Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3I3OAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:00:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46845 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab3I3OA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:00:26 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <r.sricharan@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>
Subject: [RFC PATCH 2/6] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
Date: Mon, 30 Sep 2013 19:29:20 +0530
Message-ID: <1380549564-31045-3-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
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

This driver takes care a allocating a free irq and then configuring the
crossbar IP as a part of the mpu's irqchip callbacks. crossbar_init should
be called right before the irqchip_init, so that it is setup to handle the
irqchip callbacks.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
 drivers/irqchip/Kconfig                            |    8 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  195 ++++++++++++++++++++
 include/linux/irqchip/irq-crossbar.h               |   11 ++
 5 files changed, 242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
 create mode 100644 drivers/irqchip/irq-crossbar.c
 create mode 100644 include/linux/irqchip/irq-crossbar.h

diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
new file mode 100644
index 0000000..cdec2cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -0,0 +1,27 @@
+Some socs have a large number of interrupts requests to service
+the needs of its many peripherals and subsystems. All of the
+interrupt lines from the subsystems are not needed at the same
+time, so they have to be muxed to the irq-controller appropriately.
+In such places a interrupt controllers are preceded by an CROSSBAR
+that provides flexibility in muxing the device requests to the controller
+inputs.
+
+Required properties:
+- compatible : Should be "ti,irq-crossbar"
+- reg: Base address and the size of the crossbar registers.
+- max-irqs: Total number of irqs available at the interrupt controller.
+- reg-size: Size of a individual register in bytes. Every individual
+	    register is assumed to be of same size. Valid sizes are 1, 2, 4.
+- irqs-reserved: List of the reserved irq lines that are not muxed using
+		 crossbar. These interrupt lines are reserved in the soc,
+		 so crossbar bar driver should not consider them as free
+		 lines.
+
+Examples:
+		crossbar_mpu: @4a020000 {
+			compatible = "ti,irq-crossbar";
+			reg = <0x4a002a48 0x130>;
+			max-irqs = <160>;
+			reg-size = <2>;
+			irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+		};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..ed6ced28 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -41,3 +41,11 @@ config VERSATILE_FPGA_IRQ_NR
        int
        default 4
        depends on VERSATILE_FPGA_IRQ
+
+config IRQ_CROSSBAR
+	bool
+	help
+	  Support for a CROSSBAR ip that preceeds the main interrupt controller.
+	  The primary irqchip invokes the crossbar's callback which inturn allocates
+	  a free irq and configures the IP. Thus the peripheral interrupts are
+	  routed to one of the free irqchip interrupt lines.
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..7f690b7 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
+obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
new file mode 100644
index 0000000..3e1b488
--- /dev/null
+++ b/drivers/irqchip/irq-crossbar.c
@@ -0,0 +1,195 @@
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
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/slab.h>
+#include <linux/irqchip/arm-gic.h>
+
+#define IRQ_FREE	-1
+#define GIC_IRQ_START	32
+
+/*
+ * @int_max: maximum number of supported interrupts
+ * @irq_map: array of interrupts to crossbar number mapping
+ * @crossbar_base: crossbar base address
+ * @register_offsets: offsets for each irq number
+ */
+struct crossbar_device {
+	uint int_max;
+	uint *irq_map;
+	void __iomem *crossbar_base;
+	int *register_offsets;
+	void (*write) (int, int);
+};
+
+static struct crossbar_device *cb;
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
+static inline const u32 allocate_free_irq(int cb_no)
+{
+	int i;
+
+	for (i = 0; i < cb->int_max; i++) {
+		if (cb->irq_map[i] == IRQ_FREE) {
+			cb->irq_map[i] = cb_no;
+			return i;
+		}
+	}
+
+	return -ENODEV;
+}
+
+static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
+			       irq_hw_number_t hw)
+{
+	cb->write(hw - GIC_IRQ_START, cb->irq_map[hw - GIC_IRQ_START]);
+	return 0;
+}
+
+static void crossbar_domain_unmap(struct irq_domain *d, unsigned int irq)
+{
+	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq - GIC_IRQ_START;
+	cb->irq_map[hw] = IRQ_FREE;
+}
+
+static int crossbar_domain_xlate(struct irq_domain *d,
+				 struct device_node *controller,
+				 const u32 *intspec, unsigned int intsize,
+				 unsigned long *out_hwirq,
+				 unsigned int *out_type)
+{
+	return allocate_free_irq(intspec[1]) + GIC_IRQ_START;
+}
+
+const struct irq_domain_ops routable_irq_domain_ops = {
+	.map = crossbar_domain_map,
+	.unmap = crossbar_domain_unmap,
+	.xlate = crossbar_domain_xlate
+};
+
+static int __init crossbar_of_init(struct device_node *node)
+{
+	int i, size, max, reserved = 0, entry;
+	const __be32 *irqsr;
+
+	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
+
+	if (!cb)
+		return -ENOMEM;
+
+	cb->crossbar_base = of_iomap(node, 0);
+	if (!cb->crossbar_base)
+		goto err1;
+
+	of_property_read_u32(node, "max-irqs", &max);
+	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
+	if (!cb->irq_map)
+		goto err2;
+
+	cb->int_max = max;
+
+	for (i = 0; i < max; i++)
+		cb->irq_map[i] = IRQ_FREE;
+
+	/* Get and mark reserved irqs */
+	irqsr = of_get_property(node, "irqs-reserved", &size);
+	if (irqsr) {
+		size /= sizeof(__be32);
+
+		for (i = 0; i < size; i++) {
+			entry = be32_to_cpup(irqsr + i);
+			if (entry > max) {
+				pr_err("Invalid reserved entry\n");
+				goto err3;
+			}
+			cb->irq_map[entry] = 0;
+		}
+	}
+
+	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
+	if (!cb->register_offsets)
+		goto err3;
+
+	of_property_read_u32(node, "reg-size", &size);
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
+		pr_err("Invalid reg-size property\n");
+		goto err4;
+		break;
+	}
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
+	register_routable_domain_ops(&routable_irq_domain_ops);
+	return 0;
+
+err4:
+	kfree(cb->register_offsets);
+err3:
+	kfree(cb->irq_map);
+err2:
+	iounmap(cb->crossbar_base);
+err1:
+	kfree(cb);
+	return -ENOMEM;
+}
+
+static const struct of_device_id crossbar_match[] __initconst = {
+	{ .compatible = "ti,irq-crossbar" },
+	{}
+};
+
+int crossbar_init(void)
+{
+	struct device_node *np;
+	np = of_find_matching_node(NULL, crossbar_match);
+	if (!np)
+		return -ENODEV;
+
+	crossbar_of_init(np);
+	return 0;
+}
diff --git a/include/linux/irqchip/irq-crossbar.h b/include/linux/irqchip/irq-crossbar.h
new file mode 100644
index 0000000..ad2f744
--- /dev/null
+++ b/include/linux/irqchip/irq-crossbar.h
@@ -0,0 +1,11 @@
+/*
+ *  drivers/irqchip/irq-crossbar.h
+ *
+ *  Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+int crossbar_init(void);
-- 
1.7.9.5

