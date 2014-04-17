Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaDQLjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:39:42 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:51988 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDQLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:39:40 -0400
X-Greylist: delayed 2670 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2014 07:39:39 EDT
From: Jamie Lentin <jm@lentin.co.uk>
To: Jamie Lentin <jm@lentin.co.uk>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] hid: Add custom driver for Lenovo ThinkPad Compact Bluetooth Keyboard
Date: Thu, 17 Apr 2014 11:54:58 +0100
Message-Id: <1397732098-7853-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This keyboard requires some custom mappings for all keys to be
available, and the Fn-lock toggle needs to be controlled in software.

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
Apologies for nagging, but anyone got any feedback on this? I don't
think there's anything massively contentious, but hasn't been picked up
by anyone yet.

I assume that Linux users want Fn-Lock enabled by default, so they can
get at the function keys. If this is an incorrect assumption then can
change it---so long as I can leave it enabled and use the Fn-Lock key
for something else, I don't particuarly care.

Tested with and applies cleanly to 3.13.6.
---
 drivers/hid/Kconfig                   |  10 ++
 drivers/hid/Makefile                  |   1 +
 drivers/hid/hid-core.c                |   3 +
 drivers/hid/hid-ids.h                 |   1 +
 drivers/hid/hid-lenovo-tpcompactkbd.c | 191 ++++++++++++++++++++++++++++++++++
 5 files changed, 206 insertions(+)
 create mode 100644 drivers/hid/hid-lenovo-tpcompactkbd.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 34e2d39..8e45413 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -335,6 +335,16 @@ config HID_LENOVO_TPKBD
 	sensitivity of the trackpoint, using the microphone mute button or
 	controlling the mute and microphone mute LEDs.
 
+config HID_LENOVO_CBTKBD
+	tristate "Lenovo ThinkPad Compact Bluetooth Keyboard with TrackPoint"
+	depends on HID
+	---help---
+	Support for the Lenovo ThinkPad Compact Bluetooth Keyboard with TrackPoint.
+
+	Say Y here if you have a Lenovo ThinkPad Compact Bluetooth Keyboard with
+	TrackPoint and would like to use the function keys as function keys, as
+	well as letting linux recognise the special functions such as brightness.
+
 config HID_LOGITECH
 	tristate "Logitech devices" if EXPERT
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 30e4431..c0a2f89 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_HID_KEYTOUCH)	+= hid-keytouch.o
 obj-$(CONFIG_HID_KYE)		+= hid-kye.o
 obj-$(CONFIG_HID_LCPOWER)       += hid-lcpower.o
 obj-$(CONFIG_HID_LENOVO_TPKBD)	+= hid-lenovo-tpkbd.o
+obj-$(CONFIG_HID_LENOVO_CBTKBD)	+= hid-lenovo-tpcompactkbd.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
 obj-$(CONFIG_HID_LOGITECH_DJ)	+= hid-logitech-dj.o
 obj-$(CONFIG_HID_MAGICMOUSE)    += hid-magicmouse.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 253fe23..77bce8f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1734,6 +1734,9 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #if IS_ENABLED(CONFIG_HID_LENOVO_TPKBD)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
 #endif
+#if IS_ENABLED(CONFIG_HID_LENOVO_CBTKBD)
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CBTKBD) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..6802166 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -539,6 +539,7 @@
 
 #define USB_VENDOR_ID_LENOVO		0x17ef
 #define USB_DEVICE_ID_LENOVO_TPKBD	0x6009
+#define USB_DEVICE_ID_LENOVO_CBTKBD	0x6048
 
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
diff --git a/drivers/hid/hid-lenovo-tpcompactkbd.c b/drivers/hid/hid-lenovo-tpcompactkbd.c
new file mode 100644
index 0000000..0fd085b
--- /dev/null
+++ b/drivers/hid/hid-lenovo-tpcompactkbd.c
@@ -0,0 +1,191 @@
+/*
+ *  ThinkPad Compact (Bluetooth|USB) Keyboard with TrackPoint
+ *
+ *  Copyright (c) 2014 Jamie Lentin <jm@lentin.co.uk>
+ *
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
+
+#include "hid-ids.h"
+
+static unsigned int fnmode;
+module_param(fnmode, uint, 0644);
+MODULE_PARM_DESC(fnmode, "Fn lock mode ([0] = normal (Fn Lock toggles), 1 = Permanently on, 2 = Permanently off)");
+
+struct tpcompactkbd_sc {
+	unsigned int fn_lock;
+};
+
+/* Send a config command to the keyboard */
+static int tpcompactkbd_send_cmd(struct hid_device *hdev,
+			unsigned char byte2, unsigned char byte3)
+{
+	unsigned char buf[] = {0x18, byte2, byte3};
+
+	return hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
+						HID_OUTPUT_REPORT);
+}
+
+/* Toggle fnlock on or off, if fnmode allows */
+static void tpcompactkbd_toggle_fnlock(struct hid_device *hdev)
+{
+	struct tpcompactkbd_sc *tpcsc = hid_get_drvdata(hdev);
+
+	tpcsc->fn_lock = fnmode == 2 ? 0 : fnmode == 1 ? 1 : !tpcsc->fn_lock;
+	if (tpcompactkbd_send_cmd(hdev, 0x05, tpcsc->fn_lock ? 0x01 : 0x00))
+		hid_err(hdev, "Fn-lock toggle failed\n");
+}
+
+/*
+ * Keyboard sends non-standard reports for most "hotkey" Fn functions.
+ * Map these back to regular keys.
+ *
+ * Esc:	KEY_FN_ESC		FnLock
+ * (F1--F3 are regular keys)
+ * F4:	KEY_MICMUTE		Mic Mute
+ * F5:	KEY_BRIGHTNESSDOWN	Brightness down
+ * F6:	KEY_BRIGHTNESSUP	Brightness up
+ * F7:	KEY_SWITCHVIDEOMODE	External display (projector)
+ * F8:	KEY_FN_F8		Wireless
+ * F9:	KEY_CONFIG		Control panel / settings
+ * F10:	KEY_SEARCH		Search
+ * F11:	KEY_FN_F11		View open applications (3 boxes)
+ * F12:	KEY_FN_F12		Open My computer (6 boxes)
+ */
+
+#define tpckbd_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
+					EV_KEY, (c))
+static int tpcompactkbd_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_CONSUMER) {
+		set_bit(EV_REP, hi->input->evbit);
+		switch (usage->hid & HID_USAGE) {
+		case 0x03f1:
+			tpckbd_map_key_clear(KEY_FN_F8);
+			return 1;
+		case 0x0221:
+			tpckbd_map_key_clear(KEY_SEARCH);
+			return 1;
+		case 0x03f2:
+			tpckbd_map_key_clear(KEY_FN_F12);
+			return 1;
+		}
+	}
+
+	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_MSVENDOR) {
+		set_bit(EV_REP, hi->input->evbit);
+		switch (usage->hid & HID_USAGE) {
+		case 0x00f0:
+			tpckbd_map_key_clear(KEY_FN_ESC);
+			return 1;
+		case 0x00f1:
+			tpckbd_map_key_clear(KEY_MICMUTE);
+			return 1;
+		case 0x00f2:
+			tpckbd_map_key_clear(KEY_BRIGHTNESSDOWN);
+			return 1;
+		case 0x00f3:
+			tpckbd_map_key_clear(KEY_BRIGHTNESSUP);
+			return 1;
+		case 0x00f4:
+			tpckbd_map_key_clear(KEY_SWITCHVIDEOMODE);
+			return 1;
+		case 0x00f5:
+			tpckbd_map_key_clear(KEY_FN_F8);
+			return 1;
+		case 0x00f6:
+			tpckbd_map_key_clear(KEY_CONFIG);
+			return 1;
+		case 0x00f8:
+			tpckbd_map_key_clear(KEY_FN_F11);
+			return 1;
+		case 0x00fa:
+			tpckbd_map_key_clear(KEY_FN_ESC);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int tpcompactkbd_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	/* Switch fn-lock on fn-esc */
+	if (unlikely(usage->code == KEY_FN_ESC && value))
+		tpcompactkbd_toggle_fnlock(hdev);
+
+	return 0;
+}
+
+static int tpcompactkbd_probe(struct hid_device *hdev,
+			const struct hid_device_id *id)
+{
+	int ret;
+	struct tpcompactkbd_sc *tpcsc;
+
+	tpcsc = devm_kzalloc(&hdev->dev, sizeof(*tpcsc), GFP_KERNEL);
+	if (tpcsc == NULL) {
+		hid_err(hdev, "can't alloc keyboard descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, tpcsc);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "hid_parse failed\n");
+		return ret;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "hid_hw_start failed\n");
+		return ret;
+	}
+
+	/*
+	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
+	 * regular keys
+	 */
+	ret = tpcompactkbd_send_cmd(hdev, 0x01, 0x03);
+	if (ret)
+		hid_warn(hdev, "Failed to switch F7/9/11 into regular keys\n");
+
+	/* Toggle once to init the state of fn-lock */
+	tpcsc->fn_lock = 0;
+	tpcompactkbd_toggle_fnlock(hdev);
+
+	return 0;
+}
+
+static const struct hid_device_id tpcompactkbd_devices[] = {
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CBTKBD) },
+
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, tpcompactkbd_devices);
+
+static struct hid_driver tpcompactkbd_driver = {
+	.name = "lenovo_tpcompactkbd",
+	.id_table = tpcompactkbd_devices,
+	.input_mapping = tpcompactkbd_input_mapping,
+	.probe = tpcompactkbd_probe,
+	.event = tpcompactkbd_event,
+};
+module_hid_driver(tpcompactkbd_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Lentin <jm@lentin.co.uk>");
+MODULE_DESCRIPTION("ThinkPad Compact Keyboard with TrackPoint input driver");
-- 
1.8.5.2

