Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3EZQwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:52:38 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:43271 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3EZQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 12:52:36 -0400
Message-ID: <1369587150.4240.4.camel@roadrunner.fritz.box>
Subject: [PATCH] hid: driver for PS2/3 Buzz controllers
From: Colin Leitner <colin.leitner@googlemail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 26 May 2013 18:52:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a driver for PlayStation 2/3 Buzz controllers, which exposes the LEDs and
maps all buttons to BTN_TRIGGER_HAPPY1 to 20.

Applies to kernel version 3.10.0-rc2. Tested with Debian 7 and with a minor
change on kernel 3.8.5 on Fedora 18. Couldn't test the wireless version, but
what can be gathered on information from the net, both should be identical in
their report structure.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/hid/Kconfig    |  10 ++
 drivers/hid/Makefile   |   1 +
 drivers/hid/hid-buzz.c | 309 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |   4 +
 drivers/hid/hid-ids.h  |   2 +
 5 files changed, 326 insertions(+)
 create mode 100644 drivers/hid/hid-buzz.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index fb52f3f..b9f6877 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -146,6 +146,16 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
+config HID_BUZZ
+	tristate "PS2/3 Buzz controller support"
+	depends on USB_HID
+	select NEW_LEDS
+	select LEDS_CLASS
+	---help---
+	Say Y here if you want to enable the enhanced support for Buzz
+	controllers. This driver exports the four LEDs and remaps the keys to a
+	more sane setting.
+
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 2065694..70bfbde 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_APPLEIR)	+= hid-appleir.o
 obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BUZZ)		+= hid-buzz.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
diff --git a/drivers/hid/hid-buzz.c b/drivers/hid/hid-buzz.c
new file mode 100644
index 0000000..0c432fb
--- /dev/null
+++ b/drivers/hid/hid-buzz.c
@@ -0,0 +1,309 @@
+/*
+ *  HID driver for PS2 Buzz controllers
+ *
+ *  Based on the PS3 remote and the lg4ff driver.
+ *
+ *  Copyright (c) 2013 Colin Leitner <colin.leitner@gmail.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#ifdef CONFIG_LEDS_CLASS
+#include <linux/leds.h>
+#endif
+
+#include "hid-ids.h"
+
+struct buzz_drv_data {
+#ifdef CONFIG_LEDS_CLASS
+	int led_state;
+	struct led_classdev *leds[4];
+#endif
+};
+
+#ifdef CONFIG_LEDS_CLASS
+static void buzz_set_leds(struct hid_device *hdev, int leds)
+{
+	struct list_head *report_list =
+		&hdev->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct hid_report *report = list_entry(report_list->next,
+		struct hid_report, list);
+	__s32 *value = report->field[0]->value;
+
+	value[0] = 0x00;
+	value[1] = (leds & 1) ? 0xff : 0x00;
+	value[2] = (leds & 2) ? 0xff : 0x00;
+	value[3] = (leds & 4) ? 0xff : 0x00;
+	value[4] = (leds & 8) ? 0xff : 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
+}
+
+static void buzz_led_set_brightness(struct led_classdev *led,
+				    enum led_brightness value)
+{
+	struct device *dev = led->dev->parent;
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct buzz_drv_data *drv_data;
+
+	int n;
+
+	drv_data = hid_get_drvdata(hdev);
+	if (!drv_data) {
+		hid_err(hdev, "No device data\n");
+		return;
+	}
+
+	for (n = 0; n < 4; n++) {
+		if (led == drv_data->leds[n]) {
+			int on = !! (drv_data->led_state & (1 << n));
+			if (value == LED_OFF && on) {
+				drv_data->led_state &= ~(1 << n);
+				buzz_set_leds(hdev, drv_data->led_state);
+			} else if (value != LED_OFF && !on) {
+				drv_data->led_state |= (1 << n);
+				buzz_set_leds(hdev, drv_data->led_state);
+			}
+			break;
+		}
+	}
+}
+
+static enum led_brightness buzz_led_get_brightness(struct led_classdev *led)
+{
+	struct device *dev = led->dev->parent;
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct buzz_drv_data *drv_data;
+
+	int n;
+	int on = 0;
+
+	drv_data = hid_get_drvdata(hdev);
+	if (!drv_data) {
+		hid_err(hdev, "No device data\n");
+		return LED_OFF;
+	}
+
+	for (n = 0; n < 4; n++) {
+		if (led == drv_data->leds[n]) {
+			on = !! (drv_data->led_state & (1 << n));
+			break;
+		}
+	}
+
+	return on ? LED_FULL : LED_OFF;
+}
+#endif
+
+static const unsigned int buzz_keymap[] = {
+	/* The controller has 4 remote buzzers, each with one LED and 5
+	 * buttons.
+	 * 
+	 * We use the mapping chosen by the controller, which is:
+	 *
+	 * Key          Offset
+	 * -------------------
+	 * Buzz              1
+	 * Blue              5
+	 * Orange            4
+	 * Green             3
+	 * Yellow            2
+	 *
+	 * So, for example, the orange button on the third buzzer is mapped to
+	 * BTN_TRIGGER_HAPPY14
+	 */
+	[ 1] = BTN_TRIGGER_HAPPY1,
+	[ 2] = BTN_TRIGGER_HAPPY2,
+	[ 3] = BTN_TRIGGER_HAPPY3,
+	[ 4] = BTN_TRIGGER_HAPPY4,
+	[ 5] = BTN_TRIGGER_HAPPY5,
+	[ 6] = BTN_TRIGGER_HAPPY6,
+	[ 7] = BTN_TRIGGER_HAPPY7,
+	[ 8] = BTN_TRIGGER_HAPPY8,
+	[ 9] = BTN_TRIGGER_HAPPY9,
+	[10] = BTN_TRIGGER_HAPPY10,
+	[11] = BTN_TRIGGER_HAPPY11,
+	[12] = BTN_TRIGGER_HAPPY12,
+	[13] = BTN_TRIGGER_HAPPY13,
+	[14] = BTN_TRIGGER_HAPPY14,
+	[15] = BTN_TRIGGER_HAPPY15,
+	[16] = BTN_TRIGGER_HAPPY16,
+	[17] = BTN_TRIGGER_HAPPY17,
+	[18] = BTN_TRIGGER_HAPPY18,
+	[19] = BTN_TRIGGER_HAPPY19,
+	[20] = BTN_TRIGGER_HAPPY20,
+};
+
+static int buzz_mapping(struct hid_device *hdev, struct hid_input *hi,
+			struct hid_field *field, struct hid_usage *usage,
+			unsigned long **bit, int *max)
+{
+	unsigned int key = usage->hid & HID_USAGE;
+
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_BUTTON)
+		return -1;
+
+	switch (usage->collection_index) {
+	case 1:
+		if (key >= ARRAY_SIZE(buzz_keymap))
+			return -1;
+
+		key = buzz_keymap[key];
+		if (!key)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+
+	hid_map_usage_clear(hi, usage, bit, max, EV_KEY, key);
+	return 1;
+}
+
+static int buzz_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	struct buzz_drv_data *drv_data;
+	int ret;
+
+	drv_data = kzalloc(sizeof(struct buzz_drv_data), GFP_KERNEL);
+	if (!drv_data) {
+		hid_err(hdev, "Insufficient memory, cannot allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, drv_data);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "Parse HID failed\n");
+		goto error;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "Couldn't start HID hardware\n");
+		goto error;
+	}
+
+	/* Clear LEDs as we have no way of reading their initial state. This is
+	 * only relevant if the driver is loaded after somebody actively set the
+	 * LEDs to on */
+	buzz_set_leds(hdev, 0x00);
+
+#ifdef CONFIG_LEDS_CLASS
+	{
+		int n;
+		struct led_classdev *led;
+		size_t name_sz;
+		char *name;
+
+		name_sz = strlen(dev_name(&hdev->dev)) + strlen("::buzz#") + 1;
+
+		for (n = 0; n < 4; n++) {
+			led = kzalloc(sizeof(struct led_classdev) + name_sz, GFP_KERNEL);
+			if (!led) {
+				hid_err(hdev, "Couldn't allocate memory for LED %d\n", n);
+				goto error_leds;
+			}
+
+			name = (void *)(&led[1]);
+			snprintf(name, name_sz, "%s::buzz%d", dev_name(&hdev->dev), n + 1);
+			led->name = name;
+			led->brightness = 0;
+			led->max_brightness = 1;
+			led->brightness_get = buzz_led_get_brightness;
+			led->brightness_set = buzz_led_set_brightness;
+
+			if (led_classdev_register(&hdev->dev, led)) {
+				hid_err(hdev, "Failed to register LED %d\n", n);
+				kfree(led);
+				goto error_leds;
+			}
+
+			drv_data->leds[n] = led;
+		}
+	}
+#endif
+
+	return ret;
+
+#ifdef CONFIG_LEDS_CLASS
+error_leds:
+	{
+		int n;
+		struct led_classdev *led;
+
+		for (n = 0; n < 4; n++) {
+			led = drv_data->leds[n];
+			drv_data->leds[n] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+
+	hid_hw_stop(hdev);
+#endif
+
+error:
+	kfree(drv_data);
+	return ret;
+}
+
+static void buzz_remove(struct hid_device *hdev)
+{
+	struct buzz_drv_data *drv_data;
+
+	drv_data = hid_get_drvdata(hdev);
+	
+#ifdef CONFIG_LEDS_CLASS
+	{
+		int n;
+		struct led_classdev *led;
+
+		for (n = 0; n < 4; n++) {
+			led = drv_data->leds[n];
+			drv_data->leds[n] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+#endif
+
+	hid_hw_stop(hdev);
+	kfree(drv_data);
+}
+
+static const struct hid_device_id buzz_devices[] = {
+	/* Wired Buzz Controller. Reported as Sony Hub from its USB ID and as
+	 * Logitech joystick from the device descriptor. */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, buzz_devices);
+
+static struct hid_driver buzz_driver = {
+	.name          = "buzz",
+	.id_table      = buzz_devices,
+	.input_mapping = buzz_mapping,
+	.probe         = buzz_probe,
+	.remove        = buzz_remove,
+};
+module_hid_driver(buzz_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Colin Leitner <colin.leitner@gmail.com>");
+
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..006340f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1680,6 +1680,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
+#if IS_ENABLED(CONFIG_HID_BUZZ)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
+#endif
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_BDREMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 38535c9..508c007 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -734,6 +734,8 @@
 #define USB_DEVICE_ID_SONY_PS3_BDREMOTE		0x0306
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
+#define USB_DEVICE_ID_SONY_BUZZ_CONTROLLER		0x0002
+#define USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER	0x1000
 
 #define USB_VENDOR_ID_SOUNDGRAPH	0x15c2
 #define USB_DEVICE_ID_SOUNDGRAPH_IMON_FIRST	0x0034

