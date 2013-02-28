Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab3B1Ufr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:35:47 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:39713 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3B1Ufp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:35:45 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: Kent Overstreet <koverstreet@google.com>, tytso@mit.edu, axboe@kernel.dk,
        zab@redhat.com, bcrl@kvack.org, anatol@google.com
Subject: [PATCH 1/4] aio: io_cancel() no longer returns the io_event
Date: Thu, 28 Feb 2013 12:35:38 -0800
Message-Id: <1362083741-2429-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, io_event() was documented to return the io_event if
cancellation succeeded - the io_event wouldn't be delivered via the ring
buffer like it normally would.

But this isn't what the implementation was actually doing; the only
driver implementing cancellation, the usb gadget code, never returned an
io_event in its cancel function. And aio_complete() was recently changed
to no longer suppress event delivery if the kiocb had been cancelled.

This gets rid of the unused io_event argument to kiocb_cancel() and
kiocb->ki_cancel(), and changes io_cancel() to return -EINPROGRESS if
kiocb->ki_cancel() returned success.

Also tweak the refcounting in kiocb_cancel() to make more sense.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/usb/gadget/inode.c |  3 +--
 fs/aio.c                   | 24 ++++++++++--------------
 include/linux/aio.h        |  2 +-
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index b540a1d..fd1bf4a 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -524,7 +524,7 @@ struct kiocb_priv {
 	unsigned		actual;
 };
 
-static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
+static void ep_aio_cancel(struct kiocb *iocb)
 {
 	struct kiocb_priv	*priv = iocb->private;
 	struct ep_data		*epdata;
@@ -540,7 +540,6 @@ static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
 	// spin_unlock(&epdata->dev->lock);
 	local_irq_enable();
 
-	aio_put_req(iocb);
 	return value;
 }
 
diff --git a/fs/aio.c b/fs/aio.c
index a86ffd0..4b9bfb5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -256,8 +256,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
-			struct io_event *res)
+static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
 	int ret = -EINVAL;
@@ -279,12 +278,10 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 	atomic_inc(&kiocb->ki_users);
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	memset(res, 0, sizeof(*res));
-	res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
-	res->data = kiocb->ki_user_data;
-	ret = cancel(kiocb, res);
+	ret = cancel(kiocb);
 
 	spin_lock_irq(&ctx->ctx_lock);
+	aio_put_req(kiocb);
 
 	return ret;
 }
@@ -305,7 +302,6 @@ static void free_ioctx_rcu(struct rcu_head *head)
 static void free_ioctx(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
-	struct io_event res;
 	struct kiocb *req;
 	unsigned cpu, head, avail;
 
@@ -316,7 +312,7 @@ static void free_ioctx(struct kioctx *ctx)
 				       struct kiocb, ki_list);
 
 		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req, &res);
+		kiocb_cancel(ctx, req);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -1351,7 +1347,6 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1369,18 +1364,19 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
 	kiocb = lookup_kiocb(ctx, iocb, key);
 	if (kiocb)
-		ret = kiocb_cancel(ctx, kiocb, &res);
+		ret = kiocb_cancel(ctx, kiocb);
 	else
 		ret = -EINVAL;
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	if (!ret) {
-		/* Cancellation succeeded -- copy the result
-		 * into the user's buffer.
+		/*
+		 * The result argument is no longer used - the io_event is
+		 * always delivered via the ring buffer. -EINPROGRESS indicates
+		 * cancellation is progress:
 		 */
-		if (copy_to_user(result, &res, sizeof(res)))
-			ret = -EFAULT;
+		ret = -EINPROGRESS;
 	}
 
 	put_ioctx(ctx);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 93892bf..7340f77 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -28,7 +28,7 @@ struct batch_complete;
  */
 #define KIOCB_CANCELLED		((void *) (~0ULL))
 
-typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
+typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
 	struct rb_node		ki_node;
-- 
1.7.12

