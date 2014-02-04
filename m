Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaBDUe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:34:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:49263 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaBDUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:34:53 -0500
Date: Tue, 4 Feb 2014 21:34:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT Pull] irq updates
Message-ID: <alpine.DEB.2.02.1402042133340.24986@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

This lot provides:

     * Bugfixes for armada irq controller
     * Updates to renesas irq chip
     * Support for the TI-NSPIRE irq controller

Not strictly a bug fix only pull request, but important updates for
some of the arm Socs which I completely forgot to send last
week.

Seems like my obliviousness is getting worse, I just can't remember
when it started.

Thanks,

	tglx

------------------>
Daniel Tang (1):
      irqchip: Add support for TI-NSPIRE irqchip

Lior Amsalem (2):
      irqchip: armada-370-xp: fix IPI race condition
      irqchip: armada-370-xp: fix MSI race condition

Magnus Damm (2):
      irqchip: renesas-irqc: Use lazy disable
      irqchip: renesas-irqc: Enable mask on suspend


 .../interrupt-controller/lsi,zevio-intc.txt        |   18 +++
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-armada-370-xp.c                |    4 +-
 drivers/irqchip/irq-renesas-irqc.c                 |    4 +-
 drivers/irqchip/irq-zevio.c                        |  127 ++++++++++++++++++++
 5 files changed, 149 insertions(+), 5 deletions(-)
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
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 433cc85..3fac063 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -381,7 +381,7 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 						ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
 				& PCI_MSI_DOORBELL_MASK;
 
-			writel(~PCI_MSI_DOORBELL_MASK, per_cpu_int_base +
+			writel(~msimask, per_cpu_int_base +
 			       ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 
 			for (msinr = PCI_MSI_DOORBELL_START;
@@ -407,7 +407,7 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 						ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
 				& IPI_DOORBELL_MASK;
 
-			writel(~IPI_DOORBELL_MASK, per_cpu_int_base +
+			writel(~ipimask, per_cpu_int_base +
 				ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 
 			/* Handle all pending doorbells */
diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-renesas-irqc.c
index 2f404ba..082d95c 100644
--- a/drivers/irqchip/irq-renesas-irqc.c
+++ b/drivers/irqchip/irq-renesas-irqc.c
@@ -212,10 +212,8 @@ static int irqc_probe(struct platform_device *pdev)
 	irq_chip->name = name;
 	irq_chip->irq_mask = irqc_irq_disable;
 	irq_chip->irq_unmask = irqc_irq_enable;
-	irq_chip->irq_enable = irqc_irq_enable;
-	irq_chip->irq_disable = irqc_irq_disable;
 	irq_chip->irq_set_type = irqc_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->number_of_irqs,
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
new file mode 100644
index 0000000..8ed04c4
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
+static asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
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
