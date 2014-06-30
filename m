Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaF3VbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:31:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaF3V0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 04/15] Input - wacom: use HID core to actually fetch the report descriptor
Date: Mon, 30 Jun 2014 17:26:15 -0400
Message-Id: <1404163586-29582-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID core already retrieves the report descritor. There is no need
to ask ourself for one.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 70 ++++++----------------------------------
 1 file changed, 10 insertions(+), 60 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index eb39314..cd3d936 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -15,9 +15,6 @@
 #include "wacom.h"
 #include <linux/hid.h>
 
-/* defines to get HID report descriptor */
-#define HID_DEVICET_HID		(USB_TYPE_CLASS | 0x01)
-#define HID_DEVICET_REPORT	(USB_TYPE_CLASS | 0x02)
 #define HID_HDESC_USAGE_UNDEFINED	0x00
 #define HID_HDESC_USAGE_PAGE		0x05
 #define HID_HDESC_USAGE			0x09
@@ -25,15 +22,6 @@
 #define HID_HDESC_COLLECTION_LOGICAL	0x02
 #define HID_HDESC_COLLECTION_END	0xc0
 
-struct wac_hid_descriptor {
-	struct usb_descriptor_header header;
-	__le16   bcdHID;
-	u8       bCountryCode;
-	u8       bNumDescriptors;
-	u8       bDescriptorType;
-	__le16   wDescriptorLength;
-} __attribute__ ((packed));
-
 #define WAC_MSG_RETRIES		5
 
 #define WAC_CMD_LED_CONTROL	0x20
@@ -230,39 +218,14 @@ static void wacom_retrieve_report_data(struct hid_device *hdev,
  * this after returning from this function.
  */
 static int wacom_parse_hid(struct hid_device *hdev,
-			   struct wac_hid_descriptor *hid_desc,
 			   struct wacom_features *features)
 {
-	struct wacom *wacom = hid_get_drvdata(hdev);
-	struct usb_interface *intf = wacom->intf;
-	struct usb_device *dev = interface_to_usbdev(intf);
-	char limit = 0;
 	/* result has to be defined as int for some devices */
 	int result = 0, touch_max = 0;
 	int i = 0, page = 0, finger = 0, pen = 0;
-	unsigned char *report;
+	unsigned char *report = hdev->rdesc;
 
-	report = kzalloc(hid_desc->wDescriptorLength, GFP_KERNEL);
-	if (!report)
-		return -ENOMEM;
-
-	/* retrive report descriptors */
-	do {
-		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-			USB_REQ_GET_DESCRIPTOR,
-			USB_RECIP_INTERFACE | USB_DIR_IN,
-			HID_DEVICET_REPORT << 8,
-			intf->altsetting[0].desc.bInterfaceNumber, /* interface */
-			report,
-			hid_desc->wDescriptorLength,
-			5000); /* 5 secs */
-	} while (result < 0 && limit++ < WAC_MSG_RETRIES);
-
-	/* No need to parse the Descriptor. It isn't an error though */
-	if (result < 0)
-		goto out;
-
-	for (i = 0; i < hid_desc->wDescriptorLength; i++) {
+	for (i = 0; i < hdev->rsize; i++) {
 
 		switch (report[i]) {
 		case HID_HDESC_USAGE_PAGE:
@@ -452,11 +415,9 @@ static int wacom_parse_hid(struct hid_device *hdev,
 		}
 	}
 
- out:
 	if (!features->touch_max && touch_max)
 		features->touch_max = touch_max;
 	result = 0;
-	kfree(report);
 	return result;
 }
 
@@ -519,8 +480,6 @@ static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 	int error = 0;
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct usb_interface *intf = wacom->intf;
-	struct usb_host_interface *interface = intf->cur_altsetting;
-	struct wac_hid_descriptor *hid_desc;
 
 	/* default features */
 	features->device_type = BTN_TOOL_PEN;
@@ -549,17 +508,7 @@ static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 		goto out;
 	}
 
-	error = usb_get_extra_descriptor(interface, HID_DEVICET_HID, &hid_desc);
-	if (error) {
-		error = usb_get_extra_descriptor(&interface->endpoint[0],
-						 HID_DEVICET_REPORT, &hid_desc);
-		if (error) {
-			hid_err(hdev,
-				"can not retrieve extra class descriptor\n");
-			goto out;
-		}
-	}
-	error = wacom_parse_hid(hdev, hid_desc, features);
+	error = wacom_parse_hid(hdev, features);
 
  out:
 	return error;
@@ -1299,6 +1248,13 @@ static int wacom_probe(struct hid_device *hdev,
 	hid_set_drvdata(hdev, wacom);
 	wacom->hdev = hdev;
 
+	/* ask for the report descriptor to be loaded by HID */
+	error = hid_parse(hdev);
+	if (error) {
+		hid_err(hdev, "parse failed\n");
+		goto fail1;
+	}
+
 	wacom_wac = &wacom->wacom_wac;
 	wacom_wac->features = *((struct wacom_features *)id->driver_data);
 	features = &wacom_wac->features;
@@ -1392,12 +1348,6 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom_query_tablet_data(hdev, features);
 
 	/* Regular HID work starts now */
-	error = hid_parse(hdev);
-	if (error) {
-		hid_err(hdev, "parse failed\n");
-		goto fail4;
-	}
-
 	error = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
 	if (error) {
 		hid_err(hdev, "hw start failed\n");
-- 
2.0.0

