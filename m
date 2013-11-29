Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3K2LMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:12:07 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:49095 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2LMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:12:03 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-gpio@vger.kernel.org
Cc: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de, mark.rutland@arm.com,
        devicetree@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v7] gpio: Add MOXA ART GPIO driver
Date: Fri, 29 Nov 2013 12:11:34 +0100
Message-Id: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
References: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks Arnd, done in other drivers no reason to not do it here.
    
    Changes since v6:
    
    1. remove global __iomem pointer
    2. add derived data structure "struct moxart_gpio_chip"
    3. use container_of()
    4. add container_of() helper function
    
    Applies to next-20131129

 .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  |  19 +++
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-moxart.c                         | 162 +++++++++++++++++++++
 4 files changed, 189 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
 create mode 100644 drivers/gpio/gpio-moxart.c

diff --git a/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
new file mode 100644
index 0000000..f8e8f18
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
@@ -0,0 +1,19 @@
+MOXA ART GPIO Controller
+
+Required properties:
+
+- #gpio-cells : Should be 2, The first cell is the pin number,
+		the second cell is used to specify polarity:
+			0 = active high
+			1 = active low
+- compatible : Must be "moxa,moxart-gpio"
+- reg : Should contain registers location and length
+
+Example:
+
+	gpio: gpio@98700000 {
+		gpio-controller;
+		#gpio-cells = <2>;
+		compatible = "moxa,moxart-gpio";
+		reg =	<0x98700000 0xC>;
+	};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..e48c523 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -156,6 +156,13 @@ config GPIO_F7188X
 	  To compile this driver as a module, choose M here: the module will
 	  be called f7188x-gpio.
 
+config GPIO_MOXART
+	bool "MOXART GPIO support"
+	depends on ARCH_MOXART
+	help
+	  Select this option to enable GPIO driver for
+	  MOXA ART SoC devices.
+
 config GPIO_MPC5200
 	def_bool y
 	depends on PPC_MPC52xx
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7971e36..ee95154 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_GPIO_MC9S08DZ60)	+= gpio-mc9s08dz60.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
 obj-$(CONFIG_GPIO_MM_LANTIQ)	+= gpio-mm-lantiq.o
+obj-$(CONFIG_GPIO_MOXART)	+= gpio-moxart.o
 obj-$(CONFIG_GPIO_MPC5200)	+= gpio-mpc5200.o
 obj-$(CONFIG_GPIO_MPC8XXX)	+= gpio-mpc8xxx.o
 obj-$(CONFIG_GPIO_MSIC)		+= gpio-msic.o
diff --git a/drivers/gpio/gpio-moxart.c b/drivers/gpio/gpio-moxart.c
new file mode 100644
index 0000000..d662cde
--- /dev/null
+++ b/drivers/gpio/gpio-moxart.c
@@ -0,0 +1,162 @@
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
+#include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/bitops.h>
+
+#define GPIO_DATA_OUT		0x00
+#define GPIO_DATA_IN		0x04
+#define GPIO_PIN_DIRECTION	0x08
+
+struct moxart_gpio_chip {
+	struct gpio_chip gpio;
+	void __iomem *moxart_gpio_base;
+};
+
+static inline struct moxart_gpio_chip *to_moxart_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct moxart_gpio_chip, gpio);
+}
+
+static int moxart_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(offset);
+}
+
+static void moxart_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(offset);
+}
+
+static int moxart_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
+	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) & ~BIT(offset), ioaddr);
+	return 0;
+}
+
+static int moxart_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
+	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) | BIT(offset), ioaddr);
+	return 0;
+}
+
+static void moxart_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
+	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_DATA_OUT;
+	u32 reg = readl(ioaddr);
+
+	if (value)
+		reg = reg | BIT(offset);
+	else
+		reg = reg & ~BIT(offset);
+
+
+	writel(reg, ioaddr);
+}
+
+static int moxart_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
+	u32 ret = readl(gc->moxart_gpio_base + GPIO_PIN_DIRECTION);
+
+	if (ret & BIT(offset))
+		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_OUT) &
+			  BIT(offset));
+	else
+		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_IN) &
+			  BIT(offset));
+}
+
+static struct gpio_chip moxart_template_chip = {
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
+	struct moxart_gpio_chip *mgc;
+	int ret;
+
+	mgc = devm_kzalloc(dev, sizeof(*mgc), GFP_KERNEL);
+	if (!mgc) {
+		dev_err(dev, "can't allocate GPIO chip container\n");
+		return -ENOMEM;
+	}
+	mgc->gpio = moxart_template_chip;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mgc->moxart_gpio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(mgc->moxart_gpio_base)) {
+		dev_err(dev, "%s: devm_ioremap_resource res_gpio failed\n",
+			dev->of_node->full_name);
+		return PTR_ERR(mgc->moxart_gpio_base);
+	}
+
+	mgc->gpio.dev = dev;
+
+	ret = gpiochip_add(&mgc->gpio);
+	if (ret) {
+		dev_err(dev, "%s: gpiochip_add failed\n",
+			dev->of_node->full_name);
+		return ret;
+	}
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
+module_platform_driver(moxart_gpio_driver);
+
+MODULE_DESCRIPTION("MOXART GPIO chip driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
-- 
1.8.2.1

