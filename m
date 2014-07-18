Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbaGRKLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:11:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:44218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaGRKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:11:07 -0400
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] scsi: split __scsi_queue_insert
Date: Fri, 18 Jul 2014 12:13:01 +0200
Message-Id: <1405678393-11497-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out a helper to set the _blocked values, which we'll reuse for the
blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi_lib.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 04c3684..3ac677c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -75,28 +75,12 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
-/**
- * __scsi_queue_insert - private queue insertion
- * @cmd: The SCSI command being requeued
- * @reason:  The reason for the requeue
- * @unbusy: Whether the queue should be unbusied
- *
- * This is a private queue insertion.  The public interface
- * scsi_queue_insert() always assumes the queue should be unbusied
- * because it's always called before the completion.  This function is
- * for a requeue after completion, which should only occur in this
- * file.
- */
-static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+static void
+scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
 	struct scsi_target *starget = scsi_target(device);
-	struct request_queue *q = device->request_queue;
-	unsigned long flags;
-
-	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
-		"Inserting command %p into mlqueue\n", cmd));
 
 	/*
 	 * Set the appropriate busy bit for the device/host.
@@ -123,6 +107,30 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 		starget->target_blocked = starget->max_target_blocked;
 		break;
 	}
+}
+
+/**
+ * __scsi_queue_insert - private queue insertion
+ * @cmd: The SCSI command being requeued
+ * @reason:  The reason for the requeue
+ * @unbusy: Whether the queue should be unbusied
+ *
+ * This is a private queue insertion.  The public interface
+ * scsi_queue_insert() always assumes the queue should be unbusied
+ * because it's always called before the completion.  This function is
+ * for a requeue after completion, which should only occur in this
+ * file.
+ */
+static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+{
+	struct scsi_device *device = cmd->device;
+	struct request_queue *q = device->request_queue;
+	unsigned long flags;
+
+	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
+		"Inserting command %p into mlqueue\n", cmd));
+
+	scsi_set_blocked(cmd, reason);
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-- 
1.9.1

