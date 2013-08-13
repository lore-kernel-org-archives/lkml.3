Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3HMO7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121Ab3HMO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:58:30 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: detect Win 8 multitouch devices in core
Date: Tue, 13 Aug 2013 16:58:08 +0200
Message-Id: <1376405889-12378-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detecting Win 8 multitouch devices in core allows us to set quirks
before the device is parsed through hid_hw_start().
It also simplifies the detection of those devices in hid-multitouch and
makes the handling of those devices cleaner.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c       | 12 ++++++++++++
 drivers/hid/hid-multitouch.c | 24 +++++++++++-------------
 include/linux/hid.h          |  2 ++
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d8cdb0a..11c6f2b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -683,6 +683,13 @@ static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
 		parser->flags |= HID_FLAG_MULTITOUCH;
 }
 
+static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
+{
+	if (usage == 0xff0000c5 && parser->global.report_count == 256 &&
+	    parser->global.report_size == 8)
+		parser->flags |= HID_FLAG_WIN_8_CERTIFIED;
+}
+
 static void hid_scan_open_collection(struct hid_parser *parser, unsigned type)
 {
 	if (parser->global.usage_page == HID_UP_SENSOR &&
@@ -710,6 +717,8 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
 	case HID_MAIN_ITEM_TAG_OUTPUT:
 		break;
 	case HID_MAIN_ITEM_TAG_FEATURE:
+		for (i = 0; i < parser->local.usage_index; i++)
+			hid_scan_feature_usage(parser, parser->local.usage[i]);
 		break;
 	default:
 		hid_err(parser->device, "unknown main item tag 0x%x\n",
@@ -779,6 +788,9 @@ out:
 	case HID_FLAG_MULTITOUCH:
 		hid->group = HID_GROUP_MULTITOUCH;
 		break;
+	case HID_FLAG_MULTITOUCH | HID_FLAG_WIN_8_CERTIFIED:
+		hid->group = HID_GROUP_MULTITOUCH_WIN_8;
+		break;
 	case HID_FLAG_SENSOR_HUB:
 		hid->group = HID_GROUP_SENSOR_HUB;
 		break;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0fe00e2..c28ef86 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -133,6 +133,7 @@ static void mt_post_parse(struct mt_device *td);
 #define MT_CLS_NSMU				0x000a
 #define MT_CLS_DUAL_CONTACT_NUMBER		0x0010
 #define MT_CLS_DUAL_CONTACT_ID			0x0011
+#define MT_CLS_WIN_8				0x0012
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -205,6 +206,11 @@ static struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts = 2 },
+	{ .name = MT_CLS_WIN_8,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE },
 
 	/*
 	 * vendor specific classes
@@ -332,19 +338,6 @@ static void mt_feature_mapping(struct hid_device *hdev,
 			td->maxcontacts = td->mtclass.maxcontacts;
 
 		break;
-	case 0xff0000c5:
-		if (field->report_count == 256 && field->report_size == 8) {
-			/* Win 8 devices need special quirks */
-			__s32 *quirks = &td->mtclass.quirks;
-			*quirks |= MT_QUIRK_ALWAYS_VALID;
-			*quirks |= MT_QUIRK_IGNORE_DUPLICATES;
-			*quirks |= MT_QUIRK_HOVERING;
-			*quirks |= MT_QUIRK_CONTACT_CNT_ACCURATE;
-			*quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
-			*quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
-			*quirks &= ~MT_QUIRK_VALID_IS_CONFIDENCE;
-		}
-		break;
 	}
 }
 
@@ -1346,6 +1339,11 @@ static const struct hid_device_id mt_devices[] = {
 
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
+
+	/* Generic Win 8 certified MT device */
+	{  .driver_data = MT_CLS_WIN_8,
+		HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH_WIN_8,
+			HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7d823db..28ee7dd 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -295,6 +295,7 @@ struct hid_item {
 #define HID_GROUP_GENERIC			0x0001
 #define HID_GROUP_MULTITOUCH			0x0002
 #define HID_GROUP_SENSOR_HUB			0x0003
+#define HID_GROUP_MULTITOUCH_WIN_8		0x0004
 
 /*
  * This is the global environment of the parser. This information is
@@ -535,6 +536,7 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
 
 #define HID_FLAG_MULTITOUCH		0x0001
 #define HID_FLAG_SENSOR_HUB		0x0002
+#define HID_FLAG_WIN_8_CERTIFIED	0x0004
 
 struct hid_parser {
 	struct hid_global     global;
-- 
1.8.3.1

