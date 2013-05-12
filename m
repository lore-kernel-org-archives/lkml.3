Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3ELEYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 00:24:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53753 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3ELEYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 00:24:07 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: [RFC PATCHv3 6/6] irqchip: Add TI-Nspire irqchip
Date: Sun, 12 May 2013 14:23:01 +1000
Message-Id: <1368332581-94691-7-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/irqchip/Makefile             |   1 +
 drivers/irqchip/irq-nspire-classic.c | 177 +++++++++++++++++++++++++++++++++++
 2 files changed, 178 insertions(+)
 create mode 100644 drivers/irqchip/irq-nspire-classic.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..056ad7d 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -15,4 +15,5 @@ obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
+obj-$(CONFIG_ARCH_NSPIRE)		+= irq-nspire-classic.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
diff --git a/drivers/irqchip/irq-nspire-classic.c b/drivers/irqchip/irq-nspire-classic.c
new file mode 100644
index 0000000..9e6413a
--- /dev/null
+++ b/drivers/irqchip/irq-nspire-classic.c
@@ -0,0 +1,177 @@
+/*
+ *  linux/drivers/irqchip/irq-nspire-classic.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#include <asm/mach/irq.h>
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define IO_STATUS	0x000
+#define IO_RAW_STATUS	0x004
+#define IO_ENABLE	0x008
+#define IO_DISABLE	0x00C
+#define IO_CURRENT	0x020
+#define IO_RESET	0x028
+#define IO_MAX_PRIOTY	0x02C
+
+#define IO_IRQ_BASE	0x000
+#define IO_FIQ_BASE	0x100
+
+#define IO_INVERT_SEL	0x200
+#define IO_STICKY_SEL	0x204
+#define IO_PRIORITY_SEL	0x300
+
+#define MAX_INTRS	32
+#define FIQ_START	MAX_INTRS
+
+
+static void __iomem *irq_io_base;
+static struct irq_domain *nspire_irq_domain;
+
+static void nspire_irq_ack(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+
+	if (irqd->hwirq < FIQ_START)
+		base += IO_IRQ_BASE;
+	else
+		base += IO_FIQ_BASE;
+
+	readl(base + IO_RESET);
+}
+
+static void nspire_irq_unmask(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+	int irqnr = irqd->hwirq;
+
+	if (irqnr < FIQ_START) {
+		base += IO_IRQ_BASE;
+	} else {
+		irqnr -= MAX_INTRS;
+		base += IO_FIQ_BASE;
+	}
+
+	writel((1<<irqnr), base + IO_ENABLE);
+}
+
+static void nspire_irq_mask(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+	int irqnr = irqd->hwirq;
+
+	if (irqnr < FIQ_START) {
+		base += IO_IRQ_BASE;
+	} else {
+		irqnr -= FIQ_START;
+		base += IO_FIQ_BASE;
+	}
+
+	writel((1<<irqnr), base + IO_DISABLE);
+}
+
+static struct irq_chip nspire_irq_chip = {
+	.name		= "nspire_irq",
+	.irq_ack	= nspire_irq_ack,
+	.irq_mask	= nspire_irq_mask,
+	.irq_unmask	= nspire_irq_unmask,
+};
+
+
+static int nspire_irq_map(struct irq_domain *dom, unsigned int virq,
+		irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &nspire_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops nspire_irq_ops = {
+	.map = nspire_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static void init_base(void __iomem *base)
+{
+	/* Disable all interrupts */
+	writel(~0, base + IO_DISABLE);
+
+	/* Accept interrupts of all priorities */
+	writel(0xF, base + IO_MAX_PRIOTY);
+
+	/* Reset existing interrupts */
+	readl(base + IO_RESET);
+}
+
+static int process_base(void __iomem *base, struct pt_regs *regs)
+{
+	int irqnr;
+
+
+	if (!readl(base + IO_STATUS))
+		return 0;
+
+	irqnr = readl(base + IO_CURRENT);
+	irqnr = irq_find_mapping(nspire_irq_domain, irqnr);
+	handle_IRQ(irqnr, regs);
+
+	return 1;
+}
+
+asmlinkage void __exception_irq_entry nspire_handle_irq(struct pt_regs *regs)
+{
+	while (process_base(irq_io_base + IO_FIQ_BASE, regs))
+		;
+	while (process_base(irq_io_base + IO_IRQ_BASE, regs))
+		;
+}
+
+static int __init nspire_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	if (WARN_ON(irq_io_base))
+		return -EBUSY;
+
+	irq_io_base = of_iomap(node, 0);
+	BUG_ON(!irq_io_base);
+
+	/* Do not invert interrupt status bits */
+	writel(~0, irq_io_base + IO_INVERT_SEL);
+
+	/* Disable sticky interrupts */
+	writel(0, irq_io_base + IO_STICKY_SEL);
+
+	/* We don't use IRQ priorities. Set each IRQ to highest priority. */
+	memset_io(irq_io_base + IO_PRIORITY_SEL, 0, MAX_INTRS * sizeof(u32));
+
+	/* Init IRQ and FIQ */
+	init_base(irq_io_base + IO_IRQ_BASE);
+	init_base(irq_io_base + IO_FIQ_BASE);
+
+	nspire_irq_domain = irq_domain_add_linear(node, MAX_INTRS,
+						 &nspire_irq_ops, NULL);
+
+	BUG_ON(!nspire_irq_domain);
+
+	set_handle_irq(nspire_handle_irq);
+
+	pr_info("TI-NSPIRE classic IRQ controller\n");
+	return 0;
+}
+
+IRQCHIP_DECLARE(nspire_classic_irq, "nspire-classic-intc", nspire_of_init);
-- 
1.8.1.3

