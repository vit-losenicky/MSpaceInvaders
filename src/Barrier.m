classdef Barrier < GameObject
    properties
        ImageData  % Additional property to store the image data
    end
    
    methods
        % Constructor
        function obj = Barrier(name, x, y, width, height, UIfigure)
            obj@GameObject(name, x, y, width, height, UIfigure);
            
            % Read and store the image data
            obj.ImageData = imread(name);
            obj.ImageObject.ImageSource = name;  
        end
        

        %PROBLEM FUNCTION 
        %TODO: fix it :]
        %PROBLEM: function can't recongnize if the image is black
        % and thanks to this doesn't delete the picture, when it takes 
        % enough hits. 
        %QUICK FIX: init a taken hits variable and delete the barrier 
        %if enoguh hits are taken. CONS: isn't that cool 
        function hitByBullet(obj)
            % Find indices of non-black pixels
            [rows, cols, ~] = find(any(obj.ImageData ~= 0, 3));
            nonBlackPixelIndices = sub2ind(size(obj.ImageData, [1, 2]), rows, cols);
        
            % Determine the number of pixels to change
            numPixelsToChange = round(length(nonBlackPixelIndices) / 6);  % 1/6 of the non-black pixels
            
            if numPixelsToChange > 0
                % Randomly select pixels to turn black
                permIndices = randperm(length(nonBlackPixelIndices), numPixelsToChange);
                pixelsToBlacken = nonBlackPixelIndices(permIndices);
        
                % Change selected pixels to black
                for i = 1:length(pixelsToBlacken)
                    % Convert linear index back to subscript indices
                    [row, col] = ind2sub(size(obj.ImageData, [1, 2]), pixelsToBlacken(i));
                    
                    obj.ImageData(row, col, :) = 0;
                end
        
                obj.ImageObject.ImageSource = obj.ImageData;       
            
                % Check if the entire image is black and delete if so
                if all(obj.ImageData(:) == 0)
                    delete(obj.ImageObject);
                end
                
            end
        end
    end
end

