Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaIRVun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:50:43 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:55571 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbaIRVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:47:44 -0400
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
Subject: [PATCH V2 15/24] irqchip: mips-gic: Implement irq_set_type callback
Date: Thu, 18 Sep 2014 14:47:21 -0700
Message-Id: <1411076851-28242-16-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement an irq_set_type callback for the GIC which is used to set
the polarity and trigger type of GIC interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
Tested-by: Qais Yousef <qais.yousef@imgtec.com>
---
Changes from v1:
 - hold spinlock across gic_set_type because of r-m-w ops
---
 arch/mips/include/asm/gic.h    |  9 +++++++
 drivers/irqchip/irq-mips-gic.c | 57 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 1bf7985..662b567 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -23,6 +23,8 @@
 #define GIC_POL_NEG			0
 #define GIC_TRIG_EDGE			1
 #define GIC_TRIG_LEVEL			0
+#define GIC_TRIG_DUAL_ENABLE		1
+#define GIC_TRIG_DUAL_DISABLE		0
 
 #define MSK(n) ((1 << (n)) - 1)
 #define REG32(addr)		(*(volatile unsigned int *) (addr))
@@ -179,6 +181,13 @@
 		GIC_INTR_OFS(intr)), (1 << GIC_INTR_BIT(intr)), \
 		(trig) << GIC_INTR_BIT(intr))
 
+/* Dual edge triggering : Reset Value is always 0 */
+#define GIC_SH_SET_DUAL_OFS		0x0200
+#define GIC_SET_DUAL(intr, dual) \
+	GICBIS(GIC_REG_ADDR(SHARED, GIC_SH_SET_DUAL_OFS + \
+		GIC_INTR_OFS(intr)), (1 << GIC_INTR_BIT(intr)), \
+		(dual) << GIC_INTR_BIT(intr))
+
 /* Mask manipulation */
 #define GIC_SH_SMASK_OFS		0x0380
 #define GIC_SET_INTR_MASK(intr) \
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index b0daee5..e9abb08 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -43,6 +43,7 @@ struct gic_intrmask_regs {
 static struct gic_pcpu_mask pcpu_masks[NR_CPUS];
 static struct gic_pending_regs pending_regs[NR_CPUS];
 static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
+static DEFINE_SPINLOCK(gic_lock);
 
 #if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
@@ -244,9 +245,60 @@ static void gic_ack_irq(struct irq_data *d)
 		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), d->irq - gic_irq_base);
 }
 
-#ifdef CONFIG_SMP
-static DEFINE_SPINLOCK(gic_lock);
+static int gic_set_type(struct irq_data *d, unsigned int type)
+{
+	unsigned int irq = d->irq - gic_irq_base;
+	unsigned long flags;
+	bool is_edge;
+
+	spin_lock_irqsave(&gic_lock, flags);
+	switch (type & IRQ_TYPE_SENSE_MASK) {
+	case IRQ_TYPE_EDGE_FALLING:
+		GIC_SET_POLARITY(irq, GIC_POL_NEG);
+		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		is_edge = true;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		GIC_SET_POLARITY(irq, GIC_POL_POS);
+		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		is_edge = true;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		/* polarity is irrelevant in this case */
+		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_ENABLE);
+		is_edge = true;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		GIC_SET_POLARITY(irq, GIC_POL_NEG);
+		GIC_SET_TRIGGER(irq, GIC_TRIG_LEVEL);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		is_edge = false;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+	default:
+		GIC_SET_POLARITY(irq, GIC_POL_POS);
+		GIC_SET_TRIGGER(irq, GIC_TRIG_LEVEL);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		is_edge = false;
+		break;
+	}
 
+	if (is_edge) {
+		gic_irq_flags[irq] |= GIC_TRIG_EDGE;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+	} else {
+		gic_irq_flags[irq] &= ~GIC_TRIG_EDGE;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+	}
+	spin_unlock_irqrestore(&gic_lock, flags);
+
+	return 0;
+}
+
+#ifdef CONFIG_SMP
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 			    bool force)
 {
@@ -282,6 +334,7 @@ static struct irq_chip gic_irq_controller = {
 	.irq_ack		=	gic_ack_irq,
 	.irq_mask		=	gic_mask_irq,
 	.irq_unmask		=	gic_unmask_irq,
+	.irq_set_type		=	gic_set_type,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	=	gic_set_affinity,
 #endif
-- 
2.1.0.rc2.206.gedb03e5

