Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaFKWtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:49:23 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49184 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaFKWtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:49:20 -0400
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: jkosina@suse.cz
Cc: cooloney@gmail.com, johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>
Subject: [PATCH v4] leds: USB: HID: Add support for MSI GT683R led panels
Date: Thu, 12 Jun 2014 01:48:41 +0300
Message-Id: <1402526921-1903-1-git-send-email-janne.kanniainen@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140611173416.GJ10256@localhost>
References: <20140611173416.GJ10256@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for USB controlled led panels that exists in MSI GT683R laptop

Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
---
Changes in v2:
        - sorted headers to alphabetic order
        - using devm_kzalloc
        - using BIT(n)
        - using usb_control_msg instead of usb_submit_urb
        - removing unneeded code

Changes in v3:
        - implemented as HID device
        - some cleanups and bug fixes

Changes in v4:
	- more cleanups
	- support for selecting leds
	- support for selecting status

 drivers/hid/Kconfig             |  11 ++
 drivers/hid/Makefile            |   1 +
 drivers/hid/hid-core.c          |   1 +
 drivers/hid/hid-gt683r.c        | 320 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h           |   2 +-
 drivers/hid/usbhid/hid-quirks.c |   2 +-
 6 files changed, 335 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hid/hid-gt683r.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7af9d0b..d93e0ae 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -261,6 +261,17 @@ config HOLTEK_FF
 	  Say Y here if you have a Holtek On Line Grip based game controller
 	  and want to have force feedback support for it.
 
+config HID_GT683R
+       tristate "MSI GT68xR LED support"
+       depends on LEDS_CLASS && USB_HID
+       ---help---
+       Say Y here if you want to enable support for the MSI GT68xR LEDS
+
+       This driver support following states normal, breathing and audio.
+       You can also select which leds you want to enable.
+       Currently the following devices are know to be supported:
+       - MSI GT683R
+
 config HID_HUION
 	tristate "Huion tablets"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index fc712dd..7129311 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_HID_EMS_FF)	+= hid-emsff.o
 obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
 obj-$(CONFIG_HID_ELO)		+= hid-elo.o
 obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
+obj-$(CONFIG_HID_GT683R)	+= hid-gt683r.o
 obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-kbd.o
 obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-mouse.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index da52279..ec88fdb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1827,6 +1827,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2) },
diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
new file mode 100644
index 0000000..04e4cc2
--- /dev/null
+++ b/drivers/hid/hid-gt683r.c
@@ -0,0 +1,320 @@
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
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+#define GT683R_LED_BACK				BIT(0)
+#define GT683R_LED_SIDE				BIT(1)
+#define GT683R_LED_FRONT			BIT(2)
+
+#define GT683R_BUFFER_SIZE			8
+
+/*
+ * GT683R_LED_OFF: all LEDs are off
+ * GT683R_LED_AUDIO: the status of LEDs depends
+ * on sound level
+ * GT683R_LED_BREATHING: LEDs brightness varies
+ * at human breathing rate
+ * GT683R_LED_NORMAL: LEDs are on
+ */
+enum gt683r_led_state {
+	GT683R_LED_OFF = 0,
+	GT683R_LED_AUDIO = 2,
+	GT683R_LED_BREATHING = 3,
+	GT683R_LED_NORMAL = 5
+};
+
+struct gt683r_led {
+	struct hid_device *hdev;
+	struct led_classdev led_dev_back;
+	struct led_classdev led_dev_side;
+	struct led_classdev led_dev_front;
+	struct mutex lock;
+	struct mutex state_lock;
+	struct work_struct work;
+	enum led_brightness brightness_back;
+	enum led_brightness brightness_side;
+	enum led_brightness brightness_front;
+	enum gt683r_led_state state;
+};
+
+static const struct hid_device_id gt683r_led_id[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
+	{ }
+};
+
+#define GT683R_BRIGHTNESS_SET(name)					\
+static void gt683r_brightness_set_##name(struct led_classdev *led_cdev, \
+					enum led_brightness brightness)	\
+{									\
+	struct gt683r_led *led =					\
+			container_of(led_cdev, struct gt683r_led,	\
+				    led_dev_##name);			\
+									\
+	led->brightness_##name = brightness;				\
+									\
+	schedule_work(&led->work);					\
+}
+
+GT683R_BRIGHTNESS_SET(back);
+GT683R_BRIGHTNESS_SET(side);
+GT683R_BRIGHTNESS_SET(front);
+
+static ssize_t gt683r_show_state(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct hid_device *hdev =
+		container_of(dev, struct hid_device, dev);
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	if (led->state == GT683R_LED_OFF)
+		return sprintf(buf, "off\n");
+	else if (led->state == GT683R_LED_AUDIO)
+		return sprintf(buf, "audio\n");
+	else if (led->state == GT683R_LED_BREATHING)
+		return sprintf(buf, "breathing\n");
+	else
+		return sprintf(buf, "normal\n");
+}
+
+static ssize_t gt683r_store_state(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct hid_device *hdev =
+		container_of(dev, struct hid_device, dev);
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	mutex_lock(&led->state_lock);
+	if (!strncmp("off", buf, strlen("off"))) {
+		led->state = GT683R_LED_OFF;
+	} else if (!strncmp("audio", buf, strlen("audio"))) {
+		led->state = GT683R_LED_AUDIO;
+	} else if (!strncmp("breathing", buf, strlen("breathing"))) {
+		led->state = GT683R_LED_BREATHING;
+	} else if (!strncmp("normal", buf, strlen("normal"))) {
+		led->state = GT683R_LED_NORMAL;
+	} else {
+		count = -EINVAL;
+		goto fail;
+	}
+
+	schedule_work(&led->work);
+
+fail:
+	mutex_unlock(&led->state_lock);
+
+	return count;
+}
+
+static int gt683r_led_snd_msg(struct gt683r_led *led, char *msg)
+{
+	int ret;
+
+	ret = hid_hw_raw_request(led->hdev, msg[0], msg, GT683R_BUFFER_SIZE,
+				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+	if (ret != GT683R_BUFFER_SIZE) {
+		hid_err(led->hdev,
+			"failed to send set report request: %i\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	return 0;
+}
+
+static void gt683r_led_set(struct gt683r_led *led, char leds, char state)
+{
+	char *buffer;
+
+	buffer = kzalloc(GT683R_BUFFER_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	buffer[0] = 0x01;
+	buffer[1] = 0x02;
+	buffer[2] = 0x30;
+	buffer[3] = leds;
+	if (gt683r_led_snd_msg(led, buffer))
+		goto fail;
+
+	buffer[2] = 0x20;
+	buffer[3] = state;
+	buffer[4] = 0x01;
+	gt683r_led_snd_msg(led, buffer);
+
+fail:
+	kfree(buffer);
+}
+
+static void gt683r_led_work(struct work_struct *work)
+{
+	struct gt683r_led *led =
+			container_of(work, struct gt683r_led, work);
+	char leds = 0;
+
+	mutex_lock(&led->lock);
+
+	if (led->brightness_back)
+		leds |= GT683R_LED_BACK;
+
+	if (led->brightness_side)
+		leds |= GT683R_LED_SIDE;
+
+	if (led->brightness_front)
+		leds |= GT683R_LED_FRONT;
+
+	if (leds)
+		gt683r_led_set(led, leds, led->state);
+	else
+		gt683r_led_set(led, leds, GT683R_LED_OFF);
+
+	mutex_unlock(&led->lock);
+}
+
+static struct led_classdev gt683r_led_dev_back = {
+	.name = "gt683r-led:back",
+	.brightness_set = gt683r_brightness_set_back,
+	.max_brightness = 1,
+	.flags = LED_CORE_SUSPENDRESUME,
+};
+
+static struct led_classdev gt683r_led_dev_side = {
+	.name = "gt683r-led:side",
+	.brightness_set = gt683r_brightness_set_side,
+	.max_brightness = 1,
+	.flags = LED_CORE_SUSPENDRESUME,
+};
+
+static struct led_classdev gt683r_led_dev_front = {
+	.name = "gt683r-led:front",
+	.brightness_set = gt683r_brightness_set_front,
+	.max_brightness = 1,
+	.flags = LED_CORE_SUSPENDRESUME,
+};
+
+static struct device_attribute gt683r_led_state_attribute = {
+	.attr = {
+		.name = "state",
+		.mode = 0644,
+	},
+	.show = gt683r_show_state,
+	.store = gt683r_store_state,
+};
+
+static int gt683r_led_probe(struct hid_device *hdev,
+			const struct hid_device_id *id)
+{
+	int ret;
+	struct gt683r_led *led;
+
+	led = devm_kzalloc(&hdev->dev, sizeof(struct gt683r_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->hdev = hdev;
+	hid_set_drvdata(hdev, led);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "hid parsing failed\n");
+		goto fail;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (ret) {
+		hid_err(hdev, "hw start failed\n");
+		goto fail;
+	}
+
+	led->led_dev_back = gt683r_led_dev_back;
+	ret = led_classdev_register(&hdev->dev, &led->led_dev_back);
+	if (ret) {
+		hid_err(hdev, "could not register led device\n");
+		goto fail_back;
+	}
+
+	led->led_dev_side = gt683r_led_dev_side;
+	ret = led_classdev_register(&hdev->dev, &led->led_dev_side);
+	if (ret) {
+		hid_err(hdev, "could not register led device\n");
+		goto fail_side;
+	}
+
+	led->led_dev_front = gt683r_led_dev_front;
+	ret = led_classdev_register(&hdev->dev, &led->led_dev_front);
+	if (ret) {
+		hid_err(hdev, "could not register led device\n");
+		goto fail_front;
+	}
+
+	ret = device_create_file(&led->hdev->dev,
+				&gt683r_led_state_attribute);
+	if (ret) {
+		hid_err(hdev, "could not make state attribute file\n");
+		goto fail_create_file;
+	}
+
+	mutex_init(&led->lock);
+	mutex_init(&led->state_lock);
+	INIT_WORK(&led->work, gt683r_led_work);
+
+	return 0;
+
+fail_create_file:
+	led_classdev_unregister(&led->led_dev_front);
+fail_front:
+	led_classdev_unregister(&led->led_dev_side);
+fail_side:
+	led_classdev_unregister(&led->led_dev_back);
+fail_back:
+	hid_hw_stop(hdev);
+fail:
+	return ret;
+}
+
+static void gt683r_led_remove(struct hid_device *hdev)
+{
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	led_classdev_unregister(&led->led_dev_side);
+	led_classdev_unregister(&led->led_dev_back);
+	led_classdev_unregister(&led->led_dev_front);
+	cancel_work_sync(&led->work);
+	device_remove_file(&hdev->dev,
+			&gt683r_led_state_attribute);
+	hid_hw_stop(hdev);
+}
+
+static struct hid_driver gt683r_led_driver = {
+	.probe = gt683r_led_probe,
+	.remove = gt683r_led_remove,
+	.name = "gt683r_led",
+	.id_table = gt683r_led_id,
+};
+
+module_hid_driver(gt683r_led_driver);
+
+MODULE_AUTHOR("Janne Kanniainen");
+MODULE_DESCRIPTION("MSI GT683R led driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..3692d37 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -641,7 +641,7 @@
 #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
 
 #define USB_VENDOR_ID_MSI		0x1770
-#define USB_DEVICE_ID_MSI_GX680R_LED_PANEL	0xff00
+#define USB_DEVICE_ID_MSI_GT683R_LED_PANEL 0xff00
 
 #define USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR 0x0400
 #define USB_DEVICE_ID_N_S_HARMONY	0xc359
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8e4ddb3..c640e1d 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -73,7 +73,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
-	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
-- 
1.9.2

