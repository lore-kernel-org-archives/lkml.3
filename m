Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFRPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:21:25 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47166 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaFRPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:23 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] blk-mq: use percpu_ref for mq usage count
Date: Wed, 18 Jun 2014 11:21:12 -0400
Message-Id: <1403104872-22236-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blk-mq uses a percpu_counter to keep track of how many
usages are in flight.  The percpu_counter is drained while freezing to
ensure that no usage is left in-flight after freezing is complete.
blk_mq_queue_enter/exit() and blk_mq_[un]freeze_queue() implement this
per-cpu gating mechanism.

This type of code has relatively high chance of subtle bugs which are
extremely difficult to trigger and it's way too hairy to be open coded
in blk-mq.  percpu_ref can serve the same purpose after the recent
changes.  This patch replaces the open-coded per-cpu usage counting
and draining mechanism with percpu_ref.

blk_mq_queue_enter() performs tryget_live on the ref and exit()
performs put.  blk_mq_freeze_queue() kills the ref and waits until the
reference count reaches zero.  blk_mq_unfreeze_queue() revives the ref
and wakes up the waiters.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 block/blk-mq.c         | 68 +++++++++++++++++++++-----------------------------
 include/linux/blkdev.h |  3 ++-
 2 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index eda78c8..7b5701a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -78,34 +78,32 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 
 static int blk_mq_queue_enter(struct request_queue *q)
 {
-	int ret;
-
-	__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
-	smp_mb();
-
-	/* we have problems freezing the queue if it's initializing */
-	if (!q->mq_freeze_depth)
-		return 0;
-
-	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
+	while (true) {
+		int ret;
 
-	spin_lock_irq(q->queue_lock);
-	ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
-		!q->mq_freeze_depth || blk_queue_dying(q),
-		*q->queue_lock);
-	/* inc usage with lock hold to avoid freeze_queue runs here */
-	if (!ret && !blk_queue_dying(q))
-		__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
-	else if (blk_queue_dying(q))
-		ret = -ENODEV;
-	spin_unlock_irq(q->queue_lock);
+		if (percpu_ref_tryget_live(&q->mq_usage_counter))
+			return 0;
 
-	return ret;
+		ret = wait_event_interruptible(q->mq_freeze_wq,
+				!q->mq_freeze_depth || blk_queue_dying(q));
+		if (blk_queue_dying(q))
+			return -ENODEV;
+		if (ret)
+			return ret;
+	}
 }
 
 static void blk_mq_queue_exit(struct request_queue *q)
 {
-	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
+	percpu_ref_put(&q->mq_usage_counter);
+}
+
+static void blk_mq_usage_counter_release(struct percpu_ref *ref)
+{
+	struct request_queue *q =
+		container_of(ref, struct request_queue, mq_usage_counter);
+
+	wake_up_all(&q->mq_freeze_wq);
 }
 
 /*
@@ -118,18 +116,9 @@ void blk_mq_freeze_queue(struct request_queue *q)
 	q->mq_freeze_depth++;
 	spin_unlock_irq(q->queue_lock);
 
-	while (true) {
-		s64 count;
-
-		spin_lock_irq(q->queue_lock);
-		count = percpu_counter_sum(&q->mq_usage_counter);
-		spin_unlock_irq(q->queue_lock);
-
-		if (count == 0)
-			break;
-		blk_mq_run_queues(q, false);
-		msleep(10);
-	}
+	percpu_ref_kill(&q->mq_usage_counter);
+	blk_mq_run_queues(q, false);
+	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
 }
 
 static void blk_mq_unfreeze_queue(struct request_queue *q)
@@ -140,8 +129,10 @@ static void blk_mq_unfreeze_queue(struct request_queue *q)
 	wake = !--q->mq_freeze_depth;
 	WARN_ON_ONCE(q->mq_freeze_depth < 0);
 	spin_unlock_irq(q->queue_lock);
-	if (wake)
+	if (wake) {
+		percpu_ref_reinit(&q->mq_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
+	}
 }
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
@@ -1785,7 +1776,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!q)
 		goto err_hctxs;
 
-	if (percpu_counter_init(&q->mq_usage_counter, 0))
+	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release))
 		goto err_map;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
@@ -1878,7 +1869,7 @@ void blk_mq_free_queue(struct request_queue *q)
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 	blk_mq_free_hw_queues(q, set);
 
-	percpu_counter_destroy(&q->mq_usage_counter);
+	percpu_ref_exit(&q->mq_usage_counter);
 
 	free_percpu(q->queue_ctx);
 	kfree(q->queue_hw_ctx);
@@ -2037,8 +2028,7 @@ static int __init blk_mq_init(void)
 {
 	blk_mq_cpu_init();
 
-	/* Must be called after percpu_counter_hotcpu_callback() */
-	hotcpu_notifier(blk_mq_queue_reinit_notify, -10);
+	hotcpu_notifier(blk_mq_queue_reinit_notify, 0);
 
 	return 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2efe26a..d5933dd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -21,6 +21,7 @@
 #include <linux/bsg.h>
 #include <linux/smp.h>
 #include <linux/rcupdate.h>
+#include <linux/percpu-refcount.h>
 
 #include <asm/scatterlist.h>
 
@@ -484,7 +485,7 @@ struct request_queue {
 #endif
 	struct rcu_head		rcu_head;
 	wait_queue_head_t	mq_freeze_wq;
-	struct percpu_counter	mq_usage_counter;
+	struct percpu_ref	mq_usage_counter;
 	struct list_head	all_q_node;
 
 	struct blk_mq_tag_set	*tag_set;
-- 
1.9.3

