Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaAHWTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036AbaAHWTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:19:02 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] HID: logitech-dj: rely on hid groups to separate receivers from dj devices
Date: Wed,  8 Jan 2014 17:18:47 -0500
Message-Id: <1389219529-29671-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>

Several benefits here:
- we can drop the macro is_dj_device: I never been really conviced by
  this macro as we could fall into a null pointer anytime. Anyway time
  showed that this never happened.
- we can simplify the hid driver logitech-djdevice, and make it aware
  of any new receiver VID/PID.
- we can use the Wireless PID of the DJ device as the product id of the
  hid device, this way the sysfs will differentiate between different
  DJ devices.

Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 37 +++++++++----------------------------
 drivers/hid/hid-logitech-dj.h | 10 ----------
 include/linux/hid.h           |  1 +
 3 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index f45279c..a4b3cee 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -263,11 +263,14 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 	dj_hiddev->dev.parent = &djrcv_hdev->dev;
 	dj_hiddev->bus = BUS_USB;
 	dj_hiddev->vendor = le16_to_cpu(usbdev->descriptor.idVendor);
-	dj_hiddev->product = le16_to_cpu(usbdev->descriptor.idProduct);
+	dj_hiddev->product =
+	    (dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB] << 8) |
+	     dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB];
 	snprintf(dj_hiddev->name, sizeof(dj_hiddev->name),
-		"Logitech Unifying Device. Wireless PID:%02x%02x",
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB],
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB]);
+		"Logitech Unifying Device. Wireless PID:%04x",
+		dj_hiddev->product);
+
+	dj_hiddev->group = HID_GROUP_LOGITECH_DJ_DEVICE_GENERIC;
 
 	usb_make_path(usbdev, dj_hiddev->phys, sizeof(dj_hiddev->phys));
 	snprintf(tmpstr, sizeof(tmpstr), ":%d", dj_report->device_index);
@@ -752,9 +755,6 @@ static int logi_dj_probe(struct hid_device *hdev,
 	struct dj_receiver_dev *djrcv_dev;
 	int retval;
 
-	if (is_dj_device((struct dj_device *)hdev->driver_data))
-		return -ENODEV;
-
 	dbg_hid("%s called for ifnum %d\n", __func__,
 		intf->cur_altsetting->desc.bInterfaceNumber);
 
@@ -907,22 +907,6 @@ static void logi_dj_remove(struct hid_device *hdev)
 	hid_set_drvdata(hdev, NULL);
 }
 
-static int logi_djdevice_probe(struct hid_device *hdev,
-			 const struct hid_device_id *id)
-{
-	int ret;
-	struct dj_device *dj_dev = hdev->driver_data;
-
-	if (!is_dj_device(dj_dev))
-		return -ENODEV;
-
-	ret = hid_parse(hdev);
-	if (!ret)
-		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-
-	return ret;
-}
-
 static const struct hid_device_id logi_dj_receivers[] = {
 	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER)},
@@ -946,17 +930,14 @@ static struct hid_driver logi_djreceiver_driver = {
 
 
 static const struct hid_device_id logi_dj_devices[] = {
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER)},
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2)},
+	{ HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE_GENERIC,
+		USB_VENDOR_ID_LOGITECH, HID_ANY_ID)},
 	{}
 };
 
 static struct hid_driver logi_djdevice_driver = {
 	.name = "logitech-djdevice",
 	.id_table = logi_dj_devices,
-	.probe = logi_djdevice_probe,
 };
 
 
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 4a40003..2e52167 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -111,14 +111,4 @@ struct dj_device {
 	u8 device_index;
 };
 
-/**
- * is_dj_device - know if the given dj_device is not the receiver.
- * @dj_dev: the dj device to test
- *
- * This macro tests if a struct dj_device pointer is a device created
- * by the bus enumarator.
- */
-#define is_dj_device(dj_dev) \
-	(&(dj_dev)->dj_receiver_dev->hdev->dev == (dj_dev)->hdev->dev.parent)
-
 #endif
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 31b9d29..eacf556 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -299,6 +299,7 @@ struct hid_item {
 #define HID_GROUP_MULTITOUCH			0x0002
 #define HID_GROUP_SENSOR_HUB			0x0003
 #define HID_GROUP_MULTITOUCH_WIN_8		0x0004
+#define HID_GROUP_LOGITECH_DJ_DEVICE_GENERIC	0x0005
 
 /*
  * This is the global environment of the parser. This information is
-- 
1.8.4.2

