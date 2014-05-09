Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaEISzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:55:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50421 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbaEISzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:55:39 -0400
From: srinivas.kandagatla@linaro.org
To: Kumar Gala <galak@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] ARM: DT: apq8064: Add sdcc support via mcci driver.
Date: Fri,  9 May 2014 11:54:56 -0700
Message-Id: <1399661696-11766-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds support to SD card controller using generic pl180 mmci driver.
This patch also adds temporary fixed regulator to get it going till the actual
regulator is mainlined.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 16 ++++++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 50 ++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index c5fda40..ea386bd 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -4,9 +4,25 @@
 	model = "Qualcomm APQ8064/IFC6410";
 	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
 
+	aliases {
+		sdcc1 = &sdcc1;
+		sdcc3 = &sdcc3;
+	};
+
 	soc {
 		serial@16640000 {
 			status = "ok";
 		};
+		amba {
+			/* eMMC */
+			sdcc1: sdcc@12400000 {
+				status = "okay";
+			};
+
+			/* External micro SD card */
+			sdcc3: sdcc@12180000 {
+				status = "okay";
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 60b89e5..640fb1d 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -2,6 +2,7 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 
 / {
@@ -147,5 +148,54 @@
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 		};
+
+		/* Temporary fixed regulator */
+		vsdcc_fixed: vsdcc-regulator {
+			compatible = "regulator-fixed";
+			regulator-name = "SDCC Power";
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+			regulator-always-on;
+		};
+
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			sdcc1: sdcc@12400000 {
+				status		= "disabled";
+				compatible	= "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x00051180>;
+				reg		= <0x12400000 0x8000>;
+				interrupts	= <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names	= "cmd_irq";
+				clocks		= <&gcc SDC1_CLK>, <&gcc SDC1_H_CLK>;
+				clock-names	= "mclk", "apb_pclk";
+				bus-width	= <8>;
+				max-frequency	= <96000000>;
+				non-removable;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				vmmc-supply = <&vsdcc_fixed>;
+			};
+
+			sdcc3: sdcc@12180000 {
+				compatible	= "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x00051180>;
+				status		= "disabled";
+				reg		= <0x12180000 0x8000>;
+				interrupts	= <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names	= "cmd_irq";
+				clocks		= <&gcc SDC3_CLK>, <&gcc SDC3_H_CLK>;
+				clock-names	= "mclk", "apb_pclk";
+				bus-width	= <4>;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				max-frequency	= <192000000>;
+				no-1-8-v;
+				vmmc-supply = <&vsdcc_fixed>;
+			};
+		};
 	};
 };
-- 
1.9.1

