Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaK1EdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:33:17 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48289 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaK1EdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:13 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 05/16] irqchip: bcm7120-l2: Refactor driver for arbitrary IRQEN/IRQSTAT offsets
Date: Thu, 27 Nov 2014 20:32:11 -0800
Message-Id: <1417149142-3756-6-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver assumes that REG_BASE+0x00 is the IRQ enable mask,
and REG_BASE+0x04 is the IRQ status mask.  This is true on BCM3384 and
BCM7xxx, but it is not true for some of the controllers found on BCM63xx
chips.  So we will change a couple of key assumptions:

 - Don't assume that both the IRQEN and IRQSTAT registers will be
   covered by a single ioremap() operation.

 - Don't assume any particular ordering (IRQSTAT might show up before
   IRQEN on some chips).

 - For an L2 controller with >=64 IRQs, don't assume that every
   IRQEN/IRQSTAT pair will use the same register spacing.

This patch changes the "plumbing" but doesn't yet provide a way for users
to instantiate a controller with arbitrary IRQEN/IRQSTAT offsets.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 41 +++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 8eec8e1201d9..da5b5745003c 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -34,11 +34,15 @@
 #define IRQSTAT		0x04
 
 #define MAX_WORDS	4
+#define MAX_MAPPINGS	MAX_WORDS
 #define IRQS_PER_WORD	32
 
 struct bcm7120_l2_intc_data {
 	unsigned int n_words;
-	void __iomem *base[MAX_WORDS];
+	void __iomem *map_base[MAX_MAPPINGS];
+	void __iomem *pair_base[MAX_WORDS];
+	int en_offset[MAX_WORDS];
+	int stat_offset[MAX_WORDS];
 	struct irq_domain *domain;
 	bool can_wake;
 	u32 irq_fwd_mask[MAX_WORDS];
@@ -61,7 +65,8 @@ static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 		int hwirq;
 
 		irq_gc_lock(gc);
-		pending = irq_reg_readl(gc, IRQSTAT) & gc->mask_cache;
+		pending = irq_reg_readl(gc, b->stat_offset[idx]) &
+			  gc->mask_cache;
 		irq_gc_unlock(gc);
 
 		for_each_set_bit(hwirq, &pending, IRQS_PER_WORD) {
@@ -76,21 +81,24 @@ static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 static void bcm7120_l2_intc_suspend(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	struct bcm7120_l2_intc_data *b = gc->private;
 
 	irq_gc_lock(gc);
 	if (b->can_wake)
-		irq_reg_writel(gc, gc->mask_cache | gc->wake_active, IRQEN);
+		irq_reg_writel(gc, gc->mask_cache | gc->wake_active,
+			       ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
 static void bcm7120_l2_intc_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	irq_reg_writel(gc, gc->mask_cache, IRQEN);
+	irq_reg_writel(gc, gc->mask_cache, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -137,9 +145,14 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		return -ENOMEM;
 
 	for (idx = 0; idx < MAX_WORDS; idx++) {
-		data->base[idx] = of_iomap(dn, idx);
-		if (!data->base[idx])
+		data->map_base[idx] = of_iomap(dn, idx);
+		if (!data->map_base[idx])
 			break;
+
+		data->pair_base[idx] = data->map_base[idx];
+		data->en_offset[idx] = IRQEN;
+		data->stat_offset[idx] = IRQSTAT;
+
 		data->n_words = idx + 1;
 	}
 	if (!data->n_words) {
@@ -157,7 +170,8 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	if (ret == 0 || ret == -EINVAL) {
 		for (idx = 0; idx < data->n_words; idx++)
 			__raw_writel(data->irq_fwd_mask[idx],
-				     data->base[idx] + IRQEN);
+				     data->pair_base[idx] +
+				     data->en_offset[idx]);
 	} else {
 		/* property exists but has the wrong number of words */
 		pr_err("invalid int-fwd-mask property\n");
@@ -215,11 +229,12 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		gc = irq_get_domain_generic_chip(data->domain, irq);
 
 		gc->unused = 0xffffffff & ~data->irq_map_mask[idx];
-		gc->reg_base = data->base[idx];
 		gc->private = data;
 		ct = gc->chip_types;
 
-		ct->regs.mask = IRQEN;
+		gc->reg_base = data->pair_base[idx];
+		ct->regs.mask = data->en_offset[idx];
+
 		ct->chip.irq_mask = irq_gc_mask_clr_bit;
 		ct->chip.irq_unmask = irq_gc_mask_set_bit;
 		ct->chip.irq_ack = irq_gc_noop;
@@ -237,16 +252,16 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	}
 
 	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
-			data->base[0], num_parent_irqs);
+			data->map_base[0], num_parent_irqs);
 
 	return 0;
 
 out_free_domain:
 	irq_domain_remove(data->domain);
 out_unmap:
-	for (idx = 0; idx < MAX_WORDS; idx++) {
-		if (data->base[idx])
-			iounmap(data->base[idx]);
+	for (idx = 0; idx < MAX_MAPPINGS; idx++) {
+		if (data->map_base[idx])
+			iounmap(data->map_base[idx]);
 	}
 	kfree(data);
 	return ret;
-- 
2.1.0

