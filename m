Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab3JJPv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab3JJPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 042/104] HID: logitech-dj: validate output report details
Date: Thu, 10 Oct 2013 08:41:30 -0700
Message-Id: <1381419752-29733-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 297502abb32e225fb23801fcdb0e4f6f8e17099a upstream.

A HID device could send a malicious output report that would cause the
logitech-dj HID driver to leak kernel memory contents to the device, or
trigger a NULL dereference during initialization:

[  304.424553] usb 1-1: New USB device found, idVendor=046d, idProduct=c52b
...
[  304.780467] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  304.781409] IP: [<ffffffff815d50aa>] logi_dj_recv_send_report.isra.11+0x1a/0x90

CVE-2013-2895

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-logitech-dj.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 8758f38c..4288123 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -462,7 +462,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 	struct hid_report *report;
 	struct hid_report_enum *output_report_enum;
 	u8 *data = (u8 *)(&dj_report->device_index);
-	int i;
+	unsigned int i;
 
 	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
 	report = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
@@ -472,7 +472,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 		return -ENODEV;
 	}
 
-	for (i = 0; i < report->field[0]->report_count; i++)
+	for (i = 0; i < DJREPORT_SHORT_LENGTH - 1; i++)
 		report->field[0]->value[i] = data[i];
 
 	usbhid_submit_report(hdev, report, USB_DIR_OUT);
@@ -784,6 +784,12 @@ static int logi_dj_probe(struct hid_device *hdev,
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
1.8.1.2

