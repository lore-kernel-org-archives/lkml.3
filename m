Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190AbaE2Pkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:40:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44836 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaE2Pk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:40:29 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] ARM: dts: qcom: Update msm8960 device trees
Date: Thu, 29 May 2014 10:40:25 -0500
Message-Id: <1401378025-15460-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move SoC peripherals into an SoC container node
* Move serial enabling into board file (qcom-msm8960-cdp.dts)
* Cleanup cpu node to match binding spec, enable-method and compatible
  should be per cpu, not part of the container
* Drop interrupts property from l2-cache node as its not part of the
  binding spec
* Add GSBI node and configuration of GSBI controller

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v2:
* Added GSBI node

 arch/arm/boot/dts/qcom-msm8960-cdp.dts |  10 ++
 arch/arm/boot/dts/qcom-msm8960.dtsi    | 176 ++++++++++++++++++---------------
 2 files changed, 108 insertions(+), 78 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index a58fb88..8f75cc4 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -3,4 +3,14 @@
 / {
 	model = "Qualcomm MSM8960 CDP";
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
+
+	soc {
+		gsbi@16400000 {
+			status = "ok";
+			qcom,mode = <GSBI_PROT_I2C_UART>;
+			serial@16440000 {
+				status = "ok";
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 997b7b9..5303e53 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -3,6 +3,7 @@
 /include/ "skeleton.dtsi"
 
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
+#include <dt-bindings/soc/qcom,gsbi.h>
 
 / {
 	model = "Qualcomm MSM8960";
@@ -13,10 +14,10 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		interrupts = <1 14 0x304>;
-		compatible = "qcom,krait";
-		enable-method = "qcom,kpss-acc-v1";
 
 		cpu@0 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
 			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
@@ -25,6 +26,8 @@
 		};
 
 		cpu@1 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
 			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
@@ -35,7 +38,6 @@
 		L2: l2-cache {
 			compatible = "cache";
 			cache-level = <2>;
-			interrupts = <0 2 0x4>;
 		};
 	};
 
@@ -45,91 +47,109 @@
 		qcom,no-pc-write;
 	};
 
-	intc: interrupt-controller@2000000 {
-		compatible = "qcom,msm-qgic2";
-		interrupt-controller;
-		#interrupt-cells = <3>;
-		reg = < 0x02000000 0x1000 >,
-		      < 0x02002000 0x1000 >;
-	};
+	soc: soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		compatible = "simple-bus";
+
+		intc: interrupt-controller@2000000 {
+			compatible = "qcom,msm-qgic2";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0x02000000 0x1000>,
+			      <0x02002000 0x1000>;
+		};
 
-	timer@200a000 {
-		compatible = "qcom,kpss-timer", "qcom,msm-timer";
-		interrupts = <1 1 0x301>,
-			     <1 2 0x301>,
-			     <1 3 0x301>;
-		reg = <0x0200a000 0x100>;
-		clock-frequency = <27000000>,
-				  <32768>;
-		cpu-offset = <0x80000>;
-	};
+		timer@200a000 {
+			compatible = "qcom,kpss-timer", "qcom,msm-timer";
+			interrupts = <1 1 0x301>,
+				     <1 2 0x301>,
+				     <1 3 0x301>;
+			reg = <0x0200a000 0x100>;
+			clock-frequency = <27000000>,
+					  <32768>;
+			cpu-offset = <0x80000>;
+		};
 
-	msmgpio: gpio@800000 {
-		compatible = "qcom,msm-gpio";
-		gpio-controller;
-		#gpio-cells = <2>;
-		ngpio = <150>;
-		interrupts = <0 16 0x4>;
-		interrupt-controller;
-		#interrupt-cells = <2>;
-		reg = <0x800000 0x4000>;
-	};
+		msmgpio: gpio@800000 {
+			compatible = "qcom,msm-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <150>;
+			interrupts = <0 16 0x4>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x800000 0x4000>;
+		};
 
-	gcc: clock-controller@900000 {
-		compatible = "qcom,gcc-msm8960";
-		#clock-cells = <1>;
-		#reset-cells = <1>;
-		reg = <0x900000 0x4000>;
-	};
+		gcc: clock-controller@900000 {
+			compatible = "qcom,gcc-msm8960";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			reg = <0x900000 0x4000>;
+		};
 
-	clock-controller@4000000 {
-		compatible = "qcom,mmcc-msm8960";
-		reg = <0x4000000 0x1000>;
-		#clock-cells = <1>;
-		#reset-cells = <1>;
-	};
+		clock-controller@4000000 {
+			compatible = "qcom,mmcc-msm8960";
+			reg = <0x4000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
 
-	acc0: clock-controller@2088000 {
-		compatible = "qcom,kpss-acc-v1";
-		reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
-	};
+		acc0: clock-controller@2088000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
+		};
 
-	acc1: clock-controller@2098000 {
-		compatible = "qcom,kpss-acc-v1";
-		reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
-	};
+		acc1: clock-controller@2098000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
+		};
 
-	saw0: regulator@2089000 {
-		compatible = "qcom,saw2";
-		reg = <0x02089000 0x1000>, <0x02009000 0x1000>;
-		regulator;
-	};
+		saw0: regulator@2089000 {
+			compatible = "qcom,saw2";
+			reg = <0x02089000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
 
-	saw1: regulator@2099000 {
-		compatible = "qcom,saw2";
-		reg = <0x02099000 0x1000>, <0x02009000 0x1000>;
-		regulator;
-	};
+		saw1: regulator@2099000 {
+			compatible = "qcom,saw2";
+			reg = <0x02099000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
 
-	serial@16440000 {
-		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
-		reg = <0x16440000 0x1000>,
-		      <0x16400000 0x1000>;
-		interrupts = <0 154 0x0>;
-		clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
-		clock-names = "core", "iface";
-	};
+		gsbi5: gsbi@16400000 {
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x16400000 0x100>;
+			clocks = <&gcc GSBI5_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			serial@16440000 {
+				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+				reg = <0x16440000 0x1000>,
+				      <0x16400000 0x1000>;
+				interrupts = <0 154 0x0>;
+				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+			};
+		};
 
-	qcom,ssbi@500000 {
-		compatible = "qcom,ssbi";
-		reg = <0x500000 0x1000>;
-		qcom,controller-type = "pmic-arbiter";
-	};
+		qcom,ssbi@500000 {
+			compatible = "qcom,ssbi";
+			reg = <0x500000 0x1000>;
+			qcom,controller-type = "pmic-arbiter";
+		};
 
-	rng@1a500000 {
-		compatible = "qcom,prng";
-		reg = <0x1a500000 0x200>;
-		clocks = <&gcc PRNG_CLK>;
-		clock-names = "core";
+		rng@1a500000 {
+			compatible = "qcom,prng";
+			reg = <0x1a500000 0x200>;
+			clocks = <&gcc PRNG_CLK>;
+			clock-names = "core";
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

