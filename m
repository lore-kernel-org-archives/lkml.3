Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaFXOxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:53:23 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61912 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaFXOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:53:22 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] blk-mq: run hw queue asynchronously in blk_mq_start_hw_queues
Date: Tue, 24 Jun 2014 22:53:08 +0800
Message-Id: <1403621588-25109-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From API view, it isn't good to run all hw queues synchronously
in one context, since it isn't correct for multi hw queue case.

So this patch adds 'async' parameter to blk_mq_start_hw_queue(),
and make blk_mq_start_hw_queues() to run hw queues asynchronously
at default.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c         |    6 +++---
 include/linux/blk-mq.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0ef2dc7..f83eacd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -873,12 +873,12 @@ void blk_mq_stop_hw_queues(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_mq_stop_hw_queues);
 
-void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
+void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
 	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 
 	preempt_disable();
-	__blk_mq_run_hw_queue(hctx);
+	blk_mq_run_hw_queue(hctx, async);
 	preempt_enable();
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
@@ -889,7 +889,7 @@ void blk_mq_start_hw_queues(struct request_queue *q)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i)
-		blk_mq_start_hw_queue(hctx);
+		blk_mq_start_hw_queue(hctx, true);
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queues);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eb726b9..49e84b5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -169,7 +169,7 @@ void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_complete_request(struct request *rq);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
-void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
+void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
-- 
1.7.9.5

