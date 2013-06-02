Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3FBXCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:02:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40210 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab3FBXCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:02:32 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Date: Mon, 3 Jun 2013 01:02:20 +0200
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
Message-Id: <201306030102.20890.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic devicetree board file and a dtsi for boards
based on the RK3066a SoCs from Rockchip.

Apart from the generic parts (gic, clocks, pinctrl) the only components
currently supported are the timers, uarts and mmc ports (all DesignWare-
based).

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/Kconfig                     |    2 +
 arch/arm/Makefile                    |    1 +
 arch/arm/boot/dts/rk3066a.dtsi       |  359 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-rockchip/Kconfig       |   17 ++
 arch/arm/mach-rockchip/Makefile      |    1 +
 arch/arm/mach-rockchip/Makefile.boot |    3 +
 arch/arm/mach-rockchip/rockchip.c    |   54 +++++
 7 files changed, 437 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/rk3066a.dtsi
 create mode 100644 arch/arm/mach-rockchip/Kconfig
 create mode 100644 arch/arm/mach-rockchip/Makefile
 create mode 100644 arch/arm/mach-rockchip/Makefile.boot
 create mode 100644 arch/arm/mach-rockchip/rockchip.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ff580d3..ff892b1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -983,6 +983,8 @@ source "arch/arm/mach-mmp/Kconfig"
 
 source "arch/arm/mach-realview/Kconfig"
 
+source "arch/arm/mach-rockchip/Kconfig"
+
 source "arch/arm/mach-sa1100/Kconfig"
 
 source "arch/arm/plat-samsung/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 3380c4f..0153f60 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -172,6 +172,7 @@ machine-$(CONFIG_ARCH_PICOXCELL)	+= picoxcell
 machine-$(CONFIG_ARCH_PRIMA2)		+= prima2
 machine-$(CONFIG_ARCH_PXA)		+= pxa
 machine-$(CONFIG_ARCH_REALVIEW)		+= realview
+machine-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip
 machine-$(CONFIG_ARCH_RPC)		+= rpc
 machine-$(CONFIG_ARCH_S3C24XX)		+= s3c24xx
 machine-$(CONFIG_ARCH_S3C64XX)		+= s3c64xx
diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
new file mode 100644
index 0000000..2b42d26
--- /dev/null
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -0,0 +1,359 @@
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
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/pinctrl/rockchip.h>
+#include "skeleton.dtsi"
+#include "rk3066a-clocks.dtsi"
+
+/ {
+	compatible = "rockchip,rk30xx";
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+			reg = <0x0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+			reg = <0x1>;
+		};
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges;
+
+		gic: interrupt-controller@1013d000 {
+			compatible = "arm,cortex-a9-gic";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0x1013d000 0x1000>,
+			      <0x1013c100 0x0100>;
+		};
+
+		L2: l2-cache-controller@10138000 {
+			compatible = "arm,pl310-cache";
+			reg = <0x10138000 0x1000>;
+			cache-unified;
+			cache-level = <2>;
+		};
+
+		local-timer@1013c600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0x1013c600 0x20>;
+			interrupts = <GIC_PPI 13 0x304>;
+		};
+
+		timer@20038000 {
+			compatible = "snps,dw-apb-timer-osc";
+			reg = <0x20038000 0x100>;
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_gates1 0>, <&clk_gates7 7>;
+			clock-names = "timer", "pclk";
+		};
+
+		timer@2003a000 {
+			compatible = "snps,dw-apb-timer-osc";
+			reg = <0x2003a000 0x100>;
+			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_gates1 1>, <&clk_gates7 8>;
+			clock-names = "timer", "pclk";
+		};
+
+		timer@2000e000 {
+			compatible = "snps,dw-apb-timer-osc";
+			reg = <0x2000e000 0x100>;
+			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_gates1 2>, <&clk_gates7 9>;
+			clock-names = "timer", "pclk";
+		};
+
+		pinctrl@20008000 {
+			compatible = "rockchip,rk3066a-pinctrl";
+			reg = <0x20008000 0x150>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			gpio0: gpio0@20034000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x20034000 0x100>;
+				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 9>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			gpio1: gpio1@2003c000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x2003c000 0x100>;
+				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 10>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			gpio2: gpio2@2003e000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x2003e000 0x100>;
+				interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 11>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			gpio3: gpio3@20080000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x20080000 0x100>;
+				interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 12>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			gpio4: gpio4@20084000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x20084000 0x100>;
+				interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 13>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			gpio6: gpio6@2000a000 {
+				compatible = "rockchip,gpio-bank";
+				reg = <0x2000a000 0x100>;
+				interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_gates8 15>;
+
+				gpio-controller;
+				#gpio-cells = <2>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			uart0 {
+				uart0_xfer: uart0-xfer {
+					rockchip,pins = <RK_GPIO1 0 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO1 1 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart0_cts: uart0-cts {
+					rockchip,pins = <RK_GPIO1 2 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart0_rts: uart0-rts {
+					rockchip,pins = <RK_GPIO1 3 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+			};
+
+			uart1 {
+				uart1_xfer: uart1-xfer {
+					rockchip,pins = <RK_GPIO1 4 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO1 5 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart1_cts: uart1-cts {
+					rockchip,pins = <RK_GPIO1 6 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart1_rts: uart1-rts {
+					rockchip,pins = <RK_GPIO1 7 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+			};
+
+			uart2 {
+				uart2_xfer: uart2-xfer {
+					rockchip,pins = <RK_GPIO1 8 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO1 9 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+				/* no rts / cts for uart2 */
+			};
+
+			uart3 {
+				uart3_xfer: uart3-xfer {
+					rockchip,pins = <RK_GPIO3 27 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 28 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart3_cts: uart3-cts {
+					rockchip,pins = <RK_GPIO3 29 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				uart3_rts: uart3-rts {
+					rockchip,pins = <RK_GPIO3 30 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+			};
+
+			sd0 {
+				sd0_clk: sd0-clk {
+					rockchip,pins = <RK_GPIO3 8 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd0_cmd: sd0-cmd {
+					rockchip,pins = <RK_GPIO3 9 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd0_cd: sd0-cd {
+					rockchip,pins = <RK_GPIO3 14 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd0_wp: sd0-wp {
+					rockchip,pins = <RK_GPIO3 15 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd0_bus1: sd0-bus-width1 {
+					rockchip,pins = <RK_GPIO3 10 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd0_bus4: sd0-bus-width4 {
+					rockchip,pins = <RK_GPIO3 10 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 11 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 12 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 13 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+			};
+
+			sd1 {
+				sd1_clk: sd1-clk {
+					rockchip,pins = <RK_GPIO3 21 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd1_cmd: sd1-cmd {
+					rockchip,pins = <RK_GPIO3 16 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd1_cd: sd1-cd {
+					rockchip,pins = <RK_GPIO3 22 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd1_wp: sd1-wp {
+					rockchip,pins = <RK_GPIO3 23 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd1_bus1: sd1-bus-width1 {
+					rockchip,pins = <RK_GPIO3 17 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+
+				sd1_bus4: sd1-bus-width4 {
+					rockchip,pins = <RK_GPIO3 17 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 18 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 19 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>,
+							<RK_GPIO3 20 RK_FUNC_1 RK_PINCTRL_PULL_AUTO>;
+				};
+			};
+		};
+
+		uart0: serial@10124000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x10124000 0x400>;
+			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <1>;
+			clocks = <&mux_uart0>;
+			status = "disabled";
+		};
+
+		uart1: serial@10126000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x10126000 0x400>;
+			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <1>;
+			clocks = <&mux_uart1>;
+			status = "disabled";
+		};
+
+		uart2: serial@20064000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x20064000 0x400>;
+			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <1>;
+			clocks = <&mux_uart2>;
+			status = "disabled";
+		};
+
+		uart3: serial@20068000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x20068000 0x400>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <1>;
+			clocks = <&mux_uart3>;
+			status = "disabled";
+		};
+
+		dwmmc@10214000 {
+			compatible = "rockchip,cortex-a9-dw-mshc";
+			reg = <0x10214000 0x1000>;
+			interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			clocks = <&clk_gates5 10>, <&clk_gates2 11>;
+			clock-names = "biu", "ciu";
+
+			status = "disabled";
+		};
+
+		dwmmc@10218000 {
+			compatible = "rockchip,cortex-a9-dw-mshc";
+			reg = <0x10218000 0x1000>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			clocks = <&clk_gates5 11>, <&clk_gates2 13>;
+			clock-names = "biu", "ciu";
+
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
new file mode 100644
index 0000000..7e332ea
--- /dev/null
+++ b/arch/arm/mach-rockchip/Kconfig
@@ -0,0 +1,17 @@
+config ARCH_ROCKCHIP
+	bool "Rockchip RK2928 and RK3xxx SOCs" if ARCH_MULTI_V7
+	select PINCTRL
+	select PINCTRL_ROCKCHIP
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_GIC
+	select CACHE_L2X0
+	select HAVE_ARM_TWD if LOCAL_TIMERS
+	select HAVE_SMP
+	select LOCAL_TIMERS if SMP
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select DW_APB_TIMER
+	select DW_APB_TIMER_OF
+	help
+	  Support for Rockchip's Cortex-A9 Single-to-Quad-Core-SoCs
+	  containing the RK2928, RK30xx and RK31xx series.
diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
new file mode 100644
index 0000000..880b287
--- /dev/null
+++ b/arch/arm/mach-rockchip/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
\ No newline at end of file
diff --git a/arch/arm/mach-rockchip/Makefile.boot b/arch/arm/mach-rockchip/Makefile.boot
new file mode 100644
index 0000000..a2d8c70
--- /dev/null
+++ b/arch/arm/mach-rockchip/Makefile.boot
@@ -0,0 +1,3 @@
+zreladdr-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60408000
+params_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60088000
+initrd_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60800000
diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/rockchip.c
new file mode 100644
index 0000000..094b37d
--- /dev/null
+++ b/arch/arm/mach-rockchip/rockchip.c
@@ -0,0 +1,54 @@
+/*
+ * Device Tree support for Rockchip SoCs
+ *
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/of_platform.h>
+#include <linux/irqchip.h>
+#include <linux/dw_apb_timer.h>
+#include <linux/clk/rockchip.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/hardware/cache-l2x0.h>
+
+static void __init rockchip_timer_init(void)
+{
+	rockchip_init_clocks();
+	dw_apb_timer_init();
+}
+
+static void __init rockchip_dt_init(void)
+{
+#ifdef CONFIG_CACHE_L2X0
+	l2x0_of_init(0, ~0UL);
+#endif
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const rockchip_board_dt_compat[] = {
+	"rockchip,rk2928", /* single core */
+	"rockchip,rk30xx", /* dual cores */
+	"rockchip,rk31xx", /* dual and quad cores */
+	NULL,
+};
+
+DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
+	.map_io		= debug_ll_io_init,
+	.init_machine	= rockchip_dt_init,
+	.init_time	= rockchip_timer_init,
+	.dt_compat	= rockchip_board_dt_compat,
+MACHINE_END
-- 
1.7.2.3

