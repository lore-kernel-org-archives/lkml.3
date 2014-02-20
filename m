Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaBTUZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaBTUZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:25:02 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: benjamin.tissoires@gmail.com, jkosina@suse.cz, dh.herrmann@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] HID: hidraw: replace hid_output_raw_report() calls by appropriates ones
Date: Thu, 20 Feb 2014 15:24:50 -0500
Message-Id: <1392927890-2389-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hid_output_raw_report() call as it is not a ll_driver callbacj,
and switch to the hid_hw_* implementation. USB-HID used to fallback
into SET_REPORT when there were no output interrupt endpoint,
so emulating this if hid_hw_output_report() returns -ENOSYS.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

ex 12/14

v2:
- get rid of the test regarding .raw_request now that it is mandatory.

 drivers/hid/hidraw.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index f8708c9..2cc484c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -123,10 +123,6 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 
 	dev = hidraw_table[minor]->hid;
 
-	if (!dev->hid_output_raw_report) {
-		ret = -ENODEV;
-		goto out;
-	}
 
 	if (count > HID_MAX_BUFFER_SIZE) {
 		hid_warn(dev, "pid %d passed too large report\n",
@@ -153,7 +149,20 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 		goto out_free;
 	}
 
-	ret = hid_output_raw_report(dev, buf, count, report_type);
+	if (report_type == HID_OUTPUT_REPORT) {
+		ret = hid_hw_output_report(dev, buf, count);
+		/*
+		 * compatibility with old implementation of USB-HID and I2C-HID:
+		 * if the device does not support receiving output reports,
+		 * on an interrupt endpoint, fallback to SET_REPORT HID command.
+		 */
+		if (ret != -ENOSYS)
+			goto out_free;
+	}
+
+	ret = hid_hw_raw_request(dev, buf[0], buf, count, report_type,
+				HID_REQ_SET_REPORT);
+
 out_free:
 	kfree(buf);
 out:
-- 
1.8.5.3

