Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3LEGMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 01:12:41 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53322 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3LEGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 01:12:40 -0500
From: dt.tangr@gmail.com
To: tglx@linutronix.de
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCHv3] irqchip: Add support for TI-NSPIRE irqchip
Date: Thu,  5 Dec 2013 17:12:17 +1100
Message-Id: <1386223937-12189-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

This patch adds support for the interrupt controllers found in some
TI-Nspire models.

FIQ support was taken out to simplify the driver
code and may be added in later. Since Linux on this platform doesn't
really use FIQs, this wasn't really that important in the first
place.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
Changes from v1 to v2:
* Converted to use generic IRQ chips.
* Removed FIQ for now to simplify driver code.
* Based against tip/irq/core and uses IRQ domain support for generic
 chips.

Changes from v2 to v3:
* Removed unnessecary locking in interrupt acking function
* Mark zevio_init_irq_base as __init since it's only used at init

 .../interrupt-controller/lsi,zevio-intc.txt        |   18 +++
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-zevio.c                        |  127 ++++++++++++++++++++
 3 files changed, 146 insertions(+)
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
index c60b901..292b106 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -20,5 +20,6 @@ obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
+obj-$(CONFIG_ARCH_NSPIRE)		+= irq-zevio.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
 obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
new file mode 100644
index 0000000..3f52bb7
--- /dev/null
+++ b/drivers/irqchip/irq-zevio.c
@@ -0,0 +1,127 @@
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
+static struct irq_domain *zevio_irq_domain;
+static void __iomem *zevio_irq_io;
+
+static void zevio_irq_ack(struct irq_data *irqd)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(irqd);
+	struct irq_chip_regs *regs =
+		&container_of(irqd->chip, struct irq_chip_type, chip)->regs;
+
+	readl(gc->reg_base + regs->ack);
+}
+
+static void __init zevio_init_irq_base(void __iomem *base)
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
+asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
+{
+	int irqnr;
+
+	while (readl(zevio_irq_io + IO_STATUS)) {
+		irqnr = readl(zevio_irq_io + IO_CURRENT);
+		irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
+		handle_IRQ(irqnr, regs);
+	};
+}
+
+static int __init zevio_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct irq_chip_generic *gc;
+	int ret;
+
+	if (WARN_ON(zevio_irq_io || zevio_irq_domain))
+		return -EBUSY;
+
+	zevio_irq_io = of_iomap(node, 0);
+	BUG_ON(!zevio_irq_io);
+
+	/* Do not invert interrupt status bits */
+	writel(~0, zevio_irq_io + IO_INVERT_SEL);
+
+	/* Disable sticky interrupts */
+	writel(0, zevio_irq_io + IO_STICKY_SEL);
+
+	/* We don't use IRQ priorities. Set each IRQ to highest priority. */
+	memset_io(zevio_irq_io + IO_PRIORITY_SEL, 0, MAX_INTRS * sizeof(u32));
+
+	/* Init IRQ and FIQ */
+	zevio_init_irq_base(zevio_irq_io + IO_IRQ_BASE);
+	zevio_init_irq_base(zevio_irq_io + IO_FIQ_BASE);
+
+	zevio_irq_domain = irq_domain_add_linear(node, MAX_INTRS,
+						 &irq_generic_chip_ops, NULL);
+	BUG_ON(!zevio_irq_domain);
+
+	ret = irq_alloc_domain_generic_chips(zevio_irq_domain, MAX_INTRS, 1,
+					     "zevio_intc", handle_level_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	BUG_ON(ret);
+
+	gc = irq_get_domain_generic_chip(zevio_irq_domain, 0);
+	gc->reg_base				= zevio_irq_io;
+	gc->chip_types[0].chip.irq_ack		= zevio_irq_ack;
+	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_disable_reg;
+	gc->chip_types[0].chip.irq_unmask	= irq_gc_unmask_enable_reg;
+	gc->chip_types[0].regs.mask		= IO_IRQ_BASE + IO_ENABLE;
+	gc->chip_types[0].regs.enable		= IO_IRQ_BASE + IO_ENABLE;
+	gc->chip_types[0].regs.disable		= IO_IRQ_BASE + IO_DISABLE;
+	gc->chip_types[0].regs.ack		= IO_IRQ_BASE + IO_RESET;
+
+	set_handle_irq(zevio_handle_irq);
+
+	pr_info("TI-NSPIRE classic IRQ controller\n");
+	return 0;
+}
+
+IRQCHIP_DECLARE(zevio_irq, "lsi,zevio-intc", zevio_of_init);
-- 
1.7.10.4

