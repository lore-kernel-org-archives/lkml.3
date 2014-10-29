Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaJ2D7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:59:19 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56145 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaJ2D7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:59:15 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH 07/11] irqchip: brcmstb-l2: Use irq_reg_* accessors
Date: Tue, 28 Oct 2014 20:58:54 -0700
Message-Id: <1414555138-6500-7-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change was just made on bcm7120-l2, so let's keep things consistent
between the two drivers.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-brcmstb-l2.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index c9bdf20..8b82b86 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -58,8 +58,8 @@ static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 
 	chained_irq_enter(chip, desc);
 
-	status = __raw_readl(b->base + CPU_STATUS) &
-		~(__raw_readl(b->base + CPU_MASK_STATUS));
+	status = irq_reg_readl(b->base + CPU_STATUS) &
+		~(irq_reg_readl(b->base + CPU_MASK_STATUS));
 
 	if (status == 0) {
 		raw_spin_lock(&desc->lock);
@@ -71,7 +71,7 @@ static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 	do {
 		irq = ffs(status) - 1;
 		/* ack at our level */
-		__raw_writel(1 << irq, b->base + CPU_CLEAR);
+		irq_reg_writel(1 << irq, b->base + CPU_CLEAR);
 		status &= ~(1 << irq);
 		generic_handle_irq(irq_find_mapping(b->domain, irq));
 	} while (status);
@@ -86,12 +86,12 @@ static void brcmstb_l2_intc_suspend(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	/* Save the current mask */
-	b->saved_mask = __raw_readl(b->base + CPU_MASK_STATUS);
+	b->saved_mask = irq_reg_readl(b->base + CPU_MASK_STATUS);
 
 	if (b->can_wake) {
 		/* Program the wakeup mask */
-		__raw_writel(~gc->wake_active, b->base + CPU_MASK_SET);
-		__raw_writel(gc->wake_active, b->base + CPU_MASK_CLEAR);
+		irq_reg_writel(~gc->wake_active, b->base + CPU_MASK_SET);
+		irq_reg_writel(gc->wake_active, b->base + CPU_MASK_CLEAR);
 	}
 	irq_gc_unlock(gc);
 }
@@ -103,11 +103,11 @@ static void brcmstb_l2_intc_resume(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	/* Clear unmasked non-wakeup interrupts */
-	__raw_writel(~b->saved_mask & ~gc->wake_active, b->base + CPU_CLEAR);
+	irq_reg_writel(~b->saved_mask & ~gc->wake_active, b->base + CPU_CLEAR);
 
 	/* Restore the saved mask */
-	__raw_writel(b->saved_mask, b->base + CPU_MASK_SET);
-	__raw_writel(~b->saved_mask, b->base + CPU_MASK_CLEAR);
+	irq_reg_writel(b->saved_mask, b->base + CPU_MASK_SET);
+	irq_reg_writel(~b->saved_mask, b->base + CPU_MASK_CLEAR);
 	irq_gc_unlock(gc);
 }
 
@@ -132,8 +132,8 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	}
 
 	/* Disable all interrupts by default */
-	__raw_writel(0xffffffff, data->base + CPU_MASK_SET);
-	__raw_writel(0xffffffff, data->base + CPU_CLEAR);
+	irq_reg_writel(0xffffffff, data->base + CPU_MASK_SET);
+	irq_reg_writel(0xffffffff, data->base + CPU_CLEAR);
 
 	data->parent_irq = irq_of_parse_and_map(np, 0);
 	if (data->parent_irq < 0) {
-- 
2.1.1

