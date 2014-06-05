Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaFEV3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:29:41 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:64126 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFEV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:29:37 -0400
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: cooloney@gmail.com, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>
Subject: [PATCH v2] leds: USB: Add support for MSI GT683R led panels
Date: Fri,  6 Jun 2014 00:29:06 +0300
Message-Id: <1402003746-6354-1-git-send-email-janne.kanniainen@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for USB controlled led panels that exist in MSI GT683R laptop.

Changes in v2:
	- sorted headers to alphabetic order
	- using devm_kzalloc
	- using BIT(n)
	- using usb_control_msg instead of usb_submit_urb
	- removing unneeded code

Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
---
 drivers/leds/Kconfig       |   6 ++
 drivers/leds/Makefile      |   1 +
 drivers/leds/leds-gt683r.c | 158 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)
 create mode 100644 drivers/leds/leds-gt683r.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6de9dfb..2cffa0c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -487,6 +487,12 @@ config LEDS_BLINKM
 	  This option enables support for the BlinkM RGB LED connected
 	  through I2C. Say Y to enable support for the BlinkM LED.
 
+config LEDS_GT683R
+       tristate "LED support for the MSI GT683R"
+       depends on LEDS_CLASS && USB
+       help
+         This option enables support for the MSI GT683R LEDS
+
 comment "LED Triggers"
 source "drivers/leds/trigger/Kconfig"
 
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3cd76db..af5fb4e 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
+obj-$(CONFIG_LEDS_GT683R)		+= leds-gt683r.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-gt683r.c b/drivers/leds/leds-gt683r.c
new file mode 100644
index 0000000..5a204ea
--- /dev/null
+++ b/drivers/leds/leds-gt683r.c
@@ -0,0 +1,158 @@
+/*
+ * MSI GT683R led driver
+ *
+ * Copyright (c) 2014 Janne Kanniainen <janne.kanniainen@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#define USB_DEVICE_ID_MSI_GT683R_LED_PANEL	0xff00
+#define USB_VENDOR_ID_MSI			0x1770
+
+#define GT683R_LED_BACK				BIT(0)
+#define GT683R_LED_SIDE				BIT(1)
+#define GT683R_LED_FRONT			BIT(2)
+#define GT683R_LED_ALL (GT683R_LED_BACK | GT683R_LED_SIDE | GT683R_LED_FRONT)
+
+#define GT683R_LED_OFF				0
+#define GT683R_LED_AUDIO			2
+#define GT683R_LED_BREATHING			3
+#define GT683R_LED_NORMAL			5
+
+struct gt683r_led {
+	struct usb_device *usb_dev;
+	struct usb_endpoint_descriptor *ep;
+	struct led_classdev led_dev;
+	struct mutex lock;
+	struct work_struct work;
+	enum led_brightness brightness;
+};
+
+static const struct usb_device_id gt683r_led_id[] = {
+	{ USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
+	{ }
+};
+
+static const u64 gt683r_led_select_leds = 0x300201ULL;
+static const u64 gt683r_led_select_type = 0x100200201ULL;
+
+static void gt683r_brightness_set(struct led_classdev *led_cdev,
+				  enum led_brightness brightness)
+{
+	struct gt683r_led *led =
+			container_of(led_cdev, struct gt683r_led, led_dev);
+
+	mutex_lock(&led->lock);
+
+	led->brightness = brightness;
+
+	schedule_work(&led->work);
+}
+
+static int gt683r_led_snd_msg(struct gt683r_led *led, u64 msg)
+{
+	int result = usb_control_msg(led->usb_dev,
+				usb_sndctrlpipe(led->usb_dev,
+						led->ep->bEndpointAddress),
+				0x09, 0x22, 0x0301, 0x0000,
+				&msg, sizeof(u64), USB_CTRL_SET_TIMEOUT);
+	if (result)
+		dev_err(&led->usb_dev->dev,
+			"Failed to send control message: %i\n", result);
+
+	return result;
+}
+
+static void gt683r_led_set(struct gt683r_led *led, char type)
+{
+	gt683r_led_snd_msg(led, gt683r_led_select_leds |
+			(GT683R_LED_ALL << 24));
+	gt683r_led_snd_msg(led, gt683r_led_select_type |
+			(type << 24));
+}
+
+static void gt683r_led_work(struct work_struct *work)
+{
+	struct gt683r_led *led =
+			container_of(work, struct gt683r_led, work);
+
+	if (led->brightness)
+		gt683r_led_set(led, GT683R_LED_NORMAL);
+	else
+		gt683r_led_set(led, GT683R_LED_OFF);
+
+	mutex_unlock(&led->lock);
+}
+
+static struct led_classdev gt683r_led_dev = {
+	.name = "gt683r-led",
+	.brightness_set = gt683r_brightness_set,
+	.max_brightness = 1,
+	.flags = LED_CORE_SUSPENDRESUME,
+};
+
+static int gt683r_led_probe(struct usb_interface *intf,
+			    const struct usb_device_id *id)
+{
+	int ret = 0;
+	struct gt683r_led *led =
+		devm_kzalloc(&intf->dev, sizeof(struct gt683r_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->usb_dev = interface_to_usbdev(intf);
+	usb_set_intfdata(intf, led);
+
+	led->ep = &led->usb_dev->ep0.desc;
+	if (!usb_endpoint_xfer_control(led->ep) ||
+		usb_endpoint_maxp(led->ep) != sizeof(u64))
+		return -EINVAL;
+
+	led->led_dev = gt683r_led_dev;
+	ret = led_classdev_register(&led->usb_dev->dev, &led->led_dev);
+	if (ret) {
+		dev_err(&led->usb_dev->dev, "Could not register led_classdev\n");
+		return ret;
+	}
+
+	mutex_init(&led->lock);
+	INIT_WORK(&led->work, gt683r_led_work);
+
+	return 0;
+}
+
+static void gt683r_led_disconnect(struct usb_interface *intf)
+{
+	struct gt683r_led *led = usb_get_intfdata(intf);
+
+	led_classdev_unregister(&led->led_dev);
+	cancel_work_sync(&led->work);
+}
+
+static struct usb_driver gt683r_led_driver = {
+	.probe = gt683r_led_probe,
+	.disconnect = gt683r_led_disconnect,
+	.name = "GT683R Led Driver",
+	.id_table = gt683r_led_id,
+};
+
+module_usb_driver(gt683r_led_driver);
+
+MODULE_AUTHOR("Janne Kanniainen");
+MODULE_DESCRIPTION("MSI GT683R led driver");
+MODULE_LICENSE("GPL");
-- 
1.9.2

