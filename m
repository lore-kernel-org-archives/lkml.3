Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaGHT1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:27:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "James Bottomley" <JBottomley@Parallels.com>,
        "Mike Christie" <michaelc@cs.wisc.edu>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.203839390@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 104/125] [SCSI] Stop accepting SCSI requests before
 removing a device
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b485462aca7df4e32bcf7efb6f84a69e8b640243 upstream.

Avoid that the code for requeueing SCSI requests triggers a
crash by making sure that that code isn't scheduled anymore
after a device has been removed.

Also, source code inspection of __scsi_remove_device() revealed
a race condition in this function: no new SCSI requests must be
accepted for a SCSI device after device removal started.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_lib.c   |  7 ++++---
 drivers/scsi/scsi_sysfs.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -155,13 +155,14 @@ static int __scsi_queue_insert(struct sc
 
 	/*
 	 * Requeue this command.  It will go before all other commands
-	 * that are already in the queue.
+	 * that are already in the queue. Schedule requeue work under
+	 * lock such that the kblockd_schedule_work() call happens
+	 * before blk_cleanup_queue() finishes.
 	 */
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	kblockd_schedule_work(q, &device->requeue_work);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
 }
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -963,13 +963,20 @@ void __scsi_remove_device(struct scsi_de
 		device_del(dev);
 	} else
 		put_device(&sdev->sdev_dev);
+
+	/*
+	 * Stop accepting new requests and wait until all queuecommand() and
+	 * scsi_run_queue() invocations have finished before tearing down the
+	 * device.
+	 */
 	scsi_device_set_state(sdev, SDEV_DEL);
+	blk_cleanup_queue(sdev->request_queue);
+	cancel_work_sync(&sdev->requeue_work);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* Freeing the queue signals to block that we're done */
-	blk_cleanup_queue(sdev->request_queue);
 	put_device(dev);
 }
 

