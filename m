Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbaICWSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbaICWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.16 004/125] HID: logitech: perform bounds checking on device_id early enough
Date: Wed,  3 Sep 2014 15:06:01 -0700
Message-Id: <20140903220623.789579208@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -238,13 +238,6 @@ static void logi_dj_recv_add_djhid_devic
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
@@ -690,6 +683,12 @@ static int logi_dj_raw_event(struct hid_
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


