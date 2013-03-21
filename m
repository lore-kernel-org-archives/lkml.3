Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425Ab3CUQjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:39:41 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:64944 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934346Ab3CUQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:35 -0400
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
Subject: [PATCH 22/33] aio: percpu reqs_available
Date: Thu, 21 Mar 2013 09:35:43 -0700
Message-Id: <1363883754-27966-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See the previous patch ("aio: reqs_active -> reqs_available") for why we
want to do this - this basically implements a per cpu allocator for
reqs_available that doesn't actually allocate anything.

Note that we need to increase the size of the ringbuffer we allocate,
since a single thread won't necessarily be able to use all the
reqs_available slots - some (up to about half) might be on other per cpu
lists, unavailable for the current thread.

We size the ringbuffer based on the nr_events userspace passed to
io_setup(), so this is a slight behaviour change - but nr_events wasn't
being used as a hard limit before, it was being rounded up to the next
page before so this doesn't change the actual semantics.

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
 fs/aio.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 99 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index bc00304..603511d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/mmu_context.h>
+#include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/aio.h>
@@ -59,6 +60,10 @@ struct aio_ring {
 
 #define AIO_RING_PAGES	8
 
+struct kioctx_cpu {
+	unsigned		reqs_available;
+};
+
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -67,6 +72,13 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
+	struct __percpu kioctx_cpu *cpu;
+
+	/*
+	 * For percpu reqs_available, number of slots we move to/from global
+	 * counter at a time:
+	 */
+	unsigned		req_batch;
 	/*
 	 * This is what userspace passed to io_setup(), it's not used for
 	 * anything but counting against the global max_reqs quota.
@@ -94,6 +106,8 @@ struct kioctx {
 		 * so we avoid overflowing it: it's decremented (if positive)
 		 * when allocating a kiocb and incremented when the resulting
 		 * io_event is pulled off the ringbuffer.
+		 *
+		 * We batch accesses to it with a percpu version.
 		 */
 		atomic_t	reqs_available;
 	} ____cacheline_aligned_in_smp;
@@ -281,6 +295,8 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 static void free_ioctx_rcu(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+
+	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
 
@@ -294,7 +310,7 @@ static void free_ioctx(struct kioctx *ctx)
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
-	unsigned head, avail;
+	unsigned cpu, head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -308,6 +324,13 @@ static void free_ioctx(struct kioctx *ctx)
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	for_each_possible_cpu(cpu) {
+		struct kioctx_cpu *kcpu = per_cpu_ptr(ctx->cpu, cpu);
+
+		atomic_add(kcpu->reqs_available, &ctx->reqs_available);
+		kcpu->reqs_available = 0;
+	}
+
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
@@ -358,6 +381,18 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	struct kioctx *ctx;
 	int err = -ENOMEM;
 
+	/*
+	 * We keep track of the number of available ringbuffer slots, to prevent
+	 * overflow (reqs_available), and we also use percpu counters for this.
+	 *
+	 * So since up to half the slots might be on other cpu's percpu counters
+	 * and unavailable, double nr_events so userspace sees what they
+	 * expected: additionally, we move req_batch slots to/from percpu
+	 * counters at a time, so make sure that isn't 0:
+	 */
+	nr_events = max(nr_events, num_possible_cpus() * 4);
+	nr_events *= 2;
+
 	/* Prevent overflows */
 	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
 	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
@@ -383,10 +418,16 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 
-	if (aio_setup_ring(ctx) < 0)
+	ctx->cpu = alloc_percpu(struct kioctx_cpu);
+	if (!ctx->cpu)
 		goto out_freectx;
 
+	if (aio_setup_ring(ctx) < 0)
+		goto out_freepcpu;
+
 	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
+	ctx->req_batch = (ctx->nr_events - 1) / (num_possible_cpus() * 4);
+	BUG_ON(!ctx->req_batch);
 
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
@@ -410,6 +451,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 out_cleanup:
 	err = -EAGAIN;
 	aio_free_ring(ctx);
+out_freepcpu:
+	free_percpu(ctx->cpu);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
@@ -508,6 +551,52 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
+static void put_reqs_available(struct kioctx *ctx, unsigned nr)
+{
+	struct kioctx_cpu *kcpu;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	kcpu->reqs_available += nr;
+	while (kcpu->reqs_available >= ctx->req_batch * 2) {
+		kcpu->reqs_available -= ctx->req_batch;
+		atomic_add(ctx->req_batch, &ctx->reqs_available);
+	}
+
+	preempt_enable();
+}
+
+static bool get_reqs_available(struct kioctx *ctx)
+{
+	struct kioctx_cpu *kcpu;
+	bool ret = false;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	if (!kcpu->reqs_available) {
+		int old, avail = atomic_read(&ctx->reqs_available);
+
+		do {
+			if (avail < ctx->req_batch)
+				goto out;
+
+			old = avail;
+			avail = atomic_cmpxchg(&ctx->reqs_available,
+					       avail, avail - ctx->req_batch);
+		} while (avail != old);
+
+		kcpu->reqs_available += ctx->req_batch;
+	}
+
+	ret = true;
+	kcpu->reqs_available--;
+out:
+	preempt_enable();
+	return ret;
+}
+
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the ki_users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -522,7 +611,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
+	if (!get_reqs_available(ctx))
 		return NULL;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -531,10 +620,9 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
-
 	return req;
 out_put:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	return NULL;
 }
 
@@ -623,6 +711,10 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
 			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
+		/*
+		 * Can't use the percpu reqs_available here - could race with
+		 * free_ioctx()
+		 */
 		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
@@ -760,7 +852,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
 
-	atomic_add(ret, &ctx->reqs_available);
+	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
@@ -1193,7 +1285,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
-- 
1.8.1.3

