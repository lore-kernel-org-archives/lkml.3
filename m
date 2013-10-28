Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3J1Uhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:37:36 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50877 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3J1Uhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:37:35 -0400
Date: Tue, 29 Oct 2013 03:47:41 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq flush fix
Message-ID: <20131028194741.GA24664@kernel.org>
References: <20131026114612.GA8576@infradead.org>
 <20131026153124.GA22227@infradead.org>
 <20131027222914.GG22549@kernel.dk>
 <20131028084821.GA31270@infradead.org>
 <526E90D7.1070604@kernel.dk>
 <CANejiEWyznEOtRAXrsgEqGoo2EWJDGBt7XH4AZFksWSmR4UY+Q@mail.gmail.com>
 <526EBD51.1010804@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526EBD51.1010804@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 01:38:57PM -0600, Jens Axboe wrote:
> On 10/28/2013 10:57 AM, Shaohua Li wrote:
> > 
> > 
> > 
> > 2013/10/28 Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>>
> > 
> >     On 10/28/2013 02:48 AM, Christoph Hellwig wrote:
> >     > On Sun, Oct 27, 2013 at 10:29:25PM +0000, Jens Axboe wrote:
> >     >> On Sat, Oct 26 2013, Christoph Hellwig wrote:
> >     >>> I think this variant of the patch from Alexander should fix the
> >     issue
> >     >>> in a minimally invasive way.  Longer term I'd prefer to use
> >     q->flush_rq
> >     >>> like in the non-mq case by copying over the context and tag
> >     information.
> >     >>
> >     >> This one is pretty simple, we could definitely use it as a band
> >     aid. I
> >     >> too would greatly prefer using the static ->flush_rq instead.
> >     Just have
> >     >> it marked to bypass most of the free logic.
> >     >
> >     > We already bypass the free logical by setting and end_io callback for
> >     > a while, similar to what the old code does.  Maybe it's not all that
> >     > hard to prealloc the request, let me give a sping.  Using the static
> >     > allocated one will be hard due to the driver-specific extra data,
> >     > though.
> > 
> >     It's not that I think the existing patch is THAT bad, it fits in alright
> >     with the reserved tagging and works regardless of whether a driver uses
> >     reserved tags or not. And it does have the upside of not requiring
> >     special checks or logic for this special non-tagged request that using
> >     the preallocated would might need.
> > 
> >     >> I'll add this one.
> >     >
> >     > Gimme another day or so to figure this out.
> > 
> >     OK, holding off.
> > 
> > 
> > Another option: we could throttle flush-request allocation in
> > blk_mq_alloc_request(), for example, flush_req_nr >= max_tags - 1, make
> > the allocation wait.
> 
> That could work too. If we back off, then we could restart it once a
> request completes. That does, however, requiring checking that and
> potentially kicking all the queues on completion when that happens.

Sounds not a big problem because the case flush_req uses all tags is very rare.
The good side is we can avoid reserving a tag, which is precious.

I cooked a patch to demonstrate the idea, only compiled yet.

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3e4cc9c..192c2aa 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -284,7 +284,6 @@ static void mq_flush_work(struct work_struct *work)
 
 	q = container_of(work, struct request_queue, mq_flush_work);
 
-	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
 	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
 		__GFP_WAIT|GFP_ATOMIC);
 	rq->cmd_type = REQ_TYPE_FS;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ac804c6..fbbe0cc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -180,8 +180,21 @@ static void blk_mq_rq_ctx_init(struct blk_mq_ctx *ctx, struct request *rq,
 }
 
 static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      gfp_t gfp, bool reserved)
+					      gfp_t gfp, bool reserved,
+					      int rw)
 {
+
+	/*
+	 * flush need allocate a request, leave at least one request for
+	 * non-flush IO to avoid deadlock
+	 */
+	if ((rw & REQ_FLUSH) && !(rw & REQ_FLUSH_SEQ)) {
+		atomic_inc(&hctx->pending_flush);
+		/* fallback to a wait allocation */
+		if (atomic_read(&hctx->pending_flush) >= hctx->queue_depth -
+		    hctx->reserved_tags - 1)
+			return NULL;
+	}
 	return blk_mq_alloc_rq(hctx, gfp, reserved);
 }
 
@@ -195,7 +208,7 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
+		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved, rw);
 		if (rq) {
 			blk_mq_rq_ctx_init(ctx, rq, rw);
 			break;
@@ -253,6 +266,10 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
+	if ((rq->cmd_flags & REQ_FLUSH) && !(rq->cmd_flags & REQ_FLUSH_SEQ)) {
+		atomic_dec(&hctx->pending_flush);
+	}
+
 	blk_mq_rq_init(hctx, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
@@ -918,7 +935,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	trace_block_getrq(q, bio, rw);
-	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
+	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false, rw);
 	if (likely(rq))
 		blk_mq_rq_ctx_init(ctx, rq, rw);
 	else {
@@ -1202,6 +1219,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		hctx->queue_num = i;
 		hctx->flags = reg->flags;
 		hctx->queue_depth = reg->queue_depth;
+		hctx->reserved_tags = reg->reserved_tags;
 		hctx->cmd_size = reg->cmd_size;
 
 		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3368b97..0f81528 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -36,12 +36,15 @@ struct blk_mq_hw_ctx {
 	struct list_head	page_list;
 	struct blk_mq_tags	*tags;
 
+	atomic_t		pending_flush;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	10
 	unsigned long		dispatched[BLK_MQ_MAX_DISPATCH_ORDER];
 
 	unsigned int		queue_depth;
+	unsigned int		reserved_tags;
 	unsigned int		numa_node;
 	unsigned int		cmd_size;	/* per-request extra data */
 
