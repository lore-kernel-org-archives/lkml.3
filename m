Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKKRdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:33:09 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53327 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751392AbaKKRcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:32:53 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3 2/2] arm64: Add Juno board device tree.
Date: Tue, 11 Nov 2014 17:32:11 +0000
Message-Id: <1415727131-4572-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
References: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for ARM's Juno development board (rev 0).
It enables most of the board peripherals: UART, I2C, USB, MMC and
100Mb ethernet. There is no support at the moment for clock setting
and HDLCD driver which depends on it.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm64/boot/dts/arm/Makefile              |   1 +
 arch/arm64/boot/dts/arm/juno-clocks.dtsi      |  45 ++++++
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi | 129 +++++++++++++++
 arch/arm64/boot/dts/arm/juno.dts              | 218 ++++++++++++++++++++++++++
 4 files changed, 393 insertions(+)
 create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno.dts

diff --git a/arch/arm64/boot/dts/arm/Makefile b/arch/arm64/boot/dts/arm/Makefile
index 43d1404..301a0da 100644
--- a/arch/arm64/boot/dts/arm/Makefile
+++ b/arch/arm64/boot/dts/arm/Makefile
@@ -1,4 +1,5 @@
 dtb-$(CONFIG_ARCH_VEXPRESS) += foundation-v8.dtb
+dtb-$(CONFIG_ARCH_VEXPRESS) += juno.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb
 
 always		:= $(dtb-y)
diff --git a/arch/arm64/boot/dts/arm/juno-clocks.dtsi b/arch/arm64/boot/dts/arm/juno-clocks.dtsi
new file mode 100644
index 0000000..adbc82a
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/juno-clocks.dtsi
@@ -0,0 +1,45 @@
+/*
+ * ARM Juno Platform clocks
+ *
+ * Copyright (c) 2013-2014 ARM Ltd
+ *
+ * This file is licensed under a dual GPLv2 or BSD license.
+ *
+ */
+
+	/* SoC fixed clocks */
+	soc_uartclk: refclk72738khz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <7273800>;
+		clock-output-names = "juno:uartclk";
+	};
+
+	soc_usb48mhz: clk48mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <48000000>;
+		clock-output-names = "clk48mhz";
+	};
+
+	soc_smc50mhz: clk50mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <50000000>;
+		clock-output-names = "smc_clk";
+	};
+
+	soc_refclk100mhz: refclk100mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+		clock-output-names = "apb_pclk";
+	};
+
+	soc_faxiclk: refclk533mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <533000000>;
+		clock-output-names = "faxi_clk";
+	};
+
diff --git a/arch/arm64/boot/dts/arm/juno-motherboard.dtsi b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
new file mode 100644
index 0000000..c138b95
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
@@ -0,0 +1,129 @@
+/*
+ * ARM Juno Platform motherboard peripherals
+ *
+ * Copyright (c) 2013-2014 ARM Ltd
+ *
+ * This file is licensed under a dual GPLv2 or BSD license.
+ *
+ */
+
+		mb_clk24mhz: clk24mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <24000000>;
+			clock-output-names = "juno_mb:clk24mhz";
+		};
+
+		mb_clk25mhz: clk25mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <25000000>;
+			clock-output-names = "juno_mb:clk25mhz";
+		};
+
+		motherboard {
+			compatible = "arm,vexpress,v2p-p1", "simple-bus";
+			#address-cells = <2>;  /* SMB chipselect number and offset */
+			#size-cells = <1>;
+			#interrupt-cells = <1>;
+			ranges;
+			model = "V2M-Juno";
+			arm,hbi = <0x252>;
+			arm,vexpress,site = <0>;
+			arm,v2m-memory-map = "rs1";
+
+			mb_fixed_3v3: fixedregulator@0 {
+				compatible = "regulator-fixed";
+				regulator-name = "MCC_SB_3V3";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			ethernet@2,00000000 {
+				compatible = "smsc,lan9118", "smsc,lan9115";
+				reg = <2 0x00000000 0x10000>;
+				interrupts = <3>;
+				phy-mode = "mii";
+				reg-io-width = <4>;
+				smsc,irq-active-high;
+				smsc,irq-push-pull;
+				clocks = <&mb_clk25mhz>;
+				vdd33a-supply = <&mb_fixed_3v3>;
+				vddvario-supply = <&mb_fixed_3v3>;
+			};
+
+			usb@5,00000000 {
+				compatible = "nxp,usb-isp1763";
+				reg = <5 0x00000000 0x20000>;
+				bus-width = <16>;
+				interrupts = <4>;
+			};
+
+			iofpga@3,00000000 {
+				compatible = "arm,amba-bus", "simple-bus";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 3 0 0x200000>;
+
+				mmci@050000 {
+					compatible = "arm,pl180", "arm,primecell";
+					reg = <0x050000 0x1000>;
+					interrupts = <5>;
+					/* cd-gpios = <&v2m_mmc_gpios 0 0>;
+					wp-gpios = <&v2m_mmc_gpios 1 0>; */
+					max-frequency = <12000000>;
+					vmmc-supply = <&mb_fixed_3v3>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "mclk", "apb_pclk";
+				};
+
+				kmi@060000 {
+					compatible = "arm,pl050", "arm,primecell";
+					reg = <0x060000 0x1000>;
+					interrupts = <8>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "KMIREFCLK", "apb_pclk";
+				};
+
+				kmi@070000 {
+					compatible = "arm,pl050", "arm,primecell";
+					reg = <0x070000 0x1000>;
+					interrupts = <8>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "KMIREFCLK", "apb_pclk";
+				};
+
+				wdt@0f0000 {
+					compatible = "arm,sp805", "arm,primecell";
+					reg = <0x0f0000 0x10000>;
+					interrupts = <7>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "wdogclk", "apb_pclk";
+				};
+
+				v2m_timer01: timer@110000 {
+					compatible = "arm,sp804", "arm,primecell";
+					reg = <0x110000 0x10000>;
+					interrupts = <9>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "timclken1", "apb_pclk";
+				};
+
+				v2m_timer23: timer@120000 {
+					compatible = "arm,sp804", "arm,primecell";
+					reg = <0x120000 0x10000>;
+					interrupts = <9>;
+					clocks = <&mb_clk24mhz>, <&soc_smc50mhz>;
+					clock-names = "timclken1", "apb_pclk";
+				};
+
+				rtc@170000 {
+					compatible = "arm,pl031", "arm,primecell";
+					reg = <0x170000 0x10000>;
+					interrupts = <0>;
+					clocks = <&soc_smc50mhz>;
+					clock-names = "apb_pclk";
+				};
+			};
+		};
diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
new file mode 100644
index 0000000..097ecc4
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/juno.dts
@@ -0,0 +1,218 @@
+/*
+ * ARM Ltd. Juno Platform
+ *
+ * Copyright (c) 2013-2014 ARM Ltd.
+ *
+ * This file is licensed under a dual GPLv2 or BSD license.
+ */
+
+/dts-v1/;
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+/ {
+	model = "ARM Juno development board (r0)";
+	compatible = "arm,juno", "arm,vexpress";
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	aliases {
+		serial0 = &soc_uart0;
+	};
+
+	chosen {
+		stdout-path = &soc_uart0;
+	};
+
+	psci {
+		compatible = "arm,psci-0.2";
+		method = "smc";
+	};
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		A57_0: cpu@0 {
+			compatible = "arm,cortex-a57","arm,armv8";
+			reg = <0x0 0x0>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+
+		A57_1: cpu@1 {
+			compatible = "arm,cortex-a57","arm,armv8";
+			reg = <0x0 0x1>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+
+		A53_0: cpu@100 {
+			compatible = "arm,cortex-a53","arm,armv8";
+			reg = <0x0 0x100>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+
+		A53_1: cpu@101 {
+			compatible = "arm,cortex-a53","arm,armv8";
+			reg = <0x0 0x101>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+
+		A53_2: cpu@102 {
+			compatible = "arm,cortex-a53","arm,armv8";
+			reg = <0x0 0x102>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+
+		A53_3: cpu@103 {
+			compatible = "arm,cortex-a53","arm,armv8";
+			reg = <0x0 0x103>;
+			device_type = "cpu";
+			enable-method = "psci";
+		};
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		/* last 16MB of the first memory area is reserved for secure world use by firmware */
+		reg = <0x00000000 0x80000000 0x0 0x7f000000>,
+		      <0x00000008 0x80000000 0x1 0x80000000>;
+	};
+
+	gic: interrupt-controller@2c001000 {
+		compatible = "arm,gic-400", "arm,cortex-a15-gic";
+		reg = <0x0 0x2c010000 0 0x1000>,
+		      <0x0 0x2c02f000 0 0x2000>,
+		      <0x0 0x2c04f000 0 0x2000>,
+		      <0x0 0x2c06f000 0 0x2000>;
+		#address-cells = <0>;
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>;
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 02 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 06 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	/include/ "juno-clocks.dtsi"
+
+	dma@7ff00000 {
+		compatible = "arm,pl330", "arm,primecell";
+		reg = <0x0 0x7ff00000 0 0x1000>;
+		#dma-cells = <1>;
+		#dma-channels = <8>;
+		#dma-requests = <32>;
+		interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_faxiclk>;
+		clock-names = "apb_pclk";
+	};
+
+	soc_uart0: uart@7ff80000 {
+		compatible = "arm,pl011", "arm,primecell";
+		reg = <0x0 0x7ff80000 0x0 0x1000>;
+		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_uartclk>, <&soc_refclk100mhz>;
+		clock-names = "uartclk", "apb_pclk";
+	};
+
+	i2c@7ffa0000 {
+		compatible = "snps,designware-i2c";
+		reg = <0x0 0x7ffa0000 0x0 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
+		clock-frequency = <400000>;
+		i2c-sda-hold-time-ns = <500>;
+		clocks = <&soc_smc50mhz>;
+
+		dvi0: dvi-transmitter@70 {
+			compatible = "nxp,tda998x";
+			reg = <0x70>;
+		};
+
+		dvi1: dvi-transmitter@71 {
+			compatible = "nxp,tda998x";
+			reg = <0x71>;
+		};
+	};
+
+	ohci@7ffb0000 {
+		compatible = "generic-ohci";
+		reg = <0x0 0x7ffb0000 0x0 0x10000>;
+		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_usb48mhz>;
+	};
+
+	ehci@7ffc0000 {
+		compatible = "generic-ehci";
+		reg = <0x0 0x7ffc0000 0x0 0x10000>;
+		interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_usb48mhz>;
+	};
+
+	memory-controller@7ffd0000 {
+		compatible = "arm,pl354", "arm,primecell";
+		reg = <0 0x7ffd0000 0 0x1000>;
+		interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_smc50mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	smb {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0 0 0x08000000 0x04000000>,
+			 <1 0 0 0x14000000 0x04000000>,
+			 <2 0 0 0x18000000 0x04000000>,
+			 <3 0 0 0x1c000000 0x04000000>,
+			 <4 0 0 0x0c000000 0x04000000>,
+			 <5 0 0 0x10000000 0x04000000>;
+
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 15>;
+		interrupt-map = <0 0  0 &gic 0  68 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  1 &gic 0  69 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  2 &gic 0  70 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  3 &gic 0 160 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  4 &gic 0 161 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  5 &gic 0 162 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  6 &gic 0 163 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  7 &gic 0 164 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  8 &gic 0 165 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  9 &gic 0 166 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 10 &gic 0 167 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 11 &gic 0 168 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 12 &gic 0 169 IRQ_TYPE_LEVEL_HIGH>;
+
+		/include/ "juno-motherboard.dtsi"
+	};
+};
-- 
2.1.3

