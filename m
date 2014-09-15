Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaIOX44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:56:56 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50551 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaIOX4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:56:53 -0400
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
Subject: [PATCH 17/24] irqchip: mips-gic: Use IRQ domains
Date: Mon, 15 Sep 2014 16:51:20 -0700
Message-Id: <1410825087-5497-18-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a simple IRQ domain for the MIPS GIC.  Remove the gic_platform_init
callback as it's no longer necessary for it to set the irqchip.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h     |  1 -
 arch/mips/mti-malta/malta-int.c |  8 -------
 arch/mips/mti-sead3/sead3-int.c | 15 --------------
 drivers/irqchip/irq-mips-gic.c  | 46 +++++++++++++++++++++++++++++++++--------
 4 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 662b567..efcf4de 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -385,5 +385,4 @@ extern void gic_bind_eic_interrupt(int irq, int set);
 extern unsigned int gic_get_timer_pending(void);
 extern void gic_get_int_mask(unsigned long *dst, const unsigned long *src);
 extern unsigned int gic_get_int(void);
-extern void gic_platform_init(int irqs, struct irq_chip *irq_controller);
 #endif /* _ASM_GICREGS_H */
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index b60adfd..e56563c 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -714,11 +714,3 @@ int malta_be_handler(struct pt_regs *regs, int is_fixup)
 
 	return retval;
 }
-
-void __init gic_platform_init(int irqs, struct irq_chip *irq_controller)
-{
-	int i;
-
-	for (i = gic_irq_base; i < (gic_irq_base + irqs); i++)
-		irq_set_chip(i, irq_controller);
-}
diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index 03f9865..8f36342 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -85,18 +85,3 @@ void __init arch_init_irq(void)
 			ARRAY_SIZE(gic_intr_map), MIPS_GIC_IRQ_BASE);
 }
 
-void __init gic_platform_init(int irqs, struct irq_chip *irq_controller)
-{
-	int i;
-
-	/*
-	 * For non-EIC mode, we want to setup the GIC in pass-through
-	 * mode, as if the GIC didn't exist. Do not map any interrupts
-	 * for an external interrupt controller.
-	 */
-	if (!cpu_has_veic)
-		return;
-
-	for (i = gic_irq_base; i < (gic_irq_base + irqs); i++)
-		irq_set_chip_and_handler(i, irq_controller, handle_percpu_irq);
-}
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index fd00318..b4d87c4 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -43,6 +43,7 @@ struct gic_intrmask_regs {
 static struct gic_pcpu_mask pcpu_masks[NR_CPUS];
 static struct gic_pending_regs pending_regs[NR_CPUS];
 static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
+static struct irq_domain *gic_irq_domain;
 
 #if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
@@ -229,26 +230,28 @@ unsigned int gic_get_int(void)
 
 static void gic_mask_irq(struct irq_data *d)
 {
-	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
+	GIC_CLR_INTR_MASK(d->hwirq);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
-	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
+	GIC_SET_INTR_MASK(d->hwirq);
 }
 
 static void gic_ack_irq(struct irq_data *d)
 {
-	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
+	unsigned int irq = d->hwirq;
+
+	GIC_CLR_INTR_MASK(irq);
 
 	/* Clear edge detector */
-	if (gic_irq_flags[d->irq - gic_irq_base] & GIC_TRIG_EDGE)
-		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), d->irq - gic_irq_base);
+	if (gic_irq_flags[irq] & GIC_TRIG_EDGE)
+		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
 {
-	unsigned int irq = d->irq - gic_irq_base;
+	unsigned int irq = d->hwirq;
 	bool is_edge;
 
 	switch (type & IRQ_TYPE_SENSE_MASK) {
@@ -302,7 +305,7 @@ static DEFINE_SPINLOCK(gic_lock);
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 			    bool force)
 {
-	unsigned int irq = (d->irq - gic_irq_base);
+	unsigned int irq = d->hwirq;
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
 	int		i;
@@ -347,6 +350,7 @@ static void __init gic_setup_intr(unsigned int intr, unsigned int cpu,
 	unsigned int flags)
 {
 	struct gic_shared_intr_map *map_ptr;
+	int i;
 
 	/* Setup Intr to Pin mapping */
 	if (pin & GIC_MAP_TO_NMI_MSK) {
@@ -384,6 +388,8 @@ static void __init gic_setup_intr(unsigned int intr, unsigned int cpu,
 	GIC_CLR_INTR_MASK(intr);
 
 	/* Initialise per-cpu Interrupt software masks */
+	for (i = 0; i < NR_CPUS; i++)
+		clear_bit(intr, pcpu_masks[i].pcpu_mask);
 	set_bit(intr, pcpu_masks[cpu].pcpu_mask);
 
 	if ((flags & GIC_FLAG_TRANSPARENT) && (cpu_has_veic == 0))
@@ -435,6 +441,25 @@ static void __init gic_basic_init(int numintrs, int numvpes,
 	vpe_local_setup(numvpes);
 }
 
+static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
+			      irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &gic_irq_controller, handle_level_irq);
+
+	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(hw)),
+		 GIC_MAP_TO_PIN_MSK | 0);
+	/* Map to VPE 0 by default */
+	GIC_SH_MAP_TO_VPE_SMASK(hw, 0);
+	set_bit(hw, pcpu_masks[0].pcpu_mask);
+
+	return 0;
+}
+
+static struct irq_domain_ops gic_irq_domain_ops = {
+	.map = gic_irq_domain_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
 void __init gic_init(unsigned long gic_base_addr,
 		     unsigned long gic_addrspace_size,
 		     struct gic_intr_map *intr_map, unsigned int intr_map_size,
@@ -456,7 +481,10 @@ void __init gic_init(unsigned long gic_base_addr,
 		  GIC_SH_CONFIG_NUMVPES_SHF;
 	numvpes = numvpes + 1;
 
-	gic_basic_init(numintrs, numvpes, intr_map, intr_map_size);
+	gic_irq_domain = irq_domain_add_simple(NULL, GIC_NUM_INTRS, irqbase,
+					       &gic_irq_domain_ops, NULL);
+	if (!gic_irq_domain)
+		panic("Failed to add GIC IRQ domain");
 
-	gic_platform_init(numintrs, &gic_irq_controller);
+	gic_basic_init(numintrs, numvpes, intr_map, intr_map_size);
 }
-- 
2.1.0.rc2.206.gedb03e5

