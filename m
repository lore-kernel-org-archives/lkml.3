Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3ELKeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 06:34:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23083 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3ELKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 06:34:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="46378595"
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 1/3] block: Add support for reinsert a dispatched req
Date: Sun, 12 May 2013 13:33:56 +0300
Message-Id: <1368354841-28479-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for reinserting a dispatched request back to the
scheduler's internal data structures.
This capability is used by the device driver when it chooses to
interrupt the current request transmission and execute another (more
urgent) pending request. For example: interrupting long write in order
to handle pending read. The device driver re-inserts the
remaining write request back to the scheduler, to be rescheduled
for transmission later on.

Add API for verifying whether the current scheduler
supports reinserting requests mechanism. If reinsert mechanism isn't
supported by the scheduler, this code path will never be activated.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index 0981174..adab72d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1184,31 +1184,92 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 }
 EXPORT_SYMBOL(blk_make_request);
 
-/**
- * blk_requeue_request - put a request back on queue
+/*
+ * blk_readd_request - put the request back to the block layer data structures
  * @q:		request queue where request should be inserted
  * @rq:		request to be inserted
+ * @requeue:	if true the request will be placed at the head
+ *			of the dispatch queue. If false - reinserted to the
+ *			scheduler
  *
  * Description:
- *    Drivers often keep queueing requests until the hardware cannot accept
- *    more, when that condition happens we need to put the request back
- *    on the queue. Must be called with queue lock held.
+ *    This function requeues or reinsert the request back to the block layer.
+ *    See documentation of blk_requeue_request and blk_reinsert_request for
+ *    more details.
+ * Return: 0 on success, error code on fail
  */
-void blk_requeue_request(struct request_queue *q, struct request *rq)
+static int blk_readd_request(struct request_queue *q, struct request *rq,
+			bool requeue)
 {
+	int ret = 0;
+	if (unlikely(!rq) || unlikely(!q))
+		return -EIO;
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
-	trace_block_rq_requeue(q, rq);
 
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
 	BUG_ON(blk_queued_rq(rq));
 
-	elv_requeue_request(q, rq);
+	if (requeue) {
+		trace_block_rq_requeue(q, rq);
+		elv_requeue_request(q, rq);
+	} else
+		ret = elv_reinsert_request(q, rq);
+
+	return ret;
+}
+
+/**
+ * blk_requeue_request - put a request back on queue
+ * @q:		request queue where request should be inserted
+ * @rq:		request to be inserted
+ *
+ * Description:
+ *    Drivers often keep queueing requests until the hardware cannot accept
+ *    more, when that condition happens we need to put the request back
+ *    on the queue. Must be called with queue lock held.
+ */
+void blk_requeue_request(struct request_queue *q, struct request *rq)
+{
+	blk_readd_request(q, rq, true);
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
+/**
+ * blk_reinsert_request() - Insert a request back to the scheduler
+ * @q:		request queue
+ * @rq:		request to be inserted
+ *
+ * This function inserts the request back to the scheduler as if
+ * it was never dispatched.
+ *
+ * Return: 0 on success, error code on fail
+ */
+int blk_reinsert_request(struct request_queue *q, struct request *rq)
+{
+	return blk_readd_request(q, rq, false);
+}
+EXPORT_SYMBOL(blk_reinsert_request);
+
+/**
+ * blk_reinsert_req_sup() - check whether the scheduler supports
+ *          reinsertion of requests
+ * @q:		request queue
+ *
+ * Returns true if the current scheduler supports reinserting
+ * request. False otherwise
+ */
+bool blk_reinsert_req_sup(struct request_queue *q)
+{
+	if (unlikely(!q))
+		return false;
+	return q->elevator->type->ops.elevator_reinsert_req_fn ? true : false;
+}
+EXPORT_SYMBOL(blk_reinsert_req_sup);
+
 static void add_acct_request(struct request_queue *q, struct request *rq,
 			     int where)
 {
diff --git a/block/elevator.c b/block/elevator.c
index eba5b04c..e28011b 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -577,6 +577,41 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
+/**
+ * elv_reinsert_request() - Insert a request back to the scheduler
+ * @q:		request queue where request should be inserted
+ * @rq:		request to be inserted
+ *
+ * This function returns the request back to the scheduler to be
+ * inserted as if it was never dispatched
+ *
+ * Return: 0 on success, error code on failure
+ */
+int elv_reinsert_request(struct request_queue *q, struct request *rq)
+{
+	int res;
+
+	if (!q->elevator->type->ops.elevator_reinsert_req_fn)
+		return -EPERM;
+
+	res = q->elevator->type->ops.elevator_reinsert_req_fn(q, rq);
+	if (!res) {
+		/*
+		 * it already went through dequeue, we need to decrement the
+		 * in_flight count again
+		 */
+		if (blk_account_rq(rq)) {
+			q->in_flight[rq_is_sync(rq)]--;
+			if (rq->cmd_flags & REQ_SORTED)
+				elv_deactivate_rq(q, rq);
+		}
+		rq->cmd_flags &= ~REQ_STARTED;
+		q->nr_sorted++;
+	}
+
+	return res;
+}
+
 void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ddc2f80..102d217 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -738,6 +738,8 @@ extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
 extern void blk_requeue_request(struct request_queue *, struct request *);
+extern int blk_reinsert_request(struct request_queue *q, struct request *rq);
+extern bool blk_reinsert_req_sup(struct request_queue *q);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index acd0312..d703f94 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -23,6 +23,8 @@ typedef void (elevator_bio_merged_fn) (struct request_queue *,
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
+typedef int (elevator_reinsert_req_fn) (struct request_queue *,
+					struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -48,6 +50,8 @@ struct elevator_ops
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
+	elevator_reinsert_req_fn *elevator_reinsert_req_fn;
+
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
 
@@ -126,6 +130,7 @@ extern void elv_merged_request(struct request_queue *, struct request *, int);
 extern void elv_bio_merged(struct request_queue *q, struct request *,
 				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
+extern int elv_reinsert_request(struct request_queue *, struct request *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
