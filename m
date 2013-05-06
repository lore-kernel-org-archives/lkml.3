Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3EFOag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:30:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:52267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3EFOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:29 -0400
Message-Id: <20130506142539.450634298@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 06 May 2013 14:30:27 -0000
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
Subject: [patch 7/8] genirq: generic chip: Add linear irq domain support
References: <20130503212258.385818955@linutronix.de>
 <20130506142348.321859745@linutronix.de>
Content-Disposition: inline; filename=genirq-add-linear-domain-support.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide infrastructure for irq chip implementations which work on
linear irq domains.

- Interface to allocate multiple generic chips which are associated to
  the irq domain.

- Interface to get the generic chip pointer for a particular hardware
  interrupt in the domain.

- irq domain mapping function to install the chip for a particular
  interrupt.

Note: This lacks a removal function for now, but this is a draft patch
the ARM folks to work on.

[ Sebastian Hesselbarth: Mask cache and pointer math fixups ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |   30 +++++++
 include/linux/irqdomain.h |   12 ++
 kernel/irq/generic-chip.c |  187 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/irqdomain.c    |    6 -
 4 files changed, 223 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -678,6 +678,8 @@ struct irq_chip_type {
  * @wake_active:	Interrupt is marked as an wakeup from suspend source
  * @num_ct:		Number of available irq_chip_type instances (usually 1)
  * @private:		Private data for non generic chip callbacks
+ * @installed:		bitfield to denote installed interrupts
+ * @domain:		irq domain pointer
  * @list:		List head for keeping track of instances
  * @chip_types:		Array of interrupt irq_chip_types
  *
@@ -699,6 +701,8 @@ struct irq_chip_generic {
 	u32			wake_active;
 	unsigned int		num_ct;
 	void			*private;
+	unsigned long		installed;
+	struct irq_domain	*domain;
 	struct list_head	list;
 	struct irq_chip_type	chip_types[0];
 };
@@ -719,6 +723,24 @@ enum irq_gc_flags {
 	IRQ_GC_NO_MASK			= 1 << 3,
 };
 
+/*
+ * struct irq_domain_chip_generic - Generic irq chip data structure for irq domains
+ * @irqs_per_chip:	Number of interrupts per chip
+ * @num_chips:		Number of chips
+ * @irq_flags_to_set:	IRQ* flags to set on irq setup
+ * @irq_flags_to_clear:	IRQ* flags to clear on irq setup
+ * @gc_flags:		Generic chip specific setup flags
+ * @gc:			Array of pointers to generic interrupt chips
+ */
+struct irq_domain_chip_generic {
+	unsigned int		irqs_per_chip;
+	unsigned int		num_chips;
+	unsigned int		irq_flags_to_clear;
+	unsigned int		irq_flags_to_set;
+	enum irq_gc_flags	gc_flags;
+	struct irq_chip_generic	*gc[0];
+};
+
 /* Generic chip callback functions */
 void irq_gc_noop(struct irq_data *d);
 void irq_gc_mask_disable_reg(struct irq_data *d);
@@ -742,6 +764,14 @@ int irq_setup_alt_chip(struct irq_data *
 void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			     unsigned int clr, unsigned int set);
 
+struct irq_chip_generic *irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq);
+int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
+				   int num_ct, const char *name,
+				   irq_flow_handler_t handler,
+				   unsigned int clr, unsigned int set,
+				   enum irq_gc_flags flags);
+
+
 static inline struct irq_chip_type *irq_data_get_chip_type(struct irq_data *d)
 {
 	return container_of(d->chip, struct irq_chip_type, chip);
Index: linux-2.6/include/linux/irqdomain.h
===================================================================
--- linux-2.6.orig/include/linux/irqdomain.h
+++ linux-2.6/include/linux/irqdomain.h
@@ -66,6 +66,10 @@ struct irq_domain_ops {
 		     unsigned long *out_hwirq, unsigned int *out_type);
 };
 
+extern struct irq_domain_ops irq_generic_chip_ops;
+
+struct irq_domain_chip_generic;
+
 /**
  * struct irq_domain - Hardware interrupt number translation object
  * @link: Element in global irq_domain list.
@@ -109,8 +113,16 @@ struct irq_domain {
 
 	/* Optional device node pointer */
 	struct device_node *of_node;
+	/* Optional pointer to generic interrupt chips */
+	struct irq_domain_chip_generic *gc;
 };
 
+#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
+				 * ie. legacy 8259, gets irqs 1..15 */
+#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
+#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
+#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
+
 #ifdef CONFIG_IRQ_DOMAIN
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -7,6 +7,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/syscore_ops.h>
@@ -244,6 +245,90 @@ irq_gc_init_mask_cache(struct irq_chip_g
 	}
 }
 
+/**
+ * irq_alloc_domain_generic_chip - Allocate generic chips for an irq domain
+ * @d:			irq domain for which to allocate chips
+ * @irqs_per_chip:	Number of interrupts each chip handles
+ * @num_ct:		Number of irq_chip_type instances associated with this
+ * @name:		Name of the irq chip
+ * @handler:		Default flow handler associated with these chips
+ * @clr:		IRQ_* bits to clear in the mapping function
+ * @set:		IRQ_* bits to set in the mapping function
+ */
+int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
+				   int num_ct, const char *name,
+				   irq_flow_handler_t handler,
+				   unsigned int clr, unsigned int set,
+				   enum irq_gc_flags gcflags)
+{
+	struct irq_domain_chip_generic *dgc;
+	struct irq_chip_generic *gc;
+	int numchips, sz, i;
+	unsigned long flags;
+	void *tmp;
+
+	if (d->gc)
+		return -EBUSY;
+
+	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
+		return -EINVAL;
+
+	numchips = d->revmap_data.linear.size / irqs_per_chip;
+	if (!numchips)
+		return -EINVAL;
+
+	/* Allocate a pointer, generic chip and chiptypes for each chip */
+	sz = sizeof(*dgc) + numchips * sizeof(gc);
+	sz += numchips * (sizeof(*gc) + num_ct * sizeof(struct irq_chip_type));
+
+	tmp = dgc = kzalloc(sz, GFP_KERNEL);
+	if (!dgc)
+		return -ENOMEM;
+	dgc->irqs_per_chip = irqs_per_chip;
+	dgc->num_chips = numchips;
+	dgc->irq_flags_to_set = set;
+	dgc->irq_flags_to_clear = clr;
+	dgc->gc_flags = gcflags;
+	d->gc = dgc;
+
+	/* Calc pointer to the first generic chip */
+	tmp += sizeof(*dgc) + numchips * sizeof(gc);
+	for (i = 0; i < numchips; i++) {
+		/* Store the pointer to the generic chip */
+		dgc->gc[i] = gc = tmp;
+		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
+				      NULL, handler);
+		gc->domain = d;
+		raw_spin_lock_irqsave(&gc_lock, flags);
+		list_add_tail(&gc->list, &gc_list);
+		raw_spin_unlock_irqrestore(&gc_lock, flags);
+		/* Calc pointer to the next generic chip */
+		tmp += sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_alloc_domain_generic_chips);
+
+/**
+ * irq_get_domain_generic_chip - Get a pointer to the generic chip of a hw_irq
+ * @d:			irq domain pointer
+ * @hw_irq:		Hardware interrupt number
+ */
+struct irq_chip_generic *
+irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	int idx;
+
+	if (!dgc)
+		return NULL;
+	idx = hw_irq / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return NULL;
+	return dgc->gc[idx];
+}
+EXPORT_SYMBOL_GPL(irq_get_domain_generic_chip);
+
 /*
  * Separate lockdep class for interrupt chip which can nest irq_desc
  * lock.
@@ -251,6 +336,66 @@ irq_gc_init_mask_cache(struct irq_chip_g
 static struct lock_class_key irq_nested_lock_class;
 
 /**
+ * irq_map_generic_chip - Map a generic chip for an irq domain
+ */
+static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hw_irq)
+{
+	struct irq_data *data = irq_get_irq_data(virq);
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+	struct irq_chip *chip;
+	unsigned long flags;
+	int idx;
+
+	if (!d->gc)
+		return -ENODEV;
+
+	idx = hw_irq / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return -EINVAL;
+	gc = dgc->gc[idx];
+
+	idx = hw_irq % dgc->irqs_per_chip;
+
+	if (test_bit(idx, &gc->installed))
+		return -EBUSY;
+
+	ct = gc->chip_types;
+	chip = &ct->chip;
+
+	/* We only init the cache for the first mapping of a generic chip */
+	if (!gc->installed) {
+		raw_spin_lock_irqsave(&gc->lock, flags);
+		irq_gc_init_mask_cache(gc, dgc->gc_flags);
+		raw_spin_unlock_irqrestore(&gc->lock, flags);
+	}
+
+	/* Mark the interrupt as installed */
+	set_bit(idx, &gc->installed);
+
+	if (dgc->gc_flags & IRQ_GC_INIT_NESTED_LOCK)
+		irq_set_lockdep_class(virq, &irq_nested_lock_class);
+
+	if (chip->irq_calc_mask)
+		chip->irq_calc_mask(data);
+	else
+		data->mask = 1 << idx;
+
+	irq_set_chip_and_handler(virq, chip, ct->handler);
+	irq_set_chip_data(virq, gc);
+	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
+	return 0;
+}
+
+struct irq_domain_ops irq_generic_chip_ops = {
+	.map = irq_map_generic_chip,
+	.xlate = irq_domain_xlate_onecell,
+};
+EXPORT_SYMBOL_GPL(irq_generic_chip_ops);
+
+/**
  * irq_setup_generic_chip - Setup a range of interrupts with a generic chip
  * @gc:		Generic irq chip holding all data
  * @msk:	Bitmask holding the irqs to initialize relative to gc->irq_base
@@ -354,6 +499,24 @@ void irq_remove_generic_chip(struct irq_
 }
 EXPORT_SYMBOL_GPL(irq_remove_generic_chip);
 
+static struct irq_data *irq_gc_get_irq_data(struct irq_chip_generic *gc)
+{
+	unsigned int virq;
+
+	if (!gc->domain)
+		return irq_get_irq_data(gc->irq_base);
+
+	/*
+	 * We don't know which of the irqs has been actually
+	 * installed. Use the first one.
+	 */
+	if (!gc->installed)
+		return NULL;
+
+	virq = irq_find_mapping(gc->domain, gc->irq_base + __ffs(gc->installed));
+	return virq ? irq_get_irq_data(virq) : NULL;
+}
+
 #ifdef CONFIG_PM
 static int irq_gc_suspend(void)
 {
@@ -362,8 +525,12 @@ static int irq_gc_suspend(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_suspend)
-			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_suspend) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_suspend(data);
+		}
 	}
 	return 0;
 }
@@ -375,8 +542,12 @@ static void irq_gc_resume(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_resume)
-			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_resume) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_resume(data);
+		}
 	}
 }
 #else
@@ -391,8 +562,12 @@ static void irq_gc_shutdown(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_pm_shutdown)
-			ct->chip.irq_pm_shutdown(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_pm_shutdown) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_pm_shutdown(data);
+		}
 	}
 }
 
Index: linux-2.6/kernel/irq/irqdomain.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdomain.c
+++ linux-2.6/kernel/irq/irqdomain.c
@@ -16,12 +16,6 @@
 #include <linux/smp.h>
 #include <linux/fs.h>
 
-#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
-				 * ie. legacy 8259, gets irqs 1..15 */
-#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
-#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
-#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
-
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 


