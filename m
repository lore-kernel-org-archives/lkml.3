Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169Ab3GLRIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:08:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60992 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab3GLRIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:08:11 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND v2 3/4] block: Add API for URGENT request handling
Date: Fri, 12 Jul 2013 20:07:52 +0300
Message-Id: <1373648878-17268-1-git-send-email-tlinder@codeaurora.org>
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
index bf4f836..3ab3a62 100644
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
 
@@ -1192,6 +1208,18 @@ static void __blk_put_back_rq(struct request_queue *q, struct request *rq)
 		blk_queue_end_tag(q, rq);
 
 	BUG_ON(blk_queued_rq(rq));
+
+	if (rq->cmd_flags & REQ_URGENT) {
+		/*
+		 * It's not compliant with the design to re-insert
+		 * urgent requests. We want to be able to track this
+		 * down.
+		 */
+		pr_debug("%s(): requeueing/reinserting an URGENT request",
+			__func__);
+		WARN_ON(!q->dispatched_urgent);
+		q->dispatched_urgent = false;
+	}
 }
 
 /**
@@ -2157,6 +2185,8 @@ struct request *blk_peek_request(struct request_queue *q)
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
+			if (rq->cmd_flags & REQ_URGENT)
+				q->dispatched_urgent = true;
 			trace_block_rq_issue(q, rq);
 		}
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..2c63a26 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -100,6 +100,18 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
+ * blk_urgent_request() - Set an urgent_request handler function for queue
+ * @q:		queue
+ * @fn:		handler for urgent requests
+ *
+ */
+void blk_urgent_request(struct request_queue *q, request_fn_proc *fn)
+{
+	q->urgent_request_fn = fn;
+}
+EXPORT_SYMBOL(blk_urgent_request);
+
+/**
  * blk_set_default_limits - reset limits to default values
  * @lim:  the queue_limits structure to reset
  *
diff --git a/block/elevator.c b/block/elevator.c
index a0b462d..92bad80 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -780,6 +780,10 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	if (rq->cmd_flags & REQ_URGENT) {
+		q->notified_urgent = false;
+		q->dispatched_urgent = false;
+	}
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c26801e..db123c8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -178,6 +178,7 @@ enum rq_flag_bits {
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_PM,		/* runtime pm request */
+	__REQ_URGENT,	/* urgent request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -191,6 +192,7 @@ enum rq_flag_bits {
 #define REQ_DISCARD		(1ULL << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
+#define REQ_URGENT		(1ULL << __REQ_URGENT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84d51bd..12cb015 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -304,6 +304,7 @@ struct request_queue {
 	struct request_list	root_rl;
 
 	request_fn_proc		*request_fn;
+	request_fn_proc		*urgent_request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
@@ -404,6 +405,8 @@ struct request_queue {
 #endif
 
 	struct queue_limits	limits;
+	bool			notified_urgent;
+	bool			dispatched_urgent;
 
 	/*
 	 * sg stuff
@@ -910,6 +913,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_urgent_request(struct request_queue *q, request_fn_proc *fn);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d458ea4..b3afa35 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,6 +26,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_reinsert_req_fn) (struct request_queue *,
 					struct request *);
+typedef bool (elevator_is_urgent_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -53,6 +54,7 @@ struct elevator_ops
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
of Code Aurora Forum, hosted by The Linux Foundatio
