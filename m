Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab3GLRIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:08:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32780 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab3GLRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:08:34 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 4/4] block: Add URGENT request notification support to CFQ scheduler
Date: Fri, 12 Jul 2013 20:08:23 +0300
Message-Id: <1373648903-17382-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the scheduler reports to the block layer that there is an urgent
request pending, the device driver may decide to stop the transmission
of the current request in order to handle the urgent one. This is done
in order to reduce the latency of an urgent request. For example:
long WRITE may be stopped to handle an urgent READ.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d5bbdcf..9fb71bd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -320,6 +320,9 @@ struct cfq_data {
 	unsigned long workload_expires;
 	struct cfq_group *serving_group;
 
+	unsigned int nr_urgent_pending;
+	unsigned int nr_urgent_in_flight;
+
 	/*
 	 * Each priority tree is sorted by next_request position.  These
 	 * trees are used when determining if two or more queues are
@@ -2783,6 +2786,12 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	(RQ_CFQG(rq))->dispatched++;
 	elv_dispatch_sort(q, rq);
 
+	if (rq->cmd_flags & REQ_URGENT) {
+		if (cfqd->nr_urgent_pending)
+			cfqd->nr_urgent_pending--;
+		cfqd->nr_urgent_in_flight++;
+	}
+
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfqg_stats_update_dispatch(cfqq->cfqg, blk_rq_bytes(rq), rq->cmd_flags);
@@ -3856,12 +3865,13 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 }
 
 /*
- * Called when a new fs request (rq) is added (to cfqq). Check if there's
+ * Called when a new fs request (rq) is added or an older
+ * request is reinserted back (to cfqq). Check if there's
  * something we should do about it
  */
 static void
 cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		struct request *rq)
+		struct request *rq, bool run_queue)
 {
 	struct cfq_io_cq *cic = RQ_CIC(rq);
 
@@ -3891,7 +3901,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			    cfqd->busy_queues > 1) {
 				cfq_del_timer(cfqd, cfqq);
 				cfq_clear_cfqq_wait_request(cfqq);
-				__blk_run_queue(cfqd->queue);
+				if (run_queue)
+					__blk_run_queue(cfqd->queue);
 			} else {
 				cfqg_stats_update_idle_time(cfqq->cfqg);
 				cfq_mark_cfqq_must_dispatch(cfqq);
@@ -3905,10 +3916,45 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
-		__blk_run_queue(cfqd->queue);
+		if (run_queue)
+			__blk_run_queue(cfqd->queue);
 	}
 }
 
+/* Called when a request (rq) is reinserted (to cfqq). */
+static void
+cfq_rq_requeued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+		struct request *rq)
+{
+	cfqq->dispatched--;
+	(RQ_CFQG(rq))->dispatched--;
+
+	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
+	cfq_rq_enqueued(cfqd, cfqq, rq, false);
+}
+
+static int cfq_reinsert_request(struct request_queue *q, struct request *rq)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+
+	if (!cfqq || cfqq->cfqd != cfqd)
+		return -EIO;
+
+	cfq_log_cfqq(cfqd, cfqq, "re-insert_request");
+	list_add(&rq->queuelist, &cfqq->fifo);
+	cfq_add_rq_rb(rq);
+
+	cfq_rq_requeued(cfqd, cfqq, rq);
+	if (rq->cmd_flags & REQ_URGENT) {
+		if (cfqd->nr_urgent_in_flight)
+			cfqd->nr_urgent_in_flight--;
+		cfqd->nr_urgent_pending++;
+	}
+
+	return 0;
+}
+
 static void cfq_insert_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
@@ -3922,7 +3968,44 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_add_rq_rb(rq);
 	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
 				 rq->cmd_flags);
-	cfq_rq_enqueued(cfqd, cfqq, rq);
+	cfq_rq_enqueued(cfqd, cfqq, rq, true);
+
+	if (rq->cmd_flags & REQ_URGENT) {
+		WARN_ON(1);
+		blk_dump_rq_flags(rq, "");
+		rq->cmd_flags &= ~REQ_URGENT;
+	}
+
+	/*
+	 * Request is considered URGENT if:
+	 * 1. The queue being served is of a lower IO priority then the new
+	 *    request
+	 * OR:
+	 * 2. The workload being performed is ASYNC
+	 * Only READ requests may be considered as URGENT
+	 */
+	if ((cfqd->active_queue &&
+		 cfqq->ioprio_class < cfqd->active_queue->ioprio_class) ||
+		(cfqd->serving_wl_type == ASYNC_WORKLOAD &&
+		 rq_data_dir(rq) == READ)) {
+		rq->cmd_flags |= REQ_URGENT;
+		cfqd->nr_urgent_pending++;
+	}
+}
+
+/**
+ * cfq_urgent_pending() - Return TRUE if there is an urgent
+ *			  request on scheduler
+ * @q:	requests queue
+ */
+static bool cfq_urgent_pending(struct request_queue *q)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+
+	if (cfqd->nr_urgent_pending && !cfqd->nr_urgent_in_flight)
+		return true;
+
+	return false;
 }
 
 /*
@@ -4006,6 +4089,12 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	const int sync = rq_is_sync(rq);
 	unsigned long now;
 
+	if (rq->cmd_flags & REQ_URGENT) {
+		if (cfqd->nr_urgent_in_flight)
+			cfqd->nr_urgent_in_flight--;
+		rq->cmd_flags &= ~REQ_URGENT;
+	}
+
 	now = jiffies;
 	cfq_log_cfqq(cfqd, cfqq, "complete rqnoidle %d",
 		     !!(rq->cmd_flags & REQ_NOIDLE));
@@ -4550,6 +4639,8 @@ static struct elevator_type iosched_cfq = {
 		.elevator_bio_merged_fn =	cfq_bio_merged,
 		.elevator_dispatch_fn =		cfq_dispatch_requests,
 		.elevator_add_req_fn =		cfq_insert_request,
+		.elevator_reinsert_req_fn	= cfq_reinsert_request,
+		.elevator_is_urgent_fn		= cfq_urgent_pending,
 		.elevator_activate_req_fn =	cfq_activate_request,
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
 		.elevator_completed_req_fn =	cfq_completed_request,
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundatio
