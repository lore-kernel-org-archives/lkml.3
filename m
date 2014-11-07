Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaKGWEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:04:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45480 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKGWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:04:14 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Clark Williams <williams@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] blk_mq: call preempt_disable/enable in blk_mq_run_hw_queue, and only if needed
Date: Fri,  7 Nov 2014 23:03:59 +0100
Message-Id: <1415397840-18041-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
References: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preempt_disable/enable surrounds every call to blk_mq_run_hw_queue,
except the one in blk-flush.c.  In fact that one is always asynchronous,
and it does not need smp_processor_id().

We can do the same for all other calls, avoiding preempt_disable when
async is true.  This avoids peppering blk-mq.c with preemption-disabled
regions.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Clark Williams <williams@redhat.com>
Tested-by: Clark Williams <williams@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-mq.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index df8e1e09dd17..c6192ba78950 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -828,9 +828,18 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
 
-	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask))
-		__blk_mq_run_hw_queue(hctx);
-	else if (hctx->queue->nr_hw_queues == 1)
+	if (!async) {
+		preempt_disable();
+		if (cpumask_test_cpu(smp_processor_id(), hctx->cpumask)) {
+			__blk_mq_run_hw_queue(hctx);
+			preempt_enable();
+			return;
+		}
+
+		preempt_enable();
+	}
+
+	if (hctx->queue->nr_hw_queues == 1)
 		kblockd_schedule_delayed_work(&hctx->run_work, 0);
 	else {
 		unsigned int cpu;
@@ -851,9 +860,7 @@ void blk_mq_run_queues(struct request_queue *q, bool async)
 		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
 			continue;
 
-		preempt_disable();
 		blk_mq_run_hw_queue(hctx, async);
-		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(blk_mq_run_queues);
@@ -880,9 +887,7 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 
-	preempt_disable();
 	blk_mq_run_hw_queue(hctx, false);
-	preempt_enable();
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
@@ -907,9 +912,7 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 			continue;
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
-		preempt_disable();
 		blk_mq_run_hw_queue(hctx, async);
-		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
-- 
2.1.0


