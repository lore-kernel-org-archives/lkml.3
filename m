Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3JKOxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:53:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64278 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3JKOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:53:37 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-gpio@vger.kernel.org
Cc: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de, mark.rutland@arm.com,
        devicetree@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5] gpio: Add MOXA ART GPIO driver
Date: Fri, 11 Oct 2013 16:53:10 +0200
Message-Id: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
References: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for the replies,
    
    I agree it is a bit strange GPIO control is divided in two
    separate registers. Unfortunately I can't offer an explanation
    because the documentation is not publicly available.
    
    The register responsible for doing enable/disable is located
    at <0x98100100 0x4>, the clock register is very close at
    <0x98100000 0x34>.
    
    I don't think gpio_poweroff driver is right for this hardware
    because the pin is not connected to anything that can do reset.
    The old 2.6.9 kernel driver uses timer poll with eventual call
    to userspace.
    
    To test that it works, I added gpio_poweroff anyway, modified
    with gpio_export() the pin can then be seen switching between
    0 and 1 (on "cat /sys/class/gpio/gpio25/value").
    
    The DT file I use on UC-7112-LX:
    
    clk_pll: pll@98100000 {
    	compatible = "moxa,moxart-pll-clock";
    	#clock-cells = <0>;
    	reg = <0x98100000 0x34>;
    	clocks = <&ref12>;
    };
    
    clk_apb: clk_apb@98100000 {
    	compatible = "moxa,moxart-apb-clock";
    	#clock-cells = <0>;
    	reg = <0x98100000 0x34>;
    	clocks = <&clk_pll>;
    };
    
    gpio: gpio@98700000 {
    	gpio-controller;
    	#gpio-cells = <2>;
    	compatible = "moxa,moxart-gpio";
    	reg =   <0x98700000 0xC>,
    		    <0x98100100 0x4>;
    };
    
    leds {
    	compatible = "gpio-leds";
    	user-led {
    		label = "ready-led";
    		gpios = <&gpio 27 0x1>;
    		default-state = "on";
    		linux,default-trigger = "default-on";
    	};
    };
    
    gpio_poweroff {
    	compatible = "gpio-poweroff";
    	pinctrl-names = "default";
    	input = <1>;
    	gpios = <&gpio 25 0x0>;
    };
    
    Changes since v4:
    
    1. elaborate DT binding #gpio-cells description
    2. remove ready-led / reset-switch from driver and binding
    3. use BIT() macro
    4. remove ternary operator in moxart_gpio_set()
    5. use !!(condition) construct in moxart_gpio_get()
    6. replace postcore_initcall() with module_platform_driver()
    7. return gpiochip_add() return value on failure
    
    Applies to next-20130927

 .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  |  22 +++
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-moxart.c                         | 163 +++++++++++++++++++++
 4 files changed, 193 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
 create mode 100644 drivers/gpio/gpio-moxart.c

diff --git a/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
new file mode 100644
index 0000000..5039e17
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
@@ -0,0 +1,22 @@
+MOXA ART GPIO Controller
+
+Required properties:
+
+- #gpio-cells : Should be 2, The first cell is the pin number and
+		the second cell is used to specify polarity:
+			0 = active high
+			1 = active low
+- compatible : Must be "moxa,moxart-gpio"
+- reg : Should contain registers location and length
+	index 0 : input, output, and direction control
+	index 1 : enable/disable individual pins, pin 0-31
+
+Example:
+
+	gpio: gpio@98700000 {
+		gpio-controller;
+		#gpio-cells = <2>;
+		compatible = "moxa,moxart-gpio";
+		reg =	<0x98700000 0xC>,
+			<0x98100100 0x4>;
+	};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index c8b02a5..c5a2767 100644
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
index 5c353df..a26029d 100644
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
index 0000000..5796846
--- /dev/null
+++ b/drivers/gpio/gpio-moxart.c
@@ -0,0 +1,163 @@
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
+	moxart_gpio_enable(BIT(offset));
+	return pinctrl_request_gpio(offset);
+}
+
+static void moxart_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(offset);
+	moxart_gpio_disable(BIT(offset));
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
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	moxart_pincontrol_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(moxart_pincontrol_base)) {
+		dev_err(dev, "%s: devm_ioremap_resource res_pmu failed\n",
+			dev->of_node->full_name);
+		return PTR_ERR(moxart_pincontrol_base);
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

