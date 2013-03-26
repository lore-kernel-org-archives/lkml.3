Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab3CZJNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:13:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3CZJN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] clocksource: sunxi: make use of CLKSRC_OF
Date: Tue, 26 Mar 2013 10:13:10 +0100
Message-Id: <1364289198-11589-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using CLKSRC_OF allows to remove the SoC specific sunxi_timer.h header,
and instead of using a custom init function in the machine definition
use the standard clocksource_of_init function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Kconfig       |    1 +
 arch/arm/mach-sunxi/sunxi.c       |   11 +++++++++--
 drivers/clocksource/sunxi_timer.c |   18 +++---------------
 include/linux/sunxi_timer.h       |   24 ------------------------
 4 files changed, 13 insertions(+), 41 deletions(-)
 delete mode 100644 include/linux/sunxi_timer.h

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 8709a39..06c2894 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -1,6 +1,7 @@
 config ARCH_SUNXI
 	bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
 	select CLKSRC_MMIO
+	select CLKSRC_OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 23afb73..b26748d 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -17,8 +18,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
-#include <linux/sunxi_timer.h>
 
+#include <linux/clk/sunxi.h>
 #include <linux/irqchip/sunxi.h>
 
 #include <asm/mach/arch.h>
@@ -81,6 +82,12 @@ void __init sunxi_map_io(void)
 	iotable_init(sunxi_io_desc, ARRAY_SIZE(sunxi_io_desc));
 }
 
+static void __init sunxi_timer_init(void)
+{
+	sunxi_init_clocks();
+	clocksource_of_init();
+}
+
 static void __init sunxi_dt_init(void)
 {
 	sunxi_setup_restart();
@@ -100,6 +107,6 @@ DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
 	.init_irq	= sunxi_init_irq,
 	.handle_irq	= sunxi_handle_irq,
 	.restart	= sunxi_restart,
-	.init_time	= &sunxi_timer_init,
+	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
 MACHINE_END
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 7a3ea23..308bbe3 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -22,8 +22,6 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <linux/sunxi_timer.h>
-#include <linux/clk/sunxi.h>
 
 #define TIMER_IRQ_EN_REG	0x00
 #define TIMER_IRQ_EN(val)		(1 << val)
@@ -98,23 +96,13 @@ static struct irqaction sunxi_timer_irq = {
 	.dev_id = &sunxi_clockevent,
 };
 
-static struct of_device_id sunxi_timer_dt_ids[] = {
-	{ .compatible = "allwinner,sunxi-timer" },
-	{ }
-};
-
-void __init sunxi_timer_init(void)
+static void __init sunxi_timer_init(struct device_node *node)
 {
-	struct device_node *node;
 	unsigned long rate = 0;
 	struct clk *clk;
 	int ret, irq;
 	u32 val;
 
-	node = of_find_matching_node(NULL, sunxi_timer_dt_ids);
-	if (!node)
-		panic("No sunxi timer node");
-
 	timer_base = of_iomap(node, 0);
 	if (!timer_base)
 		panic("Can't map registers");
@@ -123,8 +111,6 @@ void __init sunxi_timer_init(void)
 	if (irq <= 0)
 		panic("Can't parse IRQ");
 
-	sunxi_init_clocks();
-
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
@@ -158,3 +144,5 @@ void __init sunxi_timer_init(void)
 	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
 					0x1, 0xff);
 }
+CLOCKSOURCE_OF_DECLARE(sunxi, "allwinner,sunxi-timer",
+		       sunxi_timer_init);
diff --git a/include/linux/sunxi_timer.h b/include/linux/sunxi_timer.h
deleted file mode 100644
index 1808178..0000000
--- a/include/linux/sunxi_timer.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Copyright 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __SUNXI_TIMER_H
-#define __SUNXI_TIMER_H
-
-#include <asm/mach/time.h>
-
-void sunxi_timer_init(void);
-
-#endif
-- 
1.7.10.4

