Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3FBXAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:00:54 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40157 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab3FBXAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:00:45 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 08/10] clk: add basic Rockchip rk3066a clock support
Date: Mon, 3 Jun 2013 01:00:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de>
In-Reply-To: <201306030055.15413.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306030100.31647.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds basic support for clocks on Rockchip rk3066 SoCs.
The clock handling thru small dt nodes is heavily inspired by the
sunxi clk code.

The clock specifiers are named as "x-cortex-a9-x", because the clock
semantics are the same thru the whole cortex-a9 series (rk30xx,
rk3188, rk2928; but not the other rk29 SoCs, which are Cortex-A8 based).

The plls are currently read-only, as their setting needs more
investigation. This also results in slow cpu speeds.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/boot/dts/rk3066a-clocks.dtsi   |  459 +++++++++++++++++++++++++++++++
 drivers/clk/Makefile                    |    1 +
 drivers/clk/rockchip/Makefile           |    6 +
 drivers/clk/rockchip/clk-rockchip-pll.c |  131 +++++++++
 drivers/clk/rockchip/clk-rockchip-pll.h |   19 ++
 drivers/clk/rockchip/clk-rockchip.c     |  315 +++++++++++++++++++++
 include/linux/clk/rockchip.h            |   21 ++
 7 files changed, 952 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/rk3066a-clocks.dtsi
 create mode 100644 drivers/clk/rockchip/Makefile
 create mode 100644 drivers/clk/rockchip/clk-rockchip-pll.c
 create mode 100644 drivers/clk/rockchip/clk-rockchip-pll.h
 create mode 100644 drivers/clk/rockchip/clk-rockchip.c
 create mode 100644 include/linux/clk/rockchip.h

diff --git a/arch/arm/boot/dts/rk3066a-clocks.dtsi b/arch/arm/boot/dts/rk3066a-clocks.dtsi
new file mode 100644
index 0000000..5e0614a
--- /dev/null
+++ b/arch/arm/boot/dts/rk3066a-clocks.dtsi
@@ -0,0 +1,459 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/ {
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * This is a dummy clock, to be used as placeholder on
+		 * other mux clocks when a specific parent clock is not
+		 * yet implemented. It should be dropped when the driver
+		 * is complete.
+		 */
+		dummy: dummy {
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+		};
+
+		xin24m: xin24m {
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+
+		apll: apll@20000000 {
+			compatible = "rockchip,rk3066a-apll";
+			reg = <0x20000000 0x10>,
+			      <0x20000040 0x04>;
+			clocks = <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		dpll: dpll@20000000 {
+			compatible = "rockchip,rk3066a-dpll";
+			reg = <0x20000010 0x10>,
+			      <0x20000040 0x04>;
+			clocks = <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		cpll: cpll@20000000 {
+			compatible = "rockchip,rk3066a-cpll";
+			reg = <0x20000020 0x10>,
+			      <0x20000040 0x04>;
+			clocks = <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		gpll: gpll@20000000 {
+			compatible = "rockchip,rk3066a-gpll";
+			reg = <0x20000030 0x10>,
+			      <0x20000040 0x04>;
+			clocks = <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		mux_aclk_periph: mux-aclk-periph@2000006c {
+			compatible = "rockchip,cortex-a9-gpll-cpll-bit15-mux";
+			reg = <0x2000006c 0x04>;
+			clocks = <&gpll>, <&cpll>;
+			#clock-cells = <0>;
+		};
+
+		mux_uart_pll: mux-uart_pll@20000074 {
+			compatible = "rockchip,cortex-a9-gpll-cpll-bit15-mux";
+			reg = <0x20000074 0x04>;
+			clocks = <&gpll>, <&cpll>;
+			#clock-cells = <0>;
+		};
+
+		div_uart0: div-uart0@20000078 {
+			compatible = "rockchip,cortex-a9-uart-divider";
+			reg = <0x20000078 0x04>;
+			clocks = <&mux_uart_pll>;
+			#clock-cells = <0>;
+		};
+
+		mux_uart0: mux-uart0@20000078 {
+			compatible = "rockchip,cortex-a9-uart-mux";
+			reg = <0x20000078 0x04>;
+			clocks = <&clk_gates1 8>, <&dummy>, <&xin24m>; /* dummy is uart0_frac_div */
+			#clock-cells = <0>;
+		};
+
+		div_uart1: div-uart1@2000007c {
+			compatible = "rockchip,cortex-a9-uart-divider";
+			reg = <0x2000007c 0x04>;
+			clocks = <&mux_uart_pll>;
+			#clock-cells = <0>;
+		};
+
+		mux_uart1: mux-uart1@2000007c {
+			compatible = "rockchip,cortex-a9-uart-mux";
+			reg = <0x2000007c 0x04>;
+			clocks = <&clk_gates1 10>, <&dummy>, <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		div_uart2: div-uart2@20000080 {
+			compatible = "rockchip,cortex-a9-uart-divider";
+			reg = <0x20000080 0x04>;
+			clocks = <&mux_uart_pll>;
+			#clock-cells = <0>;
+		};
+
+		mux_uart2: mux-uart2@20000080 {
+			compatible = "rockchip,cortex-a9-uart-mux";
+			reg = <0x20000080 0x04>;
+			clocks = <&clk_gates1 12>, <&dummy>, <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		div_uart3: div-uart3@20000084 {
+			compatible = "rockchip,cortex-a9-uart-divider";
+			reg = <0x20000084 0x04>;
+			clocks = <&mux_uart_pll>;
+			#clock-cells = <0>;
+		};
+
+		mux_uart3: mux-uart3@20000084 {
+			compatible = "rockchip,cortex-a9-uart-mux";
+			reg = <0x20000084 0x04>;
+			clocks = <&clk_gates1 14>, <&dummy>, <&xin24m>;
+			#clock-cells = <0>;
+		};
+
+		mux_cpu: mux-cpu@20000044 {
+			compatible = "rockchip,cortex-a9-cpu-mux";
+			reg = <0x20000044 0x4>;
+			clocks = <&apll>, <&dummy> /* cpu_gpll_path */;
+			#clock-cells = <0>;
+		};
+
+		div_cpu: div-cpu@20000044 {
+			compatible = "rockchip,cortex-a9-cpu-divider";
+			reg = <0x20000044 0x4>;
+			clocks = <&mux_cpu>;
+			#clock-cells = <0>;
+		};
+
+		div_aclk_cpu: div-aclk-cpu@20000048 {
+			compatible = "rockchip,cortex-a9-aclk-cpu-divider";
+			reg = <0x20000048 0x4>;
+			clocks = <&div_cpu>;
+			#clock-cells = <0>;
+		};
+
+		div_aclk_periph: div-aclk-periph@2000006c {
+			compatible = "rockchip,cortex-a9-hclk-divider";
+			reg = <0x2000006c 0x4>;
+			clocks = <&mux_aclk_periph>;
+			#clock-cells = <0>;
+		};
+
+		div_hclk_periph: div-hclk-periph@2000006c {
+			compatible = "rockchip,cortex-a9-hclk-divider";
+			reg = <0x2000006c 0x4>;
+			clocks = <&clk_gates2 1>;
+			#clock-cells = <0>;
+		};
+
+		div_pclk_periph: div-pclk-periph@2000006c {
+			compatible = "rockchip,cortex-a9-pclk-divider";
+			reg = <0x2000006c 0x4>;
+			clocks = <&clk_gates2 1>;
+			#clock-cells = <0>;
+		};
+
+		div_hclk_cpu: div-hclk-cpu@20000048 {
+			compatible = "rockchip,cortex-a9-hclk-divider";
+			reg = <0x20000048 0x4>;
+			clocks = <&clk_gates0 3>;
+			#clock-cells = <0>;
+		};
+
+		div_pclk_cpu: div-pclk-cpu@20000048 {
+			compatible = "rockchip,cortex-a9-pclk-divider";
+			reg = <0x20000048 0x4>;
+			clocks = <&clk_gates0 3>;
+			#clock-cells = <0>;
+		};
+
+		div_mmc0: div-mmc0@20000070 {
+			compatible = "rockchip,cortex-a9-mmc-divider";
+			reg = <0x20000070 0x4>;
+			clocks = <&clk_gates2 2>;
+			#clock-cells = <0>;
+		};
+
+		div_mmc1: div-mmc1@20000074 {
+			compatible = "rockchip,cortex-a9-mmc-divider";
+			reg = <0x20000074 0x4>;
+			clocks = <&clk_gates2 2>;
+			#clock-cells = <0>;
+		};
+
+		clk_gates0: gate-clk@200000d0 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000d0 0x4>;
+			clocks = <&dummy>, <&dummy>,
+				 <&dummy>, <&div_aclk_cpu>,
+				 <&div_hclk_cpu>, <&div_pclk_cpu>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>;
+
+			clock-output-names =
+				"gate_core_periph", "gate_cpu_gpll",
+				"gate_ddrphy", "gate_aclk_cpu",
+				"gate_hclk_cpu", "gate_pclk_cpu",
+				"gate_atclk_cpu", "gate_i2s0",
+				"gate_i2s0_frac", "gate_i2s1",
+				"gate_i2s1_frac", "gate_i2s2",
+				"gate_i2s2_frac", "gate_spdif",
+				"gate_spdif_frac", "gate_testclk";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates1: gate-clk@200000d4 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000d4 0x4>;
+			clocks = <&xin24m>, <&xin24m>,
+				 <&xin24m>, <&dummy>,
+				 <&dummy>, <&xin24m>,
+				 <&xin24m>, <&dummy>,
+				 <&div_uart0>, <&dummy>,
+				 <&div_uart1>, <&dummy>,
+				 <&div_uart2>, <&dummy>,
+				 <&div_uart3>, <&dummy>;
+
+			clock-output-names =
+				"gate_timer0", "gate_timer1",
+				"gate_timer2", "gate_jtag",
+				"gate_aclk_lcdc1_src", "gate_otgphy0",
+				"gate_otgphy1", "gate_ddr_gpll",
+				"gate_uart0", "gate_frac_uart0",
+				"gate_uart1", "gate_frac_uart1",
+				"gate_uart2", "gate_frac_uart2",
+				"gate_uart3", "gate_frac_uart3";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates2: gate-clk@200000d8 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000d8 0x4>;
+			clocks = <&clk_gates2 1>, <&div_aclk_periph>,
+				 <&div_hclk_periph>, <&div_pclk_periph>,
+				 <&dummy>, <&dummy>,
+				 <&clk_gates2 3>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&div_mmc0>,
+				 <&dummy>, <&div_mmc1>,
+				 <&dummy>, <&dummy>;
+
+			clock-output-names =
+				"gate_periph_src", "gate_aclk_periph",
+				"gate_hclk_periph", "gate_pclk_periph",
+				"gate_smc", "gate_mac",
+				"gate_hsadc", "gate_hsadc_frac",
+				"gate_saradc", "gate_spi0",
+				"gate_spi1", "gate_mmc0",
+				"gate_mac_lbtest", "gate_mmc1",
+				"gate_emmc", "gate_tsadc";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates3: gate-clk@200000dc {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000dc 0x4>;
+			clocks = <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&dummy>;
+
+			clock-output-names =
+				"gate_aclk_lcdc0_src", "gate_dclk_lcdc0",
+				"gate_dclk_lcdc1", "gate_pclkin_cif0",
+				"gate_pclkin_cif1", "reserved",
+				"reserved", "gate_cif0_out",
+				"gate_cif1_out", "gate_aclk_vepu",
+				"gate_hclk_vepu", "gate_aclk_vdpu",
+				"gate_hclk_vdpu", "gate_gpu_src",
+				"reserved", "gate_xin27m";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates4: gate-clk@200000e0 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000e0 0x4>;
+			clocks = <&clk_gates2 2>, <&clk_gates2 3>,
+				 <&clk_gates2 1>, <&clk_gates2 1>,
+				 <&clk_gates2 1>, <&clk_gates2 2>,
+				 <&clk_gates2 2>, <&clk_gates2 2>,
+				 <&clk_gates0 4>, <&clk_gates0 4>,
+				 <&clk_gates0 3>, <&clk_gates0 3>,
+				 <&clk_gates0 3>, <&clk_gates2 3>,
+				 <&clk_gates0 4>;
+
+			clock-output-names =
+				"gate_hclk_peri_axi_matrix", "gate_pclk_peri_axi_matrix",
+				"gate_aclk_cpu_peri", "gate_aclk_peri_axi_matrix",
+				"gate_aclk_pei_niu", "gate_hclk_usb_peri",
+				"gate_hclk_peri_ahb_arbi", "gate_hclk_emem_peri",
+				"gate_hclk_cpubus", "gate_hclk_ahb2apb",
+				"gate_aclk_strc_sys", "gate_aclk_l2mem_con",
+				"gate_aclk_intmem", "gate_pclk_tsadc",
+				"gate_hclk_hdmi";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates5: gate-clk@200000e4 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000e4 0x4>;
+			clocks = <&clk_gates0 3>, <&clk_gates2 1>,
+				 <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates0 4>, <&clk_gates0 5>,
+				 <&clk_gates2 1>, <&clk_gates2 2>,
+				 <&clk_gates2 2>, <&clk_gates2 2>,
+				 <&clk_gates2 2>, <&clk_gates4 5>,
+				 <&clk_gates4 5>, <&dummy>;
+
+			clock-output-names =
+				"gate_aclk_dmac1", "gate_aclk_dmac2",
+				"gate_pclk_efuse", "gate_pclk_tzpc",
+				"gate_pclk_grf", "gate_pclk_pmu",
+				"gate_hclk_rom", "gate_pclk_ddrupctl",
+				"gate_aclk_smc", "gate_hclk_nandc",
+				"gate_hclk_mmc0", "gate_hclk_mmc1",
+				"gate_hclk_emmc", "gate_hclk_otg0",
+				"gate_hclk_otg1", "gate_aclk_gpu";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates6: gate-clk@200000e8 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000e8 0x4>;
+			clocks = <&clk_gates3 0>, <&clk_gates0 4>,
+				 <&clk_gates0 4>, <&clk_gates1 4>,
+				 <&clk_gates0 4>, <&clk_gates3 0>,
+				 <&clk_gates0 4>, <&clk_gates1 4>,
+				 <&clk_gates3 0>, <&clk_gates0 4>,
+				 <&clk_gates0 4>, <&clk_gates1 4>,
+				 <&clk_gates0 4>, <&clk_gates3 0>,
+				 <&dummy>, <&dummy>;
+
+			clock-output-names =
+				"gate_aclk_lcdc0", "gate_hclk_lcdc0",
+				"gate_hclk_lcdc1", "gate_aclk_lcdc1",
+				"gate_hclk_cif0", "gate_aclk_cif0",
+				"gate_hclk_cif1", "gate_aclk_cif1",
+				"gate_aclk_ipp", "gate_hclk_ipp",
+				"gate_hclk_rga", "gate_aclk_rga",
+				"gate_hclk_vio_bus", "gate_aclk_vio0",
+				"gate_aclk_vcodec", "gate_shclk_vio_h2h";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates7: gate-clk@200000ec {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000ec 0x4>;
+			clocks = <&clk_gates2 2>, <&clk_gates0 4>,
+				 <&clk_gates0 4>, <&clk_gates0 4>,
+				 <&clk_gates0 4>, <&clk_gates2 2>,
+				 <&clk_gates2 2>, <&clk_gates0 5>,
+				 <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates0 5>, <&clk_gates2 3>,
+				 <&clk_gates2 3>, <&clk_gates2 3>,
+				 <&clk_gates2 3>, <&clk_gates2 3>;
+
+			clock-output-names =
+				"gate_hclk_emac", "gate_hclk_spdif",
+				"gate_hclk_i2s0_2ch", "gate_hclk_i2s1_2ch",
+				"gate_hclk_i2s_8ch", "gate_hclk_hsadc",
+				"gate_hclk_pidf", "gate_pclk_timer0",
+				"gate_pclk_timer1", "gate_pclk_timer2",
+				"gate_pclk_pwm01", "gate_pclk_pwm23",
+				"gate_pclk_spi0", "gate_pclk_spi1",
+				"gate_pclk_saradc", "gate_pclk_wdt";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates8: gate-clk@200000f0 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000f0 0x4>;
+			clocks = <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates2 3>, <&clk_gates2 3>,
+				 <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates2 3>, <&clk_gates2 3>,
+				 <&clk_gates2 3>, <&clk_gates0 5>,
+				 <&clk_gates0 5>, <&clk_gates0 5>,
+				 <&clk_gates2 3>, <&clk_gates2 3>,
+				 <&dummy>, <&clk_gates0 5>;
+
+			clock-output-names =
+				"gate_pclk_uart0", "gate_pclk_uart1",
+				"gate_pclk_uart2", "gate_pclk_uart3",
+				"gate_pclk_i2c0", "gate_pclk_i2c1",
+				"gate_pclk_i2c2", "gate_pclk_i2c3",
+				"gate_pclk_i2c4", "gate_pclk_gpio0",
+				"gate_pclk_gpio1", "gate_pclk_gpio2",
+				"gate_pclk_gpio3", "gate_pclk_gpio4",
+				"reserved", "gate_pclk_gpio6";
+
+			#clock-cells = <1>;
+		};
+
+		clk_gates9: gate-clk@200000f4 {
+			compatible = "rockchip,cortex-a9-gates-clk";
+			reg = <0x200000f4 0x4>;
+			clocks = <&dummy>, <&clk_gates0 5>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>, <&clk_gates1 4>,
+				 <&clk_gates0 5>, <&dummy>,
+				 <&dummy>, <&dummy>,
+				 <&dummy>;
+
+			clock-output-names =
+				"gate_clk_core_dbg", "gate_pclk_dbg",
+				"gate_clk_trace", "gate_atclk",
+				"gate_clk_l2c", "gate_aclk_vio1",
+				"gate_pclk_publ", "gate_aclk_intmem0",
+				"gate_aclk_intmem1", "gate_aclk_intmem2",
+				"gate_aclk_intmem3";
+
+			#clock-cells = <1>;
+		};
+	};
+
+};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 3a26115..4063afc 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -24,6 +24,7 @@ ifeq ($(CONFIG_COMMON_CLK), y)
 obj-$(CONFIG_ARCH_MMP)		+= mmp/
 endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
+obj-$(CONFIG_ARCH_ROCKCHIP)	+= rockchip/
 obj-$(CONFIG_ARCH_SUNXI)	+= sunxi/
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
diff --git a/drivers/clk/rockchip/Makefile b/drivers/clk/rockchip/Makefile
new file mode 100644
index 0000000..e0fbafb
--- /dev/null
+++ b/drivers/clk/rockchip/Makefile
@@ -0,0 +1,6 @@
+#
+# Rockchip Clock specific Makefile
+#
+
+obj-y	+= clk-rockchip.o
+obj-y	+= clk-rockchip-pll.o
diff --git a/drivers/clk/rockchip/clk-rockchip-pll.c b/drivers/clk/rockchip/clk-rockchip-pll.c
new file mode 100644
index 0000000..4456445
--- /dev/null
+++ b/drivers/clk/rockchip/clk-rockchip-pll.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/div64.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-private.h>
+
+#define RK3X_PLL_MODE_MASK		0x3
+#define RK3X_PLL_MODE_SLOW		0x0
+#define RK3X_PLL_MODE_NORM		0x1
+#define RK3X_PLL_MODE_DEEP		0x2
+
+#define RK3X_PLLCON0_OD_MASK		0xf
+#define RK3X_PLLCON0_OD_SHIFT		0
+#define RK3X_PLLCON0_NR_MASK		0x3f
+#define RK3X_PLLCON0_NR_SHIFT		8
+
+#define RK3X_PLLCON1_NF_MASK		0x1fff
+#define RK3X_PLLCON1_NF_SHIFT		0
+
+#define RK3X_PLLCON3_REST		(1 << 5)
+#define RK3X_PLLCON3_BYPASS		(1 << 0)
+
+struct rockchip_clk_pll {
+	struct clk_hw		hw;
+	void __iomem		*reg_base;
+	void __iomem		*reg_mode;
+	unsigned int		shift_mode;
+	spinlock_t		*lock;
+};
+
+#define to_clk_pll(_hw) container_of(_hw, struct rockchip_clk_pll, hw)
+
+static unsigned long rk3x_generic_pll_recalc_rate(struct clk_hw *hw,
+				unsigned long parent_rate)
+{
+	struct rockchip_clk_pll *pll = to_clk_pll(hw);
+	u32 pll_con0 = readl_relaxed(pll->reg_base);
+	u32 pll_con1 = readl_relaxed(pll->reg_base + 0x4);
+	u32 pll_con3 = readl_relaxed(pll->reg_base + 0xc);
+	u32 mode_con = readl_relaxed(pll->reg_mode) >> pll->shift_mode;
+	u64 pll_nf;
+	u64 pll_nr;
+	u64 pll_no;
+	u64 rate64;
+
+	if (pll_con3 & RK3X_PLLCON3_BYPASS) {
+		pr_debug("%s: pll %s is bypassed\n", __func__,
+			__clk_get_name(hw->clk));
+		return parent_rate;
+	}
+
+	mode_con &= RK3X_PLL_MODE_MASK;
+	if (mode_con != RK3X_PLL_MODE_NORM) {
+		pr_debug("%s: pll %s not in normal mode: %d\n", __func__,
+			__clk_get_name(hw->clk), mode_con);
+		return parent_rate;
+	}
+
+	pll_nf = (pll_con1 >> RK3X_PLLCON1_NF_SHIFT);
+	pll_nf &= RK3X_PLLCON1_NF_MASK;
+	pll_nf++;
+	rate64 = (u64)parent_rate * pll_nf;
+
+	pll_nr = (pll_con0 >> RK3X_PLLCON0_NR_SHIFT);
+	pll_nr &= RK3X_PLLCON0_NR_MASK;
+	pll_nr++;
+	do_div(rate64, pll_nr);
+
+	pll_no = (pll_con0 >> RK3X_PLLCON0_OD_SHIFT);
+	pll_no &= RK3X_PLLCON0_OD_MASK;
+	pll_no++;
+	do_div(rate64, pll_no);
+
+	return (unsigned long)rate64;
+}
+
+static const struct clk_ops rk3x_generic_pll_clk_ops = {
+	.recalc_rate = rk3x_generic_pll_recalc_rate,
+};
+
+struct clk * __init rockchip_clk_register_rk3x_pll(const char *name,
+			const char *pname, void __iomem *reg_base,
+			void __iomem *reg_mode, unsigned int shift_mode,
+			spinlock_t *lock)
+{
+	struct rockchip_clk_pll *pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll) {
+		pr_err("%s: could not allocate pll clk %s\n", __func__, name);
+		return NULL;
+	}
+
+	init.name = name;
+	init.ops = &rk3x_generic_pll_clk_ops;
+	init.flags = CLK_GET_RATE_NOCACHE;
+	init.parent_names = &pname;
+	init.num_parents = 1;
+
+	pll->hw.init = &init;
+	pll->reg_base = reg_base;
+	pll->reg_mode = reg_mode;
+	pll->shift_mode = shift_mode;
+	pll->lock = lock;
+
+	clk = clk_register(NULL, &pll->hw);
+	if (IS_ERR(clk)) {
+		pr_err("%s: failed to register pll clock %s\n", __func__,
+				name);
+		kfree(pll);
+	}
+
+	return clk;
+}
diff --git a/drivers/clk/rockchip/clk-rockchip-pll.h b/drivers/clk/rockchip/clk-rockchip-pll.h
new file mode 100644
index 0000000..a63288a
--- /dev/null
+++ b/drivers/clk/rockchip/clk-rockchip-pll.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+extern struct clk * __init rockchip_clk_register_rk3x_pll(const char *name,
+			const char *pname, const void __iomem *reg_base,
+			const void __iomem *reg_mode, unsigned int shift_mode,
+			spinlock_t *lock);
diff --git a/drivers/clk/rockchip/clk-rockchip.c b/drivers/clk/rockchip/clk-rockchip.c
new file mode 100644
index 0000000..3d7e0b2
--- /dev/null
+++ b/drivers/clk/rockchip/clk-rockchip.c
@@ -0,0 +1,315 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/rockchip.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "clk-rockchip-pll.h"
+
+static DEFINE_SPINLOCK(clk_lock);
+
+struct rockchip_pll_data {
+	int mode_shift;
+};
+
+struct rockchip_pll_data rk3066a_apll_data = {
+	.mode_shift = 0,
+};
+
+struct rockchip_pll_data rk3066a_dpll_data = {
+	.mode_shift = 4,
+};
+
+struct rockchip_pll_data rk3066a_cpll_data = {
+	.mode_shift = 8,
+};
+
+struct rockchip_pll_data rk3066a_gpll_data = {
+	.mode_shift = 12,
+};
+
+/* Matches for plls */
+static const __initconst struct of_device_id clk_pll_match[] = {
+	{ .compatible = "rockchip,rk3066a-apll", .data = &rk3066a_apll_data },
+	{ .compatible = "rockchip,rk3066a-dpll", .data = &rk3066a_dpll_data },
+	{ .compatible = "rockchip,rk3066a-cpll", .data = &rk3066a_cpll_data },
+	{ .compatible = "rockchip,rk3066a-gpll", .data = &rk3066a_gpll_data },
+	{}
+};
+
+static void __init rockchip_pll_setup(struct device_node *node,
+				      struct rockchip_pll_data *data)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	const char *clk_parent;
+	void __iomem *reg_base;
+	void __iomem *reg_mode;
+	u32 rate;
+
+	reg_base = of_iomap(node, 0);
+	reg_mode = of_iomap(node, 1);
+
+	clk_parent = of_clk_get_parent_name(node, 0);
+
+	pr_debug("%s: adding %s as child of %s\n",
+		__func__, clk_name, clk_parent);
+
+	clk = rockchip_clk_register_rk3x_pll(clk_name, clk_parent, reg_base,
+					     reg_mode, data->mode_shift,
+					     &clk_lock);
+	if (clk) {
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+		/* optionally set a target frequency for the pll */
+		if (!of_property_read_u32(node, "clock-frequency", &rate))
+			clk_set_rate(clk, rate);
+	}
+}
+
+/*
+ * Mux clocks
+ */
+
+struct rockchip_mux_data {
+	int shift;
+	int width;
+};
+
+#define RK_MUX(n, s, w)					\
+static const __initconst struct rockchip_mux_data n = {	\
+	.shift = s,					\
+	.width = w,					\
+}
+
+RK_MUX(gpll_cpll_15_mux_data, 15, 1);
+RK_MUX(uart_mux_data, 8, 2);
+RK_MUX(cpu_mux_data, 8, 1);
+
+static const __initconst struct of_device_id clk_mux_match[] = {
+	{ .compatible = "rockchip,cortex-a9-gpll-cpll-bit15-mux",
+		.data = &gpll_cpll_15_mux_data },
+	{ .compatible = "rockchip,cortex-a9-uart-mux",
+		.data = &uart_mux_data },
+	{ .compatible = "rockchip,cortex-a9-cpu-mux",
+		.data = &cpu_mux_data },
+	{}
+};
+
+static void __init rockchip_mux_clk_setup(struct device_node *node,
+					  struct rockchip_mux_data *data)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	int max_parents = (1 << data->width);
+	const char *parents[max_parents];
+	int flags;
+	int i = 0;
+
+	reg = of_iomap(node, 0);
+
+	while (i < max_parents &&
+	       (parents[i] = of_clk_get_parent_name(node, i)) != NULL)
+		i++;
+
+	flags = CLK_MUX_MASK_UPPER_HALF;
+
+	clk = clk_register_mux(NULL, clk_name, parents, i, 0,
+			       reg, data->shift, data->width,
+			       flags, &clk_lock);
+	if (clk)
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+
+/*
+ * Divider clocks
+ */
+
+struct rockchip_div_data {
+	int shift;
+	int width;
+	int max;
+	int flags;
+};
+
+#define RK_DIV(n, s, w, f)				\
+static const __initconst struct rockchip_div_data n = {	\
+	.shift = s,					\
+	.width = w,					\
+	.flags = f,					\
+}
+
+RK_DIV(cpu_div_data, 0, 5, 0);
+RK_DIV(aclk_periph_div_data, 0, 5, 0);
+RK_DIV(aclk_cpu_div_data, 0, 3, 0);
+RK_DIV(hclk_div_data, 8, 2, CLK_DIVIDER_POWER_OF_TWO);
+RK_DIV(pclk_div_data, 12, 2, CLK_DIVIDER_POWER_OF_TWO);
+RK_DIV(mmc_div_data, 0, 6, CLK_DIVIDER_EVEN);
+RK_DIV(uart_div_data, 0, 7, 0);
+
+static const __initconst struct of_device_id clk_divider_match[] = {
+	{ .compatible = "rockchip,cortex-a9-cpu-divider",
+		.data = &cpu_div_data },
+	{ .compatible = "rockchip,cortex-a9-aclk-periph-divider",
+		.data = &aclk_periph_div_data },
+	{ .compatible = "rockchip,cortex-a9-aclk-cpu-divider",
+		.data = &aclk_cpu_div_data },
+	{ .compatible = "rockchip,cortex-a9-hclk-divider",
+		.data = &hclk_div_data },
+	{ .compatible = "rockchip,cortex-a9-pclk-divider",
+		.data = &pclk_div_data },
+	{ .compatible = "rockchip,cortex-a9-mmc-divider",
+		.data = &mmc_div_data },
+	{ .compatible = "rockchip,cortex-a9-uart-divider",
+		.data = &uart_div_data },
+	{}
+};
+
+static void __init rockchip_divider_clk_setup(struct device_node *node,
+					      struct rockchip_div_data *data)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	const char *clk_parent;
+	void __iomem *reg;
+	int flags;
+
+	reg = of_iomap(node, 0);
+
+	clk_parent = of_clk_get_parent_name(node, 0);
+
+	flags = data->flags;
+	flags |= CLK_DIVIDER_MASK_UPPER_HALF;
+
+	clk = clk_register_divider(NULL, clk_name, clk_parent, 0,
+				   reg, data->shift, data->width,
+				   flags, &clk_lock);
+	if (clk)
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+
+/*
+ * Gate clocks
+ */
+
+static void __init rockchip_gate_clk_setup(struct device_node *node,
+					    void *data)
+{
+	struct clk_onecell_data *clk_data;
+	const char *clk_parent;
+	const char *clk_name;
+	void __iomem *reg;
+	void __iomem *reg_idx;
+	int flags;
+	int qty;
+	int reg_bit;
+	int clkflags = CLK_SET_RATE_PARENT;
+	int i;
+
+	qty = of_property_count_strings(node, "clock-output-names");
+	if (qty < 0) {
+		pr_err("%s: error in clock-output-names %d\n", __func__, qty);
+		return;
+	}
+
+	if (qty == 0) {
+		pr_info("%s: nothing to do\n", __func__);
+		return;
+	}
+
+	reg = of_iomap(node, 0);
+
+	clk_data = kzalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
+	if (!clk_data)
+		return;
+
+	clk_data->clks = kzalloc(qty * sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_data->clks) {
+		kfree(clk_data);
+		return;
+	}
+
+	flags = CLK_GATE_MASK_UPPER_HALF | CLK_GATE_SET_TO_DISABLE;
+
+	for (i = 0; i < qty; i++) {
+		of_property_read_string_index(node, "clock-output-names",
+					      i, &clk_name);
+
+		/* ignore empty slots */
+		if (!strcmp("reserved", clk_name))
+			continue;
+
+		clk_parent = of_clk_get_parent_name(node, i);
+
+		/* keep all gates untouched for now */
+		clkflags |= CLK_IGNORE_UNUSED;
+
+		reg_idx = reg + (4 * (i / 16));
+		reg_bit = (i % 16);
+
+		clk_data->clks[i] = clk_register_gate(NULL, clk_name,
+						      clk_parent, clkflags,
+						      reg_idx, reg_bit,
+						      flags,
+						      &clk_lock);
+		WARN_ON(IS_ERR(clk_data->clks[i]));
+	}
+
+	clk_data->clk_num = qty;
+
+	of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+}
+
+static const __initconst struct of_device_id clk_gate_match[] = {
+	{ .compatible = "rockchip,cortex-a9-gates-clk" },
+	{}
+};
+
+void __init of_rockchip_clk_table_clock_setup(
+					const struct of_device_id *clk_match,
+					void *function)
+{
+	struct device_node *np;
+	const struct div_data *data;
+	const struct of_device_id *match;
+	void (*setup_function)(struct device_node *, const void *) = function;
+
+	for_each_matching_node(np, clk_match) {
+		match = of_match_node(clk_match, np);
+		data = match->data;
+		setup_function(np, data);
+	}
+}
+
+void __init rockchip_init_clocks(void)
+{
+	of_clk_init(NULL);
+
+	of_rockchip_clk_table_clock_setup(clk_pll_match,
+					  rockchip_pll_setup);
+
+	of_rockchip_clk_table_clock_setup(clk_mux_match,
+					  rockchip_mux_clk_setup);
+
+	of_rockchip_clk_table_clock_setup(clk_gate_match,
+					  rockchip_gate_clk_setup);
+
+	of_rockchip_clk_table_clock_setup(clk_divider_match,
+					  rockchip_divider_clk_setup);
+}
diff --git a/include/linux/clk/rockchip.h b/include/linux/clk/rockchip.h
new file mode 100644
index 0000000..571721f
--- /dev/null
+++ b/include/linux/clk/rockchip.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_CLK_ROCKCHIP_H_
+#define __LINUX_CLK_ROCKCHIP_H_
+
+void __init rockchip_init_clocks(void);
+
+#endif
-- 
1.7.2.3

