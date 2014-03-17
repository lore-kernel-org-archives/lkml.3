Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaCQNhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:37:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbaCQNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:36 -0400
Message-Id: <20140317133136.024605773@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/39] scsi: split __scsi_queue_insert
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0031-scsi-split-__scsi_queue_insert.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out a helper to set the _blocked values, which we'll reuse for the
blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 53d06e8..cd82e4c 100644
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
-	SCSI_LOG_MLQUEUE(1,
-		 printk("Inserting command %p into mlqueue\n", cmd));
 
 	/*
 	 * Set the appropriate busy bit for the device/host.
@@ -125,6 +109,30 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 			   starget->max_target_blocked);
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
+	SCSI_LOG_MLQUEUE(1,
+		 printk("Inserting command %p into mlqueue\n", cmd));
+
+	scsi_set_blocked(cmd, reason);
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-- 
1.7.10.4


