Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935139AbaE2OS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:18:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59336 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933173AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roman Pen <r.peniaev@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/103] blktrace: fix accounting of partially completed requests
Date: Thu, 29 May 2014 15:48:08 +0200
Message-Id: <5104b40a981d26212ced149fbd43ad0b6b72910b.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Pen <r.peniaev@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit af5040da01ef980670b3741b3e10733ee3e33566 upstream.

trace_block_rq_complete does not take into account that request can
be partially completed, so we can get the following incorrect output
of blkparser:

  C   R 232 + 240 [0]
  C   R 240 + 232 [0]
  C   R 248 + 224 [0]
  C   R 256 + 216 [0]

but should be:

  C   R 232 + 8 [0]
  C   R 240 + 8 [0]
  C   R 248 + 8 [0]
  C   R 256 + 8 [0]

Also, the whole output summary statistics of completed requests and
final throughput will be incorrect.

This patch takes into account real completion size of the request and
fixes wrong completion accounting.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 block/blk-core.c             |  2 +-
 include/trace/events/block.h | 33 ++++++++++++++++++++++++++++++---
 kernel/trace/blktrace.c      | 20 +++++++++++---------
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fce4b9387f36..bf214ae98937 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2297,7 +2297,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	if (!req->bio)
 		return false;
 
-	trace_block_rq_complete(req->q, req);
+	trace_block_rq_complete(req->q, req, nr_bytes);
 
 	/*
 	 * For fs requests, rq is just carrier of independent bio's
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 4c2301d2ef1a..2aaf370c462b 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -132,6 +132,7 @@ DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
  * block_rq_complete - block IO operation completed by device driver
  * @q: queue containing the block operation request
  * @rq: block operations request
+ * @nr_bytes: number of completed bytes
  *
  * The block_rq_complete tracepoint event indicates that some portion
  * of operation request has been completed by the device driver.  If
@@ -139,11 +140,37 @@ DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
  * do for the request. If @rq->bio is non-NULL then there is
  * additional work required to complete the request.
  */
-DEFINE_EVENT(block_rq_with_error, block_rq_complete,
+TRACE_EVENT(block_rq_complete,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request_queue *q, struct request *rq,
+		 unsigned int nr_bytes),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(q, rq, nr_bytes),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	RWBS_LEN	)
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_rq_pos(rq);
+		__entry->nr_sector = nr_bytes >> 9;
+		__entry->errors    = rq->errors;
+
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, nr_bytes);
+		blk_dump_cmd(__get_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
 );
 
 DECLARE_EVENT_CLASS(block_rq,
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7f727b34280d..e0e5f73db5a4 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -703,6 +703,7 @@ void blk_trace_shutdown(struct request_queue *q)
  * blk_add_trace_rq - Add a trace for a request oriented action
  * @q:		queue the io is for
  * @rq:		the source request
+ * @nr_bytes:	number of completed bytes
  * @what:	the action
  *
  * Description:
@@ -710,7 +711,7 @@ void blk_trace_shutdown(struct request_queue *q)
  *
  **/
 static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
-			     u32 what)
+			     unsigned int nr_bytes, u32 what)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -719,11 +720,11 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rq->cmd_flags,
+		__blk_add_trace(bt, 0, nr_bytes, rq->cmd_flags,
 				what, rq->errors, rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
+		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes,
 				rq->cmd_flags, what, rq->errors, 0, NULL);
 	}
 }
@@ -731,33 +732,34 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 static void blk_add_trace_rq_abort(void *ignore,
 				   struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_ABORT);
+	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_ABORT);
 }
 
 static void blk_add_trace_rq_insert(void *ignore,
 				    struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
+	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_INSERT);
 }
 
 static void blk_add_trace_rq_issue(void *ignore,
 				   struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
+	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_ISSUE);
 }
 
 static void blk_add_trace_rq_requeue(void *ignore,
 				     struct request_queue *q,
 				     struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
+	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_REQUEUE);
 }
 
 static void blk_add_trace_rq_complete(void *ignore,
 				      struct request_queue *q,
-				      struct request *rq)
+				      struct request *rq,
+				      unsigned int nr_bytes)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_COMPLETE);
+	blk_add_trace_rq(q, rq, nr_bytes, BLK_TA_COMPLETE);
 }
 
 /**
-- 
1.9.3

