Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaKGGp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:45:29 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51797 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKGGpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:45:17 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org
Cc: arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: [PATCH V4 10/14] irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume functions
Date: Thu,  6 Nov 2014 22:44:25 -0800
Message-Id: <1415342669-30640-11-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cached value already incorporates irq_fwd_mask, and was saved the
last time an IRQ was enabled/disabled.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index b70679f8..9841121 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -37,7 +37,6 @@ struct bcm7120_l2_intc_data {
 	bool can_wake;
 	u32 irq_fwd_mask;
 	u32 irq_map_mask;
-	u32 saved_mask;
 };
 
 static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
@@ -62,14 +61,11 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct bcm7120_l2_intc_data *b = gc->private;
-	u32 reg;
 
 	irq_gc_lock(gc);
-	/* Save the current mask and the interrupt forward mask */
-	b->saved_mask = __raw_readl(b->base + IRQEN) | b->irq_fwd_mask;
 	if (b->can_wake) {
-		reg = b->saved_mask | gc->wake_active;
-		__raw_writel(reg, b->base + IRQEN);
+		__raw_writel(gc->mask_cache | gc->wake_active,
+			     b->base + IRQEN);
 	}
 	irq_gc_unlock(gc);
 }
@@ -77,11 +73,10 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 static void bcm7120_l2_intc_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct bcm7120_l2_intc_data *b = gc->private;
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	__raw_writel(b->saved_mask, b->base + IRQEN);
+	__raw_writel(gc->mask_cache, b->base + IRQEN);
 	irq_gc_unlock(gc);
 }
 
-- 
2.1.1

