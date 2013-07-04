Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3GDMjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:39:45 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42139 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3GDMjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:39:43 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, tglx@linutronix.de,
        grant.likely@secretlab.ca, thomas.petazzoni@free-electrons.com,
        arnd@arndb.de, u.kleine-koenig@pengutronix.de, linux@arm.linux.org.uk,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5] ARM: irqchip: add support for MOXA ART SoCs
Date: Thu,  4 Jul 2013 14:38:51 +0200
Message-Id: <1372941531-6393-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372689241-18758-1-git-send-email-jonas.jensen@gmail.com>
References: <1372689241-18758-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an irqchip driver for the main interrupt controller found
on MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703
    
    Changes since v4:
    
    1. shorten DT compatible value to "moxart-ic"
    2. use alphabetic ordering in Makefile

 drivers/irqchip/Makefile     |   1 +
 drivers/irqchip/irq-moxart.c | 118 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)
 create mode 100644 drivers/irqchip/irq-moxart.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 2065ef6..e65c41a 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
+obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
 obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
new file mode 100644
index 0000000..a9d9f36
--- /dev/null
+++ b/drivers/irqchip/irq-moxart.c
@@ -0,0 +1,118 @@
+/*
+ * MOXA ART SoCs IRQ chip driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define IRQ_SOURCE_REG		0
+#define IRQ_MASK_REG		0x04
+#define IRQ_CLEAR_REG		0x08
+#define IRQ_MODE_REG		0x0c
+#define IRQ_LEVEL_REG		0x10
+#define IRQ_STATUS_REG		0x14
+
+#define FIQ_SOURCE_REG		0x20
+#define FIQ_MASK_REG		0x24
+#define FIQ_CLEAR_REG		0x28
+#define FIQ_MODE_REG		0x2c
+#define FIQ_LEVEL_REG		0x30
+#define FIQ_STATUS_REG		0x34
+
+
+struct moxart_irq_data {
+	void __iomem *base;
+	struct irq_domain *domain;
+	unsigned int interrupt_mask;
+};
+
+static struct moxart_irq_data intc;
+
+static asmlinkage void __exception_irq_entry handle_irq(struct pt_regs *regs)
+{
+	u32 irqstat;
+	int hwirq;
+
+	irqstat = readl(intc.base + IRQ_STATUS_REG);
+
+	while (irqstat) {
+		hwirq = ffs(irqstat) - 1;
+		handle_IRQ(irq_linear_revmap(intc.domain, hwirq), regs);
+		irqstat &= ~(1 << hwirq);
+	}
+}
+
+static int __init moxart_of_intc_init(struct device_node *node,
+				      struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	int ret;
+	struct irq_chip_generic *gc;
+
+	intc.base = of_iomap(node, 0);
+	if (!intc.base) {
+		pr_err("%s: unable to map IC registers\n",
+		       node->full_name);
+		return -EINVAL;
+	}
+
+	intc.domain = irq_domain_add_linear(node, 32, &irq_generic_chip_ops,
+					    intc.base);
+	if (!intc.domain) {
+		pr_err("%s: unable to create IRQ domain\n", node->full_name);
+		return -EINVAL;
+	}
+
+	ret = irq_alloc_domain_generic_chips(intc.domain, 32, 1,
+					     "MOXARTINTC", handle_edge_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: could not allocate generic chip\n",
+		       node->full_name);
+		irq_domain_remove(intc.domain);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(node, "interrupt-mask",
+				   &intc.interrupt_mask);
+	if (ret)
+		pr_err("%s: could not read interrupt-mask DT property\n",
+		       node->full_name);
+
+	gc = irq_get_domain_generic_chip(intc.domain, 0);
+
+	gc->reg_base = intc.base;
+	gc->chip_types[0].regs.mask = IRQ_MASK_REG;
+	gc->chip_types[0].regs.ack = IRQ_CLEAR_REG;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+	writel(0, intc.base + IRQ_MASK_REG);
+	writel(0xffffffff, intc.base + IRQ_CLEAR_REG);
+
+	writel(intc.interrupt_mask, intc.base + IRQ_MODE_REG);
+	writel(intc.interrupt_mask, intc.base + IRQ_LEVEL_REG);
+
+	set_handle_irq(handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(moxa_moxart_ic, "moxa,moxart-ic",
+		moxart_of_intc_init);
-- 
1.8.2.1

