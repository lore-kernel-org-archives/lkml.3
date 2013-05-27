Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3E0VlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 17:41:14 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:32941 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3E0VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 17:41:12 -0400
Message-ID: <1369690865.2369.5.camel@roadrunner.fritz.box>
Subject: Re: [PATCH] hid: driver for PS2/3 Buzz controllers
From: Colin Leitner <colin.leitner@googlemail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 May 2013 23:41:05 +0200
In-Reply-To: <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
References: <1369587150.4240.4.camel@roadrunner.fritz.box>
	 <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for PS2/3 Buzz controllers into hid-sony

It has been tested on Debian 7 with kernel version 3.10.0-rc2. Unfortunately
I can't test the patch with a regular six-axis controller myself.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/hid/Kconfig    |    9 +-
 drivers/hid/hid-core.c |    2 +
 drivers/hid/hid-ids.h  |    2 +
 drivers/hid/hid-sony.c |  310 ++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 312 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index fb52f3f..53caf0b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -594,10 +594,15 @@ config HID_SAMSUNG
 	Support for Samsung InfraRed remote control or keyboards.
 
 config HID_SONY
-	tristate "Sony PS3 controller"
+	tristate "Sony PS2/3 accessories"
 	depends on USB_HID
+	select NEW_LEDS
+	select LEDS_CLASS
 	---help---
-	Support for Sony PS3 6-axis controllers.
+	Support for
+	  
+	  * Sony PS3 6-axis controllers
+	  * Buzz controllers
 
 	Support for the Sony PS3 BD Remote is provided by HID_PS3REMOTE.
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..ecd1107 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1680,6 +1680,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
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
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 312098e..41e829c 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -6,6 +6,7 @@
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2008 Jiri Slaby
  *  Copyright (c) 2006-2008 Jiri Kosina
+ *  Copyright (c) 2013 Colin Leitner <colin.leitner@gmail.com>
  */
 
 /*
@@ -26,6 +27,7 @@
 #define VAIO_RDESC_CONSTANT     (1 << 0)
 #define SIXAXIS_CONTROLLER_USB  (1 << 1)
 #define SIXAXIS_CONTROLLER_BT   (1 << 2)
+#define BUZZ_CONTROLLER         (1 << 3)
 
 static const u8 sixaxis_rdesc_fixup[] = {
 	0x95, 0x13, 0x09, 0x01, 0x81, 0x02, 0x95, 0x0C,
@@ -55,8 +57,56 @@ static const u8 sixaxis_rdesc_fixup2[] = {
 	0xb1, 0x02, 0xc0, 0xc0,
 };
 
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
 struct sony_sc {
 	unsigned long quirks;
+
+	void *extra;
+};
+
+struct buzz_extra {
+#ifdef CONFIG_LEDS_CLASS
+	int led_state;
+	struct led_classdev *leds[4];
+#endif
 };
 
 /* Sony Vaio VGX has wrongly mouse pointer declared as constant */
@@ -117,6 +167,38 @@ static int sony_raw_event(struct hid_device *hdev, struct hid_report *report,
 	return 0;
 }
 
+static int sony_mapping(struct hid_device *hdev, struct hid_input *hi,
+			struct hid_field *field, struct hid_usage *usage,
+			unsigned long **bit, int *max)
+{
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+
+	if (sc->quirks & BUZZ_CONTROLLER) {
+		unsigned int key = usage->hid & HID_USAGE;
+
+		if ((usage->hid & HID_USAGE_PAGE) != HID_UP_BUTTON)
+			return -1;
+
+		switch (usage->collection_index) {
+		case 1:
+			if (key >= ARRAY_SIZE(buzz_keymap))
+				return -1;
+
+			key = buzz_keymap[key];
+			if (!key)
+				return -1;
+			break;
+		default:
+			return -1;
+		}
+
+		hid_map_usage_clear(hi, usage, bit, max, EV_KEY, key);
+		return 1;
+	}
+
+	return -1;
+}
+
 /*
  * The Sony Sixaxis does not handle HID Output Reports on the Interrupt EP
  * like it should according to usbhid/hid-core.c::usbhid_output_raw_report()
@@ -192,11 +274,201 @@ static int sixaxis_set_operational_bt(struct hid_device *hdev)
 	return hdev->hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
 }
 
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
+	struct sony_sc *drv_data;
+	struct buzz_extra *buzz;
+
+	int n;
+
+	drv_data = hid_get_drvdata(hdev);
+	if (!drv_data || !drv_data->extra) {
+		hid_err(hdev, "No device data\n");
+		return;
+	}
+	buzz = drv_data->extra;
+
+	for (n = 0; n < 4; n++) {
+		if (led == buzz->leds[n]) {
+			int on = !! (buzz->led_state & (1 << n));
+			if (value == LED_OFF && on) {
+				buzz->led_state &= ~(1 << n);
+				buzz_set_leds(hdev, buzz->led_state);
+			} else if (value != LED_OFF && !on) {
+				buzz->led_state |= (1 << n);
+				buzz_set_leds(hdev, buzz->led_state);
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
+	struct sony_sc *drv_data;
+	struct buzz_extra *buzz;
+
+	int n;
+	int on = 0;
+
+	drv_data = hid_get_drvdata(hdev);
+	if (!drv_data || !drv_data->extra) {
+		hid_err(hdev, "No device data\n");
+		return LED_OFF;
+	}
+	buzz = drv_data->extra;
+
+	for (n = 0; n < 4; n++) {
+		if (led == buzz->leds[n]) {
+			on = !! (buzz->led_state & (1 << n));
+			break;
+		}
+	}
+
+	return on ? LED_FULL : LED_OFF;
+}
+#endif
+
+static int buzz_init(struct hid_device *hdev)
+{
+	struct sony_sc *drv_data;
+	struct buzz_extra *buzz;
+	int ret = 0;
+
+	drv_data = hid_get_drvdata(hdev);
+	BUG_ON(!(drv_data->quirks & BUZZ_CONTROLLER));
+
+	buzz = kzalloc(sizeof(*buzz), GFP_KERNEL);
+	if (!buzz) {
+		hid_err(hdev, "Insufficient memory, cannot allocate driver data\n");
+		return -ENOMEM;
+	}
+	drv_data->extra = buzz;
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
+			buzz->leds[n] = led;
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
+			led = buzz->leds[n];
+			buzz->leds[n] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+
+	kfree(drv_data->extra);
+	drv_data->extra = NULL;
+	return ret;
+#endif
+}
+
+static void buzz_remove(struct hid_device *hdev)
+{
+	struct sony_sc *drv_data;
+	struct buzz_extra *buzz;
+
+	drv_data = hid_get_drvdata(hdev);
+	BUG_ON(!(drv_data->quirks & BUZZ_CONTROLLER));
+
+	buzz = drv_data->extra;
+	
+#ifdef CONFIG_LEDS_CLASS
+	{
+		int n;
+		struct led_classdev *led;
+
+		for (n = 0; n < 4; n++) {
+			led = buzz->leds[n];
+			buzz->leds[n] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+#endif
+
+	kfree(drv_data->extra);
+	drv_data->extra = NULL;
+}
+
 static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
 	unsigned long quirks = id->driver_data;
 	struct sony_sc *sc;
+	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 
 	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
 	if (sc == NULL) {
@@ -213,8 +485,14 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT |
-			HID_CONNECT_HIDDEV_FORCE);
+	if (sc->quirks & VAIO_RDESC_CONSTANT)
+		connect_mask |= HID_CONNECT_HIDDEV_FORCE;
+	else if (sc->quirks & SIXAXIS_CONTROLLER_USB)
+		connect_mask |= HID_CONNECT_HIDDEV_FORCE;
+	else if (sc->quirks & SIXAXIS_CONTROLLER_BT)
+		connect_mask |= HID_CONNECT_HIDDEV_FORCE;
+
+	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto err_free;
@@ -226,6 +504,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 	else if (sc->quirks & SIXAXIS_CONTROLLER_BT)
 		ret = sixaxis_set_operational_bt(hdev);
+	else if (sc->quirks & BUZZ_CONTROLLER)
+		ret = buzz_init(hdev);
 	else
 		ret = 0;
 
@@ -242,8 +522,13 @@ err_free:
 
 static void sony_remove(struct hid_device *hdev)
 {
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+
+	if (sc->quirks & BUZZ_CONTROLLER)
+		buzz_remove(hdev);
+
 	hid_hw_stop(hdev);
-	kfree(hid_get_drvdata(hdev));
+	kfree(sc);
 }
 
 static const struct hid_device_id sony_devices[] = {
@@ -257,17 +542,24 @@ static const struct hid_device_id sony_devices[] = {
 		.driver_data = VAIO_RDESC_CONSTANT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE),
 		.driver_data = VAIO_RDESC_CONSTANT },
+	/* Wired Buzz Controller. Reported as Sony Hub from its USB ID and as
+	 * Logitech joystick from the device descriptor. */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER),
+		.driver_data = BUZZ_CONTROLLER },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER),
+		.driver_data = BUZZ_CONTROLLER },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sony_devices);
 
 static struct hid_driver sony_driver = {
-	.name = "sony",
-	.id_table = sony_devices,
-	.probe = sony_probe,
-	.remove = sony_remove,
-	.report_fixup = sony_report_fixup,
-	.raw_event = sony_raw_event
+	.name          = "sony",
+	.id_table      = sony_devices,
+	.input_mapping = sony_mapping,
+	.probe         = sony_probe,
+	.remove        = sony_remove,
+	.report_fixup  = sony_report_fixup,
+	.raw_event     = sony_raw_event
 };
 module_hid_driver(sony_driver);
 
-- 
1.7.10.4


