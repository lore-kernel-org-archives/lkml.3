Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab3K1PTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:19:40 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59842 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab3K1PTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:19:36 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-gpio@vger.kernel.org
Cc: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de, mark.rutland@arm.com,
        devicetree@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v6] gpio: Add MOXA ART GPIO driver
Date: Thu, 28 Nov 2013 16:19:05 +0100
Message-Id: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
References: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for reviewing!
    
    v5 writes to "pincontrol" are not needed, the pins work regardless.
    
    I took notes probing the pins with a multimeter, and I don't know the proper
    place for it, so I'm attaching the text here:
    
    GPIOs on the UC-7112-LX base board can be found at "JP2", this is a 2x10 hole through
    area that comes without header pins. The holes can be used to measure and test GPIOs.
    A header could theoretically be soldered in.
    
    "JP2" is described with the following PCB print:
    
    |PIO1|PIO3|PIO5|PIO7|PIO9|NC|NC|NC|GND|+5V|
    |PIO0|    |PIO4|PIO6|PIO8|NC|NC|NC|GND|+5V|
    
    PIO2 (no text / PIO2) to PIO9 were verified working.
    PIO0, PIO1 could not be verified.
    
    The driver adds support for 32 pins via the register at 0x98700000, the following
    GPIO numbers (corresponding pins on the right) were tested and verified:
    
    05: RTC SCLK
    06: RTC DATA
    07: RTC RESET
    12: (no text / PIO2)
    13: PIO3
    14: PIO4
    15: PIO5
    16: PIO6
    17: PIO7
    18: PIO8
    19: PIO9
    24: HCM1206EN buzzer
    25: reset button
    27: ready LED
    
    GPIOs that can be set from sysfs are:
    1. GPIO 12-19 (measures 0V / 3.3V respectively)
    2. GPIO 24, 27
    
    GPIOs that can be "seen":
    1. GPIO 25
    
    Thanks for telling me about drivers/input/keyboard/gpio_keys_polled.c,
    it works, events are triggered on reset "key" and print to console,
    the relevant DT parts are:
    
    leds {
            compatible = "gpio-leds";
            user-led {
                    label = "ready-led";
                    gpios = <&gpio 27 0x1>;
                    default-state = "on";
                    linux,default-trigger = "default-on";
            };
    };
    
    gpio_keys_polled {
            compatible = "gpio-keys-polled";
            #address-cells = <1>;
            #size-cells = <0>;
            poll-interval = <500>;
            button@25 {
                    label = "GPIO Reset";
                    linux,code = <116>;
                    gpios = <&gpio 25 1>;
            };
    };
    
    Changes since v5:
    
    1. remove pincontrol register
    2. update DT binding and example
    
    Applies to next-20131128

 .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  |  19 +++
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-moxart.c                         | 142 +++++++++++++++++++++
 4 files changed, 169 insertions(+)
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
index 0000000..96ec03c
--- /dev/null
+++ b/drivers/gpio/gpio-moxart.c
@@ -0,0 +1,142 @@
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
+static void __iomem *moxart_gpio_base;
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
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) & ~BIT(offset), ioaddr);
+	return 0;
+}
+
+static int moxart_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_PIN_DIRECTION;
+
+	writel(readl(ioaddr) | BIT(offset), ioaddr);
+	return 0;
+}
+
+static void moxart_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	void __iomem *ioaddr = moxart_gpio_base + GPIO_DATA_OUT;
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
+	u32 ret = readl(moxart_gpio_base + GPIO_PIN_DIRECTION);
+
+	if (ret & BIT(offset))
+		return !!(readl(moxart_gpio_base + GPIO_DATA_OUT) &
+			  BIT(offset));
+	else
+		return !!(readl(moxart_gpio_base + GPIO_DATA_IN) &
+			  BIT(offset));
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
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	moxart_gpio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(moxart_gpio_base)) {
+		dev_err(dev, "%s: devm_ioremap_resource res_gpio failed\n",
+			dev->of_node->full_name);
+		return PTR_ERR(moxart_gpio_base);
+	}
+
+	moxart_gpio_chip.dev = dev;
+
+	ret = gpiochip_add(&moxart_gpio_chip);
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

