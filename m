Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab3CUQlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:41:00 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:58240 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934297Ab3CUQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:28 -0400
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
Subject: [PATCH 17/33] aio: change reqs_active to include unreaped completions
Date: Thu, 21 Mar 2013 09:35:38 -0700
Message-Id: <1363883754-27966-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aio code tries really hard to avoid having to deal with the completion
ringbuffer overflowing.  To do that, it has to keep track of the number of
outstanding kiocbs, and the number of completions currently in the
ringbuffer - and it's got to check that every time we allocate a kiocb.
Ouch.

But - we can improve this quite a bit if we just change reqs_active to
mean "number of outstanding requests and unreaped completions" - that
means kiocb allocation doesn't have to look at the ringbuffer, which is a
fairly significant win.

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
 fs/aio.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 16050fa..6828a31 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -71,12 +71,6 @@ struct aio_ring_info {
 	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -92,7 +86,13 @@ struct kioctx {
 	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
-	/* sys_io_setup currently limits this to an unsigned int */
+	/*
+	 * This is what userspace passed to io_setup(), it's not used for
+	 * anything but counting against the global max_reqs quota.
+	 *
+	 * The real limit is ring->nr - 1, which will be larger (see
+	 * aio_setup_ring())
+	 */
 	unsigned		max_reqs;
 
 	struct aio_ring_info	ring_info;
@@ -284,8 +284,11 @@ static void free_ioctx_rcu(struct rcu_head *head)
  */
 static void free_ioctx(struct kioctx *ctx)
 {
+	struct aio_ring_info *info = &ctx->ring_info;
+	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
+	unsigned head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -299,7 +302,21 @@ static void free_ioctx(struct kioctx *ctx)
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	wait_event(ctx->wait, !atomic_read(&ctx->reqs_active));
+	ring = kmap_atomic(info->ring_pages[0]);
+	head = ring->head;
+	kunmap_atomic(ring);
+
+	while (atomic_read(&ctx->reqs_active) > 0) {
+		wait_event(ctx->wait, head != info->tail);
+
+		avail = (head <= info->tail ? info->tail : info->nr) - head;
+
+		atomic_sub(avail, &ctx->reqs_active);
+		head += avail;
+		head %= info->nr;
+	}
+
+	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
 
 	aio_free_ring(ctx);
 
@@ -548,7 +565,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	unsigned short allocated, to_alloc;
 	long avail;
 	struct kiocb *req, *n;
-	struct aio_ring *ring;
 
 	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
 	for (allocated = 0; allocated < to_alloc; allocated++) {
@@ -563,9 +579,8 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
+	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active) - 1;
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -580,7 +595,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	batch->count -= allocated;
 	atomic_add(allocated, &ctx->reqs_active);
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -687,8 +701,11 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * when the event got cancelled.
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
-			  KIOCB_CANCELLED) == KIOCB_CANCELLED))
+			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
+		atomic_dec(&ctx->reqs_active);
+		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
+	}
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
@@ -745,7 +762,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
-	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -822,6 +838,8 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
+
+	atomic_sub(ret, &ctx->reqs_active);
 out:
 	mutex_unlock(&info->ring_lock);
 
-- 
1.8.1.3

