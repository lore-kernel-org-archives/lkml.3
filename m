Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaKGGpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:45:34 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52379 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaKGGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:45:19 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org
Cc: arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: [PATCH V4 11/14] irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
Date: Thu,  6 Nov 2014 22:44:26 -0800
Message-Id: <1415342669-30640-12-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most implementations of the bcm7120-l2 controller only have a single
32-bit enable word + 32-bit status word.  But some instances have added
more enable/status pairs in order to support 64+ IRQs (which are all
ORed into one parent IRQ input).  Make the following changes to allow
the driver to support this:

 - Extend DT bindings so that multiple words can be specified for the
   reg property, various masks, etc.

 - Add loops to the probe/handle functions to deal with each word
   separately

 - Allocate 1 generic-chip for every 32 IRQs, so we can still use the
   clr/set helper functions

 - Update the documentation

This uses one domain per bcm7120-l2 DT node.  If the DT node defines
multiple enable/status pairs (i.e. >=64 IRQs) then the driver will
create a single IRQ domain with 2+ generic chips.  Multiple generic chips
are required because the generic-chip code can only handle one
enable/status register pair per instance.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  26 ++--
 drivers/irqchip/irq-bcm7120-l2.c                   | 144 ++++++++++++++-------
 2 files changed, 113 insertions(+), 57 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
index ff812a8..bae1f21 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -13,7 +13,12 @@ Such an interrupt controller has the following hardware design:
   or if they will output an interrupt signal at this 2nd level interrupt
   controller, in particular for UARTs
 
-- not all 32-bits within the interrupt controller actually map to an interrupt
+- typically has one 32-bit enable word and one 32-bit status word, but on
+  some hardware may have more than one enable/status pair
+
+- no atomic set/clear operations
+
+- not all bits within the interrupt controller actually map to an interrupt
 
 The typical hardware layout for this controller is represented below:
 
@@ -48,7 +53,9 @@ The typical hardware layout for this controller is represented below:
 Required properties:
 
 - compatible: should be "brcm,bcm7120-l2-intc"
-- reg: specifies the base physical address and size of the registers
+- reg: specifies the base physical address and size of the registers;
+  multiple pairs may be specified, with the first pair handling IRQ offsets
+  0..31 and the second pair handling 32..63
 - interrupt-controller: identifies the node as an interrupt controller
 - #interrupt-cells: specifies the number of cells needed to encode an interrupt
   source, should be 1.
@@ -59,18 +66,21 @@ Required properties:
 - brcm,int-map-mask: 32-bits bit mask describing how many and which interrupts
   are wired to this 2nd level interrupt controller, and how they match their
   respective interrupt parents. Should match exactly the number of interrupts
-  specified in the 'interrupts' property.
+  specified in the 'interrupts' property, multiplied by the number of
+  enable/status register pairs implemented by this controller.  For
+  multiple parent IRQs with multiple enable/status words, this looks like:
+  <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
 
 Optional properties:
 
 - brcm,irq-can-wake: if present, this means the L2 controller can be used as a
   wakeup source for system suspend/resume.
 
-- brcm,int-fwd-mask: if present, a 32-bits bit mask to configure for the
-  interrupts which have a mux gate, typically UARTs. Setting these bits will
-  make their respective interrupts outputs bypass this 2nd level interrupt
-  controller completely, it completely transparent for the interrupt controller
-  parent
+- brcm,int-fwd-mask: if present, a bit mask to configure the interrupts which
+  have a mux gate, typically UARTs. Setting these bits will make their
+  respective interrupt outputs bypass this 2nd level interrupt controller
+  completely; it is completely transparent for the interrupt controller
+  parent. This should have one 32-bit word per enable/status pair.
 
 Example:
 
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 9841121..ef4d32c 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/irqdomain.h>
 #include <linux/reboot.h>
+#include <linux/bitops.h>
 #include <linux/irqchip/chained_irq.h>
 
 #include "irqchip.h"
@@ -31,27 +32,42 @@
 #define IRQEN		0x00
 #define IRQSTAT		0x04
 
+#define MAX_WORDS	4
+#define IRQS_PER_WORD	32
+
 struct bcm7120_l2_intc_data {
-	void __iomem *base;
+	unsigned int n_words;
+	void __iomem *base[MAX_WORDS];
 	struct irq_domain *domain;
 	bool can_wake;
-	u32 irq_fwd_mask;
-	u32 irq_map_mask;
+	u32 irq_fwd_mask[MAX_WORDS];
+	u32 irq_map_mask[MAX_WORDS];
 };
 
 static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 {
 	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
-	u32 status;
+	unsigned int idx;
 
 	chained_irq_enter(chip, desc);
 
-	status = __raw_readl(b->base + IRQSTAT);
-	while (status) {
-		irq = ffs(status) - 1;
-		status &= ~(1 << irq);
-		generic_handle_irq(irq_find_mapping(b->domain, irq));
+	for (idx = 0; idx < b->n_words; idx++) {
+		int base = idx * IRQS_PER_WORD;
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(b->domain, base);
+		unsigned long pending;
+		int hwirq;
+
+		irq_gc_lock(gc);
+		pending = __raw_readl(b->base[idx] + IRQSTAT) &
+			  gc->mask_cache;
+		irq_gc_unlock(gc);
+
+		for_each_set_bit(hwirq, &pending, IRQS_PER_WORD) {
+			generic_handle_irq(irq_find_mapping(b->domain,
+					   base + hwirq));
+		}
 	}
 
 	chained_irq_exit(chip, desc);
@@ -65,7 +81,7 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 	irq_gc_lock(gc);
 	if (b->can_wake) {
 		__raw_writel(gc->mask_cache | gc->wake_active,
-			     b->base + IRQEN);
+			     gc->reg_base + IRQEN);
 	}
 	irq_gc_unlock(gc);
 }
@@ -76,7 +92,7 @@ static void bcm7120_l2_intc_resume(struct irq_data *d)
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	__raw_writel(gc->mask_cache, b->base + IRQEN);
+	__raw_writel(gc->mask_cache, gc->reg_base + IRQEN);
 	irq_gc_unlock(gc);
 }
 
@@ -85,6 +101,7 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 					int irq, const __be32 *map_mask)
 {
 	int parent_irq;
+	unsigned int idx;
 
 	parent_irq = irq_of_parse_and_map(dn, irq);
 	if (parent_irq < 0) {
@@ -92,7 +109,12 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 		return parent_irq;
 	}
 
-	data->irq_map_mask |= be32_to_cpup(map_mask + irq);
+	/* For multiple parent IRQs with multiple words, this looks like:
+	 * <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
+	 */
+	for (idx = 0; idx < data->n_words; idx++)
+		data->irq_map_mask[idx] |=
+			be32_to_cpup(map_mask + irq * data->n_words + idx);
 
 	irq_set_handler_data(parent_irq, data);
 	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
@@ -109,26 +131,41 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	struct irq_chip_type *ct;
 	const __be32 *map_mask;
 	int num_parent_irqs;
-	int ret = 0, len, irq;
+	int ret = 0, len;
+	unsigned int idx, irq;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->base = of_iomap(dn, 0);
-	if (!data->base) {
+	for (idx = 0; idx < MAX_WORDS; idx++) {
+		data->base[idx] = of_iomap(dn, idx);
+		if (!data->base[idx])
+			break;
+		data->n_words = idx + 1;
+	}
+	if (!data->n_words) {
 		pr_err("failed to remap intc L2 registers\n");
 		ret = -ENOMEM;
-		goto out_free;
+		goto out_unmap;
 	}
 
-	if (of_property_read_u32(dn, "brcm,int-fwd-mask", &data->irq_fwd_mask))
-		data->irq_fwd_mask = 0;
-
-	/* Enable all interrupt specified in the interrupt forward mask and have
-	 * the other disabled
+	/* Enable all interrupts specified in the interrupt forward mask;
+	 * disable all others.  If the property doesn't exist (-EINVAL),
+	 * assume all zeroes.
 	 */
-	__raw_writel(data->irq_fwd_mask, data->base + IRQEN);
+	ret = of_property_read_u32_array(dn, "brcm,int-fwd-mask",
+					 data->irq_fwd_mask, data->n_words);
+	if (ret == 0 || ret == -EINVAL) {
+		for (idx = 0; idx < data->n_words; idx++)
+			__raw_writel(data->irq_fwd_mask[idx],
+				     data->base[idx] + IRQEN);
+	} else {
+		/* property exists but has the wrong number of words */
+		pr_err("invalid int-fwd-mask property\n");
+		ret = -EINVAL;
+		goto out_unmap;
+	}
 
 	num_parent_irqs = of_irq_count(dn);
 	if (num_parent_irqs <= 0) {
@@ -138,7 +175,8 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	}
 
 	map_mask = of_get_property(dn, "brcm,int-map-mask", &len);
-	if (!map_mask || (len != (sizeof(*map_mask) * num_parent_irqs))) {
+	if (!map_mask ||
+	    (len != (sizeof(*map_mask) * num_parent_irqs * data->n_words))) {
 		pr_err("invalid brcm,int-map-mask property\n");
 		ret = -EINVAL;
 		goto out_unmap;
@@ -150,14 +188,14 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 			goto out_unmap;
 	}
 
-	data->domain = irq_domain_add_linear(dn, 32,
-					&irq_generic_chip_ops, NULL);
+	data->domain = irq_domain_add_linear(dn, IRQS_PER_WORD * data->n_words,
+					     &irq_generic_chip_ops, NULL);
 	if (!data->domain) {
 		ret = -ENOMEM;
 		goto out_unmap;
 	}
 
-	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
+	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
 				dn->full_name, handle_level_irq, clr, 0,
 				IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
@@ -165,39 +203,47 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		goto out_free_domain;
 	}
 
-	gc = irq_get_domain_generic_chip(data->domain, 0);
-	gc->unused = 0xffffffff & ~data->irq_map_mask;
-	gc->reg_base = data->base;
-	gc->private = data;
-	ct = gc->chip_types;
-
-	ct->regs.mask = IRQEN;
-	ct->chip.irq_mask = irq_gc_mask_clr_bit;
-	ct->chip.irq_unmask = irq_gc_mask_set_bit;
-	ct->chip.irq_ack = irq_gc_noop;
-	ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
-	ct->chip.irq_resume = bcm7120_l2_intc_resume;
-
-	if (of_property_read_bool(dn, "brcm,irq-can-wake")) {
+	if (of_property_read_bool(dn, "brcm,irq-can-wake"))
 		data->can_wake = true;
-		/* This IRQ chip can wake the system, set all relevant child
-		 * interupts in wake_enabled mask
-		 */
-		gc->wake_enabled = 0xffffffff;
-		gc->wake_enabled &= ~gc->unused;
-		ct->chip.irq_set_wake = irq_gc_set_wake;
+
+	for (idx = 0; idx < data->n_words; idx++) {
+		irq = idx * IRQS_PER_WORD;
+		gc = irq_get_domain_generic_chip(data->domain, irq);
+
+		gc->unused = 0xffffffff & ~data->irq_map_mask[idx];
+		gc->reg_base = data->base[idx];
+		gc->private = data;
+		ct = gc->chip_types;
+
+		ct->regs.mask = IRQEN;
+		ct->chip.irq_mask = irq_gc_mask_clr_bit;
+		ct->chip.irq_unmask = irq_gc_mask_set_bit;
+		ct->chip.irq_ack = irq_gc_noop;
+		ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
+		ct->chip.irq_resume = bcm7120_l2_intc_resume;
+
+		if (data->can_wake) {
+			/* This IRQ chip can wake the system, set all
+			 * relevant child interupts in wake_enabled mask
+			 */
+			gc->wake_enabled = 0xffffffff;
+			gc->wake_enabled &= ~gc->unused;
+			ct->chip.irq_set_wake = irq_gc_set_wake;
+		}
 	}
 
 	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
-			data->base, num_parent_irqs);
+			data->base[0], num_parent_irqs);
 
 	return 0;
 
 out_free_domain:
 	irq_domain_remove(data->domain);
 out_unmap:
-	iounmap(data->base);
-out_free:
+	for (idx = 0; idx < MAX_WORDS; idx++) {
+		if (data->base[idx])
+			iounmap(data->base[idx]);
+	}
 	kfree(data);
 	return ret;
 }
-- 
2.1.1

