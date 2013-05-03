Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab3ECOKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:10:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:45397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab3ECOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:10:00 -0400
Date: Fri, 3 May 2013 16:09:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] irqchip: add support for Marvell Orion SoCs
In-Reply-To: <5183B7ED.7030800@gmail.com>
Message-ID: <alpine.LFD.2.02.1305031514230.2886@ionos>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130503125527.GE18614@n2100.arm.linux.org.uk>
 <5183B7ED.7030800@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Sebastian Hesselbarth wrote:
> On 05/03/13 14:55, Russell King - ARM Linux wrote:
> > This is where it starts to get tricky, because I can't see how you'd
> > merge the irq_alloc_generic_chip() and irq_setup_generic_chip() with
> > this.  Maybe you don't need to do anything here and just do all that
> > in orion_of_init() instead?  But then you seem to need to know the
> > virq range before hand, and I can't see how that's known.  Maybe Thomas
> > can provide some enlightenment about how the gc irqchip stuff works
> > with the irq domain stuff...
> 
> Exactly, and that is what I am looking into right now. But hell, I am
> not an expert in linux irq yet. Moreover, I am not even sure if it is
> okay to rely on irqdomain or at least irq_data->hw_irq at all.

Here is a solution to that problem.

1) It adds a mask field to irq_data so we dont have to compute the
   mask over and over

2) For compability with existing users it populates the mask with 
   1 << (d->irq - gc->irq_base)

3) It gives you the option to disable that mask setup or let it
   generate from d->hwirq

I'm still looking into a way how to proper support the generic chip /
linear domain mapping in the setup path. Will send you a draft patch
to play with later.

Thanks,

	tglx


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
@@ -700,10 +702,14 @@ struct irq_chip_generic {
  * @IRQ_GC_INIT_NESTED_LOCK:	Set the lock class of the irqs to nested for
  *				irq chips which need to call irq_set_wake() on
  *				the parent irq. Usually GPIO implementations
+ * @IRQ_GC_NO_MASK:		Do not calculate irq_data->mask
+ * @IRQ_GC_MASK_FROM_HWIRQ:	Calculate irq_data->mask from the hwirq number
  */
 enum irq_gc_flags {
 	IRQ_GC_INIT_MASK_CACHE		= 1 << 0,
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
+	IRQ_GC_NO_MASK			= 1 << 2,
+	IRQ_GC_MASK_FROM_HWIRQ		= 1 << 4,
 };
 
 /* Generic chip callback functions */
Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -39,7 +39,7 @@ void irq_gc_noop(struct irq_data *d)
 void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
@@ -57,7 +57,7 @@ void irq_gc_mask_disable_reg(struct irq_
 void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	gc->mask_cache |= mask;
@@ -75,7 +75,7 @@ void irq_gc_mask_set_bit(struct irq_data
 void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	gc->mask_cache &= ~mask;
@@ -93,7 +93,7 @@ void irq_gc_mask_clr_bit(struct irq_data
 void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
@@ -108,7 +108,7 @@ void irq_gc_unmask_enable_reg(struct irq
 void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
@@ -122,7 +122,7 @@ void irq_gc_ack_set_bit(struct irq_data 
 void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	u32 mask = ~d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
@@ -136,7 +136,7 @@ void irq_gc_ack_clr_bit(struct irq_data 
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
@@ -151,7 +151,7 @@ void irq_gc_mask_disable_reg_and_ack(str
 void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
@@ -169,7 +169,7 @@ void irq_gc_eoi(struct irq_data *d)
 int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	if (!(mask & gc->wake_enabled))
 		return -EINVAL;
@@ -254,6 +254,15 @@ void irq_setup_generic_chip(struct irq_c
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
 			irq_set_lockdep_class(i, &irq_nested_lock_class);
 
+		if (!(flags & IRQ_GC_NO_MASK)) {
+			struct irq_data *d = irq_get_irq_data(i);
+			u32 mask;
+
+			if (flags & IRQ_GC_MASK_FROM_HWIRQ)
+				d->mask = 1 << (d->hwirq % 32);
+			else
+				d->mask = 1 << (i - gc->irq_base);
+		}
 		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
 		irq_set_chip_data(i, gc);
 		irq_modify_status(i, clr, set);
