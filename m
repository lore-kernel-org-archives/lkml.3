Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBBEvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaBBEuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:51 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] HID: move hid_output_raw_report to hid_ll_driver
Date: Sat,  1 Feb 2014 23:50:30 -0500
Message-Id: <1391316630-29541-12-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct hid_ll_driver is responsible for the transport communication.
Move hid_output_raw_report from hid_device to the transport layer then.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c        |  2 +-
 drivers/hid/hid-logitech-dj.c  |  2 +-
 drivers/hid/hid-sony.c         | 11 ++++++++++-
 drivers/hid/hid-wiimote-core.c |  2 +-
 drivers/hid/hidraw.c           |  2 +-
 drivers/hid/i2c-hid/i2c-hid.c  |  2 +-
 drivers/hid/uhid.c             |  2 +-
 drivers/hid/usbhid/hid-core.c  |  2 +-
 include/linux/hid.h            | 11 +++++++----
 net/bluetooth/hidp/core.c      |  4 ++--
 10 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 78293c3..3125155 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1263,7 +1263,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	}
 
 	input_set_drvdata(input_dev, hid);
-	if (hid->ll_driver->request || hid->hid_output_raw_report)
+	if (hid->ll_driver->request || hid->ll_driver->hid_output_raw_report)
 		input_dev->event = hidinput_input_event;
 	input_dev->open = hidinput_open;
 	input_dev->close = hidinput_close;
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 9347625..bdfa1db 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -262,7 +262,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 	}
 
 	dj_hiddev->ll_driver = &logi_dj_ll_driver;
-	dj_hiddev->hid_output_raw_report = logi_dj_output_hidraw_report;
 
 	dj_hiddev->dev.parent = &djrcv_hdev->dev;
 	dj_hiddev->bus = BUS_USB;
@@ -655,6 +654,7 @@ static struct hid_ll_driver logi_dj_ll_driver = {
 	.stop = logi_dj_ll_stop,
 	.open = logi_dj_ll_open,
 	.close = logi_dj_ll_close,
+	.hid_output_raw_report = logi_dj_output_hidraw_report,
 };
 
 
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 8494b8c..9dd37ff 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -494,6 +494,8 @@ struct sony_sc {
 	unsigned long quirks;
 	struct work_struct state_worker;
 
+	struct hid_ll_driver *ll_driver;
+
 #ifdef CONFIG_SONY_FF
 	__u8 left;
 	__u8 right;
@@ -1077,7 +1079,14 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
-		hdev->hid_output_raw_report = sixaxis_usb_output_raw_report;
+		sc->ll_driver = devm_kzalloc(&hdev->dev, sizeof(*sc->ll_driver),
+					     GFP_KERNEL);
+		if (sc->ll_driver == NULL)
+			return -ENOMEM;
+		*sc->ll_driver = *hdev->ll_driver;
+		hdev->ll_driver = sc->ll_driver;
+		sc->ll_driver->hid_output_raw_report =
+						sixaxis_usb_output_raw_report;
 		ret = sixaxis_set_operational_usb(hdev);
 		INIT_WORK(&sc->state_worker, sixaxis_state_worker);
 	}
diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
index d7dc6c5b..715a3ab 100644
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -28,7 +28,7 @@ static int wiimote_hid_send(struct hid_device *hdev, __u8 *buffer,
 	__u8 *buf;
 	int ret;
 
-	if (!hdev->hid_output_raw_report)
+	if (!hdev->ll_driver->hid_output_raw_report)
 		return -ENODEV;
 
 	buf = kmemdup(buffer, count, GFP_KERNEL);
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index f8708c9..c60c530 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -123,7 +123,7 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 
 	dev = hidraw_table[minor]->hid;
 
-	if (!dev->hid_output_raw_report) {
+	if (!dev->ll_driver->hid_output_raw_report) {
 		ret = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index fe3b392..fabb388 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -785,6 +785,7 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
 	.request = i2c_hid_request,
 	.output_report = i2c_hid_output_report,
 	.raw_request = i2c_hid_raw_request,
+	.hid_output_raw_report = i2c_hid_output_raw_report,
 };
 
 static int i2c_hid_init_irq(struct i2c_client *client)
@@ -1029,7 +1030,6 @@ static int i2c_hid_probe(struct i2c_client *client,
 
 	hid->driver_data = client;
 	hid->ll_driver = &i2c_hid_ll_driver;
-	hid->hid_output_raw_report = i2c_hid_output_raw_report;
 	hid->dev.parent = &client->dev;
 	ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
 	hid->bus = BUS_I2C;
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 7358346..8e99a5a 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -294,6 +294,7 @@ static struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.output_report = uhid_hid_output_report,
 	.raw_request = uhid_raw_request,
+	.hid_output_raw_report = uhid_hid_output_raw,
 };
 
 #ifdef CONFIG_COMPAT
@@ -421,7 +422,6 @@ static int uhid_dev_create(struct uhid_device *uhid,
 	hid->uniq[63] = 0;
 
 	hid->ll_driver = &uhid_hid_driver;
-	hid->hid_output_raw_report = uhid_hid_output_raw;
 	hid->bus = ev->u.create.bus;
 	hid->vendor = ev->u.create.vendor;
 	hid->product = ev->u.create.product;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b9a770f..9c3c244 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1260,6 +1260,7 @@ static struct hid_ll_driver usb_hid_driver = {
 	.raw_request = usbhid_raw_request,
 	.output_report = usbhid_output_report,
 	.idle = usbhid_idle,
+	.hid_output_raw_report = usbhid_output_raw_report,
 };
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
@@ -1289,7 +1290,6 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
-	hid->hid_output_raw_report = usbhid_output_raw_report;
 	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
 	hid->hiddev_connect = hiddev_connect;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a837ede..eb588e9 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -508,9 +508,6 @@ struct hid_device {							/* device report descriptor */
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 
-	/* handler for raw output data, used by hidraw */
-	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t, unsigned char);
-
 	/* debugging support via debugfs */
 	unsigned short debug;
 	struct dentry *debug_dir;
@@ -678,6 +675,7 @@ struct hid_driver {
  * @wait: wait for buffered io to complete (send/recv reports)
  * @raw_request: send raw report request to device (e.g. feature report)
  * @output_report: send output report to device
+ * @hid_output_raw_report: send report to device (e.g. feature report)
  * @idle: send idle request to device
  */
 struct hid_ll_driver {
@@ -702,6 +700,10 @@ struct hid_ll_driver {
 
 	int (*output_report) (struct hid_device *hdev, __u8 *buf, size_t len);
 
+	/* handler for raw output data, used by hidraw */
+	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t,
+				      unsigned char);
+
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 };
 
@@ -1024,7 +1026,8 @@ static inline int hid_hw_output_report(struct hid_device *hdev, __u8 *buf,
 static inline int hid_output_raw_report(struct hid_device *hdev, __u8 *buf,
 					size_t len, unsigned char report_type)
 {
-	return hdev->hid_output_raw_report(hdev, buf, len, report_type);
+	return hdev->ll_driver->hid_output_raw_report(hdev, buf, len,
+						      report_type);
 }
 
 /**
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 77c4bad..6189b54 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -726,6 +726,8 @@ static struct hid_ll_driver hidp_hid_driver = {
 	.close = hidp_close,
 	.raw_request = hidp_raw_request,
 	.output_report = hidp_output_report,
+	.hid_output_raw_report = hidp_output_raw_report,
+
 };
 
 /* This function sets up the hid device. It does not add it
@@ -773,8 +775,6 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->dev.parent = &session->conn->hcon->dev;
 	hid->ll_driver = &hidp_hid_driver;
 
-	hid->hid_output_raw_report = hidp_output_raw_report;
-
 	/* True if device is blacklisted in drivers/hid/hid-core.c */
 	if (hid_ignore(hid)) {
 		hid_destroy_device(session->hid);
-- 
1.8.3.1

