Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaE0SNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:13:11 -0400
Received: from verein.lst.de ([213.95.11.211]:60725 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaE0SNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:13:09 -0400
Date: Tue, 27 May 2014 20:13:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140527181305.GA7975@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com> <20140520152303.GA20352@lst.de> <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com> <20140521053634.GA4764@lst.de> <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here is my counter proposal that requeues via two lists and a work struct
in the request_queue.  I've also tested it with scsi-mq.


--ikeVEW9yuYc//A+q
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-blk-mq-add-helper-to-insert-requests-from-irq-contex.patch"

>From 95f15eda9a87d8545e1dff1b996d9227dfca1129 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 21 May 2014 19:37:11 +0200
Subject: blk-mq: add helper to insert requests from irq context

---
 block/blk-flush.c      |   16 ++++----------
 block/blk-mq.c         |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk-mq.h |    3 +++
 include/linux/blkdev.h |    6 +++++-
 4 files changed, 65 insertions(+), 14 deletions(-)

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
index 62082c5..926d844 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -510,10 +510,57 @@ void blk_mq_requeue_request(struct request *rq)
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
+	LIST_HEAD(head_list);
+	LIST_HEAD(tail_list);
+	struct request *rq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->requeue_lock, flags);
+	list_splice_init(&q->requeue_head_list, &head_list);
+	list_splice_init(&q->requeue_list, &tail_list);
+	spin_unlock_irqrestore(&q->requeue_lock, flags);
+
+	while (!list_empty(&head_list)) {
+		rq = list_entry(head_list.next, struct request, queuelist);
+		blk_mq_insert_request(rq, true, false, false);
+	}
+
+	while (!list_empty(&tail_list)) {
+		rq = list_entry(tail_list.next, struct request, queuelist);
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
+	spin_lock_irqsave(&q->requeue_lock, flags);
+	if (at_head)
+		list_add(&rq->queuelist, &q->requeue_head_list);
+	else
+		list_add_tail(&rq->queuelist, &q->requeue_list);
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
@@ -1777,6 +1824,11 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	q->sg_reserved_size = INT_MAX;
 
+	INIT_WORK(&q->requeue_work, blk_mq_requeue_work);
+	INIT_LIST_HEAD(&q->requeue_head_list);
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
index b0104ba..e137348 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -99,7 +99,6 @@ struct request {
 	struct list_head queuelist;
 	union {
 		struct call_single_data csd;
-		struct work_struct requeue_work;
 		unsigned long fifo_time;
 	};
 
@@ -463,6 +462,11 @@ struct request_queue {
 	struct request		*flush_rq;
 	spinlock_t		mq_flush_lock;
 
+	struct list_head	requeue_list;
+	struct list_head	requeue_head_list;
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work;
+
 	struct mutex		sysfs_lock;
 
 	int			bypass_depth;
-- 
1.7.10.4


--ikeVEW9yuYc//A+q--
