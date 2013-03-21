Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab3CUQgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:38 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:53943 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306Ab3CUQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:29 -0400
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
Subject: [PATCH 18/33] aio: kill batch allocation
Date: Thu, 21 Mar 2013 09:35:39 -0700
Message-Id: <1363883754-27966-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, allocating a kiocb required touching quite a few global (well,
per kioctx) cachelines...  so batching up allocation to amortize those was
worthwhile.  But we've gotten rid of some of those, and in another couple
of patches kiocb allocation won't require writing to any shared
cachelines, so that means we can just rip this code out.

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
 fs/aio.c            | 116 +++++++---------------------------------------------
 include/linux/aio.h |   1 -
 2 files changed, 15 insertions(+), 102 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6828a31..95fcd08 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -510,108 +510,27 @@ void exit_aio(struct mm_struct *mm)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
-	struct kiocb *req = NULL;
+	struct kiocb *req;
+
+	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+		return NULL;
+
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr - 1)
+		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
-		return NULL;
+		goto out_put;
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
 
 	return req;
-}
-
-/*
- * struct kiocb's are allocated in batches to reduce the number of
- * times the ctx lock is acquired and released.
- */
-#define KIOCB_BATCH_SIZE	32L
-struct kiocb_batch {
-	struct list_head head;
-	long count; /* number of requests left to allocate */
-};
-
-static void kiocb_batch_init(struct kiocb_batch *batch, long total)
-{
-	INIT_LIST_HEAD(&batch->head);
-	batch->count = total;
-}
-
-static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	struct kiocb *req, *n;
-
-	if (list_empty(&batch->head))
-		return;
-
-	spin_lock_irq(&ctx->ctx_lock);
-	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-		list_del(&req->ki_batch);
-		kmem_cache_free(kiocb_cachep, req);
-		atomic_dec(&ctx->reqs_active);
-	}
-	spin_unlock_irq(&ctx->ctx_lock);
-}
-
-/*
- * Allocate a batch of kiocbs.  This avoids taking and dropping the
- * context lock a lot during setup.
- */
-static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	unsigned short allocated, to_alloc;
-	long avail;
-	struct kiocb *req, *n;
-
-	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
-	for (allocated = 0; allocated < to_alloc; allocated++) {
-		req = __aio_get_req(ctx);
-		if (!req)
-			/* allocation failed, go with what we've got */
-			break;
-		list_add(&req->ki_batch, &batch->head);
-	}
-
-	if (allocated == 0)
-		goto out;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active) - 1;
-	BUG_ON(avail < 0);
-	if (avail < allocated) {
-		/* Trim back the number of requests. */
-		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-			list_del(&req->ki_batch);
-			kmem_cache_free(kiocb_cachep, req);
-			if (--allocated <= avail)
-				break;
-		}
-	}
-
-	batch->count -= allocated;
-	atomic_add(allocated, &ctx->reqs_active);
-
-	spin_unlock_irq(&ctx->ctx_lock);
-
-out:
-	return allocated;
-}
-
-static inline struct kiocb *aio_get_req(struct kioctx *ctx,
-					struct kiocb_batch *batch)
-{
-	struct kiocb *req;
-
-	if (list_empty(&batch->head))
-		if (kiocb_batch_refill(ctx, batch) == 0)
-			return NULL;
-	req = list_first_entry(&batch->head, struct kiocb, ki_batch);
-	list_del(&req->ki_batch);
-	return req;
+out_put:
+	atomic_dec(&ctx->reqs_active);
+	return NULL;
 }
 
 static void kiocb_free(struct kiocb *req)
@@ -1192,8 +1111,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, struct kiocb_batch *batch,
-			 bool compat)
+			 struct iocb *iocb, bool compat)
 {
 	struct kiocb *req;
 	ssize_t ret;
@@ -1214,7 +1132,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EINVAL;
 	}
 
-	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
+	req = aio_get_req(ctx);  /* returns with 2 references to req */
 	if (unlikely(!req))
 		return -EAGAIN;
 
@@ -1286,7 +1204,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	long ret = 0;
 	int i = 0;
 	struct blk_plug plug;
-	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1303,8 +1220,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		return -EINVAL;
 	}
 
-	kiocb_batch_init(&batch, nr);
-
 	blk_start_plug(&plug);
 
 	/*
@@ -1325,13 +1240,12 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, &batch, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
-	kiocb_batch_free(ctx, &batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
diff --git a/include/linux/aio.h b/include/linux/aio.h
index d2a0003..f0a8481 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -85,7 +85,6 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-	struct list_head	ki_batch;	/* batch allocation */
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
-- 
1.8.1.3

