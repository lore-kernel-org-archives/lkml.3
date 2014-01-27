Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaA0IpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:45:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40707 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0IpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:45:23 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-aa-52e61c9efd8f
From: Robert Baldyga <r.baldyga@samsung.com>
To: viro@zeniv.linux.org.uk
Cc: bcrl@kvack.org, kmo@daterainc.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] aio: fix kiocb_cancel() funcition
Date: Mon, 27 Jan 2014 09:45:01 +0100
Message-id: <1390812301-4102-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e+xgO48mWdBBkcuG1p0/dvCYjF/UhOL
	xZRpTYwWe/aeZLG4vGsOm8XaI3fZLR4c3slucf7vcVYHDo+lH1Yxe2z6NIndo2/LKkaPz5vk
	PDY9ecsUwBrFZZOSmpNZllqkb5fAldH46zBLQS9fRf/06WwNjEe5uxg5OSQETCT2blvJCGGL
	SVy4t56ti5GLQ0hgEaPE5/0T2CGcLiaJd7P+gFWxCehIbPk+AcwWEZCWONN/iQmkiFlgL6PE
	n18b2UESwgJGEgvv7gArYhFQlVj+4DqYzSvgIrGicRorxDpFie5nE9gmMHIvYGRYxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcMs+kdjCubLA4xCjAwajEw5tx/WmQEGtiWXFl7iFGCQ5m
	JRHeB5LPgoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	LtSbeC1N3HF35e7IVYxi177smXeD73jLSzltZcmZ08wLU/Ze3PJwSfLUqHp/hksOv4121hnP
	us8XxsrFpBu5JJOr2n+v28yO1W9C3NeyP3n8v/rT6Ru2yT8edlTeXXdF+dq7yRaOUbsyO7te
	pnuoRrvUJWjv3jr1ht2Go2te3c6VWifxe/XMMCWW4oxEQy3mouJEANb15aAVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves problem related with lack of possibility to call
aio_complete() from cancel callback. It was because it needs to lock
ctx->ctx_lock which is always locked before kiocb_cancel() call. So there
was no way to complete request properly.

Now spinlock is unlocked before cancel callback function call, so spinlock
recursion will not occur in case of aio_complete() call. After cancel function
call spinlock is locked back.

There is also __must_hold() macro added for kiocb_cancel() function, to allow
sparse spin lock checking.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

This patch was created according to suggestions of Benjamin LaHaise
(https://lkml.org/lkml/2014/1/23/336).

 fs/aio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..6d5cd9e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -472,8 +472,10 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
+			__must_hold(&ctx->ctx_lock)
 {
 	kiocb_cancel_fn *old, *cancel;
+	int ret;
 
 	/*
 	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
@@ -489,7 +491,15 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
 	} while (cancel != old);
 
-	return cancel(kiocb);
+	/*
+	 * cancel() function may call aio_complete function, which needs to
+	 * lock ctx->ctx_lock, so we call cancel() with spinlock unlocked
+	 */
+	spin_unlock(&ctx->ctx_lock);
+	ret = cancel(kiocb);
+	spin_lock(&ctx->ctx_lock);
+
+	return ret;
 }
 
 static void free_ioctx(struct work_struct *work)
-- 
1.7.9.5

