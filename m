Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbaHZLd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:33:28 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:47799 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbaHZLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:33:26 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        davidb@codeaurora.org, afaerber@suse.de
Cc: devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH v3] ARM: apq8064: Add pinmux and i2c pinctrl nodes
Date: Tue, 26 Aug 2014 17:00:45 +0530
Message-Id: <1409052645-14984-1-git-send-email-kiran.padwal@smartplayin.com>
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
Changes since v2:
 - Renamed pinmux i2c subnode "i2c1_pinmux" to "i2c1".
 - Removed labes of node.
 - Used canonical value as "okay" instead of "ok".
 - Used macros.

Changes since v1:
 - Renamed pinmux phandle "qcom_pinmux" to "tlmm_pinmux".
 - Updated pinmux interrupt.

 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   27 ++++++++++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        |   53 ++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index 7c2441d..ef0857e 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -5,6 +5,24 @@
 	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
 
 	soc {
+		gsbi@12440000 {
+			status = "okay";
+			qcom,mode = <GSBI_PROT_I2C>;
+
+			i2c@12460000 {
+				status = "okay";
+				clock-frequency = <200000>;
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
+
 		gsbi@16600000 {
 			status = "ok";
 			qcom,mode = <GSBI_PROT_I2C_UART>;
@@ -12,5 +30,14 @@
 				status = "ok";
 			};
 		};
+
+		pinmux@800000 {
+			i2c1_pins: i2c1 {
+				mux {
+					pins = "gpio20", "gpio21";
+					function = "gsbi1";
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 92bf793..5dddbf3 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -89,6 +89,17 @@
 			cpu-offset = <0x80000>;
 		};
 
+		tlmm_pinmux: pinmux@800000 {
+			compatible = "qcom,apq8064-pinctrl";
+			reg = <0x800000 0x4000>;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <0 16 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		acc0: clock-controller@2088000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
@@ -133,6 +144,48 @@
 			regulator;
 		};
 
+		gsbi1: gsbi@12440000 {
+			status = "disabled";
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12440000 0x100>;
+			clocks = <&gcc GSBI1_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			i2c1: i2c@12460000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x12460000 0x1000>;
+				interrupts = <0 194 IRQ_TYPE_NONE>;
+				clocks = <&gcc GSBI1_QUP_CLK>, <&gcc GSBI1_H_CLK>;
+				clock-names = "core", "iface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		gsbi2: gsbi@12480000 {
+			status = "disabled";
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12480000 0x100>;
+			clocks = <&gcc GSBI2_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			i2c2: i2c@124a0000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x124a0000 0x1000>;
+				interrupts = <0 196 IRQ_TYPE_NONE>;
+				clocks = <&gcc GSBI2_QUP_CLK>, <&gcc GSBI2_H_CLK>;
+				clock-names = "core", "iface";
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

