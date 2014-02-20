Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaBTUZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:25:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaBTUZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:25:00 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: benjamin.tissoires@gmail.com, jkosina@suse.cz, dh.herrmann@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] HID: input: hid-input remove hid_output_raw_report call
Date: Thu, 20 Feb 2014 15:24:48 -0500
Message-Id: <1392927890-2389-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_output_raw_report() is not a ll_driver callback and should not be used.
To keep the same code path than before, we are forced to play with the
different hid_hw_* calls: if the usb or i2c device does not support
direct output reports, then we will rely on the SET_REPORT HID call.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

ex 7/14

changes since last version:
- replace buf[0] by report->id to prevent a bug with devices not having a report ID.

 drivers/hid/hid-input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index eb00a5b..e3d625a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1153,7 +1153,7 @@ static void hidinput_led_worker(struct work_struct *work)
 					      led_work);
 	struct hid_field *field;
 	struct hid_report *report;
-	int len;
+	int len, ret;
 	__u8 *buf;
 
 	field = hidinput_get_led_field(hid);
@@ -1187,7 +1187,10 @@ static void hidinput_led_worker(struct work_struct *work)
 
 	hid_output_report(report, buf);
 	/* synchronous output report */
-	hid_output_raw_report(hid, buf, len, HID_OUTPUT_REPORT);
+	ret = hid_hw_output_report(hid, buf, len);
+	if (ret == -ENOSYS)
+		hid_hw_raw_request(hid, report->id, buf, len, HID_OUTPUT_REPORT,
+				HID_REQ_SET_REPORT);
 	kfree(buf);
 }
 
@@ -1266,7 +1269,8 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	}
 
 	input_set_drvdata(input_dev, hid);
-	if (hid->ll_driver->request || hid->hid_output_raw_report)
+	if (hid->ll_driver->request || hid->ll_driver->output_report ||
+	    hid->ll_driver->raw_request)
 		input_dev->event = hidinput_input_event;
 	input_dev->open = hidinput_open;
 	input_dev->close = hidinput_close;
-- 
1.8.5.3

