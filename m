Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166AbaFSVgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:36:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55701 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbaFSVen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:43 -0400
Message-Id: <20140619212713.496614337@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 08/13] irqchip: spear_shirq: Precalculate status mask
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-precalc-mask.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate the status mask at compile time, not at runtime.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -49,6 +49,7 @@ struct shirq_regs {
  *
  * base:	Base register address
  * regs:	Register configuration for shared irq block
+ * mask:	Mask to apply to the status register
  * virq_base:	Base virtual interrupt number
  * nr_irqs:	Number of interrupts handled by this block
  * offset:	Bit offset of the first interrupt
@@ -57,6 +58,7 @@ struct shirq_regs {
 struct spear_shirq {
 	void __iomem		*base;
 	struct shirq_regs	regs;
+	u32			mask;
 	u32			virq_base;
 	u32			nr_irqs;
 	u32			offset;
@@ -72,6 +74,7 @@ static DEFINE_SPINLOCK(lock);
 static struct spear_shirq spear300_shirq_ras1 = {
 	.offset		= 0,
 	.nr_irqs	= 9,
+	.mask		= ((0x1 << 9) - 1) << 0,
 	.regs = {
 		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
 		.status_reg = SPEAR300_INT_STS_MASK_REG,
@@ -89,6 +92,7 @@ static struct spear_shirq *spear300_shir
 static struct spear_shirq spear310_shirq_ras1 = {
 	.offset		= 0,
 	.nr_irqs	= 8,
+	.mask		= ((0x1 << 8) - 1) << 0,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -99,6 +103,7 @@ static struct spear_shirq spear310_shirq
 static struct spear_shirq spear310_shirq_ras2 = {
 	.offset		= 8,
 	.nr_irqs	= 5,
+	.mask		= ((0x1 << 5) - 1) << 8,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -109,6 +114,7 @@ static struct spear_shirq spear310_shirq
 static struct spear_shirq spear310_shirq_ras3 = {
 	.offset		= 13,
 	.nr_irqs	= 1,
+	.mask		= ((0x1 << 1) - 1) << 13,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -119,6 +125,7 @@ static struct spear_shirq spear310_shirq
 static struct spear_shirq spear310_shirq_intrcomm_ras = {
 	.offset		= 14,
 	.nr_irqs	= 3,
+	.mask		= ((0x1 << 3) - 1) << 14,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -141,6 +148,7 @@ static struct spear_shirq *spear310_shir
 static struct spear_shirq spear320_shirq_ras3 = {
 	.offset		= 0,
 	.nr_irqs	= 7,
+	.mask		= ((0x1 << 7) - 1) << 0,
 	.disabled	= 1,
 	.regs = {
 		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
@@ -154,6 +162,7 @@ static struct spear_shirq spear320_shirq
 static struct spear_shirq spear320_shirq_ras1 = {
 	.offset		= 7,
 	.nr_irqs	= 3,
+	.mask		= ((0x1 << 3) - 1) << 7,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -165,6 +174,7 @@ static struct spear_shirq spear320_shirq
 static struct spear_shirq spear320_shirq_ras2 = {
 	.offset		= 10,
 	.nr_irqs	= 1,
+	.mask		= ((0x1 << 1) - 1) << 10,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -176,6 +186,7 @@ static struct spear_shirq spear320_shirq
 static struct spear_shirq spear320_shirq_intrcomm_ras = {
 	.offset		= 11,
 	.nr_irqs	= 11,
+	.mask		= ((0x1 << 11) - 1) << 11,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -239,7 +250,7 @@ static void shirq_handler(unsigned irq,
 
 	chip->irq_ack(idata);
 
-	mask = ((0x1 << shirq->nr_irqs) - 1) << shirq->offset;
+	mask = shirq->mask;
 	while ((val = readl(shirq->base + shirq->regs.status_reg) &
 				mask)) {
 


