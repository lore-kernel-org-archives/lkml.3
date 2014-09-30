Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaI3RUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbaI3RSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:50 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 09/13] HID: logitech-dj: enable notifications on connect/disconnect
Date: Tue, 30 Sep 2014 13:18:31 -0400
Message-Id: <1412097515-17241-10-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The receiver can send HID++ notifications to the DJ devices when the
physical devices are connected/disconnected.
Enable this feature by default.

This command uses a HID++ command instead of a DJ one, so use a direct
call to usbhid instead of using logi_dj_recv_send_report()

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 9bc3942..c917ab6 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -630,7 +630,9 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
 static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 					  unsigned timeout)
 {
+	struct hid_device *hdev = djrcv_dev->hdev;
 	struct dj_report *dj_report;
+	u8 *buf;
 	int retval;
 
 	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
@@ -642,7 +644,6 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	dj_report->report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
 	dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
 	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
-	kfree(dj_report);
 
 	/*
 	 * Ugly sleep to work around a USB 3.0 bug when the receiver is still
@@ -651,6 +652,30 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	 */
 	msleep(50);
 
+	/*
+	 * Magical bits to set up hidpp notifications when the dj devices
+	 * are connected/disconnected.
+	 *
+	 * We can reuse dj_report because HIDPP_REPORT_SHORT_LENGTH is smaller
+	 * than DJREPORT_SHORT_LENGTH.
+	 */
+	buf = (u8 *)dj_report;
+
+	memset(buf, 0, HIDPP_REPORT_SHORT_LENGTH);
+
+	buf[0] = REPORT_ID_HIDPP_SHORT;
+	buf[1] = 0xFF;
+	buf[2] = 0x80;
+	buf[3] = 0x00;
+	buf[4] = 0x00;
+	buf[5] = 0x09;
+	buf[6] = 0x00;
+
+	hid_hw_raw_request(hdev, REPORT_ID_HIDPP_SHORT, buf,
+			HIDPP_REPORT_SHORT_LENGTH, HID_OUTPUT_REPORT,
+			HID_REQ_SET_REPORT);
+
+	kfree(dj_report);
 	return retval;
 }
 
-- 
2.1.0

