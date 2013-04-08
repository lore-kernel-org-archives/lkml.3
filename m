Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138Ab3DHQcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935022Ab3DHQb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:31:57 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Bastien Nocera <hadess@hadess.net>, Fabien <fabien.andre@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: appleir: add support for Apple ir devices
Date: Mon,  8 Apr 2013 18:30:51 +0200
Message-Id: <1365438651-32623-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was originally written by James McKenzie, updated by
Greg Kroah-Hartman, further updated by Bastien Nocera, with suspend
support added.
I ported it to the HID subsystem, in order to simplify it a litle
and allow lirc to use it through hiddev.

More recent versions of the IR receiver are also supported through
a patch by Alex Karpenko. The patch also adds support for the 2nd
and 5th generation of the controller, and the menu key on newer
brushed metal remotes.

Tested-by: Fabien André <fabien.andre@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Hi guys,

this is the re-spin of Bastien's patch submitted last november.
I ported it to use the hid subsystem, reducing the size of the driver
to 355 lines instead of 527.

any comments are welcome!

Cheers,
Benjamin

 drivers/hid/Kconfig       |  11 ++
 drivers/hid/Makefile      |   1 +
 drivers/hid/hid-apple.c   |   4 -
 drivers/hid/hid-appleir.c | 355 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c    |   7 +-
 drivers/hid/hid-ids.h     |   5 +-
 6 files changed, 376 insertions(+), 7 deletions(-)
 create mode 100644 drivers/hid/hid-appleir.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 613083a..034b0c9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -122,6 +122,17 @@ config HID_APPLE
 	Say Y here if you want support for keyboards of	Apple iBooks, PowerBooks,
 	MacBooks, MacBook Pros and Apple Aluminum.
 
+config HID_APPLEIR
+	tristate "Apple infrared receiver"
+	depends on (USB_HID)
+	---help---
+	Support for Apple infrared remote control. All the Apple computers from
+	  2005 onwards include such a port, except the unibody Macbook (2009),
+	  and Mac Pros. This receiver is also used in the Apple TV set-top box
+	  prior to the 2010 model.
+
+	Say Y here if you want support for Apple infrared remote control.
+
 config HID_AUREAL
 	tristate "Aureal"
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 2735151..2065694 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -39,6 +39,7 @@ endif
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
+obj-$(CONFIG_HID_APPLEIR)	+= hid-appleir.o
 obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 9e0c4fbb..feae88b 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -389,10 +389,6 @@ static void apple_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id apple_devices[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL),
-		.driver_data = APPLE_HIDDEV | APPLE_IGNORE_HIDINPUT },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4),
-		.driver_data = APPLE_HIDDEV | APPLE_IGNORE_HIDINPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE),
 		.driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
 
diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
new file mode 100644
index 0000000..2aff98f
--- /dev/null
+++ b/drivers/hid/hid-appleir.c
@@ -0,0 +1,355 @@
+/*
+ * HID driver for the apple ir device
+ *
+ * Original driver written by James McKenzie
+ * Ported to recent 2.6 kernel versions by Greg Kroah-Hartman <gregkh@suse.de>
+ * Updated to support newer remotes by Bastien Nocera <hadess@hadess.net>
+ * Ported to HID subsystem by Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ *
+ * Copyright (C) 2006 James McKenzie
+ * Copyright (C) 2008 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (C) 2008 Novell Inc.
+ * Copyright (C) 2010, 2012 Bastien Nocera <hadess@hadess.net>
+ * Copyright (C) 2013 Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ * Copyright (C) 2013 Red Hat Inc. All Rights Reserved
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include "hid-ids.h"
+
+MODULE_AUTHOR("James McKenzie");
+MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@redhat.com>");
+MODULE_DESCRIPTION("HID Apple IR remote controls");
+MODULE_LICENSE("GPL");
+
+#define KEY_MASK		0x0F
+#define TWO_PACKETS_MASK	0x40
+
+#define appleir_dbg(hid, fmt, arg...)					  \
+do {									  \
+	if (debug)							  \
+		dev_dbg(&(hid)->dev, fmt, ##arg); \
+} while (0)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Enable extra debug messages and information");
+
+/* James McKenzie has two devices both of which report the following */
+/* 25 87 ee 83 0a	+  */
+/* 25 87 ee 83 0c	-  */
+/* 25 87 ee 83 09	<< */
+/* 25 87 ee 83 06	>> */
+/* 25 87 ee 83 05	>" */
+/* 25 87 ee 83 03	menu */
+/* 26 00 00 00 00	for key repeat*/
+
+/* Thomas Glanzmann reports the following responses */
+/* 25 87 ee ca 0b	+  */
+/* 25 87 ee ca 0d	-  */
+/* 25 87 ee ca 08	<< */
+/* 25 87 ee ca 07	>> */
+/* 25 87 ee ca 04	>" */
+/* 25 87 ee ca 02	menu */
+/* 26 00 00 00 00       for key repeat*/
+/* He also observes the following event sometimes */
+/* sent after a key is release, which I interpret */
+/* as a flat battery message */
+/* 25 87 e0 ca 06	flat battery */
+
+/* Alexandre Karpenko reports the following responses for Device ID 0x8242 */
+/* 25 87 ee 47 0b	+  */
+/* 25 87 ee 47 0d	-  */
+/* 25 87 ee 47 08	<< */
+/* 25 87 ee 47 07	>> */
+/* 25 87 ee 47 04	>" */
+/* 25 87 ee 47 02	menu */
+/* 26 87 ee 47 **	for key repeat (** is the code of the key being held) */
+
+/* Bastien Nocera's remote */
+/* 25 87 ee 91 5f	followed by
+ * 25 87 ee 91 05	gives you >"
+ *
+ * 25 87 ee 91 5c	followed by
+ * 25 87 ee 91 05	gives you the middle button */
+
+/* Fabien Andre's remote */
+/* 25 87 ee a3 5e	followed by
+ * 25 87 ee a3 04	gives you >"
+ *
+ * 25 87 ee a3 5d	followed by
+ * 25 87 ee a3 04	gives you the middle button */
+
+static const unsigned short appleir_key_table[] = {
+	KEY_RESERVED,
+	KEY_MENU,
+	KEY_PLAYPAUSE,
+	KEY_FORWARD,
+	KEY_BACK,
+	KEY_VOLUMEUP,
+	KEY_VOLUMEDOWN,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_ENTER,
+	KEY_PLAYPAUSE,
+	KEY_RESERVED,
+};
+
+struct appleir {
+	struct input_dev *input_dev;
+	struct hid_device *hid;
+	unsigned short keymap[ARRAY_SIZE(appleir_key_table)];
+	struct timer_list key_up_timer;	/* timer for key up */
+	spinlock_t lock;		/* protects .current_key */
+	int current_key;		/* the currently pressed key */
+	int prev_key_idx;		/* key index in a 2 packets message */
+};
+
+static void dump_packet(struct appleir *appleir, char *msg, u8 *data, int len)
+{
+	appleir_dbg(appleir->hid,
+		    "appleir: %s (%d bytes) %*ph (should be command %d)\n",
+		    msg, len, len, data, (data[4] >> 1) & KEY_MASK);
+}
+
+static int get_key(int data)
+{
+	/*
+	 * The indexes of the keys are computed like this:
+	 * 0x00 or 0x01 (        )	key:   0	-> KEY_RESERVED
+	 * 0x02 or 0x03 (  menu  )	key:   1	-> KEY_MENU
+	 * 0x04 or 0x05 (   >"   )	key:   2	-> KEY_PLAYPAUSE
+	 * 0x06 or 0x07 (   >>   )	key:   3	-> KEY_FORWARD
+	 * 0x08 or 0x09 (   <<   )	key:   4	-> KEY_BACK
+	 * 0x0a or 0x0b (    +   )	key:   5	-> KEY_VOLUMEUP
+	 * 0x0c or 0x0d (    -   )	key:   6	-> KEY_VOLUMEDOWN
+	 * 0x0e or 0x0f (        )	key:   7	-> KEY_RESERVED
+	 * 0x50 or 0x51 (        )	key:  -8	-> KEY_RESERVED
+	 * 0x52 or 0x53 (        )	key:  -9	-> KEY_RESERVED
+	 * 0x54 or 0x55 (        )	key: -10	-> KEY_RESERVED
+	 * 0x56 or 0x57 (        )	key: -11	-> KEY_RESERVED
+	 * 0x58 or 0x59 (        )	key: -12	-> KEY_RESERVED
+	 * 0x5a or 0x5b (        )	key: -13	-> KEY_RESERVED
+	 * 0x5c or 0x5d ( middle )	key: -14	-> KEY_ENTER
+	 * 0x5e or 0x5f (   >"   )	key: -15	-> KEY_PLAYPAUSE
+	 */
+	int key = (data >> 1) & KEY_MASK;
+
+	if ((data & TWO_PACKETS_MASK))
+		/* Part of a 2 packet-command */
+		key = -key;
+
+	return key;
+}
+
+static void key_up(struct hid_device *hid, struct appleir *appleir, int key)
+{
+	appleir_dbg(hid, "key %d up\n", key);
+	input_report_key(appleir->input_dev, key, 0);
+	input_sync(appleir->input_dev);
+}
+
+static void key_down(struct hid_device *hid, struct appleir *appleir, int key)
+{
+	appleir_dbg(hid, "key %d down\n", key);
+	input_report_key(appleir->input_dev, key, 1);
+	input_sync(appleir->input_dev);
+}
+
+static void battery_flat(struct appleir *appleir)
+{
+	dev_err(&appleir->input_dev->dev, "possible flat battery?\n");
+}
+
+static void key_up_tick(unsigned long data)
+{
+	struct appleir *appleir = (struct appleir *)data;
+	struct hid_device *hid = appleir->hid;
+	unsigned long flags;
+
+	spin_lock_irqsave(&appleir->lock, flags);
+	if (appleir->current_key) {
+		key_up(hid, appleir, appleir->current_key);
+		appleir->current_key = 0;
+	}
+	spin_unlock_irqrestore(&appleir->lock, flags);
+}
+
+static int appleir_raw_event(struct hid_device *hid, struct hid_report *report,
+	 u8 *data, int len)
+{
+	struct appleir *appleir = hid_get_drvdata(hid);
+	static const u8 keydown[] = { 0x25, 0x87, 0xee };
+	static const u8 keyrepeat[] = { 0x26, };
+	static const u8 flatbattery[] = { 0x25, 0x87, 0xe0 };
+	unsigned long flags;
+
+	if (debug)
+		dump_packet(appleir, "received", data, len);
+
+	if (len != 5)
+		goto out;
+
+	if (!memcmp(data, keydown, sizeof(keydown))) {
+		int index;
+
+		spin_lock_irqsave(&appleir->lock, flags);
+		/* If we already have a key down, take it up before marking
+		   this one down */
+		if (appleir->current_key)
+			key_up(hid, appleir, appleir->current_key);
+
+		/* Handle dual packet commands */
+		if (appleir->prev_key_idx > 0)
+			index = appleir->prev_key_idx;
+		else
+			index = get_key(data[4]);
+
+		if (index >= 0) {
+			appleir->current_key = appleir->keymap[index];
+
+			key_down(hid, appleir, appleir->current_key);
+			/* Remote doesn't do key up, either pull them up, in
+			 * the test above, or here set a timer which pulls
+			 * them up after 1/8 s */
+			mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
+			appleir->prev_key_idx = 0;
+		} else
+			/* Remember key for next packet */
+			appleir->prev_key_idx = -index;
+		spin_unlock_irqrestore(&appleir->lock, flags);
+		goto out;
+	}
+
+	appleir->prev_key_idx = 0;
+
+	if (!memcmp(data, keyrepeat, sizeof(keyrepeat))) {
+		key_down(hid, appleir, appleir->current_key);
+		/* Remote doesn't do key up, either pull them up, in the test
+		   above, or here set a timer which pulls them up after 1/8 s */
+		mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
+		goto out;
+	}
+
+	if (!memcmp(data, flatbattery, sizeof(flatbattery))) {
+		battery_flat(appleir);
+		/* Fall through */
+	}
+
+	dump_packet(appleir, "unknown packet", data, len);
+
+out:
+	/* let hidraw and hiddev handle the report */
+	return 0;
+}
+
+static void appleir_input_configured(struct hid_device *hid,
+		struct hid_input *hidinput)
+{
+	struct input_dev *input_dev = hidinput->input;
+	struct appleir *appleir = hid_get_drvdata(hid);
+	int i;
+
+	appleir->input_dev = input_dev;
+
+	input_dev->keycode = appleir->keymap;
+	input_dev->keycodesize = sizeof(unsigned short);
+	input_dev->keycodemax = ARRAY_SIZE(appleir->keymap);
+
+	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+
+	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
+	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
+		set_bit(appleir->keymap[i], input_dev->keybit);
+	clear_bit(KEY_RESERVED, input_dev->keybit);
+}
+
+static int appleir_input_mapping(struct hid_device *hid,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	return -1;
+}
+
+static int appleir_probe(struct hid_device *hid, const struct hid_device_id *id)
+{
+	int ret;
+	struct appleir *appleir;
+
+	appleir = kzalloc(sizeof(struct appleir), GFP_KERNEL);
+	if (!appleir) {
+		ret = -ENOMEM;
+		goto allocfail;
+	}
+
+	appleir->hid = hid;
+
+	spin_lock_init(&appleir->lock);
+	setup_timer(&appleir->key_up_timer,
+		    key_up_tick, (unsigned long) appleir);
+
+	hid_set_drvdata(hid, appleir);
+
+	ret = hid_parse(hid);
+	if (ret) {
+		hid_err(hid, "parse failed\n");
+		goto fail;
+	}
+
+	ret = hid_hw_start(hid, HID_CONNECT_DEFAULT | HID_CONNECT_HIDDEV_FORCE);
+	if (ret) {
+		hid_err(hid, "hw start failed\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	kfree(appleir);
+allocfail:
+	return ret;
+}
+
+static void appleir_remove(struct hid_device *hid)
+{
+	struct appleir *appleir = hid_get_drvdata(hid);
+	del_timer_sync(&appleir->key_up_timer);
+	hid_hw_stop(hid);
+	kfree(appleir);
+}
+
+static const struct hid_device_id appleir_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL3) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL5) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, appleir_devices);
+
+static struct hid_driver appleir_driver = {
+	.name = "appleir",
+	.id_table = appleir_devices,
+	.raw_event = appleir_raw_event,
+	.input_configured = appleir_input_configured,
+	.probe = appleir_probe,
+	.remove = appleir_remove,
+	.input_mapping = appleir_input_mapping,
+};
+module_hid_driver(appleir_driver);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1129f49..ceb419d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1501,8 +1501,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICTRACKPAD) },
@@ -1526,6 +1524,11 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL3) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL5) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b622aec..8dd7295 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -137,8 +137,11 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
-#define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
+#define USB_DEVICE_ID_APPLE_IRCONTROL	0x8240
+#define USB_DEVICE_ID_APPLE_IRCONTROL2	0x1440
+#define USB_DEVICE_ID_APPLE_IRCONTROL3	0x8241
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
+#define USB_DEVICE_ID_APPLE_IRCONTROL5	0x8243
 
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
-- 
1.8.1.4

