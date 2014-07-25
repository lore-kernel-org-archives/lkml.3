Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbaGYRgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:36:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44352 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbaGYRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:36:50 -0400
Date: Sat, 26 Jul 2014 01:35:23 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140725173523.GA30320@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, linus.walleij@linaro.org,
	jhovold@gmail.com, andi@lisas.de, dforsi@gmail.com,
	gnomes@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL2303HX has two GPIOs, this patch add interface for it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 Changes v4-v5:
 1: fix gpio_chip.lable been overwrited by template_chip.
 2: use idr to manage minor instead of crude monotonous atomic increment.
 
 drivers/usb/serial/Kconfig  |  10 +++
 drivers/usb/serial/pl2303.c | 189 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 3ce5c74..4bc0d0f 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -516,6 +516,16 @@ config USB_SERIAL_PL2303
 	  To compile this driver as a module, choose M here: the
 	  module will be called pl2303.
 
+config USB_SERIAL_PL2303_GPIO
+	bool "USB Prolific 2303 Single Port GPIOs support"
+	depends on USB_SERIAL_PL2303 && GPIOLIB
+	---help---
+	  Say Y here if you want to use the GPIOs on PL2303 USB Serial single port
+	  adapter from Prolific.
+
+	  It support 2 GPIOs on PL2303HX currently,
+	  if unsure, say N.
+
 config USB_SERIAL_OTI6858
 	tristate "USB Ours Technology Inc. OTi-6858 USB To RS232 Bridge Controller"
 	help
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index b3d5a35..938684c 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -28,6 +28,8 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <asm/unaligned.h>
+#include <linux/gpio.h>
+#include <linux/idr.h>
 #include "pl2303.h"
 
 
@@ -143,9 +145,26 @@ struct pl2303_type_data {
 	unsigned long quirks;
 };
 
+struct pl2303_gpio {
+	/*
+	 * 0..3: unknown (zero)
+	 * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
+	 * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
+	 * 6: gp0 pin value
+	 * 7: gp1 pin value
+	 */
+	u8 index;
+	u32 minor;
+	struct usb_serial *serial;
+	struct gpio_chip gpio_chip;
+};
+
 struct pl2303_serial_private {
 	const struct pl2303_type_data *type;
 	unsigned long quirks;
+#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
+	struct pl2303_gpio *gpio;
+#endif
 };
 
 struct pl2303_private {
@@ -213,6 +232,170 @@ static int pl2303_probe(struct usb_serial *serial,
 	return 0;
 }
 
+#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
+#define GPIO_NUM (2)
+static u8 gpio_dir_mask[GPIO_NUM] = {0x10, 0x20};
+static u8 gpio_value_mask[GPIO_NUM] = {0x40, 0x80};
+static DEFINE_IDR(gpiochip_minor);
+static DEFINE_MUTEX(gpiochip_lock);
+
+static inline struct pl2303_gpio *to_pl2303_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct pl2303_gpio, gpio_chip);
+}
+
+static int pl2303_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	gpio->index &= ~gpio_dir_mask[offset];
+	pl2303_vendor_write(gpio->serial, 1, gpio->index);
+	return 0;
+}
+
+static int pl2303_gpio_direction_out(struct gpio_chip *chip,
+				unsigned offset, int value)
+{
+	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	gpio->index |= gpio_dir_mask[offset];
+	if (value)
+		gpio->index |= gpio_value_mask[offset];
+	else
+		gpio->index &= ~gpio_value_mask[offset];
+
+	pl2303_vendor_write(gpio->serial, 1, gpio->index);
+	return 0;
+}
+
+static void pl2303_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
+
+	if (offset >= chip->ngpio)
+		return;
+
+	if (value)
+		gpio->index |= gpio_value_mask[offset];
+	else
+		gpio->index &= ~gpio_value_mask[offset];
+
+	pl2303_vendor_write(gpio->serial, 1, gpio->index);
+}
+
+static int pl2303_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
+	unsigned char buf[1];
+	int value = 0;
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	if (pl2303_vendor_read(gpio->serial, 0x0081, buf))
+		return -EIO;
+
+	value = buf[0] & gpio_value_mask[offset];
+	return value;
+}
+
+static const struct gpio_chip template_chip = {
+	.owner                  = THIS_MODULE,
+	.direction_input        = pl2303_gpio_direction_in,
+	.get                    = pl2303_gpio_get,
+	.direction_output       = pl2303_gpio_direction_out,
+	.set                    = pl2303_gpio_set,
+	.can_sleep              = true,
+};
+
+static int pl2303_gpio_startup(struct usb_serial *serial)
+{
+	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
+	char *label;
+	int ret;
+	int minor;
+
+	if (spriv->type != &pl2303_type_data[TYPE_HX])
+		return 0;
+
+	spriv->gpio = kzalloc(sizeof(struct pl2303_gpio), GFP_KERNEL);
+	if (spriv->gpio == NULL) {
+		dev_err(&serial->interface->dev,
+			"Failed to allocate pl2303_gpio\n");
+		ret = -ENOMEM;
+		goto ERROR0;
+	}
+
+	spriv->gpio->index = 0x00;
+	spriv->gpio->serial = serial;
+
+	mutex_lock(&gpiochip_lock);
+	minor = idr_alloc(&gpiochip_minor, serial, 0, 0, GFP_KERNEL);
+	if (minor < 0) {
+		mutex_unlock(&gpiochip_lock);
+		ret = minor;
+		goto ERROR1;
+	}
+	spriv->gpio->minor = minor;
+	mutex_unlock(&gpiochip_lock);
+
+	label = kasprintf(GFP_KERNEL, "pl2303-gpio%d",
+			  spriv->gpio->minor);
+	if (label == NULL) {
+		ret = -ENOMEM;
+		goto ERROR2;
+	}
+	spriv->gpio->gpio_chip = template_chip;
+	spriv->gpio->gpio_chip.label = label;
+	spriv->gpio->gpio_chip.ngpio = GPIO_NUM;
+	spriv->gpio->gpio_chip.base = -1;
+	spriv->gpio->gpio_chip.dev = &serial->interface->dev;
+	/* initialize GPIOs, input mode as default */
+	pl2303_vendor_write(spriv->gpio->serial, 1, spriv->gpio->index);
+
+	ret = gpiochip_add(&spriv->gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&serial->interface->dev,
+			"Could not register gpiochip, %d\n", ret);
+		goto ERROR3;
+	}
+	return 0;
+ERROR3:
+	kfree(spriv->gpio->gpio_chip.label);
+ERROR2:
+	mutex_lock(&gpiochip_lock);
+	idr_remove(&gpiochip_minor, spriv->gpio->minor);
+	mutex_unlock(&gpiochip_lock);
+ERROR1:
+	kfree(spriv->gpio);
+	spriv->gpio = NULL;
+ERROR0:
+	return ret;
+}
+
+static void pl2303_gpio_release(struct usb_serial *serial)
+{
+	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
+
+	if (spriv->gpio) {
+		mutex_lock(&gpiochip_lock);
+		idr_remove(&gpiochip_minor, spriv->gpio->minor);
+		mutex_unlock(&gpiochip_lock);
+
+		gpiochip_remove(&spriv->gpio->gpio_chip);
+		kfree(spriv->gpio->gpio_chip.label);
+		kfree(spriv->gpio);
+		spriv->gpio = NULL;
+	}
+}
+#endif
+
 static int pl2303_startup(struct usb_serial *serial)
 {
 	struct pl2303_serial_private *spriv;
@@ -262,6 +445,9 @@ static int pl2303_startup(struct usb_serial *serial)
 
 	kfree(buf);
 
+#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
+	pl2303_gpio_startup(serial);
+#endif
 	return 0;
 }
 
@@ -269,6 +455,9 @@ static void pl2303_release(struct usb_serial *serial)
 {
 	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
 
+#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
+	pl2303_gpio_release(serial);
+#endif
 	kfree(spriv);
 }
 
-- 
1.8.5.5.dirty
