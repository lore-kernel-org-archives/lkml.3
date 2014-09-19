Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaISOXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:23:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61523 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbaISOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:22:58 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] blk-mq: auto-start hw queue in requeue
Date: Fri, 19 Sep 2014 22:22:50 +0800
Message-Id: <1411136570-23439-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requests often need to be retried because of timeout, hardware
busy or sort of reasons via blk_mq_requeue_request(), but at
that time dispatch queue may have been stopped.

This patch starts the dispatch queue automatically in requeue's
work handler, and fixes scsi-mq's timeout issue, which can be
triggered if there are two or more requests timedout.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 80ade9f..edd0ece 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -33,6 +33,8 @@ static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
+static void __blk_mq_run_queues(struct request_queue *q, bool async,
+				bool restart);
 
 /*
  * Check if any of the ctx's have pending work in this hardware queue
@@ -473,7 +475,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
 		blk_mq_insert_request(rq, false, false, false);
 	}
 
-	blk_mq_run_queues(q, false);
+	__blk_mq_run_queues(q, false, true);
 }
 
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
@@ -806,15 +808,21 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	}
 }
 
-void blk_mq_run_queues(struct request_queue *q, bool async)
+static void __blk_mq_run_queues(struct request_queue *q, bool async,
+				bool restart)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
+		bool stopped = test_bit(BLK_MQ_S_STOPPED, &hctx->state);
+
+		if (restart && stopped)
+		    clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+
 		if ((!blk_mq_hctx_has_pending(hctx) &&
 		    list_empty_careful(&hctx->dispatch)) ||
-		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		    (stopped && !restart))
 			continue;
 
 		preempt_disable();
@@ -822,6 +830,11 @@ void blk_mq_run_queues(struct request_queue *q, bool async)
 		preempt_enable();
 	}
 }
+
+void blk_mq_run_queues(struct request_queue *q, bool async)
+{
+	__blk_mq_run_queues(q, async, false);
+}
 EXPORT_SYMBOL(blk_mq_run_queues);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
-- 
1.7.9.5

