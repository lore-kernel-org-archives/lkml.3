Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaHXSFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:05:36 -0400
Received: from kanga.kvack.org ([205.233.56.17]:39936 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaHXSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:05:34 -0400
Date: Sun, 24 Aug 2014 14:05:31 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dan Aloni <dan@kernelim.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140824180531.GC4376@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org> <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org> <20140819171426.GA11811@gmail.com> <20140820004651.GJ13858@kvack.org> <20140822160111.GD20391@kvack.org> <20140822161502.GA30392@gmail.com> <20140822162630.GF20391@kvack.org> <20140822185110.GA2333@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822185110.GA2333@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 09:51:10PM +0300, Dan Aloni wrote:
> Ben, seems that the test program needs some twidling to make the bug
> appear still by setting MAX_IOS to 256 (and it still passes on a
> kernel with the original patch reverted). Under this condition the
> ring buffer size remains 128 (here, 32*4 CPUs), and it is overrun on
> the second attempt.

Thanks for checking that.  I've made some further changes to your test 
program to be able to support both userspace event reaping and using the 
io_getevents() syscall.  I also added a --max-ios= parameter to allow 
using different values of MAX_IOS for testing.  A copy of the modified 
source is available at http://www.kvack.org/~bcrl/20140824-aio_bug.c .  
With this version of the patch, both means of reaping events now work 
corectly.  The aio_bug.c code still needs to be added to libaio's set 
of tests, but that's a separate email.

> I think I have found two problems with your patch: first, the
> completed_events field is never decremented so it goes up until 2^32
> wraparound. So I tested with 'ctx->completed_events -= completed;'
> there (along with some prints), but testing revealed that this didn't
> solve the problem, so secondly, I also fixed the 'avail = ' line. The
> case where the 'head > tail' case didn't look correct to me.

Yeah, sorry for not checking that.  I didn't have time to sit down for a 
couple of hours to test and verify it until today.  Your changes for 
handling ring wrap around correctly look good after inspecting the code 
and how it reacts to the various conditions.

> So the good news is that it works now with fix below and MAX_IOS=256
> and even with MAX_IOS=512. You can git-amend this it to your patch I
> guess.

I ended up making a bunch of changes to the patch to ensure the user 
space tainted value of ring->head is clamped.  I also made the code use 
ctx->tail to avoid having to do a mod operation on the value of tail as 
well.  The code is rearranged to optimistically call refill_reqs_available() 
in aio_complete() to try to avoid doing this only at io_submit() time.  
This helps to avoid having to perform refill from the io_submit() path, 
as io_submit() does not otherwise have to take ctx->completion_lock 
and potentially bounce that cache line around.

If you can have a quick look and acknowledge with your Signed-off-by, I'll 
add it to the commit and send a pull request.  With these changes and the 
modified aio_bug.c, the test passes using various random values for 
max_ios, as well as both with and without --user_getevents validating that
both regressions involved have now been fixed.

...
> BTW, I am not an expert on this code so I am still not sure that
> 'ctx->completed_events' wouldn't get wrong if for instance - one SMP
> core does userspace event reaping and another calls io_submit(). Do
> you think it would work alright in that case?

This should be SMP safe: both ctx->completed_events and ctx->tail are 
protected ctx->completion_lock.  Additionally, possible races with 
grabbing the value of ring->head should also be safe, and I added a 
comment explaining why.  Does that address your concerns?  Cheers,

		-ben
-- 
"Thought is the essence of where you are now."
---- SNIP: from git://git.kvack.org/~bcrl/aio-fixes.git ----
>From 46faee0c63f6712874215b7ca878c52a0960c5da Mon Sep 17 00:00:00 2001
From: Benjamin LaHaise <bcrl@kvack.org>
Date: Sun, 24 Aug 2014 13:14:05 -0400
Subject: [PATCH] aio: fix reqs_available handling

As reported by Dan Aloni <dan@kernelim.com>, the commit "aio: fix aio request
leak when events are reaped by userspace" introduces a regression when user
code attempts to perform io_submit() with more events than are available in
the ring buffer.  Reverting that commit would reintroduce a regression when
user space event reaping is used.

Fixing this bug is a bit more involved than the previous attempts to fix
this regression.  Since we do not have a single point at which we can count
events as being reaped by user space and io_getevents(), we have to track
event completion by looking at the number of events left in the event ring.
So long as there are as many events in the ring buffer as there have been
completion events generate, we cannot call put_reqs_available().  The code
to check for this is now placed in refill_reqs_available().

A test program from Dan and modified by me for verifying this bug is available
at http://www.kvack.org/~bcrl/20140824-aio_bug.c .

Reported-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index ae63587..24c4fe4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -141,6 +141,7 @@ struct kioctx {
 
 	struct {
 		unsigned	tail;
+		unsigned	completed_events;
 		spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
@@ -857,6 +858,68 @@ out:
 	return ret;
 }
 
+/* refill_reqs_available
+ *	Updates the reqs_available reference counts used for tracking the
+ *	number of free slots in the completion ring.  This can be called
+ *	from aio_complete() (to optimistically update reqs_available) or
+ *	from aio_get_req() (the we're out of events case).  It must be
+ *	called holding ctx->completion_lock.
+ */
+static void refill_reqs_available(struct kioctx *ctx, unsigned head,
+                                  unsigned tail)
+{
+	unsigned events_in_ring, completed;
+
+	/* Clamp head since userland can write to it. */
+	head %= ctx->nr_events;
+	if (head <= tail)
+		events_in_ring = tail - head;
+	else
+		events_in_ring = ctx->nr_events - (head - tail);
+
+	completed = ctx->completed_events;
+	if (events_in_ring < completed)
+		completed -= events_in_ring;
+	else
+		completed = 0;
+
+	if (!completed)
+		return;
+
+	ctx->completed_events -= completed;
+	put_reqs_available(ctx, completed);
+}
+
+/* user_refill_reqs_available
+ *	Called to refill reqs_available when aio_get_req() encounters an
+ *	out of space in the completion ring.
+ */
+static void user_refill_reqs_available(struct kioctx *ctx)
+{
+	spin_lock_irq(&ctx->completion_lock);
+	if (ctx->completed_events) {
+		struct aio_ring *ring;
+		unsigned head;
+
+		/* Access of ring->head may race with aio_read_events_ring() 
+		 * here, but that's okay since whether we read the old version
+		 * or the new version, and either will be valid.  The important
+		 * part is that head cannot pass tail since we prevent
+		 * aio_complete() from updating tail by holding
+		 * ctx->completion_lock.  Even if head is invalid, the check
+		 * against ctx->completed_events below will make sure we do the
+		 * safe/right thing.
+		 */
+		ring = kmap_atomic(ctx->ring_pages[0]);
+		head = ring->head;
+		kunmap_atomic(ring);
+
+		refill_reqs_available(ctx, head, ctx->tail);
+	}
+
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
 /* aio_get_req
  *	Allocate a slot for an aio request.
  * Returns NULL if no requests are free.
@@ -865,8 +928,11 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (!get_reqs_available(ctx))
-		return NULL;
+	if (!get_reqs_available(ctx)) {
+		user_refill_reqs_available(ctx);
+		if (!get_reqs_available(ctx))
+			return NULL;
+	}
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
@@ -925,8 +991,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
+	unsigned tail, pos, head;
 	unsigned long	flags;
-	unsigned tail, pos;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -987,10 +1053,14 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	ctx->tail = tail;
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
+	head = ring->head;
 	ring->tail = tail;
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
+	ctx->completed_events++;
+	if (ctx->completed_events > 1)
+		refill_reqs_available(ctx, head, tail);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
@@ -1005,7 +1075,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
-	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
-- 
1.8.2.1
