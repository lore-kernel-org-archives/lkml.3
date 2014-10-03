Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaJDAHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:07:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbaJCVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Aloni <dan@kernelim.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <kmo@daterainc.com>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 029/238] aio: fix reqs_available handling
Date: Fri,  3 Oct 2014 14:29:04 -0700
Message-Id: <20141003212914.599217600@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit d856f32a86b2b015ab180ab7a55e455ed8d3ccc5 upstream.

As reported by Dan Aloni, commit f8567a3845ac ("aio: fix aio request
leak when events are reaped by userspace") introduces a regression when
user code attempts to perform io_submit() with more events than are
available in the ring buffer.  Reverting that commit would reintroduce a
regression when user space event reaping is used.

Fixing this bug is a bit more involved than the previous attempts to fix
this regression.  Since we do not have a single point at which we can
count events as being reaped by user space and io_getevents(), we have
to track event completion by looking at the number of events left in the
event ring.  So long as there are as many events in the ring buffer as
there have been completion events generate, we cannot call
put_reqs_available().  The code to check for this is now placed in
refill_reqs_available().

A test program from Dan and modified by me for verifying this bug is available
at http://www.kvack.org/~bcrl/20140824-aio_bug.c .

Reported-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Dan Aloni <dan@kernelim.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 4 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -141,6 +141,7 @@ struct kioctx {
 
 	struct {
 		unsigned	tail;
+		unsigned	completed_events;
 		spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
@@ -880,6 +881,68 @@ out:
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
@@ -888,8 +951,11 @@ static inline struct kiocb *aio_get_req(
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
@@ -948,8 +1014,8 @@ void aio_complete(struct kiocb *iocb, lo
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
+	unsigned tail, pos, head;
 	unsigned long	flags;
-	unsigned tail, pos;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -1010,10 +1076,14 @@ void aio_complete(struct kiocb *iocb, lo
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
@@ -1028,7 +1098,6 @@ void aio_complete(struct kiocb *iocb, lo
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
-	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test


