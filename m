Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaHTAqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:46:55 -0400
Received: from kanga.kvack.org ([205.233.56.17]:43402 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaHTAqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:53 -0400
Date: Tue, 19 Aug 2014 20:46:51 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dan Aloni <dan@kernelim.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140820004651.GJ13858@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org> <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org> <20140819171426.GA11811@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819171426.GA11811@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:14:26PM +0300, Dan Aloni wrote:
> On Tue, Aug 19, 2014 at 12:54:04PM -0400, Benjamin LaHaise wrote:
> > On Tue, Aug 19, 2014 at 07:37:33PM +0300, Dan Aloni wrote:
> > > Some testing I've done today indicates that the original commit broke
> > > AIO with regard to users that overflow the maximum number of request
> > > per IO context (where -EAGAIN is returned).
> > > 
> > > In fact, it did worse - the attached C program can easily overrun the
> > > ring buffer that is responsible for managing the completed requests,
> > > and caused notification about their completion never to be returned.
> > 
> > Argh, that would be a problem.
> > 
> > ...
> > > This reverts commit b34e0e1319b31202eb142dcd9688cf7145a30bf6.
> > 
> > Reverting isn't okay, as that reintroduces another regression.  We need 
> > to come up with a fix for this issue that doesn't reintroduce the other 
> > regression for events reaped in user space.  Let me have a look and see 
> > what I can come up with...
> 
> About the original regression you mention, is there a program you can
> indicate that reproduces it? On my setups, the regression testing in 
> libaio was not able to detect the current regression too.

You can trigger the behaviour with fio by using userspace event reaping.  
Adding a test case for that behaviour to libaio would be a good idea.

I thought about how to fix this, and it isn't actually that hard.  Move 
the put_reqs_available() call back into event consumption, and then add 
code in the submit path to call put_reqs_available() if the system runs 
out of events by noticing that there is free space in the event ring.  
Something along the lines below should do it (please note, this is 
completely untested!).  I'll test and polish this off tomorrow, as it's 
getting a bit late here.
 
		-ben
-- 
"Thought is the essence of where you are now."

diff --git a/fs/aio.c b/fs/aio.c
index ae63587..749ac22 100644
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
@@ -1005,7 +1034,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
-	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
