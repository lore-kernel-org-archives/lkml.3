Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab3GSIzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:55:14 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49061 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759726Ab3GSIzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:55:10 -0400
Message-ID: <1374224105.3819.1.camel@phoenix>
Subject: [PATCH RESEND] irqchip: sun4i: Remove wrong irq_ack callback
 implementation
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 16:55:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet[1], the Interrupt IRQ Pending Registers are
read-only. The implementation of sun4i_irq_ack() is worng becasue it writes
to these read-only registers.

This patch removes the wrong irq_ack callback implementation and all the code
writing to these read-only registers in sun4i_of_init().

[1] http://dl.linux-sunxi.org/A10/A10%20User%20Manual%20-%20v1.20%20%282012-04-09%2c%20DECRYPTED%29.pdf

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
This patch was sent on https://lkml.org/lkml/2013/7/6/59
This resend rebase it on top of 3.11-rc1.

Thanks,
Axel
 drivers/irqchip/irq-sun4i.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index a5438d8..29b75c0a 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -38,18 +38,6 @@ static struct irq_domain *sun4i_irq_domain;
 
 static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-static void sun4i_irq_ack(struct irq_data *irqd)
-{
-	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
-
-	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-}
-
 static void sun4i_irq_mask(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
@@ -76,7 +64,6 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
-	.irq_ack	= sun4i_irq_ack,
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
 };
@@ -114,11 +101,6 @@ static int __init sun4i_of_init(struct device_node *node,
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
 
-	/* Clear all the pending interrupts */
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(1));
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(2));
-
 	/* Enable protection mode */
 	writel(0x01, sun4i_irq_base + SUN4I_IRQ_PROTECTION_REG);
 
-- 
1.8.1.2



