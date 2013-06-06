Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3FFQ1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:27:40 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:39505 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3FFQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:27:38 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] irqchip: add support for Marvell Orion SoCs
Date: Thu,  6 Jun 2013 18:27:09 +0200
Message-Id: <1370536034-23956-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an irqchip driver for the main interrupt controller found
on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
Corresponding device tree documentation is also added.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../interrupt-controller/marvell,orion-intc.txt    |   48 +++++
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-orion.c                        |  193 ++++++++++++++++++++
 4 files changed, 247 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
 create mode 100644 drivers/irqchip/irq-orion.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
new file mode 100644
index 0000000..2c11ac7
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
@@ -0,0 +1,48 @@
+Marvell Orion SoC interrupt controllers
+
+* Main interrupt controller
+
+Required properties:
+- compatible: shall be "marvell,orion-intc"
+- reg: base address(es) of interrupt registers starting with CAUSE register
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
+
+The interrupt sources map to the corresponding bits in the interrupt
+registers, i.e.
+- 0 maps to bit 0 of first base address,
+- 1 maps to bit 1 of first base address,
+- 32 maps to bit 0 of second base address, and so on.
+
+Example:
+	intc: interrupt-controller {
+		compatible = "marvell,orion-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		 /* Dove has 64 first level interrupts */
+		reg = <0x20200 0x10>, <0x20210 0x10>;
+	};
+
+* Bridge interrupt controller
+
+Required properties:
+- compatible: shall be "marvell,orion-bridge-intc"
+- reg: base address of bridge interrupt registers starting with CAUSE register
+- interrupts: bridge interrupt of the main interrupt controller
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
+
+Optional properties:
+- marvell,#interrupts: number of interrupts provided by bridge interrupt
+      controller, defaults to 32 if not set
+
+Example:
+	bridge_intc: interrupt-controller {
+		compatible = "marvell,orion-bridge-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x20110 0x8>;
+		interrupts = <0>;
+		/* Dove bridge provides 5 interrupts */
+		marvell,#interrupts = <5>;
+	};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..68c3107 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -25,6 +25,11 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config ORION_IRQCHIP
+	bool
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+
 config RENESAS_INTC_IRQPIN
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..55df3bd 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
+obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
new file mode 100644
index 0000000..693ea20
--- /dev/null
+++ b/drivers/irqchip/irq-orion.c
@@ -0,0 +1,193 @@
+/*
+ * Marvell Orion SoCs IRQ chip driver.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
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
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
+
+/*
+ * Orion SoC main interrupt controller
+ */
+
+#define ORION_IRQS_PER_CHIP		32
+
+#define ORION_IRQ_CAUSE			0x00
+#define ORION_IRQ_MASK			0x04
+#define ORION_IRQ_FIQ_MASK		0x08
+#define ORION_IRQ_ENDP_MASK		0x0c
+
+static struct irq_domain *orion_irq_domain;
+
+static asmlinkage void __exception_irq_entry orion_handle_irq(
+	struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = orion_irq_domain->gc;
+	int n, base = 0;
+
+	for (n = 0; n < dgc->num_chips; n++, base += ORION_IRQS_PER_CHIP) {
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(orion_irq_domain, base);
+		u32 stat = readl_relaxed(gc->reg_base + ORION_IRQ_CAUSE) &
+			gc->mask_cache;
+		while (stat) {
+			u32 hwirq = ffs(stat) - 1;
+			u32 irq = irq_find_mapping(orion_irq_domain,
+						   gc->irq_base + hwirq);
+			handle_IRQ(irq, regs);
+			stat &= ~(1 << hwirq);
+		}
+	}
+}
+
+static int __init orion_irq_init(struct device_node *np,
+				 struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	int n, ret, base, num_chips = 0;
+
+	/* count number of irq chips by valid reg addresses */
+	while (of_address_to_resource(np, num_chips, &r) == 0)
+		num_chips++;
+
+	orion_irq_domain = irq_domain_add_linear(np,
+				num_chips * ORION_IRQS_PER_CHIP,
+				&irq_generic_chip_ops, NULL);
+	if (!orion_irq_domain)
+		panic("%s: unable to add irq domain\n", np->name);
+
+	ret = irq_alloc_domain_generic_chips(orion_irq_domain,
+				ORION_IRQS_PER_CHIP, 1, np->name,
+				handle_level_irq, clr, 0,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret)
+		panic("%s: unable to alloc irq domain gc\n", np->name);
+
+	for (n = 0, base = 0; n < num_chips; n++, base += ORION_IRQS_PER_CHIP) {
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(orion_irq_domain, base);
+
+		of_address_to_resource(np, n, &r);
+
+		if (!request_mem_region(r.start, resource_size(&r), np->name))
+			panic("%s: unable to request mem region %d",
+			      np->name, n);
+
+		gc->reg_base = ioremap(r.start, resource_size(&r));
+		if (!gc->reg_base)
+			panic("%s: unable to map resource %d", np->name, n);
+
+		gc->chip_types[0].regs.mask = ORION_IRQ_MASK;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+		/* mask all interrupts */
+		writel(0, gc->reg_base + ORION_IRQ_MASK);
+	}
+
+	set_handle_irq(orion_handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(orion_intc, "marvell,orion-intc", orion_irq_init);
+
+/*
+ * Orion SoC bridge interrupt controller
+ */
+
+#define ORION_BRIDGE_IRQ_CAUSE	0x00
+#define ORION_BRIDGE_IRQ_MASK	0x04
+
+static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *d = irq_get_handler_data(irq);
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
+	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
+		gc->mask_cache;
+
+	while (stat) {
+		u32 hwirq = ffs(stat) - 1;
+		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
+		stat &= ~(1 << hwirq);
+	}
+}
+
+static int __init orion_bridge_irq_init(struct device_node *np,
+					struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	int ret, irq, nrirqs = 32;
+
+	/* get optional number of interrupts provided */
+	of_property_read_u32(np, "marvell,#interrupts", &nrirqs);
+
+	domain = irq_domain_add_linear(np, nrirqs,
+				       &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: unable to add irq domain\n", np->name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
+			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: unable to alloc irq domain gc\n", np->name);
+		return ret;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	if (ret) {
+		pr_err("%s: unable to get resource\n", np->name);
+		return ret;
+	}
+
+	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
+		pr_err("%s: unable to request mem region\n", np->name);
+		return -ENOMEM;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", np->name);
+		return -EINVAL;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->reg_base = ioremap(r.start, resource_size(&r));
+	if (!gc->reg_base) {
+		pr_err("%s: unable to map resource\n", np->name);
+		return -ENOMEM;
+	}
+
+	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
+	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+	/* mask all interrupts */
+	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+
+	irq_set_handler_data(irq, domain);
+	irq_set_chained_handler(irq, orion_bridge_irq_handler);
+
+	return 0;
+}
+IRQCHIP_DECLARE(orion_bridge_intc,
+		"marvell,orion-bridge-intc", orion_bridge_irq_init);
-- 
1.7.2.5

