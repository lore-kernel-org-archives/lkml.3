Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaBXTBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:01:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:53884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBXTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:01:19 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 14:01:19 EST
From: Fabian Vogt <fabian@ritter-vogt.de>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@linaro.org, pawel.moll@arm.com, rob@landley.net,
        Fabian Vogt <fabian@ritter-vogt.de>
Subject: [PATCH V6] gpio: New driver for LSI ZEVIO SoCs
Date: Mon, 24 Feb 2014 20:54:58 +0100
Message-Id: <1393271698-15829-1-git-send-email-fabian@ritter-vogt.de>
X-Mailer: git-send-email 1.8.1.4
X-Provags-ID: V02:K0:BQWG2qLF5c1RUTb3DNki+y6Yjlud/6uEudcbGi2K/EI
 5iAOdXj42PSjdPyOWcuf1+TGPr+a5XUmvnhVTCTes1RzZS7ps6
 GUSuAM2FkKIjLbh3n2wFTu7+LR8zqkjNI7k036sIuCuAVD5NcW
 XSdJvvux227gY1GdnXDv2quZvKq23/RziDmIE6kEIUzfWzQAIj
 I6MoKBRLq72AQAr8JMbkKES7CtRyFXpoJk4OaYue6q/5QQhf+H
 LB3B3LkaRO5nXZIHgwtDV1VJLmQhPWDnrSaZLaAwsG1BTNYzO8
 d0rcHvNc3xne+8ZH4pPoZ40VXXHvY3UqZaGc+XK2j+BIJEauXk
 w87xivsWNyQLjPGxQnh63b8NkEyOJ6Oc5IpUItu0NUJjX6BMkS
 LKDaarNK5Fo7UQOLVkPDPecR/jTCexHfqc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the GPIO controller found in LSI ZEVIO SoCs.
It has been successfully tested on a TI nspire CX calculator.

Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>

---
It took a while for me to make this patch.
School, other projects and some bugs which prevented testing
were time consuming.
This patch should resolve all issues, hopefully.

Changes to V5:
 -Rewrote documentation
 -Doesn't kfree devm_kzalloc'd memory
 -Fixed multiline comments
 -Got rid of unnecessary braces
 -Converted two too complex macros to static inline functions

 .../devicetree/bindings/gpio/gpio-zevio.txt        |  17 ++
 drivers/gpio/Kconfig                               |   6 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-zevio.c                          | 221 +++++++++++++++++++++
 4 files changed, 245 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.txt
 create mode 100644 drivers/gpio/gpio-zevio.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
new file mode 100644
index 0000000..17bd9c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
@@ -0,0 +1,17 @@
+Zevio GPIO controller
+
+Required properties:
+- compatible: Should be "lsi,zevio-gpio"
+- reg: Address and length of the register set for the device
+- #gpio-cells: Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+- gpio-controller: Marks the device node as a GPIO controller.
+
+Example:
+	gpio: gpio@90000000 {
+		compatible = "lsi,zevio-gpio";
+		reg = <0x90000000 0x1000>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 903f24d..c69b9e3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -145,6 +145,12 @@ config GPIO_EP93XX
 	depends on ARCH_EP93XX
 	select GPIO_GENERIC
 
+config GPIO_ZEVIO
+	bool "LSI ZEVIO SoC memory mapped GPIOs"
+	depends on OF
+	help
+	  Say yes here to support the GPIO controller in LSI ZEVIO SoCs.
+
 config GPIO_MM_LANTIQ
 	bool "Lantiq Memory mapped GPIOs"
 	depends on LANTIQ && SOC_XWAY
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d50179..b845375 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -99,3 +99,4 @@ obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
 obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
 obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
 obj-$(CONFIG_GPIO_XTENSA)	+= gpio-xtensa.o
+obj-$(CONFIG_GPIO_ZEVIO)	+= gpio-zevio.o
diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
new file mode 100644
index 0000000..9354c8e
--- /dev/null
+++ b/drivers/gpio/gpio-zevio.c
@@ -0,0 +1,221 @@
+/*
+ * GPIO controller in LSI ZEVIO SoCs.
+ *
+ * Author: Fabian Vogt <fabian@ritter-vogt.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+
+/*
+ * Memory layout:
+ * This chip has four gpio sections, each controls 8 GPIOs.
+ * Bit 0 in section 0 is GPIO 0, bit 2 in section 1 is GPIO 10.
+ * Disclaimer: Reverse engineered!
+ * For more information refer to:
+ * http://hackspire.unsads.com/wiki/index.php/Memory-mapped_I/O_ports#90000000_-_General_Purpose_I.2FO_.28GPIO.29
+ *
+ * 0x00-0x3F: Section 0
+ *     +0x00: Masked interrupt status (read-only)
+ *     +0x04: R: Interrupt status W: Reset interrupt status
+ *     +0x08: R: Interrupt mask W: Mask interrupt
+ *     +0x0C: W: Unmask interrupt (write-only)
+ *     +0x10: Direction: I/O=1/0
+ *     +0x14: Output
+ *     +0x18: Input (read-only)
+ *     +0x20: R: Level interrupt W: Set as level interrupt
+ * 0x40-0x7F: Section 1
+ * 0x80-0xBF: Section 2
+ * 0xC0-0xFF: Section 3
+ */
+
+#define ZEVIO_GPIO_SECTION_SIZE			0x40
+
+/* Offsets to various registers */
+#define ZEVIO_GPIO_INT_MASKED_STATUS	0x00
+#define ZEVIO_GPIO_INT_STATUS		0x04
+#define ZEVIO_GPIO_INT_UNMASK		0x08
+#define ZEVIO_GPIO_INT_MASK		0x0C
+#define ZEVIO_GPIO_DIRECTION		0x10
+#define ZEVIO_GPIO_OUTPUT		0x14
+#define ZEVIO_GPIO_INPUT			0x18
+#define ZEVIO_GPIO_INT_STICKY		0x20
+
+#define to_zevio_gpio(chip) container_of(to_of_mm_gpio_chip(chip), \
+				struct zevio_gpio, chip)
+
+/* Bit number of GPIO in its section */
+#define ZEVIO_GPIO_BIT(gpio) (gpio&7)
+
+struct zevio_gpio {
+	spinlock_t		lock;
+	struct of_mm_gpio_chip	chip;
+};
+
+static inline u32 zevio_gpio_port_get(struct zevio_gpio *c, unsigned pin,
+					unsigned port_offset)
+{
+	unsigned section_offset = ((pin >> 3) & 3)*ZEVIO_GPIO_SECTION_SIZE;
+	return readl(IOMEM(c->chip.regs + section_offset + port_offset));
+}
+
+static inline void zevio_gpio_port_set(struct zevio_gpio *c, unsigned pin,
+					unsigned port_offset, u32 val)
+{
+	unsigned section_offset = ((pin >> 3) & 3)*ZEVIO_GPIO_SECTION_SIZE;
+	writel(val, IOMEM(c->chip.regs + section_offset + port_offset));
+}
+
+/* Functions for struct gpio_chip */
+static int zevio_gpio_get(struct gpio_chip *chip, unsigned pin)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+
+	/* Only reading allowed, so no spinlock needed */
+	u32 val = zevio_gpio_port_get(controller, pin, ZEVIO_GPIO_INPUT);
+
+	return (val >> ZEVIO_GPIO_BIT(pin)) & 0x1;
+}
+
+static void zevio_gpio_set(struct gpio_chip *chip, unsigned pin, int value)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+	u32 val;
+
+	spin_lock(&controller->lock);
+	val = zevio_gpio_port_get(controller, pin, ZEVIO_GPIO_OUTPUT);
+	if (value)
+		val |= BIT(ZEVIO_GPIO_BIT(pin));
+	else
+		val &= ~BIT(ZEVIO_GPIO_BIT(pin));
+
+	zevio_gpio_port_set(controller, pin, ZEVIO_GPIO_OUTPUT, val);
+	spin_unlock(&controller->lock);
+}
+
+static int zevio_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+	u32 val;
+
+	spin_lock(&controller->lock);
+
+	val = zevio_gpio_port_get(controller, pin, ZEVIO_GPIO_DIRECTION);
+	val |= BIT(ZEVIO_GPIO_BIT(pin));
+	zevio_gpio_port_set(controller, pin, ZEVIO_GPIO_DIRECTION, val);
+
+	spin_unlock(&controller->lock);
+
+	return 0;
+}
+
+static int zevio_gpio_direction_output(struct gpio_chip *chip,
+				       unsigned pin, int value)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+	u32 val;
+
+	spin_lock(&controller->lock);
+	val = zevio_gpio_port_get(controller, pin, ZEVIO_GPIO_OUTPUT);
+	if (value)
+		val |= BIT(ZEVIO_GPIO_BIT(pin));
+	else
+		val &= ~BIT(ZEVIO_GPIO_BIT(pin));
+
+	zevio_gpio_port_set(controller, pin, ZEVIO_GPIO_OUTPUT, val);
+	val = zevio_gpio_port_get(controller, pin, ZEVIO_GPIO_DIRECTION);
+	val &= ~BIT(ZEVIO_GPIO_BIT(pin));
+	zevio_gpio_port_set(controller, pin, ZEVIO_GPIO_DIRECTION, val);
+
+	spin_unlock(&controller->lock);
+
+	return 0;
+}
+
+static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
+{
+	/*
+	 * TODO: Implement IRQs.
+	 * Not implemented yet due to weird lockups
+	 */
+
+	return -ENXIO;
+}
+
+static struct gpio_chip zevio_gpio_chip = {
+	.direction_input	= zevio_gpio_direction_input,
+	.direction_output	= zevio_gpio_direction_output,
+	.set			= zevio_gpio_set,
+	.get			= zevio_gpio_get,
+	.to_irq			= zevio_gpio_to_irq,
+	.base			= 0,
+	.owner			= THIS_MODULE,
+	.ngpio			= 32,
+	.of_gpio_n_cells	= 2,
+};
+
+/* Initialization */
+static int zevio_gpio_probe(struct platform_device *pdev)
+{
+	struct zevio_gpio *controller;
+	int status, i;
+
+	controller = devm_kzalloc(&pdev->dev, sizeof(*controller), GFP_KERNEL);
+	if (!controller) {
+		dev_err(&pdev->dev, "not enough free memory\n");
+		return -ENOMEM;
+	}
+
+	/* Copy our reference */
+	controller->chip.gc = zevio_gpio_chip;
+	controller->chip.gc.dev = &pdev->dev;
+
+	status = of_mm_gpiochip_add(pdev->dev.of_node, &(controller->chip));
+	if (status) {
+		dev_err(&pdev->dev, "failed to add gpiochip: %d\n", status);
+		return status;
+	}
+
+	spin_lock_init(&controller->lock);
+
+	/* Disable interrupts, they only cause errors */
+	for (i = 0; i < controller->chip.gc.ngpio; i += 8)
+		zevio_gpio_port_set(controller, i, ZEVIO_GPIO_INT_MASK, 0xFF);
+
+	dev_dbg(controller->chip.gc.dev, "ZEVIO GPIO controller set up!\n");
+
+	return 0;
+}
+
+static struct of_device_id zevio_gpio_of_match[] = {
+	{ .compatible = "lsi,zevio-gpio", },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, zevio_gpio_of_match);
+
+static struct platform_driver zevio_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-zevio",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(zevio_gpio_of_match),
+	},
+	.probe		= zevio_gpio_probe,
+};
+
+module_platform_driver(zevio_gpio_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fabian Vogt <fabian@ritter-vogt.de>");
+MODULE_DESCRIPTION("LSI ZEVIO SoC GPIO driver");
-- 
1.8.1.4

