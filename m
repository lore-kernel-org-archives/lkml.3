Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3CZJOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:14:47 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51000 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3CZJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:32 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] irqchip: sunxi: Make use of the IRQCHIP_DECLARE macro
Date: Tue, 26 Mar 2013 10:13:13 +0100
Message-Id: <1364289198-11589-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to remove some boilerplate code. At the same time, call the
set_handle_irq function in the initialization function of the irqchip,
so that we can remove it from the machine declaration.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sunxi.c   |    5 ++---
 drivers/irqchip/irq-sunxi.c   |   22 ++++++++++------------
 include/linux/irqchip/sunxi.h |   27 ---------------------------
 3 files changed, 12 insertions(+), 42 deletions(-)
 delete mode 100644 include/linux/irqchip/sunxi.h

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index b26748d..c99ab1b 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -14,13 +14,13 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/irqchip.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
 
 #include <linux/clk/sunxi.h>
-#include <linux/irqchip/sunxi.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -104,8 +104,7 @@ static const char * const sunxi_board_dt_compat[] = {
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
 	.init_machine	= sunxi_dt_init,
 	.map_io		= sunxi_map_io,
-	.init_irq	= sunxi_init_irq,
-	.handle_irq	= sunxi_handle_irq,
+	.init_irq	= irqchip_init,
 	.restart	= sunxi_restart,
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
diff --git a/drivers/irqchip/irq-sunxi.c b/drivers/irqchip/irq-sunxi.c
index 10974fa..0fc49c5 100644
--- a/drivers/irqchip/irq-sunxi.c
+++ b/drivers/irqchip/irq-sunxi.c
@@ -20,7 +20,10 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
-#include <linux/irqchip/sunxi.h>
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
 
 #define SUNXI_IRQ_VECTOR_REG		0x00
 #define SUNXI_IRQ_PROTECTION_REG	0x08
@@ -33,6 +36,8 @@
 static void __iomem *sunxi_irq_base;
 static struct irq_domain *sunxi_irq_domain;
 
+static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs);
+
 void sunxi_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
@@ -125,20 +130,13 @@ static int __init sunxi_of_init(struct device_node *node,
 	if (!sunxi_irq_domain)
 		panic("%s: unable to create IRQ domain\n", node->full_name);
 
-	return 0;
-}
-
-static struct of_device_id sunxi_irq_dt_ids[] __initconst = {
-	{ .compatible = "allwinner,sunxi-ic", .data = sunxi_of_init },
-	{ }
-};
+	set_handle_irq(sunxi_handle_irq);
 
-void __init sunxi_init_irq(void)
-{
-	of_irq_init(sunxi_irq_dt_ids);
+	return 0;
 }
+IRQCHIP_DECLARE(allwinner_sunxi_ic, "allwinner,sunxi-ic", sunxi_of_init);
 
-asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs)
+static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs)
 {
 	u32 irq, hwirq;
 
diff --git a/include/linux/irqchip/sunxi.h b/include/linux/irqchip/sunxi.h
deleted file mode 100644
index 1fe2c22..0000000
--- a/include/linux/irqchip/sunxi.h
+++ /dev/null
@@ -1,27 +0,0 @@
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
-#ifndef __LINUX_IRQCHIP_SUNXI_H
-#define __LINUX_IRQCHIP_SUNXI_H
-
-#include <asm/exception.h>
-
-extern void sunxi_init_irq(void);
-
-extern asmlinkage void __exception_irq_entry sunxi_handle_irq(
-	struct pt_regs *regs);
-
-#endif
-- 
1.7.10.4

