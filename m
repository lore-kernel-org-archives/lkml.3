Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3AYIjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:39:49 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:46392 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3AYIjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:39:44 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Brian Lilly <brian@crystalfontz.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: cfa10049: Change the SPI3 bus to spi-gpio
Date: Fri, 25 Jan 2013 09:39:35 +0100
Message-Id: <1359103175-26304-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359103175-26304-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359103175-26304-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DAC found on the last chip select requires a word length of 12 bits,
which is not supported by the SSP controller of the iMX28. Use
bitbanging for that bus to support such a length.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts |   78 ++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index 7890acc..dd91244 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -52,48 +52,17 @@
 				spi3_pins_cfa10049: spi3-cfa10049@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
-						0x0181 /* MX28_PAD_GPMI_RDN__SSP3_SCK */
-						0x01c1 /* MX28_PAD_GPMI_RESETN__SSP3_CMD */
-						0x0111 /* MX28_PAD_GPMI_CE1N__SSP3_D3 */
-						0x01a2 /* MX28_PAD_GPMI_ALE__SSP3_D4 */
-						0x01b2 /* MX28_PAD_GPMI_CLE__SSP3_D5 */
+						0x0183 /* MX28_PAD_GPMI_RDN__GPIO_0_24 */
+						0x01c3 /* MX28_PAD_GPMI_RESETN__GPIO_0_28 */
+						0x0113 /* MX28_PAD_GPMI_CE1N__GPIO_0_17 */
+						0x01a3 /* MX28_PAD_GPMI_ALE__GPIO_0_26 */
+						0x01b3 /* MX28_PAD_GPMI_CLE__GPIO_0_27 */
 					>;
 					fsl,drive-strength = <1>;
 					fsl,voltage = <1>;
 					fsl,pull-up = <1>;
 				};
 			};
-
-			ssp3: ssp@80016000 {
-				compatible = "fsl,imx28-spi";
-				pinctrl-names = "default";
-				pinctrl-0 = <&spi3_pins_cfa10049>;
-				status = "okay";
-
-				gpio5: gpio5@0 {
-					compatible = "fairchild,74hc595";
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <0>;
-					registers-number = <2>;
-					spi-max-frequency = <100000>;
-				};
-
-				gpio6: gpio6@1 {
-					compatible = "fairchild,74hc595";
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <1>;
-					registers-number = <4>;
-					spi-max-frequency = <100000>;
-				};
-
-				dac0: dh2228@2 {
-					compatible = "rohm,dh2228fv";
-					reg = <2>;
-					spi-max-frequency = <100000>;
-				};
-			};
 		};
 
 		apbx@80040000 {
@@ -177,4 +146,41 @@
 			status = "okay";
 		};
 	};
+
+	spi3 {
+		compatible = "spi-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi3_pins_cfa10049>;
+		status = "okay";
+		gpio-sck = <&gpio0 24 0>;
+		gpio-mosi = <&gpio0 28 0>;
+		cs-gpios = <&gpio0 17 0 &gpio0 26 0 &gpio0 27 0>;
+		num-chipselects = <3>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		gpio5: gpio5@0 {
+			compatible = "fairchild,74hc595";
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <0>;
+			registers-number = <2>;
+			spi-max-frequency = <100000>;
+		};
+
+		gpio6: gpio6@1 {
+			compatible = "fairchild,74hc595";
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <1>;
+			registers-number = <4>;
+			spi-max-frequency = <100000>;
+		};
+
+		dac0: dh2228@2 {
+			compatible = "rohm,dh2228fv";
+			reg = <2>;
+			spi-max-frequency = <100000>;
+		};
+	};
 };
-- 
1.7.10.4

