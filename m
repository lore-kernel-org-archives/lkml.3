Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3DTNP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:15:57 -0400
Received: from mail.df.lth.se ([194.47.250.12]:56976 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab3DTNPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:15:30 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] ARM: nomadik: register clocksource from device tree
Date: Sat, 20 Apr 2013 15:08:47 +0200
Message-Id: <1366463327-10025-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the Nomadik platform to also registering its
clocksource from the device tree, removing unused support
code as we go along.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi | 11 ++++++++---
 arch/arm/mach-nomadik/Kconfig              |  1 +
 arch/arm/mach-nomadik/cpu-8815.c           |  6 +++---
 drivers/clk/clk-nomadik.c                  | 15 ---------------
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index f0df948..51a33e0 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -21,18 +21,23 @@
 		cache-level = <2>;
 	};
 
-	mtu0 {
+	mtu0: mtu@101e2000 {
 		/* Nomadik system timer */
+		compatible = "st,nomadik-mtu";
 		reg = <0x101e2000 0x1000>;
 		interrupt-parent = <&vica>;
 		interrupts = <4>;
+		clocks = <&timclk>, <&pclk>;
+		clock-names = "timclk", "apb_pclk";
 	};
 
-	mtu1 {
+	mtu1: mtu@101e3000 {
 		/* Secondary timer */
 		reg = <0x101e3000 0x1000>;
 		interrupt-parent = <&vica>;
 		interrupts = <5>;
+		clocks = <&timclk>, <&pclk>;
+		clock-names = "timclk", "apb_pclk";
 	};
 
 	gpio0: gpio@101e4000 {
@@ -101,7 +106,7 @@
 			pclk: pclk@0 {
 				#clock-cells = <0>;
 				compatible = "fixed-clock";
-				clock-frequency = <2400000>;
+				clock-frequency = <0>;
 			};
 			/*
 			 * The 2.4 MHz TIMCLK reference clock is active at
diff --git a/arch/arm/mach-nomadik/Kconfig b/arch/arm/mach-nomadik/Kconfig
index 8c1ccd4..4eafec3 100644
--- a/arch/arm/mach-nomadik/Kconfig
+++ b/arch/arm/mach-nomadik/Kconfig
@@ -6,6 +6,7 @@ config ARCH_NOMADIK
 	select ARM_VIC
 	select CLKSRC_NOMADIK_MTU
 	select CLKSRC_NOMADIK_MTU_SCHED_CLOCK
+	select CLKSRC_OF
 	select COMMON_CLK
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 0e2c5e0..e73a71f7 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -29,7 +29,7 @@
 #include <linux/platform_data/clk-nomadik.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/pinctrl/machine.h>
-#include <linux/platform_data/clocksource-nomadik-mtu.h>
+#include <linux/clocksource.h>
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/of_address.h>
@@ -172,7 +172,7 @@ static void __init cpu8815_timer_init_of(void)
 	/* We need this to be up now */
 	nomadik_clk_init();
 
-	mtu = of_find_node_by_path("/mtu0");
+	mtu = of_find_node_by_path("/mtu@101e2000");
 	if (!mtu)
 		return;
 	base = of_iomap(mtu, 0);
@@ -188,7 +188,7 @@ static void __init cpu8815_timer_init_of(void)
 	src_cr |= SRC_CR_INIT_VAL;
 	writel(src_cr, base);
 
-	nmdk_timer_init(base, irq);
+	clocksource_of_init();
 }
 
 static struct fsmc_nand_timings cpu8815_nand_timings = {
diff --git a/drivers/clk/clk-nomadik.c b/drivers/clk/clk-nomadik.c
index 19f197c..4a1ab27 100644
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -17,20 +17,5 @@ static const __initconst struct of_device_id cpu8815_clk_match[] = {
 
 void __init nomadik_clk_init(void)
 {
-	struct clk *clk;
-
-	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
-	clk_register_clkdev(clk, "apb_pclk", NULL);
-
-	/*
-	 * The 2.4 MHz TIMCLK reference clock is active at boot time, this is
-	 * actually the MXTALCLK @19.2 MHz divided by 8. This clock is used
-	 * by the timers and watchdog. See page 105 ff.
-	 */
-	clk = clk_register_fixed_rate(NULL, "TIMCLK", NULL, CLK_IS_ROOT,
-				      2400000);
-	clk_register_clkdev(clk, NULL, "mtu0");
-	clk_register_clkdev(clk, NULL, "mtu1");
-
 	of_clk_init(cpu8815_clk_match);
 }
-- 
1.8.1.4

