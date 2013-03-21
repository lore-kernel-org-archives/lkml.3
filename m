Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397Ab3CUQiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:38:13 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:42661 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab3CUQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:41 -0400
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
Subject: [PATCH 27/33] aio: kill ki_key
Date: Thu, 21 Mar 2013 09:35:48 -0700
Message-Id: <1363883754-27966-28-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ki_key wasn't actually used for anything previously - it was always 0.
Drop it to trim struct kiocb a bit.

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
 fs/aio.c            | 7 +++++--
 include/linux/aio.h | 9 ++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index e4b1cc1..8f6fb4d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1257,7 +1257,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		}
 	}
 
-	ret = put_user(req->ki_key, &user_iocb->aio_key);
+	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
@@ -1378,10 +1378,13 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (key != KIOCB_KEY)
+		return NULL;
+
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each(pos, &ctx->active_reqs) {
 		struct kiocb *kiocb = list_kiocb(pos);
-		if (kiocb->ki_obj.user == iocb && kiocb->ki_key == key)
+		if (kiocb->ki_obj.user == iocb)
 			return kiocb;
 	}
 	return NULL;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index f0a8481..7308836 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -12,7 +12,7 @@
 struct kioctx;
 struct kiocb;
 
-#define KIOCB_SYNC_KEY		(~0U)
+#define KIOCB_KEY		0
 
 /*
  * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
@@ -56,10 +56,9 @@ typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
  */
 struct kiocb {
 	atomic_t		ki_users;
-	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
+	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
@@ -95,14 +94,14 @@ struct kiocb {
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
-	return kiocb->ki_key == KIOCB_SYNC_KEY;
+	return kiocb->ki_ctx == NULL;
 }
 
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
 			.ki_users = ATOMIC_INIT(1),
-			.ki_key = KIOCB_SYNC_KEY,
+			.ki_ctx = NULL,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
 		};
-- 
1.8.1.3

