Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3FYQay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:30:54 -0400
Received: from mail.abilis.ch ([195.70.19.74]:21688 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3FYQaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:30:52 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH V4] irqchip: Add TB10x interrupt controller driver
Date: Tue, 25 Jun 2013 18:29:57 +0200
Message-Id: <1372177797-9458-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.DEB.2.02.1306251636270.4013@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1306251636270.4013@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC interrupt controller driver for the Abilis Systems TB10x series of
SOCs based on ARC700 CPUs.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---
This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.

 .../interrupt-controller/abilis,tb10x-ictl.txt     |   38 ++++
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-tb10x.c                        |  195 ++++++++++++++++++++
 4 files changed, 239 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
 create mode 100644 drivers/irqchip/irq-tb10x.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
new file mode 100644
index 0000000..9d52d5a
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
@@ -0,0 +1,38 @@
+TB10x Top Level Interrupt Controller
+====================================
+
+The Abilis TB10x SOC contains a custom interrupt controller. It performs
+one-to-one mapping of external interrupt sources to CPU interrupts and
+provides support for reconfigurable trigger modes.
+
+Required properties
+-------------------
+
+- compatible: Should be "abilis,tb10x-ictl"
+- reg: specifies physical base address and size of register range.
+- interrupt-congroller: Identifies the node as an interrupt controller.
+- #interrupt cells: Specifies the number of cells used to encode an interrupt
+  source connected to this controller. The value shall be 2.
+- interrupt-parent: Specifies the parent interrupt controller.
+- interrupts: Specifies the list of interrupt lines which are handled by
+  the interrupt controller in the parent controller's notation. Interrupts
+  are mapped one-to-one to parent interrupts.
+
+Example
+-------
+
+intc: interrupt-controller {	/* Parent interrupt controller */
+	interrupt-controller;
+	#interrupt-cells = <1>;	/* For example below */
+	/* ... */
+};
+
+tb10x_ictl: pic@2000 {		/* TB10x interrupt controller */
+	compatible = "abilis,tb10x-ictl";
+	reg = <0x2000 0x20>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	interrupt-parent = <&intc>;
+	interrupts = <5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
+			20 21 22 23 24 25 26 27 28 29 30 31>;
+};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..8843f21 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -33,6 +33,11 @@ config RENESAS_IRQC
 	bool
 	select IRQ_DOMAIN
 
+config TB10X_IRQC
+	bool
+	select IRQ_DOMAIN
+	select GENERIC_IRQ_CHIP
+
 config VERSATILE_FPGA_IRQ
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..b45e4a4 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
+obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
new file mode 100644
index 0000000..7c44c99
--- /dev/null
+++ b/drivers/irqchip/irq-tb10x.c
@@ -0,0 +1,195 @@
+/*
+ * Abilis Systems interrupt controller driver
+ *
+ * Copyright (C) Abilis Systems 2012
+ *
+ * Author: Christian Ruppert <christian.ruppert@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/irq.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include "irqchip.h"
+
+#define AB_IRQCTL_INT_ENABLE   0x00
+#define AB_IRQCTL_INT_STATUS   0x04
+#define AB_IRQCTL_SRC_MODE     0x08
+#define AB_IRQCTL_SRC_POLARITY 0x0C
+#define AB_IRQCTL_INT_MODE     0x10
+#define AB_IRQCTL_INT_POLARITY 0x14
+#define AB_IRQCTL_INT_FORCE    0x18
+
+#define AB_IRQCTL_MAXIRQ       32
+
+static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
+	u32 val)
+{
+	irq_reg_writel(val, gc->reg_base + reg);
+}
+
+static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
+{
+	return irq_reg_readl(gc->reg_base + reg);
+}
+
+static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	uint32_t im, mod, pol;
+
+	im = data->mask;
+
+	irq_gc_lock(gc);
+
+	mod = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_MODE) | im;
+	pol = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_POLARITY) | im;
+
+	switch (flow_type & IRQF_TRIGGER_MASK) {
+	case IRQ_TYPE_EDGE_FALLING:
+		pol ^= im;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		mod ^= im;
+		break;
+	case IRQ_TYPE_NONE:
+		flow_type = IRQ_TYPE_LEVEL_LOW;
+	case IRQ_TYPE_LEVEL_LOW:
+		mod ^= im;
+		pol ^= im;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		break;
+	default:
+		irq_gc_unlock(gc);
+		pr_err("%s: Cannot assign multiple trigger modes to IRQ %d.\n",
+			__func__, data->irq);
+		return -EBADR;
+	}
+
+	irqd_set_trigger_type(data, flow_type);
+	irq_setup_alt_chip(data, flow_type);
+
+	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_MODE, mod);
+	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_POLARITY, pol);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, im);
+
+	irq_gc_unlock(gc);
+
+	return IRQ_SET_MASK_OK;
+}
+
+static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *domain = irq_desc_get_handler_data(desc);
+
+	generic_handle_irq(irq_find_mapping(domain, irq));
+}
+
+static int __init of_tb10x_init_irq(struct device_node *ictl,
+					struct device_node *parent)
+{
+	int i, ret, nrirqs = of_irq_count(ictl);
+	struct resource mem;
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	void __iomem *reg_base;
+
+	if (of_address_to_resource(ictl, 0, &mem)) {
+		pr_err("%s: No registers declared in DeviceTree.\n",
+			ictl->name);
+		return -EINVAL;
+	}
+
+	if (!request_mem_region(mem.start, resource_size(&mem),
+		ictl->name)) {
+		pr_err("%s: Request mem region failed.\n", ictl->name);
+		return -EBUSY;
+	}
+
+	reg_base = ioremap(mem.start, resource_size(&mem));
+	if (!reg_base) {
+		ret = -EBUSY;
+		pr_err("%s: ioremap failed.\n", ictl->name);
+		goto ioremap_fail;
+	}
+
+	domain = irq_domain_add_linear(ictl, AB_IRQCTL_MAXIRQ,
+					&irq_generic_chip_ops, NULL);
+	if (!domain) {
+		ret = -ENOMEM;
+		pr_err("%s: Could not register interrupt domain.\n",
+			ictl->name);
+		goto irq_domain_add_fail;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, AB_IRQCTL_MAXIRQ,
+				2, ictl->name, handle_level_irq,
+				IRQ_NOREQUEST, IRQ_NOPROBE,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: Could not allocate generic interrupt chip.\n",
+			ictl->name);
+		goto gc_alloc_fail;
+	}
+
+	gc = domain->gc->gc[0];
+	gc->reg_base                         = reg_base;
+
+	gc->chip_types[0].type               = IRQ_TYPE_LEVEL_MASK;
+	gc->chip_types[0].chip.irq_mask      = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask    = irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_set_type  = tb10x_irq_set_type;
+	gc->chip_types[0].regs.mask          = AB_IRQCTL_INT_ENABLE;
+
+	gc->chip_types[1].type               = IRQ_TYPE_EDGE_BOTH;
+	gc->chip_types[1].chip.name          = gc->chip_types[0].chip.name;
+	gc->chip_types[1].chip.irq_ack       = irq_gc_ack_set_bit;
+	gc->chip_types[1].chip.irq_mask      = irq_gc_mask_clr_bit;
+	gc->chip_types[1].chip.irq_unmask    = irq_gc_mask_set_bit;
+	gc->chip_types[1].chip.irq_set_type  = tb10x_irq_set_type;
+	gc->chip_types[1].regs.ack           = AB_IRQCTL_INT_STATUS;
+	gc->chip_types[1].regs.mask          = AB_IRQCTL_INT_ENABLE;
+	gc->chip_types[1].handler            = handle_edge_irq;
+
+	for (i = 0; i < nrirqs; i++) {
+		unsigned int irq = irq_of_parse_and_map(ictl, i);
+
+		irq_set_handler_data(irq, domain);
+		irq_set_chained_handler(irq, tb10x_irq_cascade);
+	}
+
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_ENABLE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_MODE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_POLARITY, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, ~0UL);
+
+	return 0;
+
+gc_alloc_fail:
+	irq_domain_remove(domain);
+irq_domain_add_fail:
+	iounmap(reg_base);
+ioremap_fail:
+	release_mem_region(mem.start, resource_size(&mem));
+	return ret;
+}
+IRQCHIP_DECLARE(tb10x_intc, "abilis,tb10x-ictl", of_tb10x_init_irq);
-- 
1.7.1

