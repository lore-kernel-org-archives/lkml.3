Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaLWH7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:59:37 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42136 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbaLWH7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:59:31 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, Baruch Siach <baruch@tkos.co.il>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] irqchip: Conexant CX92755 interrupts controller driver
Date: Tue, 23 Dec 2014 09:58:42 +0200
Message-Id: <7997c913e9f6debc09fd62c788b8ac6bd330d4f3.1419318109.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1419318109.git.baruch@tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/irqchip/Makefile        |   1 +
 drivers/irqchip/irq-digicolor.c | 135 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+)
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
index 000000000000..9970090821a9
--- /dev/null
+++ b/drivers/irqchip/irq-digicolor.c
@@ -0,0 +1,135 @@
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
+#define IC_INT0ENABLE_LO	0x50
+#define IC_INT0ENABLE_XLO	0x54
+#define IC_INT0STATUS_LO	0x58
+#define IC_INT0STATUS_XLO	0x5c
+
+static void __iomem *digicolor_irq_base;
+static struct irq_domain *digicolor_irq_domain;
+
+static void __exception_irq_entry digicolor_handle_irq(struct pt_regs *regs)
+{
+	u32 status, hwirq;
+
+	do {
+		status = readl(digicolor_irq_base + IC_INT0STATUS_LO);
+		if (status) {
+			hwirq = ffs(status) - 1;
+		} else {
+			status = readl(digicolor_irq_base + IC_INT0STATUS_XLO);
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
+static void digicolor_irq_ack(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+	unsigned int irq_off = irq % 8;
+	int reg = irq / 8;
+
+	writeb(BIT(irq_off), digicolor_irq_base + IC_FLAG_CLEAR_LO + reg);
+}
+
+static void digicolor_irq_mask(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+	unsigned int irq_off = irq % 8;
+	int reg = irq / 8;
+	u8 val;
+
+	val = readb(digicolor_irq_base + IC_INT0ENABLE_LO + reg);
+	writeb(val & ~BIT(irq_off),
+	       digicolor_irq_base + IC_INT0ENABLE_LO + reg);
+}
+
+static void digicolor_irq_unmask(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+	unsigned int irq_off = irq % 8;
+	int reg = irq / 8;
+	u8 val;
+
+	val = readb(digicolor_irq_base + IC_INT0ENABLE_LO + reg);
+	writeb(val | BIT(irq_off),
+	       digicolor_irq_base + IC_INT0ENABLE_LO + reg);
+}
+
+static struct irq_chip digicolor_irq_chip = {
+	.name		= "digicolor_irq",
+	.irq_ack	= digicolor_irq_ack,
+	.irq_mask	= digicolor_irq_mask,
+	.irq_unmask	= digicolor_irq_unmask,
+};
+
+static int digicolor_irq_map(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &digicolor_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops digicolor_irq_ops = {
+	.map = digicolor_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static int __init digicolor_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	digicolor_irq_base = of_iomap(node, 0);
+	if (!digicolor_irq_base) {
+		pr_err("%s: unable to map IC registers\n", node->full_name);
+		return -ENXIO;
+	}
+
+	/* disable all interrupts */
+	writel(0, digicolor_irq_base + IC_INT0ENABLE_LO);
+	writel(0, digicolor_irq_base + IC_INT0ENABLE_XLO);
+
+	/* channel 1, regular IRQs */
+	writeb(1, digicolor_irq_base + UC_IRQ_CONTROL);
+
+	digicolor_irq_domain = irq_domain_add_linear(node, 64,
+						     &digicolor_irq_ops, NULL);
+	if (!digicolor_irq_domain) {
+		pr_err("%s: unable to create IRQ domain\n", node->full_name);
+		return -ENOMEM;
+	}
+
+	set_handle_irq(digicolor_handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(conexant_digicolor_ic, "cnxt,cx92755-ic", digicolor_of_init);
-- 
2.1.3

