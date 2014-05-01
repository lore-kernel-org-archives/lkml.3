Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaEATRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:17:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEATRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, Kamal Mostafa <kamal@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [3.13.y.z extended stable] Patch "blktrace: fix accounting of partially completed requests" has been added to staging queue
Date: Thu,  1 May 2014 12:17:09 -0700
Message-Id: <1398971829-17728-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    blktrace: fix accounting of partially completed requests

to the linux-3.13.y-queue branch of the 3.13.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.13.y-queue

This patch is scheduled to be released in version 3.13.11.1.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.13.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

------

>From e0a37bba81caddde3f9fc2c2d5d25e439ac30587 Mon Sep 17 00:00:00 2001
From: Roman Pen <r.peniaev@gmail.com>
Date: Tue, 4 Mar 2014 23:13:10 +0900
Subject: blktrace: fix accounting of partially completed requests

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-core.c             |  2 +-
 block/blk-mq.c               |  2 +-
 include/trace/events/block.h | 33 ++++++++++++++++++++++++++++++---
 kernel/trace/blktrace.c      | 20 +++++++++++---------
 4 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8bdd012..ee8f1a4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2325,7 +2325,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	if (!req->bio)
 		return false;

-	trace_block_rq_complete(req->q, req);
+	trace_block_rq_complete(req->q, req, nr_bytes);

 	/*
 	 * For fs requests, rq is just carrier of independent bio's
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c79126e..7f9b1f6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -299,7 +299,7 @@ void blk_mq_complete_request(struct request *rq, int error)
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;

-	trace_block_rq_complete(rq->q, rq);
+	trace_block_rq_complete(rq->q, rq, blk_rq_bytes(rq));

 	while (bio) {
 		struct bio *next = bio->bi_next;
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 4c2301d..2aaf370 100644
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
index f785aef..ead60f2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -702,6 +702,7 @@ void blk_trace_shutdown(struct request_queue *q)
  * blk_add_trace_rq - Add a trace for a request oriented action
  * @q:		queue the io is for
  * @rq:		the source request
+ * @nr_bytes:	number of completed bytes
  * @what:	the action
  *
  * Description:
@@ -709,7 +710,7 @@ void blk_trace_shutdown(struct request_queue *q)
  *
  **/
 static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
-			     u32 what)
+			     unsigned int nr_bytes, u32 what)
 {
 	struct blk_trace *bt = q->blk_trace;

@@ -718,11 +719,11 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,

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
@@ -730,33 +731,34 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
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
1.9.1

