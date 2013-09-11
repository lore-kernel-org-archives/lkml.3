Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3IKT5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab3IKT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:57:27 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/10] HID: logitech-dj: validate output report details
Date: Wed, 11 Sep 2013 21:56:56 +0200
Message-Id: <1378929419-6269-8-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

A HID device could send a malicious output report that would cause the
logitech-dj HID driver to leak kernel memory contents to the device, or
trigger a NULL dereference during initialization:

[  304.424553] usb 1-1: New USB device found, idVendor=046d, idProduct=c52b
...
[  304.780467] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  304.781409] IP: [<ffffffff815d50aa>] logi_dj_recv_send_report.isra.11+0x1a/0x90

CVE-2013-2895

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
v3:
 - check for the whole size of the DJ report, as per the spec

 drivers/hid/hid-logitech-dj.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 7800b14..2e53024 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -461,7 +461,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 	struct hid_report *report;
 	struct hid_report_enum *output_report_enum;
 	u8 *data = (u8 *)(&dj_report->device_index);
-	int i;
+	unsigned int i;
 
 	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
 	report = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
@@ -471,7 +471,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 		return -ENODEV;
 	}
 
-	for (i = 0; i < report->field[0]->report_count; i++)
+	for (i = 0; i < DJREPORT_SHORT_LENGTH - 1; i++)
 		report->field[0]->value[i] = data[i];
 
 	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
@@ -791,6 +791,12 @@ static int logi_dj_probe(struct hid_device *hdev,
 		goto hid_parse_fail;
 	}
 
+	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, REPORT_ID_DJ_SHORT,
+				 0, DJREPORT_SHORT_LENGTH - 1)) {
+		retval = -ENODEV;
+		goto hid_parse_fail;
+	}
+
 	/* Starts the usb device and connects to upper interfaces hiddev and
 	 * hidraw */
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-- 
1.8.3.1

