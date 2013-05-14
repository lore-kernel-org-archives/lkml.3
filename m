Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3ENBYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:24:30 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:61272 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3ENBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:12 -0400
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
Subject: [PATCH 06/21] aio: io_cancel() no longer returns the io_event
Date: Mon, 13 May 2013 18:18:43 -0700
Message-Id: <1368494338-7069-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
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
 drivers/usb/gadget/inode.c |  3 +--
 fs/aio.c                   | 40 ++++++++++------------------------------
 include/linux/aio.h        |  2 +-
 3 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 570c005..e02c1e0 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -524,7 +524,7 @@ struct kiocb_priv {
 	unsigned		actual;
 };
 
-static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
+static int ep_aio_cancel(struct kiocb *iocb)
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
index 93383b0..5e1b801 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -259,8 +259,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
-			struct io_event *res)
+static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
 	int ret = -EINVAL;
@@ -282,12 +281,10 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
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
@@ -308,7 +305,6 @@ static void free_ioctx_rcu(struct rcu_head *head)
 static void free_ioctx(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
-	struct io_event res;
 	struct kiocb *req;
 	unsigned cpu, head, avail;
 
@@ -319,7 +315,7 @@ static void free_ioctx(struct kioctx *ctx)
 				       struct kiocb, ki_list);
 
 		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req, &res);
+		kiocb_cancel(ctx, req);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -709,21 +705,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	}
 
 	/*
-	 * cancelled requests don't get events, userland was given one
-	 * when the event got cancelled.
-	 */
-	if (unlikely(xchg(&iocb->ki_cancel,
-			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-		/*
-		 * Can't use the percpu reqs_available here - could race with
-		 * free_ioctx()
-		 */
-		atomic_inc(&ctx->reqs_available);
-		/* Still need the wake_up in case free_ioctx is waiting */
-		goto put_rq;
-	}
-
-	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->ctx_lock to prevent other code from messing with the tail
 	 * pointer since we might be called from irq context.
@@ -775,7 +756,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	if (iocb->ki_eventfd != NULL)
 		eventfd_signal(iocb->ki_eventfd, 1);
 
-put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
 
@@ -1352,7 +1332,6 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1370,18 +1349,19 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
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
index 1bdf965..8c8dd1d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -27,7 +27,7 @@ struct kiocb;
  */
 #define KIOCB_CANCELLED		((void *) (~0ULL))
 
-typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
+typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
 	atomic_t		ki_users;
-- 
1.8.2.1

