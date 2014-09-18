Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaIRVvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:51:01 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:53461 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbaIRVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:47:43 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 14/24] irqchip: mips-gic: Remove platform irq_ack/irq_eoi callbacks
Date: Thu, 18 Sep 2014 14:47:20 -0700
Message-Id: <1411076851-28242-15-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for platforms to have their own GIC irq_ack/irq_eoi
callbacks.  irq_ack need only clear the GIC's edge detector on
edge-triggered interrupts and there's no need at all for irq_eoi.
Also get rid of the mask_ack callback since it's not necessary either.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
Tested-by: Qais Yousef <qais.yousef@imgtec.com>
---
Changes from v1:
 - made irq_ack only clear the edge detector
 - removed irq_eoi and irq_mask_ack
---
 arch/mips/include/asm/gic.h     |  2 --
 arch/mips/mti-malta/malta-int.c | 16 ----------------
 arch/mips/mti-sead3/sead3-int.c | 21 ---------------------
 drivers/irqchip/irq-mips-gic.c  | 11 ++++++++---
 4 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 022d831..1bf7985 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -376,7 +376,5 @@ extern void gic_bind_eic_interrupt(int irq, int set);
 extern unsigned int gic_get_timer_pending(void);
 extern void gic_get_int_mask(unsigned long *dst, const unsigned long *src);
 extern unsigned int gic_get_int(void);
-extern void gic_irq_ack(struct irq_data *d);
-extern void gic_finish_irq(struct irq_data *d);
 extern void gic_platform_init(int irqs, struct irq_chip *irq_controller);
 #endif /* _ASM_GICREGS_H */
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index 5c31208..b60adfd 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -715,22 +715,6 @@ int malta_be_handler(struct pt_regs *regs, int is_fixup)
 	return retval;
 }
 
-void gic_irq_ack(struct irq_data *d)
-{
-	int irq = (d->irq - gic_irq_base);
-
-	GIC_CLR_INTR_MASK(irq);
-
-	if (gic_irq_flags[irq] & GIC_TRIG_EDGE)
-		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
-}
-
-void gic_finish_irq(struct irq_data *d)
-{
-	/* Enable interrupts. */
-	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
-}
-
 void __init gic_platform_init(int irqs, struct irq_chip *irq_controller)
 {
 	int i;
diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index 9d5b5bd..03f9865 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -85,27 +85,6 @@ void __init arch_init_irq(void)
 			ARRAY_SIZE(gic_intr_map), MIPS_GIC_IRQ_BASE);
 }
 
-void gic_irq_ack(struct irq_data *d)
-{
-	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
-}
-
-void gic_finish_irq(struct irq_data *d)
-{
-	unsigned int irq = (d->irq - gic_irq_base);
-	unsigned int i, irq_source;
-
-	/* Clear edge detectors. */
-	for (i = 0; i < gic_shared_intr_map[irq].num_shared_intr; i++) {
-		irq_source = gic_shared_intr_map[irq].intr_list[i];
-		if (gic_irq_flags[irq_source] & GIC_TRIG_EDGE)
-			GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq_source);
-	}
-
-	/* Enable interrupts. */
-	GIC_SET_INTR_MASK(irq);
-}
-
 void __init gic_platform_init(int irqs, struct irq_chip *irq_controller)
 {
 	int i;
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 9e9d8b9..b0daee5 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -237,6 +237,13 @@ static void gic_unmask_irq(struct irq_data *d)
 	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
 }
 
+static void gic_ack_irq(struct irq_data *d)
+{
+	/* Clear edge detector */
+	if (gic_irq_flags[d->irq - gic_irq_base] & GIC_TRIG_EDGE)
+		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), d->irq - gic_irq_base);
+}
+
 #ifdef CONFIG_SMP
 static DEFINE_SPINLOCK(gic_lock);
 
@@ -272,11 +279,9 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 
 static struct irq_chip gic_irq_controller = {
 	.name			=	"MIPS GIC",
-	.irq_ack		=	gic_irq_ack,
+	.irq_ack		=	gic_ack_irq,
 	.irq_mask		=	gic_mask_irq,
-	.irq_mask_ack		=	gic_mask_irq,
 	.irq_unmask		=	gic_unmask_irq,
-	.irq_eoi		=	gic_finish_irq,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	=	gic_set_affinity,
 #endif
-- 
2.1.0.rc2.206.gedb03e5

