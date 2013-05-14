Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3ENBXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:23:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57562 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3ENBTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:18 -0400
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
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 10/21] aio: Kill ki_users
Date: Mon, 13 May 2013 18:18:47 -0700
Message-Id: <1368494338-7069-11-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kiocb refcount is only needed for cancellation - to ensure a kiocb
isn't freed while a ki_cancel callback is running. But if we restrict
ki_cancel callbacks to not block (which they currently don't), we can
simply drop the refcount.

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
---
 fs/aio.c            | 47 ++++++++++++-----------------------------------
 include/linux/aio.h |  5 -----
 2 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 280b014..40781ff 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -262,7 +262,6 @@ EXPORT_SYMBOL(kiocb_set_cancel_fn);
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
-	int ret = -EINVAL;
 
 	/*
 	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
@@ -272,21 +271,13 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 	cancel = ACCESS_ONCE(kiocb->ki_cancel);
 	do {
 		if (!cancel || cancel == KIOCB_CANCELLED)
-			return ret;
+			return -EINVAL;
 
 		old = cancel;
 		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
 	} while (cancel != old);
 
-	atomic_inc(&kiocb->ki_users);
-	spin_unlock_irq(&ctx->ctx_lock);
-
-	ret = cancel(kiocb);
-
-	spin_lock_irq(&ctx->ctx_lock);
-	aio_put_req(kiocb);
-
-	return ret;
+	return cancel(kiocb);
 }
 
 static void free_ioctx_rcu(struct rcu_head *head)
@@ -510,16 +501,16 @@ static void kill_ioctx(struct kioctx *ctx)
 /* wait_on_sync_kiocb:
  *	Waits on the given sync kiocb to complete.
  */
-ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
+ssize_t wait_on_sync_kiocb(struct kiocb *req)
 {
-	while (atomic_read(&iocb->ki_users)) {
+	while (!req->ki_ctx) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!atomic_read(&iocb->ki_users))
+		if (req->ki_ctx)
 			break;
 		io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
-	return iocb->ki_user_data;
+	return req->ki_user_data;
 }
 EXPORT_SYMBOL(wait_on_sync_kiocb);
 
@@ -601,14 +592,8 @@ out:
 }
 
 /* aio_get_req
- *	Allocate a slot for an aio request.  Increments the ki_users count
- * of the kioctx so that the kioctx stays around until all requests are
- * complete.  Returns NULL if no requests are free.
- *
- * Returns with kiocb->ki_users set to 2.  The io submit code path holds
- * an extra reference while submitting the i/o.
- * This prevents races between the aio code path referencing the
- * req (after submitting it) and aio_complete() freeing the req.
+ *	Allocate a slot for an aio request.
+ * Returns NULL if no requests are free.
  */
 static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
@@ -621,7 +606,6 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 1);
 	req->ki_ctx = ctx;
 	return req;
 out_put:
@@ -640,13 +624,6 @@ static void kiocb_free(struct kiocb *req)
 	kmem_cache_free(kiocb_cachep, req);
 }
 
-void aio_put_req(struct kiocb *req)
-{
-	if (atomic_dec_and_test(&req->ki_users))
-		kiocb_free(req);
-}
-EXPORT_SYMBOL(aio_put_req);
-
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct mm_struct *mm = current->mm;
@@ -685,9 +662,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 *  - the sync task helpfully left a reference to itself in the iocb
 	 */
 	if (is_sync_kiocb(iocb)) {
-		BUG_ON(atomic_read(&iocb->ki_users) != 1);
 		iocb->ki_user_data = res;
-		atomic_set(&iocb->ki_users, 0);
+		smp_wmb();
+		iocb->ki_ctx = ERR_PTR(-EXDEV);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
 	}
@@ -759,7 +736,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		eventfd_signal(iocb->ki_eventfd, 1);
 
 	/* everything turned out well, dispose of the aiocb. */
-	aio_put_req(iocb);
+	kiocb_free(iocb);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1183,7 +1160,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 out_put_req:
 	put_reqs_available(ctx, 1);
-	aio_put_req(req);
+	kiocb_free(req);
 	return ret;
 }
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b570472..c4f07ff 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -30,8 +30,6 @@ struct kiocb;
 typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
-	atomic_t		ki_users;
-
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
@@ -65,7 +63,6 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
-			.ki_users = ATOMIC_INIT(1),
 			.ki_ctx = NULL,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
@@ -75,7 +72,6 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern void aio_put_req(struct kiocb *iocb);
 extern void aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
@@ -84,7 +80,6 @@ extern long do_io_submit(aio_context_t ctx_id, long nr,
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline void aio_put_req(struct kiocb *iocb) { }
 static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
-- 
1.8.2.1

