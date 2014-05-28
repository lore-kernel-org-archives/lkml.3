Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaE1S0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:26:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51275 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaE1S0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:26:18 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3] ARM: qcom: Add initial APQ8064 SoC and IFC6410 board device trees
Date: Wed, 28 May 2014 13:26:14 -0500
Message-Id: <1401301574-20102-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic APQ8064 SoC include device tree and support for basic booting on
the IFC6410 board.  Also, keep dtb build list and qcom_dt_match in sorted
order.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v3:
* Cleanup cpu node to have compatible & enable-method per node and
  not in the container
* Dropped l2-cache interrupt prop as its not part of any binding
* Cleanup reg whitespace

v2:
* created a v2.0 apq8064.dtsi to handle differences in Si rev in future
* changed /include/ to #include
* added PMU node
* dropped interrupts from cpus node, not currently part of binding

 arch/arm/boot/dts/Makefile                 |   8 +-
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |  16 +++
 arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi   |   1 +
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 170 +++++++++++++++++++++++++++++
 arch/arm/mach-qcom/board.c                 |   3 +-
 5 files changed, 194 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-apq8064.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 35c146f..c58624f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -291,9 +291,11 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	dra7-evm.dtb
 dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
-dtb-$(CONFIG_ARCH_QCOM) += qcom-msm8660-surf.dtb \
-	qcom-msm8960-cdp.dtb \
-	qcom-apq8074-dragonboard.dtb
+dtb-$(CONFIG_ARCH_QCOM) += \
+	qcom-apq8064-ifc6410.dtb \
+	qcom-apq8074-dragonboard.dtb \
+	qcom-msm8660-surf.dtb \
+	qcom-msm8960-cdp.dtb
 dtb-$(CONFIG_ARCH_U8500) += ste-snowball.dtb \
 	ste-hrefprev60-stuib.dtb \
 	ste-hrefprev60-tvk.dtb \
diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
new file mode 100644
index 0000000..7c2441d
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -0,0 +1,16 @@
+#include "qcom-apq8064-v2.0.dtsi"
+
+/ {
+	model = "Qualcomm APQ8064/IFC6410";
+	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
+
+	soc {
+		gsbi@16600000 {
+			status = "ok";
+			qcom,mode = <GSBI_PROT_I2C_UART>;
+			serial@16640000 {
+				status = "ok";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi b/arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi
new file mode 100644
index 0000000..935c394
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi
@@ -0,0 +1 @@
+#include "qcom-apq8064.dtsi"
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
new file mode 100644
index 0000000..e8a3423
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -0,0 +1,170 @@
+/dts-v1/;
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/qcom,gcc-msm8960.h>
+#include <dt-bindings/soc/qcom,gsbi.h>
+
+/ {
+	model = "Qualcomm APQ8064";
+	compatible = "qcom,apq8064";
+	interrupt-parent = <&intc>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc0>;
+			qcom,saw = <&saw0>;
+		};
+
+		cpu@1 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc1>;
+			qcom,saw = <&saw1>;
+		};
+
+		cpu@2 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
+			device_type = "cpu";
+			reg = <2>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc2>;
+			qcom,saw = <&saw2>;
+		};
+
+		cpu@3 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v1";
+			device_type = "cpu";
+			reg = <3>;
+			next-level-cache = <&L2>;
+			qcom,acc = <&acc3>;
+			qcom,saw = <&saw3>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+		};
+	};
+
+	cpu-pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <1 10 0x304>;
+	};
+
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
+
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
+
+		acc0: clock-controller@2088000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
+		};
+
+		acc1: clock-controller@2098000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
+		};
+
+		acc2: clock-controller@20a8000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x020a8000 0x1000>, <0x02008000 0x1000>;
+		};
+
+		acc3: clock-controller@20b8000 {
+			compatible = "qcom,kpss-acc-v1";
+			reg = <0x020b8000 0x1000>, <0x02008000 0x1000>;
+		};
+
+		saw0: regulator@2089000 {
+			compatible = "qcom,saw2";
+			reg = <0x02089000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
+
+		saw1: regulator@2099000 {
+			compatible = "qcom,saw2";
+			reg = <0x02099000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
+
+		saw2: regulator@20a9000 {
+			compatible = "qcom,saw2";
+			reg = <0x020a9000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
+
+		saw3: regulator@20b9000 {
+			compatible = "qcom,saw2";
+			reg = <0x020b9000 0x1000>, <0x02009000 0x1000>;
+			regulator;
+		};
+
+		gsbi7: gsbi@16600000 {
+			status = "disabled";
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x16300000 0x100>;
+			clocks = <&gcc GSBI7_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			serial@16640000 {
+				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+				reg = <0x16640000 0x1000>,
+				      <0x16600000 0x1000>;
+				interrupts = <0 158 0x0>;
+				clocks = <&gcc GSBI7_UART_CLK>, <&gcc GSBI7_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+			};
+		};
+
+		qcom,ssbi@500000 {
+			compatible = "qcom,ssbi";
+			reg = <0x00500000 0x1000>;
+			qcom,controller-type = "pmic-arbiter";
+		};
+
+		gcc: clock-controller@900000 {
+			compatible = "qcom,gcc-apq8064";
+			reg = <0x00900000 0x4000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+	};
+};
diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
index bae617e..350fa8d 100644
--- a/arch/arm/mach-qcom/board.c
+++ b/arch/arm/mach-qcom/board.c
@@ -15,9 +15,10 @@
 #include <asm/mach/arch.h>
 
 static const char * const qcom_dt_match[] __initconst = {
+	"qcom,apq8064",
+	"qcom,apq8074-dragonboard",
 	"qcom,msm8660-surf",
 	"qcom,msm8960-cdp",
-	"qcom,apq8074-dragonboard",
 	NULL
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

