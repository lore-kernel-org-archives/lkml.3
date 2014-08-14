Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaHNLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:16:29 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44785 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaHNLQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:16:07 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [RFC PATCH 3/3] irqchip: gic: Add support for IPI FIQ
Date: Thu, 14 Aug 2014 12:15:51 +0100
Message-Id: <1408014951-24820-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
References: <53EC9404.5010908@linaro.org>
 <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support IPI FIQ we alter gic_cpu_init() to honour SMP_IPI_FIQ_MASK and
register a fairly high priority notifier to acknowledge and clear the IPI
when it is triggered.

For the IPI FIQ to be useful we must also make it safe to call
gic_raise_softirq() from the FIQ handler by altering the locking
strategy slightly.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/irqchip/irq-gic.c | 126 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 107 insertions(+), 19 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d928912..240cc87 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/ratelimit.h>
 
 #include <asm/cputype.h>
 #ifdef CONFIG_FIQ
@@ -51,6 +52,10 @@
 #include "irq-gic-common.h"
 #include "irqchip.h"
 
+#ifndef SMP_IPI_FIQ_MASK
+#define SMP_IPI_FIQ_MASK 0
+#endif
+
 union gic_base {
 	void __iomem *common_base;
 	void __percpu * __iomem *percpu_base;
@@ -77,6 +82,8 @@ struct gic_chip_data {
 };
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+/* A fiq-safe spinlock must only be locked when the FIQ is masked */
+static DEFINE_RAW_SPINLOCK(fiq_safe_migration_lock);
 
 /*
  * The GIC mapping of CPU interfaces does not necessarily match
@@ -346,20 +353,21 @@ static struct irq_chip gic_chip = {
  * match what "ARM strongly recommends" for a system where no Group 1
  * interrupt must ever preempt a Group 0 interrupt.
  */
-static void gic_set_group_irq(struct irq_data *d, int group)
+static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
+				int group)
 {
-	unsigned int grp_reg = gic_irq(d) / 32 * 4;
-	u32 grp_mask = 1 << (gic_irq(d) % 32);
+	unsigned int grp_reg = hwirq / 32 * 4;
+	u32 grp_mask = 1 << (hwirq % 32);
 	u32 grp_val;
 
-	unsigned int pri_reg = (gic_irq(d) / 4) * 4;
-	u32 pri_mask = 1 << (7 + ((gic_irq(d) % 4) * 8));
+	unsigned int pri_reg = (hwirq / 4) * 4;
+	u32 pri_mask = 1 << (7 + ((hwirq % 4) * 8));
 	u32 pri_val;
 
 	raw_spin_lock(&irq_controller_lock);
 
-	grp_val = readl_relaxed(gic_dist_base(d) + GIC_DIST_IGROUP + grp_reg);
-	pri_val = readl_relaxed(gic_dist_base(d) + GIC_DIST_PRI + pri_reg);
+	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
+	pri_val = readl_relaxed(base + GIC_DIST_PRI + pri_reg);
 
 	if (group) {
 		grp_val |= grp_mask;
@@ -369,20 +377,20 @@ static void gic_set_group_irq(struct irq_data *d, int group)
 		pri_val &= ~pri_mask;
 	}
 
-	writel_relaxed(grp_val, gic_dist_base(d) + GIC_DIST_IGROUP + grp_reg);
-	writel_relaxed(pri_val, gic_dist_base(d) + GIC_DIST_PRI + pri_reg);
+	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
+	writel_relaxed(pri_val, base + GIC_DIST_PRI + pri_reg);
 
 	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_enable_fiq(struct irq_data *d)
 {
-	gic_set_group_irq(d, 0);
+	gic_set_group_irq(gic_dist_base(d), gic_irq(d), 0);
 }
 
 static void gic_disable_fiq(struct irq_data *d)
 {
-	gic_set_group_irq(d, 1);
+	gic_set_group_irq(gic_dist_base(d), gic_irq(d), 1);
 }
 
 static int gic_ack_fiq(struct irq_data *d)
@@ -430,7 +438,63 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 	for (i = 0; i < num_irqs; i++)
 		fiq_register_mapping(first_irq + i, &gic_fiq);
 }
+
+/*
+ * Fully acknowledge (both ack and eoi) a FIQ-based IPI
+ */
+static int gic_eoi_fiq_ipi(struct notifier_block *nb, unsigned long expected,
+			   void *data)
+{
+	struct gic_chip_data *gic = &gic_data[0];
+	void __iomem *cpu_base = gic_data_cpu_base(gic);
+	unsigned long irqstat, irqnr, last_irqnr;
+
+	if (WARN_ON(!in_nmi()))
+		return NOTIFY_BAD;
+
+	irqnr = -1;
+	do {
+		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
+		writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+
+		last_irqnr = irqnr;
+		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+		if (likely(irqnr == expected))
+			return NOTIFY_OK;
+
+		/* We're in pretty serious trouble if we get here. We cannot
+		 * safely call the handler for the unexpected interrupt either
+		 * because we don't know how (if it is a FIQ) or we can't do so
+		 * safely (if it is an IRQ). The only recovery possible is to
+		 * spuriously EOI (which we've already done by this point) and
+		 * hope this is sufficient to clear the spurious FIQ.
+		 */
+		WARN_RATELIMIT(1, "Unexpected irqnr %lu (expected %lu)\n",
+			       irqnr, expected);
+	} while (last_irqnr != irqnr);
+
+	/* We've become stuck EOIing the same interrupt. There's nothing
+	 * more we can do here except hope that "something has changed" and
+	 * that the FIQ handler doesn't re-enter.
+	 *
+	 * We ratelimit the message because expecting something to change
+	 * is really quite optimistic.
+	 */
+	pr_crit_ratelimited("gic_eoi_fiq_ipi: Stuck on %lu, giving up\n",
+			    irqnr);
+	return NOTIFY_BAD;
+}
+
+/*
+ * Notifier to ensure IPI FIQ is acknowledged correctly.
+ */
+static struct notifier_block gic_fiq_ipi_notifier = {
+	.notifier_call = gic_eoi_fiq_ipi,
+	.priority = 100,
+};
 #else /* CONFIG_FIQ */
+static inline void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
+				     int group) {}
 static inline void gic_init_fiq(struct gic_chip_data *gic,
 				irq_hw_number_t first_irq,
 				unsigned int num_irqs) {}
@@ -508,6 +572,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	void __iomem *base = gic_data_cpu_base(gic);
 	unsigned int cpu_mask, cpu = smp_processor_id();
 	int i;
+	u32 val;
 
 	/*
 	 * Get what the GIC says our CPU mask is.
@@ -527,14 +592,19 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	gic_cpu_config(dist_base, NULL);
 
 	/*
-	 * Set all PPI and SGI interrupts to be group 1.
-	 *
-	 * If grouping is not available (not implemented or prohibited by
-	 * security mode) these registers are read-as-zero/write-ignored.
+	 * Optionally set all PPI and SGI interrupts to be group 1.
 	 */
 	if (gic_data_fiq_enable(gic))
 		writel_relaxed(0xffffffff, dist_base + GIC_DIST_IGROUP + 0);
 
+	/*
+	 * Optionally shift the FIQ based IPIs to group 0.
+	 */
+	if (gic_data_fiq_enable(gic))
+		for (i = 0; i < 16; i++)
+			if (SMP_IPI_FIQ_MASK & (1 << i))
+				gic_set_group_irq(dist_base, i, 0);
+
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
 	if (gic_data_fiq_enable(gic))
 		writel_relaxed(0x1f, base + GIC_CPU_CTRL);
@@ -747,7 +817,17 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	unsigned long flags, map = 0;
 	unsigned long softint;
 
-	raw_spin_lock_irqsave(&irq_controller_lock, flags);
+	/*
+	 * The locking in this function ensures we don't use stale cpu mappings
+	 * and thus we never route an IPI to the wrong physical core during a
+	 * big.LITTLE switch. The switch code takes both of these locks meaning
+	 * we can choose whichever lock is safe to use from our current calling
+	 * context.
+	 */
+	if (in_nmi())
+		raw_spin_lock(&fiq_safe_migration_lock);
+	else
+		raw_spin_lock_irqsave(&irq_controller_lock, flags);
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -761,12 +841,16 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 
 	/* this always happens on GIC0 */
 	softint = map << 16 | irq;
-	if (gic_data_fiq_enable(&gic_data[0]))
+	if (gic_data_fiq_enable(&gic_data[0]) &&
+	    !(SMP_IPI_FIQ_MASK & (1 << irq)))
 		softint |= 0x8000;
 	writel_relaxed(softint,
 		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
+	if (in_nmi())
+		raw_spin_unlock(&fiq_safe_migration_lock);
+	else
+		raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
 }
 #endif
 
@@ -814,7 +898,7 @@ int gic_get_cpu_id(unsigned int cpu)
  * Migrate all peripheral interrupts with a target matching the current CPU
  * to the interface corresponding to @new_cpu_id.  The CPU interface mapping
  * is also updated.  Targets to other CPU interfaces are unchanged.
- * This must be called with IRQs locally disabled.
+ * This must be called with IRQ and FIQ locally disabled.
  */
 void gic_migrate_target(unsigned int new_cpu_id)
 {
@@ -836,6 +920,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
 	ror_val = (cur_cpu_id - new_cpu_id) & 31;
 
 	raw_spin_lock(&irq_controller_lock);
+	raw_spin_lock(&fiq_safe_migration_lock);
 
 	/* Update the target interface for this logical CPU */
 	gic_cpu_map[cpu] = 1 << new_cpu_id;
@@ -855,6 +940,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
 		}
 	}
 
+	raw_spin_unlock(&fiq_safe_migration_lock);
 	raw_spin_unlock(&irq_controller_lock);
 
 	/*
@@ -1125,6 +1211,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_SMP
 		set_smp_cross_call(gic_raise_softirq);
 		register_cpu_notifier(&gic_cpu_notifier);
+		if (gic_data_fiq_enable(gic))
+			register_fiq_ipi_notifier(&gic_fiq_ipi_notifier);
 #endif
 		set_handle_irq(gic_handle_irq);
 	}
-- 
1.9.3

