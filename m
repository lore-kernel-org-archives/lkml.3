Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaF3V0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaF3V0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:41 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 01/15] Input - wacom: include and use linux/hid.h
Date: Mon, 30 Jun 2014 17:26:12 -0400
Message-Id: <1404163586-29582-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current wacom code redefines constants that are already in linux/hid.h
This patch includes the official implementation and use it accross the code.

There is a conflict with HID_USAGE and others at the same level:
- in the wacom.ko implementation, those are the #define regarding the
  value of the field in the report descriptor
- in the hid.h, those are bitmask
So add HDESC_ in their current definition.

Also, the struct hid_descriptor slightly differs from the linux/hid.h
point of view, so mark it as custom for this driver.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 53 +++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 598efd4..e0c1cb2 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -13,28 +13,19 @@
 
 #include "wacom_wac.h"
 #include "wacom.h"
+#include <linux/hid.h>
 
 /* defines to get HID report descriptor */
 #define HID_DEVICET_HID		(USB_TYPE_CLASS | 0x01)
 #define HID_DEVICET_REPORT	(USB_TYPE_CLASS | 0x02)
-#define HID_USAGE_UNDEFINED		0x00
-#define HID_USAGE_PAGE			0x05
-#define HID_USAGE_PAGE_DIGITIZER	0x0d
-#define HID_USAGE_PAGE_DESKTOP		0x01
-#define HID_USAGE			0x09
-#define HID_USAGE_X			((HID_USAGE_PAGE_DESKTOP << 16) | 0x30)
-#define HID_USAGE_Y			((HID_USAGE_PAGE_DESKTOP << 16) | 0x31)
-#define HID_USAGE_PRESSURE		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x30)
-#define HID_USAGE_X_TILT		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x3d)
-#define HID_USAGE_Y_TILT		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x3e)
-#define HID_USAGE_FINGER		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x22)
-#define HID_USAGE_STYLUS		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x20)
-#define HID_USAGE_CONTACTMAX		((HID_USAGE_PAGE_DIGITIZER << 16) | 0x55)
-#define HID_COLLECTION			0xa1
-#define HID_COLLECTION_LOGICAL		0x02
-#define HID_COLLECTION_END		0xc0
-
-struct hid_descriptor {
+#define HID_HDESC_USAGE_UNDEFINED	0x00
+#define HID_HDESC_USAGE_PAGE		0x05
+#define HID_HDESC_USAGE			0x09
+#define HID_HDESC_COLLECTION		0xa1
+#define HID_HDESC_COLLECTION_LOGICAL	0x02
+#define HID_HDESC_COLLECTION_END	0xc0
+
+struct wac_hid_descriptor {
 	struct usb_descriptor_header header;
 	__le16   bcdHID;
 	u8       bCountryCode;
@@ -301,7 +292,7 @@ static void wacom_retrieve_report_data(struct usb_interface *intf,
  * this after returning from this function.
  */
 static int wacom_parse_hid(struct usb_interface *intf,
-			   struct hid_descriptor *hid_desc,
+			   struct wac_hid_descriptor *hid_desc,
 			   struct wacom_features *features)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
@@ -334,14 +325,14 @@ static int wacom_parse_hid(struct usb_interface *intf,
 	for (i = 0; i < hid_desc->wDescriptorLength; i++) {
 
 		switch (report[i]) {
-		case HID_USAGE_PAGE:
+		case HID_HDESC_USAGE_PAGE:
 			page = report[i + 1];
 			i++;
 			break;
 
-		case HID_USAGE:
+		case HID_HDESC_USAGE:
 			switch (page << 16 | report[i + 1]) {
-			case HID_USAGE_X:
+			case HID_GD_X:
 				if (finger) {
 					features->device_type = BTN_TOOL_FINGER;
 					/* touch device at least supports one touch point */
@@ -420,7 +411,7 @@ static int wacom_parse_hid(struct usb_interface *intf,
 				}
 				break;
 
-			case HID_USAGE_Y:
+			case HID_GD_Y:
 				if (finger) {
 					switch (features->type) {
 					case TABLETPC2FG:
@@ -472,7 +463,7 @@ static int wacom_parse_hid(struct usb_interface *intf,
 				}
 				break;
 
-			case HID_USAGE_FINGER:
+			case HID_DG_FINGER:
 				finger = 1;
 				i++;
 				break;
@@ -482,19 +473,19 @@ static int wacom_parse_hid(struct usb_interface *intf,
 			 * X/Y values and some cases of invalid Digitizer X/Y
 			 * values commonly reported.
 			 */
-			case HID_USAGE_STYLUS:
+			case HID_DG_STYLUS:
 				pen = 1;
 				i++;
 				break;
 
-			case HID_USAGE_CONTACTMAX:
+			case HID_DG_CONTACTMAX:
 				/* leave touch_max as is if predefined */
 				if (!features->touch_max)
 					wacom_retrieve_report_data(intf, features);
 				i++;
 				break;
 
-			case HID_USAGE_PRESSURE:
+			case HID_DG_TIPPRESSURE:
 				if (pen) {
 					features->pressure_max =
 						get_unaligned_le16(&report[i + 3]);
@@ -504,15 +495,15 @@ static int wacom_parse_hid(struct usb_interface *intf,
 			}
 			break;
 
-		case HID_COLLECTION_END:
+		case HID_HDESC_COLLECTION_END:
 			/* reset UsagePage and Finger */
 			finger = page = 0;
 			break;
 
-		case HID_COLLECTION:
+		case HID_HDESC_COLLECTION:
 			i++;
 			switch (report[i]) {
-			case HID_COLLECTION_LOGICAL:
+			case HID_HDESC_COLLECTION_LOGICAL:
 				i += wacom_parse_logical_collection(&report[i],
 								    features);
 				break;
@@ -585,7 +576,7 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 {
 	int error = 0;
 	struct usb_host_interface *interface = intf->cur_altsetting;
-	struct hid_descriptor *hid_desc;
+	struct wac_hid_descriptor *hid_desc;
 
 	/* default features */
 	features->device_type = BTN_TOOL_PEN;
-- 
2.0.0

