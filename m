Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab3CEDDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:03:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:7557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112Ab3CEDC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:02:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="264376254"
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>,
        Shane Huang <shane.huang@amd.com>
Subject: [PATCH v11 3/4] block: implement runtime pm strategy
Date: Tue,  5 Mar 2013 11:03:53 +0800
Message-Id: <1362452634-12524-4-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362452634-12524-1-git-send-email-aaron.lu@intel.com>
References: <1362452634-12524-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

When a request is added:
    If device is suspended or is suspending and the request is not a
    PM request, resume the device.

When the last request finishes:
    Call pm_runtime_mark_last_busy().

When pick a request:
    If device is resuming/suspending, then only PM request is allowed
    to go.

The idea and API is designed by Alan Stern and described here:
http://marc.info/?l=linux-scsi&m=133727953625963&w=2

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 block/blk-core.c | 39 +++++++++++++++++++++++++++++++++++++++
 block/elevator.c | 26 ++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 123d240..441f348 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1264,6 +1264,16 @@ void part_round_stats(int cpu, struct hd_struct *part)
 }
 EXPORT_SYMBOL_GPL(part_round_stats);
 
+#ifdef CONFIG_PM_RUNTIME
+static void blk_pm_put_request(struct request *rq)
+{
+	if (rq->q->dev && !(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending)
+		pm_runtime_mark_last_busy(rq->q->dev);
+}
+#else
+static inline void blk_pm_put_request(struct request *rq) {}
+#endif
+
 /*
  * queue lock must be held
  */
@@ -1274,6 +1284,8 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+	blk_pm_put_request(req);
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -2053,6 +2065,28 @@ static void blk_account_io_done(struct request *req)
 	}
 }
 
+#ifdef CONFIG_PM_RUNTIME
+/*
+ * Don't process normal requests when queue is suspended
+ * or in the process of suspending/resuming
+ */
+static struct request *blk_pm_peek_request(struct request_queue *q,
+					   struct request *rq)
+{
+	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
+	    (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))))
+		return NULL;
+	else
+		return rq;
+}
+#else
+static inline struct request *blk_pm_peek_request(struct request_queue *q,
+						  struct request *rq)
+{
+	return rq;
+}
+#endif
+
 /**
  * blk_peek_request - peek at the top of a request queue
  * @q: request queue to peek at
@@ -2075,6 +2109,11 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+
+		rq = blk_pm_peek_request(q, rq);
+		if (!rq)
+			break;
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index a0ffdd9..eba5b04 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -34,6 +34,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include <trace/events/block.h>
 
@@ -536,6 +537,27 @@ void elv_bio_merged(struct request_queue *q, struct request *rq,
 		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static void blk_pm_requeue_request(struct request *rq)
+{
+	if (rq->q->dev && !(rq->cmd_flags & REQ_PM))
+		rq->q->nr_pending--;
+}
+
+static void blk_pm_add_request(struct request_queue *q, struct request *rq)
+{
+	if (q->dev && !(rq->cmd_flags & REQ_PM) && q->nr_pending++ == 0 &&
+	    (q->rpm_status == RPM_SUSPENDED || q->rpm_status == RPM_SUSPENDING))
+		pm_request_resume(q->dev);
+}
+#else
+static inline void blk_pm_requeue_request(struct request *rq) {}
+static inline void blk_pm_add_request(struct request_queue *q,
+				      struct request *rq)
+{
+}
+#endif
+
 void elv_requeue_request(struct request_queue *q, struct request *rq)
 {
 	/*
@@ -550,6 +572,8 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+	blk_pm_requeue_request(rq);
+
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -572,6 +596,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	blk_pm_add_request(q, rq);
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
-- 
1.8.1.4

