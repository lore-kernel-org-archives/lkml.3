Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaJVQaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:30:12 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43385 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaJVQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:29:36 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, arnd@arndb.de
Cc: b35083@freescale.com, bpringlemeir@nbsps.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 3/4] ARM: dts: vf610: create generic base device trees
Date: Wed, 22 Oct 2014 18:27:56 +0200
Message-Id: <1413995277-2844-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413995277-2844-1-git-send-email-stefan@agner.ch>
References: <1413995277-2844-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds more generic base device trees for Vybrid SoCs. There
are three series of Vybrid SoC commonly available:
- VF3xx series: single core, Cortex-A5 without external memory
- VF5xx series: single core, Cortex-A5
- VF6xx series: dual core, Cortex-A5/Cortex-M4

The second digit represents the presents of a L2 cache (VFx1x).

The VF3xx series are not suitable for Linux especially since the
internal memory is quite small (1.5MiB).

The VF500 is essentially the base SoC, with only one core and
without L1 cache. The VF610 is a superset of the VF500, hence
vf500.dtsi is then included and enhanced by vf610.dtsi. There is
no board using VF510 or VF600 currently, but, if needed, they can
be added easily.

The Linux kernel can also run on the Cortex-M4 CPU of Vybrid
using !MMU support. This patchset creates a device tree structure
which allows to share peripherals nodes for a VF6xx Cortex-M4
device tree too. The two CPU types have different views of the
system: Foremost they are using different interrupt controllers,
but also the memory map is slightly different. The base device
tree vfxxx.dtsi allows to create SoC and board level device trees
supporting the Cortex-M4 while reusing the shared peripherals
nodes.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi         | 171 ++++++++++++
 arch/arm/boot/dts/vf610-colibri.dtsi |  12 +
 arch/arm/boot/dts/vf610-twr.dts      |  12 +
 arch/arm/boot/dts/vf610.dtsi         | 504 +----------------------------------
 arch/arm/boot/dts/vfxxx.dtsi         | 436 ++++++++++++++++++++++++++++++
 5 files changed, 643 insertions(+), 492 deletions(-)
 create mode 100644 arch/arm/boot/dts/vf500.dtsi
 create mode 100644 arch/arm/boot/dts/vfxxx.dtsi

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
new file mode 100644
index 0000000..de67005
--- /dev/null
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -0,0 +1,171 @@
+/*
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "skeleton.dtsi"
+#include "vfxxx.dtsi"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+/ {
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		a5_cpu: cpu@0 {
+			compatible = "arm,cortex-a5";
+			device_type = "cpu";
+			reg = <0x0>;
+		};
+	};
+
+	soc {
+		interrupt-parent = <&intc>;
+
+		aips-bus@40000000 {
+
+			intc: interrupt-controller@40002000 {
+				compatible = "arm,cortex-a9-gic";
+				#interrupt-cells = <3>;
+				interrupt-controller;
+				reg = <0x40003000 0x1000>,
+				      <0x40002100 0x100>;
+			};
+
+			global_timer: timer@40002200 {
+				compatible = "arm,cortex-a9-global-timer";
+				reg = <0x40002200 0x20>;
+				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
+			};
+		};
+	};
+};
+
+&adc0 {
+	interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&adc1 {
+	interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&can0 {
+	interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&can1 {
+	interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&dspi0 {
+	interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&edma0 {
+	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "edma-tx", "edma-err";
+};
+
+&edma1 {
+	interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "edma-tx", "edma-err";
+};
+
+&esdhc1 {
+	interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&fec0 {
+	interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&fec1 {
+	interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&ftm {
+	interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&gpio1 {
+	interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&gpio2 {
+	interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&gpio3 {
+	interrupts = <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&gpio4 {
+	interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&gpio5 {
+	interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c0 {
+	interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&pit {
+	interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&qspi0 {
+	interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&sai2 {
+	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart0 {
+	interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart1 {
+	interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart2 {
+	interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart3 {
+	interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart4 {
+	interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&uart5 {
+	interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usbdev0 {
+	interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usbh1 {
+	interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usbphy0 {
+	interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usbphy1 {
+	interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+};
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index eded7be..2bcee5a 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -40,6 +40,10 @@
 	status = "okay";
 };
 
+&edma0 {
+	status = "okay";
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
@@ -92,6 +96,14 @@
 	status = "okay";
 };
 
+&usbphy0 {
+	status = "okay";
+};
+
+&usbphy1 {
+	status = "okay";
+};
+
 &iomuxc {
 	vf610-colibri {
 		pinctrl_esdhc1: esdhc1grp {
diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 7d06d1a..ebc906b 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -115,6 +115,10 @@
 	};
 };
 
+&edma0 {
+	status = "okay";
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
@@ -288,3 +292,11 @@
 	disable-over-current;
 	status = "okay";
 };
+
+&usbphy0 {
+	status = "okay";
+};
+
+&usbphy1 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index ed12d9a..5f8eb1b 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -7,499 +7,19 @@
  * (at your option) any later version.
  */
 
-#include "skeleton.dtsi"
-#include "vf610-pinfunc.h"
-#include <dt-bindings/clock/vf610-clock.h>
-#include <dt-bindings/interrupt-controller/irq.h>
-#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include "vf500.dtsi"
 
-/ {
-	aliases {
-		can0 = &can0;
-		can1 = &can1;
-		serial0 = &uart0;
-		serial1 = &uart1;
-		serial2 = &uart2;
-		serial3 = &uart3;
-		serial4 = &uart4;
-		serial5 = &uart5;
-		gpio0 = &gpio1;
-		gpio1 = &gpio2;
-		gpio2 = &gpio3;
-		gpio3 = &gpio4;
-		gpio4 = &gpio5;
-		usbphy0 = &usbphy0;
-		usbphy1 = &usbphy1;
-	};
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		cpu@0 {
-			compatible = "arm,cortex-a5";
-			device_type = "cpu";
-			reg = <0x0>;
-			next-level-cache = <&L2>;
-		};
-	};
-
-	fxosc: fxosc {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <24000000>;
-	};
-
-	sxosc: sxosc {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <32768>;
-	};
-
-	soc {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "simple-bus";
-		interrupt-parent = <&intc>;
-		ranges;
-
-		aips0: aips-bus@40000000 {
-			compatible = "fsl,aips-bus", "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			interrupt-parent = <&intc>;
-			reg = <0x40000000 0x70000>;
-			ranges;
-
-			intc: interrupt-controller@40002000 {
-				compatible = "arm,cortex-a9-gic";
-				#interrupt-cells = <3>;
-				interrupt-controller;
-				reg = <0x40003000 0x1000>,
-				      <0x40002100 0x100>;
-			};
-
-			global_timer: timer@40002200 {
-				compatible = "arm,cortex-a9-global-timer";
-				reg = <0x40002200 0x20>;
-				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
-			};
-
-			L2: l2-cache@40006000 {
-				compatible = "arm,pl310-cache";
-				reg = <0x40006000 0x1000>;
-				cache-unified;
-				cache-level = <2>;
-				arm,data-latency = <1 1 1>;
-				arm,tag-latency = <2 2 2>;
-			};
-
-			edma0: dma-controller@40018000 {
-				#dma-cells = <2>;
-				compatible = "fsl,vf610-edma";
-				reg = <0x40018000 0x2000>,
-					<0x40024000 0x1000>,
-					<0x40025000 0x1000>;
-				interrupts = <0 8 IRQ_TYPE_LEVEL_HIGH>,
-						<0 9 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-names = "edma-tx", "edma-err";
-				dma-channels = <32>;
-				clock-names = "dmamux0", "dmamux1";
-				clocks = <&clks VF610_CLK_DMAMUX0>,
-					<&clks VF610_CLK_DMAMUX1>;
-			};
-
-			can0: flexcan@40020000 {
-				compatible = "fsl,vf610-flexcan";
-				reg = <0x40020000 0x4000>;
-				interrupts = <0 58 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_FLEXCAN0>,
-					 <&clks VF610_CLK_FLEXCAN0>;
-				clock-names = "ipg", "per";
-				status = "disabled";
-			};
-
-			uart0: serial@40027000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x40027000 0x1000>;
-				interrupts = <0 61 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART0>;
-				clock-names = "ipg";
-				dmas = <&edma0 0 2>,
-					<&edma0 0 3>;
-				dma-names = "rx","tx";
-				status = "disabled";
-			};
-
-			uart1: serial@40028000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x40028000 0x1000>;
-				interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART1>;
-				clock-names = "ipg";
-				dmas = <&edma0 0 4>,
-					<&edma0 0 5>;
-				dma-names = "rx","tx";
-				status = "disabled";
-			};
-
-			uart2: serial@40029000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x40029000 0x1000>;
-				interrupts = <0 63 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART2>;
-				clock-names = "ipg";
-				dmas = <&edma0 0 6>,
-					<&edma0 0 7>;
-				dma-names = "rx","tx";
-				status = "disabled";
-			};
-
-			uart3: serial@4002a000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x4002a000 0x1000>;
-				interrupts = <0 64 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART3>;
-				clock-names = "ipg";
-				dmas = <&edma0 0 8>,
-					<&edma0 0 9>;
-				dma-names = "rx","tx";
-				status = "disabled";
-			};
-
-			dspi0: dspi0@4002c000 {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				compatible = "fsl,vf610-dspi";
-				reg = <0x4002c000 0x1000>;
-				interrupts = <0 67 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_DSPI0>;
-				clock-names = "dspi";
-				spi-num-chipselects = <5>;
-				status = "disabled";
-			};
-
-			sai2: sai@40031000 {
-				compatible = "fsl,vf610-sai";
-				reg = <0x40031000 0x1000>;
-				interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_SAI2>;
-				clock-names = "sai";
-				dma-names = "tx", "rx";
-				dmas = <&edma0 0 21>,
-					<&edma0 0 20>;
-				status = "disabled";
-			};
-
-			pit: pit@40037000 {
-				compatible = "fsl,vf610-pit";
-				reg = <0x40037000 0x1000>;
-				interrupts = <0 39 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_PIT>;
-				clock-names = "pit";
-			};
-
-			pwm0: pwm@40038000 {
-				compatible = "fsl,vf610-ftm-pwm";
-				#pwm-cells = <3>;
-				reg = <0x40038000 0x1000>;
-				clock-names = "ftm_sys", "ftm_ext",
-					      "ftm_fix", "ftm_cnt_clk_en";
-				clocks = <&clks VF610_CLK_FTM0>,
-					<&clks VF610_CLK_FTM0_EXT_SEL>,
-					<&clks VF610_CLK_FTM0_FIX_SEL>,
-					<&clks VF610_CLK_FTM0_EXT_FIX_EN>;
-				status = "disabled";
-			};
-
-			pwm1: pwm@40039000 {
-				compatible = "fsl,vf610-ftm-pwm";
-				#pwm-cells = <3>;
-				reg = <0x40039000 0x1000>;
-				clock-names = "ftm_sys", "ftm_ext",
-					      "ftm_fix", "ftm_cnt_clk_en";
-				clocks = <&clks VF610_CLK_FTM1>,
-					<&clks VF610_CLK_FTM1_EXT_SEL>,
-					<&clks VF610_CLK_FTM1_FIX_SEL>,
-					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
-				status = "disabled";
-			};
-
-			adc0: adc@4003b000 {
-				compatible = "fsl,vf610-adc";
-				reg = <0x4003b000 0x1000>;
-				interrupts = <0 53 0x04>;
-				clocks = <&clks VF610_CLK_ADC0>;
-				clock-names = "adc";
-				status = "disabled";
-			};
-
-			wdog@4003e000 {
-				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
-				reg = <0x4003e000 0x1000>;
-				clocks = <&clks VF610_CLK_WDT>;
-				clock-names = "wdog";
-			};
-
-			qspi0: quadspi@40044000 {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				compatible = "fsl,vf610-qspi";
-				reg = <0x40044000 0x1000>;
-				interrupts = <0 24 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_QSPI0_EN>,
-					<&clks VF610_CLK_QSPI0>;
-				clock-names = "qspi_en", "qspi";
-				status = "disabled";
-			};
-
-			iomuxc: iomuxc@40048000 {
-				compatible = "fsl,vf610-iomuxc";
-				reg = <0x40048000 0x1000>;
-				#gpio-range-cells = <3>;
-			};
-
-			gpio1: gpio@40049000 {
-				compatible = "fsl,vf610-gpio";
-				reg = <0x40049000 0x1000 0x400ff000 0x40>;
-				interrupts = <0 107 IRQ_TYPE_LEVEL_HIGH>;
-				gpio-controller;
-				#gpio-cells = <2>;
-				interrupt-controller;
-				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 0 32>;
-			};
-
-			gpio2: gpio@4004a000 {
-				compatible = "fsl,vf610-gpio";
-				reg = <0x4004a000 0x1000 0x400ff040 0x40>;
-				interrupts = <0 108 IRQ_TYPE_LEVEL_HIGH>;
-				gpio-controller;
-				#gpio-cells = <2>;
-				interrupt-controller;
-				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 32 32>;
-			};
-
-			gpio3: gpio@4004b000 {
-				compatible = "fsl,vf610-gpio";
-				reg = <0x4004b000 0x1000 0x400ff080 0x40>;
-				interrupts = <0 109 IRQ_TYPE_LEVEL_HIGH>;
-				gpio-controller;
-				#gpio-cells = <2>;
-				interrupt-controller;
-				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 64 32>;
-			};
-
-			gpio4: gpio@4004c000 {
-				compatible = "fsl,vf610-gpio";
-				reg = <0x4004c000 0x1000 0x400ff0c0 0x40>;
-				interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
-				gpio-controller;
-				#gpio-cells = <2>;
-				interrupt-controller;
-				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 96 32>;
-			};
-
-			gpio5: gpio@4004d000 {
-				compatible = "fsl,vf610-gpio";
-				reg = <0x4004d000 0x1000 0x400ff100 0x40>;
-				interrupts = <0 111 IRQ_TYPE_LEVEL_HIGH>;
-				gpio-controller;
-				#gpio-cells = <2>;
-				interrupt-controller;
-				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 128 7>;
-			};
-
-			anatop: anatop@40050000 {
-				compatible = "fsl,vf610-anatop", "syscon";
-				reg = <0x40050000 0x400>;
-			};
-
-			usbphy0: usbphy@40050800 {
-				compatible = "fsl,vf610-usbphy";
-				reg = <0x40050800 0x400>;
-				interrupts = <0 50 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_USBPHY0>;
-				fsl,anatop = <&anatop>;
-			};
-
-			usbphy1: usbphy@40050c00 {
-				compatible = "fsl,vf610-usbphy";
-				reg = <0x40050c00 0x400>;
-				interrupts = <0 51 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_USBPHY1>;
-				fsl,anatop = <&anatop>;
-			};
-
-			i2c0: i2c@40066000 {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				compatible = "fsl,vf610-i2c";
-				reg = <0x40066000 0x1000>;
-				interrupts =<0 71 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_I2C0>;
-				clock-names = "ipg";
-				dmas = <&edma0 0 50>,
-					<&edma0 0 51>;
-				dma-names = "rx","tx";
-				status = "disabled";
-			};
-
-			clks: ccm@4006b000 {
-				compatible = "fsl,vf610-ccm";
-				reg = <0x4006b000 0x1000>;
-				clocks = <&sxosc>, <&fxosc>;
-				clock-names = "sxosc", "fxosc";
-				#clock-cells = <1>;
-			};
-
-			usbdev0: usb@40034000 {
-				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
-				reg = <0x40034000 0x800>;
-				interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_USBC0>;
-				fsl,usbphy = <&usbphy0>;
-				fsl,usbmisc = <&usbmisc0 0>;
-				dr_mode = "peripheral";
-				status = "disabled";
-			};
-
-			usbmisc0: usb@40034800 {
-				#index-cells = <1>;
-				compatible = "fsl,vf610-usbmisc";
-				reg = <0x40034800 0x200>;
-				clocks = <&clks VF610_CLK_USBC0>;
-			};
-		};
-
-		aips1: aips-bus@40080000 {
-			compatible = "fsl,aips-bus", "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			reg = <0x40080000 0x80000>;
-			ranges;
-
-			edma1: dma-controller@40098000 {
-				#dma-cells = <2>;
-				compatible = "fsl,vf610-edma";
-				reg = <0x40098000 0x2000>,
-					<0x400a1000 0x1000>,
-					<0x400a2000 0x1000>;
-				interrupts = <0 10 IRQ_TYPE_LEVEL_HIGH>,
-						<0 11 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-names = "edma-tx", "edma-err";
-				dma-channels = <32>;
-				clock-names = "dmamux0", "dmamux1";
-				clocks = <&clks VF610_CLK_DMAMUX2>,
-					<&clks VF610_CLK_DMAMUX3>;
-			};
-
-			uart4: serial@400a9000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x400a9000 0x1000>;
-				interrupts = <0 65 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART4>;
-				clock-names = "ipg";
-				status = "disabled";
-			};
-
-			uart5: serial@400aa000 {
-				compatible = "fsl,vf610-lpuart";
-				reg = <0x400aa000 0x1000>;
-				interrupts = <0 66 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_UART5>;
-				clock-names = "ipg";
-				status = "disabled";
-			};
-
-			adc1: adc@400bb000 {
-				compatible = "fsl,vf610-adc";
-				reg = <0x400bb000 0x1000>;
-				interrupts = <0 54 0x04>;
-				clocks = <&clks VF610_CLK_ADC1>;
-				clock-names = "adc";
-				status = "disabled";
-			};
-
-			esdhc1: esdhc@400b2000 {
-				compatible = "fsl,imx53-esdhc";
-				reg = <0x400b2000 0x1000>;
-				interrupts = <0 28 0x04>;
-				clocks = <&clks VF610_CLK_IPG_BUS>,
-					<&clks VF610_CLK_PLATFORM_BUS>,
-					<&clks VF610_CLK_ESDHC1>;
-				clock-names = "ipg", "ahb", "per";
-				status = "disabled";
-			};
-
-			usbh1: usb@400b4000 {
-				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
-				reg = <0x400b4000 0x800>;
-				interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_USBC1>;
-				fsl,usbphy = <&usbphy1>;
-				fsl,usbmisc = <&usbmisc1 0>;
-				dr_mode = "host";
-				status = "disabled";
-			};
-
-			usbmisc1: usb@400b4800 {
-				#index-cells = <1>;
-				compatible = "fsl,vf610-usbmisc";
-				reg = <0x400b4800 0x200>;
-				clocks = <&clks VF610_CLK_USBC1>;
-			};
-
-			ftm: ftm@400b8000 {
-				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
-				interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
-				clock-names = "ftm-evt", "ftm-src",
-					"ftm-evt-counter-en", "ftm-src-counter-en";
-				clocks = <&clks VF610_CLK_FTM2>,
-					<&clks VF610_CLK_FTM3>,
-					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
-					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
-				status = "disabled";
-			};
-
-			fec0: ethernet@400d0000 {
-				compatible = "fsl,mvf600-fec";
-				reg = <0x400d0000 0x1000>;
-				interrupts = <0 78 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_ENET0>,
-					<&clks VF610_CLK_ENET0>,
-					<&clks VF610_CLK_ENET>;
-				clock-names = "ipg", "ahb", "ptp";
-				status = "disabled";
-			};
-
-			fec1: ethernet@400d1000 {
-				compatible = "fsl,mvf600-fec";
-				reg = <0x400d1000 0x1000>;
-				interrupts = <0 79 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_ENET1>,
-					<&clks VF610_CLK_ENET1>,
-					<&clks VF610_CLK_ENET>;
-				clock-names = "ipg", "ahb", "ptp";
-				status = "disabled";
-			};
-
-			can1: flexcan@400d4000 {
-				compatible = "fsl,vf610-flexcan";
-				reg = <0x400d4000 0x4000>;
-				interrupts = <0 59 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks VF610_CLK_FLEXCAN1>,
-					 <&clks VF610_CLK_FLEXCAN1>;
-				clock-names = "ipg", "per";
-				status = "disabled";
-			};
+&a5_cpu {
+	next-level-cache = <&L2>;
+};
 
-		};
+&aips0 {
+	L2: l2-cache@40006000 {
+		compatible = "arm,pl310-cache";
+		reg = <0x40006000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+		arm,data-latency = <1 1 1>;
+		arm,tag-latency = <2 2 2>;
 	};
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
new file mode 100644
index 0000000..4e70833
--- /dev/null
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -0,0 +1,436 @@
+/*
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "vf610-pinfunc.h"
+#include <dt-bindings/clock/vf610-clock.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	aliases {
+		can0 = &can0;
+		can1 = &can1;
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+		serial3 = &uart3;
+		serial4 = &uart4;
+		serial5 = &uart5;
+		gpio0 = &gpio1;
+		gpio1 = &gpio2;
+		gpio2 = &gpio3;
+		gpio3 = &gpio4;
+		gpio4 = &gpio5;
+		usbphy0 = &usbphy0;
+		usbphy1 = &usbphy1;
+	};
+
+	fxosc: fxosc {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+	};
+
+	sxosc: sxosc {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges;
+
+		aips0: aips-bus@40000000 {
+			compatible = "fsl,aips-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			edma0: dma-controller@40018000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40018000 0x2000>,
+					<0x40024000 0x1000>,
+					<0x40025000 0x1000>;
+				dma-channels = <32>;
+				clock-names = "dmamux0", "dmamux1";
+				clocks = <&clks VF610_CLK_DMAMUX0>,
+					<&clks VF610_CLK_DMAMUX1>;
+				status = "disabled";
+			};
+
+			can0: flexcan@40020000 {
+				compatible = "fsl,vf610-flexcan";
+				reg = <0x40020000 0x4000>;
+				clocks = <&clks VF610_CLK_FLEXCAN0>,
+					 <&clks VF610_CLK_FLEXCAN0>;
+				clock-names = "ipg", "per";
+				status = "disabled";
+			};
+
+			uart0: serial@40027000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x40027000 0x1000>;
+				clocks = <&clks VF610_CLK_UART0>;
+				clock-names = "ipg";
+				dmas = <&edma0 0 2>,
+					<&edma0 0 3>;
+				dma-names = "rx","tx";
+				status = "disabled";
+			};
+
+			uart1: serial@40028000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x40028000 0x1000>;
+				clocks = <&clks VF610_CLK_UART1>;
+				clock-names = "ipg";
+				dmas = <&edma0 0 4>,
+					<&edma0 0 5>;
+				dma-names = "rx","tx";
+				status = "disabled";
+			};
+
+			uart2: serial@40029000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x40029000 0x1000>;
+				clocks = <&clks VF610_CLK_UART2>;
+				clock-names = "ipg";
+				dmas = <&edma0 0 6>,
+					<&edma0 0 7>;
+				dma-names = "rx","tx";
+				status = "disabled";
+			};
+
+			uart3: serial@4002a000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x4002a000 0x1000>;
+				clocks = <&clks VF610_CLK_UART3>;
+				clock-names = "ipg";
+				dmas = <&edma0 0 8>,
+					<&edma0 0 9>;
+				dma-names = "rx","tx";
+				status = "disabled";
+			};
+
+			dspi0: dspi0@4002c000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,vf610-dspi";
+				reg = <0x4002c000 0x1000>;
+				clocks = <&clks VF610_CLK_DSPI0>;
+				clock-names = "dspi";
+				spi-num-chipselects = <5>;
+				status = "disabled";
+			};
+
+			sai2: sai@40031000 {
+				compatible = "fsl,vf610-sai";
+				reg = <0x40031000 0x1000>;
+				clocks = <&clks VF610_CLK_SAI2>;
+				clock-names = "sai";
+				dma-names = "tx", "rx";
+				dmas = <&edma0 0 21>,
+					<&edma0 0 20>;
+				status = "disabled";
+			};
+
+			pit: pit@40037000 {
+				compatible = "fsl,vf610-pit";
+				reg = <0x40037000 0x1000>;
+				clocks = <&clks VF610_CLK_PIT>;
+				clock-names = "pit";
+			};
+
+			pwm0: pwm@40038000 {
+				compatible = "fsl,vf610-ftm-pwm";
+				#pwm-cells = <3>;
+				reg = <0x40038000 0x1000>;
+				clock-names = "ftm_sys", "ftm_ext",
+					      "ftm_fix", "ftm_cnt_clk_en";
+				clocks = <&clks VF610_CLK_FTM0>,
+					<&clks VF610_CLK_FTM0_EXT_SEL>,
+					<&clks VF610_CLK_FTM0_FIX_SEL>,
+					<&clks VF610_CLK_FTM0_EXT_FIX_EN>;
+				status = "disabled";
+			};
+
+			pwm1: pwm@40039000 {
+				compatible = "fsl,vf610-ftm-pwm";
+				#pwm-cells = <3>;
+				reg = <0x40039000 0x1000>;
+				clock-names = "ftm_sys", "ftm_ext",
+					      "ftm_fix", "ftm_cnt_clk_en";
+				clocks = <&clks VF610_CLK_FTM1>,
+					<&clks VF610_CLK_FTM1_EXT_SEL>,
+					<&clks VF610_CLK_FTM1_FIX_SEL>,
+					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
+				status = "disabled";
+			};
+
+			adc0: adc@4003b000 {
+				compatible = "fsl,vf610-adc";
+				reg = <0x4003b000 0x1000>;
+				clocks = <&clks VF610_CLK_ADC0>;
+				clock-names = "adc";
+				status = "disabled";
+			};
+
+			wdog@4003e000 {
+				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
+				reg = <0x4003e000 0x1000>;
+				clocks = <&clks VF610_CLK_WDT>;
+				clock-names = "wdog";
+				status = "disabled";
+			};
+
+			qspi0: quadspi@40044000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,vf610-qspi";
+				reg = <0x40044000 0x1000>;
+				clocks = <&clks VF610_CLK_QSPI0_EN>,
+					<&clks VF610_CLK_QSPI0>;
+				clock-names = "qspi_en", "qspi";
+				status = "disabled";
+			};
+
+			iomuxc: iomuxc@40048000 {
+				compatible = "fsl,vf610-iomuxc";
+				reg = <0x40048000 0x1000>;
+				#gpio-range-cells = <3>;
+			};
+
+			gpio1: gpio@40049000 {
+				compatible = "fsl,vf610-gpio";
+				reg = <0x40049000 0x1000 0x400ff000 0x40>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				gpio-ranges = <&iomuxc 0 0 32>;
+			};
+
+			gpio2: gpio@4004a000 {
+				compatible = "fsl,vf610-gpio";
+				reg = <0x4004a000 0x1000 0x400ff040 0x40>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				gpio-ranges = <&iomuxc 0 32 32>;
+			};
+
+			gpio3: gpio@4004b000 {
+				compatible = "fsl,vf610-gpio";
+				reg = <0x4004b000 0x1000 0x400ff080 0x40>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				gpio-ranges = <&iomuxc 0 64 32>;
+			};
+
+			gpio4: gpio@4004c000 {
+				compatible = "fsl,vf610-gpio";
+				reg = <0x4004c000 0x1000 0x400ff0c0 0x40>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				gpio-ranges = <&iomuxc 0 96 32>;
+			};
+
+			gpio5: gpio@4004d000 {
+				compatible = "fsl,vf610-gpio";
+				reg = <0x4004d000 0x1000 0x400ff100 0x40>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				gpio-ranges = <&iomuxc 0 128 7>;
+			};
+
+			anatop: anatop@40050000 {
+				compatible = "fsl,vf610-anatop", "syscon";
+				reg = <0x40050000 0x400>;
+			};
+
+			usbphy0: usbphy@40050800 {
+				compatible = "fsl,vf610-usbphy";
+				reg = <0x40050800 0x400>;
+				clocks = <&clks VF610_CLK_USBPHY0>;
+				fsl,anatop = <&anatop>;
+				status = "disabled";
+			};
+
+			usbphy1: usbphy@40050c00 {
+				compatible = "fsl,vf610-usbphy";
+				reg = <0x40050c00 0x400>;
+				clocks = <&clks VF610_CLK_USBPHY1>;
+				fsl,anatop = <&anatop>;
+				status = "disabled";
+			};
+
+			i2c0: i2c@40066000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,vf610-i2c";
+				reg = <0x40066000 0x1000>;
+				clocks = <&clks VF610_CLK_I2C0>;
+				clock-names = "ipg";
+				dmas = <&edma0 0 50>,
+					<&edma0 0 51>;
+				dma-names = "rx","tx";
+				status = "disabled";
+			};
+
+			clks: ccm@4006b000 {
+				compatible = "fsl,vf610-ccm";
+				reg = <0x4006b000 0x1000>;
+				clocks = <&sxosc>, <&fxosc>;
+				clock-names = "sxosc", "fxosc";
+				#clock-cells = <1>;
+			};
+
+			usbdev0: usb@40034000 {
+				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
+				reg = <0x40034000 0x800>;
+				clocks = <&clks VF610_CLK_USBC0>;
+				fsl,usbphy = <&usbphy0>;
+				fsl,usbmisc = <&usbmisc0 0>;
+				dr_mode = "peripheral";
+				status = "disabled";
+			};
+
+			usbmisc0: usb@40034800 {
+				#index-cells = <1>;
+				compatible = "fsl,vf610-usbmisc";
+				reg = <0x40034800 0x200>;
+				clocks = <&clks VF610_CLK_USBC0>;
+				status = "disabled";
+			};
+		};
+
+		aips1: aips-bus@40080000 {
+			compatible = "fsl,aips-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			edma1: dma-controller@40098000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40098000 0x2000>,
+					<0x400a1000 0x1000>,
+					<0x400a2000 0x1000>;
+				dma-channels = <32>;
+				clock-names = "dmamux0", "dmamux1";
+				clocks = <&clks VF610_CLK_DMAMUX2>,
+					<&clks VF610_CLK_DMAMUX3>;
+				status = "disabled";
+			};
+
+			uart4: serial@400a9000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x400a9000 0x1000>;
+				clocks = <&clks VF610_CLK_UART4>;
+				clock-names = "ipg";
+				status = "disabled";
+			};
+
+			uart5: serial@400aa000 {
+				compatible = "fsl,vf610-lpuart";
+				reg = <0x400aa000 0x1000>;
+				clocks = <&clks VF610_CLK_UART5>;
+				clock-names = "ipg";
+				status = "disabled";
+			};
+
+			adc1: adc@400bb000 {
+				compatible = "fsl,vf610-adc";
+				reg = <0x400bb000 0x1000>;
+				clocks = <&clks VF610_CLK_ADC1>;
+				clock-names = "adc";
+				status = "disabled";
+			};
+
+			esdhc1: esdhc@400b2000 {
+				compatible = "fsl,imx53-esdhc";
+				reg = <0x400b2000 0x1000>;
+				clocks = <&clks VF610_CLK_IPG_BUS>,
+					<&clks VF610_CLK_PLATFORM_BUS>,
+					<&clks VF610_CLK_ESDHC1>;
+				clock-names = "ipg", "ahb", "per";
+				status = "disabled";
+			};
+
+			usbh1: usb@400b4000 {
+				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
+				reg = <0x400b4000 0x800>;
+				clocks = <&clks VF610_CLK_USBC1>;
+				fsl,usbphy = <&usbphy1>;
+				fsl,usbmisc = <&usbmisc1 0>;
+				dr_mode = "host";
+				status = "disabled";
+			};
+
+			usbmisc1: usb@400b4800 {
+				#index-cells = <1>;
+				compatible = "fsl,vf610-usbmisc";
+				reg = <0x400b4800 0x200>;
+				clocks = <&clks VF610_CLK_USBC1>;
+				status = "disabled";
+			};
+
+			ftm: ftm@400b8000 {
+				compatible = "fsl,ftm-timer";
+				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				clock-names = "ftm-evt", "ftm-src",
+					"ftm-evt-counter-en", "ftm-src-counter-en";
+				clocks = <&clks VF610_CLK_FTM2>,
+					<&clks VF610_CLK_FTM3>,
+					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+				status = "disabled";
+			};
+
+			fec0: ethernet@400d0000 {
+				compatible = "fsl,mvf600-fec";
+				reg = <0x400d0000 0x1000>;
+				clocks = <&clks VF610_CLK_ENET0>,
+					<&clks VF610_CLK_ENET0>,
+					<&clks VF610_CLK_ENET>;
+				clock-names = "ipg", "ahb", "ptp";
+				status = "disabled";
+			};
+
+			fec1: ethernet@400d1000 {
+				compatible = "fsl,mvf600-fec";
+				reg = <0x400d1000 0x1000>;
+				clocks = <&clks VF610_CLK_ENET1>,
+					<&clks VF610_CLK_ENET1>,
+					<&clks VF610_CLK_ENET>;
+				clock-names = "ipg", "ahb", "ptp";
+				status = "disabled";
+			};
+
+			can1: flexcan@400d4000 {
+				compatible = "fsl,vf610-flexcan";
+				reg = <0x400d4000 0x4000>;
+				clocks = <&clks VF610_CLK_FLEXCAN1>,
+					 <&clks VF610_CLK_FLEXCAN1>;
+				clock-names = "ipg", "per";
+				status = "disabled";
+			};
+
+		};
+	};
+};
-- 
2.1.2

