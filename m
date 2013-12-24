Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3LXAlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:41:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47630 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab3LXAkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:40:02 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 9/9] ARM: dts: msm: Add nodes necessary for SMP boot
Date: Mon, 23 Dec 2013 16:39:53 -0800
Message-Id: <1387845593-10050-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Add the necessary nodes to support SMP on MSM8660, MSM8960, and
MSM8974/APQ8074. While we're here also add in the error
interrupts for the Krait cache error detection.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
[sboyd: Split into separate patch, add error interrupts]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts | 24 ++++++++++++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 52 +++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi     | 69 +++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 20cb9ad..c72325e 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -9,6 +9,30 @@
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,scorpion";
+		enable-method = "qcom,gcc-msm8660";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+		};
+	};
+
 	intc: interrupt-controller@2080000 {
 		compatible = "qcom,msm-8660-qgic";
 		interrupt-controller;
diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index d5b1318..bb20f94 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -9,6 +9,36 @@
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 14 0x304>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,kpss-acc-v1";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc0>;
+			qcom,saw = <&saw0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc1>;
+			qcom,saw = <&saw1>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+			interrupts = <0 2 0x4>;
+		};
+	};
+
 	intc: interrupt-controller@2000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
@@ -53,6 +83,28 @@
 		#reset-cells = <1>;
 	};
 
+	acc0: clock-controller@2088000 {
+		compatible = "qcom,kpss-acc-v1";
+		reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
+	};
+
+	acc1: clock-controller@2098000 {
+		compatible = "qcom,kpss-acc-v1";
+		reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
+	};
+
+	saw0: regulator@2089000 {
+		compatible = "qcom,saw2";
+		reg = <0x02089000 0x1000>, <0x02009000 0x1000>;
+		regulator;
+	};
+
+	saw1: regulator@2099000 {
+		compatible = "qcom,saw2";
+		reg = <0x02099000 0x1000>, <0x02009000 0x1000>;
+		regulator;
+	};
+
 	serial@16440000 {
 		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x16440000 0x1000>,
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9fa57d7..22555f6 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,49 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 9 0xf04>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,kpss-acc-v2";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc1>;
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			reg = <2>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc2>;
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			reg = <3>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc3>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+			interrupts = <0 2 0x4>;
+			qcom,saw = <&saw_l2>;
+		};
+	};
+
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <1 2 0xf08>,
@@ -91,6 +134,32 @@
 			};
 		};
 
+		saw_l2: regulator@f9012000 {
+			compatible = "qcom,saw2";
+			reg = <0xf9012000 0x1000>;
+			regulator;
+		};
+
+		acc0: clock-controller@f9088000 {
+			compatible = "qcom,kpss-acc-v2";
+			reg = <0xf9088000 0x1000>, <0xf9008000 0x1000>;
+		};
+
+		acc1: clock-controller@f9098000 {
+			compatible = "qcom,kpss-acc-v2";
+			reg = <0xf9098000 0x1000>, <0xf9008000 0x1000>;
+		};
+
+		acc2: clock-controller@f90a8000 {
+			compatible = "qcom,kpss-acc-v2";
+			reg = <0xf90a8000 0x1000>, <0xf9008000 0x1000>;
+		};
+
+		acc3: clock-controller@f90b8000 {
+			compatible = "qcom,kpss-acc-v2";
+			reg = <0xf90b8000 0x1000>, <0xf9008000 0x1000>;
+		};
+
 		restart@fc4ab000 {
 			compatible = "qcom,pshold";
 			reg = <0xfc4ab000 0x4>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

