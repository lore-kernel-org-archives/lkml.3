Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaHVQ0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:26:34 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35398 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaHVQ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:26:32 -0400
Date: Fri, 22 Aug 2014 12:26:30 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dan Aloni <dan@kernelim.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140822162630.GF20391@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org> <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org> <20140819171426.GA11811@gmail.com> <20140820004651.GJ13858@kvack.org> <20140822160111.GD20391@kvack.org> <20140822161502.GA30392@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822161502.GA30392@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 07:15:02PM +0300, Dan Aloni wrote:
> Sorry, I was waiting for a new patch from your direction, I should
> have replied earlier. What bothered me about the patch you sent is that
> completed_events is added as a new field but nothing assigns to it, so I 
> wonder how it can be effective.

Ah, that was missing a hunk then.  Try this version instead.

		-ben
-- 
"Thought is the essence of where you are now."


diff --git a/fs/aio.c b/fs/aio.c
index ae63587..fbdcc47 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -142,6 +142,7 @@ struct kioctx {
 	struct {
 		unsigned	tail;
 		spinlock_t	completion_lock;
+		unsigned	completed_events;
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
@@ -857,6 +858,31 @@ out:
 	return ret;
 }
 
+static void refill_reqs_available(struct kioctx *ctx)
+{
+	spin_lock_irq(&ctx->completion_lock);
+	if (ctx->completed_events) {
+		unsigned head, tail, avail, completed;
+		struct aio_ring *ring;
+
+		ring = kmap_atomic(ctx->ring_pages[0]);
+		head = ACCESS_ONCE(ring->head);
+		tail = ACCESS_ONCE(ring->tail);
+		kunmap_atomic(ring);
+
+		avail = (head <= tail ?  tail : ctx->nr_events) - head;
+		completed = ctx->completed_events;
+		if (avail < completed)
+			completed -= avail;
+		else
+			completed = 0;
+		put_reqs_available(ctx, completed);
+	}
+
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
+
 /* aio_get_req
  *	Allocate a slot for an aio request.
  * Returns NULL if no requests are free.
@@ -865,8 +891,11 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (!get_reqs_available(ctx))
-		return NULL;
+	if (!get_reqs_available(ctx)) {
+		refill_reqs_available(ctx);
+		if (!get_reqs_available(ctx))
+			return NULL;
+	}
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
@@ -958,6 +987,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
+	ctx->completed_events++;
 	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
@@ -1005,7 +1035,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
-	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
