Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaIKLc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:32:29 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44785 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaIKLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:31:38 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17-rc4 v5 4/6] irqchip: gic: Add support for IPI FIQ
Date: Thu, 11 Sep 2014 12:31:16 +0100
Message-Id: <1410435078-28462-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org>
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org>
 <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides support for arm's newly added IPI FIQ. It works
by placing all interrupt sources *except* IPI FIQ in group 1 and
then flips a configuration bit in the GIC such that group 1
interrupts use IRQ and group 0 interrupts use FIQ.

All GIC hardware except GICv1-without-TrustZone support provides a means
to group exceptions into group 0 and group 1. However the hardware
functionality is unavailable to the kernel when a secure monitor is
present because access to the grouping registers are prohibited outside
"secure world" (a feature that allows grouping to be used to allow
hardware peripherals to send interrupts into the secure world). However
when grouping is not available we can rely on the GIC's RAZ/WI semantics
and avoid conditional code.

Tested on Freescale i.MX6 (quad A9, GICv1-with-TrustZone running in
secure mode).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 arch/arm/kernel/traps.c         |   5 +-
 drivers/irqchip/irq-gic.c       | 140 ++++++++++++++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic.h |   3 +
 3 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 439138d..92c4ea1 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/irq.h>
+#include <linux/irqchip/arm-gic.h>
 
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
@@ -479,7 +480,9 @@ asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
 
 	nmi_enter();
 
-	/* nop. FIQ handlers for special arch/arm features can be added here. */
+#ifdef CONFIG_ARM_GIC
+	gic_handle_fiq_ipi();
+#endif
 
 	nmi_exit();
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e6..0d67b0e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -39,8 +39,10 @@
 #include <linux/slab.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/ratelimit.h>
 
 #include <asm/cputype.h>
+#include <asm/fiq.h>
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -48,6 +50,10 @@
 #include "irq-gic-common.h"
 #include "irqchip.h"
 
+#ifndef SMP_IPI_FIQ_MASK
+#define SMP_IPI_FIQ_MASK 0
+#endif
+
 union gic_base {
 	void __iomem *common_base;
 	void __percpu * __iomem *percpu_base;
@@ -325,6 +331,94 @@ static struct irq_chip gic_chip = {
 	.irq_set_wake		= gic_set_wake,
 };
 
+/*
+ * Shift an interrupt between Group 0 and Group 1.
+ *
+ * In addition to changing the group we also modify the priority to
+ * match what "ARM strongly recommends" for a system where no Group 1
+ * interrupt must ever preempt a Group 0 interrupt.
+ *
+ * If is safe to call this function on systems which do not support
+ * grouping (it will have no effect).
+ */
+static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
+				int group)
+{
+	unsigned int grp_reg = hwirq / 32 * 4;
+	u32 grp_mask = BIT(hwirq % 32);
+	u32 grp_val;
+
+	unsigned int pri_reg = (hwirq / 4) * 4;
+	u32 pri_mask = BIT(7 + ((hwirq % 4) * 8));
+	u32 pri_val;
+
+	/*
+	 * Systems which do not support grouping will have no bits
+	 * set in IGROUP[0] (and all systems which do will have set bits).
+	 */
+	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + 0);
+	if (!grp_val)
+		return;
+
+	raw_spin_lock(&irq_controller_lock);
+
+	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
+	pri_val = readl_relaxed(base + GIC_DIST_PRI + pri_reg);
+
+	if (group) {
+		grp_val |= grp_mask;
+		pri_val |= pri_mask;
+	} else {
+		grp_val &= ~grp_mask;
+		pri_val &= ~pri_mask;
+	}
+
+	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
+	writel_relaxed(pri_val, base + GIC_DIST_PRI + pri_reg);
+
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+/*
+ * Test which group an interrupt belongs to.
+ *
+ * Returns 0 if the controller does not support grouping.
+ */
+static int gic_get_group_irq(void __iomem *base, unsigned int hwirq)
+{
+	unsigned int grp_reg = hwirq / 32 * 4;
+	u32 grp_val;
+
+	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
+
+	return (grp_val >> (hwirq % 32)) & 1;
+}
+
+/*
+ * Fully acknowledge (both ack and eoi) any outstanding FIQ-based IPI,
+ * otherwise do nothing.
+ */
+void gic_handle_fiq_ipi(void)
+{
+	struct gic_chip_data *gic = &gic_data[0];
+	void __iomem *cpu_base = gic_data_cpu_base(gic);
+	unsigned long irqstat, irqnr;
+
+	if (WARN_ON(!in_nmi()))
+		return;
+
+	while ((1u << readl_relaxed(cpu_base + GIC_CPU_HIGHPRI)) &
+	       SMP_IPI_FIQ_MASK) {
+		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
+		writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+
+		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+		WARN_RATELIMIT(irqnr > 16,
+			       "Unexpected irqnr %lu (bad prioritization?)\n",
+			       irqnr);
+	}
+}
+
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
 	if (gic_nr >= MAX_GIC_NR)
@@ -373,7 +467,18 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 
 	gic_dist_config(base, gic_irqs, NULL);
 
-	writel_relaxed(1, base + GIC_DIST_CTRL);
+	/*
+	 * Set all global interrupts to be group 1 (this register is
+	 * RAZ/WI if not accessible in current mode)
+	 */
+	for (i = 32; i < gic_irqs; i += 32)
+		writel_relaxed(0xffffffff, base + GIC_DIST_IGROUP + i * 4 / 32);
+
+	/*
+	 * Set EnableGrp1/EnableGrp0 (bit 1 and 0) or EnableGrp (bit 0 only,
+	 * bit 1 ignored)
+	 */
+	writel_relaxed(3, base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_init(struct gic_chip_data *gic)
@@ -382,6 +487,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	void __iomem *base = gic_data_cpu_base(gic);
 	unsigned int cpu_mask, cpu = smp_processor_id();
 	int i;
+	unsigned long secure_irqs, secure_irq;
 
 	/*
 	 * Get what the GIC says our CPU mask is.
@@ -400,8 +506,27 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 
 	gic_cpu_config(dist_base, NULL);
 
+	/*
+	 * Set any PPI and SGI interrupts not set in SMP_IPI_FIQ_MASK
+	 * to be group 1 (this register is RAZ/WI if not accessible)
+	 */
+	writel_relaxed(~SMP_IPI_FIQ_MASK, dist_base + GIC_DIST_IGROUP + 0);
+
+	/*
+	 * Update the priority of any resulting group0 interrupts.
+	 */
+	secure_irqs = ~readl_relaxed(dist_base + GIC_DIST_IGROUP + 0);
+	for_each_set_bit(secure_irq, &secure_irqs, 16)
+		gic_set_group_irq(dist_base, i, 0);
+
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+
+	/* The bottom most bit will be set for all GIC variants (and is
+	 * called Enable or EnableGrp0 depending on operating mode). The
+	 * remaining four bits (CBPR, FIQEn, AckCtl and EnableGrp1) are
+	 * RAZ/WI if not accessible.
+	 */
+	writel_relaxed(0x1f, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
@@ -485,7 +610,7 @@ static void gic_dist_restore(unsigned int gic_nr)
 		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
 			dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
+	writel_relaxed(3, dist_base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_save(unsigned int gic_nr)
@@ -542,7 +667,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(0x1f, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
@@ -604,6 +729,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
 	unsigned long flags, map = 0;
+	unsigned long softint;
 
 	raw_spin_lock_irqsave(&irq_controller_lock, flags);
 
@@ -618,7 +744,11 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	dmb(ishst);
 
 	/* this always happens on GIC0 */
-	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
+	softint = map << 16 | irq;
+	if (gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
+		softint |= 0x8000;
+	writel_relaxed(softint,
+		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
 	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
 }
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c..52a5676 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -101,5 +101,8 @@ static inline void __init register_routable_domain_ops
 {
 	gic_routable_irq_domain_ops = ops;
 }
+
+void gic_handle_fiq_ipi(void);
+
 #endif /* __ASSEMBLY */
 #endif
-- 
1.9.3

