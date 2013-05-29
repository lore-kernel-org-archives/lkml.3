Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352Ab3E2JVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:21:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201Ab3E2JVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:21:46 -0400
Date: Wed, 29 May 2013 02:21:05 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3528d82b684680b72fa31881c8c572c5a98b51de@git.kernel.org>
Cc: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, thomas.petazzoni@free-electrons.com,
        linux@arm.linux.org.uk, ezequiel.garcia@free-electrons.com,
        tglx@linutronix.de, maxime.ripard@free-electrons.com, rob@landley.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        grant.likely@linaro.org, gerlando.falauto@keymile.com,
        sebastian.hesselbarth@gmail.com, rob.herring@calxeda.com,
        gregory.clement@free-electrons.com, andrew@lunn.ch
Reply-To: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, thomas.petazzoni@free-electrons.com,
        linux@arm.linux.org.uk, ezequiel.garcia@free-electrons.com,
        tglx@linutronix.de, maxime.ripard@free-electrons.com, rob@landley.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        grant.likely@linaro.org, gerlando.falauto@keymile.com,
        gregory.clement@free-electrons.com, rob.herring@calxeda.com,
        sebastian.hesselbarth@gmail.com, andrew@lunn.ch
In-Reply-To: <20130506142539.377017672@linutronix.de>
References: <20130506142539.377017672@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Generic chip:
  Split out code into separate functions
Git-Commit-ID: 3528d82b684680b72fa31881c8c572c5a98b51de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3528d82b684680b72fa31881c8c572c5a98b51de
Gitweb:     http://git.kernel.org/tip/3528d82b684680b72fa31881c8c572c5a98b51de
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 6 May 2013 14:30:25 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:11 +0200

genirq: Generic chip: Split out code into separate functions

Preparatory patch for linear interrupt domains.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Rob Landley <rob@landley.net>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Link: http://lkml.kernel.org/r/20130506142539.377017672@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 50 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 5068fe3..3deb333 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -186,6 +186,19 @@ int irq_gc_set_wake(struct irq_data *d, unsigned int on)
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
@@ -206,17 +219,31 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
 
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
@@ -242,21 +269,12 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
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
