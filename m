Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EFObM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:31:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:52246 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3EFOa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:28 -0400
Message-Id: <20130506142539.377017672@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 06 May 2013 14:30:25 -0000
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
Subject: [patch 6/8] genirq: Split out code in generic chip
References: <20130503212258.385818955@linutronix.de>
 <20130506142348.321859745@linutronix.de>
Content-Disposition: inline; filename=genirq-generic-chip-split-out-code.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for linear interrupt domains.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c |   50 +++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/irq/generic-chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/generic-chip.c
+++ linux-2.6/kernel/irq/generic-chip.c
@@ -186,6 +186,19 @@ int irq_gc_set_wake(struct irq_data *d, 
 	return 0;
 }
 
+static void
+irq_init_generic_chip(struct irq_chip_generic *gc, const char *name,
+		      int num_ct, unsigned int irq_base,
+		      void __iomem *reg_base, irq_flow_handler_t handler)
+{
+	raw_spin_lock_init(&gc->lock);
+	gc->num_ct = num_ct;
+	gc->irq_base = irq_base;
+	gc->reg_base = reg_base;
+	gc->chip_types->chip.name = name;
+	gc->chip_types->handler = handler;
+}
+
 /**
  * irq_alloc_generic_chip - Allocate a generic chip and initialize it
  * @name:	Name of the irq chip
@@ -206,17 +219,31 @@ irq_alloc_generic_chip(const char *name,
 
 	gc = kzalloc(sz, GFP_KERNEL);
 	if (gc) {
-		raw_spin_lock_init(&gc->lock);
-		gc->num_ct = num_ct;
-		gc->irq_base = irq_base;
-		gc->reg_base = reg_base;
-		gc->chip_types->chip.name = name;
-		gc->chip_types->handler = handler;
+		irq_init_generic_chip(gc, name, num_ct, irq_base, reg_base,
+				      handler);
 	}
 	return gc;
 }
 EXPORT_SYMBOL_GPL(irq_alloc_generic_chip);
 
+static void
+irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
+{
+	struct irq_chip_type *ct = gc->chip_types;
+	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
+	int i;
+
+	for (i = 0; i < gc->num_ct; i++) {
+		if (flags & IRQ_GC_MASK_CACHE_PER_TYPE) {
+			mskptr = &ct[i].mask_cache_priv;
+			mskreg = ct[i].regs.mask;
+		}
+		ct[i].mask_cache = mskptr;
+		if (flags & IRQ_GC_INIT_MASK_CACHE)
+			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+	}
+}
+
 /*
  * Separate lockdep class for interrupt chip which can nest irq_desc
  * lock.
@@ -242,21 +269,12 @@ void irq_setup_generic_chip(struct irq_c
 	struct irq_chip_type *ct = gc->chip_types;
 	struct irq_chip *chip = &ct->chip;
 	unsigned int i;
-	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
 
 	raw_spin_lock(&gc_lock);
 	list_add_tail(&gc->list, &gc_list);
 	raw_spin_unlock(&gc_lock);
 
-	for (i = 0; i < gc->num_ct; i++) {
-		if (flags & IRQ_GC_MASK_CACHE_PER_TYPE) {
-			mskptr = &ct[i].mask_cache_priv;
-			mskreg = ct[i].regs.mask;
-		}
-		ct[i].mask_cache = mskptr;
-		if (flags & IRQ_GC_INIT_MASK_CACHE)
-			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
-	}
+	irq_gc_init_mask_cache(gc, flags);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))


