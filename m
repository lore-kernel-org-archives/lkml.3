Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030612Ab3E3LXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:23:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42560 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968083Ab3E3LXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:23:43 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Add TI-Nspire irqchip support
Date: Thu, 30 May 2013 21:23:35 +1000
Message-Id: <89D06030-E27E-445D-BBB8-45A47CA6C892@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds a driver for the interrupt controller found in the TI-Nspire calculator series.

Cheers,
Daniel Tang

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../interrupt-controller/lsi,zevio-intc.txt        |  18 +++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-zevio.c                        | 177 +++++++++++++++++++++
 3 files changed, 196 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/lsi,zevio-intc.txt
 create mode 100644 drivers/irqchip/irq-zevio.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/lsi,zevio-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/lsi,zevio-intc.txt
new file mode 100644
index 0000000..aee38e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/lsi,zevio-intc.txt
@@ -0,0 +1,18 @@
+TI-NSPIRE interrupt controller
+
+Required properties:
+- compatible: Compatible property value should be "lsi,zevio-intc".
+
+- reg: Physical base address of the controller and length of memory mapped
+	region.
+
+- interrupt-controller : Identifies the node as an interrupt controller
+
+Example:
+
+interrupt-controller {
+	compatible = "lsi,zevio-intc";
+	interrupt-controller;
+	reg = <0xDC000000 0x1000>;
+	#interrupt-cells = <1>;
+};
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..f313d14 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -15,4 +15,5 @@ obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
+obj-$(CONFIG_ARCH_NSPIRE)		+= irq-zevio.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
new file mode 100644
index 0000000..7786f73
--- /dev/null
+++ b/drivers/irqchip/irq-zevio.c
@@ -0,0 +1,177 @@
+/*
+ *  linux/drivers/irqchip/irq-zevio.c
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
+static struct irq_domain *zevio_irq_domain;
+
+static void zevio_irq_ack(struct irq_data *irqd)
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
+static void zevio_irq_unmask(struct irq_data *irqd)
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
+static void zevio_irq_mask(struct irq_data *irqd)
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
+static struct irq_chip zevio_irq_chip = {
+	.name		= "zevio_irq",
+	.irq_ack	= zevio_irq_ack,
+	.irq_mask	= zevio_irq_mask,
+	.irq_unmask	= zevio_irq_unmask,
+};
+
+
+static int zevio_irq_map(struct irq_domain *dom, unsigned int virq,
+		irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &zevio_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops zevio_irq_ops = {
+	.map = zevio_irq_map,
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
+	irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
+	handle_IRQ(irqnr, regs);
+
+	return 1;
+}
+
+asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
+{
+	while (process_base(irq_io_base + IO_FIQ_BASE, regs))
+		;
+	while (process_base(irq_io_base + IO_IRQ_BASE, regs))
+		;
+}
+
+static int __init zevio_of_init(struct device_node *node,
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
+	zevio_irq_domain = irq_domain_add_linear(node, MAX_INTRS,
+						 &zevio_irq_ops, NULL);
+
+	BUG_ON(!zevio_irq_domain);
+
+	set_handle_irq(zevio_handle_irq);
+
+	pr_info("TI-NSPIRE classic IRQ controller\n");
+	return 0;
+}
+
+IRQCHIP_DECLARE(zevio_irq, "lsi,zevio-intc", zevio_of_init);
-- 
1.8.1.3

