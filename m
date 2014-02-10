Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaBJR7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbaBJR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] HID: logitech-dj: remove hid_output_raw_report call
Date: Mon, 10 Feb 2014 12:58:53 -0500
Message-Id: <1392055139-19631-9-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-input do not use anymore hid_output_raw_report() to set the LEDs.
Use the correct implementation now and make them working again.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 980ede5..486dbde 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -193,9 +193,6 @@ static const u8 hid_reportid_size_map[NUMBER_OF_HID_REPORTS] = {
 
 static struct hid_ll_driver logi_dj_ll_driver;
 
-static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
-					size_t count,
-					unsigned char report_type);
 static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev);
 
 static void logi_dj_recv_destroy_djhid_device(struct dj_receiver_dev *djrcv_dev,
@@ -262,7 +259,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 	}
 
 	dj_hiddev->ll_driver = &logi_dj_ll_driver;
-	dj_hiddev->hid_output_raw_report = logi_dj_output_hidraw_report;
 
 	dj_hiddev->dev.parent = &djrcv_hdev->dev;
 	dj_hiddev->bus = BUS_USB;
@@ -544,9 +540,10 @@ static void logi_dj_ll_close(struct hid_device *hid)
 	dbg_hid("%s:%s\n", __func__, hid->phys);
 }
 
-static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
-					size_t count,
-					unsigned char report_type)
+static int logi_dj_ll_raw_request(struct hid_device *hid,
+				  unsigned char reportnum, __u8 *buf,
+				  size_t count, unsigned char report_type,
+				  int reqtype)
 {
 	struct dj_device *djdev = hid->driver_data;
 	struct dj_receiver_dev *djrcv_dev = djdev->dj_receiver_dev;
@@ -567,15 +564,8 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 	out_buf[1] = djdev->device_index;
 	memcpy(out_buf + 2, buf, count);
 
-	/*
-	 * hid-generic calls us with hid_output_raw_report(), but the LEDs
-	 * are set through a SET_REPORT command. It works for USB-HID devices
-	 * because usbhid either calls a SET_REPORT or directly send the output
-	 * report depending if the device presents an urbout.
-	 * Let be simple, send a SET_REPORT request.
-	 */
 	ret = hid_hw_raw_request(djrcv_dev->hdev, out_buf[0], out_buf,
-		DJREPORT_SHORT_LENGTH, report_type, HID_REQ_SET_REPORT);
+		DJREPORT_SHORT_LENGTH, report_type, reqtype);
 
 	kfree(out_buf);
 	return ret;
@@ -662,6 +652,7 @@ static struct hid_ll_driver logi_dj_ll_driver = {
 	.stop = logi_dj_ll_stop,
 	.open = logi_dj_ll_open,
 	.close = logi_dj_ll_close,
+	.raw_request = logi_dj_ll_raw_request,
 };
 
 
-- 
1.8.3.1

