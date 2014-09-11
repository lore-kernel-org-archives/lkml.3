Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaIKNAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51541 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.74994208@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 085/131] HID: logitech-dj: prevent false errors to be
 shown
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-logitech-dj.c | 43 +++++++++++++++++++++++++------------------
 drivers/hid/hid-logitech-dj.h |  1 +
 2 files changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -679,7 +679,6 @@ static int logi_dj_raw_event(struct hid_
 	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
 	struct dj_report *dj_report = (struct dj_report *) data;
 	unsigned long flags;
-	bool report_processed = false;
 
 	dbg_hid("%s, size:%d\n", __func__, size);
 
@@ -706,34 +705,42 @@ static int logi_dj_raw_event(struct hid_
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
 

