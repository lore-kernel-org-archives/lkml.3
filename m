Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbbAUREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:04:20 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34870 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbbAURD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:03:57 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH v2 3/5] irq: gic: Add support for NMI routing
Date: Wed, 21 Jan 2015 17:03:40 +0000
Message-Id: <1421859822-3621-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
 <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an implementation of irq_set_nmi_routing by
allowing SPIs to be switched between group 1 (IRQ) and group 0 (FIQ).

It also repaces the interface used between the default FIQ handler and
the GIC. These extensions are required in order to allow SPIs to be
acknowledged and completed.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/kernel/traps.c         | 29 +++++++++++++++----
 drivers/irqchip/irq-gic.c       | 64 +++++++++++++++++++++++++++++------------
 include/linux/irqchip/arm-gic.h |  6 +++-
 3 files changed, 74 insertions(+), 25 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 5645f81ac4cc..445fdf26b1af 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/irqchip/arm-gic.h>
 
 #include <linux/atomic.h>
@@ -462,6 +463,23 @@ die_sig:
 	arm_notify_die("Oops - undefined instruction", regs, &info, 0, 6);
 }
 
+int arch_filter_nmi_handler(irq_handler_t handler)
+{
+	irq_handler_t whitelist[] = {
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(whitelist); i++)
+		if (handler == whitelist[i]) {
+			pr_debug("%pS accepted for use as NMI handler\n",
+				handler);
+			return 0;
+		}
+
+	pr_err("%pS cannot be used as an NMI handler\n", handler);
+	return -EPERM;
+}
+
 /*
  * Handle FIQ similarly to NMI on x86 systems.
  *
@@ -478,19 +496,20 @@ asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
 {
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
+	enum irqreturn irqret = 0;
 
 	__inc_irq_stat(cpu, __nmi_count);
 	nmi_enter();
 
-#ifdef CONFIG_ARM_GIC
-	gic_handle_fiq_ipi();
-#endif
+	irqret = gic_handle_fiq();
+
+	if (irqret == IRQ_NONE) {
 #ifdef CONFIG_SMP
-	ipi_cpu_backtrace(regs);
+		ipi_cpu_backtrace(regs);
 #endif
+	}
 
 	nmi_exit();
-
 	set_irq_regs(old_regs);
 }
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index c4f4a8827ed8..658c6dd5cf08 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -129,6 +129,9 @@ struct irq_chip gic_arch_extn = {
 
 static struct gic_chip_data gic_data[MAX_GIC_NR] __read_mostly;
 
+static int gic_set_group_irq(struct gic_chip_data *gic, unsigned int hwirq,
+			     int group);
+
 #ifdef CONFIG_GIC_NON_BANKED
 static void __iomem *gic_get_percpu_base(union gic_base *base)
 {
@@ -214,6 +217,18 @@ static void gic_eoi_irq(struct irq_data *d)
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 }
 
+static int gic_set_nmi_routing(struct irq_data *d, unsigned int nmi)
+{
+	struct gic_chip_data *gic = irq_data_get_irq_chip_data(d);
+	int ret;
+
+	ret = gic_set_group_irq(gic, gic_irq(d), !nmi);
+	if (ret >= 0)
+		ret = !ret;
+
+	return ret;
+}
+
 static int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(d);
@@ -346,6 +361,7 @@ static struct irq_chip gic_chip = {
 	.irq_mask		= gic_mask_irq,
 	.irq_unmask		= gic_unmask_irq,
 	.irq_eoi		= gic_eoi_irq,
+	.irq_set_nmi_routing    = gic_set_nmi_routing,
 	.irq_set_type		= gic_set_type,
 	.irq_retrigger		= gic_retrigger,
 #ifdef CONFIG_SMP
@@ -364,8 +380,8 @@ static struct irq_chip gic_chip = {
  * If is safe to call this function on systems which do not support
  * grouping (it will have no effect).
  */
-static void gic_set_group_irq(struct gic_chip_data *gic, unsigned int hwirq,
-			      int group)
+static int gic_set_group_irq(struct gic_chip_data *gic, unsigned int hwirq,
+			     int group)
 {
 	void __iomem *base = gic_data_dist_base(gic);
 	unsigned int grp_reg = hwirq / 32 * 4;
@@ -381,7 +397,7 @@ static void gic_set_group_irq(struct gic_chip_data *gic, unsigned int hwirq,
 	 * the EnableGrp1 bit set.
 	 */
 	if (!(GICD_ENABLE_GRP1 & readl_relaxed(base + GIC_DIST_CTRL)))
-		return;
+		return -EINVAL;
 
 	raw_spin_lock(&irq_controller_lock);
 
@@ -403,32 +419,42 @@ static void gic_set_group_irq(struct gic_chip_data *gic, unsigned int hwirq,
 	writel_relaxed(pri_val, base + GIC_DIST_PRI + pri_reg);
 
 	raw_spin_unlock(&irq_controller_lock);
-}
 
+	return group;
+}
 
-/*
- * Fully acknowledge (both ack and eoi) any outstanding FIQ-based IPI,
- * otherwise do nothing.
- */
-void gic_handle_fiq_ipi(void)
+enum irqreturn gic_handle_fiq(void)
 {
 	struct gic_chip_data *gic = &gic_data[0];
 	void __iomem *cpu_base = gic_data_cpu_base(gic);
-	unsigned long irqstat, irqnr;
+	unsigned long irqstat, hwirq;
+	unsigned int irq = 0;
+
+	/*
+	 * This function is called unconditionally by the default FIQ
+	 * handler so first we must check that the driver it
+	 * initialized.
+	 */
+	if (!gic->gic_irqs)
+		return IRQ_NONE;
 
 	if (WARN_ON(!in_nmi()))
-		return;
+		return IRQ_NONE;
 
-	while ((1u << readl_relaxed(cpu_base + GIC_CPU_HIGHPRI)) &
-	       SMP_IPI_FIQ_MASK) {
-		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
-		writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+	/* read intack with the priority mask set so we only acknowledge FIQs */
+	writel_relaxed(GICC_INT_PRI_THRESHOLD >> 1, cpu_base + GIC_CPU_PRIMASK);
+	irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
+	writel_relaxed(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
 
-		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
-		WARN_RATELIMIT(irqnr > 16,
-			       "Unexpected irqnr %lu (bad prioritization?)\n",
-			       irqnr);
+	hwirq = irqstat & GICC_IAR_INT_ID_MASK;
+	if (likely(hwirq > 15 && hwirq < 1021)) {
+		irq = irq_find_mapping(gic->domain, hwirq);
+		handle_nmi_irq(irq);
 	}
+
+	writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
+
+	return IRQ_RETVAL(irq);
 }
 
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 7690f70049a3..265ea31a5711 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -127,7 +127,11 @@ static inline void __init register_routable_domain_ops
 	gic_routable_irq_domain_ops = ops;
 }
 
-void gic_handle_fiq_ipi(void);
+#ifdef CONFIG_ARM_GIC
+enum irqreturn gic_handle_fiq(void);
+#else
+enum irqreturn gic_handle_fiq(void) { return IRQ_NONE; }
+#endif
 
 #endif /* __ASSEMBLY */
 #endif
-- 
1.9.3

