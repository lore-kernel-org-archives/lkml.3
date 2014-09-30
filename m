Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaI3VhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaI3Vg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/103] HID: logitech-dj: prevent false errors to be shown
Date: Tue, 30 Sep 2014 14:31:03 -0700
Message-Id: <1412112708-27356-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-logitech-dj.c | 43 +++++++++++++++++++++++++------------------
 drivers/hid/hid-logitech-dj.h |  1 +
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index e19efd6..fa1da91 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -679,7 +679,6 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
 	struct dj_report *dj_report = (struct dj_report *) data;
 	unsigned long flags;
-	bool report_processed = false;
 
 	dbg_hid("%s, size:%d\n", __func__, size);
 
@@ -706,34 +705,42 @@ static int logi_dj_raw_event(struct hid_device *hdev,
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
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 4a40003..daeb0aa 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -27,6 +27,7 @@
 
 #define DJ_MAX_PAIRED_DEVICES			6
 #define DJ_MAX_NUMBER_NOTIFICATIONS		8
+#define DJ_RECEIVER_INDEX			0
 #define DJ_DEVICE_INDEX_MIN 			1
 #define DJ_DEVICE_INDEX_MAX 			6
 
-- 
1.9.1

