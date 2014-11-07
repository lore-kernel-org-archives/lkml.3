Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaKGGpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:45:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61444 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaKGGpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:45:22 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org
Cc: arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: [PATCH V4 13/14] irqchip: bcm7120-l2: Convert driver to use irq_reg_{readl,writel}
Date: Thu,  6 Nov 2014 22:44:28 -0800
Message-Id: <1415342669-30640-14-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On BE MIPS systems this needs to use the new IRQ_GC_BE_IO gc_flag.  In
all other cases it will use the standard readl/writel accessors.

The initial irq_fwd_mask setup runs before "gc" is initialized, so it
is unchanged for now.  This could potentially be a problem on an ARM
system that boots in LE mode but runs a BE kernel, but currently none
of the supported ARM platforms are ever expected to run BE.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index e53a3a6..e7c6155 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -60,8 +61,7 @@ static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 		int hwirq;
 
 		irq_gc_lock(gc);
-		pending = __raw_readl(b->base[idx] + IRQSTAT) &
-			  gc->mask_cache;
+		pending = irq_reg_readl(gc, IRQSTAT) & gc->mask_cache;
 		irq_gc_unlock(gc);
 
 		for_each_set_bit(hwirq, &pending, IRQS_PER_WORD) {
@@ -79,10 +79,8 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 	struct bcm7120_l2_intc_data *b = gc->private;
 
 	irq_gc_lock(gc);
-	if (b->can_wake) {
-		__raw_writel(gc->mask_cache | gc->wake_active,
-			     gc->reg_base + IRQEN);
-	}
+	if (b->can_wake)
+		irq_reg_writel(gc, gc->mask_cache | gc->wake_active, IRQEN);
 	irq_gc_unlock(gc);
 }
 
@@ -92,7 +90,7 @@ static void bcm7120_l2_intc_resume(struct irq_data *d)
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	__raw_writel(gc->mask_cache, gc->reg_base + IRQEN);
+	irq_reg_writel(gc, gc->mask_cache, IRQEN);
 	irq_gc_unlock(gc);
 }
 
@@ -132,7 +130,7 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	const __be32 *map_mask;
 	int num_parent_irqs;
 	int ret = 0, len;
-	unsigned int idx, irq;
+	unsigned int idx, irq, flags;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -195,9 +193,15 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		goto out_unmap;
 	}
 
+	/* MIPS chips strapped for BE will automagically configure the
+	 * peripheral registers for CPU-native byte order.
+	 */
+	flags = IRQ_GC_INIT_MASK_CACHE;
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		flags |= IRQ_GC_BE_IO;
+
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0,
-				IRQ_GC_INIT_MASK_CACHE);
+				dn->full_name, handle_level_irq, clr, 0, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
2.1.1

