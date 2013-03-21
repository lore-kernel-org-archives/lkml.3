Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab3CUQgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:18 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34343 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3CUQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:12 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 06/33] aio: kill return value of aio_complete()
Date: Thu, 21 Mar 2013 09:35:27 -0700
Message-Id: <1363883754-27966-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing used the return value, and it probably wasn't possible to use it
safely for the locked versions (aio_complete(), aio_put_req()).  Just kill
it.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Acked-by: Zach Brown <zab@redhat.com>
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
 fs/aio.c            | 21 +++++++--------------
 include/linux/aio.h |  8 ++++----
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f9a7e6a..6b29e41a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -531,7 +531,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 /* __aio_put_req
  *	Returns true if this put was the last user of the request.
  */
-static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
+static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
@@ -541,7 +541,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
-		return 0;
+		return;
 	list_del(&req->ki_list);		/* remove from active_reqs */
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
@@ -549,21 +549,18 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	fput(req->ki_filp);
 	req->ki_filp = NULL;
 	really_put_req(ctx, req);
-	return 1;
 }
 
 /* aio_put_req
  *	Returns true if this put was the last user of the kiocb,
  *	false if the request is still in use.
  */
-int aio_put_req(struct kiocb *req)
+void aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
-	int ret;
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = __aio_put_req(ctx, req);
+	__aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
-	return ret;
 }
 EXPORT_SYMBOL(aio_put_req);
 
@@ -593,10 +590,8 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
- *	Returns true if this is the last user of the request.  The 
- *	only other user of the request can be the cancellation code.
  */
-int aio_complete(struct kiocb *iocb, long res, long res2)
+void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -604,7 +599,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	struct io_event	*event;
 	unsigned long	flags;
 	unsigned long	tail;
-	int		ret;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -618,7 +612,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_user_data = res;
 		iocb->ki_users = 0;
 		wake_up_process(iocb->ki_obj.tsk);
-		return 1;
+		return;
 	}
 
 	info = &ctx->ring_info;
@@ -677,7 +671,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	ret = __aio_put_req(ctx, iocb);
+	__aio_put_req(ctx, iocb);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -691,7 +685,6 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	return ret;
 }
 EXPORT_SYMBOL(aio_complete);
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 019204e..615d55a 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -167,16 +167,16 @@ struct kioctx {
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern int aio_put_req(struct kiocb *iocb);
-extern int aio_complete(struct kiocb *iocb, long res, long res2);
+extern void aio_put_req(struct kiocb *iocb);
+extern void aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+static inline void aio_put_req(struct kiocb *iocb) { }
+static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
-- 
1.8.1.3

