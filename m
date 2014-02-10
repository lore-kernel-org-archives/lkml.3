Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBJSDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbaBJR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:05 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] HID: uHID: implement .raw_request
Date: Mon, 10 Feb 2014 12:58:47 -0500
Message-Id: <1392055139-19631-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uHID is missing a SET_REPORT protocol implementation, but as
.hid_get_raw_report() as been removed from struct hid_device,
there were no means to access GET_REPORT in uhid.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/uhid.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index b6de903..60acee4 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -250,6 +250,21 @@ static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
 	return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);
 }
 
+static int uhid_raw_request(struct hid_device *hid, unsigned char reportnum,
+			    __u8 *buf, size_t len, unsigned char rtype,
+			    int reqtype)
+{
+	switch (reqtype) {
+	case HID_REQ_GET_REPORT:
+		return uhid_hid_get_raw(hid, reportnum, buf, len, rtype);
+	case HID_REQ_SET_REPORT:
+		/* TODO: implement proper SET_REPORT functionality */
+		return -ENOSYS;
+	default:
+		return -EIO;
+	}
+}
+
 static struct hid_ll_driver uhid_hid_driver = {
 	.start = uhid_hid_start,
 	.stop = uhid_hid_stop,
@@ -257,6 +272,7 @@ static struct hid_ll_driver uhid_hid_driver = {
 	.close = uhid_hid_close,
 	.parse = uhid_hid_parse,
 	.output_report = uhid_hid_output_report,
+	.raw_request = uhid_raw_request,
 };
 
 #ifdef CONFIG_COMPAT
-- 
1.8.3.1

