Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3ENBTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:43 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35765 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3ENBT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:29 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 18/21] aio: Allow cancellation without a cancel callback, new kiocb lookup
Date: Mon, 13 May 2013 18:18:55 -0700
Message-Id: <1368494338-7069-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does a couple things:

 * Allows cancellation of any kiocb, even if the driver doesn't
   implement a ki_cancel callback function. This will be used for block
   layer cancellation - there, implementing a callback is problematic,
   but we can implement useful cancellation by just checking if the
   kicob has been marked as cancelled when it goes to dequeue the
   request.

 * Implements a new lookup mechanism for cancellation.

   Previously, to cancel a kiocb we had to look it up in a linked list,
   and kiocbs were added to the linked list lazily. But if any kiocb is
   cancellable, the lazy list adding no longer works, so we need a new
   mechanism.

   This is done by allocating kiocbs out of a (lazily allocated) array
   of pages, which means we can refer to the kiocbs (and iterate over
   them) with small integers - we use the percpu tag allocation code for
   allocating individual kiocbs.

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
---
 fs/aio.c            | 207 +++++++++++++++++++++++++++++++++-------------------
 include/linux/aio.h |  92 ++++++++++++++++-------
 2 files changed, 197 insertions(+), 102 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index aa39194..f4ea8d5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -39,6 +39,7 @@
 #include <linux/compat.h>
 #include <linux/percpu-refcount.h>
 #include <linux/radix-tree.h>
+#include <linux/tags.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -74,6 +75,9 @@ struct kioctx {
 
 	struct __percpu kioctx_cpu *cpu;
 
+	struct tag_pool		kiocb_tags;
+	struct page		**kiocb_pages;
+
 	/*
 	 * For percpu reqs_available, number of slots we move to/from global
 	 * counter at a time:
@@ -113,11 +117,6 @@ struct kioctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct {
-		spinlock_t	ctx_lock;
-		struct list_head active_reqs;	/* used for cancellation */
-	} ____cacheline_aligned_in_smp;
-
-	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
 	} ____cacheline_aligned_in_smp;
@@ -136,16 +135,25 @@ unsigned long aio_nr;		/* current system wide number of aio requests */
 unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
 /*----end sysctl variables---*/
 
-static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
 
+#define KIOCBS_PER_PAGE	(PAGE_SIZE / sizeof(struct kiocb))
+
+static inline struct kiocb *kiocb_from_id(struct kioctx *ctx, unsigned id)
+{
+	struct page *p = ctx->kiocb_pages[id / KIOCBS_PER_PAGE];
+
+	return p
+		? ((struct kiocb *) page_address(p)) + (id % KIOCBS_PER_PAGE)
+		: NULL;
+}
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
  */
 static int __init aio_setup(void)
 {
-	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
@@ -245,45 +253,58 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 {
-	struct kioctx *ctx = req->ki_ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
+	kiocb_cancel_fn *p, *old = req->ki_cancel;
 
-	if (!req->ki_list.next)
-		list_add(&req->ki_list, &ctx->active_reqs);
-
-	req->ki_cancel = cancel;
+	do {
+		if (old == KIOCB_CANCELLED) {
+			cancel(req);
+			return;
+		}
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+		p = old;
+		old = cmpxchg(&req->ki_cancel, old, cancel);
+	} while (old != p);
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
+static void kiocb_cancel(struct kioctx *ctx, struct kiocb *req)
 {
-	kiocb_cancel_fn *old, *cancel;
+	kiocb_cancel_fn *old, *new, *cancel = req->ki_cancel;
 
-	/*
-	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
-	 * actually has a cancel function, hence the cmpxchg()
-	 */
+	local_irq_disable();
 
-	cancel = ACCESS_ONCE(kiocb->ki_cancel);
 	do {
-		if (!cancel || cancel == KIOCB_CANCELLED)
-			return -EINVAL;
+		if (cancel == KIOCB_CANCELLING ||
+		    cancel == KIOCB_CANCELLED)
+			goto out;
 
 		old = cancel;
-		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
-	} while (cancel != old);
+		new = cancel ? KIOCB_CANCELLING : KIOCB_CANCELLED;
+
+		cancel = cmpxchg(&req->ki_cancel, old, KIOCB_CANCELLING);
+	} while (old != cancel);
 
-	return cancel(kiocb);
+	if (cancel) {
+		cancel(req);
+		smp_wmb();
+		req->ki_cancel = KIOCB_CANCELLED;
+	}
+out:
+	local_irq_enable();
 }
 
 static void free_ioctx_rcu(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+	unsigned i;
+
+	for (i = 0; i < DIV_ROUND_UP(ctx->nr_events, KIOCBS_PER_PAGE); i++)
+		if (ctx->kiocb_pages[i])
+			__free_page(ctx->kiocb_pages[i]);
 
+	kfree(ctx->kiocb_pages);
+
+	tag_pool_free(&ctx->kiocb_tags);
 	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
@@ -296,21 +317,16 @@ static void free_ioctx_rcu(struct rcu_head *head)
 static void free_ioctx(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
-	struct kiocb *req;
-	unsigned cpu, avail;
+	unsigned i, cpu, avail;
 	DEFINE_WAIT(wait);
 
-	spin_lock_irq(&ctx->ctx_lock);
+	for (i = 0; i < ctx->nr_events; i++) {
+		struct kiocb *req = kiocb_from_id(ctx, i);
 
-	while (!list_empty(&ctx->active_reqs)) {
-		req = list_first_entry(&ctx->active_reqs,
-				       struct kiocb, ki_list);
-
-		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req);
+		if (req)
+			kiocb_cancel(ctx, req);
 	}
 
-	spin_unlock_irq(&ctx->ctx_lock);
 
 	for_each_possible_cpu(cpu) {
 		struct kioctx_cpu *kcpu = per_cpu_ptr(ctx->cpu, cpu);
@@ -409,13 +425,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	percpu_ref_get(&ctx->users);
 	rcu_read_unlock();
 
-	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
-	INIT_LIST_HEAD(&ctx->active_reqs);
-
 	ctx->cpu = alloc_percpu(struct kioctx_cpu);
 	if (!ctx->cpu)
 		goto out_freeref;
@@ -427,6 +440,15 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	ctx->req_batch = (ctx->nr_events - 1) / (num_possible_cpus() * 4);
 	BUG_ON(!ctx->req_batch);
 
+	if (tag_pool_init(&ctx->kiocb_tags, ctx->nr_events))
+		goto out_freering;
+
+	ctx->kiocb_pages =
+		kzalloc(DIV_ROUND_UP(ctx->nr_events, KIOCBS_PER_PAGE) *
+			sizeof(struct page *), GFP_KERNEL);
+	if (!ctx->kiocb_pages)
+		goto out_freetags;
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -456,6 +478,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 out_cleanup:
 	err = -EAGAIN;
+	kfree(ctx->kiocb_pages);
+out_freetags:
+	tag_pool_free(&ctx->kiocb_tags);
+out_freering:
 	aio_free_ring(ctx);
 out_freepcpu:
 	free_percpu(ctx->cpu);
@@ -619,17 +645,46 @@ out:
 static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
+	unsigned id;
 
 	if (!get_reqs_available(ctx))
 		return NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
-	if (unlikely(!req))
-		goto out_put;
+	id = tag_alloc(&ctx->kiocb_tags, false);
+	if (!id)
+		goto err;
+
+	req = kiocb_from_id(ctx, id);
+	if (!req) {
+		unsigned i, page_nr = id / KIOCBS_PER_PAGE;
+		struct page *p = alloc_page(GFP_KERNEL);
+		if (!p)
+			goto err;
 
+		req = page_address(p);
+
+		for (i = 0; i < KIOCBS_PER_PAGE; i++) {
+			req[i].ki_cancel = KIOCB_CANCELLED;
+			req[i].ki_id = page_nr * KIOCBS_PER_PAGE + i;
+		}
+
+		smp_wmb();
+
+		if (cmpxchg(&ctx->kiocb_pages[page_nr], NULL, p) != NULL)
+			__free_page(p);
+	}
+
+	req = kiocb_from_id(ctx, id);
+
+	/*
+	 * Can't set ki_cancel to NULL until we're ready for it to be
+	 * cancellable - leave it as KIOCB_CANCELLED until then
+	 */
+	memset(req, 0, offsetof(struct kiocb, ki_cancel));
 	req->ki_ctx = ctx;
+
 	return req;
-out_put:
+err:
 	put_reqs_available(ctx, 1);
 	return NULL;
 }
@@ -640,7 +695,7 @@ static void kiocb_free(struct kiocb *req)
 		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
-	kmem_cache_free(kiocb_cachep, req);
+	tag_free(&req->ki_ctx->kiocb_tags, req->ki_id);
 }
 
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
@@ -770,17 +825,21 @@ EXPORT_SYMBOL(batch_complete_aio);
 void aio_complete_batch(struct kiocb *req, long res, long res2,
 			struct batch_complete *batch)
 {
-	req->ki_res = res;
-	req->ki_res2 = res2;
+	kiocb_cancel_fn *old = NULL, *cancel = req->ki_cancel;
+
+	do {
+		if (cancel == KIOCB_CANCELLING) {
+			cpu_relax();
+			cancel = req->ki_cancel;
+			continue;
+		}
 
-	if (req->ki_list.next) {
-		struct kioctx *ctx = req->ki_ctx;
-		unsigned long flags;
+		old = cancel;
+		cancel = cmpxchg(&req->ki_cancel, old, KIOCB_CANCELLED);
+	} while (old != cancel);
 
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
-		list_del(&req->ki_list);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	}
+	req->ki_res = res;
+	req->ki_res2 = res2;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -1204,7 +1263,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		}
 	}
 
-	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
+	ret = put_user(req->ki_id, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
@@ -1215,6 +1274,13 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_pos = iocb->aio_offset;
 	req->ki_nbytes = iocb->aio_nbytes;
 
+	/*
+	 * ki_obj.user must point to the right iocb before making the kiocb
+	 * cancellable by setting ki_cancel = NULL:
+	 */
+	smp_wmb();
+	req->ki_cancel = NULL;
+
 	ret = aio_run_iocb(req, iocb->aio_lio_opcode,
 			   (char __user *)(unsigned long)iocb->aio_buf,
 			   compat);
@@ -1305,19 +1371,16 @@ SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
 static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 				  u32 key)
 {
-	struct list_head *pos;
-
-	assert_spin_locked(&ctx->ctx_lock);
+	struct kiocb *req;
 
-	if (key != KIOCB_KEY)
+	if (key > ctx->nr_events)
 		return NULL;
 
-	/* TODO: use a hash or array, this sucks. */
-	list_for_each(pos, &ctx->active_reqs) {
-		struct kiocb *kiocb = list_kiocb(pos);
-		if (kiocb->ki_obj.user == iocb)
-			return kiocb;
-	}
+	req = kiocb_from_id(ctx, key);
+
+	if (req && req->ki_obj.user == iocb)
+		return req;
+
 	return NULL;
 }
 
@@ -1347,17 +1410,9 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 	if (unlikely(!ctx))
 		return -EINVAL;
 
-	spin_lock_irq(&ctx->ctx_lock);
-
 	kiocb = lookup_kiocb(ctx, iocb, key);
-	if (kiocb)
-		ret = kiocb_cancel(ctx, kiocb);
-	else
-		ret = -EINVAL;
-
-	spin_unlock_irq(&ctx->ctx_lock);
-
-	if (!ret) {
+	if (kiocb) {
+		kiocb_cancel(ctx, kiocb);
 		/*
 		 * The result argument is no longer used - the io_event is
 		 * always delivered via the ring buffer. -EINPROGRESS indicates
diff --git a/include/linux/aio.h b/include/linux/aio.h
index a6fe048..985e664 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -13,31 +13,80 @@ struct kioctx;
 struct kiocb;
 struct batch_complete;
 
-#define KIOCB_KEY		0
-
 /*
- * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
- * cancelled or completed (this makes a certain amount of sense because
- * successful cancellation - io_cancel() - does deliver the completion to
- * userspace).
+ * CANCELLATION
+ *
+ * SEMANTICS:
+ *
+ * Userspace may indicate (via io_cancel()) that they wish an iocb to be
+ * cancelled. io_cancel() does nothing more than indicate that the iocb should
+ * be cancelled if possible; it does not indicate whether it succeeded (nor will
+ * it block).
+ *
+ * If cancellation does succeed, userspace should be informed by passing
+ * -ECANCELLED to aio_complete(); userspace retrieves the io_event in the usual
+ * manner.
+ *
+ * DRIVERS:
+ *
+ * A driver that wishes to support cancellation may (but does not have to)
+ * implement a ki_cancel callback. If it doesn't implement a callback, it can
+ * check if the kiocb has been marked as cancelled (with kiocb_cancelled()).
+ * This is what the block layer does - when dequeuing requests it checks to see
+ * if it's for a bio that's been marked as cancelled, and if so doesn't send it
+ * to the device.
+ *
+ * Some drivers are going to need to kick something to notice that kiocb has
+ * been cancelled - those will want to implement a ki_cancel function. The
+ * callback could, say, issue a wakeup so that the thread processing the kiocb
+ * can notice the cancellation - or it might do something else entirely.
+ * kiocb->private is owned by the driver, so that ki_cancel can find the
+ * driver's state.
+ *
+ * A driver must guarantee that a kiocb completes in bounded time if it's been
+ * cancelled - this means that ki_cancel may have to guarantee forward progress.
+ *
+ * ki_cancel() may not call aio_complete().
  *
- * And since most things don't implement kiocb cancellation and we'd really like
- * kiocb completion to be lockless when possible, we use ki_cancel to
- * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
- * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
+ * SYNCHRONIZATION:
+ *
+ * The aio code ensures that after aio_complete() returns, no ki_cancel function
+ * can be called or still be executing. Thus, the driver should free whatever
+ * kiocb->private points to after calling aio_complete().
+ *
+ * Drivers must not set kiocb->ki_cancel directly; they should use
+ * kiocb_set_cancel_fn(), which guards against races with kiocb_cancel(). It
+ * might be the case that userspace cancelled the iocb before the driver called
+ * kiocb_set_cancel_fn() - in that case, kiocb_set_cancel_fn() will immediately
+ * call the cancel function you passed it, and leave ki_cancel set to
+ * KIOCB_CANCELLED.
+ */
+
+/*
+ * Special values for kiocb->ki_cancel - these indicate that a kiocb has either
+ * been cancelled, or has a ki_cancel function currently running.
  */
-#define KIOCB_CANCELLED		((void *) (~0ULL))
+#define KIOCB_CANCELLED		((void *) (-1LL))
+#define KIOCB_CANCELLING	((void *) (-2LL))
 
 typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
 	struct kiocb		*ki_next;	/* batch completion */
 
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying eventfd context to deliver events to.
+	 */
+	struct eventfd_ctx	*ki_eventfd;
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
-	kiocb_cancel_fn		*ki_cancel;
 	void			*private;
 
+	/* Only zero up to here in aio_get_req() */
+	kiocb_cancel_fn		*ki_cancel;
+	unsigned		ki_id;
+
 	union {
 		void __user		*user;
 		struct task_struct	*tsk;
@@ -49,17 +98,13 @@ struct kiocb {
 
 	loff_t			ki_pos;
 	size_t			ki_nbytes;	/* copy of iocb->aio_nbytes */
-
-	struct list_head	ki_list;	/* the aio core uses this
-						 * for cancellation */
-
-	/*
-	 * If the aio_resfd field of the userspace iocb is not zero,
-	 * this is the underlying eventfd context to deliver events to.
-	 */
-	struct eventfd_ctx	*ki_eventfd;
 };
 
+static inline bool kiocb_cancelled(struct kiocb *kiocb)
+{
+	return kiocb->ki_cancel == KIOCB_CANCELLED;
+}
+
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
 	return kiocb->ki_ctx == NULL;
@@ -107,11 +152,6 @@ static inline void aio_complete(struct kiocb *iocb, long res, long res2)
 	aio_complete_batch(iocb, res, res2, NULL);
 }
 
-static inline struct kiocb *list_kiocb(struct list_head *h)
-{
-	return list_entry(h, struct kiocb, ki_list);
-}
-
 /* for sysctl: */
 extern unsigned long aio_nr;
 extern unsigned long aio_max_nr;
-- 
1.8.2.1

