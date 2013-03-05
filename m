Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3CEQKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:10:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3CEQJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:09:59 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Bowles <bobjohnbowles@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: logitech-dj: do not directly call hid_output_raw_report() during probe
Date: Tue,  5 Mar 2013 17:09:00 +0100
Message-Id: <1362499740-32459-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_output_raw_report() makes a direct call to usb_control_msg(). However,
some USB3 boards have shown that the usb device is not ready during the
.probe(). This blocks the entire usb device, and the paired mice, keyboards
are not functional. The dmesg output is the following:

[   11.912287] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-2/input2
[   11.912537] logitech-djreceiver 0003:046D:C52B.0003: logi_dj_probe:logi_dj_recv_query_paired_devices error:-32
[   11.912636] logitech-djreceiver: probe of 0003:046D:C52B.0003 failed with error -32

Relying on the scheduled call to .hid_hw_request() fixes the problem.

related bugs:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143
https://bugzilla.redhat.com/show_bug.cgi?id=840391
https://bugzilla.kernel.org/show_bug.cgi?id=49781

Reported-and-tested-by: Bob Bowles <bobjohnbowles@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi guys,

this bug has taken too long to be solved. I managed to figure out the root cause
recently thanks to the work of Jelle Foks in lp#1039143.

Jiri, I based this fix on top of your for-3.10/logitech branch.
It *will* failed to build when you will merge it with the branch
for-3.10/hid-driver-transport-cleanups. This is due to the use of
usbhid_submit_report() instead of hid_hw_request(). The 

However, I prefer do it that way so that I can send it to "stable" to fix all
the current releases since 3.2 (I guess only the LTS v3.4 will pick it and the
current 3.8, but distros can then cherry-pick it easily).

Is that ok for you?

Cheers,
Benjamin

 drivers/hid/hid-logitech-dj.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 199b78c..147b59c 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -419,19 +419,25 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
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
1.8.1.4

