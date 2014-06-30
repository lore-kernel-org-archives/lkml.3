Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaF3V0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239AbaF3V0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:45 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 03/15] Input - wacom: use hid communication instead of plain usb
Date: Mon, 30 Jun 2014 17:26:14 -0400
Message-Id: <1404163586-29582-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wacom.ko was a plain USB driver for a HID device. The communications
from/to the devices can actually be replaced with the HID API.

At the USB level, the reports are exactly the same.

This will allow to use uhid virtual devices instead of true USB devices.
This step is necessary to implement regression tests.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 81 ++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index aa2a4d7..eb39314 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -34,11 +34,6 @@ struct wac_hid_descriptor {
 	__le16   wDescriptorLength;
 } __attribute__ ((packed));
 
-/* defines to get/set USB message */
-#define USB_REQ_GET_REPORT	0x01
-#define USB_REQ_SET_REPORT	0x09
-
-#define WAC_HID_FEATURE_REPORT	0x03
 #define WAC_MSG_RETRIES		5
 
 #define WAC_CMD_LED_CONTROL	0x20
@@ -46,38 +41,27 @@ struct wac_hid_descriptor {
 #define WAC_CMD_ICON_XFER	0x23
 #define WAC_CMD_RETRIES		10
 
-static int wacom_get_report(struct usb_interface *intf, u8 type, u8 id,
+static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
 			    void *buf, size_t size, unsigned int retries)
 {
-	struct usb_device *dev = interface_to_usbdev(intf);
 	int retval;
 
 	do {
-		retval = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-				USB_REQ_GET_REPORT,
-				USB_DIR_IN | USB_TYPE_CLASS |
-				USB_RECIP_INTERFACE,
-				(type << 8) + id,
-				intf->altsetting[0].desc.bInterfaceNumber,
-				buf, size, 100);
+		retval = hid_hw_raw_request(hdev, id, buf, size, type,
+				HID_REQ_GET_REPORT);
 	} while ((retval == -ETIMEDOUT || retval == -EPIPE) && --retries);
 
 	return retval;
 }
 
-static int wacom_set_report(struct usb_interface *intf, u8 type, u8 id,
+static int wacom_set_report(struct hid_device *hdev, u8 type, u8 id,
 			    void *buf, size_t size, unsigned int retries)
 {
-	struct usb_device *dev = interface_to_usbdev(intf);
 	int retval;
 
 	do {
-		retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				USB_REQ_SET_REPORT,
-				USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-				(type << 8) + id,
-				intf->altsetting[0].desc.bInterfaceNumber,
-				buf, size, 1000);
+		retval = hid_hw_raw_request(hdev, id, buf, size, type,
+				HID_REQ_SET_REPORT);
 	} while ((retval == -ETIMEDOUT || retval == -EPIPE) && --retries);
 
 	return retval;
@@ -188,7 +172,7 @@ static int wacom_parse_logical_collection(unsigned char *report,
 	return length;
 }
 
-static void wacom_retrieve_report_data(struct usb_interface *intf,
+static void wacom_retrieve_report_data(struct hid_device *hdev,
 				       struct wacom_features *features)
 {
 	int result = 0;
@@ -198,7 +182,7 @@ static void wacom_retrieve_report_data(struct usb_interface *intf,
 	if (rep_data) {
 
 		rep_data[0] = 12;
-		result = wacom_get_report(intf, WAC_HID_FEATURE_REPORT,
+		result = wacom_get_report(hdev, HID_FEATURE_REPORT,
 					  rep_data[0], rep_data, 2,
 					  WAC_MSG_RETRIES);
 
@@ -245,10 +229,12 @@ static void wacom_retrieve_report_data(struct usb_interface *intf,
  * Intuos5 touch interface does not contain useful data. We deal with
  * this after returning from this function.
  */
-static int wacom_parse_hid(struct usb_interface *intf,
+static int wacom_parse_hid(struct hid_device *hdev,
 			   struct wac_hid_descriptor *hid_desc,
 			   struct wacom_features *features)
 {
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct usb_interface *intf = wacom->intf;
 	struct usb_device *dev = interface_to_usbdev(intf);
 	char limit = 0;
 	/* result has to be defined as int for some devices */
@@ -435,7 +421,7 @@ static int wacom_parse_hid(struct usb_interface *intf,
 			case HID_DG_CONTACTMAX:
 				/* leave touch_max as is if predefined */
 				if (!features->touch_max)
-					wacom_retrieve_report_data(intf, features);
+					wacom_retrieve_report_data(hdev, features);
 				i++;
 				break;
 
@@ -474,7 +460,8 @@ static int wacom_parse_hid(struct usb_interface *intf,
 	return result;
 }
 
-static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int length, int mode)
+static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
+		int length, int mode)
 {
 	unsigned char *rep_data;
 	int error = -ENOMEM, limit = 0;
@@ -487,10 +474,10 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
 		rep_data[0] = report_id;
 		rep_data[1] = mode;
 
-		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
+		error = wacom_set_report(hdev, HID_FEATURE_REPORT,
 		                         report_id, rep_data, length, 1);
 		if (error >= 0)
-			error = wacom_get_report(intf, WAC_HID_FEATURE_REPORT,
+			error = wacom_get_report(hdev, HID_FEATURE_REPORT,
 			                         report_id, rep_data, length, 1);
 	} while ((error < 0 || rep_data[1] != mode) && limit++ < WAC_MSG_RETRIES);
 
@@ -506,29 +493,32 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
  * from the tablet, it is necessary to switch the tablet out of this
  * mode and into one which sends the full range of tablet data.
  */
-static int wacom_query_tablet_data(struct usb_interface *intf, struct wacom_features *features)
+static int wacom_query_tablet_data(struct hid_device *hdev,
+		struct wacom_features *features)
 {
 	if (features->device_type == BTN_TOOL_FINGER) {
 		if (features->type > TABLETPC) {
 			/* MT Tablet PC touch */
-			return wacom_set_device_mode(intf, 3, 4, 4);
+			return wacom_set_device_mode(hdev, 3, 4, 4);
 		}
 		else if (features->type == WACOM_24HDT || features->type == CINTIQ_HYBRID) {
-			return wacom_set_device_mode(intf, 18, 3, 2);
+			return wacom_set_device_mode(hdev, 18, 3, 2);
 		}
 	} else if (features->device_type == BTN_TOOL_PEN) {
 		if (features->type <= BAMBOO_PT && features->type != WIRELESS) {
-			return wacom_set_device_mode(intf, 2, 2, 2);
+			return wacom_set_device_mode(hdev, 2, 2, 2);
 		}
 	}
 
 	return 0;
 }
 
-static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
+static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 					 struct wacom_features *features)
 {
 	int error = 0;
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct usb_interface *intf = wacom->intf;
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct wac_hid_descriptor *hid_desc;
 
@@ -564,12 +554,12 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 		error = usb_get_extra_descriptor(&interface->endpoint[0],
 						 HID_DEVICET_REPORT, &hid_desc);
 		if (error) {
-			dev_err(&intf->dev,
+			hid_err(hdev,
 				"can not retrieve extra class descriptor\n");
 			goto out;
 		}
 	}
-	error = wacom_parse_hid(intf, hid_desc, features);
+	error = wacom_parse_hid(hdev, hid_desc, features);
 
  out:
 	return error;
@@ -711,8 +701,8 @@ static int wacom_led_control(struct wacom *wacom)
 		buf[4] = wacom->led.img_lum;
 	}
 
-	retval = wacom_set_report(wacom->intf, 0x03, WAC_CMD_LED_CONTROL,
-				  buf, 9, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
+				  WAC_CMD_LED_CONTROL, buf, 9, WAC_CMD_RETRIES);
 	kfree(buf);
 
 	return retval;
@@ -730,8 +720,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 	/* Send 'start' command */
 	buf[0] = WAC_CMD_ICON_START;
 	buf[1] = 1;
-	retval = wacom_set_report(wacom->intf, 0x03, WAC_CMD_ICON_START,
-				  buf, 2, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
+				  WAC_CMD_ICON_START, buf, 2, WAC_CMD_RETRIES);
 	if (retval < 0)
 		goto out;
 
@@ -741,7 +731,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 		buf[2] = i;
 		memcpy(buf + 3, img + i * 256, 256);
 
-		retval = wacom_set_report(wacom->intf, 0x03, WAC_CMD_ICON_XFER,
+		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
+					  WAC_CMD_ICON_XFER,
 					  buf, 259, WAC_CMD_RETRIES);
 		if (retval < 0)
 			break;
@@ -750,7 +741,7 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 	/* Send 'stop' */
 	buf[0] = WAC_CMD_ICON_START;
 	buf[1] = 0;
-	wacom_set_report(wacom->intf, 0x03, WAC_CMD_ICON_START,
+	wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, WAC_CMD_ICON_START,
 			 buf, 2, WAC_CMD_RETRIES);
 
 out:
@@ -1334,7 +1325,7 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom_set_default_phy(features);
 
 	/* Retrieve the physical and logical size for touch devices */
-	error = wacom_retrieve_hid_descriptor(intf, features);
+	error = wacom_retrieve_hid_descriptor(hdev, features);
 	if (error)
 		goto fail1;
 
@@ -1398,7 +1389,7 @@ static int wacom_probe(struct hid_device *hdev,
 	}
 
 	/* Note that if query fails it is not a hard failure */
-	wacom_query_tablet_data(intf, features);
+	wacom_query_tablet_data(hdev, features);
 
 	/* Regular HID work starts now */
 	error = hid_parse(hdev);
@@ -1459,7 +1450,7 @@ static int wacom_resume(struct hid_device *hdev)
 	mutex_lock(&wacom->lock);
 
 	/* switch to wacom mode first */
-	wacom_query_tablet_data(wacom->intf, features);
+	wacom_query_tablet_data(hdev, features);
 	wacom_led_control(wacom);
 
 	mutex_unlock(&wacom->lock);
-- 
2.0.0

