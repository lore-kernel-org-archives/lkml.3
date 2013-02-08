Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab3BHOip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:38:45 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56251 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946496Ab3BHOie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:34 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] HID: Extend the interface with wait io request
Date: Fri,  8 Feb 2013 15:37:31 +0100
Message-Id: <1360334256-22127-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers need to wait for an io from the underlying device, creating
an unwanted dependency on the underlying transport layer. This patch adds
wait() to the interface, thereby removing usbhid from the lion share of
the drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |  1 +
 include/linux/hid.h           | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 366fd09..99d95d3 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1264,6 +1264,7 @@ static struct hid_ll_driver usb_hid_driver = {
 	.power = usbhid_power,
 	.hidinput_input_event = usb_hidinput_input_event,
 	.request = usbhid_request,
+	.wait = usbhid_wait_io,
 };
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 261c713..7071eb3 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -663,6 +663,7 @@ struct hid_driver {
  * @parse: this method is called only once to parse the device data,
  *	   shouldn't allocate anything to not leak memory
  * @request: send report request to device (e.g. feature report)
+ * @wait: wait for buffered io to complete (send/recv reports)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -681,6 +682,8 @@ struct hid_ll_driver {
 	void (*request)(struct hid_device *hdev,
 			struct hid_report *report, int reqtype);
 
+	int (*wait)(struct hid_device *hdev);
+
 };
 
 #define	PM_HINT_FULLON	1<<5
@@ -903,6 +906,17 @@ static inline void hid_hw_request(struct hid_device *hdev,
 		hdev->ll_driver->request(hdev, report, reqtype);
 }
 
+/**
+ * hid_hw_wait - wait for buffered io to complete
+ *
+ * @hdev: hid device
+ */
+static inline void hid_hw_wait(struct hid_device *hdev)
+{
+	if (hdev->ll_driver->wait)
+		hdev->ll_driver->wait(hdev);
+}
+
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
-- 
1.8.1

