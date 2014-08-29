Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaH2WOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:14:52 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52536 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaH2WOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:47 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] MIPS: GIC: Implement irq_set_type callback
Date: Fri, 29 Aug 2014 15:14:34 -0700
Message-Id: <1409350479-19108-8-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement an irq_set_type callback for the GIC which is used to set
the polarity and trigger type of GIC interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h |  9 ++++++++
 arch/mips/kernel/irq-gic.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 1146803..3853c15 100644
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
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 42558eb..01fcc28 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -47,6 +47,8 @@ static struct gic_pcpu_mask pcpu_masks[NR_CPUS];
 static struct gic_pending_regs pending_regs[NR_CPUS];
 static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
 
+static struct irq_chip gic_irq_controller;
+
 #if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
 {
@@ -240,6 +242,56 @@ static void gic_unmask_irq(struct irq_data *d)
 	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
 }
 
+static int gic_set_type(struct irq_data *d, unsigned int type)
+{
+	unsigned int irq = d->irq - gic_irq_base;
+	bool is_edge;
+
+	switch (type & IRQ_TYPE_SENSE_MASK) {
+	case IRQ_TYPE_EDGE_FALLING:
+		GIC_SET_POLARITY(irq, GIC_POL_POS);
+		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
+		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		is_edge = true;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		GIC_SET_POLARITY(irq, GIC_POL_NEG);
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
+
+	if (is_edge) {
+		gic_irq_flags[irq] |= GIC_TRIG_EDGE;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+	} else {
+		gic_irq_flags[irq] &= ~GIC_TRIG_EDGE;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 static DEFINE_SPINLOCK(gic_lock);
 
@@ -280,6 +332,7 @@ static struct irq_chip gic_irq_controller = {
 	.irq_mask_ack		=	gic_mask_irq,
 	.irq_unmask		=	gic_unmask_irq,
 	.irq_eoi		=	gic_finish_irq,
+	.irq_set_type		=	gic_set_type,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	=	gic_set_affinity,
 #endif
-- 
2.1.0.rc2.206.gedb03e5

