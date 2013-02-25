Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab3BYKcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:32:48 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56255 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab3BYKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:32:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] HID: Extend the interface with report requests
Date: Mon, 25 Feb 2013 11:31:43 +0100
Message-Id: <1361788310-6048-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Rydberg <rydberg@euromail.se>

Some drivers send reports directly to underlying device, creating an
unwanted dependency on the underlying transport layer. This patch adds
hid_hw_request() to the interface, thereby removing usbhid from the
lion share of the drivers.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/usbhid/hid-core.c | 13 +++++++++++++
 include/linux/hid.h           | 20 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 8e0c4bf94..366fd09 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1243,6 +1243,18 @@ static int usbhid_power(struct hid_device *hid, int lvl)
 	return r;
 }
 
+static void usbhid_request(struct hid_device *hid, struct hid_report *rep, int reqtype)
+{
+	switch (reqtype) {
+	case HID_REQ_GET_REPORT:
+		usbhid_submit_report(hid, rep, USB_DIR_IN);
+		break;
+	case HID_REQ_SET_REPORT:
+		usbhid_submit_report(hid, rep, USB_DIR_OUT);
+		break;
+	}
+}
+
 static struct hid_ll_driver usb_hid_driver = {
 	.parse = usbhid_parse,
 	.start = usbhid_start,
@@ -1251,6 +1263,7 @@ static struct hid_ll_driver usb_hid_driver = {
 	.close = usbhid_close,
 	.power = usbhid_power,
 	.hidinput_input_event = usb_hidinput_input_event,
+	.request = usbhid_request,
 };
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e14b465..261c713 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -662,6 +662,7 @@ struct hid_driver {
  * @hidinput_input_event: event input event (e.g. ff or leds)
  * @parse: this method is called only once to parse the device data,
  *	   shouldn't allocate anything to not leak memory
+ * @request: send report request to device (e.g. feature report)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -676,6 +677,10 @@ struct hid_ll_driver {
 			unsigned int code, int value);
 
 	int (*parse)(struct hid_device *hdev);
+
+	void (*request)(struct hid_device *hdev,
+			struct hid_report *report, int reqtype);
+
 };
 
 #define	PM_HINT_FULLON	1<<5
@@ -883,6 +888,21 @@ static inline int hid_hw_power(struct hid_device *hdev, int level)
 	return hdev->ll_driver->power ? hdev->ll_driver->power(hdev, level) : 0;
 }
 
+
+/**
+ * hid_hw_request - send report request to device
+ *
+ * @hdev: hid device
+ * @report: report to send
+ * @reqtype: hid request type
+ */
+static inline void hid_hw_request(struct hid_device *hdev,
+				  struct hid_report *report, int reqtype)
+{
+	if (hdev->ll_driver->request)
+		hdev->ll_driver->request(hdev, report, reqtype);
+}
+
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
-- 
1.8.1.2

