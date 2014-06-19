Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966070AbaFSVfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:35:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:55725 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965908AbaFSVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:45 -0400
Message-Id: <20140619212713.831341023@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 12/13] irqchip: spear_shirq: Use proper irq chips for the
 different SoCs
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-kill-enb-crap.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only spear300 has an actual mask register for the RAS interrupts. Add
an irq chip pointer to the shirq struct and initialize spear300 with
the actual implementation and the others with dummy_irq_chip. The
disabled RAS3 block has no irq chip assigned, so we can check for this
and remove the disabled member.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   97 +++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 52 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -49,7 +49,8 @@ struct shirq_regs {
  * virq_base:	Base virtual interrupt number
  * nr_irqs:	Number of interrupts handled by this block
  * offset:	Bit offset of the first interrupt
- * disabled:	Group is disabled, but accounted
+ * irq_chip:	Interrupt controller chip used for this instance,
+ *		if NULL group is disabled, but accounted
  */
 struct spear_shirq {
 	void __iomem		*base;
@@ -58,19 +59,50 @@ struct spear_shirq {
 	u32			virq_base;
 	u32			nr_irqs;
 	u32			offset;
-	bool			disabled;
+	struct irq_chip		*irq_chip;
 };
 
-static DEFINE_SPINLOCK(lock);
-
 /* spear300 shared irq registers offsets and masks */
 #define SPEAR300_INT_ENB_MASK_REG	0x54
 #define SPEAR300_INT_STS_MASK_REG	0x58
 
+static DEFINE_RAW_SPINLOCK(shirq_lock);
+
+static void shirq_irq_mask(struct irq_data *d)
+{
+	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
+	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
+	u32 __iomem *reg = shirq->base + shirq->regs.enb_reg;
+
+	raw_spin_lock(&shirq_lock);
+	val = readl(reg) & ~(0x1 << shift);
+	writel(val, reg);
+	raw_spin_unlock(&shirq_lock);
+}
+
+static void shirq_irq_unmask(struct irq_data *d)
+{
+	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
+	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
+	u32 __iomem *reg = shirq->base + shirq->regs.enb_reg;
+
+	raw_spin_lock(&shirq_lock);
+	val = readl(reg) | (0x1 << shift);
+	writel(val, reg);
+	raw_spin_unlock(&shirq_lock);
+}
+
+static struct irq_chip shirq_chip = {
+	.name		= "spear-shirq",
+	.irq_mask	= shirq_irq_mask,
+	.irq_unmask	= shirq_irq_unmask,
+};
+
 static struct spear_shirq spear300_shirq_ras1 = {
 	.offset		= 0,
 	.nr_irqs	= 9,
 	.mask		= ((0x1 << 9) - 1) << 0,
+	.irq_chip	= &shirq_chip,
 	.regs = {
 		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
 		.status_reg = SPEAR300_INT_STS_MASK_REG,
@@ -88,8 +120,8 @@ static struct spear_shirq spear310_shirq
 	.offset		= 0,
 	.nr_irqs	= 8,
 	.mask		= ((0x1 << 8) - 1) << 0,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
 	},
 };
@@ -98,6 +130,7 @@ static struct spear_shirq spear310_shirq
 	.offset		= 8,
 	.nr_irqs	= 5,
 	.mask		= ((0x1 << 5) - 1) << 8,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -108,8 +141,8 @@ static struct spear_shirq spear310_shirq
 	.offset		= 13,
 	.nr_irqs	= 1,
 	.mask		= ((0x1 << 1) - 1) << 13,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
 	},
 };
@@ -118,8 +151,8 @@ static struct spear_shirq spear310_shirq
 	.offset		= 14,
 	.nr_irqs	= 3,
 	.mask		= ((0x1 << 3) - 1) << 14,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
 	},
 };
@@ -140,15 +173,14 @@ static struct spear_shirq spear320_shirq
 	.offset		= 0,
 	.nr_irqs	= 7,
 	.mask		= ((0x1 << 7) - 1) << 0,
-	.disabled	= 1,
 };
 
 static struct spear_shirq spear320_shirq_ras1 = {
 	.offset		= 7,
 	.nr_irqs	= 3,
 	.mask		= ((0x1 << 3) - 1) << 7,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
 	},
 };
@@ -157,8 +189,8 @@ static struct spear_shirq spear320_shirq
 	.offset		= 10,
 	.nr_irqs	= 1,
 	.mask		= ((0x1 << 1) - 1) << 10,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
 	},
 };
@@ -167,8 +199,8 @@ static struct spear_shirq spear320_shirq
 	.offset		= 11,
 	.nr_irqs	= 11,
 	.mask		= ((0x1 << 11) - 1) << 11,
+	.irq_chip	= &dummy_irq_chip,
 	.regs = {
-		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
 	},
 };
@@ -180,45 +212,6 @@ static struct spear_shirq *spear320_shir
 	&spear320_shirq_intrcomm_ras,
 };
 
-static void shirq_irq_mask_unmask(struct irq_data *d, bool mask)
-{
-	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
-	u32 val, offset = d->irq - shirq->virq_base;
-	unsigned long flags;
-
-	if (shirq->regs.enb_reg == -1)
-		return;
-
-	spin_lock_irqsave(&lock, flags);
-	val = readl(shirq->base + shirq->regs.enb_reg);
-
-	if (mask ^ shirq->regs.reset_to_enb)
-		val &= ~(0x1 << shirq->offset << offset);
-	else
-		val |= 0x1 << shirq->offset << offset;
-
-	writel(val, shirq->base + shirq->regs.enb_reg);
-	spin_unlock_irqrestore(&lock, flags);
-
-}
-
-static void shirq_irq_mask(struct irq_data *d)
-{
-	shirq_irq_mask_unmask(d, 1);
-}
-
-static void shirq_irq_unmask(struct irq_data *d)
-{
-	shirq_irq_mask_unmask(d, 0);
-}
-
-static struct irq_chip shirq_chip = {
-	.name		= "spear-shirq",
-	.irq_ack	= shirq_irq_mask,
-	.irq_mask	= shirq_irq_mask,
-	.irq_unmask	= shirq_irq_unmask,
-};
-
 static void shirq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
@@ -240,7 +233,7 @@ static void __init spear_shirq_register(
 {
 	int i;
 
-	if (shirq->disabled)
+	if (!shirq->irq_chip)
 		return;
 
 	irq_set_chained_handler(parent_irq, shirq_handler);
@@ -248,7 +241,7 @@ static void __init spear_shirq_register(
 
 	for (i = 0; i < shirq->nr_irqs; i++) {
 		irq_set_chip_and_handler(shirq->virq_base + i,
-					 &shirq_chip, handle_simple_irq);
+					 shirq->irq_chip, handle_simple_irq);
 		set_irq_flags(shirq->virq_base + i, IRQF_VALID);
 		irq_set_chip_data(shirq->virq_base + i, shirq);
 	}


