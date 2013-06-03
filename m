Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3FCPFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:05:22 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:58871 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606Ab3FCPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:21 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Stefan Weinhuber <wein@de.ibm.com>
Subject: [PATCH 4/9] dasd: Implement block timeout handling
Date: Mon,  3 Jun 2013 17:03:17 +0200
Message-Id: <1370271802-30019-5-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060315-4966-0000-0000-000005EB29B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

This patch implements generic block layer timeout handling
callbacks for DASDs. When the timeout expires the respective
cqr is aborted.

With this timeout handler time-critical request abort
is guaranteed as the abort does not depend on the internal
state of the various DASD driver queues.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/block/dasd.c      |   76 ++++++++++++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_diag.c |    5 ++-
 drivers/s390/block/dasd_eckd.c |    4 +++
 drivers/s390/block/dasd_fba.c  |    5 ++-
 4 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 000e514..87478be 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2573,8 +2573,10 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 		 */
 		cqr->callback_data = (void *) req;
 		cqr->status = DASD_CQR_FILLED;
+		req->completion_data = cqr;
 		blk_start_request(req);
 		list_add_tail(&cqr->blocklist, &block->ccw_queue);
+		INIT_LIST_HEAD(&cqr->devlist);
 		dasd_profile_start(block, cqr, req);
 	}
 }
@@ -2862,6 +2864,80 @@ static void do_dasd_request(struct request_queue *queue)
 }
 
 /*
+ * Block timeout callback, called from the block layer
+ *
+ * request_queue lock is held on entry.
+ *
+ * Return values:
+ * BLK_EH_RESET_TIMER if the request should be left running
+ * BLK_EH_NOT_HANDLED if the request is handled or terminated
+ *		      by the driver.
+ */
+enum blk_eh_timer_return dasd_times_out(struct request *req)
+{
+	struct dasd_ccw_req *cqr = req->completion_data;
+	struct dasd_block *block = req->q->queuedata;
+	struct dasd_device *device;
+	int rc = 0;
+
+	if (!cqr)
+		return BLK_EH_NOT_HANDLED;
+
+	device = cqr->startdev ? cqr->startdev : block->base;
+	DBF_DEV_EVENT(DBF_WARNING, device,
+		      " dasd_times_out cqr %p status %x",
+		      cqr, cqr->status);
+
+	spin_lock(&block->queue_lock);
+	spin_lock(get_ccwdev_lock(device->cdev));
+	cqr->retries = -1;
+	cqr->intrc = -ETIMEDOUT;
+	if (cqr->status >= DASD_CQR_QUEUED) {
+		spin_unlock(get_ccwdev_lock(device->cdev));
+		rc = dasd_cancel_req(cqr);
+	} else if (cqr->status == DASD_CQR_FILLED ||
+		   cqr->status == DASD_CQR_NEED_ERP) {
+		cqr->status = DASD_CQR_TERMINATED;
+		spin_unlock(get_ccwdev_lock(device->cdev));
+	} else if (cqr->status == DASD_CQR_IN_ERP) {
+		struct dasd_ccw_req *searchcqr, *nextcqr, *tmpcqr;
+
+		list_for_each_entry_safe(searchcqr, nextcqr,
+					 &block->ccw_queue, blocklist) {
+			tmpcqr = searchcqr;
+			while (tmpcqr->refers)
+				tmpcqr = tmpcqr->refers;
+			if (tmpcqr != cqr)
+				continue;
+			/* searchcqr is an ERP request for cqr */
+			searchcqr->retries = -1;
+			searchcqr->intrc = -ETIMEDOUT;
+			if (searchcqr->status >= DASD_CQR_QUEUED) {
+				spin_unlock(get_ccwdev_lock(device->cdev));
+				rc = dasd_cancel_req(searchcqr);
+				spin_lock(get_ccwdev_lock(device->cdev));
+			} else if ((searchcqr->status == DASD_CQR_FILLED) ||
+				   (searchcqr->status == DASD_CQR_NEED_ERP)) {
+				searchcqr->status = DASD_CQR_TERMINATED;
+				rc = 0;
+			} else if (searchcqr->status == DASD_CQR_IN_ERP) {
+				/*
+				 * Shouldn't happen; most recent ERP
+				 * request is at the front of queue
+				 */
+				continue;
+			}
+			break;
+		}
+		spin_unlock(get_ccwdev_lock(device->cdev));
+	}
+	dasd_schedule_block_bh(block);
+	spin_unlock(&block->queue_lock);
+
+	return rc ? BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
+}
+
+/*
  * Allocate and initialize request queue and default I/O scheduler.
  */
 static int dasd_alloc_queue(struct dasd_block *block)
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 1548422..feca317 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -583,7 +583,10 @@ dasd_diag_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 
 static void dasd_diag_handle_terminated_request(struct dasd_ccw_req *cqr)
 {
-	cqr->status = DASD_CQR_FILLED;
+	if (cqr->retries < 0)
+		cqr->status = DASD_CQR_FAILED;
+	else
+		cqr->status = DASD_CQR_FILLED;
 };
 
 /* Fill in IOCTL data for device. */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index f4315dc..e25a817 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2381,6 +2381,10 @@ sleep:
 
 static void dasd_eckd_handle_terminated_request(struct dasd_ccw_req *cqr)
 {
+	if (cqr->retries < 0) {
+		cqr->status = DASD_CQR_FAILED;
+		return;
+	}
 	cqr->status = DASD_CQR_FILLED;
 	if (cqr->block && (cqr->startdev != cqr->block->base)) {
 		dasd_eckd_reset_ccw_to_base_io(cqr);
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index d232c83..9cbc8c3 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -428,7 +428,10 @@ out:
 
 static void dasd_fba_handle_terminated_request(struct dasd_ccw_req *cqr)
 {
-	cqr->status = DASD_CQR_FILLED;
+	if (cqr->retries < 0)
+		cqr->status = DASD_CQR_FAILED;
+	else
+		cqr->status = DASD_CQR_FILLED;
 };
 
 static int
-- 
1.7.9.5

