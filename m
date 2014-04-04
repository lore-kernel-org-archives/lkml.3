Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaDDRO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:14:29 -0400
Received: from smtp04.udag.de ([62.146.106.30]:34922 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaDDRN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:13:26 -0400
From: Tolga Cakir <tolga@cevel.net>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tolga Cakir <tolga@cevel.net>
Subject: [PATCH 2/4] HID: microsoft: initial support for Microsoft Sidewinder X4 / X6 keyboards
Date: Fri,  4 Apr 2014 19:06:56 +0200
Message-Id: <1396631216-11726-1-git-send-email-tolga@cevel.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will let hid-microsoft handle the Microsoft Sidewinder X4 and X6 keyboards.

Signed-off-by: Tolga Cakir <tolga@cevel.net>
---
 drivers/hid/hid-core.c      |   2 +
 drivers/hid/hid-ids.h       |   2 +
 drivers/hid/hid-microsoft.c | 114 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index dbe548b..5de5ba1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1815,6 +1815,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X6) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K_JP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 548c1a5..21be65d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -626,6 +626,8 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_BT	0x0701
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
+#define USB_DEVICE_ID_SIDEWINDER_X6	0x074b
+#define USB_DEVICE_ID_SIDEWINDER_X4	0x0768
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
 #define USB_DEVICE_ID_MS_TOUCH_COVER_2	0x07a7
 #define USB_DEVICE_ID_MS_TYPE_COVER_2	0x07a9
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 0a61403..5b5d40f 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -29,12 +29,28 @@
 #define MS_NOGET		0x10
 #define MS_DUPLICATE_USAGES	0x20
 #define MS_RDESC_3K		0x40
+#define MS_SIDEWINDER	0x80
 
 struct ms_data {
 	unsigned long quirks;
 	void *extra;
 };
 
+/*
+ * For Sidewinder X4 / X6 devices.
+ * @profile: for storing profile status.
+ * @status: holds information about LED states and numpad mode (X6
+ * only). The 1st bit is for numpad mode, bits 2 - 7 are reserved for
+ * LED configuration and the last bit is currently unused.
+ * @key_mask: holds information about pressed special keys. It's
+ * readable via sysfs, so user-space tools can handle keys.
+ */
+struct ms_sidewinder_extra {
+	unsigned profile;
+	__u8 status;
+	unsigned long key_mask;
+};
+
 static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
@@ -143,6 +159,56 @@ static int ms_presenter_8k_quirk(struct hid_input *hi, struct hid_usage *usage,
 	return 1;
 }
 
+static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	set_bit(EV_REP, hi->input->evbit);
+	switch (usage->hid & HID_USAGE) {
+	/*
+	 * Registering Sidewinder X4 / X6 special keys. S1 - S6 macro keys
+	 * are shared between Sidewinder X4 & X6 and are programmable.
+	 */
+	case 0xfb01: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S1 */
+	case 0xfb02: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S2 */
+	case 0xfb03: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S3 */
+	case 0xfb04: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S4 */
+	case 0xfb05: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S5 */
+	case 0xfb06: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S6 */
+	/* S7 - S30 macro keys are only present on the Sidewinder X6 */
+	case 0xfb07: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S7 */
+	case 0xfb08: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S8 */
+	case 0xfb09: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S9 */
+	case 0xfb0a: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S10 */
+	case 0xfb0b: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S11 */
+	case 0xfb0c: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S12 */
+	case 0xfb0d: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S13 */
+	case 0xfb0e: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S14 */
+	case 0xfb0f: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S15 */
+	case 0xfb10: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S16 */
+	case 0xfb11: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S17 */
+	case 0xfb12: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S18 */
+	case 0xfb13: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S19 */
+	case 0xfb14: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S20 */
+	case 0xfb15: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S21 */
+	case 0xfb16: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S22 */
+	case 0xfb17: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S23 */
+	case 0xfb18: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S24 */
+	case 0xfb19: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S25 */
+	case 0xfb1a: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S26 */
+	case 0xfb1b: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S27 */
+	case 0xfb1c: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S28 */
+	case 0xfb1d: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S29 */
+	case 0xfb1e: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S30 */
+	/* Not programmable keys: Profile, Game Center (X6 only) and Macro */
+	case 0xfd11: ms_map_key_clear(KEY_GAMES);	break;	/* X6: Game Center*/
+	case 0xfd12: ms_map_key_clear(KEY_MACRO);	break;	/* Macro */
+	case 0xfd15: ms_map_key_clear(KEY_UNKNOWN);	break;	/* Profile */
+	default:
+		return 0;
+	}
+	return 1;
+}
+
 static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -159,6 +225,10 @@ static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			ms_presenter_8k_quirk(hi, usage, bit, max))
 		return 1;
 
+	if ((sc->quirks & MS_SIDEWINDER) &&
+			ms_sidewinder_kb_quirk(hi, usage, bit, max))
+		return 1;
+
 	return 0;
 }
 
@@ -229,6 +299,34 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		return 1;
 	}
 
+	/*
+	 * Sidewinder special button handling & profile switching
+	 *
+	 * Pressing S1 - S30 macro keys will not send out any keycodes, but
+	 * set bits on key_mask (readable via sysfs). It's possible to press
+	 * multiple special keys at the same time.
+	 */
+	if (sc->quirks & MS_SIDEWINDER) {
+		struct input_dev *input = field->hidinput->input;
+		struct ms_sidewinder_extra *sidewinder = sc->extra;
+		int i;
+
+		for (i = 0; i <= 29; i++) {	/* Run through S1 - S30 keys */
+			if ((usage->hid & HID_USAGE) == (0xfb01 + i)) {
+				value ? set_bit(i, &sidewinder->key_mask) : clear_bit(i, &sidewinder->key_mask);
+				break;	/* Exit loop, when correct hid usage has been found */
+			}
+		}
+
+		switch (usage->hid & HID_USAGE) {
+		case 0xfd11: input_event(input, usage->type, KEY_GAMES, value);	break;
+		case 0xfd12: input_event(input, usage->type, KEY_MACRO, value);	break;
+		case 0xfd15: value ? set_bit(30, &sidewinder->key_mask) : clear_bit(30, &sidewinder->key_mask);	break;
+		}
+
+		return 1;
+	}
+
 	return 0;
 }
 
@@ -249,6 +347,18 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (sc->quirks & MS_NOGET)
 		hdev->quirks |= HID_QUIRK_NOGET;
 
+	if (sc->quirks & MS_SIDEWINDER) {
+		struct ms_sidewinder_extra *sidewinder;
+
+		sidewinder = devm_kzalloc(&hdev->dev, sizeof(struct ms_sidewinder_extra),
+					GFP_KERNEL);
+		if (!sidewinder) {
+			hid_err(hdev, "can't alloc microsoft descriptor\n");
+			return -ENOMEM;
+		}
+		sc->extra = sidewinder;
+	}
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
@@ -270,6 +380,10 @@ err_free:
 static const struct hid_device_id ms_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV),
 		.driver_data = MS_HIDINPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X6),
+		.driver_data = MS_SIDEWINDER },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X4),
+		.driver_data = MS_SIDEWINDER },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB),
 		.driver_data = MS_ERGONOMY },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K),
-- 
1.9.1

