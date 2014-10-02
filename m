Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaJBSY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:24:57 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:37304 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbaJBSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:24:46 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 02 Oct 2014 11:41:33 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: Scan the report descriptor to determine if the device is suitable for the hid-rmi driver
Date: Thu, 2 Oct 2014 11:15:20 -0700
Message-ID: <1412273720-4431-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On composite HID devices there may be multiple HID devices on separate interfaces, but hid-rmi
should only bind to the touchpad. Commit e19ff99f256aeeff6c07b373e01883b72e049552 simply checked
that the interface protocol was set to mouse. Unfortuately, it is not always the case that the
touchpad has the mouse interface protocol set. This patch takes a different approach and scans
the report descriptor looking for the Vendor Specific Top Level Collection and the associated
usages and report IDs needed by the hid-rmi driver to interface with the device.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-core.c | 42 +++++++++++++++++++++++++++++++++++++-----
 include/linux/hid.h    |  8 +++++++-
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 12b6e67..498f674 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -686,6 +686,23 @@ static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
 
 	if (usage == HID_DG_CONTACTID)
 		hid->group = HID_GROUP_MULTITOUCH;
+
+	if (usage == 0xff000004 && parser->global.report_id == 0xb)
+		parser->scan_flags |= HID_SCAN_FLAG_RMI_INPUT_READ;
+
+	if (usage == 0xff000005 && parser->global.report_id == 0xc)
+		parser->scan_flags |= HID_SCAN_FLAG_RMI_ATTN;
+}
+
+static void hid_scan_output_usage(struct hid_parser *parser, u32 usage)
+{
+	struct hid_device *hid = parser->device;
+
+	if (usage == 0xff000002 && parser->global.report_id == 0x9)
+		parser->scan_flags |= HID_SCAN_FLAG_RMI_WRITE;
+
+	if (usage == 0xff000003 && parser->global.report_id == 0xa)
+		parser->scan_flags |= HID_SCAN_FLAG_RMI_OUTPUT_READ;
 }
 
 static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
@@ -693,6 +710,9 @@ static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
 	if (usage == 0xff0000c5 && parser->global.report_count == 256 &&
 	    parser->global.report_size == 8)
 		parser->scan_flags |= HID_SCAN_FLAG_MT_WIN_8;
+
+	if (usage == 0xff000006 && parser->global.report_id == 0xf)
+		parser->scan_flags |= HID_SCAN_FLAG_RMI_MODE;
 }
 
 static void hid_scan_collection(struct hid_parser *parser, unsigned type)
@@ -702,6 +722,9 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
 	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
 	    type == HID_COLLECTION_PHYSICAL)
 		hid->group = HID_GROUP_SENSOR_HUB;
+
+	if ((parser->global.usage_page << 16) == HID_UP_MSVENDOR)
+		parser->scan_flags |= HID_SCAN_FLAG_VENDOR_SPECIFIC;
 }
 
 static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
@@ -725,6 +748,10 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
 			hid_scan_input_usage(parser, parser->local.usage[i]);
 		break;
 	case HID_MAIN_ITEM_TAG_OUTPUT:
+		if (data & HID_MAIN_ITEM_CONSTANT)
+			break;
+		for (i = 0; i < parser->local.usage_index; i++)
+			hid_scan_output_usage(parser, parser->local.usage[i]);
 		break;
 	case HID_MAIN_ITEM_TAG_FEATURE:
 		for (i = 0; i < parser->local.usage_index; i++)
@@ -783,11 +810,16 @@ static int hid_scan_report(struct hid_device *hid)
 	* Vendor specific handlings
 	*/
 	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
-	    (hid->group == HID_GROUP_GENERIC) &&
-	    /* only bind to the mouse interface of composite USB devices */
-	    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
-		/* hid-rmi should take care of them, not hid-generic */
-		hid->group = HID_GROUP_RMI;
+	    (hid->group == HID_GROUP_GENERIC)) {
+		if ((parser->scan_flags & HID_SCAN_FLAG_VENDOR_SPECIFIC)
+			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_WRITE)
+			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_INPUT_READ)
+			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_OUTPUT_READ)
+			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_ATTN)
+			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_MODE))
+			/* hid-rmi should take care of them, not hid-generic */
+			hid->group = HID_GROUP_RMI;
+	}
 
 	/*
 	 * Vendor specific handlings
diff --git a/include/linux/hid.h b/include/linux/hid.h
index f53c4a9..82d1f82 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -547,7 +547,13 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
 #define HID_GLOBAL_STACK_SIZE 4
 #define HID_COLLECTION_STACK_SIZE 4
 
-#define HID_SCAN_FLAG_MT_WIN_8			0x00000001
+#define HID_SCAN_FLAG_MT_WIN_8			BIT(0)
+#define HID_SCAN_FLAG_VENDOR_SPECIFIC		BIT(1)
+#define HID_SCAN_FLAG_RMI_WRITE			BIT(2)
+#define HID_SCAN_FLAG_RMI_INPUT_READ		BIT(3)
+#define HID_SCAN_FLAG_RMI_OUTPUT_READ		BIT(3)
+#define HID_SCAN_FLAG_RMI_ATTN			BIT(4)
+#define HID_SCAN_FLAG_RMI_MODE			BIT(5)
 
 struct hid_parser {
 	struct hid_global     global;
-- 
1.9.1

