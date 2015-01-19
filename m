Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbbASLv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:51:59 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:3024 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbASLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:51:57 -0500
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] MIPS: irq-mips-gic.c: handle pending interrupts once in __gic_irq_dispatch()
Date: Mon, 19 Jan 2015 11:51:29 +0000
Message-ID: <1421668289-828-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an interrupt occurs __gic_irq_dispatch() continuously reads local and shared pending registers
until all is serviced before returning. The problem with that is that it could introduce
a long delay before returning if a piece of hardware keeps triggering while in one of these loops.

To ensure fairness and priority doesn't get skewed a lot, read local and shared pending registers once
to service each pending IRQ once.
If another interupt triggers while servicing the current ones, then we shall re-enter the handler after
we return.

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/irqchip/irq-mips-gic.c | 44 +++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 2b0468e3df6a..f3f9873dfb68 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -234,9 +234,9 @@ int gic_get_c0_perfcount_int(void)
 				  GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_PERFCTR));
 }
 
-static unsigned int gic_get_int(void)
+static void gic_handle_shared_int(void)
 {
-	unsigned int i;
+	unsigned int i, intr, virq;
 	unsigned long *pcpu_mask;
 	unsigned long pending_reg, intrmask_reg;
 	DECLARE_BITMAP(pending, GIC_MAX_INTRS);
@@ -258,7 +258,16 @@ static unsigned int gic_get_int(void)
 	bitmap_and(pending, pending, intrmask, gic_shared_intrs);
 	bitmap_and(pending, pending, pcpu_mask, gic_shared_intrs);
 
-	return find_first_bit(pending, gic_shared_intrs);
+	intr = find_first_bit(pending, gic_shared_intrs);
+	while (intr != gic_shared_intrs) {
+		virq = irq_linear_revmap(gic_irq_domain,
+					 GIC_SHARED_TO_HWIRQ(intr));
+		do_IRQ(virq);
+
+		/* go to next pending bit */
+		bitmap_clear(pending, intr, 1);
+		intr = find_first_bit(pending, gic_shared_intrs);
+	}
 }
 
 static void gic_mask_irq(struct irq_data *d)
@@ -385,16 +394,26 @@ static struct irq_chip gic_edge_irq_controller = {
 #endif
 };
 
-static unsigned int gic_get_local_int(void)
+static void gic_handle_local_int(void)
 {
 	unsigned long pending, masked;
+	unsigned int intr, virq;
 
 	pending = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_PEND));
 	masked = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_MASK));
 
 	bitmap_and(&pending, &pending, &masked, GIC_NUM_LOCAL_INTRS);
 
-	return find_first_bit(&pending, GIC_NUM_LOCAL_INTRS);
+	intr = find_first_bit(&pending, GIC_NUM_LOCAL_INTRS);
+	while (intr != GIC_NUM_LOCAL_INTRS) {
+		virq = irq_linear_revmap(gic_irq_domain,
+					 GIC_LOCAL_TO_HWIRQ(intr));
+		do_IRQ(virq);
+
+		/* go to next pending bit */
+		bitmap_clear(&pending, intr, 1);
+		intr = find_first_bit(&pending, GIC_NUM_LOCAL_INTRS);
+	}
 }
 
 static void gic_mask_local_irq(struct irq_data *d)
@@ -453,19 +472,8 @@ static struct irq_chip gic_all_vpes_local_irq_controller = {
 
 static void __gic_irq_dispatch(void)
 {
-	unsigned int intr, virq;
-
-	while ((intr = gic_get_local_int()) != GIC_NUM_LOCAL_INTRS) {
-		virq = irq_linear_revmap(gic_irq_domain,
-					 GIC_LOCAL_TO_HWIRQ(intr));
-		do_IRQ(virq);
-	}
-
-	while ((intr = gic_get_int()) != gic_shared_intrs) {
-		virq = irq_linear_revmap(gic_irq_domain,
-					 GIC_SHARED_TO_HWIRQ(intr));
-		do_IRQ(virq);
-	}
+	gic_handle_local_int();
+	gic_handle_shared_int();
 }
 
 static void gic_irq_dispatch(unsigned int irq, struct irq_desc *desc)
-- 
2.1.0

