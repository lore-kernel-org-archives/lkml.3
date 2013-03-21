Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385Ab3CUQgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:44 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61959 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934366Ab3CUQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:38 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 25/33] aio: use xchg() instead of completion_lock
Date: Thu, 21 Mar 2013 09:35:46 -0700
Message-Id: <1363883754-27966-26-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, for sticking kiocb completions on the kioctx ringbuffer, we need a
lock - it unfortunately can't be lockless.

When the kioctx is shared between threads on different cpus and the rate
of completions is high, this lock sees quite a bit of contention - in
terms of cacheline contention it's the hottest thing in the aio subsystem.

That means, with a regular spinlock, we're going to take a cache miss to
grab the lock, then another cache miss when we touch the data the lock
protects - if it's on the same cacheline as the lock, other cpus spinning
on the lock are going to be pulling it out from under us as we're using
it.

So, we use an old trick to get rid of this second forced cache miss - make
the data the lock protects be the lock itself, so we grab them both at
once.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/aio.c | 59 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3db2dab..e4b1cc1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -120,11 +120,23 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+
+		/*
+		 * Copy of the real tail - to reduce cacheline bouncing. Updated
+		 * by aio_complete() whenever it updates the real tail.
+		 */
+		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
+		/*
+		 * This is the canonical copy of the tail pointer, updated by
+		 * aio_complete(). But aio_complete() also uses it as a lock, so
+		 * other code can't use it; aio_complete() keeps shadow_tail in
+		 * sync with the real value of the tail pointer for other code
+		 * to use.
+		 */
 		unsigned	tail;
-		spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
@@ -336,9 +348,10 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
+		avail = (head <= ctx->shadow_tail
+			 ? ctx->shadow_tail : ctx->nr_events) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -415,7 +428,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	rcu_read_unlock();
 
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -713,18 +725,19 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		 * free_ioctx()
 		 */
 		atomic_inc(&ctx->reqs_available);
+		smp_mb__after_atomic_inc();
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
+	 * Add a completion event to the ring buffer; ctx->tail is both our lock
+	 * and the canonical version of the tail pointer.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	local_irq_save(flags);
+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
+		cpu_relax();
 
-	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr_events)
@@ -750,14 +763,18 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	ctx->tail = tail;
+	ctx->shadow_tail = tail;
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	/* unlock, make new tail visible before checking waitlist */
+	smp_mb();
+
+	ctx->tail = tail;
+	local_irq_restore(flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -773,14 +790,6 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
 
-	/*
-	 * We have to order our ring_info tail store above and test
-	 * of the wait list below outside the wait lock.  This is
-	 * like in wake_up_bit() where clearing a bit has to be
-	 * ordered with the unlocked test.
-	 */
-	smp_mb();
-
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
@@ -806,18 +815,18 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr_events);
+	pr_debug("h%u t%u m%u\n", head, ctx->shadow_tail, ctx->nr_events);
 
-	if (head == ctx->tail)
+	if (head == ctx->shadow_tail)
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head <= ctx->tail
-			      ? ctx->tail : ctx->nr_events) - head;
+		long avail = (head <= ctx->shadow_tail
+			      ? ctx->shadow_tail : ctx->nr_events) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == ctx->tail)
+		if (head == ctx->shadow_tail)
 			break;
 
 		avail = min(avail, nr - ret);
@@ -847,7 +856,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
+	pr_debug("%li  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
-- 
1.8.1.3

