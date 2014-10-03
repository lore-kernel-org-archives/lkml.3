Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaJCVmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:42:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbaJCVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.16 067/357] HID: logitech-dj: prevent false errors to be shown
Date: Fri,  3 Oct 2014 14:27:33 -0700
Message-Id: <20141003212935.484369785@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 5abfe85c1d4694d5d4bbd13ecc166262b937adf0 upstream.

Commit "HID: logitech: perform bounds checking on device_id early
enough" unfortunately leaks some errors to dmesg which are not real
ones:
- if the report is not a DJ one, then there is not point in checking
  the device_id
- the receiver (index 0) can also receive some notifications which
  can be safely ignored given the current implementation

Move out the test regarding the report_id and also discards
printing errors when the receiver got notified.

Fixes: ad3e14d7c5268c2e24477c6ef54bbdf88add5d36

Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |   43 ++++++++++++++++++++++++------------------
 drivers/hid/hid-logitech-dj.h |    1 
 2 files changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -656,7 +656,6 @@ static int logi_dj_raw_event(struct hid_
 	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
 	struct dj_report *dj_report = (struct dj_report *) data;
 	unsigned long flags;
-	bool report_processed = false;
 
 	dbg_hid("%s, size:%d\n", __func__, size);
 
@@ -683,34 +682,42 @@ static int logi_dj_raw_event(struct hid_
 	 * device (via hid_input_report() ) and return 1 so hid-core does not do
 	 * anything else with it.
 	 */
+
+	/* case 1) */
+	if (data[0] != REPORT_ID_DJ_SHORT)
+		return false;
+
 	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
 	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
-		dev_err(&hdev->dev, "%s: invalid device index:%d\n",
+		/*
+		 * Device index is wrong, bail out.
+		 * This driver can ignore safely the receiver notifications,
+		 * so ignore those reports too.
+		 */
+		if (dj_report->device_index != DJ_RECEIVER_INDEX)
+			dev_err(&hdev->dev, "%s: invalid device index:%d\n",
 				__func__, dj_report->device_index);
 		return false;
 	}
 
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
-	if (dj_report->report_id == REPORT_ID_DJ_SHORT) {
-		switch (dj_report->report_type) {
-		case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
-		case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
-			logi_dj_recv_queue_notification(djrcv_dev, dj_report);
-			break;
-		case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
-			if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] ==
-			    STATUS_LINKLOSS) {
-				logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
-			}
-			break;
-		default:
-			logi_dj_recv_forward_report(djrcv_dev, dj_report);
+	switch (dj_report->report_type) {
+	case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
+	case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
+		logi_dj_recv_queue_notification(djrcv_dev, dj_report);
+		break;
+	case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
+		if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] ==
+		    STATUS_LINKLOSS) {
+			logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
 		}
-		report_processed = true;
+		break;
+	default:
+		logi_dj_recv_forward_report(djrcv_dev, dj_report);
 	}
 	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
 
-	return report_processed;
+	return true;
 }
 
 static int logi_dj_probe(struct hid_device *hdev,
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -27,6 +27,7 @@
 
 #define DJ_MAX_PAIRED_DEVICES			6
 #define DJ_MAX_NUMBER_NOTIFICATIONS		8
+#define DJ_RECEIVER_INDEX			0
 #define DJ_DEVICE_INDEX_MIN 			1
 #define DJ_DEVICE_INDEX_MAX 			6
 


