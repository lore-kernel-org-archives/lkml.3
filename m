Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3ILPk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:40:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56374 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3ILPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:40:55 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <r.sricharan@ti.com>
Subject: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
Date: Thu, 12 Sep 2013 21:09:08 +0530
Message-ID: <1379000351-15672-2-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts requests to service
the needs of its many peripherals and subsystems. All of the
interrupt lines from the subsystems are not needed at the same
time, so they have to be muxed to the irq-controller appropriately.
In such places a interrupt controllers are preceded by an CROSSBAR
that provides flexibility in muxing the device requests to the controller
inputs.

This models the crossbar IP as a cascaded irqchip controller.
The peripheral crossbar inputs are mapped on to the crossbar irq-domain.
The driver then allocates a 'free' irq line and maps that to the
actual interrupt controller's domain. So every external peripheral interrupt
is routed through the crossbar handler.

 GIC  <----- CROSSBAR <----- PERIPHERAL INTERRUPT LINES

 peripheral's irq_of_parse_and_map()
              |
              |
        crossbar_xlate()
              |
              |
 saves the interrupt properties passed

 peripheral's request_irq(crossbar_number)
              |
              |
        crossbar_request_irq
              |
              |
	allocates free irq and maps it to parent domain
	      |
	      |
        request_irq(mapped interrupt number)

 gic_interrupt_hanadler
            |
            |
 crossbar_irq(interrupt number)
            |
            |
 get crossbar number from interrupt number
            |
            |
 handle_irq(crossbar_domain(crossbar number))

The irqchip callback hooks added here are just a redirection to the
parent irqchip.

This adds a extra translation in the fast path. The maximum increase in
the average interrupt latency due to the same was measured as around 1.63us
on a cpu running at 1GHZ.

cat /proc/interrupts looks like this, with both crossbar and interrupt number

           CPU0       CPU1
 45:        267          0       GIC  OMAP UART0
205:        267          0  CROSSBAR  OMAP UART0

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
There is lockdep warning during the boot. This is because we try to
do one request_irq with in another and that results in kmalloc being
called from an atomic context, which generates the warning.
Any suggestions to overcome this will help.

  WARNING: at kernel/lockdep.c:2740 lockdep_trace_alloc+0xe8/0x108()
  DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))

 .../devicetree/bindings/arm/omap/irq-crossbar.txt  |   39 ++
 drivers/irqchip/Kconfig                            |    9 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  407 ++++++++++++++++++++
 4 files changed, 456 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/irq-crossbar.txt
 create mode 100644 drivers/irqchip/irq-crossbar.c

diff --git a/Documentation/devicetree/bindings/arm/omap/irq-crossbar.txt b/Documentation/devicetree/bindings/arm/omap/irq-crossbar.txt
new file mode 100644
index 0000000..5d465cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/omap/irq-crossbar.txt
@@ -0,0 +1,39 @@
+* IRQ CROSSBAR
+
+Some socs have a large number of interrupts requests to service
+the needs of its many peripherals and subsystems. All of the
+interrupt lines from the subsystems are not needed at the same
+time, so they have to be muxed to the irq-controller appropriately.
+In such places a interrupt controllers are preceded by an CROSSBAR
+that provides flexibility in muxing the device requests to the controller
+inputs.
+
+Required properties:
+- compatible : Should be "irq-crossbar"
+- interrupt-parent: phandle to crossbar's interrupt parent.
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupt-cells: Should be the same value as the interrupt parent.
+- reg: Base address and the size of the crossbar registers.
+- max-crossbar-lines: Total number of input lines of the crossbar.
+- max-irqs: Total number of irqs available at the interrupt controller.
+- reg-size: size of the crossbar registers.
+- irqs-reserved: List of the reserved irq lines that are not muxed using
+		 crossbar. These interrupt lines are reserved in the soc,
+		 so crossbar bar driver should not consider them as free
+		 lines.
+
+Examples:
+		crossbar_mpu: @4a020000 {
+			compatible = "irq-crossbar";
+			interrupt-parent = <&gic>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0x4a002a48 0x130>;
+			max-crossbar-lines = <512>;
+			max-irqs = <160>;
+			reg-size = <2>;
+			irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+		};
+
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..5152777 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -41,3 +41,12 @@ config VERSATILE_FPGA_IRQ_NR
        int
        default 4
        depends on VERSATILE_FPGA_IRQ
+
+config IRQCHIP_CROSSBAR
+	bool
+	help
+	   Those socs which has a crossbar IP to mux the irqs from peripherals
+	   to the interrupt-controllers can use this. This driver would
+	   dynamically allocate a free interrupt line and map the peripheral
+	   crossbar input to the parent interrupt-controller.
+
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..0033d93 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
+obj-$(CONFIG_IRQCHIP_CROSSBAR)		+= irq-crossbar.o
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
new file mode 100644
index 0000000..3980502
--- /dev/null
+++ b/drivers/irqchip/irq-crossbar.c
@@ -0,0 +1,407 @@
+/*
+ *  drivers/irqchip/irq-crossbar.c
+ *
+ *  Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include "irqchip.h"
+
+#define IRQ_FREE	-1
+
+/*
+ * @hwirq: hardware irq line number
+ * @virq: linux irq corresponding to hwirq
+ * @intspec: interrupt specifier passed from DT
+ * @intspec_size: intspec size
+ */
+struct pirqs {
+	int hwirq;
+	int virq;
+	u32 *intspec;
+	int intspec_size;
+};
+
+/*
+ * @irq_map: array of interrupts to crossbar number mapping
+ * @crossbar_map: array of interrupt parent's virtual irqs
+ * @crossbar_base: crossbar base address
+ * @domain: crossbar domain ptr
+ * @irqp: pointer to crossbar irq parent
+ * @register_offsets: offsets for each irq number
+ * @int_max: maximum number of supported interrupts
+ */
+struct crossbar_device {
+	int *irq_map;
+	struct pirqs *crossbar_map;
+	void __iomem *crossbar_base;
+	struct irq_domain *domain;
+	struct device_node *irqp;
+	int *register_offsets;
+	int int_max;
+	void (*write) (int, int);
+};
+
+static struct crossbar_device *cb;
+static struct lock_class_key crossbar_lock_class;
+
+static inline void crossbar_writel(int irq_no, int cb_no)
+{
+	writel(cb_no, cb->crossbar_base + cb->register_offsets[irq_no]);
+}
+
+static inline void crossbar_writew(int irq_no, int cb_no)
+{
+	writew(cb_no, cb->crossbar_base + cb->register_offsets[irq_no]);
+}
+
+static inline void crossbar_writeb(int irq_no, int cb_no)
+{
+	writeb(cb_no, cb->crossbar_base + cb->register_offsets[irq_no]);
+}
+
+static inline int map_free_irq(int cb_no, int irq)
+{
+	int virq;
+
+	cb->crossbar_map[cb_no].intspec[1] = irq;
+
+	/* This maps the free_irq to the parent domain */
+	virq = irq_create_of_mapping(cb->irqp,
+				  (const u32 *)cb->crossbar_map[cb_no].intspec,
+				  cb->crossbar_map[cb_no].intspec_size);
+
+	cb->crossbar_map[cb_no].virq = virq;
+	cb->crossbar_map[cb_no].hwirq = irq;
+
+	return virq;
+}
+
+static inline const u32 allocate_free_irq(int cb_no)
+{
+	int i;
+
+	for (i = 0; i < cb->int_max; i++) {
+		if (cb->irq_map[i] == IRQ_FREE) {
+			cb->irq_map[i] = cb_no;
+			cb->write(i, cb_no);
+			return map_free_irq(cb_no, i);
+		}
+	}
+
+	return -ENODEV;
+}
+
+static irqreturn_t crossbar_irq(int unused,
+				void *hwirq)
+{
+	int *irq = hwirq;
+	int cb_no = cb->irq_map[*irq];
+
+	generic_handle_irq(irq_find_mapping(cb->domain, cb_no));
+
+	return IRQ_HANDLED;
+}
+
+static inline int crossbar_to_virq(int irq)
+{
+	return cb->crossbar_map[irq].virq;
+}
+
+static inline int crossbar_to_irq(int irq)
+{
+	return cb->crossbar_map[irq].hwirq;
+}
+
+static inline void crossbar_to_irq_chip_data(int irq,
+				struct irq_chip **chip,
+				struct irq_data **data)
+{
+	int virq;
+
+	virq = crossbar_to_virq(irq);
+	*chip = irq_get_chip(virq);
+	*data = irq_get_irq_data(virq);
+}
+
+/*
+ * Drivers can call these callbacks directly.
+ * So re-direct it to the parent chip.
+ */
+static void crossbar_eoi_irq(struct irq_data *d)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+
+	if (chip->irq_eoi)
+		return chip->irq_eoi(data);
+}
+
+static int crossbar_set_type(struct irq_data *d, unsigned int type)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+	int ret = 0;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+
+	if (chip->irq_set_type)
+		ret = chip->irq_set_type(data, type);
+
+	return ret;
+}
+
+static void crossbar_unmask_irq(struct irq_data *d)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+
+	if (chip->irq_unmask)
+		return chip->irq_unmask(data);
+}
+
+static void crossbar_mask_irq(struct irq_data *d)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+
+	if (chip->irq_mask)
+		return chip->irq_mask(data);
+}
+
+#ifdef CONFIG_SMP
+static int crossbar_set_affinity(struct irq_data *d,
+				 const struct cpumask *mask_val,
+				 bool force)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+	int ret = 0;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+
+	if (chip->irq_set_affinity)
+		ret = chip->irq_set_affinity(data, mask_val, force);
+
+	return ret;
+}
+#endif
+
+/*
+ * Request and free are already called in atomic contexts
+ */
+unsigned int crossbar_request_irq(struct irq_data *d)
+{
+	int cb_no = d->hwirq;
+	int virq = allocate_free_irq(cb_no);
+	void *irq = &cb->crossbar_map[cb_no].hwirq;
+	int err;
+
+	err = request_threaded_irq(virq, crossbar_irq, NULL,
+				   0, "CROSSBAR", irq);
+	if (err)
+		pr_err("\n request_irq failed for crossbar %d", cb_no);
+
+	return 0;
+}
+
+void crossbar_free_irq(struct irq_data *d)
+{
+	void *irq = &cb->crossbar_map[d->hwirq].hwirq;
+	int hwirq = crossbar_to_irq(d->hwirq);
+	int virq = crossbar_to_virq(d->hwirq);
+
+	free_irq(virq, irq);
+	cb->irq_map[hwirq] = IRQ_FREE;
+	irq_dispose_mapping(virq);
+	cb->crossbar_map[d->hwirq].virq = 0;
+}
+
+static void crossbar_print_name(struct irq_data *d, struct seq_file *p)
+{
+	struct irq_chip *chip;
+	struct irq_data *data;
+	struct irqaction *action;
+
+	crossbar_to_irq_chip_data(d->hwirq, &chip, &data);
+	action = irq_to_desc(data->irq)->action;
+
+	seq_printf(p, " %8s", d->chip->name);
+
+	/* interrupt proc entries look better this way */
+	while (action != NULL) {
+		action->name = irq_to_desc(d->irq)->action->name;
+		action = action->next;
+	}
+}
+
+static struct irq_chip crossbar_chip = {
+	.name			= "CROSSBAR",
+	.irq_startup		= crossbar_request_irq,
+	.irq_shutdown		= crossbar_free_irq,
+	.irq_unmask		= crossbar_unmask_irq,
+	.irq_mask		= crossbar_mask_irq,
+	.irq_eoi		= crossbar_eoi_irq,
+	.irq_set_type		= crossbar_set_type,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= crossbar_set_affinity,
+#endif
+	.irq_print_chip		= crossbar_print_name
+};
+
+static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
+			       irq_hw_number_t hw)
+{
+	irq_set_lockdep_class(irq, &crossbar_lock_class);
+	irq_set_chip_and_handler(irq, &crossbar_chip,
+				 handle_simple_irq);
+
+	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	return 0;
+}
+
+static int crossbar_domain_xlate(struct irq_domain *d,
+				 struct device_node *controller,
+				 const u32 *intspec, unsigned int intsize,
+				 unsigned long *out_hwirq,
+				 unsigned int *out_type)
+{
+	int i, cb_no;
+	u32 *cb_intspec = kzalloc(intsize * sizeof(int), GFP_KERNEL);
+
+	if (!cb_intspec)
+		return -ENOMEM;
+
+	cb_no = intspec[1];
+
+	if (WARN_ON(intsize < 1))
+		return -EINVAL;
+
+	cb->crossbar_map[cb_no].intspec = cb_intspec;
+
+	/*
+	 * Free irq is allocated and mapped during request_irq
+	 * So just save the interrupt properties here
+	 */
+	for (i = 0; i < intsize; i++)
+		cb->crossbar_map[cb_no].intspec[i] = intspec[i];
+
+	cb->crossbar_map[cb_no].intspec_size = intsize;
+	*out_hwirq = intspec[1];
+	*out_type = IRQ_TYPE_NONE;
+
+	return 0;
+}
+
+const struct irq_domain_ops crossbar_domain_ops = {
+	.map = crossbar_domain_map,
+	.xlate = crossbar_domain_xlate
+};
+
+static int __init crossbar_of_init(struct device_node *node,
+				   struct device_node *parent)
+{
+	int i, size, max, reserved = 0;
+	const __be32 *irqsr;
+
+	if (!parent) {
+		pr_err("\n interrupt-parent is missing");
+		return -ENODEV;
+	}
+
+	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
+
+	if (!cb)
+		return -ENOMEM;
+
+	cb->irqp = parent;
+
+	cb->crossbar_base = of_iomap(node, 0);
+	if (!cb->crossbar_base)
+		return -ENOMEM;
+
+	of_property_read_u32(node, "max-crossbar-lines", &max);
+	cb->crossbar_map = kzalloc(max * sizeof(struct pirqs *), GFP_KERNEL);
+
+	if (!cb->crossbar_map)
+		return -ENOMEM;
+
+	cb->domain = irq_domain_add_linear(node, max,
+				       &crossbar_domain_ops, NULL);
+
+	if (!cb->domain) {
+		pr_err("Couldn't register an IRQ domain\n");
+		return -ENODEV;
+	}
+
+	of_property_read_u32(node, "max-irqs", &max);
+	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
+	if (!cb->irq_map)
+		return -ENOMEM;
+
+	cb->int_max = max;
+
+	for (i = 0; i < max; i++)
+		cb->irq_map[i] = IRQ_FREE;
+
+	/* Get and mark reserved irqs */
+	irqsr = of_get_property(node, "irqs-reserved", &size);
+	size /= sizeof(int);
+
+	for (i = 0; i < size; i++)
+		cb->irq_map[be32_to_cpup(irqsr + i)] = 0;
+
+	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
+	if (!cb->register_offsets)
+		return -ENOMEM;
+
+	of_property_read_u32(node, "reg-size", &size);
+
+	/*
+	 * Register offsets are not linear because of the
+	 * reserved irqs. so find and store the offsets once.
+	 */
+	for (i = 0; i < max; i++) {
+		if (!cb->irq_map[i])
+			continue;
+
+		cb->register_offsets[i] = reserved;
+		reserved += size;
+	}
+
+	switch (size) {
+	case 1:
+		cb->write = crossbar_writeb;
+		break;
+	case 2:
+		cb->write = crossbar_writew;
+		break;
+	case 4:
+		cb->write = crossbar_writel;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+IRQCHIP_DECLARE(crossbar, "crossbar-irqchip", crossbar_of_init);
-- 
1.7.9.5

