Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJTTHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:07:20 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58135 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJTTEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:11 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] irqchip: mips-gic: Use proper iomem accessors
Date: Mon, 20 Oct 2014 12:03:52 -0700
Message-Id: <1413831846-32100-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the ugly GICREAD/GICWRITE/GICBIS macros and use proper
iomem accessors instead.  Since the GIC registers are not directly
accessed outside of the GIC driver any more, make gic_base static
and move all the GIC register manipulation macros out of gic.h,
converting them to static inline functions.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h    |  72 ++------------
 drivers/irqchip/irq-mips-gic.c | 206 +++++++++++++++++++++++++++--------------
 2 files changed, 142 insertions(+), 136 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index c88e1fa..285944c 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -16,8 +16,6 @@
 
 #include <irq.h>
 
-#undef	GICISBYTELITTLEENDIAN
-
 #define GIC_MAX_INTRS			256
 
 /* Constants */
@@ -29,36 +27,9 @@
 #define GIC_TRIG_DUAL_DISABLE		0
 
 #define MSK(n) ((1 << (n)) - 1)
-#define REG32(addr)		(*(volatile unsigned int *) (addr))
-#define REG(base, offs)		REG32((unsigned long)(base) + offs##_##OFS)
-#define REGP(base, phys)	REG32((unsigned long)(base) + (phys))
 
 /* Accessors */
-#define GIC_REG(segment, offset) \
-	REG32(_gic_base + segment##_##SECTION_OFS + offset##_##OFS)
-#define GIC_REG_ADDR(segment, offset) \
-	REG32(_gic_base + segment##_##SECTION_OFS + offset)
-
-#define GIC_ABS_REG(segment, offset) \
-	(_gic_base + segment##_##SECTION_OFS + offset##_##OFS)
-#define GIC_REG_ABS_ADDR(segment, offset) \
-	(_gic_base + segment##_##SECTION_OFS + offset)
-
-#ifdef GICISBYTELITTLEENDIAN
-#define GICREAD(reg, data)	((data) = (reg), (data) = le32_to_cpu(data))
-#define GICWRITE(reg, data)	((reg) = cpu_to_le32(data))
-#else
-#define GICREAD(reg, data)	((data) = (reg))
-#define GICWRITE(reg, data)	((reg) = (data))
-#endif
-#define GICBIS(reg, mask, bits)			\
-	do { u32 data;				\
-		GICREAD(reg, data);		\
-		data &= ~(mask);		\
-		data |= ((bits) & (mask));	\
-		GICWRITE((reg), data);		\
-	} while (0)
-
+#define GIC_REG(segment, offset) (segment##_##SECTION_OFS + offset##_##OFS)
 
 /* GIC Address Space */
 #define SHARED_SECTION_OFS		0x0000
@@ -155,14 +126,13 @@
 #define GIC_SH_INTR_MAP_TO_PIN_BASE_OFS 0x0500
 
 /* Maps Interrupt X to a Pin */
-#define GIC_SH_MAP_TO_PIN(intr) \
-	(GIC_SH_INTR_MAP_TO_PIN_BASE_OFS + (4 * intr))
+#define GIC_SH_MAP_TO_PIN(intr)		(4 * (intr))
 
 #define GIC_SH_INTR_MAP_TO_VPE_BASE_OFS 0x2000
 
 /* Maps Interrupt X to a VPE */
 #define GIC_SH_MAP_TO_VPE_REG_OFF(intr, vpe) \
-	(GIC_SH_INTR_MAP_TO_VPE_BASE_OFS + (32 * (intr)) + (((vpe) / 32) * 4))
+	((32 * (intr)) + (((vpe) / 32) * 4))
 #define GIC_SH_MAP_TO_VPE_REG_BIT(vpe)	(1 << ((vpe) % 32))
 
 /* Convert an interrupt number to a byte offset/bit for multi-word registers */
@@ -171,34 +141,16 @@
 
 /* Polarity : Reset Value is always 0 */
 #define GIC_SH_SET_POLARITY_OFS		0x0100
-#define GIC_SET_POLARITY(intr, pol) \
-	GICBIS(GIC_REG_ADDR(SHARED, GIC_SH_SET_POLARITY_OFS + \
-		GIC_INTR_OFS(intr)), (1 << GIC_INTR_BIT(intr)), \
-		(pol) << GIC_INTR_BIT(intr))
 
 /* Triggering : Reset Value is always 0 */
 #define GIC_SH_SET_TRIGGER_OFS		0x0180
-#define GIC_SET_TRIGGER(intr, trig) \
-	GICBIS(GIC_REG_ADDR(SHARED, GIC_SH_SET_TRIGGER_OFS + \
-		GIC_INTR_OFS(intr)), (1 << GIC_INTR_BIT(intr)), \
-		(trig) << GIC_INTR_BIT(intr))
 
 /* Dual edge triggering : Reset Value is always 0 */
 #define GIC_SH_SET_DUAL_OFS		0x0200
-#define GIC_SET_DUAL(intr, dual) \
-	GICBIS(GIC_REG_ADDR(SHARED, GIC_SH_SET_DUAL_OFS + \
-		GIC_INTR_OFS(intr)), (1 << GIC_INTR_BIT(intr)), \
-		(dual) << GIC_INTR_BIT(intr))
 
 /* Mask manipulation */
 #define GIC_SH_SMASK_OFS		0x0380
-#define GIC_SET_INTR_MASK(intr) \
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_SMASK_OFS + \
-		GIC_INTR_OFS(intr)), 1 << GIC_INTR_BIT(intr))
 #define GIC_SH_RMASK_OFS		0x0300
-#define GIC_CLR_INTR_MASK(intr) \
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_RMASK_OFS + \
-		GIC_INTR_OFS(intr)), 1 << GIC_INTR_BIT(intr))
 
 /* Register Map for Local Section */
 #define GIC_VPE_CTL_OFS			0x0000
@@ -220,13 +172,11 @@
 #define GIC_VPE_COMPARE_LO_OFS		0x00a0
 #define GIC_VPE_COMPARE_HI_OFS		0x00a4
 
-#define GIC_VPE_EIC_SHADOW_SET_BASE	0x0100
-#define GIC_VPE_EIC_SS(intr) \
-	(GIC_VPE_EIC_SHADOW_SET_BASE + (4 * intr))
+#define GIC_VPE_EIC_SHADOW_SET_BASE_OFS	0x0100
+#define GIC_VPE_EIC_SS(intr)		(4 * (intr))
 
-#define GIC_VPE_EIC_VEC_BASE		0x0800
-#define GIC_VPE_EIC_VEC(intr) \
-	(GIC_VPE_EIC_VEC_BASE + (4 * intr))
+#define GIC_VPE_EIC_VEC_BASE_OFS	0x0800
+#define GIC_VPE_EIC_VEC(intr)		(4 * (intr))
 
 #define GIC_VPE_TENABLE_NMI_OFS		0x1000
 #define GIC_VPE_TENABLE_YQ_OFS		0x1004
@@ -316,13 +266,6 @@
 #define GIC_VPE_SMASK_SWINT1_SHF	5
 #define GIC_VPE_SMASK_SWINT1_MSK	(MSK(1) << GIC_VPE_SMASK_SWINT1_SHF)
 
-/*
- * Set the Mapping of Interrupt X to a VPE.
- */
-#define GIC_SH_MAP_TO_VPE_SMASK(intr, vpe) \
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_VPE_REG_OFF(intr, vpe)), \
-		 GIC_SH_MAP_TO_VPE_REG_BIT(vpe))
-
 /* GIC nomenclature for Core Interrupt Pins. */
 #define GIC_CPU_INT0		0 /* Core Interrupt 2 */
 #define GIC_CPU_INT1		1 /* .		      */
@@ -363,7 +306,6 @@
 
 extern unsigned int gic_present;
 extern unsigned int gic_frequency;
-extern unsigned long _gic_base;
 
 extern void gic_init(unsigned long gic_base_addr,
 	unsigned long gic_addrspace_size, unsigned int cpu_vec,
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 83dde6f..afa3663 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -23,7 +23,6 @@
 
 unsigned int gic_frequency;
 unsigned int gic_present;
-unsigned long _gic_base;
 
 struct gic_pcpu_mask {
 	DECLARE_BITMAP(pcpu_mask, GIC_MAX_INTRS);
@@ -37,6 +36,7 @@ struct gic_intrmask_regs {
 	DECLARE_BITMAP(intrmask, GIC_MAX_INTRS);
 };
 
+static void __iomem *gic_base;
 static struct gic_pcpu_mask pcpu_masks[NR_CPUS];
 static struct gic_pending_regs pending_regs[NR_CPUS];
 static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
@@ -49,15 +49,82 @@ static struct irq_chip gic_level_irq_controller, gic_edge_irq_controller;
 
 static void __gic_irq_dispatch(void);
 
+static inline unsigned int gic_read(unsigned int reg)
+{
+	return readl(gic_base + reg);
+}
+
+static inline void gic_write(unsigned int reg, unsigned int val)
+{
+	writel(val, gic_base + reg);
+}
+
+static inline void gic_update_bits(unsigned int reg, unsigned int mask,
+				   unsigned int val)
+{
+	unsigned int regval;
+
+	regval = gic_read(reg);
+	regval &= ~mask;
+	regval |= val;
+	gic_write(reg, regval);
+}
+
+static inline void gic_reset_mask(unsigned int intr)
+{
+	gic_write(GIC_REG(SHARED, GIC_SH_RMASK) + GIC_INTR_OFS(intr),
+		  1 << GIC_INTR_BIT(intr));
+}
+
+static inline void gic_set_mask(unsigned int intr)
+{
+	gic_write(GIC_REG(SHARED, GIC_SH_SMASK) + GIC_INTR_OFS(intr),
+		  1 << GIC_INTR_BIT(intr));
+}
+
+static inline void gic_set_polarity(unsigned int intr, unsigned int pol)
+{
+	gic_update_bits(GIC_REG(SHARED, GIC_SH_SET_POLARITY) +
+			GIC_INTR_OFS(intr), 1 << GIC_INTR_BIT(intr),
+			pol << GIC_INTR_BIT(intr));
+}
+
+static inline void gic_set_trigger(unsigned int intr, unsigned int trig)
+{
+	gic_update_bits(GIC_REG(SHARED, GIC_SH_SET_TRIGGER) +
+			GIC_INTR_OFS(intr), 1 << GIC_INTR_BIT(intr),
+			trig << GIC_INTR_BIT(intr));
+}
+
+static inline void gic_set_dual_edge(unsigned int intr, unsigned int dual)
+{
+	gic_update_bits(GIC_REG(SHARED, GIC_SH_SET_DUAL) + GIC_INTR_OFS(intr),
+			1 << GIC_INTR_BIT(intr),
+			dual << GIC_INTR_BIT(intr));
+}
+
+static inline void gic_map_to_pin(unsigned int intr, unsigned int pin)
+{
+	gic_write(GIC_REG(SHARED, GIC_SH_INTR_MAP_TO_PIN_BASE) +
+		  GIC_SH_MAP_TO_PIN(intr), GIC_MAP_TO_PIN_MSK | pin);
+}
+
+static inline void gic_map_to_vpe(unsigned int intr, unsigned int vpe)
+{
+	gic_write(GIC_REG(SHARED, GIC_SH_INTR_MAP_TO_VPE_BASE) +
+		  GIC_SH_MAP_TO_VPE_REG_OFF(intr, vpe),
+		  GIC_SH_MAP_TO_VPE_REG_BIT(vpe));
+}
+
 #if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
 {
 	unsigned int hi, hi2, lo;
 
 	do {
-		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_63_32), hi);
-		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_31_00), lo);
-		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_63_32), hi2);
+		hi = gic_read(GIC_REG(SHARED, GIC_SH_COUNTER_63_32));
+		lo = gic_read(GIC_REG(SHARED, GIC_SH_COUNTER_31_00));
+		hi2 = gic_read(GIC_REG(SHARED, GIC_SH_COUNTER_63_32));
 	} while (hi2 != hi);
 
 	return (((cycle_t) hi) << 32) + lo;
@@ -67,7 +134,7 @@ unsigned int gic_get_count_width(void)
 {
 	unsigned int bits, config;
 
-	GICREAD(GIC_REG(SHARED, GIC_SH_CONFIG), config);
+	config = gic_read(GIC_REG(SHARED, GIC_SH_CONFIG));
 	bits = 32 + 4 * ((config & GIC_SH_CONFIG_COUNTBITS_MSK) >>
 			 GIC_SH_CONFIG_COUNTBITS_SHF);
 
@@ -76,9 +143,9 @@ unsigned int gic_get_count_width(void)
 
 void gic_write_compare(cycle_t cnt)
 {
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_HI),
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_HI),
 				(int)(cnt >> 32));
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_LO),
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_LO),
 				(int)(cnt & 0xffffffff));
 }
 
@@ -88,10 +155,10 @@ void gic_write_cpu_compare(cycle_t cnt, int cpu)
 
 	local_irq_save(flags);
 
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), cpu);
-	GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_HI),
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), cpu);
+	gic_write(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_HI),
 				(int)(cnt >> 32));
-	GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_LO),
+	gic_write(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_LO),
 				(int)(cnt & 0xffffffff));
 
 	local_irq_restore(flags);
@@ -101,8 +168,8 @@ cycle_t gic_read_compare(void)
 {
 	unsigned int hi, lo;
 
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_HI), hi);
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_LO), lo);
+	hi = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_HI));
+	lo = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_LO));
 
 	return (((cycle_t) hi) << 32) + lo;
 }
@@ -116,7 +183,7 @@ static bool gic_local_irq_is_routable(int intr)
 	if (cpu_has_veic)
 		return true;
 
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_CTL), vpe_ctl);
+	vpe_ctl = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_CTL));
 	switch (intr) {
 	case GIC_LOCAL_INT_TIMER:
 		return vpe_ctl & GIC_VPE_CTL_TIMER_RTBL_MSK;
@@ -136,7 +203,7 @@ unsigned int gic_get_timer_pending(void)
 {
 	unsigned int vpe_pending;
 
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_PEND), vpe_pending);
+	vpe_pending = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_PEND));
 	return (vpe_pending & GIC_VPE_PEND_TIMER_MSK);
 }
 
@@ -146,12 +213,13 @@ static void gic_bind_eic_interrupt(int irq, int set)
 	irq -= GIC_PIN_TO_VEC_OFFSET;
 
 	/* Set irq to use shadow set */
-	GICWRITE(GIC_REG_ADDR(VPE_LOCAL, GIC_VPE_EIC_SS(irq)), set);
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_EIC_SHADOW_SET_BASE) +
+		  GIC_VPE_EIC_SS(irq), set);
 }
 
 void gic_send_ipi(unsigned int intr)
 {
-	GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), 0x80000000 | intr);
+	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), 0x80000000 | intr);
 }
 
 int gic_get_c0_compare_int(void)
@@ -178,23 +246,21 @@ static unsigned int gic_get_int(void)
 {
 	unsigned int i;
 	unsigned long *pending, *intrmask, *pcpu_mask;
-	unsigned long *pending_abs, *intrmask_abs;
+	unsigned long pending_reg, intrmask_reg;
 
 	/* Get per-cpu bitmaps */
 	pending = pending_regs[smp_processor_id()].pending;
 	intrmask = intrmask_regs[smp_processor_id()].intrmask;
 	pcpu_mask = pcpu_masks[smp_processor_id()].pcpu_mask;
 
-	pending_abs = (unsigned long *) GIC_REG_ABS_ADDR(SHARED,
-							 GIC_SH_PEND_31_0_OFS);
-	intrmask_abs = (unsigned long *) GIC_REG_ABS_ADDR(SHARED,
-							  GIC_SH_MASK_31_0_OFS);
+	pending_reg = GIC_REG(SHARED, GIC_SH_PEND_31_0);
+	intrmask_reg = GIC_REG(SHARED, GIC_SH_MASK_31_0);
 
 	for (i = 0; i < BITS_TO_LONGS(gic_shared_intrs); i++) {
-		GICREAD(*pending_abs, pending[i]);
-		GICREAD(*intrmask_abs, intrmask[i]);
-		pending_abs++;
-		intrmask_abs++;
+		pending[i] = gic_read(pending_reg);
+		intrmask[i] = gic_read(intrmask_reg);
+		pending_reg += 0x4;
+		intrmask_reg += 0x4;
 	}
 
 	bitmap_and(pending, pending, intrmask, gic_shared_intrs);
@@ -205,19 +271,19 @@ static unsigned int gic_get_int(void)
 
 static void gic_mask_irq(struct irq_data *d)
 {
-	GIC_CLR_INTR_MASK(GIC_HWIRQ_TO_SHARED(d->hwirq));
+	gic_reset_mask(GIC_HWIRQ_TO_SHARED(d->hwirq));
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
-	GIC_SET_INTR_MASK(GIC_HWIRQ_TO_SHARED(d->hwirq));
+	gic_set_mask(GIC_HWIRQ_TO_SHARED(d->hwirq));
 }
 
 static void gic_ack_irq(struct irq_data *d)
 {
 	unsigned int irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
+	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
@@ -229,34 +295,34 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	spin_lock_irqsave(&gic_lock, flags);
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
-		GIC_SET_POLARITY(irq, GIC_POL_NEG);
-		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
-		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		gic_set_polarity(irq, GIC_POL_NEG);
+		gic_set_trigger(irq, GIC_TRIG_EDGE);
+		gic_set_dual_edge(irq, GIC_TRIG_DUAL_DISABLE);
 		is_edge = true;
 		break;
 	case IRQ_TYPE_EDGE_RISING:
-		GIC_SET_POLARITY(irq, GIC_POL_POS);
-		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
-		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		gic_set_polarity(irq, GIC_POL_POS);
+		gic_set_trigger(irq, GIC_TRIG_EDGE);
+		gic_set_dual_edge(irq, GIC_TRIG_DUAL_DISABLE);
 		is_edge = true;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
 		/* polarity is irrelevant in this case */
-		GIC_SET_TRIGGER(irq, GIC_TRIG_EDGE);
-		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_ENABLE);
+		gic_set_trigger(irq, GIC_TRIG_EDGE);
+		gic_set_dual_edge(irq, GIC_TRIG_DUAL_ENABLE);
 		is_edge = true;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		GIC_SET_POLARITY(irq, GIC_POL_NEG);
-		GIC_SET_TRIGGER(irq, GIC_TRIG_LEVEL);
-		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		gic_set_polarity(irq, GIC_POL_NEG);
+		gic_set_trigger(irq, GIC_TRIG_LEVEL);
+		gic_set_dual_edge(irq, GIC_TRIG_DUAL_DISABLE);
 		is_edge = false;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 	default:
-		GIC_SET_POLARITY(irq, GIC_POL_POS);
-		GIC_SET_TRIGGER(irq, GIC_TRIG_LEVEL);
-		GIC_SET_DUAL(irq, GIC_TRIG_DUAL_DISABLE);
+		gic_set_polarity(irq, GIC_POL_POS);
+		gic_set_trigger(irq, GIC_TRIG_LEVEL);
+		gic_set_dual_edge(irq, GIC_TRIG_DUAL_DISABLE);
 		is_edge = false;
 		break;
 	}
@@ -292,7 +358,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	spin_lock_irqsave(&gic_lock, flags);
 
 	/* Re-route this IRQ */
-	GIC_SH_MAP_TO_VPE_SMASK(irq, first_cpu(tmp));
+	gic_map_to_vpe(irq, first_cpu(tmp));
 
 	/* Update the pcpu_masks */
 	for (i = 0; i < NR_CPUS; i++)
@@ -331,8 +397,8 @@ static unsigned int gic_get_local_int(void)
 {
 	unsigned long pending, masked;
 
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_PEND), pending);
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_MASK), masked);
+	pending = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_PEND));
+	masked = gic_read(GIC_REG(VPE_LOCAL, GIC_VPE_MASK));
 
 	bitmap_and(&pending, &pending, &masked, GIC_NUM_LOCAL_INTRS);
 
@@ -343,14 +409,14 @@ static void gic_mask_local_irq(struct irq_data *d)
 {
 	int intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
 
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK), 1 << intr);
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK), 1 << intr);
 }
 
 static void gic_unmask_local_irq(struct irq_data *d)
 {
 	int intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
 
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK), 1 << intr);
+	gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK), 1 << intr);
 }
 
 static struct irq_chip gic_local_irq_controller = {
@@ -367,8 +433,8 @@ static void gic_mask_local_irq_all_vpes(struct irq_data *d)
 
 	spin_lock_irqsave(&gic_lock, flags);
 	for (i = 0; i < gic_vpes; i++) {
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
-		GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_RMASK), 1 << intr);
+		gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+		gic_write(GIC_REG(VPE_OTHER, GIC_VPE_RMASK), 1 << intr);
 	}
 	spin_unlock_irqrestore(&gic_lock, flags);
 }
@@ -381,8 +447,8 @@ static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
 
 	spin_lock_irqsave(&gic_lock, flags);
 	for (i = 0; i < gic_vpes; i++) {
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
-		GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_SMASK), 1 << intr);
+		gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+		gic_write(GIC_REG(VPE_OTHER, GIC_VPE_SMASK), 1 << intr);
 	}
 	spin_unlock_irqrestore(&gic_lock, flags);
 }
@@ -462,7 +528,7 @@ static __init void gic_ipi_init_one(unsigned int intr, int cpu,
 				      GIC_SHARED_TO_HWIRQ(intr));
 	int i;
 
-	GIC_SH_MAP_TO_VPE_SMASK(intr, cpu);
+	gic_map_to_vpe(intr, cpu);
 	for (i = 0; i < NR_CPUS; i++)
 		clear_bit(intr, pcpu_masks[i].pcpu_mask);
 	set_bit(intr, pcpu_masks[cpu].pcpu_mask);
@@ -500,19 +566,19 @@ static void __init gic_basic_init(void)
 
 	/* Setup defaults */
 	for (i = 0; i < gic_shared_intrs; i++) {
-		GIC_SET_POLARITY(i, GIC_POL_POS);
-		GIC_SET_TRIGGER(i, GIC_TRIG_LEVEL);
-		GIC_CLR_INTR_MASK(i);
+		gic_set_polarity(i, GIC_POL_POS);
+		gic_set_trigger(i, GIC_TRIG_LEVEL);
+		gic_reset_mask(i);
 	}
 
 	for (i = 0; i < gic_vpes; i++) {
 		unsigned int j;
 
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+		gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
 		for (j = 0; j < GIC_NUM_LOCAL_INTRS; j++) {
 			if (!gic_local_irq_is_routable(j))
 				continue;
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_RMASK), 1 << j);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_RMASK), 1 << j);
 		}
 	}
 }
@@ -548,29 +614,29 @@ static int gic_local_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	for (i = 0; i < gic_vpes; i++) {
 		u32 val = GIC_MAP_TO_PIN_MSK | gic_cpu_pin;
 
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
+		gic_write(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), i);
 
 		switch (intr) {
 		case GIC_LOCAL_INT_WD:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_WD_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_WD_MAP), val);
 			break;
 		case GIC_LOCAL_INT_COMPARE:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_COMPARE_MAP), val);
 			break;
 		case GIC_LOCAL_INT_TIMER:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_TIMER_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_TIMER_MAP), val);
 			break;
 		case GIC_LOCAL_INT_PERFCTR:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_PERFCTR_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_PERFCTR_MAP), val);
 			break;
 		case GIC_LOCAL_INT_SWINT0:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_SWINT0_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_SWINT0_MAP), val);
 			break;
 		case GIC_LOCAL_INT_SWINT1:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_SWINT1_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_SWINT1_MAP), val);
 			break;
 		case GIC_LOCAL_INT_FDC:
-			GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_FDC_MAP), val);
+			gic_write(GIC_REG(VPE_OTHER, GIC_VPE_FDC_MAP), val);
 			break;
 		default:
 			pr_err("Invalid local IRQ %d\n", intr);
@@ -593,10 +659,9 @@ static int gic_shared_irq_domain_map(struct irq_domain *d, unsigned int virq,
 				 handle_level_irq);
 
 	spin_lock_irqsave(&gic_lock, flags);
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(intr)),
-		 GIC_MAP_TO_PIN_MSK | gic_cpu_pin);
+	gic_map_to_pin(intr, gic_cpu_pin);
 	/* Map to VPE 0 by default */
-	GIC_SH_MAP_TO_VPE_SMASK(intr, 0);
+	gic_map_to_vpe(intr, 0);
 	set_bit(intr, pcpu_masks[0].pcpu_mask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
@@ -622,10 +687,9 @@ void __init gic_init(unsigned long gic_base_addr,
 {
 	unsigned int gicconfig;
 
-	_gic_base = (unsigned long) ioremap_nocache(gic_base_addr,
-						    gic_addrspace_size);
+	gic_base = ioremap_nocache(gic_base_addr, gic_addrspace_size);
 
-	GICREAD(GIC_REG(SHARED, GIC_SH_CONFIG), gicconfig);
+	gicconfig = gic_read(GIC_REG(SHARED, GIC_SH_CONFIG));
 	gic_shared_intrs = (gicconfig & GIC_SH_CONFIG_NUMINTRS_MSK) >>
 		   GIC_SH_CONFIG_NUMINTRS_SHF;
 	gic_shared_intrs = ((gic_shared_intrs + 1) * 8);
-- 
2.1.0.rc2.206.gedb03e5

