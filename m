Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaH2WPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:15:53 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:48087 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaH2WOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:50 -0400
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
Subject: [PATCH 10/12] MIPS: GIC: Support local interrupts
Date: Fri, 29 Aug 2014 15:14:37 -0700
Message-Id: <1409350479-19108-11-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPS GIC supports 7 local interrupts, 5 of which are just core
interrupts which can be re-routed through the GIC.  This patch adds
support for mapping and handling the remaining two: the GIC timer
and watchdog.  GIC interrupts from 0 to GIC_NUM_INTRS are still the
shared external interrupts while interrupts from GIC_NUM_INTRS to
GIC_NUM_INTRS + GIC_NUM_LOCAL_INTRS are local interrupts.

With device-tree based probing, the GIC local interrupts will be routed
to the first GIC-to-CPU pin.  For platforms using a static mapping, the
local interrupts can be initialized by extending the interrupt mapping
table passed to gic_init.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h              |  12 ++
 arch/mips/include/asm/mach-generic/irq.h |   2 +
 arch/mips/kernel/irq-gic.c               | 183 +++++++++++++++++++++++++++----
 3 files changed, 175 insertions(+), 22 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 3853c15..d5b2d84 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -217,6 +217,10 @@
 #define GIC_VPE_COMPARE_LO_OFS		0x00a0
 #define GIC_VPE_COMPARE_HI_OFS		0x00a4
 
+#define GIC_VPE_MAP_OFS			0x0040
+#define GIC_VPE_MAP_TO_PIN(intr) \
+	(GIC_VPE_MAP_OFS + 4 * (intr))
+
 #define GIC_VPE_EIC_SHADOW_SET_BASE	0x0100
 #define GIC_VPE_EIC_SS(intr) \
 	(GIC_VPE_EIC_SHADOW_SET_BASE + (4 * intr))
@@ -354,6 +358,11 @@ struct gic_shared_intr_map {
 #define GIC_CPU_PIN_OFFSET	2
 
 /* Local GIC interrupts. */
+#define GIC_LOCAL_INTR_WD	0 /* GIC watchdog timer */
+#define GIC_LOCAL_INTR_COMPARE	1 /* GIC count/compare timer */
+#define GIC_NUM_LOCAL_INTRS	2
+
+/* Pin mapping for CPU interrupts routable through the GIC. */
 #define GIC_INT_TMR		(GIC_CPU_INT5)
 #define GIC_INT_PERFCTR		(GIC_CPU_INT5)
 
@@ -389,6 +398,9 @@ extern void gic_bind_eic_interrupt(int irq, int set);
 extern unsigned int gic_get_timer_pending(void);
 extern void gic_get_int_mask(unsigned long *dst, const unsigned long *src);
 extern unsigned int gic_get_int(void);
+extern void gic_get_local_int_mask(unsigned long *dst,
+				   const unsigned long *src);
+extern unsigned int gic_get_local_int(void);
 extern void gic_enable_interrupt(int irq_vec);
 extern void gic_disable_interrupt(int irq_vec);
 extern void gic_irq_ack(struct irq_data *d);
diff --git a/arch/mips/include/asm/mach-generic/irq.h b/arch/mips/include/asm/mach-generic/irq.h
index c0fc62b..89bc185 100644
--- a/arch/mips/include/asm/mach-generic/irq.h
+++ b/arch/mips/include/asm/mach-generic/irq.h
@@ -40,6 +40,8 @@
 #ifndef MIPS_GIC_IRQ_BASE
 #define MIPS_GIC_IRQ_BASE (MIPS_CPU_IRQ_BASE + 8)
 #endif
+
+#define MIPS_GIC_LOCAL_IRQ_BASE (MIPS_GIC_IRQ_BASE + GIC_NUM_INTRS)
 #endif /* CONFIG_IRQ_GIC */
 
 #endif /* __ASM_MACH_GENERIC_IRQ_H */
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 4ee3ad8..7f66d6e 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -49,6 +49,21 @@ static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
 
 static struct irq_chip gic_irq_controller;
 
+static inline bool gic_is_local_irq(unsigned int hwirq)
+{
+	return hwirq >= GIC_NUM_INTRS;
+}
+
+static inline unsigned int gic_hw_to_local_irq(unsigned int hwirq)
+{
+	return hwirq - GIC_NUM_INTRS;
+}
+
+static inline unsigned int gic_local_to_hw_irq(unsigned int irq)
+{
+	return irq + GIC_NUM_INTRS;
+}
+
 #if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
 {
@@ -232,28 +247,77 @@ unsigned int gic_get_int(void)
 	return find_first_bit(interrupts, GIC_NUM_INTRS);
 }
 
+void gic_get_local_int_mask(unsigned long *dst, const unsigned long *src)
+{
+	unsigned long pending, intrmask;
+
+	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_PEND), pending);
+	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_MASK), intrmask);
+
+	bitmap_and(&pending, &pending, &intrmask, GIC_NUM_LOCAL_INTRS);
+	bitmap_and(dst, src, &pending, GIC_NUM_LOCAL_INTRS);
+}
+
+unsigned int gic_get_local_int(void)
+{
+	unsigned long interrupts;
+
+	bitmap_fill(&interrupts, GIC_NUM_LOCAL_INTRS);
+	gic_get_local_int_mask(&interrupts, &interrupts);
+
+	return find_first_bit(&interrupts, GIC_NUM_LOCAL_INTRS);
+}
+
 static void gic_mask_irq(struct irq_data *d)
 {
-	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
+	unsigned int irq = d->irq - gic_irq_base;
+
+	if (gic_is_local_irq(irq)) {
+		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK),
+			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
+	} else {
+		GIC_CLR_INTR_MASK(irq);
+	}
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
-	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
+	unsigned int irq = d->irq - gic_irq_base;
+
+	if (gic_is_local_irq(irq)) {
+		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK),
+			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
+	} else {
+		GIC_SET_INTR_MASK(irq);
+	}
 }
 
 void __weak gic_irq_ack(struct irq_data *d)
 {
-	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
+	unsigned int irq = d->irq - gic_irq_base;
 
-	/* Clear edge detector */
-	if (gic_irq_flags[d->irq - gic_irq_base] & GIC_TRIG_EDGE)
-		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), d->irq - gic_irq_base);
+	if (gic_is_local_irq(irq)) {
+		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK),
+			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
+	} else {
+		GIC_CLR_INTR_MASK(irq);
+
+		/* Clear edge detector */
+		if (gic_irq_flags[irq] & GIC_TRIG_EDGE)
+			GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
+	}
 }
 
 void __weak gic_finish_irq(struct irq_data *d)
 {
-	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
+	unsigned int irq = d->irq - gic_irq_base;
+
+	if (gic_is_local_irq(irq)) {
+		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK),
+			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
+	} else {
+		GIC_SET_INTR_MASK(irq);
+	}
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
@@ -261,6 +325,9 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	unsigned int irq = d->irq - gic_irq_base;
 	bool is_edge;
 
+	if (gic_is_local_irq(irq))
+		return -EINVAL;
+
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
 		GIC_SET_POLARITY(irq, GIC_POL_POS);
@@ -317,6 +384,9 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	unsigned long	flags;
 	int		i;
 
+	if (gic_is_local_irq(irq))
+		return -EINVAL;
+
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
 		return -EINVAL;
@@ -402,6 +472,42 @@ static void __init gic_setup_intr(unsigned int intr, unsigned int cpu,
 		gic_irq_flags[intr] |= GIC_TRIG_EDGE;
 }
 
+static void __init gic_setup_local_intr(unsigned int intr, unsigned int pin,
+				unsigned int flags)
+{
+	struct gic_shared_intr_map *map_ptr;
+	unsigned int local_irq = gic_hw_to_local_irq(intr);
+	int i;
+
+	/* Setup Intr to Pin mapping */
+	for (i = 0; i < nr_cpu_ids; i++) {
+		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+		if (pin & GIC_MAP_TO_NMI_MSK) {
+			GICWRITE(GIC_REG_ADDR(VPE_OTHER,
+					GIC_VPE_MAP_TO_PIN(local_irq)), pin);
+		} else {
+			GICWRITE(GIC_REG_ADDR(VPE_OTHER,
+					GIC_VPE_MAP_TO_PIN(local_irq)),
+				 GIC_MAP_TO_PIN_MSK | pin);
+		}
+	}
+
+	if (!(pin & GIC_MAP_TO_NMI_MSK) && cpu_has_veic) {
+		set_vi_handler(pin + GIC_PIN_TO_VEC_OFFSET,
+			       gic_eic_irq_dispatch);
+		map_ptr = &gic_shared_intr_map[pin + GIC_PIN_TO_VEC_OFFSET];
+		if (map_ptr->num_shared_intr >= GIC_MAX_SHARED_INTR)
+			BUG();
+		map_ptr->intr_list[map_ptr->num_shared_intr++] = intr;
+	}
+
+	/* Init Intr Masks */
+	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK),
+		 1 << GIC_INTR_BIT(local_irq));
+
+	irq_set_percpu_devid(gic_irq_base + intr);
+}
+
 static void __init gic_basic_init(int numintrs, int numvpes,
 			struct gic_intr_map *intrmap, int mapsize)
 {
@@ -434,12 +540,17 @@ static void __init gic_basic_init(int numintrs, int numvpes,
 		cpu = intrmap[i].cpunum;
 		if (cpu == GIC_UNUSED)
 			continue;
-		gic_setup_intr(i,
-			intrmap[i].cpunum,
-			intrmap[i].pin + pin_offset,
-			intrmap[i].polarity,
-			intrmap[i].trigtype,
-			intrmap[i].flags);
+		if (gic_is_local_irq(i))
+			gic_setup_local_intr(i,
+				intrmap[i].pin + pin_offset,
+				intrmap[i].flags);
+		else
+			gic_setup_intr(i,
+				intrmap[i].cpunum,
+				intrmap[i].pin + pin_offset,
+				intrmap[i].polarity,
+				intrmap[i].trigtype,
+				intrmap[i].flags);
 	}
 
 	vpe_local_setup(numvpes);
@@ -468,7 +579,8 @@ void __init gic_init(unsigned long gic_base_addr,
 
 	gic_basic_init(numintrs, numvpes, intr_map, intr_map_size);
 
-	gic_platform_init(numintrs, &gic_irq_controller);
+	gic_platform_init(GIC_NUM_INTRS + GIC_NUM_LOCAL_INTRS,
+			  &gic_irq_controller);
 }
 
 #ifdef CONFIG_IRQ_DOMAIN
@@ -481,6 +593,8 @@ static int gic_irq_pin[GIC_NUM_INTRS];
 
 static inline int gic_irq_to_cpu_pin(unsigned int hwirq)
 {
+	if (gic_is_local_irq(hwirq))
+		return gic_cpu_pin[0] - MIPS_CPU_IRQ_BASE - GIC_CPU_PIN_OFFSET;
 	return gic_cpu_pin[gic_irq_pin[hwirq]] - MIPS_CPU_IRQ_BASE -
 		GIC_CPU_PIN_OFFSET;
 }
@@ -571,13 +685,31 @@ static inline void gic_ipi_init(struct irq_domain *domain)
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(irq, &gic_irq_controller, handle_level_irq);
+	int i;
 
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(hw)),
-		 GIC_MAP_TO_PIN_MSK | gic_irq_to_cpu_pin(hw));
-	/* Map to VPE 0 by default */
-	GIC_SH_MAP_TO_VPE_SMASK(hw, 0);
-	set_bit(hw, pcpu_masks[0].pcpu_mask);
+	if (gic_is_local_irq(hw)) {
+		int local_irq = gic_hw_to_local_irq(hw);
+
+		irq_set_chip_and_handler(irq, &gic_irq_controller,
+					 handle_percpu_irq);
+		irq_set_percpu_devid(irq);
+
+		for (i = 0; i < nr_cpu_ids; i++) {
+			GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+			GICWRITE(GIC_REG_ADDR(VPE_OTHER,
+					      GIC_VPE_MAP_TO_PIN(local_irq)),
+				 GIC_MAP_TO_PIN_MSK | gic_irq_to_cpu_pin(hw));
+		}
+	} else {
+		irq_set_chip_and_handler(irq, &gic_irq_controller,
+					 handle_level_irq);
+
+		GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(hw)),
+			 GIC_MAP_TO_PIN_MSK | gic_irq_to_cpu_pin(hw));
+		/* Map to VPE 0 by default */
+		GIC_SH_MAP_TO_VPE_SMASK(hw, 0);
+		set_bit(hw, pcpu_masks[0].pcpu_mask);
+	}
 
 	return 0;
 }
@@ -615,6 +747,11 @@ static void gic_irq_dispatch(unsigned int irq, struct irq_desc *desc)
 	struct irq_domain *domain = irq_get_handler_data(irq);
 	unsigned int hwirq;
 
+	while ((hwirq = gic_get_local_int()) != GIC_NUM_LOCAL_INTRS) {
+		irq = irq_linear_revmap(domain, gic_local_to_hw_irq(hwirq));
+		generic_handle_irq(irq);
+	}
+
 	while ((hwirq = gic_get_int()) != GIC_NUM_INTRS) {
 		irq = irq_linear_revmap(domain, hwirq);
 		generic_handle_irq(irq);
@@ -654,8 +791,10 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 
 	gic_init(res.start, resource_size(&res), NULL, 0, MIPS_GIC_IRQ_BASE);
 
-	domain = irq_domain_add_legacy(node, GIC_NUM_INTRS, MIPS_GIC_IRQ_BASE,
-				       0, &gic_irq_domain_ops, NULL);
+	domain = irq_domain_add_legacy(node,
+				       GIC_NUM_INTRS + GIC_NUM_LOCAL_INTRS,
+				       MIPS_GIC_IRQ_BASE, 0,
+				       &gic_irq_domain_ops, NULL);
 	if (!domain) {
 		pr_err("Failed to add GIC IRQ domain\n");
 		return -ENOMEM;
-- 
2.1.0.rc2.206.gedb03e5

