Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab3CUQj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:39:56 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:43523 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342Ab3CUQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:33 -0400
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
Subject: [PATCH 21/33] aio: reqs_active -> reqs_available
Date: Thu, 21 Mar 2013 09:35:42 -0700
Message-Id: <1363883754-27966-22-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of outstanding kiocbs is one of the few shared things left that
has to be touched for every kiocb - it'd be nice to make it percpu.

We can make it per cpu by treating it like an allocation problem: we have
a maximum number of kiocbs that can be outstanding (i.e.  slots) - then we
just allocate and free slots, and we know how to write per cpu allocators.

So as prep work for that, we convert reqs_active to reqs_available.

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
 fs/aio.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b71691d..bc00304 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -89,7 +89,13 @@ struct kioctx {
 	struct work_struct	rcu_work;
 
 	struct {
-		atomic_t	reqs_active;
+		/*
+		 * This counts the number of available slots in the ringbuffer,
+		 * so we avoid overflowing it: it's decremented (if positive)
+		 * when allocating a kiocb and incremented when the resulting
+		 * io_event is pulled off the ringbuffer.
+		 */
+		atomic_t	reqs_available;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -306,17 +312,17 @@ static void free_ioctx(struct kioctx *ctx)
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_active) > 0) {
+	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
 		wait_event(ctx->wait, head != ctx->tail);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
+		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
 		head %= ctx->nr_events;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);
 
 	aio_free_ring(ctx);
 
@@ -380,6 +386,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freectx;
 
+	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -482,7 +490,7 @@ void exit_aio(struct mm_struct *mm)
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users),
 				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_active));
+				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -514,12 +522,9 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->nr_events)
+	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr_events - 1)
-		goto out_put;
-
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		goto out_put;
@@ -529,7 +534,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 
 	return req;
 out_put:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	return NULL;
 }
 
@@ -600,7 +605,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after decrementing reqs_active.
+	 * need to issue a wakeup after incrementing reqs_available.
 	 */
 	rcu_read_lock();
 
@@ -618,7 +623,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
 			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-		atomic_dec(&ctx->reqs_active);
+		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
@@ -755,7 +760,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
 
-	atomic_sub(ret, &ctx->reqs_active);
+	atomic_add(ret, &ctx->reqs_available);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
@@ -1188,7 +1193,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
-- 
1.8.1.3

