Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3HSUg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:36:57 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43362 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3HSUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:36:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] irqchip: add DesignWare APB ICTL interrupt controller
Date: Mon, 19 Aug 2013 22:36:47 +0200
Message-Id: <1376944607-20322-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an irqchip driver and corresponding devicetree binding for the
secondary interrupt controllers based on Synopsys DesignWare IP dw_apb_ictl.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Note: This single patch is separated from an RFC for initial support of
Marvell Armada 1500 [1]. The RFC needs some more work, while this driver is
fairly self-contained.

[1] http://lists-archives.com/linux-kernel/27893855-arm-initial-support-for-marvell-armada-1500.html

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../interrupt-controller/snps,dw-apb-ictl.txt      |   29 ++++
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-dw-apb-ictl.c                  |  139 ++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
new file mode 100644
index 0000000..7ccd1ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
@@ -0,0 +1,29 @@
+Synopsys DesignWare APB interrupt controller (dw_apb_ictl)
+
+Synopsys DesignWare provides interrupt controller IP for APB known as
+dw_apb_ictl. The IP is used as secondary interrupt controller in some SoCs with
+APB bus, e.g. Marvell Armada 1500.
+
+Required properties:
+- compatible: shall be "snps,dw-apb-ictl"
+- reg: base address of interrupt registers starting with ENABLE_LOW register
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
+- interrupts: interrupt reference to primary interrupt controller
+- interrupt-parent: (optional) reference specific primary interrupt controller
+
+The interrupt sources map to the corresponding bits in the interrupt
+registers, i.e.
+- 0 maps to bit 0 of low interrupts,
+- 1 maps to bit 1 of low interrupts,
+- 32 maps to bit 0 of high interrupts, and so on.
+
+Example:
+	aic: interrupt-controller@3000 {
+		compatible = "snps,dw-apb-ictl";
+		reg = <0x3000 0xc00>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+	};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 1fea003..f38164c 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -30,6 +30,10 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config DW_APB_ICTL
+	bool
+	select IRQ_DOMAIN
+
 config ORION_IRQCHIP
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index e65c41a..54164e1 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
+obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
new file mode 100644
index 0000000..3af7d30
--- /dev/null
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -0,0 +1,139 @@
+/*
+ * Synopsys DW APB ICTL irqchip driver.
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
+#include <linux/irqchip/chained_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#include "irqchip.h"
+
+#define APB_INT_ENABLE_L	0x00
+#define APB_INT_ENABLE_H	0x04
+#define APB_INT_MASK_L		0x08
+#define APB_INT_MASK_H		0x0c
+#define APB_INT_FINALSTATUS_L	0x30
+#define APB_INT_FINALSTATUS_H	0x34
+
+static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct irq_chip_generic *gc = irq_get_handler_data(irq);
+	struct irq_domain *d = gc->private;
+	u32 stat;
+	int n;
+
+	chained_irq_enter(chip, desc);
+
+	for (n = 0; n < gc->num_ct; n++) {
+		stat = readl_relaxed(gc->reg_base +
+				     APB_INT_FINALSTATUS_L + 4 * n);
+		while (stat) {
+			u32 hwirq = ffs(stat) - 1;
+			generic_handle_irq(irq_find_mapping(d,
+					    gc->irq_base + hwirq + 32 * n));
+			stat &= ~(1 << hwirq);
+		}
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static int __init dw_apb_ictl_init(struct device_node *np,
+				   struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	void __iomem *iobase;
+	int ret, nrirqs, irq;
+	u32 reg;
+
+	/* Map the parent interrupt for the chained handler */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", np->name);
+		return -EINVAL;
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
+	iobase = ioremap(r.start, resource_size(&r));
+	if (!iobase) {
+		pr_err("%s: unable to map resource\n", np->name);
+		return -ENOMEM;
+	}
+
+	/*
+	 * DW IP can be configured to allow 2-64 irqs. We can determine
+	 * the number of irqs supported by writing into enable register
+	 * and look for bits not set, as corresponding flip-flops will
+	 * have been removed by sythesis tool.
+	 */
+
+	/* mask and enable all interrupts */
+	writel(~0, iobase + APB_INT_MASK_L);
+	writel(~0, iobase + APB_INT_MASK_H);
+	writel(~0, iobase + APB_INT_ENABLE_L);
+	writel(~0, iobase + APB_INT_ENABLE_H);
+
+	reg = readl(iobase + APB_INT_ENABLE_H);
+	if (reg)
+		nrirqs = 32 + fls(reg);
+	else
+		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
+
+	domain = irq_domain_add_linear(np, nrirqs,
+				       &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: unable to add irq domain\n", np->name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 32, (nrirqs > 32) ? 2 : 1,
+					     np->name, handle_level_irq, clr, 0,
+					     IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: unable to alloc irq domain gc\n", np->name);
+		return ret;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->private = domain;
+	gc->reg_base = iobase;
+
+	gc->chip_types[0].regs.mask = APB_INT_MASK_L;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+
+	if (nrirqs > 32) {
+		gc->chip_types[1].regs.mask = APB_INT_MASK_H;
+		gc->chip_types[1].chip.irq_mask = irq_gc_mask_set_bit;
+		gc->chip_types[1].chip.irq_unmask = irq_gc_mask_clr_bit;
+	}
+
+	irq_set_handler_data(irq, gc);
+	irq_set_chained_handler(irq, dw_apb_ictl_handler);
+
+	return 0;
+}
+IRQCHIP_DECLARE(dw_apb_ictl,
+		"snps,dw-apb-ictl", dw_apb_ictl_init);
-- 
1.7.10.4

