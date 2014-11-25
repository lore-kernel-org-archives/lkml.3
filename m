Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKYAVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:21:31 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:21463 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbaKYAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:21:27 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 24 Nov 2014 16:44:01 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: Add support for the touchpad in the Razer Blade 14 laptop
Date: Mon, 24 Nov 2014 16:20:19 -0800
Message-ID: <1416874819-9914-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Razer Blade 14 has a Synaptic's TouchPad on one of the interfaces of
a composite USB device. This patch allows the hid-rmi driver to bind
to that interface. It also adds support for the external click buttons
on the Razer's touchpad. External buttons are reported using generic
mouse reports instead of through the F30 like it is on ClickPads.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
This patch depends on the "HID: rmi: Scan the report descriptor to determine if the device is
suitable for the hid-rmi driver" I submitted earlier today to correctly bind to the touchpad HID
device in the composite USB device.

 drivers/hid/hid-core.c |  4 +++-
 drivers/hid/hid-ids.h  |  3 +++
 drivers/hid/hid-rmi.c  | 15 ++++++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index ba9dc59..d69ea16 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -792,7 +792,9 @@ static int hid_scan_report(struct hid_device *hid)
 	/*
 	* Vendor specific handlings
 	*/
-	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
+	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS
+	    || (hid->vendor == USB_VENDOR_ID_RAZER
+	    && hid->product == USB_DEVICE_ID_RAZER_BLADE_14)) &&
 	    (hid->group == HID_GROUP_GENERIC)) {
 		if ((parser->scan_flags & HID_SCAN_FLAG_VENDOR_SPECIFIC)
 		    && (parser->scan_flags & HID_SCAN_FLAG_GENDESK_POINTER))
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 25cd674..c677aad 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -751,6 +751,9 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
 
+#define USB_VENDOR_ID_RAZER		0x1532
+#define USB_DEVICE_ID_RAZER_BLADE_14	0x011D
+
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define USB_DEVICE_ID_REALTEK_READER	0x0152
 
diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 3cccff7..1f131df 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -453,7 +453,15 @@ static int rmi_raw_event(struct hid_device *hdev,
 	case RMI_ATTN_REPORT_ID:
 		return rmi_input_event(hdev, data, size);
 	case RMI_MOUSE_REPORT_ID:
-		rmi_schedule_reset(hdev);
+		/*
+		 * touchpads with physical mouse buttons will report those
+		 * buttons in mouse reports even in RMI mode. Only reset
+		 * the device if we see reports which contain X or Y data.
+		 */
+		if (data[2] != 0 || data[3] != 0)
+			rmi_schedule_reset(hdev);
+		else
+			return 1;
 		break;
 	}
 
@@ -871,6 +879,11 @@ static int rmi_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max)
 {
+	if (field->application == HID_GD_POINTER
+		&& (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
+		/* Pass mouse button reports to generic code for processing */
+		return 0;
+
 	/* we want to make HID ignore the advertised HID collection */
 	return -1;
 }
-- 
2.1.0

