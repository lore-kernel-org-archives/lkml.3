Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaGHTog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:44:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54064 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.11378700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 106/125] [SCSI] dual scan thread bug fix
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_scan.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -332,6 +332,7 @@ static void scsi_target_destroy(struct s
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
@@ -396,9 +397,15 @@ static void scsi_target_reap_ref_release
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
 
@@ -518,11 +525,13 @@ static struct scsi_target *scsi_alloc_ta
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

