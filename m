Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaLNXKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:10:25 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:48492 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaLNXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:10:20 -0500
X-ME-Helo: beldin.home
X-ME-Date: Mon, 15 Dec 2014 00:10:17 +0100
X-ME-IP: 86.199.199.51
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH] mfd: cottula: add cottula board
Date: Mon, 15 Dec 2014 00:10:06 +0100
Message-Id: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cottula board is the IO motherboard of the Intel PXA25x Development
Platform, which supports the Lubbock pxa25x soc board.

Historically, this support was in arch/arm/mach-pxa/lubbock.c. When
gpio-pxa was moved to drivers/pxa, it became a driver, and its
initialization and probing happened at postcore initcall. The lubbock
code used to install the chained lubbock interrupt handler at init_irq()
time.

The consequence of the gpio-pxa change is that the installed chained irq
handler lubbock_irq_handler() was overwritten in pxa_gpio_probe(_dt)(),
removing :
 - the handler
 - the falling edge detection setting of GPIO0, which revealed the
   interrupt request from the lubbock IO board.

As a fix, move the gpio0 chained handler setup to a place where we have
the guarantee that pxa_gpio_probe() was called before, so that lubbock
handler becomes the true IRQ chained handler of GPIO0, demuxing the
lubbock IO board interrupts.

This patch moves all that handling to a mfd driver. It's only purpose
for the time being is the interrupt handling, but in the future it
should encompass all the motherboard CPLDs handling :
 - leds
 - switches
 - hexleds

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mfd/Kconfig   |  10 +++
 drivers/mfd/Makefile  |   1 +
 drivers/mfd/cottula.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
 create mode 100644 drivers/mfd/cottula.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1456ea7..051bd6d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -79,6 +79,16 @@ config MFD_AXP20X
 	  components like regulators or the PEK (Power Enable Key) under the
 	  corresponding menus.
 
+config MFD_COTTULA
+	bool "Cottula Motherboard"
+	def_bool ARCH_LUBBOCK
+	select MFD_CORE
+	help
+	  This driver supports the Cottula multifunction chip found on the
+	  lubbock development platform system (named Cottula). This IO board
+	  supports the interrupts handling, ethernet controller, flash chips,
+	  etc ...
+
 config MFD_CROS_EC
 	tristate "ChromeOS Embedded Controller"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8bd54b1..48cc65b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
+obj-$(CONFIG_MFD_COTTULA)	+= cottula.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
diff --git a/drivers/mfd/cottula.c b/drivers/mfd/cottula.c
new file mode 100644
index 0000000..0345dbd
--- /dev/null
+++ b/drivers/mfd/cottula.c
@@ -0,0 +1,184 @@
+/*
+ * Intel Cotulla MFD - lubbock motherboard
+ *
+ * Copyright (C) 2014 Robert Jarzmik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Cottula motherboard driver, supporting lubbock (aka. pxa25x) soc board.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+
+#define COT_IRQ_MASK_EN 0xc0
+#define COT_IRQ_SET_CLR 0xd0
+
+#define COTTULA_NB_IRQ	8
+
+struct cottula {
+	void __iomem	*base;
+	int irq;
+	unsigned int irq_mask;
+	struct gpio_desc *gpio0;
+	struct irq_domain *irqdomain;
+};
+
+static void cottula_irq_handler(unsigned int in_irq, struct irq_desc *desc)
+{
+	struct cottula *cot = irq_desc_get_handler_data(desc);
+	unsigned long pending;
+	unsigned int bit;
+
+	pending = readl(cot->base + COT_IRQ_SET_CLR) & cot->irq_mask;
+	for_each_set_bit(bit, &pending, COTTULA_NB_IRQ)
+		generic_handle_irq(irq_find_mapping(cot->irqdomain, bit));
+}
+
+static void cottula_irq_mask_ack(struct irq_data *d)
+{
+	struct cottula *cot = irq_data_get_irq_chip_data(d);
+	unsigned int cottula_irq = irqd_to_hwirq(d);
+	unsigned int set, bit = BIT(cottula_irq);
+
+	cot->irq_mask &= ~bit;
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+	set = readl(cot->base + COT_IRQ_SET_CLR);
+	writel(set & ~bit, cot->base + COT_IRQ_SET_CLR);
+}
+
+static void cottula_irq_unmask(struct irq_data *d)
+{
+	struct cottula *cot = irq_data_get_irq_chip_data(d);
+	unsigned int cottula_irq = irqd_to_hwirq(d);
+	unsigned int bit = BIT(cottula_irq);
+
+	cot->irq_mask |= bit;
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+}
+
+static struct irq_chip cottula_irq_chip = {
+	.name		= "cottula",
+	.irq_mask_ack	= cottula_irq_mask_ack,
+	.irq_unmask	= cottula_irq_unmask,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_SKIP_SET_WAKE,
+};
+
+static int cottula_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hwirq)
+{
+	struct cottula *cot = d->host_data;
+
+	irq_set_chip_and_handler(irq, &cottula_irq_chip, handle_level_irq);
+	irq_set_chip_data(irq, cot);
+	return 0;
+}
+
+static const struct irq_domain_ops cottula_irq_domain_ops = {
+	.xlate = irq_domain_xlate_twocell,
+	.map = cottula_irq_domain_map,
+};
+
+static int cottula_resume(struct platform_device *pdev)
+{
+	struct cottula *cot = platform_get_drvdata(pdev);
+
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+	return 0;
+}
+
+static int cottula_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct cottula *cot;
+	int ret;
+	unsigned int base_irq = 0;
+
+	cot = devm_kzalloc(&pdev->dev, sizeof(*cot), GFP_KERNEL);
+	if (!cot)
+		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res)
+		base_irq = (unsigned int)res->start;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	cot->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cot->base))
+		return PTR_ERR(cot->base);
+
+	platform_set_drvdata(pdev, cot);
+	cot->gpio0 = gpiod_get(&pdev->dev, "lubbock_irq", 0);
+	if (IS_ERR(cot->gpio0)) {
+		dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
+		return PTR_ERR(cot->gpio0);
+	}
+	cot->irq = gpiod_to_irq(cot->gpio0);
+	if (cot->irq < 0)
+		return cot->irq;
+
+	cot->irqdomain =
+		irq_domain_add_linear(pdev->dev.of_node, COTTULA_NB_IRQ,
+				      &cottula_irq_domain_ops, cot);
+	if (!cot->irqdomain)
+		return -ENODEV;
+
+	ret = 0;
+	if (base_irq)
+		ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
+						 COTTULA_NB_IRQ);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't create the irq mapping %d..%d\n",
+			base_irq, base_irq + COTTULA_NB_IRQ);
+		return ret;
+	}
+
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+	writel(0, cot->base + COT_IRQ_SET_CLR);
+	irq_set_chained_handler(cot->irq, cottula_irq_handler);
+	irq_set_handler_data(cot->irq, cot);
+	irq_set_irq_type(cot->irq, IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_wake(cot->irq, 1);
+	return 0;
+}
+
+static int cottula_remove(struct platform_device *pdev)
+{
+	struct cottula *cot = platform_get_drvdata(pdev);
+
+	irq_set_chip_and_handler(cot->irq, NULL, NULL);
+	return 0;
+}
+
+static const struct of_device_id cottula_id_table[] = {
+	{ .compatible = "marvell,cottula", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, cottula_id_table);
+
+static struct platform_driver cottula_driver = {
+	.driver		= {
+		.name	= "cottula",
+		.of_match_table = of_match_ptr(cottula_id_table),
+	},
+	.probe		= cottula_probe,
+	.remove		= cottula_remove,
+	.resume		= cottula_resume,
+};
+
+module_platform_driver(cottula_driver);
+
+MODULE_DESCRIPTION("Cottula lubbock driver");
+MODULE_AUTHOR("Robert Jarzmik");
+MODULE_LICENSE("GPL");
-- 
2.1.0

