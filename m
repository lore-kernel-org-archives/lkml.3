Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaKCIXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:23:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:54719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKCIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:23:20 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Richard Weinberger <richard@nod.at>, Ming Lei <tom.leiming@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] blk-mq: handle single queue case in blk_mq_hctx_next_cpu
Date: Mon,  3 Nov 2014 09:23:27 +0100
Message-Id: <1415003008-16683-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003008-16683-1-git-send-email-hch@lst.de>
References: <1415003008-16683-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't duplicate the code to handle the not cpu bounce case in the
caller, do it inside blk_mq_hctx_next_cpu instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b355b59..22e50a5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -780,10 +780,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
  */
 static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 {
-	int cpu = hctx->next_cpu;
+	if (hctx->queue->nr_hw_queues == 1)
+		return WORK_CPU_UNBOUND;
 
 	if (--hctx->next_cpu_batch <= 0) {
-		int next_cpu;
+		int cpu = hctx->next_cpu, next_cpu;
 
 		next_cpu = cpumask_next(hctx->next_cpu, hctx->cpumask);
 		if (next_cpu >= nr_cpu_ids)
@@ -791,9 +792,11 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 
 		hctx->next_cpu = next_cpu;
 		hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
+	
+		return cpu;
 	}
 
-	return cpu;
+	return hctx->next_cpu;
 }
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
@@ -801,16 +804,13 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
 
-	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask))
+	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask)) {
 		__blk_mq_run_hw_queue(hctx);
-	else if (hctx->queue->nr_hw_queues == 1)
-		kblockd_schedule_delayed_work(&hctx->run_work, 0);
-	else {
-		unsigned int cpu;
-
-		cpu = blk_mq_hctx_next_cpu(hctx);
-		kblockd_schedule_delayed_work_on(cpu, &hctx->run_work, 0);
+		return;
 	}
+
+	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
+			&hctx->run_work, 0);
 }
 
 void blk_mq_run_queues(struct request_queue *q, bool async)
@@ -908,16 +908,8 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
 
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
 {
-	unsigned long tmo = msecs_to_jiffies(msecs);
-
-	if (hctx->queue->nr_hw_queues == 1)
-		kblockd_schedule_delayed_work(&hctx->delay_work, tmo);
-	else {
-		unsigned int cpu;
-
-		cpu = blk_mq_hctx_next_cpu(hctx);
-		kblockd_schedule_delayed_work_on(cpu, &hctx->delay_work, tmo);
-	}
+	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
+			&hctx->delay_work, msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_mq_delay_queue);
 
-- 
1.9.1

