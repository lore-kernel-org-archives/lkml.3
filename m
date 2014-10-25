Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaJYVwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:52:35 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:39401 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbaJYVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:07 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] irqchip: GIC: Convert to EOImode == 1
Date: Sat, 25 Oct 2014 12:06:54 +0100
Message-Id: <1414235215-10468-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jason@lakedaemon.net, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, GICv2 has been used in with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself. This is also rather
inefficient for threaded interrupts, as it forces us to hit the
distributor (which is slower, specially when using virtualization).

For this case, the GIC architecture provides EOImode == 1, where:
- A write to the EOI register drops the priority of the interrupt and leaves
it active. Other interrupts at the same priority level can now be taken,
but the active interrupt cannot be taken again
- A write to the DIR marks the interrupt as inactive, meaning it can
now be taken again.

We only enable this feature when booted in HYP mode. Also, as most device
trees are broken (they report the CPU interface size to be 4kB, while
the GICv2 CPU interface size is 8kB), output a warning if we're booted
in HYP mode, and disable the feature.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c       | 64 +++++++++++++++++++++++++++++++++++++----
 include/linux/irqchip/arm-gic.h |  4 +++
 2 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d78169e..53aedc8 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -44,6 +44,7 @@
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
+#include <asm/virt.h>
 
 #include "irq-gic-common.h"
 #include "irqchip.h"
@@ -93,6 +94,10 @@ struct irq_chip gic_arch_extn = {
 	.irq_set_wake	= NULL,
 };
 
+static struct irq_chip *gic_chip;
+
+static bool supports_deactivate = false;
+
 #ifndef MAX_GIC_NR
 #define MAX_GIC_NR	1
 #endif
@@ -192,6 +197,16 @@ static void gic_eoi_irq(struct irq_data *d)
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 }
 
+static void gic_priority_drop_irq(struct irq_data *d)
+{
+	gic_eoi_irq(d);
+}
+
+static void gic_deactivate_irq(struct irq_data *d)
+{
+	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
+}
+
 static void gic_irq_set_irqchip_state(struct irq_data *d, int state, int val)
 {
 	u32 reg;
@@ -333,6 +348,8 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 		}
 		if (irqnr < 16) {
 			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+			if (supports_deactivate)
+				writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #endif
@@ -369,7 +386,7 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static struct irq_chip gic_chip = {
+static struct irq_chip gicv1_chip = {
 	.name			= "GIC",
 	.irq_mask		= gic_mask_irq,
 	.irq_unmask		= gic_unmask_irq,
@@ -384,6 +401,23 @@ static struct irq_chip gic_chip = {
 	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
 };
 
+static struct irq_chip gicv2_chip = {
+	.name			= "GIC",
+	.flags			= IRQCHIP_EOI_THREADED,
+	.irq_mask		= gic_mask_irq,
+	.irq_unmask		= gic_unmask_irq,
+	.irq_priority_drop	= gic_priority_drop_irq,
+	.irq_eoi		= gic_deactivate_irq,
+	.irq_set_type		= gic_set_type,
+	.irq_retrigger		= gic_retrigger,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= gic_set_affinity,
+#endif
+	.irq_set_wake		= gic_set_wake,
+	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
+	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+};
+
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
 	if (gic_nr >= MAX_GIC_NR)
@@ -415,7 +449,11 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 static void gic_cpu_if_up(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	u32 bypass = 0;
+	u32 bypass;
+	u32 mode = 0;
+
+	if (supports_deactivate)
+		mode = GIC_CPU_CTRL_EOImodeNS;
 
 	/*
 	* Preserve bypass disable bits to be written back later
@@ -423,7 +461,7 @@ static void gic_cpu_if_up(void)
 	bypass = readl(cpu_base + GIC_CPU_CTRL);
 	bypass &= GICC_DIS_BYPASS_MASK;
 
-	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(bypass | mode | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
 }
 
 
@@ -848,11 +886,11 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 {
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
+		irq_set_chip_and_handler(irq, gic_chip,
 					 handle_percpu_devid_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	} else {
-		irq_set_chip_and_handler(irq, &gic_chip,
+		irq_set_chip_and_handler(irq, gic_chip,
 					 handle_fasteoi_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 
@@ -1031,6 +1069,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
 
+	if (!supports_deactivate)
+		gic_chip = &gicv1_chip;
+	else
+		gic_chip = &gicv2_chip;
+
 	if (of_property_read_u32(node, "arm,routable-irqs",
 				 &nr_routable_irqs)) {
 		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
@@ -1060,7 +1103,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		set_handle_irq(gic_handle_irq);
 	}
 
-	gic_chip.flags |= gic_arch_extn.flags;
+	gic_chip->flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
 	gic_cpu_init(gic);
 	gic_pm_init(gic);
@@ -1074,6 +1117,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
+	struct resource cpu_res;
 	u32 percpu_offset;
 	int irq;
 
@@ -1086,6 +1130,14 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	cpu_base = of_iomap(node, 1);
 	WARN(!cpu_base, "unable to map gic cpu registers\n");
 
+	of_address_to_resource(node, 1, &cpu_res);
+	if (is_hyp_mode_available()) {
+		if (resource_size(&cpu_res) >= SZ_8K)
+			supports_deactivate = true;
+		else
+			pr_warn("GIC: CPU interface size is %x, DT is probably wrong\n", (int)resource_size(&cpu_res));
+	}
+
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 13eed92..e8de29a 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -20,9 +20,13 @@
 #define GIC_CPU_ALIAS_BINPOINT		0x1c
 #define GIC_CPU_ACTIVEPRIO		0xd0
 #define GIC_CPU_IDENT			0xfc
+#define GIC_CPU_DEACTIVATE		0x1000
 
 #define GICC_ENABLE			0x1
 #define GICC_INT_PRI_THRESHOLD		0xf0
+
+#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
+
 #define GICC_IAR_INT_ID_MASK		0x3ff
 #define GICC_INT_SPURIOUS		1023
 #define GICC_DIS_BYPASS_MASK		0x1e0
-- 
2.1.0

