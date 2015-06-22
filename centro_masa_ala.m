
                                %puntos generales
a=[0,.2535,.4732,.9367,2.1425,4.5989,7.0819,9.5789,14.5976,19.6357,24.6857,29.7435,34.8061,39.8711,44.9367,50,55.05780,60.10690,65.145,70.1701,75.1803,80.1747,85.1522,90.1122,95.0564,100];
b=[0,0.9316,1.1700,1.5542,2.2769,3.4037,4.3098,5.0787,6.3358,7.3110,8.0720,8.6411,9.0402,9.2783,9.3426,9.2240,8.9096,8.4286,7.7991,7.0394,6.1577,5.1633,4.0686,2.8702,1.5648,0];
c=[0,0.7465,1.0268,1.5633,2.8575,5.4011,7.9181,10.4211,15.4024,20.3642,25.3143,30.2565,35.1939,40.1289,45.0633,50.0000,54.9422,59.8931,64.8550,69.8299,74.8197,79.8253,84.8480,89.8878,94.9436,100];
d=[0,-0.5316,-0.6100,-0.6982,-0.7889,-0.8757,-0.9178,-0.9427, -0.9518, -0.9430,-0.9120,-0.8651,-0.8002,-0.7103,-0.5826,-0.4000,-0.1496,0.1394,0.4409, 0.7366,1.0023,1.2047,1.3154,1.2658,0.9632,0];
                                %corte en secciones superiores
a0=[0,.2535,.4732,.9367,2.1425,4.5989,7.0819,9.5789,14.5976,19.6357,24.6857,29.7435];
b0=[0,0.9316,1.1700,1.5542,2.2769,3.4037,4.3098,5.0787,6.3358,7.3110,8.0720,8.6411];
c0=[29.7435,34.8061,39.8711,44.9367,50,55.05780,60.10690,65.145,70.1701,75.1803,80.1747,85.1522,90.1122,95.0564,100];
d0=[8.6411,9.0402,9.2783,9.3426,9.2240,8.9096,8.4286,7.7991,7.0394,6.1577,5.1633,4.0686,2.8702,1.5648,0];
                                %corte en secciones inferiores
a1=[0,0.7465,1.0268,1.5633,2.8575,5.4011,7.9181,10.4211,15.4024,20.3642,25.3143,30.2565];
b1=[0,-0.5316,-0.6100,-0.6982,-0.7889,-0.8757,-0.9178,-0.9427, -0.9518, -0.9430,-0.9120,-0.8651];
c1=[30.2565,35.1939,40.1289,45.0633,50.0000,54.9422,59.8931,64.8550,69.8299,74.8197,79.8253,84.8480,89.8878,94.9436,100];
d1=[-0.8651,-0.8002,-0.7103,-0.5826,-0.4000,-0.1496,0.1394,0.4409, 0.7366,1.0023,1.2047,1.3154,1.2658,0.9632,0];

                                %cambio de escala
A=a.*(1/100);
B=b.*(1/100);
C=c.*(1/100);
D=d.*(1/100);
A=A.*20;
B=B.*20;
C=C.*20;
D=D.*20;
A0=a0.*(1/100);
B0=b0.*(1/100);
C0=c0.*(1/100);
D0=d0.*(1/100);
A0=A0.*20;
B0=B0.*20;
C0=C0.*20;
D0=D0.*20;
A1=a1.*(1/100);
B1=b1.*(1/100);
C1=c1.*(1/100);
D1=d1.*(1/100);
A1=A1.*20;
B1=B1.*20;
C1=C1.*20;
D1=D1.*20;

## ---------------
## variables personalizadas

min_a = min(A);
max_a = max(A);

min_c = min(C);
max_c = max(C);

min_ac = min([min_a, min_c]);
max_ac = max([max_a, max_c]);
## ---------------

pp_spline_superior = splinefit(A, B, length(A) + 1);
pp_spline_inferior = splinefit(C, D, length(A) + 1);

interpolated_y_sup = ppval(pp_spline_superior, A);
interpolated_y_inf = ppval(pp_spline_inferior, C);

figure(1);
hold on;
plot(A, B, '*m');
plot(A, interpolated_y_sup, '-.b');
plot(C, D, '*m');
plot(C, interpolated_y_inf, '-.b');
hold off;

## factor de rotación y escalamiento
indx_test = [1:16];
theta = (25/15)*(indx_test - 1)*2*pi/360;
r = (307 - 7*indx_test) / 300;

function val = theta(param)
  val = (25/15)*(param - 1)*2*pi/360;
endfunction

## Transformación de coordenadas

## Parámetros de la superficie, parte superior
[PAR_1, PAR_2] = meshgrid(linspace(min_ac, max_ac, 100), linspace(1, 16, 100));

A = ppval(pp_spline_superior, PAR_1);
B = PAR_1;
X_arriba = A .* cos(theta(PAR_2)) + B .* sin(theta(PAR_2)) + (PAR_1 - 1)/30;
Y_arriba = (35 / 15) * (theta(PAR_2) - 1);
Z_arriba = - A .* sin(theta(PAR_2)) + B .* cos(theta(PAR_2)) + (PAR_1 - 1)*0.41413;

## Parámetros de la superficie, parte inferior
[PAR_1, PAR_2] = meshgrid(linspace(min_ac, max_ac, 100), linspace(1, 16, 100));

A = ppval(pp_spline_inferior, PAR_1);
B = PAR_1;
X_abajo = A .* cos(theta(PAR_2)) + B .* sin(theta(PAR_2)) + (PAR_1 - 1)/30;
Y_abajo = (35 / 15) * (theta(PAR_2) - 1);
Z_abajo = - A .* sin(theta(PAR_2)) + B .* cos(theta(PAR_2)) + (PAR_1 - 1)*0.41413;

## hold on;

## figure(2);
## mesh(X_arriba, Y_arriba, Z_arriba);
## ## shading flat;

## mesh(X_abajo, Y_abajo, Z_abajo);
## ## shading flat;

## hold off;

## xlabel('X');
## ylabel('Y');
## zlabel('Z');

##############################################
## Parametrización personal (Superficie 3D) ##
##############################################

## Inicialización de parámetros

longitud_ala = 35;
[PAR_1, PAR_2] = meshgrid(linspace(min_ac, max_ac, 100),
                          linspace(0., longitud_ala, 100));

## Escalamiento con forme se acerca al máximo del segundo parámetro

SCALE = 1 - PAR_2 / (longitud_ala * 3);

Z_up = SCALE .* ppval(pp_spline_superior, PAR_1);
Y_up = SCALE .* PAR_1;
X_up = PAR_2;

Z_down = SCALE .* ppval(pp_spline_inferior, PAR_1);
Y_down = SCALE .* PAR_1;
X_down = PAR_2;

figure(3);
axis("equal")
hold on;
mesh_up = mesh(X_up, Y_up, Z_up);
## set(mesh_up, 'FaceColor', [0, 1, 0], 'FaceAlpha', 0.5);
## set(mesh_up, 'FaceColor', [0, 1, 0], 'FaceAlpha', 0.5);
mesh_down = mesh(X_down, Y_down, Z_down);
## set(mesh_down, 'FaceColor', [1, 0, 0], 'FaceAlpha', 0.5);
## set(mesh_down, 'FaceColor', [1, 0, 0], 'FaceAlpha', 0.5);


xlabel('X');
ylabel('Y');
zlabel('Z');

#######################################
## Función de cambio de coordenadas: ##
#######################################
## Para poder describir el volumen en 3D, estoy utilizando la
## siguiente parametrización:

## [x, y, z] = [ (1 - p_2 / (longitud_ala * 3) ) * (spl_inf(p_1) + (spl_sup(p_1) - spl_inf(p_1)) * p_3 ) ,
##               (1 - p_2 / (longitud_ala * 3) ) * p_1,
##               p_2 ]

## min_ac <= p_1 <= max_ac
## 0 <= p_2 <= longitud_ala
## 0 <= p_1 <= 1

## Según mis cálculos, y las corroboraciones en máxima, el jacobiano
## de la transformación es:
## - (1 - p_2 / (3*la))^2 * (sp_sup - sp_inf),
## sólo se ocupa su valor absoluto

J = @(p_1, p_2, p_3) ((1 - p_2 / (3*longitud_ala)).^2 .* (ppval(pp_spline_superior, p_1) - ppval(pp_spline_inferior, p_1)));
x = @(p_1, p_2, p_3) p_2;
y = @(p_1, p_2, p_3) ((1 - p_2 / (3*longitud_ala)) .* p_1);
z = @(p_1, p_2, p_3) ((1 - p_2 / (3*longitud_ala)) .*(
			ppval(pp_spline_inferior, p_1)
                        + (ppval(pp_spline_superior, p_1) - ppval(pp_spline_inferior, p_1)) .* p_3) );

vol = triplequad(J, min_ac, max_ac, 0, longitud_ala, 0, 1);
x_momento = triplequad(@(p_1, p_2, p_3) x(p_1, p_2, p_3) .* J(p_1, p_2, p_3), min_ac, max_ac, 0, longitud_ala, 0, 1);
y_momento = triplequad(@(p_1, p_2, p_3) y(p_1, p_2, p_3) .* J(p_1, p_2, p_3), min_ac, max_ac, 0, longitud_ala, 0, 1);
z_momento = triplequad(@(p_1, p_2, p_3) z(p_1, p_2, p_3) .* J(p_1, p_2, p_3), min_ac, max_ac, 0, longitud_ala, 0, 1);

x_bar = x_momento / vol;
y_bar = y_momento / vol;
z_bar = z_momento / vol;

## Después de unos minutos, me sale que (redondeado) :
## vol = 642.75
## x_bar =  15.197
## y_bar =  7.3635
## z_bar =  0.62786

plot3(x_bar, y_bar, z_bar, "*", "markersize", 35);
hold off;
