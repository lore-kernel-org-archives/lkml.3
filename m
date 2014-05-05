Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaEEDXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:23:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35187 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754278AbaEEDXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:23:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/6] ARM: sunxi: Remove reset code from the platform
Date: Sun,  4 May 2014 22:08:01 -0500
Message-Id: <1399259284-6282-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that reset is handled either by the watchdog driver for the sun4i, sun5i
and sun7i, and by a driver of its own for sun6i, we can remove it from the
platform code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-sunxi/sunxi.c | 98 ---------------------------------------------
 1 file changed, 98 deletions(-)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 460b5a4962ef..1c62a0a021d7 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -12,109 +12,14 @@
 
 #include <linux/clk-provider.h>
 #include <linux/clocksource.h>
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <linux/io.h>
-#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/system_misc.h>
 
 #include "common.h"
 
-#define SUN4I_WATCHDOG_CTRL_REG		0x00
-#define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
-#define SUN4I_WATCHDOG_MODE_REG		0x04
-#define SUN4I_WATCHDOG_MODE_ENABLE		BIT(0)
-#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	BIT(1)
-
-#define SUN6I_WATCHDOG1_IRQ_REG		0x00
-#define SUN6I_WATCHDOG1_CTRL_REG	0x10
-#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
-#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
-#define SUN6I_WATCHDOG1_MODE_REG	0x18
-#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
-
-static void __iomem *wdt_base;
-
-static void sun4i_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (!wdt_base)
-		return;
-
-	/* Enable timer and set reset bit in the watchdog */
-	writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
-	       wdt_base + SUN4I_WATCHDOG_MODE_REG);
-
-	/*
-	 * Restart the watchdog. The default (and lowest) interval
-	 * value for the watchdog is 0.5s.
-	 */
-	writel(SUN4I_WATCHDOG_CTRL_RESTART, wdt_base + SUN4I_WATCHDOG_CTRL_REG);
-
-	while (1) {
-		mdelay(5);
-		writel(SUN4I_WATCHDOG_MODE_ENABLE | SUN4I_WATCHDOG_MODE_RESET_ENABLE,
-		       wdt_base + SUN4I_WATCHDOG_MODE_REG);
-	}
-}
-
-static void sun6i_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (!wdt_base)
-		return;
-
-	/* Disable interrupts */
-	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
-
-	/* We want to disable the IRQ and just reset the whole system */
-	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
-
-	/* Enable timer. The default and lowest interval value is 0.5s */
-	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-
-	/* Restart the watchdog. */
-	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
-
-	while (1) {
-		mdelay(5);
-		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-	}
-}
-
-static struct of_device_id sunxi_restart_ids[] = {
-	{ .compatible = "allwinner,sun4i-a10-wdt" },
-	{ .compatible = "allwinner,sun6i-a31-wdt" },
-	{ /*sentinel*/ }
-};
-
-static void sunxi_setup_restart(void)
-{
-	struct device_node *np;
-
-	np = of_find_matching_node(NULL, sunxi_restart_ids);
-	if (WARN(!np, "unable to setup watchdog restart"))
-		return;
-
-	wdt_base = of_iomap(np, 0);
-	WARN(!wdt_base, "failed to map watchdog base address");
-}
-
 static void __init sunxi_dt_init(void)
 {
-	sunxi_setup_restart();
-
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
@@ -128,7 +33,6 @@ static const char * const sunxi_board_dt_compat[] = {
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
 	.init_machine	= sunxi_dt_init,
 	.dt_compat	= sunxi_board_dt_compat,
-	.restart	= sun4i_restart,
 MACHINE_END
 
 static const char * const sun6i_board_dt_compat[] = {
@@ -148,7 +52,6 @@ DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
 	.init_machine	= sunxi_dt_init,
 	.init_time	= sun6i_timer_init,
 	.dt_compat	= sun6i_board_dt_compat,
-	.restart	= sun6i_restart,
 	.smp		= smp_ops(sun6i_smp_ops),
 MACHINE_END
 
@@ -160,5 +63,4 @@ static const char * const sun7i_board_dt_compat[] = {
 DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
 	.init_machine	= sunxi_dt_init,
 	.dt_compat	= sun7i_board_dt_compat,
-	.restart	= sun4i_restart,
 MACHINE_END
-- 
1.9.1

