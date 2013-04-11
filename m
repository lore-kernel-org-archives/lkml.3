Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3DKNSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:18:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:16043 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab3DKNST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:18:19 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: [PATCH] irqchip: Add TB10x interrupt controller driver
Date: Thu, 11 Apr 2013 15:17:32 +0200
Message-Id: <1365686252-9828-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC interrupt controller driver for the Abilis Systems TB10x series of
SOCs based on ARC700 CPUs.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---
 .../interrupt-controller/abilis,tb10x_ictl.txt     |   38 +++
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-tb10x.c                        |  254 ++++++++++++++++++++
 3 files changed, 293 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
 create mode 100644 drivers/irqchip/irq-tb10x.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
new file mode 100644
index 0000000..bc292cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
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
+- compatible: Should be "abilis,tb10x_ictl"
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
+	compatible = "abilis,tb10x_ictl";
+	reg = <0x2000 0x20>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	interrupt-parent = <&intc>;
+	interrupts = <5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
+			20 21 22 23 24 25 26 27 28 29 30 31>;
+};
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 98e3b87..ab64cc2 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
+obj-$(CONFIG_ARC_PLAT_TB10X)		+= irq-tb10x.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
new file mode 100644
index 0000000..542de1e
--- /dev/null
+++ b/drivers/irqchip/irq-tb10x.c
@@ -0,0 +1,254 @@
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
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include "../../drivers/irqchip/irqchip.h"
+
+#define AB_IRQCTL_INT_ENABLE   (0x00)
+#define AB_IRQCTL_INT_STATUS   (0x04)
+#define AB_IRQCTL_SRC_MODE     (0x08)
+#define AB_IRQCTL_SRC_POLARITY (0x0C)
+#define AB_IRQCTL_INT_MODE     (0x10)
+#define AB_IRQCTL_INT_POLARITY (0x14)
+#define AB_IRQCTL_INT_FORCE    (0x18)
+
+struct tb10x_ictl {
+	void *base;
+	struct irq_domain *domain;
+};
+
+static inline void ab_irqctl_writereg(struct tb10x_ictl *ictl, u32 reg,
+	u32 val)
+{
+	iowrite32(val, (u32 *)(ictl->base + reg));
+}
+
+static inline u32 ab_irqctl_readreg(struct tb10x_ictl *ictl, u32 reg)
+{
+	return ioread32((u32 *)(ictl->base + reg));
+}
+
+static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct tb10x_ictl *ictl = irq_data_get_irq_chip_data(data);
+	unsigned int irq = data->irq;
+	unsigned int hwirq = irqd_to_hwirq(data);
+	uint32_t im, mod, pol;
+
+	im = 1UL << hwirq;
+
+	mod = ab_irqctl_readreg(ictl, AB_IRQCTL_SRC_MODE) | im;
+	pol = ab_irqctl_readreg(ictl, AB_IRQCTL_SRC_POLARITY) | im;
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
+		pr_err("%s: Cannot assign multiple trigger modes to IRQ %d.\n",
+			__func__, irq);
+		return -EBADR;
+	}
+
+	irqd_set_trigger_type(data, flow_type);
+
+	ab_irqctl_writereg(ictl, AB_IRQCTL_SRC_MODE, mod);
+	ab_irqctl_writereg(ictl, AB_IRQCTL_SRC_POLARITY, pol);
+	ab_irqctl_writereg(ictl, AB_IRQCTL_INT_STATUS, im);
+
+	if (flow_type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+		__irq_set_handler_locked(irq, handle_level_irq);
+	else
+		__irq_set_handler_locked(irq, handle_edge_irq);
+
+	return IRQ_SET_MASK_OK;
+}
+
+static void tb10x_irq_unmask(struct irq_data *data)
+{
+	struct tb10x_ictl *ictl = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+
+	ab_irqctl_writereg(ictl, AB_IRQCTL_INT_ENABLE,
+		ab_irqctl_readreg(ictl, AB_IRQCTL_INT_ENABLE) | (1 << hwirq));
+}
+
+static void tb10x_irq_mask(struct irq_data *data)
+{
+	struct tb10x_ictl *ictl = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+
+	ab_irqctl_writereg(ictl, AB_IRQCTL_INT_ENABLE,
+		ab_irqctl_readreg(ictl, AB_IRQCTL_INT_ENABLE) & ~(1 << hwirq));
+}
+
+static void tb10x_irq_ack(struct irq_data *data)
+{
+	struct tb10x_ictl *ictl = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+
+	ab_irqctl_writereg(ictl, AB_IRQCTL_INT_STATUS,
+			ab_irqctl_readreg(ictl, AB_IRQCTL_SRC_MODE)
+			& (1 << hwirq));
+}
+
+static struct irq_chip irq_tb10x_chip = {
+	.name          = "TB10x-ICTL",
+	.irq_ack       = tb10x_irq_ack,
+	.irq_mask      = tb10x_irq_mask,
+	.irq_unmask    = tb10x_irq_unmask,
+	.irq_set_type  = tb10x_irq_set_type,
+};
+
+static int tb10x_irq_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_and_handler(irq, &irq_tb10x_chip, handle_level_irq);
+
+	return 0;
+}
+
+static int tb10x_irq_xlate(struct irq_domain *d, struct device_node *node,
+			const u32 *intspec, unsigned int intsize,
+			unsigned long *out_hwirq, unsigned int *out_type)
+{
+	static const unsigned int tb10x_xlate_types[] = {
+		IRQ_TYPE_EDGE_RISING,
+		IRQ_TYPE_LEVEL_LOW,
+		IRQ_TYPE_LEVEL_HIGH,
+		IRQ_TYPE_EDGE_FALLING,
+	};
+
+	if (WARN_ON(intsize != 2))
+		return -EINVAL;
+
+	if (WARN_ON(intspec[1] >= ARRAY_SIZE(tb10x_xlate_types)))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = tb10x_xlate_types[intspec[1]];
+	return 0;
+}
+
+static struct irq_domain_ops irq_tb10x_domain_ops = {
+	.map	= tb10x_irq_map,
+	.xlate	= tb10x_irq_xlate,
+};
+
+static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
+{
+	struct tb10x_ictl *ictl = irq_desc_get_handler_data(desc);
+
+	generic_handle_irq(irq_find_mapping(ictl->domain, irq));
+}
+
+static int __init of_tb10x_init_irq(struct device_node *ictl,
+					struct device_node *parent)
+{
+	int i;
+	int ret;
+	int nrirqs = of_irq_count(ictl);
+	struct resource mem;
+	struct tb10x_ictl *ic;
+
+	ic = kmalloc(sizeof(struct tb10x_ictl), GFP_KERNEL);
+	if (!ic)
+		return -ENOMEM;
+
+	ic->domain = irq_domain_add_tree(ictl, &irq_tb10x_domain_ops, ic);
+	if (!ic->domain) {
+		ret = -ENOMEM;
+		goto irq_domain_add_fail;
+	}
+
+	if (of_address_to_resource(ictl, 0, &mem)) {
+		pr_err("%s: No registers declared in DeviceTree.\n",
+			ictl->name);
+		ret = -EINVAL;
+		goto of_reg_get_fail;
+	}
+
+	if (!request_mem_region(mem.start, resource_size(&mem),
+		irq_tb10x_chip.name)) {
+		ret = -EBUSY;
+		goto reg_request_fail;
+	}
+
+	ic->base = ioremap(mem.start, resource_size(&mem));
+	if (!ic->base) {
+		ret = -EBUSY;
+		goto ioremap_fail;
+	}
+
+	for (i = 0; i < nrirqs; i++) {
+		unsigned int irq, hwirq;
+		struct irq_data *irq_data;
+
+		irq = irq_of_parse_and_map(ictl, i);
+		irq_data = irq_get_irq_data(irq);
+
+		if (!irq_data)
+			continue;
+
+		hwirq = irqd_to_hwirq(irq_data);
+
+		if (irq != hwirq)
+			panic("IRQ %d maps to hardware IRQ %d.\n", irq, hwirq);
+
+		irq_set_handler_data(irq, ic);
+		irq_set_chained_handler(irq, tb10x_irq_cascade);
+	}
+
+	ab_irqctl_writereg(ic, AB_IRQCTL_INT_ENABLE, 0);
+	ab_irqctl_writereg(ic, AB_IRQCTL_INT_MODE, 0);
+	ab_irqctl_writereg(ic, AB_IRQCTL_INT_POLARITY, 0);
+	ab_irqctl_writereg(ic, AB_IRQCTL_INT_STATUS, ~0UL);
+
+	return 0;
+
+ioremap_fail:
+	release_mem_region(mem.start, resource_size(&mem));
+reg_request_fail:
+of_reg_get_fail:
+	irq_domain_remove(ic->domain);
+irq_domain_add_fail:
+	kfree(ic);
+	return ret;
+}
+IRQCHIP_DECLARE(tb10x_intc, "abilis,tb10x_ictl", of_tb10x_init_irq);
-- 
1.7.1

