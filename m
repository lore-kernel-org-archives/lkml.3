Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3FRKAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:00:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61586 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3FRKAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:00:02 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, tglx@linutronix.de,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: irqchip: add support for MOXA ART SoCs
Date: Tue, 18 Jun 2013 11:59:44 +0200
Message-Id: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an irqchip driver for the main interrupt controller found
on MOXA ART SoCs.

Applies to 3.10-rc1 and arm-soc/for-next (2013-06-15)

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 drivers/irqchip/Makefile     |    1 +
 drivers/irqchip/irq-moxart.c |  163 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 drivers/irqchip/irq-moxart.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..956d129 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
+obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
new file mode 100644
index 0000000..8606089
--- /dev/null
+++ b/drivers/irqchip/irq-moxart.c
@@ -0,0 +1,163 @@
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
+#define IRQ_SOURCE_REG      0
+#define IRQ_MASK_REG        0x04
+#define IRQ_CLEAR_REG       0x08
+#define IRQ_MODE_REG        0x0c
+#define IRQ_LEVEL_REG       0x10
+#define IRQ_STATUS_REG      0x14
+
+#define FIQ_SOURCE_REG      0x20
+#define FIQ_MASK_REG        0x24
+#define FIQ_CLEAR_REG       0x28
+#define FIQ_MODE_REG        0x2c
+#define FIQ_LEVEL_REG       0x30
+#define FIQ_STATUS_REG      0x34
+
+#define IRQ_SOURCE(base_addr)   (base_addr + 0x00)
+#define IRQ_MASK(base_addr)     (base_addr + 0x04)
+#define IRQ_CLEAR(base_addr)    (base_addr + 0x08)
+#define IRQ_TMODE(base_addr)    (base_addr + 0x0C)
+#define IRQ_TLEVEL(base_addr)   (base_addr + 0x10)
+#define IRQ_STATUS(base_addr)   (base_addr + 0x14)
+#define FIQ_SOURCE(base_addr)   (base_addr + 0x20)
+#define FIQ_MASK(base_addr)     (base_addr + 0x24)
+#define FIQ_CLEAR(base_addr)    (base_addr + 0x28)
+#define FIQ_TMODE(base_addr)    (base_addr + 0x2C)
+#define FIQ_TLEVEL(base_addr)   (base_addr + 0x30)
+#define FIQ_STATUS(base_addr)   (base_addr + 0x34)
+
+static void __iomem *moxart_irq_base;
+static struct irq_domain *moxart_irq_domain;
+static unsigned int interrupt_mask;
+
+asmlinkage void __exception_irq_entry moxart_handle_irq(struct pt_regs *regs);
+
+void moxart_irq_ack(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+
+	writel(1 << irq, IRQ_CLEAR(moxart_irq_base));
+}
+
+static void moxart_irq_mask(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+	unsigned int mask;
+
+	mask = readl(IRQ_MASK(moxart_irq_base));
+	mask &= ~(1 << irq);
+	writel(mask, IRQ_MASK(moxart_irq_base));
+}
+
+static void moxart_irq_unmask(struct irq_data *irqd)
+{
+	unsigned int irq = irqd_to_hwirq(irqd);
+	unsigned int mask;
+
+	mask = readl(IRQ_MASK(moxart_irq_base));
+	mask |= (1 << irq);
+	writel(mask, IRQ_MASK(moxart_irq_base));
+}
+
+static struct irq_chip moxart_irq_chip = {
+	.name		= "moxart_irq",
+	.irq_ack	= moxart_irq_ack,
+	.irq_mask	= moxart_irq_mask,
+	.irq_unmask	= moxart_irq_unmask,
+	.irq_set_wake = NULL,
+};
+
+static int moxart_irq_map(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw)
+{
+	if ((1 << hw) && interrupt_mask) {
+		irq_set_chip_and_handler(virq, &moxart_irq_chip,
+			handle_edge_irq);
+		pr_info("%s: irq_set_chip_and_handler edge virq=%d hw=%d\n",
+			__func__, virq, (unsigned int) hw);
+	} else {
+		irq_set_chip_and_handler(virq, &moxart_irq_chip,
+			handle_level_irq);
+		pr_info("%s: irq_set_chip_and_handler level virq=%d hw=%d\n",
+			__func__, virq, (unsigned int) hw);
+	}
+
+	set_irq_flags(virq, IRQF_VALID);
+
+	return 0;
+}
+
+static struct irq_domain_ops moxart_irq_ops = {
+	.map = moxart_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+static int __init moxart_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	interrupt_mask = be32_to_cpup(of_get_property(node,
+		"interrupt-mask", NULL));
+	pr_debug("%s: interrupt-mask=%x\n", node->full_name, interrupt_mask);
+
+	moxart_irq_base = of_iomap(node, 0);
+	if (!moxart_irq_base)
+		panic("%s: unable to map IC registers\n", node->full_name);
+
+	moxart_irq_domain = irq_domain_add_linear(node,
+		32, &moxart_irq_ops, NULL);
+
+	if (!moxart_irq_domain)
+		panic("%s: unable to create IRQ domain\n", node->full_name);
+
+	writel(0, IRQ_MASK(moxart_irq_base));
+	writel(0xffffffff, IRQ_CLEAR(moxart_irq_base));
+
+	writel(interrupt_mask, IRQ_TMODE(moxart_irq_base));
+	writel(interrupt_mask, IRQ_TLEVEL(moxart_irq_base));
+
+	set_handle_irq(moxart_handle_irq);
+
+	pr_info("%s: %s finished\n", node->full_name, __func__);
+
+	return 0;
+}
+IRQCHIP_DECLARE(moxa_moxart_ic, "moxa,moxart-interrupt-controller",
+	moxart_of_init);
+
+asmlinkage void __exception_irq_entry moxart_handle_irq(struct pt_regs *regs)
+{
+	u32 irqstat;
+	int hwirq;
+
+	irqstat = readl(moxart_irq_base + IRQ_STATUS_REG);
+
+	while (irqstat) {
+		hwirq = ffs(irqstat) - 1;
+		handle_IRQ(irq_find_mapping(moxart_irq_domain, hwirq), regs);
+		irqstat &= ~(1 << hwirq);
+	}
+}
+
+
-- 
1.7.2.5

