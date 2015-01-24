Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbbAXPGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:06:22 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:25631 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbAXPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:05:55 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 24 Jan 2015 16:05:54 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v4 2/4] mfd: lubbock_cplds: add lubbock IO board
Date: Sat, 24 Jan 2015 16:05:01 +0100
Message-Id: <1422111903-22176-2-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
References: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lubbock () board is the IO motherboard of the Intel PXA25x Development
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
Since v1: change the name from cottula to lubbock_io
            Dmitry pointed out the Cottula was the pxa25x family name,
	    lubbock was the pxa25x development board name. Therefore the
	    name was changed to lubbock_io (lubbock IO board)
	  change the resources to bi-irq ioresource
	    Discussion between Arnd and Robert to change the gpio
	    request by a irq request.
Since v2: take into account Mark's review
      	    Use irq flags from resources (DT case and pdata case).
	    Change of name from lubbock_io to lubbock-io
Since v3: take into account Lee's review + Russell's advice
            whitespace errors fixes
	    debug/info messages formatting
	    return X; empty lines
---
 drivers/mfd/Kconfig   |  10 +++
 drivers/mfd/Makefile  |   1 +
 drivers/mfd/lubbock.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/mfd/lubbock.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2e6b731..4d8939f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -91,6 +91,16 @@ config MFD_AXP20X
 	  components like regulators or the PEK (Power Enable Key) under the
 	  corresponding menus.
 
+config MFD_LUBBOCK
+	bool "Lubbock Motherboard"
+	def_bool ARCH_LUBBOCK
+	select MFD_CORE
+	help
+	  This driver supports the Lubbock multifunction chip found on the
+	  pxa25x development platform system (named Lubbock). This IO board
+	  supports the interrupts handling, ethernet controller, flash chips,
+	  etc ...
+
 config MFD_CROS_EC
 	tristate "ChromeOS Embedded Controller"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e2..aff1f4f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
+obj-$(CONFIG_MFD_LUBBOCK)	+= lubbock.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
diff --git a/drivers/mfd/lubbock.c b/drivers/mfd/lubbock.c
new file mode 100644
index 0000000..4077fc5
--- /dev/null
+++ b/drivers/mfd/lubbock.c
@@ -0,0 +1,199 @@
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
+ * Lubbock motherboard driver, supporting Lubbock (aka. PXA25X) SoC board.
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
+#define LUBBOCK_NB_IRQ	8
+
+struct lubbock {
+	void __iomem *base;
+	int irq;
+	unsigned int irq_mask;
+	struct gpio_desc *gpio0;
+	struct irq_domain *irqdomain;
+};
+
+static irqreturn_t lubbock_irq_handler(int in_irq, void *d)
+{
+	struct lubbock *cot = d;
+	unsigned long pending;
+	unsigned int bit;
+
+	pending = readl(cot->base + COT_IRQ_SET_CLR) & cot->irq_mask;
+	for_each_set_bit(bit, &pending, LUBBOCK_NB_IRQ)
+		generic_handle_irq(irq_find_mapping(cot->irqdomain, bit));
+
+	return IRQ_HANDLED;
+}
+
+static void lubbock_irq_mask_ack(struct irq_data *d)
+{
+	struct lubbock *cot = irq_data_get_irq_chip_data(d);
+	unsigned int lubbock_irq = irqd_to_hwirq(d);
+	unsigned int set, bit = BIT(lubbock_irq);
+
+	cot->irq_mask &= ~bit;
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+	set = readl(cot->base + COT_IRQ_SET_CLR);
+	writel(set & ~bit, cot->base + COT_IRQ_SET_CLR);
+}
+
+static void lubbock_irq_unmask(struct irq_data *d)
+{
+	struct lubbock *cot = irq_data_get_irq_chip_data(d);
+	unsigned int lubbock_irq = irqd_to_hwirq(d);
+	unsigned int bit = BIT(lubbock_irq);
+
+	cot->irq_mask |= bit;
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+}
+
+static struct irq_chip lubbock_irq_chip = {
+	.name		= "lubbock",
+	.irq_mask_ack	= lubbock_irq_mask_ack,
+	.irq_unmask	= lubbock_irq_unmask,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_SKIP_SET_WAKE,
+};
+
+static int lubbock_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hwirq)
+{
+	struct lubbock *cot = d->host_data;
+
+	irq_set_chip_and_handler(irq, &lubbock_irq_chip, handle_level_irq);
+	irq_set_chip_data(irq, cot);
+
+	return 0;
+}
+
+static const struct irq_domain_ops lubbock_irq_domain_ops = {
+	.xlate = irq_domain_xlate_twocell,
+	.map = lubbock_irq_domain_map,
+};
+
+static int lubbock_resume(struct platform_device *pdev)
+{
+	struct lubbock *cot = platform_get_drvdata(pdev);
+
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+
+	return 0;
+}
+
+static int lubbock_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct lubbock *cot;
+	int ret;
+	unsigned int base_irq = 0;
+	unsigned long irqflags;
+
+	cot = devm_kzalloc(&pdev->dev, sizeof(*cot), GFP_KERNEL);
+	if (!cot)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res) {
+		cot->irq = (unsigned int)res->start;
+		irqflags = res->flags;
+	}
+	if (!cot->irq)
+		return -ENODEV;
+
+	base_irq = platform_get_irq(pdev, 1);
+	if (base_irq < 0)
+		base_irq = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	cot->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cot->base))
+		return PTR_ERR(cot->base);
+
+	platform_set_drvdata(pdev, cot);
+
+	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
+	writel(0, cot->base + COT_IRQ_SET_CLR);
+
+	ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
+			       irqflags, dev_name(&pdev->dev), cot);
+	if (ret == -ENOSYS)
+		return -EPROBE_DEFER;
+
+	if (ret) {
+		dev_err(&pdev->dev, "couldn't request main irq%d: %d\n",
+			cot->irq, ret);
+		return ret;
+	}
+
+	irq_set_irq_wake(cot->irq, 1);
+	cot->irqdomain = irq_domain_add_linear(pdev->dev.of_node,
+					       LUBBOCK_NB_IRQ,
+					       &lubbock_irq_domain_ops, cot);
+	if (!cot->irqdomain)
+		return -ENODEV;
+
+	if (base_irq) {
+		ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
+						 LUBBOCK_NB_IRQ);
+		if (ret) {
+			dev_err(&pdev->dev, "couldn't create the irq mapping %d..%d\n",
+				base_irq, base_irq + LUBBOCK_NB_IRQ);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int lubbock_remove(struct platform_device *pdev)
+{
+	struct lubbock *cot = platform_get_drvdata(pdev);
+
+	irq_set_chip_and_handler(cot->irq, NULL, NULL);
+
+	return 0;
+}
+
+static const struct of_device_id lubbock_id_table[] = {
+	{ .compatible = "intel,lubbock-cplds", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lubbock_id_table);
+
+static struct platform_driver lubbock_driver = {
+	.driver		= {
+		.name	= "lubbock_cplds",
+		.of_match_table = of_match_ptr(lubbock_id_table),
+	},
+	.probe		= lubbock_probe,
+	.remove		= lubbock_remove,
+	.resume		= lubbock_resume,
+};
+
+module_platform_driver(lubbock_driver);
+
+MODULE_DESCRIPTION("Lubbock MFD driver");
+MODULE_AUTHOR("Robert Jarzmik <robert.jarzmik@free.fr>");
+MODULE_LICENSE("GPL");
-- 
2.1.0

