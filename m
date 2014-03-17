Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbaCQNsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:48:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaCQNbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:32 -0400
Message-Id: <20140317133132.655867077@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:27:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/39] scsi: avoid taking host_lock in scsi_run_queue unless nessecary
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0008-scsi-avoid-taking-host_lock-in-scsi_run_queue-unless.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't have starved devices we don't need to take the host lock
to iterate over them.  Also split the function up to be more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62ec84b..aa6a581 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -385,29 +385,12 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 	return 0;
 }
 
-/*
- * Function:	scsi_run_queue()
- *
- * Purpose:	Select a proper request queue to serve next
- *
- * Arguments:	q	- last request's queue
- *
- * Returns:     Nothing
- *
- * Notes:	The previous command was completely finished, start
- *		a new one if possible.
- */
-static void scsi_run_queue(struct request_queue *q)
+static void scsi_starved_list_run(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost;
 	LIST_HEAD(starved_list);
+	struct scsi_device *sdev;
 	unsigned long flags;
 
-	shost = sdev->host;
-	if (scsi_target(sdev)->single_lun)
-		scsi_single_lun_run(sdev);
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->starved_list, &starved_list);
 
@@ -459,6 +442,28 @@ static void scsi_run_queue(struct request_queue *q)
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/*
+ * Function:   scsi_run_queue()
+ *
+ * Purpose:    Select a proper request queue to serve next
+ *
+ * Arguments:  q       - last request's queue
+ *
+ * Returns:     Nothing
+ *
+ * Notes:      The previous command was completely finished, start
+ *             a new one if possible.
+ */
+static void scsi_run_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = q->queuedata;
+
+	if (scsi_target(sdev)->single_lun)
+		scsi_single_lun_run(sdev);
+	if (!list_empty(&sdev->host->starved_list))
+		scsi_starved_list_run(sdev->host);
 
 	blk_run_queue(q);
 }
-- 
1.7.10.4


