Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaIWCej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:34:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:37480 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbaIWCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:34:36 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 05/45] HID: logitech: perform bounds checking on device_id early enough
Date: Tue, 23 Sep 2014 10:31:07 +0800
Message-Id: <1411439507-30391-5-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hid/hid-logitech-dj.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 3bfd74f..bdf9f53 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -230,13 +230,6 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
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
@@ -715,6 +708,12 @@ static int logi_dj_raw_event(struct hid_device *hdev,
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
1.7.9.5

