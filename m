Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3CYJDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:03:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21943 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3CYJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:03:07 -0400
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="32349656"
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alex.Lemberg@sandisk.com, Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/3] block: Add API for urgent request handling
Date: Mon, 25 Mar 2013 11:02:53 +0200
Message-Id: <1364202178-8936-1-git-send-email-tlinder@codeaurora.org>
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
index d66b387..b6bb49d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -304,6 +304,13 @@ EXPORT_SYMBOL(blk_sync_queue);
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
@@ -318,7 +325,16 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
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
 
@@ -2267,8 +2283,13 @@ struct request *blk_fetch_request(struct request_queue *q)
 	struct request *rq;
 
 	rq = blk_peek_request(q);
-	if (rq)
+	if (rq) {
+		if (rq->cmd_flags & REQ_URGENT) {
+			WARN_ON(q->dispatched_urgent);
+			q->dispatched_urgent = true;
+		}
 		blk_start_request(rq);
+	}
 	return rq;
 }
 EXPORT_SYMBOL(blk_fetch_request);
diff --git a/block/elevator.c b/block/elevator.c
index 2516ae2..81390d3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -762,6 +762,11 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	if (rq->cmd_flags & REQ_URGENT) {
+		q->notified_urgent = false;
+		WARN_ON(!q->dispatched_urgent);
+		q->dispatched_urgent = false;
+	}
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d4e7bab..7fe32b9 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -182,6 +182,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
+	__REQ_URGENT,		/* urgent request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -195,6 +196,7 @@ enum rq_flag_bits {
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+#define REQ_URGENT		(1 << __REQ_URGENT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7c6839b..711e0b6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -304,6 +304,7 @@ struct request_queue {
 	struct request_list	root_rl;
 
 	request_fn_proc		*request_fn;
+	request_fn_proc		*urgent_request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
@@ -398,6 +399,8 @@ struct request_queue {
 #endif
 
 	struct queue_limits	limits;
+	bool			notified_urgent;
+	bool			dispatched_urgent;
 
 	/*
 	 * sg stuff
@@ -912,6 +915,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
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

