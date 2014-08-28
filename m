Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaH1WgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:36:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47903 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaH1WgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:36:06 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, tglx@linutronix.de, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 1/2] irqchip: add Broadcom BCM7120-style Level 2 interrupt controller
Date: Thu, 28 Aug 2014 15:35:25 -0700
Message-Id: <1409265326-7579-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Level-2 interrupt controller
hardware found in Broadcom Set Top Box System-on-a-Chip devices. This
interrupt controller is implemented using a single enable register.

This interrupt controller is always present on the platforms supported
by the irq-brcmstb-l2 driver, hence the reason why both are compiled
using the same Kconfig symbol.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/Makefile         |   3 +-
 drivers/irqchip/irq-bcm7120-l2.c | 222 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 drivers/irqchip/irq-bcm7120-l2.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 73052ba9ca62..824f5eb780b6 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -33,4 +33,5 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
-obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
+obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
+					   irq-bcm7120-l2.o
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
new file mode 100644
index 000000000000..1bba8978a622
--- /dev/null
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -0,0 +1,222 @@
+/*
+ * Broadcom BCM7120 style Level 2 interrupt controller driver
+ *
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME	": " fmt
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/reboot.h>
+#include <linux/irqchip/chained_irq.h>
+
+#include "irqchip.h"
+
+#include <asm/mach/irq.h>
+
+/* Register offset in the L2 interrupt controller */
+#define IRQEN		0x00
+#define IRQSTAT		0x04
+
+struct bcm7120_l2_intc_data {
+	void __iomem *base;
+	struct irq_domain *domain;
+	bool can_wake;
+	u32 irq_fwd_mask;
+	u32 irq_map_mask;
+	u32 saved_mask;
+};
+
+static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
+{
+	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(b->domain, 0);
+	u32 status;
+
+	chained_irq_enter(chip, desc);
+
+	irq_gc_lock(gc);
+	status = __raw_readl(b->base + IRQSTAT);
+	irq_gc_unlock(gc);
+
+	if (status == 0) {
+		do_bad_IRQ(irq, desc);
+		goto out;
+	}
+
+	do {
+		irq = ffs(status) - 1;
+		status &= ~(1 << irq);
+		generic_handle_irq(irq_find_mapping(b->domain, irq));
+	} while (status);
+
+out:
+	chained_irq_exit(chip, desc);
+}
+
+static void bcm7120_l2_intc_suspend(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct bcm7120_l2_intc_data *b = gc->private;
+	u32 reg;
+
+	irq_gc_lock(gc);
+	/* Save the current mask and the interrupt forward mask */
+	b->saved_mask = __raw_readl(b->base) | b->irq_fwd_mask;
+	if (b->can_wake) {
+		reg = b->saved_mask | gc->wake_active;
+		__raw_writel(reg, b->base);
+	}
+	irq_gc_unlock(gc);
+}
+
+static void bcm7120_l2_intc_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct bcm7120_l2_intc_data *b = gc->private;
+
+	/* Restore the saved mask */
+	irq_gc_lock(gc);
+	__raw_writel(b->saved_mask, b->base);
+	irq_gc_unlock(gc);
+}
+
+static int bcm7120_l2_intc_init_one(struct device_node *dn,
+					struct bcm7120_l2_intc_data *data,
+					int irq, const __be32 *map_mask)
+{
+	int parent_irq;
+
+	parent_irq = irq_of_parse_and_map(dn, irq);
+	if (parent_irq < 0) {
+		pr_err("failed to map interrupt %d\n", irq);
+		return parent_irq;
+	}
+
+	data->irq_map_mask |= be32_to_cpup(map_mask + irq);
+
+	irq_set_handler_data(parent_irq, data);
+	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
+
+	return 0;
+}
+
+int __init bcm7120_l2_intc_of_init(struct device_node *dn,
+					struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct bcm7120_l2_intc_data *data;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+	const __be32 *map_mask;
+	int num_parent_irqs;
+	int ret = 0, len, irq;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->base = of_iomap(dn, 0);
+	if (!data->base) {
+		pr_err("failed to remap intc L2 registers\n");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	if (of_property_read_u32(dn, "brcm,int-fwd-mask", &data->irq_fwd_mask))
+		data->irq_fwd_mask = 0;
+
+	/* Enable all interrupt specified in the interrupt forward mask and have
+	 * the other disabled
+	 */
+	__raw_writel(data->irq_fwd_mask, data->base + IRQEN);
+
+	num_parent_irqs = of_irq_count(dn);
+	if (num_parent_irqs <= 0) {
+		pr_err("invalid number of parent interrupts\n");
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	map_mask = of_get_property(dn, "brcm,int-map-mask", &len);
+	if (!map_mask || (len != (sizeof(*map_mask) * num_parent_irqs))) {
+		pr_err("invalid brcm,int-map-mask property\n");
+		ret = -EINVAL;
+		goto out_unmap;
+	}
+
+	for (irq = 0; irq < num_parent_irqs; irq++) {
+		ret = bcm7120_l2_intc_init_one(dn, data, irq, map_mask);
+		if (ret)
+			continue;
+	}
+
+	data->domain = irq_domain_add_linear(dn, 32,
+					&irq_generic_chip_ops, NULL);
+	if (!data->domain) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
+				dn->full_name, handle_level_irq, clr, 0,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("failed to allocate generic irq chip\n");
+		goto out_free_domain;
+	}
+
+	gc = irq_get_domain_generic_chip(data->domain, 0);
+	gc->unused = 0xfffffff & ~data->irq_map_mask;
+	gc->reg_base = data->base;
+	gc->private = data;
+	ct = gc->chip_types;
+
+	ct->regs.mask = IRQEN;
+	ct->chip.irq_mask = irq_gc_mask_clr_bit;
+	ct->chip.irq_unmask = irq_gc_mask_set_bit;
+	ct->chip.irq_ack = irq_gc_noop;
+	ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
+	ct->chip.irq_resume = bcm7120_l2_intc_resume;
+
+	if (of_property_read_bool(dn, "brcm,irq-can-wake")) {
+		data->can_wake = true;
+		/* This IRQ chip can wake the system, set all relevant child
+		 * interupts in wake_enabled mask
+		 */
+		gc->wake_enabled = 0xffffffff;
+		gc->wake_enabled &= ~gc->unused;
+		ct->chip.irq_set_wake = irq_gc_set_wake;
+	}
+
+	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
+			data->base, num_parent_irqs);
+
+	return 0;
+
+out_free_domain:
+	irq_domain_remove(data->domain);
+out_unmap:
+	iounmap(data->base);
+out_free:
+	kfree(data);
+	return ret;
+}
+IRQCHIP_DECLARE(brcmstb_l2_intc, "brcm,bcm7120-l2-intc",
+		bcm7120_l2_intc_of_init);
-- 
1.9.1

