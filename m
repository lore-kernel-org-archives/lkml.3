Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaHFSii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:38:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaHFSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:38:35 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: qcom: Add initial IPQ8064 SoC and AP148 device trees
Date: Wed,  6 Aug 2014 13:38:32 -0500
Message-Id: <1407350312-17040-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic IPQ8064 SoC include device tree and support for basic booting on
the AP148 Reference board with support for UART, I2C, and SPI.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/Makefile               |   1 +
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts |  85 +++++++++++
 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi |   1 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi      | 250 +++++++++++++++++++++++++++++++
 arch/arm/mach-qcom/board.c               |   2 +
 5 files changed, 339 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-ap148.dts
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index adb5ed9..6e4b702 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -316,6 +316,7 @@ dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8064-ifc6410.dtb \
 	qcom-apq8074-dragonboard.dtb \
 	qcom-apq8084-mtp.dtb \
+	qcom-ipq8064-ap148.dtb \
 	qcom-msm8660-surf.dtb \
 	qcom-msm8960-cdp.dtb
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
diff --git a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
new file mode 100644
index 0000000..95e6495
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
@@ -0,0 +1,85 @@
+#include "qcom-ipq8064-v1.0.dtsi"
+
+/ {
+	model = "Qualcomm IPQ8064/AP148";
+	compatible = "qcom,ipq8064-ap148", "qcom,ipq8064";
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		rsvd@41200000 {
+			reg = <0x41200000 0x300000>;
+			no-map;
+		};
+	};
+
+	soc {
+		pinmux@800000 {
+			i2c4_pins: i2c4_pinmux {
+				pins = "gpio12", "gpio13";
+				function = "gsbi4";
+				bias-disable;
+			};
+
+			spi_pins: spi_pins {
+				mux {
+					pins = "gpio18", "gpio19", "gpio21";
+					function = "gsbi5";
+					drive-strength = <10>;
+					bias-none;
+				};
+			};
+		};
+
+		gsbi@16300000 {
+			qcom,mode = <GSBI_PROT_I2C_UART>;
+			status = "ok";
+			serial@16340000 {
+				status = "ok";
+			};
+
+			i2c4: i2c@16380000 {
+				status = "ok";
+
+				clock-frequency = <200000>;
+
+				pinctrl-0 = <&i2c4_pins>;
+				pinctrl-names = "default";
+			};
+		};
+
+		gsbi5: gsbi@1a200000 {
+			qcom,mode = <GSBI_PROT_SPI>;
+			status = "ok";
+
+			spi4: spi@1a280000 {
+				status = "ok";
+				spi-max-frequency = <50000000>;
+
+				pinctrl-0 = <&spi_pins>;
+				pinctrl-names = "default";
+
+				cs-gpios = <&qcom_pinmux 20 0>;
+
+				flash: m25p80@0 {
+					compatible = "s25fl256s1";
+					#address-cells = <1>;
+					#size-cells = <1>;
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+
+					partition@0 {
+						label = "rootfs";
+						reg = <0x0 0x1000000>;
+					};
+
+					partition@1 {
+						label = "scratch";
+						reg = <0x1000000 0x1000000>;
+					};
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi b/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
new file mode 100644
index 0000000..7093b07
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
@@ -0,0 +1 @@
+#include "qcom-ipq8064.dtsi"
diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
new file mode 100644
index 0000000..244f857
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -0,0 +1,250 @@
+/dts-v1/;
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/qcom,gcc-ipq806x.h>
+#include <dt-bindings/soc/qcom,gsbi.h>
+
+/ {
+	model = "Qualcomm IPQ8064";
+	compatible = "qcom,ipq8064";
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
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		nss@40000000 {
+			reg = <0x40000000 0x1000000>;
+			no-map;
+		};
+
+		smem@41000000 {
+			reg = <0x41000000 0x200000>;
+			no-map;
+		};
+	};
+
+	soc: soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		compatible = "simple-bus";
+
+		qcom_pinmux: pinmux@800000 {
+			compatible = "qcom,ipq8064-pinctrl";
+			reg = <0x800000 0x4000>;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <0 32 0x4>;
+		};
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
+			clock-frequency = <25000000>,
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
+			serial@12490000 {
+				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+				reg = <0x12490000 0x1000>,
+				      <0x12480000 0x1000>;
+				interrupts = <0 195 0x0>;
+				clocks = <&gcc GSBI2_UART_CLK>, <&gcc GSBI2_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+			};
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
+
+		};
+
+		gsbi4: gsbi@16300000 {
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x16300000 0x100>;
+			clocks = <&gcc GSBI4_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			status = "disabled";
+
+			serial@16340000 {
+				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+				reg = <0x16340000 0x1000>,
+				      <0x16300000 0x1000>;
+				interrupts = <0 152 0x0>;
+				clocks = <&gcc GSBI4_UART_CLK>, <&gcc GSBI4_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+			};
+
+			i2c@16380000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x16380000 0x1000>;
+				interrupts = <0 153 0>;
+
+				clocks = <&gcc GSBI4_QUP_CLK>, <&gcc GSBI4_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		gsbi5: gsbi@1a200000 {
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x1a200000 0x100>;
+			clocks = <&gcc GSBI5_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			status = "disabled";
+
+			serial@1a240000 {
+				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+				reg = <0x1a240000 0x1000>,
+				      <0x1a200000 0x1000>;
+				interrupts = <0 154 0x0>;
+				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+			};
+
+			i2c@1a280000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x1a280000 0x1000>;
+				interrupts = <0 155 0>;
+
+				clocks = <&gcc GSBI5_QUP_CLK>, <&gcc GSBI5_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			spi@1a280000 {
+				compatible = "qcom,spi-qup-v1.1.1";
+				reg = <0x1a280000 0x1000>;
+				interrupts = <0 155 0>;
+
+				clocks = <&gcc GSBI5_QUP_CLK>, <&gcc GSBI5_H_CLK>;
+				clock-names = "core", "iface";
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
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
+			compatible = "qcom,gcc-ipq8064";
+			reg = <0x00900000 0x4000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+	};
+};
diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
index c437a99..6d8bbf7 100644
--- a/arch/arm/mach-qcom/board.c
+++ b/arch/arm/mach-qcom/board.c
@@ -18,6 +18,8 @@ static const char * const qcom_dt_match[] __initconst = {
 	"qcom,apq8064",
 	"qcom,apq8074-dragonboard",
 	"qcom,apq8084",
+	"qcom,ipq8062",
+	"qcom,ipq8064",
 	"qcom,msm8660-surf",
 	"qcom,msm8960-cdp",
 	NULL
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

