Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbaKSXRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:17:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62333 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307AbaKSXQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:28 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 15/15] metag: tz1090: add TZ1090 clocks to device tree
Date: Wed, 19 Nov 2014 23:15:43 +0000
Message-Id: <1416438943-11429-16-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the common clock framework for the TZ1090 SoC, add a tz1090_clk
device tree file describing the clocks, and connect the Meta core clock
so that the rate of the Meta timer can be determined.

Most of the clock tree is described apart from some AFE clocks which
aren't usually of much interest to Linux. These are represented with
placeholder clocks.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
 arch/metag/Kconfig.soc              |   1 +
 arch/metag/boot/dts/tz1090.dtsi     |   4 +
 arch/metag/boot/dts/tz1090_clk.dtsi | 784 ++++++++++++++++++++++++++++++++++++
 3 files changed, 789 insertions(+)
 create mode 100644 arch/metag/boot/dts/tz1090_clk.dtsi

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 973640f..93c21c3 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -17,6 +17,7 @@ config META21_FPGA
 config SOC_TZ1090
 	bool "Toumaz Xenif TZ1090 SoC (Comet)"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select COMMON_CLK
 	select IMGPDC_IRQ
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 24ea7d2..9e8ef8b 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -9,12 +9,16 @@
 #include "skeleton.dtsi"
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include "tz1090_clk.dtsi"
 
 / {
 	compatible = "toumaz,tz1090", "img,meta";
 
 	interrupt-parent = <&intc>;
 
+	clocks = <&meta_core_clk>;
+	clock-names = "core";
+
 	intc: interrupt-controller {
 		compatible = "img,meta-intc";
 		interrupt-controller;
diff --git a/arch/metag/boot/dts/tz1090_clk.dtsi b/arch/metag/boot/dts/tz1090_clk.dtsi
new file mode 100644
index 0000000..e21362d
--- /dev/null
+++ b/arch/metag/boot/dts/tz1090_clk.dtsi
@@ -0,0 +1,784 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * ============ CLOCK SPECIFIER DEFINITIONS ============
+ */
+
+#define CLK_XTAL1_DIV	&pdc_clk	0
+#define CLK_32KHZ	&pdc_clk	1
+
+#define CLK_SYSCLK0_SW	&top_clkswitch	0	/* bit 0 */
+#define CLK_SYSCLK1_SW	&top_clkswitch	1	/* bit 1 */
+#define CLK_OUT0_SW0	&top_clkswitch	2	/* bit 2 */
+#define CLK_OUT0_SW1	&top_clkswitch	3	/* bit 3 */
+#define CLK_OUT0_SW2	&top_clkswitch	4	/* bit 4 */
+#define CLK_OUT0_SW3	&top_clkswitch	5	/* bit 5 */
+#define CLK_OUT1_SW0	&top_clkswitch	6	/* bit 6 */
+#define CLK_OUT1_SW1	&top_clkswitch	7	/* bit 7 */
+#define CLK_OUT1_SW2	&top_clkswitch	8	/* bit 8 */
+#define CLK_OUT1_SW3	&top_clkswitch	9	/* bit 9 */
+#define CLK_I2S_SW2	&top_clkswitch	10	/* bit 10 */
+#define CLK_I2S_SW0	&top_clkswitch	11	/* bit 11 */
+#define CLK_I2S_SW1	&top_clkswitch	12	/* bit 12 */
+#define CLK_SCB_SW	&top_clkswitch	13	/* bit 13 */
+#define CLK_UART_SW	&top_clkswitch	14	/* bit 14 */
+#define CLK_ESTC0_SW	&top_clkswitch	15	/* bit 16 */
+#define CLK_ESTC1_SW	&top_clkswitch	16	/* bit 17 */
+#define CLK_USB_SW0	&top_clkswitch	17	/* bit 18 */
+#define CLK_USB_SW1	&top_clkswitch	18	/* bit 19 */
+#define CLK_AFE_SW0	&top_clkswitch	19	/* bit 20 */
+#define CLK_AFE_SW1	&top_clkswitch	20	/* bit 21 */
+#define CLK_ADCPLL_SW0	&top_clkswitch	21	/* bit 22 */
+#define CLK_ADCPLL_SW1	&top_clkswitch	22	/* bit 23 */
+#define CLK_ADCPLL_SW2	&top_clkswitch	23	/* bit 24 */
+#define CLK_ADCPLL_SW3	&top_clkswitch	24	/* bit 25 */
+#define CLK_USB_SW2	&top_clkswitch	25	/* bit 28 */
+#define CLK_USB_SW3	&top_clkswitch	26	/* bit 29 */
+
+#define CLK_PIXEL_SW0	&top_clkswitch2	0	/* bit 0 */
+#define CLK_PIXEL_SW1	&top_clkswitch2	1	/* bit 1 */
+#define CLK_PIXEL_SW2	&top_clkswitch2	2	/* bit 2 */
+#define CLK_PIXEL_SW3	&top_clkswitch2	3	/* bit 3 */
+#define CLK_PIXEL_SW4	&top_clkswitch2	4	/* bit 4 */
+#define CLK_IF1_SW	&top_clkswitch2	5	/* bit 5 */
+#define CLK_IF0_SW	&top_clkswitch2	6	/* bit 6 */
+#define CLK_DAC0_SW	&top_clkswitch2	7	/* bit 8 */
+#define CLK_UCC1_SW	&top_clkswitch2	8	/* bit 9 */
+#define CLK_UCC0_SW	&top_clkswitch2	9	/* bit 10 */
+
+#define CLK_OUT0_EN	&top_clkenab	0	/* bit 5 */
+#define CLK_OUT1_EN	&top_clkenab	1	/* bit 9 */
+#define CLK_I2S_EN	&top_clkenab	2	/* bit 12 */
+#define CLK_SCB_EN	&top_clkenab	3	/* bit 13 */
+#define CLK_UART_EN	&top_clkenab	4	/* bit 14 */
+#define CLK_ESTC0_EN	&top_clkenab	5	/* bit 16 */
+#define CLK_ESTC1_EN	&top_clkenab	6	/* bit 17 */
+#define CLK_USB_EN	&top_clkenab	7	/* bit 19 */
+#define CLK_ADCPLL_EN	&top_clkenab	8	/* bit 25 */
+
+#define CLK_PIXEL_EN	&top_clkenab2	0	/* bit 2 */
+#define CLK_IF1_EN	&top_clkenab2	1	/* bit 5 */
+#define CLK_IF0_EN	&top_clkenab2	2	/* bit 6 */
+#define CLK_EADC_EN	&top_clkenab2	3	/* bit 7 */
+#define CLK_DAC0_EN	&top_clkenab2	4	/* bit 8 */
+#define CLK_UCC1_EN	&top_clkenab2	5	/* bit 9 */
+#define CLK_UCC0_EN	&top_clkenab2	6	/* bit 10 */
+
+#define SYSCLK_SCB0	&perip_clken	0	/* bit 0 */
+#define SYSCLK_SCB1	&perip_clken	1	/* bit 1 */
+#define SYSCLK_SCB2	&perip_clken	2	/* bit 2 */
+#define SYSCLK_SDIO	&perip_clken	3	/* bit 3 */
+#define SYSCLK_UART0	&perip_clken	4	/* bit 4 */
+#define SYSCLK_UART1	&perip_clken	5	/* bit 5 */
+#define SYSCLK_SPIM	&perip_clken	6	/* bit 6 */
+#define SYSCLK_SPIS	&perip_clken	7	/* bit 7 */
+#define SYSCLK_SPIM1	&perip_clken	8	/* bit 8 */
+#define SYSCLK_I2SOUT	&perip_clken	9	/* bit 9 */
+#define SYSCLK_I2SIN	&perip_clken	10	/* bit 10 */
+#define SYSCLK_LCD	&perip_clken	11	/* bit 11 */
+#define SYSCLK_SDHOST	&perip_clken	12	/* bit 12 */
+#define SYSCLK_USB	&perip_clken	13	/* bit 13 */
+
+#define CLK_2D_EN	&hep_clken	0	/* bit 0 */
+#define CLK_DDR_EN	&hep_clken	1	/* bit 1 */
+#define CLK_PDP_EN	&hep_clken	2	/* bit 2 */
+
+#define CLK_SYSCLK_X2_UNDELETED		CLK_SYSCLK1_SW
+#define CLK_UCC1			CLK_UCC1_EN
+
+#define CLK_AFE_PROGDIV1_TO_SOC	&afe_progdiv1_to_soc
+#define CLK_AFE_PROGDIV3_TO_SOC	&afe_progdiv3_to_soc
+#define CLK_IQADC_SYNC_TO_SOC	&iqadc_sync_to_soc
+#define CLK_AFE_RXSYNC_TO_SOC	&afe_rxsync_to_soc
+#define CLK_AFE_TXSYNC_TO_SOC	&afe_txsync_to_soc
+
+/ {
+	soc {
+		/*
+		 * ============ EXTERNAL CLOCKS/OSCILLATORS ============
+		 */
+
+		/* XTAL1 frequency is specified in reset bootstrap config */
+		xtal1: xtal1 {
+			compatible = "specified-clock";
+			#clock-cells = <0>;
+			reg = <0x02004004 0x4>;	/* CR_PERIP_RESET_CFG */
+			bit-mask = <0x00000f00>;	/* FXTAL */
+			/*	 FXTAL	Frequency */
+			table = <0	16384000>,
+				<1	19200000>,
+				<2	24000000>,
+				<3	24576000>,
+				<4	26000000>,
+				<5	36000000>,
+				<6	36864000>,
+				<7	38400000>,
+				<8	40000000>,
+				<9	48000000>;
+			clock-output-names = "xtal1";
+		};
+
+		/* XTAL2 oscillator (board specific, but 12MHz recommended) */
+		xtal2: xtal2 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "xtal2";
+		};
+
+		/* XTAL3 oscillator (32.768KHz if fitted, assume not fitted) */
+		xtal3: xtal3 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "xtal3";
+		};
+
+		ext_adc_dac: ext_adc_dac {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "ext_adc_dac";
+		};
+
+
+		/*
+		 * ============ POWERDOWN CONTROLLER CLOCKS ============
+		 */
+
+		/*           ___________
+		 * xtal1 ___| xtal1_div |____________________________
+		 *          |___________|  |    ________   xtal1_div
+		 *                         `--o| rtc_sw \____________
+		 * xtal3 ----------------------|________/  32khz
+		 */
+		pdc_clk: pdc_clk {
+			compatible = "img,tz1090-pdc-clock";
+			#clock-cells = <1>;
+			reg = <0x02006500 4>;	/* SOC_GPIO_CONTROL0 */
+			clocks = <&xtal1>, <&xtal3>;
+			clock-output-names = "xtal1_div", "32khz";
+		};
+
+
+		/*
+		 * ============ AFE CLOCKS (PLACEHOLDERS) ============
+		 */
+
+		afe_progdiv1_to_soc: afe_progdiv1_to_soc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "afe_progdiv1_to_soc";
+		};
+		afe_progdiv3_to_soc: afe_progdiv3_to_soc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "afe_progdiv3_to_soc";
+		};
+		iqadc_sync_to_soc: iqadc_sync_to_soc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "iqadc_sync_to_soc";
+		};
+		afe_rxsync_to_soc: afe_rxsync_to_soc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "afe_rxsync_to_soc";
+		};
+		afe_txsync_to_soc: afe_txsync_to_soc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "afe_txsync_to_soc";
+		};
+
+		/*
+		 * ============ TOP LEVEL CLOCK SWITCHES ============
+		 */
+
+		/*
+		 * CR_TOP_CLKSWITCH
+		 *                       ___________
+		 * xtal1         ------o|sysclk0_sw \___________
+		 * xtal2         -------|___________/  0
+		 * xtal1         ------o|sysclk1_sw \___________
+		 * sys_clk_div   -------|___________/  1 sys_clk_x2_undeleted
+		 * xtal1         ------o|clkout0_sw0\______
+		 * afe_progdiv1_to_soc -|___________/  2   |
+		 * sys_clk_undeleted --o|clkout0_sw1\____  |
+		 * if0_sw        -------|___________/  3 | |
+		 *                 ,-;==================='-'
+		 *                 | |   ___________
+		 * clkout0_sw0     | `-o|clkout0_sw2\______
+		 * xtal2         --|----|___________/  4   |
+		 *                 |  _____________________|
+		 *                 | |   ___________
+		 * clkout0_sw2     | `-o|clkout0_sw3\___________
+		 * clkout0_sw1     `----|___________/  5
+		 * xtal1         ------o|clkout1_sw0\______
+		 * xtal2         -------|___________/  6   |
+		 * sys_clk_undeleted --o|clkout1_sw1\____  |
+		 * if1_sw        -------|___________/  7 | |
+		 *                 ,-;==================='-'
+		 *                 | |   ___________
+		 * adcpll_clk    --|-|-o|clkout1_sw2\______
+		 * clkout1_sw1     `-|--|___________/  8   |
+		 *                  _|_____________________|
+		 *                 | |   ___________
+		 * clkout1_sw0     | `-o|clkout1_sw3\___________
+		 * clkout1_sw2     `----|___________/  9
+		 * xtal1         ------o| i2s_sw2   \______
+		 * sys_clk_undeleted ---|___________/ 10   |
+		 * xtal2         ------o| i2s_sw0   \____  |
+		 * adcpll_clk    -------|___________/ 11 | |
+		 *                 ,-;==================='-'
+		 *                 | |   ___________
+		 * i2s_sw2         | `-o| i2s_sw1   \___________
+		 * i2s_sw0         `----|___________/ 12
+		 * xtal1         ------o| scb_sw    \___________
+		 * sys_clk_undeleted ---|___________/ 13
+		 * xtal1         ------o| uart_sw   \___________
+		 * sys_clk_undeleted ---|___________/ 14
+		 * xtal1         ------o|ext_stc0_sw\___________
+		 * xtal2         -------|___________/ 16
+		 * xtal1         ------o|ext_stc1_sw\___________
+		 * xtal2         -------|___________/ 17
+		 * adcpll_clk    ------o|  usb_sw0  \______
+		 * afe_progdiv3_to_soc -|___________/ 18   |
+		 *                    _____________________|
+		 *                   |   ___________
+		 * usb_sw3         ,-|-o|  usb_sw1  \___________
+		 * usb_sw0         | `--|___________/ 19
+		 * xtal1         --|---o|  afe_sw0  \___________
+		 * afe_sw1       ,-|----|___________/ 20
+		 *               `-`=======================:-.
+		 *                       ___________       | |
+		 * adcpll_en     ------o|  afe_sw1  \______| |
+		 * xtal2         -------|___________/ 21     |
+		 * xtal1         ------o|adcpll_sw0 \________|__
+		 * xtal2         -------|___________/ 22     |
+		 * xtal1         ------o|adcpll_sw1 \______  |
+		 * xtal2         -------|___________/ 23   | |
+		 *                    _____________________| |
+		 *                   |   ___________         |
+		 * adcpll_en     ----|-o|adcpll_sw2 \________|__
+		 * adcpll_sw1        `--|___________/ 24     |
+		 *                                           |
+		 *                       ___________         |
+		 * sys_clk_undeleted ---|adcpll_sw3 \________|__
+		 * adcpll_clk    -------|___________/ 25     |
+		 * xtal1         -------|  usb_sw2  \______  |
+		 * xtal2         -------|___________/ 28   | |
+		 *                    _____________________| |
+		 *                   |   ___________         |
+		 * usb_sw2           `--|  usb_sw3  \________|
+		 * sys_clk_undeleted ---|___________/ 29
+		 */
+		top_clkswitch: top_clkswitch {
+			compatible = "img,tz1090-mux-bank";
+			#clock-cells = <1>;
+			reg = <0x02005908 0x4>;	/* CR_TOP_CLKSWITCH */
+			bit-mask = <0x33ff7fff>;
+			clock-output-names =
+				"sysclk0_sw",
+				"sys_clk_x2_undeleted",
+				"out0_sw0",
+				"out0_sw1",
+				"out0_sw2",
+				"out0_sw3",
+				"out1_sw0",
+				"out1_sw1",
+				"out1_sw2",
+				"out1_sw3",
+				"i2s_sw2",
+				"i2s_sw0",
+				"i2s_sw1",
+				"scb_sw",
+				"uart_sw",
+				"ext_stc0_sw",
+				"ext_stc1_sw",
+				"usb_sw0",
+				"usb_sw1",
+				"afe_sw0",
+				"afe_sw1",
+				"adcpll_sw0",
+				"adcpll_sw1",
+				"adcpll_sw2",
+				"adcpll_sw3",
+				"usb_sw2",
+				"usb_sw3";
+			clocks =
+				<&xtal1>,		<&xtal2>,
+				<&xtal1>,		<&sys_clk_div>,
+				<&xtal1>,		<CLK_AFE_PROGDIV1_TO_SOC>,
+				<&sys_clk_undeleted>,	<CLK_IF0_SW>,
+				<CLK_OUT0_SW0>,		<&xtal2>,
+				<CLK_OUT0_SW2>,		<CLK_OUT0_SW1>,
+				<&xtal1>,		<&xtal2>,
+				<&sys_clk_undeleted>,	<CLK_IF1_SW>,
+				<&adcpll_clk>,		<CLK_OUT1_SW1>,
+				<CLK_OUT1_SW0>,		<CLK_OUT1_SW2>,
+				<&xtal1>,		<&sys_clk_undeleted>,
+				<&xtal2>,		<&adcpll_clk>,
+				<CLK_I2S_SW2>,		<CLK_I2S_SW0>,
+				<&xtal1>,		<&sys_clk_undeleted>,
+				<&xtal1>,		<&sys_clk_undeleted>,
+				<&xtal1>,		<&xtal2>,
+				<&xtal1>,		<&xtal2>,
+				<&adcpll_clk>,		<CLK_AFE_PROGDIV3_TO_SOC>,
+				<CLK_USB_SW3>,		<CLK_USB_SW0>,
+				<&xtal1>,		<CLK_AFE_SW1>,
+				<CLK_ADCPLL_EN>,	<&xtal2>,
+				<&xtal1>,		<&xtal2>,
+				<&xtal1>,		<&xtal2>,
+				<CLK_ADCPLL_EN>,	<CLK_ADCPLL_SW1>,
+				<&sys_clk_undeleted>,	<&adcpll_clk>,
+				<&xtal1>,		<&xtal2>,
+				<CLK_USB_SW2>,		<&sys_clk_undeleted>;
+		};
+
+		/*
+		 * CR_TOP_CLKSWITCH2
+		 *                            ___________
+		 * xtal1              ------o| pixel_sw0 \______
+		 * pixel_sw3            ,----|___________/  0   |
+		 * sys_clk_undeleted  --+---o| pixel_sw1 \____  |
+		 * pixel_sw4            | ,--|___________/  1 | |
+		 *                      `-`===================|=|=:-.
+		 *                      ,-;==================='-' | |
+		 *                      | |   ___________         | |
+		 * pixel_sw0            | `-o| pixel_sw2 \________|_|___
+		 * pixel_sw1            `----|___________/  2     | |
+		 * adcpll_clk         ------o| pixel_sw3 \________| |
+		 * afe_progdiv3_to_soc ------|___________/  3       |
+		 * usb_phy_clk        ------o| pixel_sw4 \__________|
+		 * xtal2              -------|___________/  4
+		 * iqadc_sync_to_soc  ------o| if1_sw1   \______________
+		 * ext_adc_dac        --+----|___________/  5
+		 * afe_rxsync_to_soc  --|---o| if0_sw    \______________
+		 * ext_adc_dac          |`---|___________/  6
+		 * afe_txsync_to_soc  --|---o| dac0_sw   \______________
+		 * ext_adc_dac          `----|___________/  8
+		 * ucc1_clk_del       ------o| ucc1_sw   \______________
+		 * ucc0_clk_del       --+----|___________/  9
+		 * ucc0_clk_del         `---o| ucc0_sw   \______________
+		 * sys_clk            -------|___________/  10
+		 */
+		top_clkswitch2: top_clkswitch2 {
+			compatible = "img,tz1090-mux-bank";
+			#clock-cells = <1>;
+			reg = <0x02005988 0x4>;	/* CR_TOP_CLKSWITCH2 */
+			bit-mask = <0x0000077f>;
+			clock-output-names =
+				"pixel_sw0",
+				"pixel_sw1",
+				"pixel_sw2",
+				"pixel_sw3",
+				"pixel_sw4",
+				"if1_sw1",
+				"if0_sw",
+				"dac0_sw",
+				"ucc1_sw",
+				"ucc0_sw";
+			clocks =
+				<&xtal1>,		<CLK_PIXEL_SW3>,
+				<&sys_clk_undeleted>,	<CLK_PIXEL_SW4>,
+				<CLK_PIXEL_SW0>,	<CLK_PIXEL_SW1>,
+				<&adcpll_clk>,		<&afe_progdiv3_to_soc>,
+				<&usb_phy_clk>,		<&xtal2>,
+				<CLK_IQADC_SYNC_TO_SOC>,<&ext_adc_dac>,
+				<CLK_AFE_RXSYNC_TO_SOC>,<&ext_adc_dac>,
+				<CLK_AFE_TXSYNC_TO_SOC>,<&ext_adc_dac>,
+				<&ucc1_clk_del>,	<&ucc0_clk_del>,
+				<&ucc0_clk_del>,	<&sys_clk>;
+		};
+
+		/*
+		 * ============ TOP LEVEL CLOCK GATES ============
+		 */
+
+		/*
+		 * CR_TOP_CLKENAB
+		 */
+		top_clkenab: top_clkenab {
+			compatible = "img,tz1090-gate-bank";
+			#clock-cells = <1>;
+			reg = <0x0200590c 0x4>;	/* CR_TOP_CLKENAB */
+			bit-mask = <0x020b7220>;
+			clock-output-names =
+				"out0_en",
+				"out1_en",
+				"i2s_en",
+				"scb_en",
+				"uart_en",
+				"ext_stc1_en",
+				"ext_stc1_en",
+				"usb_en",
+				"adcpll_en";
+			clocks =
+				<CLK_OUT0_SW3>,
+				<CLK_OUT1_SW3>,
+				<CLK_I2S_SW1>,
+				<CLK_SCB_SW>,
+				<CLK_UART_SW>,
+				<CLK_ESTC0_SW>,
+				<CLK_ESTC1_SW>,
+				<CLK_USB_SW1>,
+				<CLK_ADCPLL_SW3>;
+		};
+
+		/*
+		 * CR_TOP_CLKENAB2
+		 */
+		top_clkenab2: top_clkenab2 {
+			compatible = "img,tz1090-gate-bank";
+			#clock-cells = <1>;
+			reg = <0x0200598c 0x4>;	/* CR_TOP_CLKENAB2 */
+			bit-mask = <0x000007e4>;
+			clock-output-names =
+				"pixel_en",
+				"if1_en",
+				"if0_en",
+				"ext_adc_dac_en",
+				"dac0_en",
+				"ucc1_en",
+				"ucc0_en";
+			clocks =
+				<CLK_PIXEL_SW2>,
+				<CLK_IF1_SW>,
+				<CLK_IF0_SW>,
+				<&ext_adc_dac>,
+				<CLK_DAC0_SW>,
+				<CLK_UCC1_SW>,
+				<CLK_UCC0_SW>;
+		};
+
+		/*
+		 * ============ PLL CLOCKS ============
+		 */
+
+		/* sysclk0_sw ---[sys_pll]--- */
+		sys_pll: sys_pll {
+			compatible = "img,tz1090-pll";
+			#clock-cells = <0>;
+			clocks = <CLK_SYSCLK0_SW>;
+			reg = <0x02005950 0x8>;	/* CR_TOP_SYSPLL_CTL{0,1} */
+			clock-output-names = "sys_pll";
+		};
+
+		/* adcpll_sw0 ---[adcpll]--- */
+		adcpll_clk: adcpll_clk {
+			compatible = "img,tz1090-pll";
+			#clock-cells = <0>;
+			clocks = <CLK_ADCPLL_SW0>;
+			reg = <0x02005958 0x8>;	/* CR_TOP_ADCPLL_CTL{0,1} */
+			clock-output-names = "adcpll";
+		};
+
+		/*
+		 * ============ CLOCK DELETERS ============
+		 */
+
+		/* sys_clk_undeleted ---[clkdelete]--- sys_clk */
+		sys_clk: sys_clk_del {
+			compatible = "img,tz1090-deleter";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005910 0x4>;	/* CR_TOP_CLKDELETE */
+			bit-mask = <0x000003ff>; /* CR_TOP_CLKDELETE */
+			clock-output-names = "sys";
+		};
+
+		/* sys_clk_x2_undeleted ---[meta_clkdelete]--- meta_core_clk */
+		meta_core_clk: meta_clk_del {
+			compatible = "img,tz1090-deleter";
+			#clock-cells = <0>;
+			clocks = <CLK_SYSCLK_X2_UNDELETED>;
+			reg = <0x0200591c 0x4>;	/* CR_TOP_META_CLKDELETE */
+			bit-mask = <0x000003ff>; /* CR_TOP_META_CLKDELETE */
+			clock-output-names = "meta";
+		};
+
+		/* sys_clk_undeleted ---[clkdelete]--- ucc0_clk_del */
+		ucc0_clk_del: uccp0_clk_del {
+			compatible = "img,tz1090-deleter";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x020059a4 0x4>;	/* CR_TOP_UCC0_CLKDELETE */
+			bit-mask = <0x000003ff>; /* CR_TOP_UCC0_CLKDELETE */
+			clock-output-names = "ucc0";
+		};
+
+		/* sys_clk_undeleted ---[clkdelete]--- ucc1_clk_del */
+		ucc1_clk_del: uccp1_clk_del {
+			compatible = "img,tz1090-deleter";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x020059a8 0x4>;	/* CR_TOP_UCC1_CLKDELETE */
+			bit-mask = <0x000003ff>; /* CR_TOP_UCC1_CLKDELETE */
+			clock-output-names = "ucc1";
+		};
+
+		/*
+		 * ============ CLOCK DIVIDERS ============
+		 */
+
+		/* sys_pll ---[sys_clk_div]--- */
+		sys_clk_div: sys_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_pll>;
+			reg = <0x02005914 0x4>;	/* CR_TOP_SYSCLK_DIV */
+			bit-mask = <0xff>;	/* CR_TOP_SYSDIV */
+			clock-output-names = "sys_div";
+		};
+
+		/* sys_clk_x2_undeleted ---[meta_clk_div]--- sys_clk_undeleted */
+		sys_clk_undeleted: meta_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_SYSCLK_X2_UNDELETED>;
+			reg = <0x02005918 0x4>;	/* CR_TOP_META_CLKDIV */
+			bit-mask = <0x3>;	/* CR_TOP_META_X2_EN */
+			clock-output-names = "sys_clk_undeleted";
+		};
+
+		/* afe_sw0 ---[afe_clk_div]--- afe_clk */
+		afe_clk: afe_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_AFE_SW0>;
+			reg = <0x02005920 0x4>;	/* CR_TOP_AFE_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "afe";
+		};
+
+		/* adcpll_sw2 ---[adcpll_clk_div]--- adcpll_div */
+		adcpll_div: adcpll_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_ADCPLL_SW2>;
+			reg = <0x02005924 0x4>;	/* CR_TOP_ADCPLL_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "adcpll_div";
+		};
+
+		/* uart_en ---[uart_clk_div]--- uart_clk */
+		uart_clk: uart_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_UART_EN>;
+			reg = <0x02005928 0x4>;	/* CR_TOP_UARTCLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "uart";
+		};
+
+		/* sys_clk_undeleted ---[pdm_clk_div]--- pdm_clk */
+		pdm_clk: pdm_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005930 0x4>;	/* CR_TOP_PDMCK_CTL */
+			bit-mask = <0x7>;
+			clock-output-names = "pdm";
+		};
+
+		/* sys_clk_undeleted ---[spi0_clk_div]--- spi0_clk */
+		spi0_clk: spi0_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005934 0x4>;	/* CR_TOP_SPICLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "spi0";
+		};
+
+		/* sys_clk_undeleted ---[spi1_clk_div]--- spi1_clk */
+		spi1_clk: spi1_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005938 0x4>;	/* CR_TOP_SPI1CLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "spi1";
+		};
+
+		/* i2s_en ---[i2sm_clk_div]--- i2sm */
+		i2sm_clk: i2sm_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_I2S_EN>;
+			reg = <0x0200593c 0x4>;	/* CR_TOP_I2SCLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "i2sm";
+		};
+
+		/* usb_en ---[usbpll_clk_div]--- usb_phy_clk */
+		usb_phy_clk: usbpll_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_USB_EN>;
+			reg = <0x02005940 0x4>;	/* CR_TOP_USB_PLLDIV */
+			bit-mask = <0xff>;
+			clock-output-names = "usb_phy";
+		};
+
+		/* sys_clk_undeleted ---[sdhost_clk_div]--- sdhost_clk */
+		sdhost_clk: sdhost_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005944 0x4>;	/* CR_TOP_SDHOSTCLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "sdhost";
+		};
+
+		/* sys_clk_undeleted ---[ring_osc_clk_div]--- ring_osc_clk */
+		ring_osc_clk: ring_osc_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005948 0x4>;	/* CR_TOP_RING_OP_DIV */
+			bit-mask = <0xf>;
+			clock-output-names = "ring_osc";
+		};
+
+		/* i2sm_clk ---[i2s_clk_div2]--- i2s_clk */
+		i2s_clk: i2s_clk_div2 {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&i2sm_clk>;
+			reg = <0x02005990 0x4>;	/* CR_TOP_I2S_DIV2 */
+			bit-mask = <0xff>;
+			clock-output-names = "i2s";
+		};
+
+		/* sys_clk_undeleted ---[meta_trace_clk_div]--- meta_trace_clk */
+		meta_trace_clk: meta_trace_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <&sys_clk_undeleted>;
+			reg = <0x02005994 0x4>;	/* CR_TOP_META_TRACE_CLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "meta_trace";
+		};
+
+		/* pixel_en ---[pixel_clk_div]--- pixel_clk */
+		pixel_clk: pixel_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_PIXEL_EN>;
+			reg = <0x02005998 0x4>;	/* CR_TOP_PIXEL_CLK_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "pixel";
+		};
+
+		/* clkout0_en ---[clkout0_clk_div]--- clkout0 */
+		clkout0: clkout0_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_OUT0_EN>;
+			reg = <0x0200599c 0x4>;	/* CR_TOP_CLKOUT0_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "out0";
+		};
+
+		/* clkout1_en ---[clkout1_clk_div]--- clkout1 */
+		clkout1: clkout1_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_OUT1_EN>;
+			reg = <0x020059a0 0x4>;	/* CR_TOP_CLKOUT1_DIV */
+			bit-mask = <0xff>;
+			clock-output-names = "out1";
+		};
+
+		/* ddr_en ---[ddr_clk_div]--- ddr_clk */
+		ddr_clk: ddr_clk_div {
+			compatible = "img,tz1090-divider";
+			#clock-cells = <0>;
+			clocks = <CLK_DDR_EN>;
+			reg = <0x020059ac 0x4>;	/* CR_TOP_DDR_CLKDIV */
+			bit-mask = <0xff>;
+			clock-output-names = "ddr";
+		};
+
+		/*
+		 * ============ PERIPHERAL SYSTEM CLOCK GATES ============
+		 *
+		 * CR_PERIP_CLKEN
+		 *
+		 * sys_clk ---[CR_PERIP_*_SYS_CLK_EN]--- sys_*
+		 */
+		perip_clken: perip_clken {
+			compatible = "img,tz1090-gate-bank";
+			#clock-cells = <1>;
+			reg = <0x02004010 0x4>;	/* CR_PERIP_CLKEN */
+			bit-mask = <0x00003fff>;
+			clock-output-names =
+				"sys_scb0",
+				"sys_scb1",
+				"sys_scb2",
+				"sys_sdio",
+				"sys_uart0",
+				"sys_uart1",
+				"sys_spim",
+				"sys_spis",
+				"sys_spim1",
+				"sys_i2sout",
+				"sys_i2sin",
+				"sys_lcd",
+				"sys_sdhost",
+				"sys_usb";
+			clocks =
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>,
+				<&sys_clk>;
+		};
+
+		/*
+		 * ============ HIGH END PERIPHERAL SYSTEM CLOCK GATES ============
+		 *
+		 * CR_HEP_CLK_EN
+		 *
+		 * sys_clk              -+--[CR_2D_CLK_EN     ]--- 0 sys_2d
+		 * sys_clk_x2_undeleted -|--[CR_DDR_CLK_EN    ]--- 1 ddr_en
+		 * sys_clk               `--[CR_PDP_PDI_CLK_EN]--- 2 sys_pdp
+		 */
+		hep_clken: hep_clken {
+			compatible = "img,tz1090-gate-bank";
+			#clock-cells = <1>;
+			reg = <0x02008c04 0x4>;	/* CR_HEP_CLK_EN */
+			bit-mask = <0x00000007>;
+			clock-output-names =
+				"sys_2d",
+				"ddr_en",
+				"sys_pdp";
+			clocks =
+				<&sys_clk>,
+				<CLK_SYSCLK_X2_UNDELETED>,
+				<&sys_clk>;
+		};
+	};
+};
-- 
2.0.4

