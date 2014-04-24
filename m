Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaDXIxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaDXIxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/182] [SCSI] dual scan thread bug fix
Date: Thu, 24 Apr 2014 09:49:38 +0100
Message-Id: <1398329507-5911-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit f2495e228fce9f9cec84367547813cbb0d6db15a upstream.

In the highly unusual case where two threads are running concurrently through
the scanning code scanning the same target, we run into the situation where
one may allocate the target while the other is still using it.  In this case,
because the reap checks for STARGET_CREATED and kills the target without
reference counting, the second thread will do the wrong thing on reap.

Fix this by reference counting even creates and doing the STARGET_CREATED
check in the final put.

Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_scan.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5fad646..4109530 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -320,6 +320,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
@@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
 	struct scsi_target *starget
 		= container_of(kref, struct scsi_target, reap_ref);
 
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	starget->state = STARGET_DEL;
+	/*
+	 * if we get here and the target is still in the CREATED state that
+	 * means it was allocated but never made visible (because a scan
+	 * turned up no LUNs), so don't call device_del() on it.
+	 */
+	if (starget->state != STARGET_CREATED) {
+		transport_remove_device(&starget->dev);
+		device_del(&starget->dev);
+	}
 	scsi_target_destroy(starget);
 }
 
@@ -506,11 +513,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
+	/*
+	 * serious problem if this triggers: STARGET_DEL is only set in the if
+	 * the reap_ref drops to zero, so we're trying to do another final put
+	 * on an already released kref
+	 */
 	BUG_ON(starget->state == STARGET_DEL);
-	if (starget->state == STARGET_CREATED)
-		scsi_target_destroy(starget);
-	else
-		scsi_target_reap_ref_put(starget);
+	scsi_target_reap_ref_put(starget);
 }
 
 /**
-- 
1.9.1

