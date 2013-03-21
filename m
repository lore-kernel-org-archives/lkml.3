Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab3CUQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:41:51 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:55011 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934291Ab3CUQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:26 -0400
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
Subject: [PATCH 16/33] aio: use cancellation list lazily
Date: Thu, 21 Mar 2013 09:35:37 -0700
Message-Id: <1363883754-27966-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cancelling kiocbs requires adding them to a per kioctx linked list, which
is one of the few things we need to take the kioctx lock for in the fast
path.  But most kiocbs can't be cancelled - so if we just do this lazily,
we can avoid quite a bit of locking overhead.

While we're at it, instead of using a flag bit switch to using ki_cancel
itself to indicate that a kiocb has been cancelled/completed.  This lets
us get rid of ki_flags entirely.

[akpm@linux-foundation.org: remove buggy BUG()]
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
 drivers/usb/gadget/inode.c |   3 +-
 fs/aio.c                   | 106 ++++++++++++++++++++++++++-------------------
 include/linux/aio.h        |  27 ++++++++----
 3 files changed, 81 insertions(+), 55 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 525cee4..5cc4e7ee 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -533,7 +533,6 @@ static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
 	local_irq_disable();
 	epdata = priv->epdata;
 	// spin_lock(&epdata->dev->lock);
-	kiocbSetCancelled(iocb);
 	if (likely(epdata && epdata->ep && priv->req))
 		value = usb_ep_dequeue (epdata->ep, priv->req);
 	else
@@ -663,7 +662,7 @@ fail:
 		goto fail;
 	}
 
-	iocb->ki_cancel = ep_aio_cancel;
+	kiocb_set_cancel_fn(iocb, ep_aio_cancel);
 	get_ep(epdata);
 	priv->epdata = epdata;
 	priv->actual = 0;
diff --git a/fs/aio.c b/fs/aio.c
index ed9d3a3..16050fa 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -97,6 +97,8 @@ struct kioctx {
 
 	struct aio_ring_info	ring_info;
 
+	spinlock_t		completion_lock;
+
 	struct rcu_head		rcu_head;
 	struct work_struct	rcu_work;
 };
@@ -220,25 +222,51 @@ static int aio_setup_ring(struct kioctx *ctx)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
+{
+	struct kioctx *ctx = req->ki_ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->ctx_lock, flags);
+
+	if (!req->ki_list.next)
+		list_add(&req->ki_list, &ctx->active_reqs);
+
+	req->ki_cancel = cancel;
+
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+}
+EXPORT_SYMBOL(kiocb_set_cancel_fn);
+
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn *old, *cancel;
 	int ret = -EINVAL;
 
-	cancel = kiocb->ki_cancel;
-	kiocbSetCancelled(kiocb);
-	if (cancel) {
-		atomic_inc(&kiocb->ki_users);
-		spin_unlock_irq(&ctx->ctx_lock);
+	/*
+	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
+	 * actually has a cancel function, hence the cmpxchg()
+	 */
+
+	cancel = ACCESS_ONCE(kiocb->ki_cancel);
+	do {
+		if (!cancel || cancel == KIOCB_CANCELLED)
+			return ret;
 
-		memset(res, 0, sizeof(*res));
-		res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
-		res->data = kiocb->ki_user_data;
-		ret = cancel(kiocb, res);
+		old = cancel;
+		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
+	} while (cancel != old);
 
-		spin_lock_irq(&ctx->ctx_lock);
-	}
+	atomic_inc(&kiocb->ki_users);
+	spin_unlock_irq(&ctx->ctx_lock);
+
+	memset(res, 0, sizeof(*res));
+	res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
+	res->data = kiocb->ki_user_data;
+	ret = cancel(kiocb, res);
+
+	spin_lock_irq(&ctx->ctx_lock);
 
 	return ret;
 }
@@ -326,6 +354,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->users, 2);
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
+	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -468,20 +497,12 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		return NULL;
 
-	req->ki_flags = 0;
 	atomic_set(&req->ki_users, 2);
-	req->ki_key = 0;
 	req->ki_ctx = ctx;
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-	req->ki_dtor = NULL;
-	req->private = NULL;
-	req->ki_iovec = NULL;
-	req->ki_eventfd = NULL;
 
 	return req;
 }
@@ -512,7 +533,6 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 	spin_lock_irq(&ctx->ctx_lock);
 	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
 		list_del(&req->ki_batch);
-		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
 		atomic_dec(&ctx->reqs_active);
 	}
@@ -558,10 +578,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	}
 
 	batch->count -= allocated;
-	list_for_each_entry(req, &batch->head, ki_batch) {
-		list_add(&req->ki_list, &ctx->active_reqs);
-		atomic_inc(&ctx->reqs_active);
-	}
+	atomic_add(allocated, &ctx->reqs_active);
 
 	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -652,25 +669,34 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	info = &ctx->ring_info;
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
-	 *
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
 	 */
 	rcu_read_lock();
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
-	list_del(&iocb->ki_list); /* remove from active_reqs */
+	if (iocb->ki_list.next) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&iocb->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
 
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (kiocbIsCancelled(iocb))
+	if (unlikely(xchg(&iocb->ki_cancel,
+			  KIOCB_CANCELLED) == KIOCB_CANCELLED))
 		goto put_rq;
 
+	/*
+	 * Add a completion event to the ring buffer. Must be done holding
+	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * pointer since we might be called from irq context.
+	 */
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+
 	tail = info->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
@@ -704,6 +730,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	kunmap_atomic(ring);
 	flush_dcache_page(info->ring_pages[0]);
 
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
@@ -730,7 +758,6 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(aio_complete);
@@ -1209,15 +1236,10 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_opcode = iocb->aio_lio_opcode;
 
 	ret = aio_setup_iocb(req, compat);
-
 	if (ret)
 		goto out_put_req;
 
-	if (unlikely(kiocbIsCancelled(req))) {
-		ret = -EINTR;
-	} else {
-		ret = req->ki_retry(req);
-	}
+	ret = req->ki_retry(req);
 	if (ret != -EIOCBQUEUED) {
 		/*
 		 * There's no easy way to restart the syscall since other AIO's
@@ -1233,10 +1255,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	spin_lock_irq(&ctx->ctx_lock);
-	list_del(&req->ki_list);
-	spin_unlock_irq(&ctx->ctx_lock);
-
 	atomic_dec(&ctx->reqs_active);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 1e728f0..d2a0003 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -10,17 +10,24 @@
 #include <linux/atomic.h>
 
 struct kioctx;
+struct kiocb;
 
 #define KIOCB_SYNC_KEY		(~0U)
 
-/* ki_flags bits */
-#define KIF_CANCELLED		2
-
-#define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
-
-#define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+/*
+ * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
+ * cancelled or completed (this makes a certain amount of sense because
+ * successful cancellation - io_cancel() - does deliver the completion to
+ * userspace).
+ *
+ * And since most things don't implement kiocb cancellation and we'd really like
+ * kiocb completion to be lockless when possible, we use ki_cancel to
+ * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
+ * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
+ */
+#define KIOCB_CANCELLED		((void *) (~0ULL))
 
-#define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 /* is there a better place to document function pointer methods? */
 /**
@@ -48,13 +55,12 @@ struct kioctx;
  * calls may result in undefined behaviour.
  */
 struct kiocb {
-	unsigned long		ki_flags;
 	atomic_t		ki_users;
 	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
-	int			(*ki_cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
 
@@ -112,6 +118,7 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_put_req(struct kiocb *iocb) { }
@@ -121,6 +128,8 @@ static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
 				struct iocb __user * __user *iocbpp,
 				bool compat) { return 0; }
+static inline void kiocb_set_cancel_fn(struct kiocb *req,
+				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
-- 
1.8.1.3

