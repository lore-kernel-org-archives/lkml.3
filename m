Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaI3RVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:21:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaI3RSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:49 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 07/13] HID: logitech-dj: allow transfer of HID++ reports from/to the correct dj device
Date: Tue, 30 Sep 2014 13:18:29 -0400
Message-Id: <1412097515-17241-8-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID++ is a Logitech-specific protocol for communicating with HID
devices. DJ devices implement HID++, and so we can add the HID++
collection in the report descriptor and forward the incoming
reports from the receiver to the appropriate DJ device.

The same can be done in the other way, if someone calls a
.raw_request(), we can forward it to the correct dj device
by overriding the device_index in the HID++ report.

Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 188 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 160 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 45a7eac..feddacd 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -42,6 +42,15 @@
 #define REPORT_ID_DJ_SHORT			0x20
 #define REPORT_ID_DJ_LONG			0x21
 
+#define REPORT_ID_HIDPP_SHORT			0x10
+#define REPORT_ID_HIDPP_LONG			0x11
+
+#define HIDPP_REPORT_SHORT_LENGTH		7
+#define HIDPP_REPORT_LONG_LENGTH		20
+
+#define HIDPP_RECEIVER_INDEX			0xff
+
+#define REPORT_TYPE_RFREPORT_FIRST		0x01
 #define REPORT_TYPE_RFREPORT_LAST		0x1F
 
 /* Command Switch to DJ mode */
@@ -242,6 +251,57 @@ static const char media_descriptor[] = {
 	0xc0,			/* EndCollection                       */
 };				/*                                     */
 
+/* HIDPP descriptor */
+static const char hidpp_descriptor[] = {
+	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1)  */
+	0x09, 0x01,		/* Usage (Vendor Usage 1)              */
+	0xa1, 0x01,		/* Collection (Application)            */
+	0x85, 0x10,		/*   Report ID (16)                    */
+	0x75, 0x08,		/*   Report Size (8)                   */
+	0x95, 0x06,		/*   Report Count (6)                  */
+	0x15, 0x00,		/*   Logical Minimum (0)               */
+	0x26, 0xff, 0x00,	/*   Logical Maximum (255)             */
+	0x09, 0x01,		/*   Usage (Vendor Usage 1)            */
+	0x81, 0x00,		/*   Input (Data,Arr,Abs)              */
+	0x09, 0x01,		/*   Usage (Vendor Usage 1)            */
+	0x91, 0x00,		/*   Output (Data,Arr,Abs)             */
+	0xc0,			/* End Collection                      */
+	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1)  */
+	0x09, 0x02,		/* Usage (Vendor Usage 2)              */
+	0xa1, 0x01,		/* Collection (Application)            */
+	0x85, 0x11,		/*   Report ID (17)                    */
+	0x75, 0x08,		/*   Report Size (8)                   */
+	0x95, 0x13,		/*   Report Count (19)                 */
+	0x15, 0x00,		/*   Logical Minimum (0)               */
+	0x26, 0xff, 0x00,	/*   Logical Maximum (255)             */
+	0x09, 0x02,		/*   Usage (Vendor Usage 2)            */
+	0x81, 0x00,		/*   Input (Data,Arr,Abs)              */
+	0x09, 0x02,		/*   Usage (Vendor Usage 2)            */
+	0x91, 0x00,		/*   Output (Data,Arr,Abs)             */
+	0xc0,			/* End Collection                      */
+	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1)  */
+	0x09, 0x04,		/* Usage (Vendor Usage 0x04)           */
+	0xa1, 0x01,		/* Collection (Application)            */
+	0x85, 0x20,		/*   Report ID (32)                    */
+	0x75, 0x08,		/*   Report Size (8)                   */
+	0x95, 0x0e,		/*   Report Count (14)                 */
+	0x15, 0x00,		/*   Logical Minimum (0)               */
+	0x26, 0xff, 0x00,	/*   Logical Maximum (255)             */
+	0x09, 0x41,		/*   Usage (Vendor Usage 0x41)         */
+	0x81, 0x00,		/*   Input (Data,Arr,Abs)              */
+	0x09, 0x41,		/*   Usage (Vendor Usage 0x41)         */
+	0x91, 0x00,		/*   Output (Data,Arr,Abs)             */
+	0x85, 0x21,		/*   Report ID (33)                    */
+	0x95, 0x1f,		/*   Report Count (31)                 */
+	0x15, 0x00,		/*   Logical Minimum (0)               */
+	0x26, 0xff, 0x00,	/*   Logical Maximum (255)             */
+	0x09, 0x42,		/*   Usage (Vendor Usage 0x42)         */
+	0x81, 0x00,		/*   Input (Data,Arr,Abs)              */
+	0x09, 0x42,		/*   Usage (Vendor Usage 0x42)         */
+	0x91, 0x00,		/*   Output (Data,Arr,Abs)             */
+	0xc0,			/* End Collection                      */
+};
+
 /* Maximum size of all defined hid reports in bytes (including report id) */
 #define MAX_REPORT_SIZE 8
 
@@ -251,7 +311,8 @@ static const char media_descriptor[] = {
 	 sizeof(mse_descriptor) +		\
 	 sizeof(consumer_descriptor) +		\
 	 sizeof(syscontrol_descriptor) +	\
-	 sizeof(media_descriptor))
+	 sizeof(media_descriptor) +	\
+	 sizeof(hidpp_descriptor))
 
 /* Number of possible hid report types that can be created by this driver.
  *
@@ -512,6 +573,13 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
 	}
 }
 
+static void logi_dj_recv_forward_hidpp(struct dj_device *dj_dev, u8 *data,
+				       int size)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+	if (hid_input_report(dj_dev->hdev, HID_INPUT_REPORT, data, size, 1))
+		dbg_hid("hid_input_report error\n");
+}
 
 static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 				    struct dj_report *dj_report)
@@ -609,6 +677,16 @@ static int logi_dj_ll_raw_request(struct hid_device *hid,
 	u8 *out_buf;
 	int ret;
 
+	if ((buf[0] == REPORT_ID_HIDPP_SHORT) ||
+	    (buf[0] == REPORT_ID_HIDPP_LONG)) {
+		if (count < 2)
+			return -EINVAL;
+
+		buf[1] = djdev->device_index;
+		return hid_hw_raw_request(djrcv_dev->hdev, reportnum, buf,
+				count, report_type, reqtype);
+	}
+
 	if (buf[0] != REPORT_TYPE_LEDS)
 		return -EINVAL;
 
@@ -687,6 +765,8 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 			__func__, djdev->reports_supported);
 	}
 
+	rdcat(rdesc, &rsize, hidpp_descriptor, sizeof(hidpp_descriptor));
+
 	retval = hid_parse_report(hid, rdesc, rsize);
 	kfree(rdesc);
 
@@ -714,8 +794,7 @@ static struct hid_ll_driver logi_dj_ll_driver = {
 	.raw_request = logi_dj_ll_raw_request,
 };
 
-
-static int logi_dj_raw_event(struct hid_device *hdev,
+static int logi_dj_dj_event(struct hid_device *hdev,
 			     struct hid_report *report, u8 *data,
 			     int size)
 {
@@ -723,36 +802,24 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	struct dj_report *dj_report = (struct dj_report *) data;
 	unsigned long flags;
 
-	dbg_hid("%s, size:%d\n", __func__, size);
-
-	/* Here we receive all data coming from iface 2, there are 4 cases:
-	 *
-	 * 1) Data should continue its normal processing i.e. data does not
-	 * come from the DJ collection, in which case we do nothing and
-	 * return 0, so hid-core can continue normal processing (will forward
-	 * to associated hidraw device)
+	/*
+	 * Here we receive all data coming from iface 2, there are 3 cases:
 	 *
-	 * 2) Data is from DJ collection, and is intended for this driver i. e.
-	 * data contains arrival, departure, etc notifications, in which case
-	 * we queue them for delayed processing by the work queue. We return 1
-	 * to hid-core as no further processing is required from it.
+	 * 1) Data is intended for this driver i. e. data contains arrival,
+	 * departure, etc notifications, in which case we queue them for delayed
+	 * processing by the work queue. We return 1 to hid-core as no further
+	 * processing is required from it.
 	 *
-	 * 3) Data is from DJ collection, and informs a connection change,
-	 * if the change means rf link loss, then we must send a null report
-	 * to the upper layer to discard potentially pressed keys that may be
-	 * repeated forever by the input layer. Return 1 to hid-core as no
-	 * further processing is required.
+	 * 2) Data informs a connection change, if the change means rf link
+	 * loss, then we must send a null report to the upper layer to discard
+	 * potentially pressed keys that may be repeated forever by the input
+	 * layer. Return 1 to hid-core as no further processing is required.
 	 *
-	 * 4) Data is from DJ collection and is an actual input event from
-	 * a paired DJ device in which case we forward it to the correct hid
-	 * device (via hid_input_report() ) and return 1 so hid-core does not do
-	 * anything else with it.
+	 * 3) Data is an actual input event from a paired DJ device in which
+	 * case we forward it to the correct hid device (via hid_input_report()
+	 * ) and return 1 so hid-core does not anything else with it.
 	 */
 
-	/* case 1) */
-	if (data[0] != REPORT_ID_DJ_SHORT)
-		return false;
-
 	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
 	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
 		/*
@@ -797,6 +864,71 @@ out:
 	return true;
 }
 
+static int logi_dj_hidpp_event(struct hid_device *hdev,
+			     struct hid_report *report, u8 *data,
+			     int size)
+{
+	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
+	struct dj_report *dj_report = (struct dj_report *) data;
+	unsigned long flags;
+	u8 device_index = dj_report->device_index;
+
+	if (device_index == HIDPP_RECEIVER_INDEX)
+		return false;
+
+	/*
+	 * Data is from the HID++ collection, in this case, we forward the
+	 * data to the corresponding child dj device and return 0 to hid-core
+	 * so he data also goes to the hidraw device of the receiver. This
+	 * allows a user space application to implement the full HID++ routing
+	 * via the receiver.
+	 */
+
+	if ((device_index < DJ_DEVICE_INDEX_MIN) ||
+	    (device_index > DJ_DEVICE_INDEX_MAX)) {
+		/*
+		 * Device index is wrong, bail out.
+		 * This driver can ignore safely the receiver notifications,
+		 * so ignore those reports too.
+		 */
+		dev_err(&hdev->dev, "%s: invalid device index:%d\n",
+				__func__, dj_report->device_index);
+		return false;
+	}
+
+	spin_lock_irqsave(&djrcv_dev->lock, flags);
+
+	if (!djrcv_dev->paired_dj_devices[device_index])
+		/* received an event for an unknown device, bail out */
+		goto out;
+
+	logi_dj_recv_forward_hidpp(djrcv_dev->paired_dj_devices[device_index],
+				   data, size);
+
+out:
+	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
+
+	return false;
+}
+
+static int logi_dj_raw_event(struct hid_device *hdev,
+			     struct hid_report *report, u8 *data,
+			     int size)
+{
+	dbg_hid("%s, size:%d\n", __func__, size);
+
+	switch (data[0]) {
+	case REPORT_ID_DJ_SHORT:
+		return logi_dj_dj_event(hdev, report, data, size);
+	case REPORT_ID_HIDPP_SHORT:
+		/* intentional fallthrough */
+	case REPORT_ID_HIDPP_LONG:
+		return logi_dj_hidpp_event(hdev, report, data, size);
+	}
+
+	return false;
+}
+
 static int logi_dj_probe(struct hid_device *hdev,
 			 const struct hid_device_id *id)
 {
-- 
2.1.0

