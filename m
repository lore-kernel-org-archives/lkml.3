Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbbAHTkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:40:47 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42689 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbbAHTkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:40:43 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] irqchip: Conexant CX92755 interrupts controller driver
Date: Thu,  8 Jan 2015 21:40:01 +0200
Message-Id: <a655cc473a41351a764fb84b3a331df4d5073888.1420744369.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1420744368.git.baruch@tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/irqchip/Makefile        |   1 +
 drivers/irqchip/irq-digicolor.c | 112 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 drivers/irqchip/irq-digicolor.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a324be6d..42965d2476bb 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
 obj-$(CONFIG_MIPS_GIC)			+= irq-mips-gic.o
 obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
+obj-$(CONFIG_ARCH_DIGICOLOR)		+= irq-digicolor.o
diff --git a/drivers/irqchip/irq-digicolor.c b/drivers/irqchip/irq-digicolor.c
new file mode 100644
index 000000000000..8fcb82e8527e
--- /dev/null
+++ b/drivers/irqchip/irq-digicolor.c
@@ -0,0 +1,112 @@
+/*
+ * Conexant Digicolor SoCs IRQ chip driver
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ * Copyright (C) 2014 Paradox Innovation Ltd.
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
+
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define UC_IRQ_CONTROL		0x03a4
+
+#define IC_FLAG_CLEAR_LO	0x40
+#define IC_FLAG_CLEAR_XLO	0x44
+#define IC_INT0ENABLE_LO	0x50
+#define IC_INT0ENABLE_XLO	0x54
+#define IC_INT0STATUS_LO	0x58
+#define IC_INT0STATUS_XLO	0x5c
+
+static struct irq_domain *digicolor_irq_domain;
+
+static void __exception_irq_entry digicolor_handle_irq(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = digicolor_irq_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 status, hwirq;
+
+	do {
+		status = irq_reg_readl(gc, IC_INT0STATUS_LO);
+		if (status) {
+			hwirq = ffs(status) - 1;
+		} else {
+			status = irq_reg_readl(gc, IC_INT0STATUS_XLO);
+			if (status)
+				hwirq = ffs(status) - 1 + 32;
+			else
+				return;
+		}
+
+		handle_domain_irq(digicolor_irq_domain, hwirq, regs);
+	} while (1);
+}
+
+static void digicolor_set_gc(void __iomem *reg_base, unsigned irq_base,
+			     unsigned en_reg, unsigned ack_reg)
+{
+	struct irq_chip_generic *gc;
+
+	gc = irq_get_domain_generic_chip(digicolor_irq_domain, irq_base);
+	gc->reg_base = reg_base;
+	gc->chip_types[0].regs.ack = ack_reg;
+	gc->chip_types[0].regs.mask = en_reg;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+}
+
+static int __init digicolor_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	static void __iomem *reg_base;
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	int ret;
+
+	reg_base = of_iomap(node, 0);
+	if (!reg_base) {
+		pr_err("%s: unable to map IC registers\n", node->full_name);
+		return -ENXIO;
+	}
+
+	/* disable all interrupts */
+	writel(0, reg_base + IC_INT0ENABLE_LO);
+	writel(0, reg_base + IC_INT0ENABLE_XLO);
+
+	/* channel 1, regular IRQs */
+	writeb(1, reg_base + UC_IRQ_CONTROL);
+
+	digicolor_irq_domain =
+		irq_domain_add_linear(node, 64, &irq_generic_chip_ops, NULL);
+	if (!digicolor_irq_domain) {
+		pr_err("%s: unable to create IRQ domain\n", node->full_name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(digicolor_irq_domain, 32, 1,
+					     "digicolor_irq", handle_level_irq,
+					     clr, 0, 0);
+	if (ret) {
+		pr_err("%s: unable to allocate IRQ gc\n", node->full_name);
+		return ret;
+	}
+
+	digicolor_set_gc(reg_base, 0, IC_INT0ENABLE_LO, IC_FLAG_CLEAR_LO);
+	digicolor_set_gc(reg_base, 32, IC_INT0ENABLE_XLO, IC_FLAG_CLEAR_XLO);
+
+	set_handle_irq(digicolor_handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(conexant_digicolor_ic, "cnxt,cx92755-ic", digicolor_of_init);
-- 
2.1.4

