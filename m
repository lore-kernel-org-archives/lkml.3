Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaESPGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:06:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:65011 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaESPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:06:13 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] block: mq flush: fix race between IPI handler and mq flush worker
Date: Mon, 19 May 2014 23:05:50 +0800
Message-Id: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'struct request', both 'csd' and 'requeue_work' are
defined inside one union, unfortunately, the below race
can be triggered:

	- one PREFLUSH request may be queued inside the previous
	POSTFLUSH request's IPI handler, and both the two requests
	share one request instance(q->flush_rq)

	- IPI interrupt for the previous POSTFLUSH request comes, and
	generic_smp_call_function_single_interrupt() is called to run
	the remote complete handler by csd->func();

	- the POSTFLUSH flush request's end_io callback(flush_end_io)
	is called

	- finally inside the path, blk_flush_queue_rq() calls
	INIT_WORK(&rq->requeue_work,...) and schedule the work for
	queuing a new PREFLUSH request

	- csd->func(csd->info) returns, and csd_unlock(csd) is called,
	see generic_smp_call_function_single_interrupt()

	- then the initialized rq->requeue_work is changed by
	csd_unlock(): the lowerest bit of requeue_work.func is
	observed that it was cleared, and function address can
	be unaligned on x86.

	- the work func of mq_flush_run() will never be run

	- fs sync hangs forever

This patch introduces one exclusive work_struct inside
request_queue for queuing flush request only to fix the
problem.

Cc: <stable@vger.kernel.org>  #3.14
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
Another simple fix is to disable ipi for flush request, but looks
this one should be better.

 block/blk-flush.c      |   43 +++++++++++++++++++++++++++++++++++++++----
 include/linux/blkdev.h |    1 +
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index ec7a224..42e8a34 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,21 +130,56 @@ static void blk_flush_restore_request(struct request *rq)
 	blk_clear_rq_complete(rq);
 }
 
+static void __mq_flush_run(struct request *rq)
+{
+	memset(&rq->csd, 0, sizeof(rq->csd));
+	blk_mq_insert_request(rq, false, true, false);
+}
+
 static void mq_flush_run(struct work_struct *work)
 {
+	struct request_queue *q;
+	struct request *rq;
+
+	q = container_of(work, struct request_queue, flush_work);
+	rq = q->flush_rq;
+
+	__mq_flush_run(rq);
+}
+
+static void mq_data_flush_run(struct work_struct *work)
+{
 	struct request *rq;
 
 	rq = container_of(work, struct request, requeue_work);
 
-	memset(&rq->csd, 0, sizeof(rq->csd));
-	blk_mq_insert_request(rq, false, true, false);
+	__mq_flush_run(rq);
 }
 
 static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
-		INIT_WORK(&rq->requeue_work, mq_flush_run);
-		kblockd_schedule_work(&rq->requeue_work);
+		struct work_struct *wk;
+		work_func_t func;
+
+		/*
+		 * Flush request need use its own work_struct
+		 * instead of rq->requeue_work because it
+		 * will be changed by csd_unlock() in future
+		 * if the request(PREFLUSH) is being queued
+		 * from previous POSTFLUSH request's IPI
+		 * handler context.
+		 */
+		if (rq == rq->q->flush_rq) {
+			wk = &rq->q->flush_work;
+			func = mq_flush_run;
+		} else {
+			wk = &rq->requeue_work;
+			func = mq_data_flush_run;
+		}
+
+		INIT_WORK(wk, func);
+		kblockd_schedule_work(wk);
 		return false;
 	} else {
 		if (add_front)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1f1ecc7..4c8f24c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -461,6 +461,7 @@ struct request_queue {
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
 	struct request		*flush_rq;
+	struct work_struct	flush_work;
 	spinlock_t		mq_flush_lock;
 
 	struct mutex		sysfs_lock;
-- 
1.7.9.5

