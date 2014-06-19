Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966145AbaFSVgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:36:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:55707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965922AbaFSVen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:43 -0400
Message-Id: <20140619212713.570396433@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 09/13] irqchip: spear_shirq: Kill the clear_reg nonsense
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-kill-clear-reg-nonsense.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the chips has a ACK register. The code brainlessly fiddles
with the enable register, so it might even reenable a disabled
interrupt at least on spear300.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -33,15 +33,11 @@
  * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
  * status_reg: status register offset
  * status_reg_mask: status register valid mask
- * clear_reg: clear register offset
- * reset_to_clear: val 1 indicates, we need to clear bit for clearing interrupt
  */
 struct shirq_regs {
 	u32 enb_reg;
 	u32 reset_to_enb;
 	u32 status_reg;
-	u32 clear_reg;
-	u32 reset_to_clear;
 };
 
 /*
@@ -78,7 +74,6 @@ static struct spear_shirq spear300_shirq
 	.regs = {
 		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
 		.status_reg = SPEAR300_INT_STS_MASK_REG,
-		.clear_reg = -1,
 	},
 };
 
@@ -96,7 +91,6 @@ static struct spear_shirq spear310_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
 	},
 };
 
@@ -107,7 +101,6 @@ static struct spear_shirq spear310_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
 	},
 };
 
@@ -118,7 +111,6 @@ static struct spear_shirq spear310_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
 	},
 };
 
@@ -129,7 +121,6 @@ static struct spear_shirq spear310_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
 	},
 };
 
@@ -150,13 +141,6 @@ static struct spear_shirq spear320_shirq
 	.nr_irqs	= 7,
 	.mask		= ((0x1 << 7) - 1) << 0,
 	.disabled	= 1,
-	.regs = {
-		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
-		.reset_to_enb = 1,
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
-	},
 };
 
 static struct spear_shirq spear320_shirq_ras1 = {
@@ -166,8 +150,6 @@ static struct spear_shirq spear320_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
 	},
 };
 
@@ -178,8 +160,6 @@ static struct spear_shirq spear320_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
 	},
 };
 
@@ -190,8 +170,6 @@ static struct spear_shirq spear320_shirq
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
 	},
 };
 
@@ -246,7 +224,7 @@ static void shirq_handler(unsigned irq,
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
 	struct irq_data *idata = irq_desc_get_irq_data(desc);
 	struct irq_chip *chip = irq_data_get_irq_chip(idata);
-	u32 i, j, val, mask, tmp;
+	u32 i, j, val, mask;
 
 	chip->irq_ack(idata);
 
@@ -261,17 +239,6 @@ static void shirq_handler(unsigned irq,
 				continue;
 
 			generic_handle_irq(shirq->virq_base + i);
-
-			/* clear interrupt */
-			if (shirq->regs.clear_reg == -1)
-				continue;
-
-			tmp = readl(shirq->base + shirq->regs.clear_reg);
-			if (shirq->regs.reset_to_clear)
-				tmp &= ~(j << shirq->offset);
-			else
-				tmp |= (j << shirq->offset);
-			writel(tmp, shirq->base + shirq->regs.clear_reg);
 		}
 	}
 	chip->irq_unmask(idata);


