Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaBJR7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaBJR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] HID: core: check parameters when sending/receiving data from the device
Date: Mon, 10 Feb 2014 12:58:59 -0500
Message-Id: <1392055139-19631-15-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better to check them soon enough before triggering any kernel panic.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 include/linux/hid.h           | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index d3b8d7a..b50860d 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -277,7 +277,7 @@ static int i2c_hid_set_or_send_report(struct i2c_client *client, u8 reportType,
 	u16 outputRegister = le16_to_cpu(ihid->hdesc.wOutputRegister);
 	u16 maxOutputLength = le16_to_cpu(ihid->hdesc.wMaxOutputLength);
 
-	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
+	/* hid_hw_* already checked that data_len < HID_MAX_BUFFER_SIZE */
 	u16 size =	2			/* size */ +
 			(reportID ? 1 : 0)	/* reportID */ +
 			data_len		/* buf */;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index fa07639..f801506 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -986,6 +986,9 @@ static inline int hid_hw_raw_request(struct hid_device *hdev,
 				  unsigned char reportnum, __u8 *buf,
 				  size_t len, unsigned char rtype, int reqtype)
 {
+	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+		return -EINVAL;
+
 	if (hdev->ll_driver->raw_request)
 		return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
 						    rtype, reqtype);
@@ -1005,6 +1008,9 @@ static inline int hid_hw_raw_request(struct hid_device *hdev,
 static inline int hid_hw_output_report(struct hid_device *hdev, __u8 *buf,
 					size_t len)
 {
+	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+		return -EINVAL;
+
 	if (hdev->ll_driver->output_report)
 		return hdev->ll_driver->output_report(hdev, buf, len);
 
-- 
1.8.3.1

