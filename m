Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbaGUOsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:53 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33317 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:49 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>
Subject: [PATCH RFC 7/9] irqchip: gic: Use non-secure aliased register set when FIQ is enabled
Date: Mon, 21 Jul 2014 15:47:18 +0100
Message-Id: <1405954040-30399-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/irqchip/irq-gic.c       | 76 ++++++++++++++++++++++++++++++++++++-----
 include/linux/irqchip/arm-gic.h |  4 +--
 2 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 5c934a4..8faa271 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -59,6 +59,7 @@ union gic_base {
 struct gic_chip_data {
 	union gic_base dist_base;
 	union gic_base cpu_base;
+	union gic_base aliased_cpu_base;
 #ifdef CONFIG_CPU_PM
 	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
 	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
@@ -126,6 +127,12 @@ static inline void __iomem *gic_data_cpu_base(struct gic_chip_data *data)
 	return data->get_base(&data->cpu_base);
 }
 
+static inline void __iomem *gic_data_aliased_cpu_base(
+						struct gic_chip_data *data)
+{
+	return data->get_base(&data->aliased_cpu_base);
+}
+
 static inline void gic_set_base_accessor(struct gic_chip_data *data,
 					 void __iomem *(*f)(union gic_base *))
 {
@@ -134,6 +141,7 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
 #else
 #define gic_data_dist_base(d)	((d)->dist_base.common_base)
 #define gic_data_cpu_base(d)	((d)->cpu_base.common_base)
+#define gic_data_aliased_cpu_base(d)	((d)->aliased_cpu_base.common_base)
 #define gic_set_base_accessor(d, f)
 #endif
 
@@ -159,6 +167,13 @@ static inline void __iomem *gic_cpu_base(struct irq_data *d)
 	return gic_data_cpu_base(gic_data);
 }
 
+static inline void __iomem *gic_aliased_cpu_base(struct irq_data *d)
+{
+	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
+
+	return gic_data_aliased_cpu_base(gic_data);
+}
+
 static inline unsigned int gic_irq(struct irq_data *d)
 {
 	return d->hwirq;
@@ -194,7 +209,7 @@ static void gic_eoi_irq(struct irq_data *d)
 	if (gic_arch_extn.irq_eoi)
 		gic_arch_extn.irq_eoi(d);
 
-	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
+	writel_relaxed(gic_irq(d), gic_aliased_cpu_base(d) + GIC_CPU_EOI);
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
@@ -300,7 +315,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
 	struct gic_chip_data *gic = &gic_data[0];
-	void __iomem *cpu_base = gic_data_cpu_base(gic);
+	void __iomem *cpu_base = gic_data_aliased_cpu_base(gic);
 
 	do {
 		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
@@ -332,7 +347,8 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 
 	raw_spin_lock(&irq_controller_lock);
-	status = readl_relaxed(gic_data_cpu_base(chip_data) + GIC_CPU_INTACK);
+	status = readl_relaxed(gic_data_aliased_cpu_base(chip_data) +
+			       GIC_CPU_INTACK);
 	raw_spin_unlock(&irq_controller_lock);
 
 	gic_irq = (status & 0x3ff);
@@ -419,11 +435,19 @@ static int gic_ack_fiq(struct irq_data *d)
 	return irq_find_mapping(gic->domain, irqnr);
 }
 
+static void gic_eoi_fiq(struct irq_data *d)
+{
+	if (gic_arch_extn.irq_eoi)
+		gic_arch_extn.irq_eoi(d);
+
+	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
+}
+
 static struct fiq_chip gic_fiq = {
 	.fiq_enable		= gic_enable_fiq,
 	.fiq_disable            = gic_disable_fiq,
 	.fiq_ack		= gic_ack_fiq,
-	.fiq_eoi		= gic_eoi_irq,
+	.fiq_eoi		= gic_eoi_fiq,
 };
 
 static void __init gic_init_fiq(struct gic_chip_data *gic,
@@ -453,6 +477,10 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 	 */
 	for (i = 0; i < num_irqs; i++)
 		fiq_register_mapping(first_irq + i, &gic_fiq);
+
+	/* This is not a fatal problem for some use-cases so WARN() is enough */
+	WARN(gic_data_cpu_base(gic_data) == gic_data_aliased_cpu_base(gic_data),
+	     "No non-secure alias; IRQ handler may spuriously ack FIQs\n");
 }
 #else /* CONFIG_FIQ */
 static inline void gic_init_fiq(struct gic_chip_data *gic,
@@ -1076,7 +1104,9 @@ const struct irq_domain_ops *gic_routable_irq_domain_ops =
 
 void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 			   void __iomem *dist_base, void __iomem *cpu_base,
-			   u32 percpu_offset, struct device_node *node)
+			   void __iomem *aliased_cpu_base,
+			   u32 percpu_offset,
+			   struct device_node *node)
 {
 	irq_hw_number_t hwirq_base;
 	struct gic_chip_data *gic;
@@ -1085,6 +1115,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 	BUG_ON(gic_nr >= MAX_GIC_NR);
 
+	if (!aliased_cpu_base)
+		aliased_cpu_base = cpu_base;
+
 	gic = &gic_data[gic_nr];
 #ifdef CONFIG_GIC_NON_BANKED
 	if (percpu_offset) { /* Frankein-GIC without banked registers... */
@@ -1092,10 +1125,14 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 		gic->dist_base.percpu_base = alloc_percpu(void __iomem *);
 		gic->cpu_base.percpu_base = alloc_percpu(void __iomem *);
+		gic->aliased_cpu_base.percpu_base =
+		    alloc_percpu(void __iomem *);
 		if (WARN_ON(!gic->dist_base.percpu_base ||
-			    !gic->cpu_base.percpu_base)) {
+			    !gic->cpu_base.percpu_base ||
+			    !gic->aliased_cpu_base.percpu_base)) {
 			free_percpu(gic->dist_base.percpu_base);
 			free_percpu(gic->cpu_base.percpu_base);
+			free_percpu(gic->aliased_cpu_base.percpu_base);
 			return;
 		}
 
@@ -1103,6 +1140,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 			unsigned long offset = percpu_offset * cpu_logical_map(cpu);
 			*per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
 			*per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
+			*per_cpu_ptr(gic->aliased_cpu_base.percpu_base, cpu) =
+			    aliased_cpu_base + offset;
 		}
 
 		gic_set_base_accessor(gic, gic_get_percpu_base);
@@ -1114,6 +1153,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		     percpu_offset);
 		gic->dist_base.common_base = dist_base;
 		gic->cpu_base.common_base = cpu_base;
+		gic->aliased_cpu_base.common_base = aliased_cpu_base;
 		gic_set_base_accessor(gic, gic_get_common_base);
 	}
 
@@ -1188,11 +1228,27 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
+static void __init __iomem *gic_arm_iomap_nonsecure(struct device_node *np,
+						    int index)
+{
+#if defined(CONFIG_ARM) && defined(CONFIG_FIQ)
+	struct resource res;
+
+	if (of_address_to_resource(np, index, &res))
+		return NULL;
+
+	return __arm_ioremap(res.start, resource_size(&res), MT_DEVICE_NS);
+#else
+	return NULL;
+#endif
+}
+
 static int __init
 gic_of_init(struct device_node *node, struct device_node *parent)
 {
-	void __iomem *cpu_base;
 	void __iomem *dist_base;
+	void __iomem *cpu_base;
+	void __iomem *aliased_cpu_base;
 	u32 percpu_offset;
 	int irq;
 
@@ -1205,10 +1261,14 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	cpu_base = of_iomap(node, 1);
 	WARN(!cpu_base, "unable to map gic cpu registers\n");
 
+	aliased_cpu_base = gic_arm_iomap_nonsecure(node, 1);
+	/* no NULL check because NULL is a legimate value */
+
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
-	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
+	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, aliased_cpu_base,
+		       percpu_offset, node);
 	if (!gic_cnt)
 		gic_init_physaddr(node);
 
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c..15cf913 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -80,14 +80,14 @@ struct device_node;
 extern struct irq_chip gic_arch_extn;
 
 void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
-		    u32 offset, struct device_node *);
+		    void __iomem *, u32 offset, struct device_node *);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_cpu_if_down(void);
 
 static inline void gic_init(unsigned int nr, int start,
 			    void __iomem *dist , void __iomem *cpu)
 {
-	gic_init_bases(nr, start, dist, cpu, 0, NULL);
+	gic_init_bases(nr, start, dist, cpu, NULL, 0, NULL);
 }
 
 void gic_send_sgi(unsigned int cpu_id, unsigned int irq);
-- 
1.9.3

