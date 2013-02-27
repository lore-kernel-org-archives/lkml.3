Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab3B0PjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:39:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab3B0PjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:39:15 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] HID: Extend the interface with idle requests
Date: Wed, 27 Feb 2013 16:38:17 +0100
Message-Id: <1361979498-24446-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers send the idle command directly to underlying device,
creating an unwanted dependency on the underlying transport layer.
This patch adds hid_hw_idle() to the interface, thereby removing
usbhid from the lion share of the drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/usbhid/hid-core.c | 15 +++++++++++++++
 include/linux/hid.h           | 19 +++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 420466b..effcd3d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1253,6 +1253,20 @@ static void usbhid_request(struct hid_device *hid, struct hid_report *rep, int r
 	}
 }
 
+static int usbhid_idle(struct hid_device *hid, int report, int idle,
+		int reqtype)
+{
+	struct usb_device *dev = hid_to_usb_dev(hid);
+	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
+	struct usb_host_interface *interface = intf->cur_altsetting;
+	int ifnum = interface->desc.bInterfaceNumber;
+
+	if (reqtype != HID_REQ_SET_IDLE)
+		return -EINVAL;
+
+	return hid_set_idle(dev, ifnum, report, idle);
+}
+
 static struct hid_ll_driver usb_hid_driver = {
 	.parse = usbhid_parse,
 	.start = usbhid_start,
@@ -1263,6 +1277,7 @@ static struct hid_ll_driver usb_hid_driver = {
 	.hidinput_input_event = usb_hidinput_input_event,
 	.request = usbhid_request,
 	.wait = usbhid_wait_io,
+	.idle = usbhid_idle,
 };
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7071eb3..863744c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -664,6 +664,7 @@ struct hid_driver {
  *	   shouldn't allocate anything to not leak memory
  * @request: send report request to device (e.g. feature report)
  * @wait: wait for buffered io to complete (send/recv reports)
+ * @idle: send idle request to device
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -683,6 +684,7 @@ struct hid_ll_driver {
 			struct hid_report *report, int reqtype);
 
 	int (*wait)(struct hid_device *hdev);
+	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 
 };
 
@@ -907,6 +909,23 @@ static inline void hid_hw_request(struct hid_device *hdev,
 }
 
 /**
+ * hid_hw_idle - send idle request to device
+ *
+ * @hdev: hid device
+ * @report: report to control
+ * @idle: idle state
+ * @reqtype: hid request type
+ */
+static inline int hid_hw_idle(struct hid_device *hdev, int report, int idle,
+		int reqtype)
+{
+	if (hdev->ll_driver->idle)
+		return hdev->ll_driver->idle(hdev, report, idle, reqtype);
+
+	return 0;
+}
+
+/**
  * hid_hw_wait - wait for buffered io to complete
  *
  * @hdev: hid device
-- 
1.8.1.2

