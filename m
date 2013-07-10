Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3GJNtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:49:46 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:43096 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:49:45 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-gpio@vger.kernel.org
Cc: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] gpio: Add MOXA ART GPIO driver
Date: Wed, 10 Jul 2013 15:49:18 +0200
Message-Id: <1373464158-27881-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703

 drivers/gpio/Kconfig       |   7 ++
 drivers/gpio/Makefile      |   1 +
 drivers/gpio/gpio-moxart.c | 168 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 drivers/gpio/gpio-moxart.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b2450ba..521fd97 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -714,6 +714,13 @@ config GPIO_MSIC
 	  Enable support for GPIO on intel MSIC controllers found in
 	  intel MID devices
 
+config GPIO_MOXART
+	bool "MOXART GPIO support"
+	depends on ARCH_MOXART
+	help
+	  Select this option to enable GPIO driver for
+	  MOXA ART SoC devices.
+
 comment "USB GPIO expanders:"
 
 config GPIO_VIPERBOARD
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index ef3e983..44b0de4 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_GPIO_MC9S08DZ60)	+= gpio-mc9s08dz60.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
 obj-$(CONFIG_GPIO_MM_LANTIQ)	+= gpio-mm-lantiq.o
+obj-$(CONFIG_GPIO_MOXART)	+= gpio-moxart.o
 obj-$(CONFIG_GPIO_MPC5200)	+= gpio-mpc5200.o
 obj-$(CONFIG_GPIO_MPC8XXX)	+= gpio-mpc8xxx.o
 obj-$(CONFIG_GPIO_MSIC)		+= gpio-msic.o
diff --git a/drivers/gpio/gpio-moxart.c b/drivers/gpio/gpio-moxart.c
new file mode 100644
index 0000000..21d26c1
--- /dev/null
+++ b/drivers/gpio/gpio-moxart.c
@@ -0,0 +1,168 @@
+/*
+ * MOXA ART SoCs GPIO driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+
+#define SW_READY_GPIO		(27)
+#define SW_RESET_GPIO		(25)
+
+#define GPIO_DATA_OUT		0x00
+#define GPIO_DATA_IN		0x04
+#define GPIO_PIN_DIRECTION	0x08
+
+static void __iomem *moxart_pincontrol_base;
+static void __iomem *moxart_gpio_base;
+
+void moxart_gpio_enable(u32 gpio)
+{
+	writel(readl(moxart_pincontrol_base) | gpio, moxart_pincontrol_base);
+}
+
+void moxart_gpio_disable(u32 gpio)
+{
+	writel(readl(moxart_pincontrol_base) & ~gpio, moxart_pincontrol_base);
+}
+
+static int moxart_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	moxart_gpio_enable(1 << offset);
+	return pinctrl_request_gpio(offset);
+}
+
+static void moxart_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(offset);
+	moxart_gpio_disable(1 << offset);
+}
+
+static int moxart_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) & ~(1 << offset), ioaddr);
+	return 0;
+}
+
+static int moxart_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) | (1 << offset), ioaddr);
+	return 0;
+}
+
+static void moxart_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_DATA_OUT;
+	u32 reg = readl(ioaddr);
+
+	(value) ?	writel(reg | (1 << offset), ioaddr) :
+			writel(reg & ~(1 << offset), ioaddr);
+}
+
+static int moxart_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	u32 ret = readl(moxart_gpio_base + GPIO_PIN_DIRECTION);
+
+	if (ret & (1 << offset))
+		ret = readl(moxart_gpio_base + GPIO_DATA_OUT) & (1 << offset);
+	else
+		ret = readl(moxart_gpio_base + GPIO_DATA_IN) & (1 << offset);
+
+	return ret;
+}
+
+static struct gpio_chip moxart_gpio_chip = {
+	.label			= "moxart-gpio",
+	.request		= moxart_gpio_request,
+	.free			= moxart_gpio_free,
+	.direction_input	= moxart_gpio_direction_input,
+	.direction_output	= moxart_gpio_direction_output,
+	.set			= moxart_gpio_set,
+	.get			= moxart_gpio_get,
+	.base			= 0,
+	.ngpio			= 32,
+	.can_sleep		= 0,
+};
+
+static int moxart_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	moxart_gpio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(moxart_gpio_base)) {
+		dev_err(dev, "%s: devm_ioremap_resource res_gpio failed\n",
+			dev->of_node->full_name);
+		return PTR_ERR(moxart_gpio_base);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	moxart_pincontrol_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(moxart_pincontrol_base)) {
+		dev_err(dev, "%s: devm_ioremap_resource res_pmu failed\n",
+			dev->of_node->full_name);
+		return PTR_ERR(moxart_pincontrol_base);
+	}
+
+	gpiochip_add(&moxart_gpio_chip);
+
+	moxart_gpio_enable(SW_READY_GPIO | SW_RESET_GPIO);
+
+	moxart_gpio_direction_input(&moxart_gpio_chip, SW_RESET_GPIO);
+
+	/*
+	 * SW_READY_GPIO=0 ready LED on
+	 * SW_READY_GPIO=1 ready LED off
+	 */
+	moxart_gpio_direction_output(&moxart_gpio_chip, SW_READY_GPIO, 0);
+	moxart_gpio_set(&moxart_gpio_chip, SW_READY_GPIO, 0);
+
+	return 0;
+}
+
+static const struct of_device_id moxart_gpio_match[] = {
+	{ .compatible = "moxa,moxart-gpio" },
+	{ }
+};
+
+static struct platform_driver moxart_gpio_driver = {
+	.driver	= {
+		.name		= "moxart-gpio",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_gpio_match,
+	},
+	.probe	= moxart_gpio_probe,
+};
+
+static int __init moxart_gpio_init(void)
+{
+	return platform_driver_register(&moxart_gpio_driver);
+}
+
+postcore_initcall(moxart_gpio_init);
+
+MODULE_DESCRIPTION("MOXART GPIO chip driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
-- 
1.8.2.1

