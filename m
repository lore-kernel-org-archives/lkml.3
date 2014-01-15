Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaAONNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:13:04 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40176 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAONNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:13:00 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sergei Ianovich <ynvich@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v3.2 11/21] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
Date: Wed, 15 Jan 2014 17:12:34 +0400
Message-Id: <1389791557-23471-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389308855-32588-1-git-send-email-ynvich@gmail.com>
References: <1389308855-32588-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS LP-8x4x contains FPGA chip. The chip functions as an interrupt
source providing 16 additional interrupts among other things. The
interrupt lines are muxed to a GPIO pin of a 2nd level PXA-GPIO
interrupt controller. GPIO pins of the 2nd level controller are in turn
muxed to a CPU interrupt line.

Until pxa is completely converted to device tree, it is impossible
to use IRQCHIP_DECLARE() and the irqdomain needs to added manually.
Drivers for the on-CPU IRQs and GPIO-IRQs are loaded using
postcore_initcall(). We need to have all irq domain drivers loaded prior
to DT parsing in order to allow normal initialization of IRQ resources
with DT.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v3.1..v3.2
   fixes to apply Linus Walleij's "Reviewed-by":
   * add kerneldoc comment for state container struct
   * rename irq -> hwirq for clarity
   * drop overzealous error checks from the hotpaths

   v3..v3.1
   fixes according to Linus Walleij review comments:
   * update commit message
   * use state container instead of global variables
   * get hardware irq nums from irq_data, don't calculate them
   * use BIT() macro
   * add defines for system irq register masks
   * replace cycle control variable with break
   * use better names for resource variables
   * add a linear domain instead of a legacy one
   * use irq_create_mapping() instead of irq_alloc_desc()

   v2..v3
   * no changes (except number 09/16 -> 11/21)

   v0..v2
   * extract irqchip and move to drivers/irqchip/
   * use device tree
   * use devm helpers where possible

 .../bindings/interrupt-controller/irq-lp8x4x.txt   |  49 +++++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  10 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-lp8x4x.c                       | 227 +++++++++++++++++++++
 5 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/irq-lp8x4x.txt
 create mode 100644 drivers/irqchip/irq-lp8x4x.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/irq-lp8x4x.txt b/Documentation/devicetree/bindings/interrupt-controller/irq-lp8x4x.txt
new file mode 100644
index 0000000..c8940d2
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/irq-lp8x4x.txt
@@ -0,0 +1,49 @@
+ICP DAS LP-8x4x FPGA Interrupt Controller
+
+ICP DAS LP-8x4x contains FPGA chip. The chip functions as a interrupt
+source providing 16 additional interrupts among other things.
+
+Required properties:
+- compatible : should be "icpdas,irq-lp8x4x"
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- interrupt-controller : identifies the node as an interrupt controller
+
+- #interrupt-cells : should be 1
+
+- interrupts : should provide interrupt
+
+- interrupt-parent : should provide a link to interrupt controller either
+		     explicitly and implicitly from a parent node
+
+Example:
+
+	fpga: fpga@17000006 {
+		compatible = "icpdas,irq-lp8x4x";
+		reg = <0x17000006 0x16>;
+		interrupt-parent = <&gpio>;
+		interrupts = <3 IRQ_TYPE_EDGE_RISING>;
+		#interrupt-cells = <1>;
+		interrupt-controller;
+		status = "okay";
+	};
+
+	uart@17009050 {
+		compatible = "icpdas,uart-lp8x4x";
+		reg = <0x17009050 0x10
+		       0x17009030 0x02>;
+		interrupt-parent = <&fpga>;
+		interrupts = <13>;
+		status = "okay";
+	};
+
+	uart@17009060 {
+		compatible = "icpdas,uart-lp8x4x";
+		reg = <0x17009060 0x10
+		       0x17009032 0x02>;
+		interrupt-parent = <&fpga>;
+		interrupts = <14>;
+		status = "okay";
+	};
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index 07856e0..78dfd2e 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -167,6 +167,16 @@
 				reg = <0xa000 0x1000
 				       0x901e 0x1>;
 			};
+
+			fpgairq: irq@9006 {
+				compatible = "icpdas,irq-lp8x4x";
+				reg = <0x9006 0x16>;
+				interrupt-parent = <&gpio>;
+				interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+				#interrupt-cells = <1>;
+				interrupt-controller;
+				status = "okay";
+			};
 		};
 	};
 };
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 3792a1a..7e22729 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -35,6 +35,11 @@ config IMGPDC_IRQ
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
+config LP8X4X_IRQ
+	bool
+	depends on OF
+	select IRQ_DOMAIN
+
 config ORION_IRQCHIP
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index c60b901..8a28927 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
 obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
+obj-$(CONFIG_LP8X4X_IRQ)		+= irq-lp8x4x.o
diff --git a/drivers/irqchip/irq-lp8x4x.c b/drivers/irqchip/irq-lp8x4x.c
new file mode 100644
index 0000000..12ccbb03
--- /dev/null
+++ b/drivers/irqchip/irq-lp8x4x.c
@@ -0,0 +1,227 @@
+/*
+ *  linux/drivers/irqchip/irq-lp8x4x.c
+ *
+ *  Support for ICP DAS LP-8x4x FPGA irq
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation or any later version.
+ */
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#define EOI			0x00000000
+#define INSINT			0x00000002
+#define ENSYSINT		0x00000004
+#define PRIMINT			0x00000006
+#define PRIMINT_MASK		0xe0
+#define SECOINT			0x00000008
+#define SECOINT_MASK		0x1f
+#define ENRISEINT		0x0000000A
+#define CLRRISEINT		0x0000000C
+#define ENHILVINT		0x0000000E
+#define CLRHILVINT		0x00000010
+#define ENFALLINT		0x00000012
+#define CLRFALLINT		0x00000014
+#define IRQ_MEM_SIZE		0x00000016
+#define LP8X4X_NUM_IRQ_DEFAULT	16
+
+/**
+ * struct lp8x4x_irq_data - LP8X4X custom irq controller state container
+ * @base:               base IO memory address
+ * @irq_domain:         Interrupt translation domain; responsible for mapping
+ *                      between hwirq number and linux irq number
+ * @irq_sys_enabled:    mask keeping track of interrupts enabled in the
+ *                      register which vendor calls 'system'
+ * @irq_high_enabled:   mask keeping track of interrupts enabled in the
+ *                      register which vendor calls 'high'
+ *
+ * The structure implements State Container from
+ * Documentation/driver-model/design-patterns.txt
+ */
+
+struct lp8x4x_irq_data {
+	void			*base;
+	struct irq_domain	*domain;
+	unsigned char		irq_sys_enabled;
+	unsigned char		irq_high_enabled;
+};
+
+static void lp8x4x_mask_irq(struct irq_data *d)
+{
+	unsigned mask;
+	unsigned long hwirq = d->hwirq;
+	struct lp8x4x_irq_data *host = irq_data_get_irq_chip_data(d);
+
+	if (hwirq < 8) {
+		host->irq_high_enabled &= ~BIT(hwirq);
+
+		mask = ioread8(host->base + ENHILVINT);
+		mask &= ~BIT(hwirq);
+		iowrite8(mask, host->base + ENHILVINT);
+	} else {
+		hwirq -= 8;
+		host->irq_sys_enabled &= ~BIT(hwirq);
+
+		mask = ioread8(host->base + ENSYSINT);
+		mask &= ~BIT(hwirq);
+		iowrite8(mask, host->base + ENSYSINT);
+	}
+}
+
+static void lp8x4x_unmask_irq(struct irq_data *d)
+{
+	unsigned mask;
+	unsigned long hwirq = d->hwirq;
+	struct lp8x4x_irq_data *host = irq_data_get_irq_chip_data(d);
+
+	if (hwirq < 8) {
+		host->irq_high_enabled |= BIT(hwirq);
+		mask = ioread8(host->base + CLRHILVINT);
+		mask |= BIT(hwirq);
+		iowrite8(mask, host->base + CLRHILVINT);
+
+		mask = ioread8(host->base + ENHILVINT);
+		mask |= BIT(hwirq);
+		iowrite8(mask, host->base + ENHILVINT);
+	} else {
+		hwirq -= 8;
+		host->irq_sys_enabled |= BIT(hwirq);
+
+		mask = ioread8(host->base + SECOINT);
+		mask |= BIT(hwirq);
+		iowrite8(mask, host->base + SECOINT);
+
+		mask = ioread8(host->base + ENSYSINT);
+		mask |= BIT(hwirq);
+		iowrite8(mask, host->base + ENSYSINT);
+	}
+}
+
+static struct irq_chip lp8x4x_irq_chip = {
+	.name			= "FPGA",
+	.irq_ack		= lp8x4x_mask_irq,
+	.irq_mask		= lp8x4x_mask_irq,
+	.irq_mask_ack		= lp8x4x_mask_irq,
+	.irq_unmask		= lp8x4x_unmask_irq,
+};
+
+static void lp8x4x_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int n;
+	unsigned long mask;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct lp8x4x_irq_data *host = irq_desc_get_handler_data(desc);
+
+	chained_irq_enter(chip, desc);
+
+	for (;;) {
+		mask = ioread8(host->base + CLRHILVINT) & 0xff;
+		mask |= (ioread8(host->base + SECOINT) & SECOINT_MASK) << 8;
+		mask |= (ioread8(host->base + PRIMINT) & PRIMINT_MASK) << 8;
+		mask &= host->irq_high_enabled | (host->irq_sys_enabled << 8);
+		if (mask == 0)
+			break;
+		for_each_set_bit(n, &mask, BITS_PER_LONG)
+			generic_handle_irq(irq_find_mapping(host->domain, n));
+	}
+
+	iowrite8(0, host->base + EOI);
+	chained_irq_exit(chip, desc);
+}
+
+static int lp8x4x_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				 irq_hw_number_t hw)
+{
+	struct lp8x4x_irq_data *host = d->host_data;
+	int err;
+
+	err = irq_set_chip_data(irq, host);
+	if (err < 0)
+		return err;
+
+	irq_set_chip_and_handler(irq, &lp8x4x_irq_chip, handle_level_irq);
+	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	return 0;
+}
+
+const struct irq_domain_ops lp8x4x_irq_domain_ops = {
+	.map	= lp8x4x_irq_domain_map,
+	.xlate	= irq_domain_xlate_onecell,
+};
+
+static struct of_device_id lp8x4x_irq_dt_ids[] = {
+	{ .compatible = "icpdas,irq-lp8x4x", },
+	{}
+};
+
+static int lp8x4x_irq_probe(struct platform_device *pdev)
+{
+	struct resource *res_mem, *res_irq;
+	struct device_node *np = pdev->dev.of_node;
+	struct lp8x4x_irq_data *host;
+	int i, err;
+
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_mem || !res_irq || resource_size(res_mem) < IRQ_MEM_SIZE)
+		return -ENODEV;
+
+	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENODEV;
+
+	host->base = devm_ioremap_resource(&pdev->dev, res_mem);
+	if (!host->base) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n", host->base);
+		return -EFAULT;
+	}
+
+	host->domain = irq_domain_add_linear(np, LP8X4X_NUM_IRQ_DEFAULT,
+				       &lp8x4x_irq_domain_ops, host);
+	if (!host->domain) {
+		dev_err(&pdev->dev, "Failed to add IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < LP8X4X_NUM_IRQ_DEFAULT; i++) {
+		err = irq_create_mapping(host->domain, i);
+		if (err < 0)
+			dev_err(&pdev->dev, "Failed to map IRQ %i\n", i);
+	}
+
+	/* Initialize chip registers */
+	iowrite8(0, host->base + CLRRISEINT);
+	iowrite8(0, host->base + ENRISEINT);
+	iowrite8(0, host->base + CLRFALLINT);
+	iowrite8(0, host->base + ENFALLINT);
+	iowrite8(0, host->base + CLRHILVINT);
+	iowrite8(0, host->base + ENHILVINT);
+	iowrite8(0, host->base + ENSYSINT);
+	iowrite8(0, host->base + SECOINT);
+
+	irq_set_handler_data(res_irq->start, host);
+	irq_set_chained_handler(res_irq->start, lp8x4x_irq_handler);
+
+	return 0;
+}
+
+static struct platform_driver lp8x4x_irq_driver = {
+	.probe		= lp8x4x_irq_probe,
+	.driver		= {
+		.name	= "irq-lp8x4x",
+		.of_match_table = lp8x4x_irq_dt_ids,
+	},
+};
+
+static int __init lp8x4x_irq_init(void)
+{
+	return platform_driver_register(&lp8x4x_irq_driver);
+}
+postcore_initcall(lp8x4x_irq_init);
-- 
1.8.4.2

