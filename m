Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab3FFLXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:23:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3FFLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:23:47 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 3/4] block: Add API for urgent request handling
Date: Thu,  6 Jun 2013 14:23:31 +0300
Message-Id: <1370517817-6225-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support in block & elevator layers for handling
urgent requests. The decision if a request is urgent or not is taken
by the scheduler. Request is marked as urgent in cmd_flags (by the
scheduler) with a new flag - REQ_URGENT.
Urgent request notification is passed to the underlying
block device driver (eMMC for example). Block device driver may decide to
interrupt the currently running low priority request to serve the new
urgent request. By doing so READ latency is greatly reduced in read&write
collision scenarios.

Note that if the current scheduler doesn't implement the urgent request
mechanism, this code path is never activated.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a14987..5368f95 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -295,6 +295,13 @@ EXPORT_SYMBOL(blk_sync_queue);
  *    This variant runs the queue whether or not the queue has been
  *    stopped. Must be called with the queue lock held and interrupts
  *    disabled. See also @blk_run_queue.
+ *
+ *    Device driver will be notified of an urgent request
+ *    pending under the following conditions:
+ *    1. The driver and the current scheduler support urgent reques handling
+ *    2. There is an urgent request pending in the scheduler
+ *    3. There isn't already an urgent request in flight, meaning previously
+ *       notified urgent request completed (!q->notified_urgent)
  */
 inline void __blk_run_queue_uncond(struct request_queue *q)
 {
@@ -309,7 +316,16 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
 	 * can wait until all these request_fn calls have finished.
 	 */
 	q->request_fn_active++;
-	q->request_fn(q);
+
+	if (!q->notified_urgent &&
+		q->elevator->type->ops.elevator_is_urgent_fn &&
+		q->urgent_request_fn &&
+		q->elevator->type->ops.elevator_is_urgent_fn(q)) {
+		q->notified_urgent = true;
+		q->urgent_request_fn(q);
+	} else
+		q->request_fn(q);
+
 	q->request_fn_active--;
 }
 
@@ -2169,6 +2185,10 @@ struct request *blk_peek_request(struct request_queue *q)
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
+			if (rq->cmd_flags_ext & REQ_URGENT) {
+				WARN_ON(q->dispatched_urgent);
+				q->dispatched_urgent = true;
+			}
 			trace_block_rq_issue(q, rq);
 		}
 
diff --git a/block/elevator.c b/block/elevator.c
index e28011b..d0b5f04 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -788,6 +788,11 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	if (rq->cmd_flags_ext & REQ_URGENT) {
+		q->notified_urgent = false;
+		WARN_ON(!q->dispatched_urgent);
+		q->dispatched_urgent = false;
+	}
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 40a921f..c0730bd 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -183,6 +183,7 @@ enum rq_flag_bits {
 
 /* Request flags. For use in the cmd_flags_ext field of struct request */
 enum ext_rq_flag_bits {
+	__REQ_EXT_URGENT,	/* urgent request */
 	__REQ_EXT_NR_BITS,	/* stops here */
 };
 
@@ -196,6 +197,7 @@ enum ext_rq_flag_bits {
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+#define REQ_URGENT		(1 << __REQ_EXT_URGENT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aa36278..bc6d28a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -305,6 +305,7 @@ struct request_queue {
 	struct request_list	root_rl;
 
 	request_fn_proc		*request_fn;
+	request_fn_proc		*urgent_request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
@@ -405,6 +406,8 @@ struct request_queue {
 #endif
 
 	struct queue_limits	limits;
+	bool			notified_urgent;
+	bool			dispatched_urgent;
 
 	/*
 	 * sg stuff
@@ -911,6 +914,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_urgent_request(struct request_queue *q, request_fn_proc *fn);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d703f94..e753f88 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -25,6 +25,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_reinsert_req_fn) (struct request_queue *,
 					struct request *);
+typedef bool (elevator_is_urgent_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -51,6 +52,7 @@ struct elevator_ops
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
 	elevator_reinsert_req_fn *elevator_reinsert_req_fn;
+	elevator_is_urgent_fn *elevator_is_urgent_fn;
 
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
