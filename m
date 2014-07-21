Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaGUOsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39731 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbaGUOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:04 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>
Subject: [PATCH RFC 1/9] irqchip: gic: Provide support for interrupt grouping
Date: Mon, 21 Jul 2014 15:47:12 +0100
Message-Id: <1405954040-30399-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All GIC hardware except GICv1-without-TrustZone support provides a means
to group exceptions into group 0 (which can optionally be signally using
use FIQ) and group 1. The kernel currently provides no means to exploit
this. This patch alters the initialization of the GIC to place all
interrupts into group 1 which is the foundational requirement to meaningfully
use FIQ.

Note that the hardware functionality is unavailable to the kernel when a
secure monitor is present because access to the grouping registers are
prohibited outside "secure world" (this feature allows grouping to be
used to allow hardware peripherals to send interrupts into the secure
world). The GIC driver will automatically detect this and disable its
attempts to group interrupts.

On systems without TrustZone support the kernel has the power to route
interrupt sources to FIQ, potentially allowing a driver to exploit the
NMI-like properties of FIQ.

Tested on Freescale i.MX6 (quad A9), STiH416 (dual A9) and a self-written
qemu GICv2 model.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Sricharan R <r.sricharan@ti.com>
Acked-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/irqchip/irq-gic.c | 99 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 7e11c9d..bbffca3 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -42,6 +42,9 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
 
+#ifdef CONFIG_FIQ
+#include <asm/fiq.h>
+#endif
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -68,6 +71,9 @@ struct gic_chip_data {
 #ifdef CONFIG_GIC_NON_BANKED
 	void __iomem *(*get_base)(union gic_base *);
 #endif
+#ifdef CONFIG_FIQ
+	bool fiq_enable;
+#endif
 };
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
@@ -131,6 +137,16 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
 #define gic_set_base_accessor(d, f)
 #endif
 
+#ifdef CONFIG_FIQ
+static inline bool gic_data_fiq_enable(struct gic_chip_data *data)
+{
+	return data->fiq_enable;
+}
+#else
+static inline bool gic_data_fiq_enable(
+		struct gic_chip_data *data) { return false; }
+#endif
+
 static inline void __iomem *gic_dist_base(struct irq_data *d)
 {
 	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
@@ -349,6 +365,42 @@ static struct irq_chip gic_chip = {
 	.irq_set_wake		= gic_set_wake,
 };
 
+#ifdef CONFIG_FIQ
+static void __init gic_init_fiq(struct gic_chip_data *gic,
+				irq_hw_number_t first_irq,
+				unsigned int num_irqs)
+{
+	void __iomem *dist_base = gic_data_dist_base(gic_data);
+	unsigned int i;
+
+	/*
+	 * FIQ can only be supported on platforms without an extended irq_eoi
+	 * method (otherwise we take a lock during eoi handling).
+	 */
+	if (gic_arch_extn.irq_eoi)
+		return;
+
+	/*
+	 * If grouping is not available (not implemented or prohibited by
+	 * security mode) these registers a read-as-zero/write-ignored.
+	 * However as a precaution we restore the reset default regardless of
+	 * the result of the test.
+	 */
+	writel_relaxed(1, dist_base + GIC_DIST_IGROUP + 0);
+	gic->fiq_enable = readl_relaxed(dist_base + GIC_DIST_IGROUP + 0);
+	writel_relaxed(0, dist_base + GIC_DIST_IGROUP + 0);
+	pr_debug("gic: FIQ support %s\n",
+		 gic->fiq_enable ? "enabled" : "disabled");
+
+	if (!gic->fiq_enable)
+		return;
+}
+#else /* CONFIG_FIQ */
+static inline void gic_init_fiq(struct gic_chip_data *gic,
+				irq_hw_number_t first_irq,
+				unsigned int num_irqs) {}
+#endif /* CONFIG_FIQ */
+
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
 	if (gic_nr >= MAX_GIC_NR)
@@ -408,13 +460,28 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i * 4 / 4);
 
 	/*
+	 * Optionally set all global interrupts to be group 1.
+	 */
+	if (gic_data_fiq_enable(gic))
+		for (i = 32; i < gic_irqs; i += 32)
+			writel_relaxed(0xffffffff,
+				       base + GIC_DIST_IGROUP + i * 4 / 32);
+
+	/*
 	 * Disable all interrupts.  Leave the PPI and SGIs alone
 	 * as these enables are banked registers.
 	 */
 	for (i = 32; i < gic_irqs; i += 32)
 		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
-	writel_relaxed(1, base + GIC_DIST_CTRL);
+	/*
+	 * Set EnableGrp1/EnableGrp0 (bit 1 and 0) or EnableGrp (bit 0 only,
+	 * bit 1 ignored)
+	 */
+	if (gic_data_fiq_enable(gic))
+		writel_relaxed(3, base + GIC_DIST_CTRL);
+	else
+		writel_relaxed(1, base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_init(struct gic_chip_data *gic)
@@ -452,8 +519,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	for (i = 0; i < 32; i += 4)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
+	/*
+	 * Set all PPI and SGI interrupts to be group 1.
+	 *
+	 * If grouping is not available (not implemented or prohibited by
+	 * security mode) these registers are read-as-zero/write-ignored.
+	 */
+	if (gic_data_fiq_enable(gic))
+		writel_relaxed(0xffffffff, dist_base + GIC_DIST_IGROUP + 0);
+
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+	if (gic_data_fiq_enable(gic))
+		writel_relaxed(0x1f, base + GIC_CPU_CTRL);
+	else
+		writel_relaxed(1, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
@@ -537,7 +616,10 @@ static void gic_dist_restore(unsigned int gic_nr)
 		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
 			dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
+	if (gic_data_fiq_enable(&gic_data[gic_nr]))
+		writel_relaxed(3, dist_base + GIC_DIST_CTRL);
+	else
+		writel_relaxed(1, dist_base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_save(unsigned int gic_nr)
@@ -594,7 +676,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(0x1f, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
@@ -656,6 +738,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
 	unsigned long flags, map = 0;
+	unsigned long softint;
 
 	raw_spin_lock_irqsave(&irq_controller_lock, flags);
 
@@ -670,7 +753,11 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	dmb(ishst);
 
 	/* this always happens on GIC0 */
-	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
+	softint = map << 16 | irq;
+	if (gic_data_fiq_enable(&gic_data[0]))
+		softint |= 0x8000;
+	writel_relaxed(softint,
+		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
 	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
 }
@@ -1014,6 +1101,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 		gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
 					hwirq_base, &gic_irq_domain_ops, gic);
+
+		gic_init_fiq(gic, irq_base, gic_irqs);
 	} else {
 		gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
 						    &gic_irq_domain_ops,
-- 
1.9.3

