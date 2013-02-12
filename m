Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3BLWFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:05:09 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40058 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3BLWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:05:04 -0500
From: Rob Herring <robherring2@gmail.com>
To: Doug Anderson <dianders@chromium.org>, arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] ARM: exynos: move exynos4210-combiner to drivers/irqchip
Date: Tue, 12 Feb 2013 16:04:52 -0600
Message-Id: <1360706692-13622-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Exynos boot is broken with commit 0529e315 (ARM: use common irqchip_init
for GIC init). This commit split the irqchip initialization into 2 calls
to of_irq_init. This does not work because of_irq_init requires interrupt
parents to be in the match list.

Rather than reverting exynos changes, make it do the proper thing by using
IRQCHIP_DECLARE. This requires moving the combiner code to drivers/irqchip.

Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-samsung-soc@vger.kernel.org
---

I thought there may be other platforms broken in the same way, but I
checked and exynos is the only one.

This is based on my gic/vic irqchip branch in arm-soc.

Rob

 arch/arm/mach-exynos/common.c     |  218 +----------------------------------
 arch/arm/mach-exynos/common.h     |    3 +
 drivers/irqchip/Makefile          |    1 +
 drivers/irqchip/exynos-combiner.c |  230 +++++++++++++++++++++++++++++++++++++
 4 files changed, 236 insertions(+), 216 deletions(-)
 create mode 100644 drivers/irqchip/exynos-combiner.c

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 4ea80bc..50577b6 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqchip.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
@@ -439,218 +440,6 @@ static void __init exynos5_init_clocks(int xtal)
 #endif
 }
 
-#define COMBINER_ENABLE_SET	0x0
-#define COMBINER_ENABLE_CLEAR	0x4
-#define COMBINER_INT_STATUS	0xC
-
-static DEFINE_SPINLOCK(irq_controller_lock);
-
-struct combiner_chip_data {
-	unsigned int irq_offset;
-	unsigned int irq_mask;
-	void __iomem *base;
-};
-
-static struct irq_domain *combiner_irq_domain;
-static struct combiner_chip_data combiner_data[MAX_COMBINER_NR];
-
-static inline void __iomem *combiner_base(struct irq_data *data)
-{
-	struct combiner_chip_data *combiner_data =
-		irq_data_get_irq_chip_data(data);
-
-	return combiner_data->base;
-}
-
-static void combiner_mask_irq(struct irq_data *data)
-{
-	u32 mask = 1 << (data->hwirq % 32);
-
-	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_CLEAR);
-}
-
-static void combiner_unmask_irq(struct irq_data *data)
-{
-	u32 mask = 1 << (data->hwirq % 32);
-
-	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_SET);
-}
-
-static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
-{
-	struct combiner_chip_data *chip_data = irq_get_handler_data(irq);
-	struct irq_chip *chip = irq_get_chip(irq);
-	unsigned int cascade_irq, combiner_irq;
-	unsigned long status;
-
-	chained_irq_enter(chip, desc);
-
-	spin_lock(&irq_controller_lock);
-	status = __raw_readl(chip_data->base + COMBINER_INT_STATUS);
-	spin_unlock(&irq_controller_lock);
-	status &= chip_data->irq_mask;
-
-	if (status == 0)
-		goto out;
-
-	combiner_irq = __ffs(status);
-
-	cascade_irq = combiner_irq + (chip_data->irq_offset & ~31);
-	if (unlikely(cascade_irq >= NR_IRQS))
-		do_bad_IRQ(cascade_irq, desc);
-	else
-		generic_handle_irq(cascade_irq);
-
- out:
-	chained_irq_exit(chip, desc);
-}
-
-static struct irq_chip combiner_chip = {
-	.name		= "COMBINER",
-	.irq_mask	= combiner_mask_irq,
-	.irq_unmask	= combiner_unmask_irq,
-};
-
-static void __init combiner_cascade_irq(unsigned int combiner_nr, unsigned int irq)
-{
-	unsigned int max_nr;
-
-	if (soc_is_exynos5250())
-		max_nr = EXYNOS5_MAX_COMBINER_NR;
-	else
-		max_nr = EXYNOS4_MAX_COMBINER_NR;
-
-	if (combiner_nr >= max_nr)
-		BUG();
-	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
-		BUG();
-	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
-}
-
-static void __init combiner_init_one(unsigned int combiner_nr,
-				     void __iomem *base)
-{
-	combiner_data[combiner_nr].base = base;
-	combiner_data[combiner_nr].irq_offset = irq_find_mapping(
-		combiner_irq_domain, combiner_nr * MAX_IRQ_IN_COMBINER);
-	combiner_data[combiner_nr].irq_mask = 0xff << ((combiner_nr % 4) << 3);
-
-	/* Disable all interrupts */
-	__raw_writel(combiner_data[combiner_nr].irq_mask,
-		     base + COMBINER_ENABLE_CLEAR);
-}
-
-#ifdef CONFIG_OF
-static int combiner_irq_domain_xlate(struct irq_domain *d,
-				     struct device_node *controller,
-				     const u32 *intspec, unsigned int intsize,
-				     unsigned long *out_hwirq,
-				     unsigned int *out_type)
-{
-	if (d->of_node != controller)
-		return -EINVAL;
-
-	if (intsize < 2)
-		return -EINVAL;
-
-	*out_hwirq = intspec[0] * MAX_IRQ_IN_COMBINER + intspec[1];
-	*out_type = 0;
-
-	return 0;
-}
-#else
-static int combiner_irq_domain_xlate(struct irq_domain *d,
-				     struct device_node *controller,
-				     const u32 *intspec, unsigned int intsize,
-				     unsigned long *out_hwirq,
-				     unsigned int *out_type)
-{
-	return -EINVAL;
-}
-#endif
-
-static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
-				   irq_hw_number_t hw)
-{
-	irq_set_chip_and_handler(irq, &combiner_chip, handle_level_irq);
-	irq_set_chip_data(irq, &combiner_data[hw >> 3]);
-	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static struct irq_domain_ops combiner_irq_domain_ops = {
-	.xlate	= combiner_irq_domain_xlate,
-	.map	= combiner_irq_domain_map,
-};
-
-static void __init combiner_init(void __iomem *combiner_base,
-				 struct device_node *np)
-{
-	int i, irq, irq_base;
-	unsigned int max_nr, nr_irq;
-
-	if (np) {
-		if (of_property_read_u32(np, "samsung,combiner-nr", &max_nr)) {
-			pr_warning("%s: number of combiners not specified, "
-				"setting default as %d.\n",
-				__func__, EXYNOS4_MAX_COMBINER_NR);
-			max_nr = EXYNOS4_MAX_COMBINER_NR;
-		}
-	} else {
-		max_nr = soc_is_exynos5250() ? EXYNOS5_MAX_COMBINER_NR :
-						EXYNOS4_MAX_COMBINER_NR;
-	}
-	nr_irq = max_nr * MAX_IRQ_IN_COMBINER;
-
-	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
-	if (IS_ERR_VALUE(irq_base)) {
-		irq_base = COMBINER_IRQ(0, 0);
-		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
-	}
-
-	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
-				&combiner_irq_domain_ops, &combiner_data);
-	if (WARN_ON(!combiner_irq_domain)) {
-		pr_warning("%s: irq domain init failed\n", __func__);
-		return;
-	}
-
-	for (i = 0; i < max_nr; i++) {
-		combiner_init_one(i, combiner_base + (i >> 2) * 0x10);
-		irq = IRQ_SPI(i);
-#ifdef CONFIG_OF
-		if (np)
-			irq = irq_of_parse_and_map(np, i);
-#endif
-		combiner_cascade_irq(i, irq);
-	}
-}
-
-#ifdef CONFIG_OF
-static int __init combiner_of_init(struct device_node *np,
-				   struct device_node *parent)
-{
-	void __iomem *combiner_base;
-
-	combiner_base = of_iomap(np, 0);
-	if (!combiner_base) {
-		pr_err("%s: failed to map combiner registers\n", __func__);
-		return -ENXIO;
-	}
-
-	combiner_init(combiner_base, np);
-
-	return 0;
-}
-
-static const struct of_device_id exynos_dt_irq_match[] = {
-	{ .compatible = "samsung,exynos4210-combiner",
-			.data = combiner_of_init, },
-	{},
-};
-#endif
-
 void __init exynos4_init_irq(void)
 {
 	unsigned int gic_bank_offset;
@@ -660,10 +449,8 @@ void __init exynos4_init_irq(void)
 	if (!of_have_populated_dt())
 		gic_init_bases(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU, gic_bank_offset, NULL);
 #ifdef CONFIG_OF
-	else {
+	else
 		irqchip_init();
-		of_irq_init(exynos_dt_irq_match);
-	}
 #endif
 
 	if (!of_have_populated_dt())
@@ -681,7 +468,6 @@ void __init exynos5_init_irq(void)
 {
 #ifdef CONFIG_OF
 	irqchip_init();
-	of_irq_init(exynos_dt_irq_match);
 #endif
 	/*
 	 * The parameters of s5p_init_irq() are for VIC init.
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 04744f9..29196d7 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -60,6 +60,9 @@ void exynos4212_register_clocks(void);
 #define exynos4212_register_clocks()
 #endif
 
+struct device_node;
+void combiner_init(void __iomem *combiner_base, struct device_node *np);
+
 extern struct smp_operations exynos_smp_ops;
 
 extern void exynos_cpu_die(unsigned int cpu);
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 0fb8655..e65fbf2 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
+obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
new file mode 100644
index 0000000..04d86a9
--- /dev/null
+++ b/drivers/irqchip/exynos-combiner.c
@@ -0,0 +1,230 @@
+/*
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Combiner irqchip for EXYNOS
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/mach/irq.h>
+
+#include <plat/cpu.h>
+
+#include "irqchip.h"
+
+#define COMBINER_ENABLE_SET	0x0
+#define COMBINER_ENABLE_CLEAR	0x4
+#define COMBINER_INT_STATUS	0xC
+
+static DEFINE_SPINLOCK(irq_controller_lock);
+
+struct combiner_chip_data {
+	unsigned int irq_offset;
+	unsigned int irq_mask;
+	void __iomem *base;
+};
+
+static struct irq_domain *combiner_irq_domain;
+static struct combiner_chip_data combiner_data[MAX_COMBINER_NR];
+
+static inline void __iomem *combiner_base(struct irq_data *data)
+{
+	struct combiner_chip_data *combiner_data =
+		irq_data_get_irq_chip_data(data);
+
+	return combiner_data->base;
+}
+
+static void combiner_mask_irq(struct irq_data *data)
+{
+	u32 mask = 1 << (data->hwirq % 32);
+
+	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_CLEAR);
+}
+
+static void combiner_unmask_irq(struct irq_data *data)
+{
+	u32 mask = 1 << (data->hwirq % 32);
+
+	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_SET);
+}
+
+static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct combiner_chip_data *chip_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
+	unsigned int cascade_irq, combiner_irq;
+	unsigned long status;
+
+	chained_irq_enter(chip, desc);
+
+	spin_lock(&irq_controller_lock);
+	status = __raw_readl(chip_data->base + COMBINER_INT_STATUS);
+	spin_unlock(&irq_controller_lock);
+	status &= chip_data->irq_mask;
+
+	if (status == 0)
+		goto out;
+
+	combiner_irq = __ffs(status);
+
+	cascade_irq = combiner_irq + (chip_data->irq_offset & ~31);
+	if (unlikely(cascade_irq >= NR_IRQS))
+		do_bad_IRQ(cascade_irq, desc);
+	else
+		generic_handle_irq(cascade_irq);
+
+ out:
+	chained_irq_exit(chip, desc);
+}
+
+static struct irq_chip combiner_chip = {
+	.name		= "COMBINER",
+	.irq_mask	= combiner_mask_irq,
+	.irq_unmask	= combiner_unmask_irq,
+};
+
+static void __init combiner_cascade_irq(unsigned int combiner_nr, unsigned int irq)
+{
+	unsigned int max_nr;
+
+	if (soc_is_exynos5250())
+		max_nr = EXYNOS5_MAX_COMBINER_NR;
+	else
+		max_nr = EXYNOS4_MAX_COMBINER_NR;
+
+	if (combiner_nr >= max_nr)
+		BUG();
+	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
+		BUG();
+	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
+}
+
+static void __init combiner_init_one(unsigned int combiner_nr,
+				     void __iomem *base)
+{
+	combiner_data[combiner_nr].base = base;
+	combiner_data[combiner_nr].irq_offset = irq_find_mapping(
+		combiner_irq_domain, combiner_nr * MAX_IRQ_IN_COMBINER);
+	combiner_data[combiner_nr].irq_mask = 0xff << ((combiner_nr % 4) << 3);
+
+	/* Disable all interrupts */
+	__raw_writel(combiner_data[combiner_nr].irq_mask,
+		     base + COMBINER_ENABLE_CLEAR);
+}
+
+#ifdef CONFIG_OF
+static int combiner_irq_domain_xlate(struct irq_domain *d,
+				     struct device_node *controller,
+				     const u32 *intspec, unsigned int intsize,
+				     unsigned long *out_hwirq,
+				     unsigned int *out_type)
+{
+	if (d->of_node != controller)
+		return -EINVAL;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	*out_hwirq = intspec[0] * MAX_IRQ_IN_COMBINER + intspec[1];
+	*out_type = 0;
+
+	return 0;
+}
+#else
+static int combiner_irq_domain_xlate(struct irq_domain *d,
+				     struct device_node *controller,
+				     const u32 *intspec, unsigned int intsize,
+				     unsigned long *out_hwirq,
+				     unsigned int *out_type)
+{
+	return -EINVAL;
+}
+#endif
+
+static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(irq, &combiner_chip, handle_level_irq);
+	irq_set_chip_data(irq, &combiner_data[hw >> 3]);
+	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops combiner_irq_domain_ops = {
+	.xlate	= combiner_irq_domain_xlate,
+	.map	= combiner_irq_domain_map,
+};
+
+void __init combiner_init(void __iomem *combiner_base,
+			  struct device_node *np)
+{
+	int i, irq, irq_base;
+	unsigned int max_nr, nr_irq;
+
+	if (np) {
+		if (of_property_read_u32(np, "samsung,combiner-nr", &max_nr)) {
+			pr_warning("%s: number of combiners not specified, "
+				"setting default as %d.\n",
+				__func__, EXYNOS4_MAX_COMBINER_NR);
+			max_nr = EXYNOS4_MAX_COMBINER_NR;
+		}
+	} else {
+		max_nr = soc_is_exynos5250() ? EXYNOS5_MAX_COMBINER_NR :
+						EXYNOS4_MAX_COMBINER_NR;
+	}
+	nr_irq = max_nr * MAX_IRQ_IN_COMBINER;
+
+	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
+	if (IS_ERR_VALUE(irq_base)) {
+		irq_base = COMBINER_IRQ(0, 0);
+		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
+	}
+
+	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
+				&combiner_irq_domain_ops, &combiner_data);
+	if (WARN_ON(!combiner_irq_domain)) {
+		pr_warning("%s: irq domain init failed\n", __func__);
+		return;
+	}
+
+	for (i = 0; i < max_nr; i++) {
+		combiner_init_one(i, combiner_base + (i >> 2) * 0x10);
+		irq = IRQ_SPI(i);
+#ifdef CONFIG_OF
+		if (np)
+			irq = irq_of_parse_and_map(np, i);
+#endif
+		combiner_cascade_irq(i, irq);
+	}
+}
+
+#ifdef CONFIG_OF
+static int __init combiner_of_init(struct device_node *np,
+				   struct device_node *parent)
+{
+	void __iomem *combiner_base;
+
+	combiner_base = of_iomap(np, 0);
+	if (!combiner_base) {
+		pr_err("%s: failed to map combiner registers\n", __func__);
+		return -ENXIO;
+	}
+
+	combiner_init(combiner_base, np);
+
+	return 0;
+}
+IRQCHIP_DECLARE(exynos4210_combiner, "samsung,exynos4210-combiner",
+		combiner_of_init);
+#endif
-- 
1.7.10.4

