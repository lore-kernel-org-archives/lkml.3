Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031243AbaLLSTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:19:04 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:60219 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031120AbaLLSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:18:59 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 12 Dec 2014 10:43:29 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH v3] HID: rmi: Scan the report descriptor to determine if the device is suitable for the hid-rmi driver
Date: Fri, 12 Dec 2014 10:17:26 -0800
Message-ID: <1418408246-5360-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On composite HID devices there may be multiple HID devices on separate
interfaces, but hid-rmi should only bind to the touchpad. The previous version
simply checked that the interface protocol was set to mouse. Unfortuately, it
is not always the case that the touchpad has the mouse interface protocol set.
This patch takes a different approach and scans the report descriptor looking
for the Generic Desktop Pointer usage and the Vendor Specific Top Level
Collection needed by the hid-rmi driver to interface with the device.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Here is the v3 version with Benjamin's comments addressed. I also updated it to
apply to the version of hid-core.c in for-3.19/hid-rmi.

 drivers/hid/hid-core.c | 22 +++++++++++++++++-----
 include/linux/hid.h    |  4 +++-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c3d0ac1..81665b4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -698,6 +698,7 @@ static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
 static void hid_scan_collection(struct hid_parser *parser, unsigned type)
 {
 	struct hid_device *hid = parser->device;
+	int i;
 
 	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
 	    type == HID_COLLECTION_PHYSICAL)
@@ -707,6 +708,14 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
 	    hid->product == USB_DEVICE_ID_MS_TYPE_COVER_3 &&
 	    hid->group == HID_GROUP_MULTITOUCH)
 		hid->group = HID_GROUP_GENERIC;
+
+	if ((parser->global.usage_page << 16) == HID_UP_GENDESK)
+		for (i = 0; i < parser->local.usage_index; i++)
+			if (parser->local.usage[i] == HID_GD_POINTER)
+				parser->scan_flags |= HID_SCAN_FLAG_GD_POINTER;
+
+	if ((parser->global.usage_page << 16) >= HID_UP_MSVENDOR)
+		parser->scan_flags |= HID_SCAN_FLAG_VENDOR_SPECIFIC;
 }
 
 static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
@@ -792,11 +801,14 @@ static int hid_scan_report(struct hid_device *hid)
 		hid->group = HID_GROUP_WACOM;
 		break;
 	case USB_VENDOR_ID_SYNAPTICS:
-		if ((hid->group == HID_GROUP_GENERIC) &&
-		    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
-			/* hid-rmi should only bind to the mouse interface of
-			 * composite USB devices */
-			hid->group = HID_GROUP_RMI;
+		if (hid->group == HID_GROUP_GENERIC)
+			if ((parser->scan_flags & HID_SCAN_FLAG_VENDOR_SPECIFIC)
+			    && (parser->scan_flags & HID_SCAN_FLAG_GD_POINTER))
+				/*
+				 * hid-rmi should take care of them,
+				 * not hid-generic
+				 */
+				hid->group = HID_GROUP_RMI;
 		break;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 06c4607..efc7787 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -574,7 +574,9 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
 #define HID_GLOBAL_STACK_SIZE 4
 #define HID_COLLECTION_STACK_SIZE 4
 
-#define HID_SCAN_FLAG_MT_WIN_8			0x00000001
+#define HID_SCAN_FLAG_MT_WIN_8			BIT(0)
+#define HID_SCAN_FLAG_VENDOR_SPECIFIC		BIT(1)
+#define HID_SCAN_FLAG_GD_POINTER		BIT(2)
 
 struct hid_parser {
 	struct hid_global     global;
-- 
2.1.0

