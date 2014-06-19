Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966044AbaFSVes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:34:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:55731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965997AbaFSVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:46 -0400
Message-Id: <20140619212713.923306179@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 13/13] irqchip: spear_shirq: Simplify register access code
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=spear-irqchip-optimize-register-access.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra register data structure is pointless. Move the offsets of
the status and the mask register into the shirq block structure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   61 +++++++++++-------------------------------
 1 file changed, 16 insertions(+), 45 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -27,24 +27,11 @@
 #include "irqchip.h"
 
 /*
- * struct shirq_regs: shared irq register configuration
- *
- * enb_reg: enable register offset
- * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
- * status_reg: status register offset
- * status_reg_mask: status register valid mask
- */
-struct shirq_regs {
-	u32 enb_reg;
-	u32 reset_to_enb;
-	u32 status_reg;
-};
-
-/*
  * struct spear_shirq: shared irq structure
  *
  * base:	Base register address
- * regs:	Register configuration for shared irq block
+ * status_reg:	Status register offset for chained interrupt handler
+ * mask_reg:	Mask register offset for irq chip
  * mask:	Mask to apply to the status register
  * virq_base:	Base virtual interrupt number
  * nr_irqs:	Number of interrupts handled by this block
@@ -54,7 +41,8 @@ struct shirq_regs {
  */
 struct spear_shirq {
 	void __iomem		*base;
-	struct shirq_regs	regs;
+	u32			status_reg;
+	u32			mask_reg;
 	u32			mask;
 	u32			virq_base;
 	u32			nr_irqs;
@@ -72,7 +60,7 @@ static void shirq_irq_mask(struct irq_da
 {
 	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
 	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
-	u32 __iomem *reg = shirq->base + shirq->regs.enb_reg;
+	u32 __iomem *reg = shirq->base + shirq->mask_reg;
 
 	raw_spin_lock(&shirq_lock);
 	val = readl(reg) & ~(0x1 << shift);
@@ -84,7 +72,7 @@ static void shirq_irq_unmask(struct irq_
 {
 	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
 	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
-	u32 __iomem *reg = shirq->base + shirq->regs.enb_reg;
+	u32 __iomem *reg = shirq->base + shirq->mask_reg;
 
 	raw_spin_lock(&shirq_lock);
 	val = readl(reg) | (0x1 << shift);
@@ -103,10 +91,8 @@ static struct spear_shirq spear300_shirq
 	.nr_irqs	= 9,
 	.mask		= ((0x1 << 9) - 1) << 0,
 	.irq_chip	= &shirq_chip,
-	.regs = {
-		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
-		.status_reg = SPEAR300_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR300_INT_STS_MASK_REG,
+	.mask_reg	= SPEAR300_INT_ENB_MASK_REG,
 };
 
 static struct spear_shirq *spear300_shirq_blocks[] = {
@@ -121,9 +107,7 @@ static struct spear_shirq spear310_shirq
 	.nr_irqs	= 8,
 	.mask		= ((0x1 << 8) - 1) << 0,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_ras2 = {
@@ -131,10 +115,7 @@ static struct spear_shirq spear310_shirq
 	.nr_irqs	= 5,
 	.mask		= ((0x1 << 5) - 1) << 8,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_ras3 = {
@@ -142,9 +123,7 @@ static struct spear_shirq spear310_shirq
 	.nr_irqs	= 1,
 	.mask		= ((0x1 << 1) - 1) << 13,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_intrcomm_ras = {
@@ -152,9 +131,7 @@ static struct spear_shirq spear310_shirq
 	.nr_irqs	= 3,
 	.mask		= ((0x1 << 3) - 1) << 14,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq *spear310_shirq_blocks[] = {
@@ -180,9 +157,7 @@ static struct spear_shirq spear320_shirq
 	.nr_irqs	= 3,
 	.mask		= ((0x1 << 3) - 1) << 7,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear320_shirq_ras2 = {
@@ -190,9 +165,7 @@ static struct spear_shirq spear320_shirq
 	.nr_irqs	= 1,
 	.mask		= ((0x1 << 1) - 1) << 10,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear320_shirq_intrcomm_ras = {
@@ -200,9 +173,7 @@ static struct spear_shirq spear320_shirq
 	.nr_irqs	= 11,
 	.mask		= ((0x1 << 11) - 1) << 11,
 	.irq_chip	= &dummy_irq_chip,
-	.regs = {
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-	},
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq *spear320_shirq_blocks[] = {
@@ -217,7 +188,7 @@ static void shirq_handler(unsigned irq,
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
 	u32 pend;
 
-	pend = readl(shirq->base + shirq->regs.status_reg) & shirq->mask;
+	pend = readl(shirq->base + shirq->status_reg) & shirq->mask;
 	pend >>= shirq->offset;
 
 	while (pend) {


