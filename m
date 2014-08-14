Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaHNHX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:23:58 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:33116 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbaHNHX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:23:57 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] ARM: apq8064: Add pinmux and i2c pinctrl nodes
Date: Thu, 14 Aug 2014 12:50:53 +0530
Message-Id: <1408000853-2764-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pinmux and i2c pinctrl DT node for IFC6410 board.
It also adds necessary DT support for i2c eeprom which is present on
IFC6410.

Tested on IFC6410 board.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   29 ++++++++++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        |   59 ++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index 7c2441d..d52ac3c 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -5,6 +5,15 @@
 	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
 
 	soc {
+		pinmux@800000 {
+			i2c1_pins: i2c1_pinmux {
+				mux {
+					pins = "gpio20", "gpio21";
+					function = "gsbi1";
+				};
+			};
+		};
+
 		gsbi@16600000 {
 			status = "ok";
 			qcom,mode = <GSBI_PROT_I2C_UART>;
@@ -12,5 +21,25 @@
 				status = "ok";
 			};
 		};
+
+		gsbi1: gsbi@12440000 {
+			qcom,mode = <GSBI_PROT_I2C>;
+			status = "ok";
+
+			i2c1: i2c@12460000 {
+				status = "ok";
+
+				clock-frequency = <200000>;
+
+				pinctrl-0 = <&i2c1_pins>;
+				pinctrl-names = "default";
+
+				eeprom: eeprom@52 {
+					compatible = "atmel,24c128";
+					reg = <0x52>;
+					pagesize = <32>;
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 92bf793..fbebf5c 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -70,6 +70,17 @@
 		ranges;
 		compatible = "simple-bus";
 
+		qcom_pinmux: pinmux@800000 {
+			compatible = "qcom,apq8064-pinctrl";
+			reg = <0x800000 0x4000>;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <0 32 0x4>;
+		};
+
 		intc: interrupt-controller@2000000 {
 			compatible = "qcom,msm-qgic2";
 			interrupt-controller;
@@ -133,6 +144,54 @@
 			regulator;
 		};
 
+		gsbi1: gsbi@12440000 {
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12440000 0x100>;
+			clocks = <&gcc GSBI1_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			status = "disabled";
+
+			i2c@12460000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x12460000 0x1000>;
+				interrupts = <0 194 0>;
+
+				clocks = <&gcc GSBI1_QUP_CLK>, <&gcc GSBI1_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		gsbi2: gsbi@12480000 {
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12480000 0x100>;
+			clocks = <&gcc GSBI2_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			status = "disabled";
+
+			i2c@124a0000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x124a0000 0x1000>;
+				interrupts = <0 196 0>;
+
+				clocks = <&gcc GSBI2_QUP_CLK>, <&gcc GSBI2_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
 		gsbi7: gsbi@16600000 {
 			status = "disabled";
 			compatible = "qcom,gsbi-v1.0.0";
-- 
1.7.9.5

