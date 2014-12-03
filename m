Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaLCSB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:01:58 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47355 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLCSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:01:56 -0500
Date: Wed, 3 Dec 2014 10:01:52 -0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: don't use rw_is_sync() to determine sync request
Message-ID: <20141203180152.GA62282@kernel.org>
References: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org>
 <547BC5CF.7080904@fb.com>
 <20141201035712.GA8443@kernel.org>
 <20141201185934.GA52328@kernel.org>
 <547D2759.8030200@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D2759.8030200@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 07:43:37PM -0700, Jens Axboe wrote:
> On 12/01/2014 11:59 AM, Shaohua Li wrote:
> >On Sun, Nov 30, 2014 at 07:57:12PM -0800, Shaohua Li wrote:
> >>On Sun, Nov 30, 2014 at 06:35:11PM -0700, Jens Axboe wrote:
> >>>On 11/30/2014 05:01 PM, Shaohua Li wrote:
> >>>>Buffer read is counted as sync in rw_is_sync(). If we use it,
> >>>>blk_sq_make_request() will not do per-process plug any more.
> >>>>
> >>>>I haven't changed blk_mq_make_request() yet. It makes sense to dispatch
> >>>>REQ_SYNC request immediately. But for buffer read, it's weird not to do
> >>>>per-process plug, as buffer read doesn't need low latency.
> >>>>blk_mq_merge_queue_io() isn't very helpful, as we don't have delay mechanism
> >>>>there, the queue is immediately flushed, which makes the merge very
> >>>>superficial.
> >>>
> >>>A read is sync, buffered or not. A buffered read is every bit as
> >>>latency sensitive as an O_DIRECT read. I think it'd be fine to
> >>>modify rw_is_sync() to disregard REQ_AHEAD as sync (and ensure it's
> >>>carried forward in the request flags, too). At least to the extent
> >>>that we process plug and get the merging, since for streamed reads
> >>>we'd soon be waiting on them anyway.
> >>
> >>A quick search shows nobody uses REQ_AHEAD. For stream reads, only first several
> >>reads are waited I suppose, later reads are read ahead. Maybe only counts
> >>REQ_META read as sync?
> >
> >Changing rw_is_sync() sounds risky, as it will change behavior of other parts,
> >like CFQ. REQ_META/REQ_PRIO isn't an option, metadata does readahead too.
> >And nobody uses REQ_AHEAD. explictly checking REQ_SYNC in blk_sq_make_request()
> >sounds better, which is just for pluging and we use it for ages in
> >blk_queue_bio().
> 
> I'm not really disagreeing with you. The per-task plugging isn't a
> true delay mechanism like the old plugging was, and there's no
> question it makes sense to do on the single queue. For the multi
> queue, it's a bit more tricky. If it's truly a 1:1 cpu:queue
> mapping, then we can safely assume that we might as well execute it.
> Unless we can do batched submission, which would (somewhat) rely on
> having chains of requests to submit, which we'd only really get if
> we plug.
> 
> The fact that RAHEAD isn't currently really wired up is a shame, and
> it really should be. It might be problematic due to how we mix it up
> with failfast.
> 
> For blk_sq_make_request(), we should just make the change.

How about the new patch?


>From 5a749efba52ff271642e6190d0f719c223e8bdd2 Mon Sep 17 00:00:00 2001
Message-Id: <5a749efba52ff271642e6190d0f719c223e8bdd2.1417629506.git.shli@kernel.org>
From: Shaohua Li <shli@kernel.org>
Date: Sun, 30 Nov 2014 15:17:25 -0800
Subject: [PATCH] blk-mq: rationalize plug

plug is still helpful for workload with IO merge, but it can be harmful
otherwise especially with multiple hardware queues, as there is (supposed) no
lock contention in this case and plug can introduce latency.

For single queue, we always do plug. Reducing lock contention is still a win.
For multiple queues, we do a limited plug, eg plug only if there is merge. If a
request doesn't have merge with following request, the requet will be
dispatched immediately.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 block/blk-mq.c | 82 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d5b4643..6c90354 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1133,6 +1133,33 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	return rq;
 }
 
+static int blk_mq_direct_issue_request(struct request *rq)
+{
+	int ret;
+	struct request_queue *q = rq->q;
+	struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q,
+			rq->mq_ctx->cpu);
+
+	/*
+	 * For OK queue, we are done. For error, kill it. Any other
+	 * error (busy), just add it to our list as we previously
+	 * would have done
+	 */
+	ret = q->mq_ops->queue_rq(hctx, rq, true);
+	if (ret == BLK_MQ_RQ_QUEUE_OK)
+		return 0;
+	else {
+		__blk_mq_requeue_request(rq);
+
+		if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
+			rq->errors = -EIO;
+			blk_mq_end_request(rq, rq->errors);
+			return 0;
+		}
+		return -1;
+	}
+}
+
 /*
  * Multiple hardware queue variant. This will not use per-process plugs,
  * but will attempt to bypass the hctx queueing if we can go straight to
@@ -1142,8 +1169,12 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = rw_is_sync(bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	unsigned int use_plug, request_count = 0;
 	struct blk_map_ctx data;
 	struct request *rq;
+	struct blk_plug *plug;
+
+	use_plug = !is_flush_fua;
 
 	blk_queue_bounce(q, &bio);
 
@@ -1152,6 +1183,10 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
+	if (use_plug && !blk_queue_nomerges(q) &&
+	    blk_attempt_plug_merge(q, bio, &request_count))
+		return;
+
 	rq = blk_mq_map_request(q, bio, &data);
 	if (unlikely(!rq))
 		return;
@@ -1162,28 +1197,37 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		goto run_queue;
 	}
 
-	if (is_sync) {
-		int ret;
+	/*
+	 * we do limited pluging. If bio can be merged, do merge. Otherwise the
+	 * existing request in the plug list will be issued. So the plug list
+	 * will have one request at most
+	 */
+	plug = current->plug;
+	if (use_plug && plug) {
+		struct request *old_rq = NULL;
 
 		blk_mq_bio_to_request(rq, bio);
+		if (!list_empty(&plug->mq_list)) {
+			old_rq = list_first_entry(&plug->mq_list,
+				struct request, queuelist);
+			list_del_init(&old_rq->queuelist);
+		}
+		list_add_tail(&rq->queuelist, &plug->mq_list);
+		blk_mq_put_ctx(data.ctx);
 
-		/*
-		 * For OK queue, we are done. For error, kill it. Any other
-		 * error (busy), just add it to our list as we previously
-		 * would have done
-		 */
-		ret = q->mq_ops->queue_rq(data.hctx, rq, true);
-		if (ret == BLK_MQ_RQ_QUEUE_OK)
-			goto done;
-		else {
-			__blk_mq_requeue_request(rq);
+		if (!old_rq)
+			return;
 
-			if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
-				rq->errors = -EIO;
-				blk_mq_end_request(rq, rq->errors);
-				goto done;
-			}
-		}
+		if (!blk_mq_direct_issue_request(old_rq))
+			return;
+		blk_mq_insert_request(old_rq, false, true, true);
+		return;
+	}
+
+	if (is_sync) {
+		blk_mq_bio_to_request(rq, bio);
+		if (!blk_mq_direct_issue_request(rq))
+			goto done;
 	}
 
 	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
@@ -1216,7 +1260,7 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	 * If we have multiple hardware queues, just go directly to
 	 * one of those for sync IO.
 	 */
-	use_plug = !is_flush_fua && !is_sync;
+	use_plug = !is_flush_fua;
 
 	blk_queue_bounce(q, &bio);
 
-- 
1.8.3.2

