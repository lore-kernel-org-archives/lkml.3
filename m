Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaBBEvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBBEun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:43 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] HID: i2c-hid: implement ll_driver transport-layer callbacks
Date: Sat,  1 Feb 2014 23:50:21 -0500
Message-Id: <1391316630-29541-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add output_report and raw_request to i2c-hid.
Hopefully, we will manage to have the same transport level between
all the transport drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index ce68a12..5099f1f 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -574,6 +574,28 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 	return ret;
 }
 
+static int i2c_hid_output_report(struct hid_device *hid, __u8 *buf,
+		size_t count)
+{
+	return i2c_hid_output_raw_report(hid, buf, count, HID_OUTPUT_REPORT);
+}
+
+static int i2c_hid_raw_request(struct hid_device *hid, unsigned char reportnum,
+			       __u8 *buf, size_t len, unsigned char rtype,
+			       int reqtype)
+{
+	switch (reqtype) {
+	case HID_REQ_GET_REPORT:
+		return i2c_hid_get_raw_report(hid, reportnum, buf, len, rtype);
+	case HID_REQ_SET_REPORT:
+		if (buf[0] != reportnum)
+			return -EINVAL;
+		return i2c_hid_output_raw_report(hid, buf, len, rtype);
+	default:
+		return -EIO;
+	}
+}
+
 static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
 		int reqtype)
 {
@@ -761,6 +783,8 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
 	.close = i2c_hid_close,
 	.power = i2c_hid_power,
 	.request = i2c_hid_request,
+	.output_report = i2c_hid_output_report,
+	.raw_request = i2c_hid_raw_request,
 };
 
 static int i2c_hid_init_irq(struct i2c_client *client)
-- 
1.8.3.1

