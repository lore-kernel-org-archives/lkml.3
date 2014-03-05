Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbaCEVTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:19:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbaCEVTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:19:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] HID: remove hid_output_raw_report transport implementations
Date: Wed,  5 Mar 2014 16:18:54 -0500
Message-Id: <1394054334-20438-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody calls hid_output_raw_report anymore, and nobody should.
We can now remove the various implementation in the different
transport drivers and the declarations.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

no changes since v1 (what did you expected?)

 drivers/hid/i2c-hid/i2c-hid.c | 14 --------------
 drivers/hid/uhid.c            |  1 -
 drivers/hid/usbhid/hid-core.c | 12 ------------
 include/linux/hid.h           | 19 -------------------
 net/bluetooth/hidp/core.c     | 14 --------------
 5 files changed, 60 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index cbd44a7..8c52a07 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -596,19 +596,6 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 	return ret;
 }
 
-static int __i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
-		size_t count, unsigned char report_type)
-{
-	struct i2c_client *client = hid->driver_data;
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
-	bool data = true; /* SET_REPORT */
-
-	if (report_type == HID_OUTPUT_REPORT)
-		data = le16_to_cpu(ihid->hdesc.wMaxOutputLength) == 0;
-
-	return i2c_hid_output_raw_report(hid, buf, count, report_type, data);
-}
-
 static int i2c_hid_output_report(struct hid_device *hid, __u8 *buf,
 		size_t count)
 {
@@ -1037,7 +1024,6 @@ static int i2c_hid_probe(struct i2c_client *client,
 
 	hid->driver_data = client;
 	hid->ll_driver = &i2c_hid_ll_driver;
-	hid->hid_output_raw_report = __i2c_hid_output_raw_report;
 	hid->dev.parent = &client->dev;
 	ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
 	hid->bus = BUS_I2C;
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 60acee4..7ed79be 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -400,7 +400,6 @@ static int uhid_dev_create(struct uhid_device *uhid,
 	hid->uniq[63] = 0;
 
 	hid->ll_driver = &uhid_hid_driver;
-	hid->hid_output_raw_report = uhid_hid_output_raw;
 	hid->bus = ev->u.create.bus;
 	hid->vendor = ev->u.create.vendor;
 	hid->product = ev->u.create.product;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 3bc7cad..7b88f4c 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -950,17 +950,6 @@ static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
 	return ret;
 }
 
-static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf,
-		size_t count, unsigned char report_type)
-{
-	struct usbhid_device *usbhid = hid->driver_data;
-
-	if (usbhid->urbout && report_type != HID_FEATURE_REPORT)
-		return usbhid_output_report(hid, buf, count);
-
-	return usbhid_set_raw_report(hid, buf[0], buf, count, report_type);
-}
-
 static void usbhid_restart_queues(struct usbhid_device *usbhid)
 {
 	if (usbhid->urbout && !test_bit(HID_OUT_RUNNING, &usbhid->iofl))
@@ -1294,7 +1283,6 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
-	hid->hid_output_raw_report = usbhid_output_raw_report;
 	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
 	hid->hiddev_connect = hiddev_connect;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 2cd7174..720e3a1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -513,9 +513,6 @@ struct hid_device {							/* device report descriptor */
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 
-	/* handler for raw output data, used by hidraw */
-	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t, unsigned char);
-
 	/* debugging support via debugfs */
 	unsigned short debug;
 	struct dentry *debug_dir;
@@ -1023,22 +1020,6 @@ static inline int hid_hw_output_report(struct hid_device *hdev, __u8 *buf,
 }
 
 /**
- * hid_output_raw_report - send an output or a feature report to the device
- *
- * @hdev: hid device
- * @buf: raw data to transfer
- * @len: length of buf
- * @report_type: HID_FEATURE_REPORT or HID_OUTPUT_REPORT
- *
- * @return: count of data transfered, negative if error
- */
-static inline int hid_output_raw_report(struct hid_device *hdev, __u8 *buf,
-					size_t len, unsigned char report_type)
-{
-	return hdev->hid_output_raw_report(hdev, buf, len, report_type);
-}
-
-/**
  * hid_hw_idle - send idle request to device
  *
  * @hdev: hid device
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 98e4840..514ddb5 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -382,18 +382,6 @@ static int hidp_output_report(struct hid_device *hid, __u8 *data, size_t count)
 				      data, count);
 }
 
-static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data,
-		size_t count, unsigned char report_type)
-{
-	if (report_type == HID_OUTPUT_REPORT) {
-		return hidp_output_report(hid, data, count);
-	} else if (report_type != HID_FEATURE_REPORT) {
-		return -EINVAL;
-	}
-
-	return hidp_set_raw_report(hid, data[0], data, count, report_type);
-}
-
 static int hidp_raw_request(struct hid_device *hid, unsigned char reportnum,
 			    __u8 *buf, size_t len, unsigned char rtype,
 			    int reqtype)
@@ -776,8 +764,6 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->dev.parent = &session->conn->hcon->dev;
 	hid->ll_driver = &hidp_hid_driver;
 
-	hid->hid_output_raw_report = hidp_output_raw_report;
-
 	/* True if device is blacklisted in drivers/hid/hid-core.c */
 	if (hid_ignore(hid)) {
 		hid_destroy_device(session->hid);
-- 
1.8.5.3

