Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaGTACi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 20:02:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35952 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaGTACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 20:02:36 -0400
Date: Sun, 20 Jul 2014 08:01:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: linus.walleij@linaro.org
Cc: gregkh@linuxfoundation.org, jhovold@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio:gpio-pl2303: add gpio driver for GPIOs on PL2303
Message-ID: <20140720000131.GA2158@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	linus.walleij@linaro.org, gregkh@linuxfoundation.org,
	jhovold@gmail.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL2303HX has two GPIOs, this patch add driver for it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 MAINTAINERS                 |   5 +
 drivers/gpio/Kconfig        |   7 ++
 drivers/gpio/Makefile       |   1 +
 drivers/gpio/gpio-pl2303.c  | 238 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/serial/pl2303.c |  19 ++++
 5 files changed, 270 insertions(+)
 create mode 100644 drivers/gpio/gpio-pl2303.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 53feaaf..4a9d764 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6903,6 +6903,11 @@ F:	drivers/i2c/busses/i2c-puv3.c
 F:	drivers/video/fb-puv3.c
 F:	drivers/rtc/rtc-puv3.c
 
+PL2303 GPIO DRIVER
+M:	Wang YanQing <udknight@gmail.com>
+S:	Maintained
+F:	drivers/gpio/gpio-pl2303.c
+
 PMBUS HARDWARE MONITORING DRIVERS
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	lm-sensors@lm-sensors.org
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a1b511..0f90950 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -110,6 +110,13 @@ config GPIO_DA9055
 config GPIO_MAX730X
 	tristate
 
+config GPIO_PL2303
+	tristate "USB Prolific 2303 gpio support"
+	depends on USB_SERIAL_PL2303
+	help
+	  Enable support for GPIOs on USB Prolific 2303
+	  It support two GPIOs on PL2303HX currently.
+
 comment "Memory mapped GPIO drivers:"
 
 config GPIO_CLPS711X
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index d10f6a9..4ff59f6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -101,3 +101,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
 obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
 obj-$(CONFIG_GPIO_XTENSA)	+= gpio-xtensa.o
 obj-$(CONFIG_GPIO_ZEVIO)	+= gpio-zevio.o
+obj-$(CONFIG_GPIO_PL2303)	+= gpio-pl2303.o
diff --git a/drivers/gpio/gpio-pl2303.c b/drivers/gpio/gpio-pl2303.c
new file mode 100644
index 0000000..a703440
--- /dev/null
+++ b/drivers/gpio/gpio-pl2303.c
@@ -0,0 +1,238 @@
+/*
+ * PL2303 GPIO driver
+ *
+ * Copyright (C) 2014 Wang YanQing <udknight@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Check pl2303.c for further details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/gpio.h>
+
+#define VENDOR_READ_REQUEST_TYPE	0xc0
+#define VENDOR_READ_REQUEST		0x01
+
+#define VENDOR_WRITE_REQUEST_TYPE	0x40
+#define VENDOR_WRITE_REQUEST		0x01
+
+struct pl2303_gpio_data {
+	struct usb_device *pl2303;
+	/*
+	 * 0..3: unknown (zero)
+	 * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
+	 * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
+	 * 6: gp0 pin value
+	 * 7: gp1 pin value
+	 */
+	u8 index;
+	struct gpio_chip gpio_chip;
+};
+
+static inline struct pl2303_gpio_data *to_pl2303_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct pl2303_gpio_data, gpio_chip);
+}
+
+static int pl2303_gpio_read(struct gpio_chip *chip, unsigned char buf[1])
+{
+	struct pl2303_gpio_data *pl2303_gpio = to_pl2303_gpio(chip);
+	struct usb_device *pl2303 = pl2303_gpio->pl2303;
+	struct device *dev = chip->dev;
+	int res;
+
+	res = usb_control_msg(pl2303, usb_rcvctrlpipe(pl2303, 0),
+			VENDOR_READ_REQUEST, VENDOR_READ_REQUEST_TYPE,
+			0x0081, 0, buf, 1, 100);
+	if (res != 1) {
+		dev_err(dev, "%s - failed to read [%04x]: %d\n", __func__,
+			0x0081, res);
+		if (res >= 0)
+			res = -EIO;
+
+		return res;
+	}
+
+	dev_dbg(dev, "%s - [%04x] = %02x\n", __func__, 0x0081, buf[0]);
+
+	return 0;
+}
+
+static int pl2303_gpio_write(struct gpio_chip *chip)
+{
+	struct pl2303_gpio_data *pl2303_gpio = to_pl2303_gpio(chip);
+	struct usb_device *pl2303 = pl2303_gpio->pl2303;
+	struct device *dev = chip->dev;
+	int res;
+
+	dev_dbg(dev, "%s - [%04x] = %02x\n", __func__, 1, pl2303_gpio->index);
+
+	res = usb_control_msg(pl2303, usb_sndctrlpipe(pl2303, 0),
+			VENDOR_WRITE_REQUEST, VENDOR_WRITE_REQUEST_TYPE,
+			1, pl2303_gpio->index, NULL, 0, 100);
+	if (res) {
+		dev_err(dev, "%s - failed to write [%04x] = %02x: %d\n", __func__,
+			1, pl2303_gpio->index, res);
+		return res;
+	}
+
+	return 0;
+}
+
+static int pl2303_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct pl2303_gpio_data *pl2303_gpio = to_pl2303_gpio(chip);
+
+	if (offset == 0)
+		pl2303_gpio->index &= ~0x10;
+	else if (offset == 1)
+		pl2303_gpio->index &= ~0x20;
+	else
+		return -EINVAL;
+
+	pl2303_gpio_write(chip);
+	return 0;
+}
+
+static int pl2303_gpio_direction_out(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pl2303_gpio_data *pl2303_gpio = to_pl2303_gpio(chip);
+
+	if (offset == 0) {
+		pl2303_gpio->index |= 0x10;
+		if (value)
+			pl2303_gpio->index |= 0x40;
+		else
+			pl2303_gpio->index &= ~0x40;
+	} else if (offset == 1) {
+		pl2303_gpio->index |= 0x20;
+		if (value)
+			pl2303_gpio->index |= 0x80;
+		else
+			pl2303_gpio->index &= ~0x80;
+	} else {
+		return -EINVAL;
+	}
+
+	pl2303_gpio_write(chip);
+	return 0;
+}
+
+static void pl2303_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pl2303_gpio_data *pl2303_gpio = to_pl2303_gpio(chip);
+
+	if (offset == 0) {
+		if (value)
+			pl2303_gpio->index |= 0x40;
+		else
+			pl2303_gpio->index &= ~0x40;
+	} else if (offset == 1) {
+		if (value)
+			pl2303_gpio->index |= 0x80;
+		else
+			pl2303_gpio->index &= ~0x80;
+	} else {
+		return;
+	}
+
+	pl2303_gpio_write(chip);
+}
+
+static int pl2303_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned char buf[1];
+	int value = 0;
+
+	if(pl2303_gpio_read(chip, buf) < 1)
+		return -EIO;
+	if (offset == 0)
+		value = buf[0] & 0x40;
+	else if (offset == 1)
+		value = buf[0] & 0x80;
+	else
+		return -EINVAL;
+	return value;
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "pl2303-gpio",
+	.owner			= THIS_MODULE,
+	.direction_input	= pl2303_gpio_direction_in,
+	.get			= pl2303_gpio_get,
+	.direction_output	= pl2303_gpio_direction_out,
+	.set			= pl2303_gpio_set,
+	.can_sleep		= 1,
+};
+
+static int pl2303_gpio_probe(struct platform_device *pdev)
+{
+	struct usb_device *pl2303 = platform_get_drvdata(pdev);
+	struct pl2303_gpio_data *pl2303_gpio;
+	int ret;
+
+	pl2303_gpio = kzalloc(sizeof(*pl2303_gpio), GFP_KERNEL);
+	if (pl2303_gpio == NULL)
+		return -ENOMEM;
+
+	/* initialize gpio0,gpio1 for input as default*/
+	pl2303_gpio->index = 0x00;
+	pl2303_gpio->pl2303 = pl2303;
+	pl2303_gpio->gpio_chip = template_chip;
+	pl2303_gpio->gpio_chip.ngpio = 2;
+	pl2303_gpio->gpio_chip.base = -1;
+	pl2303_gpio->gpio_chip.dev = &pdev->dev;
+	pl2303_gpio_write(&pl2303_gpio->gpio_chip);
+
+	ret = gpiochip_add(&pl2303_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
+	}
+	platform_set_drvdata(pdev, pl2303_gpio);
+
+	return ret;
+}
+
+static int pl2303_gpio_remove(struct platform_device *pdev)
+{
+	struct pl2303_gpio_data *pl2303_gpio = platform_get_drvdata(pdev);
+
+	if (gpiochip_remove(&pl2303_gpio->gpio_chip))
+		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+	platform_set_drvdata(pdev, NULL);
+	kfree(pl2303_gpio);
+	return 0;
+}
+
+static struct platform_driver pl2303_gpio_driver = {
+	.driver.name	= "pl2303-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= pl2303_gpio_probe,
+	.remove		= pl2303_gpio_remove,
+};
+
+static int __init pl2303_gpio_init(void)
+{
+	return platform_driver_register(&pl2303_gpio_driver);
+}
+module_init(pl2303_gpio_init);
+
+static void __exit pl2303_gpio_exit(void)
+{
+	platform_driver_unregister(&pl2303_gpio_driver);
+}
+module_exit(pl2303_gpio_exit);
+
+MODULE_AUTHOR("Wang YanQing <udknight@gmail.com>");
+MODULE_DESCRIPTION("GPIO driver for PL2303");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("platform:pl2303-gpio");
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index b3d5a35..1bb8928 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -28,6 +28,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <asm/unaligned.h>
+#include <linux/platform_device.h>
 #include "pl2303.h"
 
 
@@ -146,6 +147,7 @@ struct pl2303_type_data {
 struct pl2303_serial_private {
 	const struct pl2303_type_data *type;
 	unsigned long quirks;
+	struct platform_device *pdev;
 };
 
 struct pl2303_private {
@@ -261,7 +263,22 @@ static int pl2303_startup(struct usb_serial *serial)
 		pl2303_vendor_write(serial, 2, 0x44);
 
 	kfree(buf);
+	if (type != TYPE_HX)
+		return 0;
 
+	spriv->pdev = platform_device_alloc("pl2303-gpio", PLATFORM_DEVID_AUTO);
+	if (spriv->pdev == NULL) {
+		dev_err(&serial->interface->dev, "Failed to allocate %s\n", "pl2303-gpio");
+	} else {
+		spriv->pdev->dev.parent = &serial->interface->dev;
+		platform_set_drvdata(spriv->pdev, serial->dev);
+		platform_device_add(spriv->pdev);
+		if (platform_device_add(spriv->pdev) != 0) {
+			dev_err(&serial->interface->dev, "Failed to register %s\n", "pl2303-gpio");
+			platform_device_put(spriv->pdev);
+			spriv->pdev = NULL;
+		}
+	}
 	return 0;
 }
 
@@ -269,6 +286,8 @@ static void pl2303_release(struct usb_serial *serial)
 {
 	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
 
+	if (spriv && spriv->pdev)
+		platform_device_unregister(spriv->pdev);
 	kfree(spriv);
 }
 
-- 
1.8.5.5.dirty
