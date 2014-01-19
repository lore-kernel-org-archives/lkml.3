Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaASKiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:38:18 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51129 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaASKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:35 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 4/5] blk-mq: Convert gfp_t parameters to task state bitmask
Date: Sun, 19 Jan 2014 10:16:55 +0000
Message-Id: <1390126616-29560-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch propigates the use of task state bitmask for
percpu_ida_alloc() up the blk-mq callchain, to the point in
blk_get_request() where the blk-mq vs. blk-old split occurs.

Along with the obvious parameters changes, there are two cases
in mq_flush_work() + blk_mq_make_request() where the original
code was using __GFP_WAIT|GFP_ATOMIC that always expect a tag
which have been converted to TASK_UNINTERRUPTIBLE.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 block/blk-core.c       |    4 +++-
 block/blk-flush.c      |    2 +-
 block/blk-mq-tag.c     |   16 +++++++---------
 block/blk-mq-tag.h     |    2 +-
 block/blk-mq.c         |   28 ++++++++++++++--------------
 include/linux/blk-mq.h |    4 ++--
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8bdd012..ab0dc9a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1112,7 +1112,9 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	if (q->mq_ops)
-		return blk_mq_alloc_request(q, rw, gfp_mask, false);
+		return blk_mq_alloc_request(q, rw, (gfp_mask & __GFP_WAIT) ?
+					    TASK_UNINTERRUPTIBLE : TASK_RUNNING,
+					    false);
 	else
 		return blk_old_get_request(q, rw, gfp_mask);
 }
diff --git a/block/blk-flush.c b/block/blk-flush.c
index fb6f3c0..8dd6ff8 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -286,7 +286,7 @@ static void mq_flush_work(struct work_struct *work)
 
 	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
 	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
-		__GFP_WAIT|GFP_ATOMIC, true);
+				  TASK_UNINTERRUPTIBLE, true);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->end_io = flush_end_io;
 
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5d70edc..20777bd 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -32,19 +32,18 @@ bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
 		percpu_ida_free_tags(&tags->free_tags, nr_cpu_ids) != 0;
 }
 
-static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp)
+static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, int state)
 {
 	int tag;
 
-	tag = percpu_ida_alloc(&tags->free_tags, (gfp & __GFP_WAIT) ?
-			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
+	tag = percpu_ida_alloc(&tags->free_tags, state);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag + tags->nr_reserved_tags;
 }
 
 static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
-					      gfp_t gfp)
+					      int state)
 {
 	int tag;
 
@@ -53,19 +52,18 @@ static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
 		return BLK_MQ_TAG_FAIL;
 	}
 
-	tag = percpu_ida_alloc(&tags->reserved_tags, (gfp & __GFP_WAIT) ?
-			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
+	tag = percpu_ida_alloc(&tags->reserved_tags, state);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag;
 }
 
-unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp, bool reserved)
+unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, int state, bool reserved)
 {
 	if (!reserved)
-		return __blk_mq_get_tag(tags, gfp);
+		return __blk_mq_get_tag(tags, state);
 
-	return __blk_mq_get_reserved_tag(tags, gfp);
+	return __blk_mq_get_reserved_tag(tags, state);
 }
 
 static void __blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag)
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 947ba2c..b3c1487 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -6,7 +6,7 @@ struct blk_mq_tags;
 extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
-extern unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp, bool reserved);
+extern unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, int state, bool reserved);
 extern void blk_mq_wait_for_tags(struct blk_mq_tags *tags);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag);
 extern void blk_mq_tag_busy_iter(struct blk_mq_tags *tags, void (*fn)(void *data, unsigned long *), void *data);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c79126e..80bbfbd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -75,13 +75,13 @@ static void blk_mq_hctx_mark_pending(struct blk_mq_hw_ctx *hctx,
 		set_bit(ctx->index_hw, hctx->ctx_map);
 }
 
-static struct request *blk_mq_alloc_rq(struct blk_mq_hw_ctx *hctx, gfp_t gfp,
+static struct request *blk_mq_alloc_rq(struct blk_mq_hw_ctx *hctx, int state,
 				       bool reserved)
 {
 	struct request *rq;
 	unsigned int tag;
 
-	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
+	tag = blk_mq_get_tag(hctx->tags, state, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->rqs[tag];
 		rq->tag = tag;
@@ -183,13 +183,13 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 }
 
 static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      gfp_t gfp, bool reserved)
+					      int state, bool reserved)
 {
-	return blk_mq_alloc_rq(hctx, gfp, reserved);
+	return blk_mq_alloc_rq(hctx, state, reserved);
 }
 
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
-						   int rw, gfp_t gfp,
+						   int rw, int state,
 						   bool reserved)
 {
 	struct request *rq;
@@ -198,14 +198,14 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
+		rq = __blk_mq_alloc_request(hctx, state, reserved);
 		if (rq) {
 			blk_mq_rq_ctx_init(q, ctx, rq, rw);
 			break;
 		}
 
 		blk_mq_put_ctx(ctx);
-		if (!(gfp & __GFP_WAIT))
+		if (state == TASK_RUNNING)
 			break;
 
 		__blk_mq_run_hw_queue(hctx);
@@ -216,28 +216,28 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 }
 
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
-		gfp_t gfp, bool reserved)
+		int state, bool reserved)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
+	rq = blk_mq_alloc_request_pinned(q, rw, state, reserved);
 	if (rq)
 		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
 }
 
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
-					      gfp_t gfp)
+					      int state)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
+	rq = blk_mq_alloc_request_pinned(q, rw, state, true);
 	if (rq)
 		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
@@ -928,14 +928,14 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	trace_block_getrq(q, bio, rw);
-	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
+	rq = __blk_mq_alloc_request(hctx, TASK_RUNNING, false);
 	if (likely(rq))
 		blk_mq_rq_ctx_init(q, ctx, rq, rw);
 	else {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
-		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
-							false);
+		rq = blk_mq_alloc_request_pinned(q, rw, TASK_UNINTERRUPTIBLE,
+						 false);
 		ctx = rq->mq_ctx;
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab0e9b2..91ee75a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -124,8 +124,8 @@ void blk_mq_insert_request(struct request_queue *, struct request *, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp, bool reserved);
-struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, int state, bool reserved);
+struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, int state);
 struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
-- 
1.7.10.4

