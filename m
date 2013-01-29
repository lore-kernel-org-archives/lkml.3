Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3A2IrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:47:25 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:41018
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab3A2IrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:47:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Gary Zhang <b13634@freescale.com>
To: <linux@arm.linux.org.uk>, <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ARM: dts: add support for wm8962 in imx6q sabresd
Date: Tue, 29 Jan 2013 15:49:15 +0800
Message-ID: <1359445755-1677-1-git-send-email-b13634@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to support for wm8962, add I2C/I2S/clk/fixed regulator and
other related supports

Signed-off-by: Gary Zhang <b13634@freescale.com>
---
 arch/arm/boot/dts/imx6q-sabresd.dts |   76 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi        |   23 ++++++++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index a424025..383fcf0 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -29,6 +29,10 @@
 					pinctrl-0 = <&pinctrl_uart1_1>;
 					status = "okay";
 				};
+				ssi2: ssi@0202c000 {
+					fsl,mode = "i2s-slave";
+					status = "okay";
+				};
 			};
 
 			iomuxc@020e0000 {
@@ -73,6 +77,33 @@
 				wp-gpios = <&gpio2 1 0>;
 				status = "okay";
 			};
+
+			audmux@021d8000 {
+				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_audmux_2>;
+			};
+
+			i2c@021a0000 { /* I2C1 */
+				status = "okay";
+				clock-frequency = <100000>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_i2c1_2>;
+
+				codec: wm8962@1a {
+					compatible = "fsl,wm8962";
+					reg = <0x1a>;
+					clocks = <&clks 169>;
+					DCVDD-supply = <&reg_1p8v>;
+					DBVDD-supply = <&reg_1p8v>;
+					AVDD-supply = <&reg_1p8v>;
+					CPVDD-supply = <&reg_1p8v>;
+					MICVDD-supply = <&reg_3p3v>;
+					PLLVDD-supply = <&reg_1p8v>;
+					SPKVDD1-supply = <&reg_4p2v>;
+					SPKVDD2-supply = <&reg_4p2v>;
+				};
+			};
 		};
 	};
 
@@ -91,4 +122,49 @@
 			linux,code = <114>; /* KEY_VOLUMEDOWN */
 		};
 	};
+	regulators {
+		compatible = "simple-bus";
+
+		reg_1p8v: 1p8v {
+			compatible = "regulator-fixed";
+			regulator-name = "1P8V";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			enable-active-high;
+		};
+		reg_3p3v: 3p3v {
+			compatible = "regulator-fixed";
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			enable-active-high;
+		};
+		reg_4p2v: 4p2v {
+			compatible = "regulator-fixed";
+			regulator-name = "4P2V";
+			regulator-min-microvolt = <4200000>;
+			regulator-max-microvolt = <4200000>;
+			gpio = <&gpio4 10 0>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+		};
+	};
+
+	sound {
+		compatible = "fsl,imx6q-sabresd-wm8962",
+			     "fsl,imx-audio-wm8962";
+		model = "imx6q-sabresd-wm8962";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_clko_1>;
+		ssi-controller = <&ssi2>;
+		audio-codec = <&codec>;
+		audio-routing =
+			"Headphone Jack", "HPOUTL",
+			"Headphone Jack", "HPOUTR";
+		mux-int-port = <2>;
+		mux-ext-port = <3>;
+	};
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index d6265ca..b612269 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -582,6 +582,23 @@
 							3    0x80000000	/* MX6Q_PAD_SD2_DAT1__AUDMUX_AUD4_TXFS */
 						>;
 					};
+
+					pinctrl_audmux_2: audmux-2 {
+						fsl,pins = <
+							1117 0x80000000	/* MX6Q_PAD_CSI0_DAT7__AUDMUX_AUD3_RXD */
+							1093 0x80000000	/* MX6Q_PAD_CSI0_DAT4__AUDMUX_AUD3_TXC */
+							1101 0x80000000	/* MX6Q_PAD_CSI0_DAT5__AUDMUX_AUD3_TXD */
+							1109 0x80000000	/* MX6Q_PAD_CSI0_DAT6__AUDMUX_AUD3_TXFS */
+						>;
+					};
+				};
+
+				clko {
+					pinctrl_clko_1: clkogrp-1 {
+						fsl,pins = <
+							953 0x130b0  /* MX6Q_PAD_GPIO_0__CCM_CLKO */
+						>;
+					};
 				};
 
 				ecspi1 {
@@ -670,6 +687,12 @@
 							196 0x4001b8b1	/* MX6Q_PAD_EIM_D28__I2C1_SDA */
 						>;
 					};
+					pinctrl_i2c1_2: i2c1grp-2 {
+						fsl,pins = <
+							1125 0x4001b8b1	/* MX6Q_PAD_CSI0_DAT8__I2C1_SDA */
+							1133 0x4001b8b1 /* MX6Q_PAD_CSI0_DAT9__I2C1_SCL */
+						>;
+					};
 				};
 
 				uart1 {
-- 
1.7.0.4


