Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3ECVuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:50:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:47073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763772Ab3ECVuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:50:52 -0400
Message-Id: <20130503214629.599155322@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 21:50:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC patch 4/8] genirq: generic chip: Cache per irq bit mask 
References: <alpine.LFD.2.02.1305031514230.2886@ionos>
 <20130503212258.385818955@linutronix.de>
Content-Disposition: inline; filename=genirq-generic-chip-cache-mask.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the per irq bit mask instead of recalculating it over and over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |    4 ++++
 kernel/irq/generic-chip.c |   23 ++++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -119,6 +119,7 @@ struct irq_domain;
 
 /**
  * struct irq_data - per irq and irq chip data passed down to chip functions
+ * @mask:		precomputed bitmask for accessing the chip registers
  * @irq:		interrupt number
  * @hwirq:		hardware interrupt number, local to the interrupt domain
  * @node:		node index useful for balancing
@@ -138,6 +139,7 @@ struct irq_domain;
  * irq_data.
  */
 struct irq_data {
+	u32			mask;
 	unsigned int		irq;
 	unsigned long		hwirq;
 	unsigned int		node;
@@ -705,11 +707,13 @@ struct irq_chip_generic {
  *				irq chips which need to call irq_set_wake() on
  *				the parent irq. Usually GPIO implementations
  * @IRQ_GC_MASK_CACHE_PER_TYPE:	Mask cache is chip type private
+ * @IRQ_GC_NO_MASK:		Do not calculate irq_data->mask
  */
 enum irq_gc_flags {
 	IRQ_GC_INIT_MASK_CACHE		= 1 << 0,
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
 	IRQ_GC_MASK_CACHE_PER_TYPE	= 1 << 2,
+	IRQ_GC_NO_MASK			= 1 << 3,
 };
 
 /* Generic chip callback functions */
Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -35,7 +35,7 @@ void irq_gc_mask_disable_reg(struct irq_
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
@@ -54,7 +54,7 @@ void irq_gc_mask_set_bit(struct irq_data
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	*ct->mask_cache |= mask;
@@ -73,7 +73,7 @@ void irq_gc_mask_clr_bit(struct irq_data
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	*ct->mask_cache &= ~mask;
@@ -92,7 +92,7 @@ void irq_gc_unmask_enable_reg(struct irq
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
@@ -108,7 +108,7 @@ void irq_gc_ack_set_bit(struct irq_data 
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
@@ -123,7 +123,7 @@ void irq_gc_ack_clr_bit(struct irq_data 
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	u32 mask = ~(d->mask);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
@@ -138,7 +138,7 @@ void irq_gc_mask_disable_reg_and_ack(str
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.mask);
@@ -154,7 +154,7 @@ void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.eoi);
@@ -172,7 +172,7 @@ void irq_gc_eoi(struct irq_data *d)
 int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	if (!(mask & gc->wake_enabled))
 		return -EINVAL;
@@ -264,6 +264,11 @@ void irq_setup_generic_chip(struct irq_c
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
 			irq_set_lockdep_class(i, &irq_nested_lock_class);
 
+		if (!(flags & IRQ_GC_NO_MASK)) {
+			struct irq_data *d = irq_get_irq_data(i);
+
+			d->mask = 1 << (i - gc->irq_base);
+		}
 		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
 		irq_set_chip_data(i, gc);
 		irq_modify_status(i, clr, set);


