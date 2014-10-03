Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaJCSGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:06:39 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51579 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaJCSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:06:36 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Slava Pestov <sp@daterainc.com>
Subject: [PATCH] aio: Fix return code of io_submit() (RFC)
Date: Fri,  3 Oct 2014 11:08:13 -0700
Message-Id: <1412359693-2535-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

io_submit() could return -EAGAIN on memory allocation failure when it should
really have been returning -ENOMEM. This could confuse applications (i.e. fio)
since -EAGAIN means "too many requests outstanding, wait until completions have
been reaped" and if the application actually was tracking outstanding
completions this wouldn't make a lot of sense.

NOTE:

the man page seems to imply that the current behaviour (-EAGAIN on allocation
failure) has always been the case. I don't think it makes a lot of sense, but
this should probably be discussed more widely in case applications have somehow
come to rely on the current behaviour...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zab@zabbo.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Slava Pestov <sp@daterainc.com>
---
 fs/aio.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 733750096b..556547044b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -933,23 +933,14 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (!get_reqs_available(ctx)) {
-		user_refill_reqs_available(ctx);
-		if (!get_reqs_available(ctx))
-			return NULL;
-	}
-
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
-		goto out_put;
+		return NULL;
 
 	percpu_ref_get(&ctx->reqs);
 
 	req->ki_ctx = ctx;
 	return req;
-out_put:
-	put_reqs_available(ctx, 1);
-	return NULL;
 }
 
 static void kiocb_free(struct kiocb *req)
@@ -1489,9 +1480,17 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EINVAL;
 	}
 
+	if (!get_reqs_available(ctx)) {
+		user_refill_reqs_available(ctx);
+		if (!get_reqs_available(ctx))
+			return -EAGAIN;
+	}
+
 	req = aio_get_req(ctx);
-	if (unlikely(!req))
-		return -EAGAIN;
+	if (unlikely(!req)) {
+		ret = -ENOMEM;
+		goto out_put;
+	}
 
 	req->ki_filp = fget(iocb->aio_fildes);
 	if (unlikely(!req->ki_filp)) {
@@ -1533,9 +1532,10 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 
 	return 0;
 out_put_req:
-	put_reqs_available(ctx, 1);
 	percpu_ref_put(&ctx->reqs);
 	kiocb_free(req);
+out_put:
+	put_reqs_available(ctx, 1);
 	return ret;
 }
 
-- 
2.1.1

