Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaFLUen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:34:43 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43066 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFLUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:34:41 -0400
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: jkosina@suse.cz
Cc: johan@kernel.org, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>
Subject: [PATCH v5] leds: USB: HID: Add support for MSI GT683R led panels
Date: Thu, 12 Jun 2014 23:34:12 +0300
Message-Id: <1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140612090636.GK10256@localhost>
References: <20140612090636.GK10256@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for USB controlled led panels that exists in
MSI GT683R laptop

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
	- suppport for selecting status

Changes in v5:
	- mode attribute documented under Documentation/ABI
	- made array for led_classdev
	- led devices uses now recommended naming scheme

 .../ABI/testing/sysfs-class-hid-driver-gt683r      |  10 +
 drivers/hid/Kconfig                                |  11 +
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-gt683r.c                           | 294 +++++++++++++++++++++
 drivers/hid/hid-ids.h                              |   2 +-
 drivers/hid/usbhid/hid-quirks.c                    |   2 +-
 7 files changed, 319 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
 create mode 100644 drivers/hid/hid-gt683r.c

diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
new file mode 100644
index 0000000..c4d604e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
@@ -0,0 +1,10 @@
+What:		/sys/class/hidraw/<hidraw>/device/state
+Date:		Jun 2014
+KernelVersion:	3.15
+Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
+Description:
+		Set the mode of LEDs
+
+		0 - normal
+		1 - audio
+		2 - breathing
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
index 0000000..6dffb76
--- /dev/null
+++ b/drivers/hid/hid-gt683r.c
@@ -0,0 +1,294 @@
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
+enum gt683r_led_mode {
+	GT683R_LED_OFF = 0,
+	GT683R_LED_AUDIO = 2,
+	GT683R_LED_BREATHING = 3,
+	GT683R_LED_NORMAL = 5
+};
+
+enum gt683r_panels {
+	back,
+	side,
+	front,
+};
+
+const char *gt683r_panel_names[] = {
+	"gt683r::back",
+	"gt683r::side",
+	"gt683r::front",
+};
+
+struct gt683r_led {
+	struct hid_device *hdev;
+	struct led_classdev *led_devs[3];
+	struct mutex lock;
+	struct work_struct work;
+	enum led_brightness brightnesses[3];
+	enum gt683r_led_mode mode;
+};
+
+static const struct hid_device_id gt683r_led_id[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
+	{ }
+};
+
+static void gt683r_brightness_set(struct led_classdev *led_cdev,
+				enum led_brightness brightness)
+{
+	int i;
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	for (i = 0; i < 3; i++) {
+		if (led->led_devs[i] != led_cdev)
+			continue;
+
+		led->brightnesses[i] = brightness;
+		schedule_work(&led->work);
+		break;
+	}
+}
+
+static ssize_t gt683r_show_mode(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct hid_device *hdev =
+		container_of(dev, struct hid_device, dev);
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	if (led->mode == GT683R_LED_NORMAL)
+		return scnprintf(buf, PAGE_SIZE, "0\n");
+	else if (led->mode == GT683R_LED_AUDIO)
+		return scnprintf(buf, PAGE_SIZE, "1\n");
+	else
+		return scnprintf(buf, PAGE_SIZE, "2\n");
+
+}
+
+static ssize_t gt683r_store_mode(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct hid_device *hdev =
+		container_of(dev, struct hid_device, dev);
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	mutex_lock(&led->lock);
+
+	if (!strncmp("0", buf, strlen("0"))) {
+		led->mode = GT683R_LED_NORMAL;
+	} else if (!strncmp("1", buf, strlen("1"))) {
+		led->mode = GT683R_LED_AUDIO;
+	} else if (!strncmp("2", buf, strlen("2"))) {
+		led->mode = GT683R_LED_BREATHING;
+	} else {
+		count = -EINVAL;
+		goto fail;
+	}
+
+	schedule_work(&led->work);
+fail:
+	mutex_unlock(&led->lock);
+
+	return count;
+}
+
+static int gt683r_led_snd_msg(struct gt683r_led *led, u8 *msg)
+{
+	int ret;
+
+	ret = hid_hw_raw_request(led->hdev, msg[0], msg, GT683R_BUFFER_SIZE,
+				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+	if (ret != GT683R_BUFFER_SIZE) {
+		hid_err(led->hdev,
+			"failed to send set report request: %i\n", ret);
+		if (ret < 0)
+			return ret;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void gt683r_led_set(struct gt683r_led *led, u8 leds, u8 mode)
+{
+	u8 *buffer;
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
+	buffer[3] = mode;
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
+	u8 leds = 0;
+
+	mutex_lock(&led->lock);
+
+	if (led->brightnesses[back])
+		leds |= GT683R_LED_BACK;
+
+	if (led->brightnesses[side])
+		leds |= GT683R_LED_SIDE;
+
+	if (led->brightnesses[front])
+		leds |= GT683R_LED_FRONT;
+
+	if (leds)
+		gt683r_led_set(led, leds, led->mode);
+	else
+		gt683r_led_set(led, leds, GT683R_LED_OFF);
+
+	mutex_unlock(&led->lock);
+}
+
+static DEVICE_ATTR(mode, 0644, gt683r_show_mode, gt683r_store_mode);
+
+static int gt683r_led_probe(struct hid_device *hdev,
+			const struct hid_device_id *id)
+{
+	int ret, i;
+	struct gt683r_led *led;
+
+	led = devm_kzalloc(&hdev->dev, sizeof(struct gt683r_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->mode = GT683R_LED_NORMAL;
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
+	for (i = 0; i < 3; i++) {
+		led->led_devs[i] = kzalloc(sizeof(struct led_classdev) +
+					strlen(gt683r_panel_names[i]) + 1,
+					GFP_KERNEL);
+		if (!led->led_devs[i])
+			goto fail2;
+		led->led_devs[i]->name = gt683r_panel_names[i];
+		led->led_devs[i]->max_brightness = 1;
+		led->led_devs[i]->brightness_set = gt683r_brightness_set;
+		ret = led_classdev_register(&hdev->dev, led->led_devs[i]);
+		if (ret) {
+			hid_err(hdev, "could not register led device\n");
+			goto fail2;
+		}
+	}
+
+	ret = device_create_file(&led->hdev->dev,
+				&dev_attr_mode);
+	if (ret) {
+		hid_err(hdev, "could not make mode attribute file\n");
+		goto fail2;
+	}
+
+	mutex_init(&led->lock);
+	INIT_WORK(&led->work, gt683r_led_work);
+
+	return 0;
+
+fail2:
+	while (i-- > 0) {
+		led_classdev_unregister(led->led_devs[i]);
+		kfree(led->led_devs[i]);
+	}
+	hid_hw_stop(hdev);
+fail:
+	return ret;
+}
+
+static void gt683r_led_remove(struct hid_device *hdev)
+{
+	int i;
+	struct gt683r_led *led = hid_get_drvdata(hdev);
+
+	for (i = 0; i < 3; i++) {
+		led_classdev_unregister(led->led_devs[i]);
+		kfree(led->led_devs[i]);
+	}
+	cancel_work_sync(&led->work);
+	device_remove_file(&hdev->dev,
+			&dev_attr_mode);
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

