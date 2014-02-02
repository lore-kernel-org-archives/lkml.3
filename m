Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaBBEvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbaBBEus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:48 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] HID: remove hid_get_raw_report in struct hid_device
Date: Sat,  1 Feb 2014 23:50:28 -0500
Message-Id: <1391316630-29541-10-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->hid_get_raw_report(X) and hid_hw_raw_request(X, HID_REQ_GET_REPORT)
are strictly equivalent. Switch the hid subsystem to the hid_hw notation
and remove the field .hid_get_raw_report in struct hid_device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c       | 6 +++---
 drivers/hid/hid-sony.c        | 3 ++-
 drivers/hid/hidraw.c          | 7 ++++---
 drivers/hid/i2c-hid/i2c-hid.c | 1 -
 drivers/hid/uhid.c            | 1 -
 drivers/hid/usbhid/hid-core.c | 1 -
 include/linux/hid.h           | 3 ---
 net/bluetooth/hidp/core.c     | 1 -
 8 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 594722d..1de5997 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -350,9 +350,9 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 			ret = -ENOMEM;
 			break;
 		}
-		ret = dev->hid_get_raw_report(dev, dev->battery_report_id,
-					      buf, 2,
-					      dev->battery_report_type);
+		ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 2,
+					 dev->battery_report_type,
+					 HID_REQ_GET_REPORT);
 
 		if (ret != 2) {
 			ret = -ENODATA;
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 1235405..3930acb 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -706,7 +706,8 @@ static int sixaxis_set_operational_usb(struct hid_device *hdev)
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hdev->hid_get_raw_report(hdev, 0xf2, buf, 17, HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, 0xf2, buf, 17, HID_FEATURE_REPORT,
+				 HID_REQ_GET_REPORT);
 
 	if (ret < 0)
 		hid_err(hdev, "can't set operational mode\n");
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index cb0137b..4b2dc95 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -189,7 +189,7 @@ static ssize_t hidraw_get_report(struct file *file, char __user *buffer, size_t
 
 	dev = hidraw_table[minor]->hid;
 
-	if (!dev->hid_get_raw_report) {
+	if (!dev->ll_driver->raw_request) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -216,14 +216,15 @@ static ssize_t hidraw_get_report(struct file *file, char __user *buffer, size_t
 
 	/*
 	 * Read the first byte from the user. This is the report number,
-	 * which is passed to dev->hid_get_raw_report().
+	 * which is passed to hid_hw_raw_request().
 	 */
 	if (copy_from_user(&report_number, buffer, 1)) {
 		ret = -EFAULT;
 		goto out_free;
 	}
 
-	ret = dev->hid_get_raw_report(dev, report_number, buf, count, report_type);
+	ret = hid_hw_raw_request(dev, report_number, buf, count, report_type,
+				 HID_REQ_GET_REPORT);
 
 	if (ret < 0)
 		goto out_free;
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 5099f1f..fe3b392 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -1029,7 +1029,6 @@ static int i2c_hid_probe(struct i2c_client *client,
 
 	hid->driver_data = client;
 	hid->ll_driver = &i2c_hid_ll_driver;
-	hid->hid_get_raw_report = i2c_hid_get_raw_report;
 	hid->hid_output_raw_report = i2c_hid_output_raw_report;
 	hid->dev.parent = &client->dev;
 	ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 438c9f1..7358346 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -421,7 +421,6 @@ static int uhid_dev_create(struct uhid_device *uhid,
 	hid->uniq[63] = 0;
 
 	hid->ll_driver = &uhid_hid_driver;
-	hid->hid_get_raw_report = uhid_hid_get_raw;
 	hid->hid_output_raw_report = uhid_hid_output_raw;
 	hid->bus = ev->u.create.bus;
 	hid->vendor = ev->u.create.vendor;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 406497b..b9a770f 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1289,7 +1289,6 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
-	hid->hid_get_raw_report = usbhid_get_raw_report;
 	hid->hid_output_raw_report = usbhid_output_raw_report;
 	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 38c307b..c56681a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -508,9 +508,6 @@ struct hid_device {							/* device report descriptor */
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 
-	/* handler for raw input (Get_Report) data, used by hidraw */
-	int (*hid_get_raw_report) (struct hid_device *, unsigned char, __u8 *, size_t, unsigned char);
-
 	/* handler for raw output data, used by hidraw */
 	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t, unsigned char);
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 02670b3..77c4bad 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -773,7 +773,6 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->dev.parent = &session->conn->hcon->dev;
 	hid->ll_driver = &hidp_hid_driver;
 
-	hid->hid_get_raw_report = hidp_get_raw_report;
 	hid->hid_output_raw_report = hidp_output_raw_report;
 
 	/* True if device is blacklisted in drivers/hid/hid-core.c */
-- 
1.8.3.1

