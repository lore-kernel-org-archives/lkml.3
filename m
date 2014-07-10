Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaGJROh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:14:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57577 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751794AbaGJROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:14:33 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 3/7] irqchip: atmel-aic: Add atmel AIC/AIC5 drivers
Date: Thu, 10 Jul 2014 19:14:18 +0200
Message-Id: <1405012462-766-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AIC (Advanced Interrupt Controller) and AIC5 (AIC5 is an evolution of
the AIC block) drivers.
Put common code in irq-atmel-aic-common.c/.h so that both driver can access
shared functions (this will ease maintenance).

These drivers are only compatible with dt enabled board and replace the
old implementation found in arch/arm/mach-at91/irq.c.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/irqchip/Kconfig                |  14 ++
 drivers/irqchip/Makefile               |   2 +
 drivers/irqchip/irq-atmel-aic-common.c | 207 ++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  35 ++++
 drivers/irqchip/irq-atmel-aic.c        | 247 ++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic5.c       | 341 +++++++++++++++++++++++++++++++++
 6 files changed, 846 insertions(+)
 create mode 100644 drivers/irqchip/irq-atmel-aic-common.c
 create mode 100644 drivers/irqchip/irq-atmel-aic-common.h
 create mode 100644 drivers/irqchip/irq-atmel-aic.c
 create mode 100644 drivers/irqchip/irq-atmel-aic5.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index bbb746e..baa32cc 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -30,6 +30,20 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config ATMEL_AIC_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+
+config ATMEL_AIC5_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+
 config BRCMSTB_L2_IRQ
 	bool
 	depends on ARM
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 62a13e5..674e895 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -18,6 +18,8 @@ obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
+obj-$(CONFIG_ATMEL_AIC_IRQ)		+= irq-atmel-aic-common.o irq-atmel-aic.o
+obj-$(CONFIG_ATMEL_AIC5_IRQ)	+= irq-atmel-aic-common.o irq-atmel-aic5.o
 obj-$(CONFIG_IMGPDC_IRQ)		+= irq-imgpdc.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
new file mode 100644
index 0000000..18b76fc
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -0,0 +1,207 @@
+/*
+ * Atmel AT91 common AIC (Advanced Interrupt Controller) code shared by
+ * irq-atmel-aic and irq-atmel-aic5 drivers
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "irq-atmel-aic-common.h"
+
+#define AT91_AIC_PRIOR			GENMASK(2, 0)
+#define AT91_AIC_IRQ_MIN_PRIORITY	0
+#define AT91_AIC_IRQ_MAX_PRIORITY	7
+
+#define AT91_AIC_SRCTYPE		GENMASK(7, 6)
+#define AT91_AIC_SRCTYPE_LOW		(0 << 5)
+#define AT91_AIC_SRCTYPE_FALLING	(1 << 5)
+#define AT91_AIC_SRCTYPE_HIGH		(2 << 5)
+#define AT91_AIC_SRCTYPE_RISING		(3 << 5)
+
+struct aic_chip_data {
+	u32 ext_irqs;
+};
+
+static void aic_common_shutdown(struct irq_data *d)
+{
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	ct->chip.irq_mask(d);
+}
+
+int aic_common_set_type(struct irq_data *d, unsigned type, unsigned *val)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct aic_chip_data *aic = gc->private;
+	unsigned aic_type;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		aic_type = AT91_AIC_SRCTYPE_HIGH;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		aic_type = AT91_AIC_SRCTYPE_RISING;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		if (!(d->mask & aic->ext_irqs))
+			return -EINVAL;
+
+		aic_type = AT91_AIC_SRCTYPE_LOW;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		if (!(d->mask & aic->ext_irqs))
+			return -EINVAL;
+
+		aic_type = AT91_AIC_SRCTYPE_FALLING;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*val &= AT91_AIC_SRCTYPE;
+	*val |= aic_type;
+
+	return 0;
+}
+
+int aic_common_set_priority(int priority, unsigned *val)
+{
+	if (priority < AT91_AIC_IRQ_MIN_PRIORITY ||
+	    priority > AT91_AIC_IRQ_MAX_PRIORITY)
+		return -EINVAL;
+
+	*val &= AT91_AIC_PRIOR;
+	*val |= priority;
+
+	return 0;
+}
+
+int aic_common_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec,
+				unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	if (WARN_ON(intsize < 3))
+		return -EINVAL;
+
+	if (WARN_ON((intspec[2] < AT91_AIC_IRQ_MIN_PRIORITY) ||
+		    (intspec[2] > AT91_AIC_IRQ_MAX_PRIORITY)))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+
+	return 0;
+}
+
+static void __init aic_common_ext_irq_of_init(struct irq_domain *domain)
+{
+	struct device_node *node = domain->of_node;
+	struct irq_chip_generic *gc;
+	struct aic_chip_data *aic;
+	struct property *prop;
+	const __be32 *p;
+	u32 hwirq;
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+
+	aic = gc->private;
+	aic->ext_irqs |= 1;
+
+	of_property_for_each_u32(node, "atmel,external-irqs", prop, p, hwirq) {
+		gc = irq_get_domain_generic_chip(domain, hwirq);
+		if (!gc) {
+			pr_warn("AIC: external irq %d >= %d skip it\n",
+				hwirq, domain->revmap_size);
+			continue;
+		}
+
+		aic = gc->private;
+		aic->ext_irqs |= (1 << (hwirq % 32));
+	}
+}
+
+struct irq_domain *__init aic_common_of_init(struct device_node *node,
+					     const struct irq_domain_ops *ops,
+					     const char *name, int nirqs)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	struct aic_chip_data *aic;
+	void __iomem *reg_base;
+	int nchips;
+	int ret;
+	int i;
+
+	nchips = DIV_ROUND_UP(nirqs, 32);
+
+	reg_base = of_iomap(node, 0);
+	if (!reg_base)
+		return ERR_PTR(-ENOMEM);
+
+	aic = kcalloc(nchips, sizeof(*aic), GFP_KERNEL);
+	if (!aic) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	domain = irq_domain_add_linear(node, nchips * 32, ops, aic);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto err_free_aic;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
+					     handle_level_irq, 0, 0,
+					     IRQCHIP_SKIP_SET_WAKE);
+	if (ret)
+		goto err_domain_remove;
+
+	for (i = 0; i < nchips; i++) {
+		gc = irq_get_domain_generic_chip(domain, i * 32);
+
+		gc->reg_base = reg_base;
+
+		gc->unused = 0;
+		gc->wake_enabled = ~0;
+		gc->chip_types[0].type = IRQ_TYPE_SENSE_MASK;
+		gc->chip_types[0].handler = handle_fasteoi_irq;
+		gc->chip_types[0].chip.irq_eoi = irq_gc_eoi;
+		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
+		gc->chip_types[0].chip.irq_shutdown = aic_common_shutdown;
+		gc->private = &aic[i];
+	}
+
+	aic_common_ext_irq_of_init(domain);
+
+	return domain;
+
+err_domain_remove:
+	irq_domain_remove(domain);
+
+err_free_aic:
+	kfree(aic);
+
+err_iounmap:
+	iounmap(reg_base);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
new file mode 100644
index 0000000..c178557
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -0,0 +1,35 @@
+/*
+ * Atmel AT91 common AIC (Advanced Interrupt Controller) header file
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __IRQ_ATMEL_AIC_COMMON_H
+#define __IRQ_ATMEL_AIC_COMMON_H
+
+
+int aic_common_set_type(struct irq_data *d, unsigned type, unsigned *val);
+
+int aic_common_set_priority(int priority, unsigned *val);
+
+int aic_common_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec,
+				unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type);
+
+struct irq_domain *__init aic_common_of_init(struct device_node *node,
+					     const struct irq_domain_ops *ops,
+					     const char *name, int nirqs);
+
+#endif /* __IRQ_ATMEL_AIC_COMMON_H */
diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
new file mode 100644
index 0000000..b15b566
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -0,0 +1,247 @@
+/*
+ * Atmel AT91 AIC (Advanced Interrupt Controller) driver
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irq-atmel-aic-common.h"
+#include "irqchip.h"
+
+/* Number of irq lines managed by AIC */
+#define NR_AIC_IRQS	32
+
+#define AT91_AIC_SMR(n)			((n) * 4)
+
+#define AT91_AIC_SVR(n)			(0x80 + ((n) * 4))
+#define AT91_AIC_IVR			0x100
+#define AT91_AIC_FVR			0x104
+#define AT91_AIC_ISR			0x108
+
+#define AT91_AIC_IPR			0x10c
+#define AT91_AIC_IMR			0x110
+#define AT91_AIC_CISR			0x114
+
+#define AT91_AIC_IECR			0x120
+#define AT91_AIC_IDCR			0x124
+#define AT91_AIC_ICCR			0x128
+#define AT91_AIC_ISCR			0x12c
+#define AT91_AIC_EOICR			0x130
+#define AT91_AIC_SPU			0x134
+#define AT91_AIC_DCR			0x138
+
+static struct irq_domain *aic_domain;
+
+static asmlinkage void __exception_irq_entry
+aic_handle(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = aic_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
+	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
+
+	irqnr = irq_find_mapping(aic_domain, irqnr);
+
+	if (!irqstat)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+static int aic_retrigger(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->mask, gc->reg_base + AT91_AIC_ISCR);
+	irq_gc_unlock(gc);
+
+	return 0;
+}
+
+static int aic_set_type(struct irq_data *d, unsigned type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned int smr;
+	int ret;
+
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	ret = aic_common_set_type(d, type, &smr);
+	if (ret)
+		return ret;
+
+	irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(d->hwirq));
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static void aic_suspend(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IECR);
+	irq_gc_unlock(gc);
+}
+
+static void aic_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IECR);
+	irq_gc_unlock(gc);
+}
+
+static void aic_pm_shutdown(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	irq_gc_unlock(gc);
+}
+#else
+#define aic_suspend		NULL
+#define aic_resume		NULL
+#define aic_pm_shutdown		NULL
+#endif /* CONFIG_PM */
+
+static void __init aic_hw_init(struct irq_domain *domain)
+{
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(domain, 0);
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_SPU);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	irq_reg_writel(0, gc->reg_base + AT91_AIC_DCR);
+
+	/* Disable and clear all interrupts initially */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+
+	for (i = 0; i < 32; i++)
+		irq_reg_writel(i, gc->reg_base + AT91_AIC_SVR(i));
+}
+
+static int aic_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	unsigned smr;
+	int idx;
+	int ret;
+
+	if (!dgc)
+		return -EINVAL;
+
+	ret = aic_common_irq_domain_xlate(d, ctrlr, intspec, intsize,
+					  out_hwirq, out_type);
+	if (ret)
+		return ret;
+
+	idx = intspec[0] / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return -EINVAL;
+
+	gc = dgc->gc[idx];
+
+	irq_gc_lock(gc);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	ret = aic_common_set_priority(intspec[2], &smr);
+	if (!ret)
+		irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+static const struct irq_domain_ops aic_irq_ops = {
+	.map	= irq_map_generic_chip,
+	.xlate	= aic_irq_domain_xlate,
+};
+
+static int __init aic_of_init(struct device_node *node,
+			      struct device_node *parent)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+
+	if (aic_domain)
+		return -EEXIST;
+
+	domain = aic_common_of_init(node, &aic_irq_ops, "atmel-aic",
+				    NR_AIC_IRQS);
+	if (IS_ERR(domain))
+		return PTR_ERR(domain);
+
+	aic_domain = domain;
+	gc = irq_get_domain_generic_chip(domain, 0);
+
+	gc->chip_types[0].regs.eoi = AT91_AIC_EOICR;
+	gc->chip_types[0].regs.enable = AT91_AIC_IECR;
+	gc->chip_types[0].regs.disable = AT91_AIC_IDCR;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
+	gc->chip_types[0].chip.irq_retrigger = aic_retrigger;
+	gc->chip_types[0].chip.irq_set_type = aic_set_type;
+	gc->chip_types[0].chip.irq_suspend = aic_suspend;
+	gc->chip_types[0].chip.irq_resume = aic_resume;
+	gc->chip_types[0].chip.irq_pm_shutdown = aic_pm_shutdown;
+
+	aic_hw_init(domain);
+	set_handle_irq(aic_handle);
+
+	return 0;
+}
+IRQCHIP_DECLARE(at91rm9200_aic, "atmel,at91rm9200-aic", aic_of_init);
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
new file mode 100644
index 0000000..c9c753a
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -0,0 +1,341 @@
+/*
+ * Atmel AT91 AIC5 (Advanced Interrupt Controller) driver
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irq-atmel-aic-common.h"
+#include "irqchip.h"
+
+/* Number of irq lines managed by AIC */
+#define NR_AIC5_IRQS	128
+
+#define AT91_AIC5_SSR		0x0
+#define AT91_AIC5_INTSEL_MSK	(0x7f << 0)
+
+#define AT91_AIC5_SMR			0x4
+
+#define AT91_AIC5_SVR			0x8
+#define AT91_AIC5_IVR			0x10
+#define AT91_AIC5_FVR			0x14
+#define AT91_AIC5_ISR			0x18
+
+#define AT91_AIC5_IPR0			0x20
+#define AT91_AIC5_IPR1			0x24
+#define AT91_AIC5_IPR2			0x28
+#define AT91_AIC5_IPR3			0x2c
+#define AT91_AIC5_IMR			0x30
+#define AT91_AIC5_CISR			0x34
+
+#define AT91_AIC5_IECR			0x40
+#define AT91_AIC5_IDCR			0x44
+#define AT91_AIC5_ICCR			0x48
+#define AT91_AIC5_ISCR			0x4c
+#define AT91_AIC5_EOICR			0x38
+#define AT91_AIC5_SPU			0x3c
+#define AT91_AIC5_DCR			0x6c
+
+#define AT91_AIC5_FFER			0x50
+#define AT91_AIC5_FFDR			0x54
+#define AT91_AIC5_FFSR			0x58
+
+static struct irq_domain *aic5_domain;
+
+static asmlinkage void __exception_irq_entry
+aic5_handle(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = aic5_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
+	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
+
+	irqnr = irq_find_mapping(aic5_domain, irqnr);
+
+	if (!irqstat)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+static void aic5_mask(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Disable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+	gc->mask_cache &= ~d->mask;
+	irq_gc_unlock(gc);
+}
+
+static void aic5_unmask(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IECR);
+	gc->mask_cache |= d->mask;
+	irq_gc_unlock(gc);
+}
+
+static int aic5_retrigger(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_ISCR);
+	irq_gc_unlock(gc);
+
+	return 0;
+}
+
+static int aic5_set_type(struct irq_data *d, unsigned type)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	unsigned int smr;
+	int ret;
+
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	ret = aic_common_set_type(d, type, &smr);
+	if (!ret)
+		irq_reg_writel(smr, gc->reg_base + AT91_AIC5_SMR);
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static void aic5_suspend(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+	u32 mask;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		mask = 1 << i;
+		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
+			continue;
+
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		if (mask & gc->wake_active)
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+		else
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+	}
+	irq_gc_unlock(bgc);
+}
+
+static void aic5_resume(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+	u32 mask;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		mask = 1 << i;
+		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
+			continue;
+
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		if (mask & gc->mask_cache)
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+		else
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+	}
+	irq_gc_unlock(bgc);
+}
+
+static void aic5_pm_shutdown(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_ICCR);
+	}
+	irq_gc_unlock(bgc);
+}
+#else
+#define aic5_suspend		NULL
+#define aic5_resume		NULL
+#define aic5_pm_shutdown	NULL
+#endif /* CONFIG_PM */
+
+static void __init aic5_hw_init(struct irq_domain *domain)
+{
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(domain, 0);
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC5_SPU);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	irq_reg_writel(0, gc->reg_base + AT91_AIC5_DCR);
+
+	/* Disable and clear all interrupts initially */
+	for (i = 0; i < domain->revmap_size; i++) {
+		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SVR);
+		irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+		irq_reg_writel(1, gc->reg_base + AT91_AIC5_ICCR);
+	}
+}
+
+static int aic5_irq_domain_xlate(struct irq_domain *d,
+				 struct device_node *ctrlr,
+				 const u32 *intspec, unsigned int intsize,
+				 irq_hw_number_t *out_hwirq,
+				 unsigned int *out_type)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	unsigned smr;
+	int ret;
+
+	if (!dgc)
+		return -EINVAL;
+
+	ret = aic_common_irq_domain_xlate(d, ctrlr, intspec, intsize,
+					  out_hwirq, out_type);
+	if (ret)
+		return ret;
+
+	gc = dgc->gc[0];
+
+	irq_gc_lock(gc);
+	irq_reg_writel(*out_hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	ret = aic_common_set_priority(intspec[2], &smr);
+	if (!ret)
+		irq_reg_writel(intspec[2] | smr, gc->reg_base + AT91_AIC5_SMR);
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+static const struct irq_domain_ops aic5_irq_ops = {
+	.map	= irq_map_generic_chip,
+	.xlate	= aic5_irq_domain_xlate,
+};
+
+static int __init aic5_of_init(struct device_node *node,
+			       struct device_node *parent,
+			       int nirqs)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	int nchips;
+	int i;
+
+	if (nirqs > NR_AIC5_IRQS)
+		return -EINVAL;
+
+	if (aic5_domain)
+		return -EEXIST;
+
+	domain = aic_common_of_init(node, &aic5_irq_ops, "atmel-aic5",
+				    nirqs);
+	if (IS_ERR(domain))
+		return PTR_ERR(domain);
+
+	aic5_domain = domain;
+	nchips = aic5_domain->revmap_size / 32;
+	for (i = 0; i < nchips; i++) {
+		gc = irq_get_domain_generic_chip(domain, i * 32);
+
+		gc->chip_types[0].regs.eoi = AT91_AIC5_EOICR;
+		gc->chip_types[0].chip.irq_mask = aic5_mask;
+		gc->chip_types[0].chip.irq_unmask = aic5_unmask;
+		gc->chip_types[0].chip.irq_retrigger = aic5_retrigger;
+		gc->chip_types[0].chip.irq_set_type = aic5_set_type;
+		gc->chip_types[0].chip.irq_suspend = aic5_suspend;
+		gc->chip_types[0].chip.irq_resume = aic5_resume;
+		gc->chip_types[0].chip.irq_pm_shutdown = aic5_pm_shutdown;
+	}
+
+	aic5_hw_init(domain);
+	set_handle_irq(aic5_handle);
+
+	return 0;
+}
+
+#define NR_SAMA5D3_IRQS		50
+
+static int __init sama5d3_aic5_of_init(struct device_node *node,
+				       struct device_node *parent)
+{
+	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
+}
+IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
-- 
1.8.3.2

