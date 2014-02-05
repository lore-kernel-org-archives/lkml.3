Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaBEVfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbaBEVdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:33:38 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] HID: usbhid: remove duplicated code
Date: Wed,  5 Feb 2014 16:33:21 -0500
Message-Id: <1391636004-29354-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, no use to keep twice the same code.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/usbhid/hid-core.c | 64 ++++++++-----------------------------------
 1 file changed, 11 insertions(+), 53 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f8ca312..406497b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -915,59 +915,6 @@ static int usbhid_set_raw_report(struct hid_device *hid, unsigned int reportnum,
 	return ret;
 }
 
-
-static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t count,
-		unsigned char report_type)
-{
-	struct usbhid_device *usbhid = hid->driver_data;
-	struct usb_device *dev = hid_to_usb_dev(hid);
-	struct usb_interface *intf = usbhid->intf;
-	struct usb_host_interface *interface = intf->cur_altsetting;
-	int ret;
-
-	if (usbhid->urbout && report_type != HID_FEATURE_REPORT) {
-		int actual_length;
-		int skipped_report_id = 0;
-
-		if (buf[0] == 0x0) {
-			/* Don't send the Report ID */
-			buf++;
-			count--;
-			skipped_report_id = 1;
-		}
-		ret = usb_interrupt_msg(dev, usbhid->urbout->pipe,
-			buf, count, &actual_length,
-			USB_CTRL_SET_TIMEOUT);
-		/* return the number of bytes transferred */
-		if (ret == 0) {
-			ret = actual_length;
-			/* count also the report id */
-			if (skipped_report_id)
-				ret++;
-		}
-	} else {
-		int skipped_report_id = 0;
-		int report_id = buf[0];
-		if (buf[0] == 0x0) {
-			/* Don't send the Report ID */
-			buf++;
-			count--;
-			skipped_report_id = 1;
-		}
-		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-			HID_REQ_SET_REPORT,
-			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			((report_type + 1) << 8) | report_id,
-			interface->desc.bInterfaceNumber, buf, count,
-			USB_CTRL_SET_TIMEOUT);
-		/* count also the report id, if this was a numbered report. */
-		if (ret > 0 && skipped_report_id)
-			ret++;
-	}
-
-	return ret;
-}
-
 static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
@@ -998,6 +945,17 @@ static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
 	return ret;
 }
 
+static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf,
+		size_t count, unsigned char report_type)
+{
+	struct usbhid_device *usbhid = hid->driver_data;
+
+	if (usbhid->urbout && report_type != HID_FEATURE_REPORT)
+		return usbhid_output_report(hid, buf, count);
+
+	return usbhid_set_raw_report(hid, buf[0], buf, count, report_type);
+}
+
 static void usbhid_restart_queues(struct usbhid_device *usbhid)
 {
 	if (usbhid->urbout && !test_bit(HID_OUT_RUNNING, &usbhid->iofl))
-- 
1.8.3.1

