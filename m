Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaIBNDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:03:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54620 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaIBNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:03:42 -0400
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
        Nicolas Pitre <nico@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v11 11/19] irqchip: vic: Add support for FIQ management
Date: Tue,  2 Sep 2014 14:00:45 +0100
Message-Id: <1409662853-29313-12-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces callbacks to route interrupts to or away
from the FIQ signal. It also causes these callbacks to be registered
with the FIQ infrastructure.

This patch enable FIQ support for mach-versatile whilst mach-ep93xx,
mach-netx, mach-s3c64xx and plat-samsung are unmodified (and can therefore
continue to use init_FIQ() as before).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-samsung-soc@vger.kernel.org
---
 arch/arm/mach-versatile/core.c  |  2 +-
 drivers/irqchip/irq-gic.c       | 21 ++++------
 drivers/irqchip/irq-vic.c       | 92 ++++++++++++++++++++++++++++++++---------
 include/linux/irqchip/arm-gic.h |  3 ++
 include/linux/irqchip/arm-vic.h |  6 ++-
 5 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 08fb8c8..bad1d30 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -108,7 +108,7 @@ void __init versatile_init_irq(void)
 
 	np = of_find_matching_node_by_address(NULL, vic_of_match,
 					      VERSATILE_VIC_BASE);
-	__vic_init(VA_VIC_BASE, 0, IRQ_VIC_START, ~0, 0, np);
+	__vic_init(VA_VIC_BASE, 0, IRQ_VIC_START, ~0, 0, np ? false : true, np);
 
 	writel(~0, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index bda5a91..8821160 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -502,13 +502,17 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 /*
  * Fully acknowledge (both ack and eoi) a FIQ-based IPI
  */
-static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
-			   void *data)
+void gic_handle_fiq_ipi(void)
 {
 	struct gic_chip_data *gic = &gic_data[0];
-	void __iomem *cpu_base = gic_data_cpu_base(gic);
+	void __iomem *cpu_base;
 	unsigned long irqstat, irqnr;
 
+	if (!gic || !gic->fiq_enable)
+		return;
+
+	cpu_base = gic_data_cpu_base(gic);
+
 	if (WARN_ON(!in_nmi()))
 		return NOTIFY_BAD;
 
@@ -525,13 +529,6 @@ static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
 
 	return NOTIFY_OK;
 }
-
-/*
- * Notifier to ensure IPI FIQ is acknowledged correctly.
- */
-static struct notifier_block gic_fiq_ipi_notifier = {
-	.notifier_call = gic_handle_fiq_ipi,
-};
 #else /* CONFIG_FIQ */
 static inline void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
 				     int group) {}
@@ -1250,10 +1247,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_SMP
 		set_smp_cross_call(gic_raise_softirq);
 		register_cpu_notifier(&gic_cpu_notifier);
-#ifdef CONFIG_FIQ
-		if (gic_data_fiq_enable(gic))
-			register_fiq_nmi_notifier(&gic_fiq_ipi_notifier);
-#endif
 #endif
 		set_handle_irq(gic_handle_irq);
 	}
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 7d35287..22aa126 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -36,6 +36,9 @@
 
 #include <asm/exception.h>
 #include <asm/irq.h>
+#ifdef CONFIG_FIQ
+#include <asm/fiq.h>
+#endif
 
 #include "irqchip.h"
 
@@ -261,11 +264,53 @@ static struct irq_domain_ops vic_irqdomain_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 
+#ifdef CONFIG_FIQ
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+
+static void vic_set_fiq(struct irq_data *d, bool enable)
+{
+	void __iomem *base = irq_data_get_irq_chip_data(d);
+	unsigned int irq = d->hwirq;
+	u32 val;
+
+	raw_spin_lock(&irq_controller_lock);
+	val = readl(base + VIC_INT_SELECT);
+	if (enable)
+		val |= 1 << irq;
+	else
+		val &= ~(1 << irq);
+	writel(val, base + VIC_INT_SELECT);
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void vic_enable_fiq(struct irq_data *d)
+{
+	vic_set_fiq(d, true);
+}
+
+static void vic_disable_fiq(struct irq_data *d)
+{
+	vic_set_fiq(d, false);
+}
+
+struct fiq_chip vic_fiq = {
+	.fiq_enable = vic_enable_fiq,
+	.fiq_disable = vic_disable_fiq,
+};
+
+static void vic_register_fiq(int irq)
+{
+	fiq_register_mapping(irq, &vic_fiq);
+}
+#else /* CONFIG_FIQ */
+static inline void vic_register_fiq(int irq) {}
+#endif /* CONFIG_FIQ */
+
 /**
  * vic_register() - Register a VIC.
  * @base: The base address of the VIC.
  * @parent_irq: The parent IRQ if cascaded, else 0.
- * @irq: The base IRQ for the VIC.
+ * @irq_start: The base IRQ for the VIC.
  * @valid_sources: bitmask of valid interrupts
  * @resume_sources: bitmask of interrupts allowed for resume sources.
  * @node: The device tree node associated with the VIC.
@@ -277,12 +322,13 @@ static struct irq_domain_ops vic_irqdomain_ops = {
  * This also configures the IRQ domain for the VIC.
  */
 static void __init vic_register(void __iomem *base, unsigned int parent_irq,
-				unsigned int irq,
+				unsigned int irq_start,
 				u32 valid_sources, u32 resume_sources,
-				struct device_node *node)
+				bool map_fiqs, struct device_node *node)
 {
 	struct vic_device *v;
 	int i;
+	unsigned int irq;
 
 	if (vic_id >= ARRAY_SIZE(vic_devices)) {
 		printk(KERN_ERR "%s: too few VICs, increase CONFIG_ARM_VIC_NR\n", __func__);
@@ -301,15 +347,19 @@ static void __init vic_register(void __iomem *base, unsigned int parent_irq,
 		irq_set_chained_handler(parent_irq, vic_handle_irq_cascaded);
 	}
 
-	v->domain = irq_domain_add_simple(node, fls(valid_sources), irq,
+	v->domain = irq_domain_add_simple(node, fls(valid_sources), irq_start,
 					  &vic_irqdomain_ops, v);
 	/* create an IRQ mapping for each valid IRQ */
-	for (i = 0; i < fls(valid_sources); i++)
-		if (valid_sources & (1 << i))
-			irq_create_mapping(v->domain, i);
+	for (i = 0; i < fls(valid_sources); i++) {
+		if (valid_sources & (1 << i)) {
+			irq = irq_create_mapping(v->domain, i);
+			vic_register_fiq(irq);
+		}
+	}
+
 	/* If no base IRQ was passed, figure out our allocated base */
-	if (irq)
-		v->irq = irq;
+	if (irq_start)
+		v->irq = irq_start;
 	else
 		v->irq = irq_find_mapping(v->domain, 0);
 }
@@ -413,7 +463,8 @@ static void __init vic_clear_interrupts(void __iomem *base)
  *  and 020 within the page. We call this "second block".
  */
 static void __init vic_init_st(void __iomem *base, unsigned int irq_start,
-			       u32 vic_sources, struct device_node *node)
+			       u32 vic_sources, bool map_fiqs,
+			       struct device_node *node)
 {
 	unsigned int i;
 	int vic_2nd_block = ((unsigned long)base & ~PAGE_MASK) != 0;
@@ -439,12 +490,12 @@ static void __init vic_init_st(void __iomem *base, unsigned int irq_start,
 		writel(32, base + VIC_PL190_DEF_VECT_ADDR);
 	}
 
-	vic_register(base, 0, irq_start, vic_sources, 0, node);
+	vic_register(base, 0, irq_start, vic_sources, 0, map_fiqs, node);
 }
 
 void __init __vic_init(void __iomem *base, int parent_irq, int irq_start,
-			      u32 vic_sources, u32 resume_sources,
-			      struct device_node *node)
+		       u32 vic_sources, u32 resume_sources,
+		       bool map_fiqs, struct device_node *node)
 {
 	unsigned int i;
 	u32 cellid = 0;
@@ -462,7 +513,7 @@ void __init __vic_init(void __iomem *base, int parent_irq, int irq_start,
 
 	switch(vendor) {
 	case AMBA_VENDOR_ST:
-		vic_init_st(base, irq_start, vic_sources, node);
+		vic_init_st(base, irq_start, vic_sources, map_fiqs, node);
 		return;
 	default:
 		printk(KERN_WARNING "VIC: unknown vendor, continuing anyways\n");
@@ -479,7 +530,8 @@ void __init __vic_init(void __iomem *base, int parent_irq, int irq_start,
 
 	vic_init2(base);
 
-	vic_register(base, parent_irq, irq_start, vic_sources, resume_sources, node);
+	vic_register(base, parent_irq, irq_start, vic_sources, resume_sources,
+		     map_fiqs, node);
 }
 
 /**
@@ -492,7 +544,8 @@ void __init __vic_init(void __iomem *base, int parent_irq, int irq_start,
 void __init vic_init(void __iomem *base, unsigned int irq_start,
 		     u32 vic_sources, u32 resume_sources)
 {
-	__vic_init(base, 0, irq_start, vic_sources, resume_sources, NULL);
+	__vic_init(base, 0, irq_start, vic_sources, resume_sources,
+		   false, NULL);
 }
 
 /**
@@ -511,7 +564,8 @@ int __init vic_init_cascaded(void __iomem *base, unsigned int parent_irq,
 	struct vic_device *v;
 
 	v = &vic_devices[vic_id];
-	__vic_init(base, parent_irq, 0, vic_sources, resume_sources, NULL);
+	__vic_init(base, parent_irq, 0, vic_sources, resume_sources, false,
+		   NULL);
 	/* Return out acquired base */
 	return v->irq;
 }
@@ -535,9 +589,9 @@ int __init vic_of_init(struct device_node *node, struct device_node *parent)
 	of_property_read_u32(node, "valid-wakeup-mask", &wakeup_mask);
 
 	/*
-	 * Passing 0 as first IRQ makes the simple domain allocate descriptors
+	 * Passing 0 as first IRQ makes the domain allocate descriptors.
 	 */
-	__vic_init(regs, 0, 0, interrupt_mask, wakeup_mask, node);
+	__vic_init(regs, 0, 0, interrupt_mask, wakeup_mask, true, node);
 
 	return 0;
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
diff --git a/include/linux/irqchip/arm-vic.h b/include/linux/irqchip/arm-vic.h
index ba46c79..30ab39f 100644
--- a/include/linux/irqchip/arm-vic.h
+++ b/include/linux/irqchip/arm-vic.h
@@ -30,8 +30,10 @@ struct device_node;
 struct pt_regs;
 
 void __vic_init(void __iomem *base, int parent_irq, int irq_start,
-		u32 vic_sources, u32 resume_sources, struct device_node *node);
-void vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources, u32 resume_sources);
+		u32 vic_sources, u32 resume_sources,
+		bool map_fiqs, struct device_node *node);
+void vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources,
+	      u32 resume_sources);
 int vic_init_cascaded(void __iomem *base, unsigned int parent_irq,
 		      u32 vic_sources, u32 resume_sources);
 
-- 
1.9.3

