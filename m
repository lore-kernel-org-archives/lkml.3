Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3LSQXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:23:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3LSQXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:23:21 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Edel Maks <edelmaks@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/3] HID: multitouch: add support of other generic collections in hid-mt
Date: Thu, 19 Dec 2013 11:23:11 -0500
Message-Id: <1387470191-9725-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ANTEC Touch Pad is a device which can switch from a multitouch
touchpad to a mouse. It thus presents several generic collections which
are currently ignored by hid-multitouch. Enable them by using the generic
protocol. Adding also a suffix for them depending on their application.

Reported-by: Edel Maks <edelmaks@gmail.com>
Tested-by: Edel Maks <edelmaks@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/hid.h          |  3 +++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2bf397f..4221494 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -67,6 +67,9 @@
 #define USB_VENDOR_ID_ALPS		0x0433
 #define USB_DEVICE_ID_IBM_GAMEPAD	0x1101
 
+#define USB_VENDOR_ID_ANTON		0x1130
+#define USB_DEVICE_ID_ANTON_TOUCH_PAD	0x3101
+
 #define USB_VENDOR_ID_APPLE		0x05ac
 #define USB_DEVICE_ID_APPLE_MIGHTYMOUSE	0x0304
 #define USB_DEVICE_ID_APPLE_MAGICMOUSE	0x030d
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4dd6c6c..502e5bb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -84,6 +84,7 @@ struct mt_class {
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
 	__u8 maxcontacts;
 	bool is_indirect;	/* true for touchpads */
+	bool export_all_inputs;	/* do not ignore mouse, keyboards, etc... */
 };
 
 struct mt_fields {
@@ -217,6 +218,7 @@ static struct mt_protocol mt_protocol_ignore = { 0 };
 #define MT_CLS_FLATFROG				0x0107
 #define MT_CLS_GENERALTOUCH_TWOFINGERS		0x0108
 #define MT_CLS_GENERALTOUCH_PWT_TENFINGERS	0x0109
+#define MT_CLS_ANTON_TP				0x010a
 
 #define MT_DEFAULT_MAXCONTACT	10
 #define MT_MAX_MAXCONTACT	250
@@ -329,13 +331,18 @@ static struct mt_class mt_classes[] = {
 		.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_SLOT_IS_CONTACTID
 	},
-
 	{ .name = MT_CLS_FLATFROG,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_NO_AREA,
 		.sn_move = 2048,
 		.maxcontacts = 40,
 	},
+	{ .name = MT_CLS_ANTON_TP,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE,
+		.is_indirect = true,
+		.export_all_inputs = true,
+	},
 	{ }
 };
 
@@ -846,10 +853,32 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct mt_device *td = hid_get_drvdata(hdev);
 	unsigned report_id = field->report->id;
 
+	if (td->mtclass.export_all_inputs) {
+		td->protocols[report_id] = mt_protocol_generic;
+		switch (field->application) {
+		case HID_GD_KEYPAD:
+			td->protocols[report_id].suffix = "Keypad";
+			break;
+		case HID_GD_MOUSE:
+			td->protocols[report_id].suffix = "Mouse";
+			break;
+		case HID_DG_TOUCHSCREEN:
+			td->protocols[report_id].suffix = "Touchscreen";
+			break;
+		case HID_GD_SYSTEM_CONTROL:
+			td->protocols[report_id].suffix = "System Control";
+			break;
+		case HID_CP_CONSUMER_CONTROL:
+			td->protocols[report_id].suffix = "Consumer Control";
+			break;
+		}
+	}
+
 	/* Only map fields from TouchScreen or TouchPad collections.
 	* We need to ignore fields that belong to other collections
 	* such as Mouse that might have the same GenericDesktop usages. */
-	if (field->application != HID_DG_TOUCHSCREEN &&
+	if (!td->mtclass.export_all_inputs &&
+	    field->application != HID_DG_TOUCHSCREEN &&
 	    field->application != HID_DG_PEN &&
 	    field->application != HID_DG_TOUCHPAD)
 		td->protocols[report_id] = mt_protocol_ignore;
@@ -859,8 +888,11 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 
 	else if (field->application == HID_DG_TOUCHSCREEN ||
 	    field->application == HID_DG_PEN ||
-	    field->application == HID_DG_TOUCHPAD)
+	    field->application == HID_DG_TOUCHPAD) {
 		td->protocols[report_id] = mt_protocol_touch;
+		if (td->mtclass.export_all_inputs)
+			td->protocols[report_id].suffix = "Touch";
+	}
 
 	if (td->protocols[report_id].input_mapping)
 		return td->protocols[report_id].input_mapping(hdev, hi,
@@ -1128,6 +1160,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
+	/* Anton Touch Pad */
+	{ .driver_data = MT_CLS_ANTON_TP,
+		MT_USB_DEVICE(USB_VENDOR_ID_ANTON,
+			USB_DEVICE_ID_ANTON_TOUCH_PAD) },
+
 	/* Atmel panels */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 31b9d29..2b2041a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -201,6 +201,7 @@ struct hid_item {
 #define HID_GD_VBRZ		0x00010045
 #define HID_GD_VNO		0x00010046
 #define HID_GD_FEATURE		0x00010047
+#define HID_GD_SYSTEM_CONTROL	0x00010080
 #define HID_GD_UP		0x00010090
 #define HID_GD_DOWN		0x00010091
 #define HID_GD_RIGHT		0x00010092
@@ -208,6 +209,8 @@ struct hid_item {
 
 #define HID_DC_BATTERYSTRENGTH	0x00060020
 
+#define HID_CP_CONSUMER_CONTROL	0x000c0001
+
 #define HID_DG_DIGITIZER	0x000d0001
 #define HID_DG_PEN		0x000d0002
 #define HID_DG_LIGHTPEN		0x000d0003
-- 
1.8.3.1

