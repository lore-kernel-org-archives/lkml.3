Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaI3RSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbaI3RSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 03/13] HID: logitech-dj: rely on hid groups to separate receivers from dj devices
Date: Tue, 30 Sep 2014 13:18:25 -0400
Message-Id: <1412097515-17241-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/hid/hid-logitech-dj.c | 38 ++++++++++----------------------------
 drivers/hid/hid-logitech-dj.h | 10 ----------
 include/linux/hid.h           |  1 +
 3 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 71f5692..42d38d5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -256,11 +256,15 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 	dj_hiddev->dev.parent = &djrcv_hdev->dev;
 	dj_hiddev->bus = BUS_USB;
 	dj_hiddev->vendor = le16_to_cpu(usbdev->descriptor.idVendor);
-	dj_hiddev->product = le16_to_cpu(usbdev->descriptor.idProduct);
+	dj_hiddev->product =
+		(dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB]
+									<< 8) |
+		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB];
 	snprintf(dj_hiddev->name, sizeof(dj_hiddev->name),
-		"Logitech Unifying Device. Wireless PID:%02x%02x",
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB],
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB]);
+		"Logitech Unifying Device. Wireless PID:%04x",
+		dj_hiddev->product);
+
+	dj_hiddev->group = HID_GROUP_LOGITECH_DJ_DEVICE;
 
 	usb_make_path(usbdev, dj_hiddev->phys, sizeof(dj_hiddev->phys));
 	snprintf(tmpstr, sizeof(tmpstr), ":%d", dj_report->device_index);
@@ -714,9 +718,6 @@ static int logi_dj_probe(struct hid_device *hdev,
 	struct dj_receiver_dev *djrcv_dev;
 	int retval;
 
-	if (is_dj_device((struct dj_device *)hdev->driver_data))
-		return -ENODEV;
-
 	dbg_hid("%s called for ifnum %d\n", __func__,
 		intf->cur_altsetting->desc.bInterfaceNumber);
 
@@ -869,22 +870,6 @@ static void logi_dj_remove(struct hid_device *hdev)
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
@@ -908,17 +893,14 @@ static struct hid_driver logi_djreceiver_driver = {
 
 
 static const struct hid_device_id logi_dj_devices[] = {
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER)},
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2)},
+	{ HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
+		USB_VENDOR_ID_LOGITECH, HID_ANY_ID)},
 	{}
 };
 
 static struct hid_driver logi_djdevice_driver = {
 	.name = "logitech-djdevice",
 	.id_table = logi_dj_devices,
-	.probe = logi_djdevice_probe,
 };
 
 
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index daeb0aa..b1208c9 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -112,14 +112,4 @@ struct dj_device {
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
index 0da2711..a50a6dd 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -312,6 +312,7 @@ struct hid_item {
  */
 #define HID_GROUP_RMI				0x0100
 #define HID_GROUP_WACOM				0x0101
+#define HID_GROUP_LOGITECH_DJ_DEVICE		0x0102
 
 /*
  * This is the global environment of the parser. This information is
-- 
2.1.0

