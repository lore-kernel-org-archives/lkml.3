Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946444Ab3BHOp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:45:26 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52166 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3BHOpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:45:24 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] HID: Extend the interface with report requests
Date: Fri,  8 Feb 2013 15:37:30 +0100
Message-Id: <1360334256-22127-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers send reports directly to underlying device, creating an
unwanted dependency on the underlying transport layer. This patch adds
hid_hw_request() to the interface, thereby removing usbhid from the
lion share of the drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
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
1.8.1

