Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3HEVws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:52:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3HEVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:52:46 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: [PATCH] gpio: New driver for LSI ZEVIO SoCs
To: linux-gpio@vger.kernel.org
Date: Mon, 05 Aug 2013 23:59:11 +0200
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box>
User-Agent: Opera Mail/12.15 (Linux)
X-Provags-ID: V02:K0:o1qT93wZGpXZaIqtP+LRbNjSedjVsKg8DTJUeP88+HY
 Jr4ouLpPN7I9nozdu6xE8uXchV6qp4cO/8PhZvlO720nJiGY3J
 QTNQcnlxUgRIMW1X1LizcfBdRElhoNSZ/WFJ+/ZrEXd/ANVXG7
 A70jhmH0d0YgRHEQRY3eVXleWYY7FbKMcwDXZzNsiQlorXygpN
 H1LFRqmDW0RA6LhgK3900uAe1GsyrHsi7yDlnAKXER4WCo9uMi
 5dafilgs18pAZsUnUSLAk57/Lm1R5dCMCloXMiNQuZd/jlWnbi
 NjQemNzX5FVU4Z14etacibRM/FvFh2MPtuUf9uRsJ18UmCD6ma
 V7sekDqStIqGJwygHk2/POSJP2Wjjgjlbz48q4ArAPDRh+w9t5
 A21hQivlCC9/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

This driver supports the GPIO controller found in LSI ZEVIO SoCs.
It has been successfully tested on a TI nspire CX calculator.

Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
---

Notes:
	Applies to v3.11-rc3-378-g1aa3b5c

    .../devicetree/bindings/gpio/gpio-zevio.txt        |  19 ++
    drivers/gpio/Kconfig                               |   7 +
    drivers/gpio/Makefile                              |   1 +
    drivers/gpio/gpio-zevio.c                          | 212  
+++++++++++++++++++++
    4 files changed, 239 insertions(+)
    create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.txt
    create mode 100644 drivers/gpio/gpio-zevio.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt  
b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
new file mode 100644
index 0000000..96d948b
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
@@ -0,0 +1,19 @@
+Zevio GPIO controller
+
+Required properties:
+- compatible = "lsi,zevio-gpio"
+- reg = <BASEADDR SIZE>
+- #gpio-cells = <2>
+- gpio-controller;
+
+Optional:
+- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent
+
+Example:
+	gpio: gpio@90000000 {
+		compatible = "lsi,zevio-gpio";
+		reg = <0x90000000 0x1000>;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
\ No newline at end of file
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b2450ba..ba8c357 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -138,6 +138,13 @@ config GPIO_EP93XX
    	depends on ARCH_EP93XX
    	select GPIO_GENERIC

+config GPIO_ZEVIO
+	bool "LSI ZEVIO SoC memory mapped GPIOs"
+	depends on ARCH_NSPIRE
+	select GENERIC_IRQ_CHIP
+	help
+	  Say yes here to support the GPIO controller in LSI ZEVIO SoCs.
+
    config GPIO_MM_LANTIQ
    	bool "Lantiq Memory mapped GPIOs"
    	depends on LANTIQ && SOC_XWAY
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index ef3e983..1e7e926 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -87,3 +87,4 @@ obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
    obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
    obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
    obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
+obj-$(CONFIG_GPIO_ZEVIO)	+= gpio-zevio.o
\ No newline at end of file
diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
new file mode 100644
index 0000000..f5c04b3
--- /dev/null
+++ b/drivers/gpio/gpio-zevio.c
@@ -0,0 +1,211 @@
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
+ *  
http://hackspire.unsads.com/wiki/index.php/Memory-mapped_I/O_ports#90000000_-_General_Purpose_I.2FO_.28GPIO.29
+ *
+ * 0x00-0x3F: Section 0
+ *     +0x00: Masked interrupt status (read-only)
+ *     +0x04: R: Interrupt status W: Reset interrupt status
+ *     +0x08: R: Interrupt mask W: Mask interrupt
+ *     +0x0C: W: Unmask interrupt (write-only)
+ *     +0x10: Direction: I/O=1/0
+ *     +0x14: Output
+ *     +0x18: Input (read-only)
+ *     +0x20: R: Sticky interrupts W: Set sticky interrupt
+ * 0x40-0x7F: Section 1
+ * 0x80-0xBF: Section 2
+ * 0xC0-0xFF: Section 3
+ */
+
+#define ZEVIO_GPIO_SECTION_SIZE			0x40
+
+#define ZEVIO_GPIO_INT_MASKED_STATUS_OFFSET	0x00
+#define ZEVIO_GPIO_INT_STATUS_OFFSET		0x04
+#define ZEVIO_GPIO_INT_UNMASK_OFFSET		0x08
+#define ZEVIO_GPIO_INT_MASK_OFFSET		0x0C
+#define ZEVIO_GPIO_DIRECTION_OFFSET		0x10
+#define ZEVIO_GPIO_OUTPUT_OFFSET		0x14
+#define ZEVIO_GPIO_INPUT_OFFSET			0x18
+#define ZEVIO_GPIO_INT_STICKY_OFFSET		0x20
+
+#define to_zevio_gpio(chip) container_of(to_of_mm_gpio_chip(chip), \
+				struct zevio_gpio, chip)
+
+/* Bit of GPIO in section */
+#define ZEVIO_GPIO_BIT(gpio) (gpio&7)
+/* Offset to section of GPIO relative to base */
+#define ZEVIO_GPIO_SECTION_OFFSET(gpio)  
(((gpio>>3)&3)*ZEVIO_GPIO_SECTION_SIZE)
+/* Address of register, which is responsible for given GPIO */
+#define ZEVIO_GPIO(cntrlr, gpio, reg) IOMEM(cntrlr->chip.regs + \
+		ZEVIO_GPIO_SECTION_OFFSET(gpio) + ZEVIO_GPIO_##reg##_OFFSET)
+
+struct zevio_gpio {
+	spinlock_t		lock;
+	struct of_mm_gpio_chip	chip;
+};
+
+/* Functions for struct gpio_chip */
+static int zevio_gpio_get(struct gpio_chip *chip, unsigned pin)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+
+	/* Only reading allowed, so no spinlock needed */
+	uint16_t val = readw(ZEVIO_GPIO(controller, pin, INPUT));
+
+	return (val >> ZEVIO_GPIO_BIT(pin)) & 0x1;
+}
+
+static void zevio_gpio_set(struct gpio_chip *chip, unsigned pin, int  
value)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+	uint16_t val;
+
+	spin_lock(&controller->lock);
+	val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
+	if (value)
+		val |= 1<<ZEVIO_GPIO_BIT(pin);
+	else
+		val &= ~(1<<ZEVIO_GPIO_BIT(pin));
+
+	writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
+	spin_unlock(&controller->lock);
+}
+
+static int zevio_gpio_direction_input(struct gpio_chip *chip, unsigned  
pin)
+{
+	struct zevio_gpio *controller = to_zevio_gpio(chip);
+	uint16_t val;
+
+	spin_lock(&controller->lock);
+
+	val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
+	val |= 1<<ZEVIO_GPIO_BIT(pin);
+	writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));
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
+	uint16_t val;
+
+	spin_lock(&controller->lock);
+	val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
+	if (value)
+		val |= 1<<ZEVIO_GPIO_BIT(pin);
+	else
+		val &= ~(1<<ZEVIO_GPIO_BIT(pin));
+
+	writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
+	val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
+	val &= ~(1<<ZEVIO_GPIO_BIT(pin));
+	writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));
+
+	spin_unlock(&controller->lock);
+
+	return 0;
+}
+
+static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
+{
+	/* Not implemented due to weird lockups */
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
+	.ngpio			= 32, /* Default, if not given in DT */
+	.of_gpio_n_cells	= 2,
+};
+
+/* Initialization */
+static int zevio_gpio_probe(struct platform_device *pdev)
+{
+	struct zevio_gpio *controller;
+	int status, i;
+	u32 ngpio;
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
+	if (!of_property_read_u32(pdev->dev.of_node, "ngpios", &ngpio))
+		controller->chip.gc.ngpio = ngpio;
+
+	status = of_mm_gpiochip_add(pdev->dev.of_node, &(controller->chip));
+	if (status) {
+		kfree(controller);
+		dev_err(&pdev->dev, "failed to add gpiochip: %d\n", status);
+		return status;
+	}
+
+	spin_lock_init(&(controller->lock));
+
+	/* Disable interrupts, they only cause errors */
+	for (i = 0; i < controller->chip.gc.ngpio; i += 8)
+		writew(0xFF, ZEVIO_GPIO(controller, i, INT_MASK));
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
