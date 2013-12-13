Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3LMC3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:29:54 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:39145 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LMC3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:29:48 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v2 09/16] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
Date: Fri, 13 Dec 2013 06:27:18 +0400
Message-Id: <1386901645-28895-10-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS LP-8x4x contains FPGA chip. The chip functions as a interrupt
source providing 16 additional interrupts among other things. The
interrupt lines are muxed to a GPIO pin. GPIO pins are in turn muxed
to a CPU interrupt line.

Until pxa is completely converted to device tree, it is impossible
to use IRQCHIP_DECLARE() and the irqdomain needs to added manually.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>
---
   v0..v2
   * extract irqchip and move to drivers/irqchip/
   * use device tree
   * use devm helpers where possible

 .../bindings/interrupt-controller/irq-lp8x4x.txt   |  49 +++++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  10 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-lp8x4x.c                       | 205 +++++++++++++++++++++
 5 files changed, 270 insertions(+)
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
index b7f8cfc..2704760 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -119,5 +119,15 @@
 			reg = <0x1700901c 0x1>;
 			status = "okay";
 		};
+
+		fpga: fpga@17009006 {
+			compatible = "icpdas,irq-lp8x4x";
+			reg = <0x17009006 0x16>;
+			interrupt-parent = <&gpio>;
+			interrupts = <3 IRQ_TYPE_EDGE_BOTH>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
+			status = "okay";
+		};
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
index 0000000..5d44880b
--- /dev/null
+++ b/drivers/irqchip/irq-lp8x4x.c
@@ -0,0 +1,205 @@
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
+#define SECOINT			0x00000008
+#define ENRISEINT		0x0000000A
+#define CLRRISEINT		0x0000000C
+#define ENHILVINT		0x0000000E
+#define CLRHILVINT		0x00000010
+#define ENFALLINT		0x00000012
+#define CLRFALLINT		0x00000014
+#define LP8X4X_IRQ_MEM_SIZE	0x00000016
+
+static unsigned char irq_sys_enabled;
+static unsigned char irq_high_enabled;
+static void *base;
+static int irq_base;
+static int num_irq = 16;
+
+static void lp8x4x_mask_irq(struct irq_data *d)
+{
+	unsigned mask;
+	int irq = d->irq - irq_base;
+
+	if (irq < 0 || irq > 15) {
+		pr_err("lp8x4x: wrong irq handler for irq %i\n", d->irq);
+		return;
+	}
+
+	if (irq < 8) {
+		irq_high_enabled &= ~(1 << irq);
+
+		mask = ioread8(base + ENHILVINT);
+		mask &= ~(1 << irq);
+		iowrite8(mask, base + ENHILVINT);
+	} else {
+		irq -= 8;
+		irq_sys_enabled &= ~(1 << irq);
+
+		mask = ioread8(base + ENSYSINT);
+		mask &= ~(1 << irq);
+		iowrite8(mask, base + ENSYSINT);
+	}
+}
+
+static void lp8x4x_unmask_irq(struct irq_data *d)
+{
+	unsigned mask;
+	int irq = d->irq - irq_base;
+
+	if (irq < 0 || irq > 15) {
+		pr_err("wrong irq handler for irq %i\n", d->irq);
+		return;
+	}
+
+	if (irq < 8) {
+		irq_high_enabled |= 1 << irq;
+		mask = ioread8(base + CLRHILVINT);
+		mask |= 1 << irq;
+		iowrite8(mask, base + CLRHILVINT);
+
+		mask = ioread8(base + ENHILVINT);
+		mask |= 1 << irq;
+		iowrite8(mask, base + ENHILVINT);
+	} else {
+		irq -= 8;
+		irq_sys_enabled |= 1 << irq;
+
+		mask = ioread8(base + SECOINT);
+		mask |= 1 << irq;
+		iowrite8(mask, base + SECOINT);
+
+		mask = ioread8(base + ENSYSINT);
+		mask |= 1 << irq;
+		iowrite8(mask, base + ENSYSINT);
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
+	int loop, n;
+	unsigned long mask;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	chained_irq_enter(chip, desc);
+
+	do {
+		loop = 0;
+		mask = ioread8(base + CLRHILVINT) & 0xff;
+		mask |= (ioread8(base + SECOINT) & 0x1f) << 8;
+		mask |= (ioread8(base + PRIMINT) & 0xe0) << 8;
+		mask &= (irq_high_enabled | (irq_sys_enabled << 8));
+		for_each_set_bit(n, &mask, BITS_PER_LONG) {
+			loop = 1;
+
+			generic_handle_irq(irq_base + n);
+		}
+	} while (loop);
+
+	iowrite8(0, base + EOI);
+	chained_irq_exit(chip, desc);
+}
+
+static int lp8x4x_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				 irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(irq, &lp8x4x_irq_chip,
+				 handle_level_irq);
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
+	struct resource *rm, *ri;
+	struct device_node *np = pdev->dev.of_node;
+	struct irq_domain *domain;
+
+	rm = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ri = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!rm || !ri || resource_size(rm) < LP8X4X_IRQ_MEM_SIZE)
+		return -ENODEV;
+
+	base = devm_ioremap_resource(&pdev->dev, rm);
+	if (!base) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n", base);
+		return -EFAULT;
+	}
+
+	irq_base = irq_alloc_descs(-1, 0, num_irq, 0);
+	if (irq_base < 0) {
+		dev_err(&pdev->dev, "Failed to allocate IRQ numbers\n");
+		return irq_base;
+	}
+
+	domain = irq_domain_add_legacy(np, num_irq, irq_base, 0,
+				       &lp8x4x_irq_domain_ops, NULL);
+	if (!domain) {
+		dev_err(&pdev->dev, "Failed to add IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	iowrite8(0, base + CLRRISEINT);
+	iowrite8(0, base + ENRISEINT);
+	iowrite8(0, base + CLRFALLINT);
+	iowrite8(0, base + ENFALLINT);
+	iowrite8(0, base + CLRHILVINT);
+	iowrite8(0, base + ENHILVINT);
+	iowrite8(0, base + ENSYSINT);
+	iowrite8(0, base + SECOINT);
+
+	irq_set_chained_handler(ri->start, lp8x4x_irq_handler);
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
1.8.4.3

