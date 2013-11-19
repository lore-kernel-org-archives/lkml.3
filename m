Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3KSQF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:05:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3KSQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:05:12 -0500
Date: Tue, 19 Nov 2013 09:05:09 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119160509.GB21343@kernel.dk>
References: <20131119080218.GJ11434@dastard>
 <20131119103635.GA9223@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119103635.GA9223@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19 2013, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 07:02:18PM +1100, Dave Chinner wrote:
> > I have no idea if it's related to the above hang, but either way
> > breaking iostat is a major regression....
> 
> Both of them are most likely due to the conversion of virtio_blk
> to the blk-mq code.
> 
> I've not seen the hang in my heavy xfstests testing, but that was a
> slightly different codebase than what finally got in, so I'll try
> to reproduce it once I get some spare QA cycles.

Thanks! Dave, if you still have it in that state, can you dump the
contents of /sys/block/<devs>/mq/ for the device/devices that are hung?

> The missing stats should be solved by something like the patch below
> (untested so far):
> 
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 862f458..41e3b85 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -175,7 +175,7 @@ static void blk_mq_rq_ctx_init(struct blk_mq_ctx *ctx, struct request *rq,
>  			       unsigned int rw_flags)
>  {
>  	rq->mq_ctx = ctx;
> -	rq->cmd_flags = rw_flags;
> +	rq->cmd_flags = rw_flags | REQ_IO_STAT;
>  	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
>  }

I have queued up the below.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 862f458..ef90f18 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -171,9 +171,12 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_can_queue);
 
-static void blk_mq_rq_ctx_init(struct blk_mq_ctx *ctx, struct request *rq,
-			       unsigned int rw_flags)
+static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
+			       struct request *rq, unsigned int rw_flags)
 {
+	if (blk_queue_io_stat(q))
+		rw_flags |= REQ_IO_STAT;
+
 	rq->mq_ctx = ctx;
 	rq->cmd_flags = rw_flags;
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
@@ -197,7 +200,7 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 
 		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
 		if (rq) {
-			blk_mq_rq_ctx_init(ctx, rq, rw);
+			blk_mq_rq_ctx_init(q, ctx, rq, rw);
 			break;
 		} else if (!(gfp & __GFP_WAIT))
 			break;
@@ -921,7 +924,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	trace_block_getrq(q, bio, rw);
 	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
 	if (likely(rq))
-		blk_mq_rq_ctx_init(ctx, rq, rw);
+		blk_mq_rq_ctx_init(q, ctx, rq, rw);
 	else {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);

-- 
Jens Axboe

