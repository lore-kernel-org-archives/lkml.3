Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaE1S1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:27:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51453 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaE1S1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:27:43 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: dts: qcom: Update msm8660 device trees
Date: Wed, 28 May 2014 13:27:39 -0500
Message-Id: <1401301659-20235-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move SoC peripherals into an SoC container node
* Move serial enabling into board file (qcom-msm8660-surf.dts)
* Cleanup cpu node to match binding spec, enable-method and compatible
  should be per cpu, not part of the container

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts |   6 ++
 arch/arm/boot/dts/qcom-msm8660.dtsi     | 104 +++++++++++++++++---------------
 2 files changed, 63 insertions(+), 47 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 169bad9..13f5a78 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -3,4 +3,10 @@
 / {
 	model = "Qualcomm MSM8660 SURF";
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
+
+	soc {
+		serial@19c40000 {
+			status = "ok";
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8660.dtsi b/arch/arm/boot/dts/qcom-msm8660.dtsi
index c52a9e9..41bc38b 100644
--- a/arch/arm/boot/dts/qcom-msm8660.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8660.dtsi
@@ -12,16 +12,18 @@
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		compatible = "qcom,scorpion";
-		enable-method = "qcom,gcc-msm8660";
 
 		cpu@0 {
+			compatible = "qcom,scorpion";
+			enable-method = "qcom,gcc-msm8660";
 			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
 		};
 
 		cpu@1 {
+			compatible = "qcom,scorpion";
+			enable-method = "qcom,gcc-msm8660";
 			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
@@ -33,55 +35,63 @@
 		};
 	};
 
-	intc: interrupt-controller@2080000 {
-		compatible = "qcom,msm-8660-qgic";
-		interrupt-controller;
-		#interrupt-cells = <3>;
-		reg = < 0x02080000 0x1000 >,
-		      < 0x02081000 0x1000 >;
-	};
+	soc: soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		compatible = "simple-bus";
 
-	timer@2000000 {
-		compatible = "qcom,scss-timer", "qcom,msm-timer";
-		interrupts = <1 0 0x301>,
-			     <1 1 0x301>,
-			     <1 2 0x301>;
-		reg = <0x02000000 0x100>;
-		clock-frequency = <27000000>,
-				  <32768>;
-		cpu-offset = <0x40000>;
-	};
+		intc: interrupt-controller@2080000 {
+			compatible = "qcom,msm-8660-qgic";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = < 0x02080000 0x1000 >,
+			      < 0x02081000 0x1000 >;
+		};
 
-	msmgpio: gpio@800000 {
-		compatible = "qcom,msm-gpio";
-		reg = <0x00800000 0x4000>;
-		gpio-controller;
-		#gpio-cells = <2>;
-		ngpio = <173>;
-		interrupts = <0 16 0x4>;
-		interrupt-controller;
-		#interrupt-cells = <2>;
-	};
+		timer@2000000 {
+			compatible = "qcom,scss-timer", "qcom,msm-timer";
+			interrupts = <1 0 0x301>,
+				     <1 1 0x301>,
+				     <1 2 0x301>;
+			reg = <0x02000000 0x100>;
+			clock-frequency = <27000000>,
+					  <32768>;
+			cpu-offset = <0x40000>;
+		};
 
-	gcc: clock-controller@900000 {
-		compatible = "qcom,gcc-msm8660";
-		#clock-cells = <1>;
-		#reset-cells = <1>;
-		reg = <0x900000 0x4000>;
-	};
+		msmgpio: gpio@800000 {
+			compatible = "qcom,msm-gpio";
+			reg = <0x00800000 0x4000>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			ngpio = <173>;
+			interrupts = <0 16 0x4>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
 
-	serial@19c40000 {
-		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
-		reg = <0x19c40000 0x1000>,
-		      <0x19c00000 0x1000>;
-		interrupts = <0 195 0x0>;
-		clocks = <&gcc GSBI12_UART_CLK>, <&gcc GSBI12_H_CLK>;
-		clock-names = "core", "iface";
-	};
+		gcc: clock-controller@900000 {
+			compatible = "qcom,gcc-msm8660";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			reg = <0x900000 0x4000>;
+		};
 
-	qcom,ssbi@500000 {
-		compatible = "qcom,ssbi";
-		reg = <0x500000 0x1000>;
-		qcom,controller-type = "pmic-arbiter";
+		serial@19c40000 {
+			compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+			reg = <0x19c40000 0x1000>,
+			      <0x19c00000 0x1000>;
+			interrupts = <0 195 0x0>;
+			clocks = <&gcc GSBI12_UART_CLK>, <&gcc GSBI12_H_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
+
+		qcom,ssbi@500000 {
+			compatible = "qcom,ssbi";
+			reg = <0x500000 0x1000>;
+			qcom,controller-type = "pmic-arbiter";
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

