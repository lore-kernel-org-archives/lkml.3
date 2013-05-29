Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965334Ab3E2JTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:19:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965261Ab3E2JTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:19:08 -0400
Date: Wed, 29 May 2013 02:18:32 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-966dc736b819999cd2d3a6408d47d33b579f7d56@git.kernel.org>
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
In-Reply-To: <20130506142539.227119865@linutronix.de>
References: <20130506142539.227119865@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Generic chip: Cache per irq bit mask
Git-Commit-ID: 966dc736b819999cd2d3a6408d47d33b579f7d56
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

Commit-ID:  966dc736b819999cd2d3a6408d47d33b579f7d56
Gitweb:     http://git.kernel.org/tip/966dc736b819999cd2d3a6408d47d33b579f7d56
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 6 May 2013 14:30:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:10 +0200

genirq: Generic chip: Cache per irq bit mask

Cache the per irq bit mask instead of recalculating it over and over.

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
Link: http://lkml.kernel.org/r/20130506142539.227119865@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |  4 ++++
 kernel/irq/generic-chip.c | 23 ++++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7f1f015..d5fc7f5 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
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
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index da2a941..957155c 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -35,7 +35,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
@@ -54,7 +54,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	*ct->mask_cache |= mask;
@@ -73,7 +73,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	*ct->mask_cache &= ~mask;
@@ -92,7 +92,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
@@ -108,7 +108,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
@@ -123,7 +123,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	u32 mask = ~d->mask;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
@@ -138,7 +138,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
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
@@ -264,6 +264,11 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
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
