Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3JZPbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 11:31:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JZPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 11:31:37 -0400
Date: Sat, 26 Oct 2013 08:31:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
Message-ID: <20131026153124.GA22227@infradead.org>
References: <20131026114612.GA8576@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026114612.GA8576@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this variant of the patch from Alexander should fix the issue
in a minimally invasive way.  Longer term I'd prefer to use q->flush_rq
like in the non-mq case by copying over the context and tag information.


diff --git a/block/blk-core.c b/block/blk-core.c
index 3bb9e9f..9677c65 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1102,7 +1102,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	if (q->mq_ops)
-		return blk_mq_alloc_request(q, rw, gfp_mask);
+		return blk_mq_alloc_request(q, rw, gfp_mask, false);
 	else
 		return blk_old_get_request(q, rw, gfp_mask);
 }
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3e4cc9c..331e627 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -286,7 +286,7 @@ static void mq_flush_work(struct work_struct *work)
 
 	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
 	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
-		__GFP_WAIT|GFP_ATOMIC);
+		__GFP_WAIT|GFP_ATOMIC, true);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->end_io = flush_end_io;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c88c0de..134100d1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -204,14 +204,15 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp)
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
+		gfp_t gfp, bool reserved)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, false);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
 	blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
 }
@@ -1286,6 +1287,15 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 		reg->queue_depth = BLK_MQ_MAX_DEPTH;
 	}
 
+	/*
+	 * Set aside a tag for flush requests.  It will only be used while
+	 * another flush request is in progress but outside the driver.
+	 *
+	 * TODO: only allocate if flushes are supported
+	 */
+	reg->queue_depth++;
+	reg->reserved_tags++;
+
 	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
 		return ERR_PTR(-EINVAL);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 158da52..3eb1beb 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -123,7 +123,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp, bool reserved);
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
 
