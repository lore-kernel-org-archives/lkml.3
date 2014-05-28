Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaE1FWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:22:47 -0400
Received: from verein.lst.de ([213.95.11.211]:33739 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaE1FWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:22:46 -0400
Date: Wed, 28 May 2014 07:22:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140528052241.GB21566@lst.de>
References: <5384DB97.70606@kernel.dk> <20140527185301.GA8466@lst.de> <5384DF5E.3020304@kernel.dk> <20140527191510.GA9274@lst.de> <5384E4D4.6040101@kernel.dk> <20140527192130.GA9850@lst.de> <5384E8FA.8080201@kernel.dk> <CACVXFVM6YYW8N0wpKGchAVpLk72qJiqHwiUg4S4Yv+M+o-B=9g@mail.gmail.com> <5385494E.1070803@kernel.dk> <53854A76.1050807@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <53854A76.1050807@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 08:31:18PM -0600, Jens Axboe wrote:
> Christoph, I'll just run a few tests and then queue it up in the morning. 
> Can you send a properly signed-off patch with a commit message as well? I 
> was writing one up, but I still need the signed-off-by.

Attached.


--xHFwDpU9dbj6ez1V
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-blk-mq-add-helper-to-insert-requests-from-irq-contex.patch"

>From 125823de325211c3e96dad884b0d1a52ec04947d Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 21 May 2014 19:37:11 +0200
Subject: blk-mq: add helper to insert requests from irq context

Both the cache flush state machine and the SCSI midlayer want to submit
requests from irq context, and the current per-request requeue_work
unfortunately causes corruption due to sharing with the csd field for
flushes.  Replace them with a per-request_queue list of requests to
be requeued.

Based on an earlier test by Ming Lei.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-flush.c      |   16 +++---------
 block/blk-mq.c         |   64 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk-mq.h |    3 +++
 include/linux/blkdev.h |    5 +++-
 4 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index ec7a224..ef608b3 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,21 +130,13 @@ static void blk_flush_restore_request(struct request *rq)
 	blk_clear_rq_complete(rq);
 }
 
-static void mq_flush_run(struct work_struct *work)
-{
-	struct request *rq;
-
-	rq = container_of(work, struct request, requeue_work);
-
-	memset(&rq->csd, 0, sizeof(rq->csd));
-	blk_mq_insert_request(rq, false, true, false);
-}
-
 static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
-		INIT_WORK(&rq->requeue_work, mq_flush_run);
-		kblockd_schedule_work(&rq->requeue_work);
+		struct request_queue *q = rq->q;
+
+		blk_mq_add_to_requeue_list(rq, add_front);
+		blk_mq_kick_requeue_list(q);
 		return false;
 	} else {
 		if (add_front)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 62082c5..0457010 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -510,10 +510,68 @@ void blk_mq_requeue_request(struct request *rq)
 	blk_clear_rq_complete(rq);
 
 	BUG_ON(blk_queued_rq(rq));
-	blk_mq_insert_request(rq, true, true, false);
+	blk_mq_add_to_requeue_list(rq, true);
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
+static void blk_mq_requeue_work(struct work_struct *work)
+{
+	struct request_queue *q =
+		container_of(work, struct request_queue, requeue_work);
+	LIST_HEAD(rq_list);
+	struct request *rq, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->requeue_lock, flags);
+	list_splice_init(&q->requeue_list, &rq_list);
+	spin_unlock_irqrestore(&q->requeue_lock, flags);
+
+	list_for_each_entry_safe(rq, next, &rq_list, queuelist) {
+		if (!(rq->cmd_flags & REQ_SOFTBARRIER))
+			continue;
+
+		rq->cmd_flags &= ~REQ_SOFTBARRIER;
+		list_del_init(&rq->queuelist);
+		blk_mq_insert_request(rq, true, false, false);
+	}
+
+	while (!list_empty(&rq_list)) {
+		rq = list_entry(rq_list.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		blk_mq_insert_request(rq, false, false, false);
+	}
+
+	blk_mq_run_queues(q, false);
+}
+
+void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags;
+
+	/*
+	 * We abuse this flag that is otherwise used by the I/O scheduler to
+	 * request head insertation from the workqueue.
+	 */
+	BUG_ON(rq->cmd_flags & REQ_SOFTBARRIER);
+
+	spin_lock_irqsave(&q->requeue_lock, flags);
+	if (at_head) {
+		rq->cmd_flags |= REQ_SOFTBARRIER;
+		list_add(&rq->queuelist, &q->requeue_list);
+	} else {
+		list_add_tail(&rq->queuelist, &q->requeue_list);
+	}
+	spin_unlock_irqrestore(&q->requeue_lock, flags);
+}
+EXPORT_SYMBOL(blk_mq_add_to_requeue_list);
+
+void blk_mq_kick_requeue_list(struct request_queue *q)
+{
+	kblockd_schedule_work(&q->requeue_work);
+}
+EXPORT_SYMBOL(blk_mq_kick_requeue_list);
+
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	return tags->rqs[tag];
@@ -1777,6 +1835,10 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	q->sg_reserved_size = INT_MAX;
 
+	INIT_WORK(&q->requeue_work, blk_mq_requeue_work);
+	INIT_LIST_HEAD(&q->requeue_list);
+	spin_lock_init(&q->requeue_lock);
+
 	if (q->nr_hw_queues > 1)
 		blk_queue_make_request(q, blk_mq_make_request);
 	else
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f76bb18..81bb7f1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -173,6 +173,9 @@ void __blk_mq_end_io(struct request *rq, int error);
 
 void blk_mq_requeue_request(struct request *rq);
 
+void blk_mq_add_to_requeue_list(struct request *rq, bool at_head);
+void blk_mq_kick_requeue_list(struct request_queue *q);
+
 void blk_mq_complete_request(struct request *rq);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b0104ba..e90e169 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -99,7 +99,6 @@ struct request {
 	struct list_head queuelist;
 	union {
 		struct call_single_data csd;
-		struct work_struct requeue_work;
 		unsigned long fifo_time;
 	};
 
@@ -463,6 +462,10 @@ struct request_queue {
 	struct request		*flush_rq;
 	spinlock_t		mq_flush_lock;
 
+	struct list_head	requeue_list;
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work;
+
 	struct mutex		sysfs_lock;
 
 	int			bypass_depth;
-- 
1.7.10.4


--xHFwDpU9dbj6ez1V--
