Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaI3Vqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:46:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaI3Vis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/103] HID: logitech: perform bounds checking on device_id early enough
Date: Tue, 30 Sep 2014 14:30:37 -0700
Message-Id: <1412112708-27356-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit ad3e14d7c5268c2e24477c6ef54bbdf88add5d36 upstream.

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

Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-logitech-dj.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index a7947d8..e19efd6 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -237,13 +237,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
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
@@ -713,6 +706,12 @@ static int logi_dj_raw_event(struct hid_device *hdev,
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
1.9.1

