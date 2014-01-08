Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbaAHWTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:19:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283AbaAHWTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:19:05 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] HID: logitech-dj: forward incoming HID++ reports to the correct dj device
Date: Wed,  8 Jan 2014 17:18:48 -0500
Message-Id: <1389219529-29671-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>

HID++ is a Logitech-specific protocol for communicating with HID
devices. DJ devices implement HID++, and so we can add the HID++
collection in the report descriptor and forward the incoming
reports from the receiver to the appropriate DJ device.

Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 99 ++++++++++++++++++++++++++++++++++++++++---
 drivers/hid/hid-logitech-dj.h |  6 +++
 2 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index a4b3cee..3444feb 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -152,6 +152,57 @@ static const char media_descriptor[] = {
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
 
@@ -161,7 +212,8 @@ static const char media_descriptor[] = {
 	 sizeof(mse_descriptor) +		\
 	 sizeof(consumer_descriptor) +		\
 	 sizeof(syscontrol_descriptor) +	\
-	 sizeof(media_descriptor))
+	 sizeof(media_descriptor) +	\
+	 sizeof(hidpp_descriptor))
 
 /* Number of possible hid report types that can be created by this driver.
  *
@@ -456,6 +508,25 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
 	}
 }
 
+static void logi_dj_recv_forward_hidpp(struct dj_receiver_dev *djrcv_dev,
+			u8 *data, int size)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	struct dj_device *dj_dev = NULL;
+	u8 device_index = data[1];
+
+	if ((device_index < DJ_DEVICE_INDEX_MIN) ||
+	    (device_index > DJ_DEVICE_INDEX_MAX))
+		return;
+
+	dj_dev = djrcv_dev->paired_dj_devices[device_index];
+
+	if (!dj_dev)
+		return;
+
+	hid_input_report(dj_dev->hdev, HID_INPUT_REPORT, data, size, 1);
+}
 
 static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 				    struct dj_report *dj_report)
@@ -610,6 +681,8 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 			__func__, djdev->reports_supported);
 	}
 
+	rdcat(rdesc, &rsize, hidpp_descriptor, sizeof(hidpp_descriptor));
+
 	retval = hid_parse_report(hid, rdesc, rsize);
 	kfree(rdesc);
 
@@ -701,12 +774,12 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 
 	dbg_hid("%s, size:%d\n", __func__, size);
 
-	/* Here we receive all data coming from iface 2, there are 4 cases:
+	/* Here we receive all data coming from iface 2, there are 5 cases:
 	 *
 	 * 1) Data should continue its normal processing i.e. data does not
-	 * come from the DJ collection, in which case we do nothing and
-	 * return 0, so hid-core can continue normal processing (will forward
-	 * to associated hidraw device)
+	 * come from the DJ or the HID++ collection, in which case we do nothing
+	 * and return 0, so hid-core can continue normal processing (will
+	 * forward to associated hidraw device)
 	 *
 	 * 2) Data is from DJ collection, and is intended for this driver i. e.
 	 * data contains arrival, departure, etc notifications, in which case
@@ -723,10 +796,17 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	 * a paired DJ device in which case we forward it to the correct hid
 	 * device (via hid_input_report() ) and return 1 so hid-core does not do
 	 * anything else with it.
+	 *
+	 * 5) Data is from the HID++ collection, in this case, we forward the
+	 * data to the corresponding child dj device and return 0 to hid-core
+	 * so he data also goes to the hidraw device of the receiver. This
+	 * allows a user space application to implement the full HID++ routing
+	 * via the receiver.
 	 */
 
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
-	if (dj_report->report_id == REPORT_ID_DJ_SHORT) {
+	switch (data[0]) {
+	case REPORT_ID_DJ_SHORT:
 		switch (dj_report->report_type) {
 		case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
 		case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
@@ -742,6 +822,13 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 			logi_dj_recv_forward_report(djrcv_dev, dj_report);
 		}
 		report_processed = true;
+		break;
+	case REPORT_ID_HIDPP_SHORT:
+		/* intentional fallthrough */
+	case REPORT_ID_HIDPP_LONG:
+		logi_dj_recv_forward_hidpp(djrcv_dev, data, size);
+		report_processed = false;
+		break;
 	}
 	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
 
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 2e52167..a805d44 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -36,6 +36,12 @@
 #define REPORT_ID_DJ_SHORT			0x20
 #define REPORT_ID_DJ_LONG			0x21
 
+#define REPORT_ID_HIDPP_SHORT			0x10
+#define REPORT_ID_HIDPP_LONG			0x11
+
+#define HIDPP_REPORT_SHORT_LENGTH		7
+#define HIDPP_REPORT_LONG_LENGTH		20
+
 #define REPORT_TYPE_RFREPORT_FIRST		0x01
 #define REPORT_TYPE_RFREPORT_LAST		0x1F
 
-- 
1.8.4.2

