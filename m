Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab3CUQnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:43:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:32858 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934269Ab3CUQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:43:21 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 12:43:20 EDT
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
Subject: [PATCH 07/33] aio: add kiocb_cancel()
Date: Thu, 21 Mar 2013 09:35:28 -0700
Message-Id: <1363883754-27966-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor refactoring, to get rid of some duplicated code

[akpm@linux-foundation.org: fix warning]
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
 fs/aio.c | 79 +++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6b29e41a..d291228 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -220,6 +220,29 @@ static inline void put_ioctx(struct kioctx *kioctx)
 		__put_ioctx(kioctx);
 }
 
+static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
+			struct io_event *res)
+{
+	int (*cancel)(struct kiocb *, struct io_event *);
+	int ret = -EINVAL;
+
+	cancel = kiocb->ki_cancel;
+	kiocbSetCancelled(kiocb);
+	if (cancel) {
+		kiocb->ki_users++;
+		spin_unlock_irq(&ctx->ctx_lock);
+
+		memset(res, 0, sizeof(*res));
+		res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
+		res->data = kiocb->ki_user_data;
+		ret = cancel(kiocb, res);
+
+		spin_lock_irq(&ctx->ctx_lock);
+	}
+
+	return ret;
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -290,25 +313,19 @@ out_freectx:
  */
 static void kill_ctx(struct kioctx *ctx)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 	struct io_event res;
+	struct kiocb *req;
 
 	spin_lock_irq(&ctx->ctx_lock);
 	ctx->dead = 1;
 	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
-		cancel = iocb->ki_cancel;
-		kiocbSetCancelled(iocb);
-		if (cancel) {
-			iocb->ki_users++;
-			spin_unlock_irq(&ctx->ctx_lock);
-			cancel(iocb, &res);
-			spin_lock_irq(&ctx->ctx_lock);
-		}
+		req = list_first_entry(&ctx->active_reqs,
+					struct kiocb, ki_list);
+
+		list_del_init(&req->ki_list);
+		kiocb_cancel(ctx, req, &res);
 	}
 
 	if (!ctx->reqs_active)
@@ -1411,7 +1428,7 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	int (*cancel)(struct kiocb *iocb, struct io_event *res);
+	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1426,32 +1443,22 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = -EAGAIN;
+
 	kiocb = lookup_kiocb(ctx, iocb, key);
-	if (kiocb && kiocb->ki_cancel) {
-		cancel = kiocb->ki_cancel;
-		kiocb->ki_users ++;
-		kiocbSetCancelled(kiocb);
-	} else
-		cancel = NULL;
+	if (kiocb)
+		ret = kiocb_cancel(ctx, kiocb, &res);
+	else
+		ret = -EINVAL;
+
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (NULL != cancel) {
-		struct io_event tmp;
-		pr_debug("calling cancel\n");
-		memset(&tmp, 0, sizeof(tmp));
-		tmp.obj = (u64)(unsigned long)kiocb->ki_obj.user;
-		tmp.data = kiocb->ki_user_data;
-		ret = cancel(kiocb, &tmp);
-		if (!ret) {
-			/* Cancellation succeeded -- copy the result
-			 * into the user's buffer.
-			 */
-			if (copy_to_user(result, &tmp, sizeof(tmp)))
-				ret = -EFAULT;
-		}
-	} else
-		ret = -EINVAL;
+	if (!ret) {
+		/* Cancellation succeeded -- copy the result
+		 * into the user's buffer.
+		 */
+		if (copy_to_user(result, &res, sizeof(res)))
+			ret = -EFAULT;
+	}
 
 	put_ioctx(ctx);
 
-- 
1.8.1.3

