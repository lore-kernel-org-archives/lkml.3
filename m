Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3FXRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:25:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FXRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:25:11 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
Date: Mon, 24 Jun 2013 19:24:58 +0200
Message-Id: <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

The ADCs connected to this bus have been experiencing some timeout
issues when using the iMX28 i2c controller. Switching back to bitbanging
solves this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts | 108 +++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index 05ae549..d3758c2 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -139,6 +139,17 @@
 					fsl,pull-up = <0>; /* 0 will enable the keeper */
 				};
 
+				i2c1_pins_cfa10049: i2c1@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x3103 /* MX28_PAD_PWM0__GPIO */
+						0x3113 /* MX28_PAD_PWM1__I2C1_SDA */
+					>;
+					fsl,drive-strength = <1>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
 				fiq_pins_cfa10049: fiq@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
@@ -199,49 +210,6 @@
 				status = "okay";
 			};
 
-			i2c1: i2c@8005a000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&i2c1_pins_a>;
-				status = "okay";
-			};
-
-			i2cmux {
-				compatible = "i2c-mux-gpio";
-				#address-cells = <1>;
-				#size-cells = <0>;
-				mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
-				i2c-parent = <&i2c1>;
-
-				i2c@0 {
-					reg = <0>;
-				};
-
-				i2c@1 {
-					reg = <1>;
-				};
-
-				i2c@2 {
-					reg = <2>;
-				};
-
-				i2c@3 {
-					reg = <3>;
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					pca9555: pca9555@20 {
-						compatible = "nxp,pca9555";
-						interrupt-parent = <&gpio2>;
-						interrupts = <19 0x2>;
-						gpio-controller;
-						#gpio-cells = <2>;
-						interrupt-controller;
-						#interrupt-cells = <2>;
-						reg = <0x20>;
-					};
-				};
-			};
-
 			usbphy1: usbphy@8007e000 {
 				status = "okay";
 			};
@@ -366,6 +334,60 @@
 		rotary-encoder,relative-axis;
 	};
 
+	i2c1gpio: i2c@0 {
+		compatible = "i2c-gpio";
+		pinctrl-0 = <&i2c1_pins_cfa10049>;
+		pinctrl-names = "default";
+		gpios = <
+			&gpio3 17 0 /* sda */
+			&gpio3 16 0 /* scl */
+			 >;
+		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
+	};
+
+	i2cmux {
+		compatible = "i2c-mux-gpio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
+		i2c-parent = <&i2c1gpio>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c@1 {
+			reg = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c@2 {
+			reg = <2>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c@3 {
+			reg = <3>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			pca9555: pca9555@20 {
+				compatible = "nxp,pca9555";
+				interrupt-parent = <&gpio2>;
+				interrupts = <19 0x2>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x20>;
+			};
+		};
+	};
+
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 3 5000000>;
-- 
1.8.1.2

