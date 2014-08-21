Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaHUPpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:45:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaHUPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:45:28 -0400
Date: Thu, 21 Aug 2014 10:45:26 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: logitech: perform bounds checking on device_id early
 enough
Message-ID: <alpine.LNX.2.00.1408211044300.23162@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_index is a char type and the size of paired_dj_deivces is 7 
elements, therefore proper bounds checking has to be applied to 
device_index before it is used.

We are currently performing the bounds checking in
logi_dj_recv_add_djhid_device(), which is too late, as malicious device
could send REPORT_TYPE_NOTIF_DEVICE_UNPAIRED early enough and trigger the
problem in one of the report forwarding functions called from
logi_dj_raw_event().

Fix this by performing the check at the earliest possible ocasion in
logi_dj_raw_event().

Cc: stable@vger.kernel.org
Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-logitech-dj.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index ca0ab51..b7ba829 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -238,13 +238,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 		return;
 	}
 
-	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
-	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
-		dev_err(&djrcv_hdev->dev, "%s: invalid device index:%d\n",
-			__func__, dj_report->device_index);
-		return;
-	}
-
 	if (djrcv_dev->paired_dj_devices[dj_report->device_index]) {
 		/* The device is already known. No need to reallocate it. */
 		dbg_hid("%s: device is already known\n", __func__);
@@ -690,6 +683,12 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	 * device (via hid_input_report() ) and return 1 so hid-core does not do
 	 * anything else with it.
 	 */
+	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
+	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
+		dev_err(&hdev->dev, "%s: invalid device index:%d\n",
+				__func__, dj_report->device_index);
+		return false;
+	}
 
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
 	if (dj_report->report_id == REPORT_ID_DJ_SHORT) {

-- 
Jiri Kosina
SUSE Labs
