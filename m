Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3CNKkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:40:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab3CNKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 73/88] HID: logitech-dj: do not directly call hid_output_raw_report() during probe
Date: Thu, 14 Mar 2013 10:36:06 +0000
Message-Id: <1363257381-15900-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit dcd9006b1b053c7b1cebe81333261d4fd492ffeb upstream.

hid_output_raw_report() makes a direct call to usb_control_msg(). However,
some USB3 boards have shown that the usb device is not ready during the
.probe(). This blocks the entire usb device, and the paired mice, keyboards
are not functional. The dmesg output is the following:

[   11.912287] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-2/input2
[   11.912537] logitech-djreceiver 0003:046D:C52B.0003: logi_dj_probe:logi_dj_recv_query_paired_devices error:-32
[   11.912636] logitech-djreceiver: probe of 0003:046D:C52B.0003 failed with error -32

Relying on the scheduled call to usbhid_submit_report() fixes the problem.

related bugs:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143
https://bugzilla.redhat.com/show_bug.cgi?id=840391
https://bugzilla.kernel.org/show_bug.cgi?id=49781

Reported-and-tested-by: Bob Bowles <bobjohnbowles@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-logitech-dj.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 9500f2f..8758f38c 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -459,19 +459,25 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 				    struct dj_report *dj_report)
 {
 	struct hid_device *hdev = djrcv_dev->hdev;
-	int sent_bytes;
+	struct hid_report *report;
+	struct hid_report_enum *output_report_enum;
+	u8 *data = (u8 *)(&dj_report->device_index);
+	int i;
 
-	if (!hdev->hid_output_raw_report) {
-		dev_err(&hdev->dev, "%s:"
-			"hid_output_raw_report is null\n", __func__);
+	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
+	report = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
+
+	if (!report) {
+		dev_err(&hdev->dev, "%s: unable to find dj report\n", __func__);
 		return -ENODEV;
 	}
 
-	sent_bytes = hdev->hid_output_raw_report(hdev, (u8 *) dj_report,
-						 sizeof(struct dj_report),
-						 HID_OUTPUT_REPORT);
+	for (i = 0; i < report->field[0]->report_count; i++)
+		report->field[0]->value[i] = data[i];
+
+	usbhid_submit_report(hdev, report, USB_DIR_OUT);
 
-	return (sent_bytes < 0) ? sent_bytes : 0;
+	return 0;
 }
 
 static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
-- 
1.8.1.2

