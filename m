Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaAWKZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:25:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8321 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaAWKZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:25:22 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-17-52e0ee0f3afc
From: Robert Baldyga <r.baldyga@samsung.com>
To: viro@zeniv.linux.org.uk
Cc: bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] aio: fix request cancelling
Date: Thu, 23 Jan 2014 11:25:03 +0100
Message-id: <1390472703-11228-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jQV3+dw+CDM6t47bo+reFxWLKtCZG
	iz17T7JYXN41h81i7ZG77BYPDu9ktzj/9zirA7vHpk+T2D36tqxi9Pi8Sc5j05O3TAEsUVw2
	Kak5mWWpRfp2CVwZG+Y1MRUsVq74c3MHcwPjRJkuRk4OCQETifu9p9ghbDGJC/fWs3UxcnEI
	CUxnlJj5qJ0Fwmlnkphy8DQzSBWbgI7Elu8TGEFsEQFpiTP9l5hAipgFVjFKnH61hBUkIQxU
	NGvNPLAGFgFViSUvZwMVcXDwCrhKLD5UBGJKCChIzJlkM4GRewEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4NB4Jr2DcVWDxSFGAQ5GJR7ehC/3g4RYE8uKK3MPMUpwMCuJ8F548yBI
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2N1RsT1sgsM
	r9SmdjmGcko+PTO9kVU68+4ajbhp3TmyZ+v/eDp8s7jsef22ZlCugIf7xz+fLvt4Lb0a5t2v
	bRSfuLLOsX96r3af6TTFpYe8F7/ad295r57LhrgVYtpr4+9yv7qxJ2l2svce00Xder7R/D0G
	1c3qHU1tFy6zWhx4rvn4UrhdmhJLcUaioRZzUXEiABr4ozwJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This this patch fix kiocb_cancel() function.
If cancel() function ends successfully:
- kiocb request is removed from ctx->active_reqs,
- new event is added to ring buffer (this behavior is described in comment
  in io_cancel function, but was not implemented)
- kiocb_free function is called
- percpu_ref_put is called for ctx->reqs refcount

To do this, part of io_complete function, responsible for adding new event
to ring buffer, was moved into new function named add_event().

This patch solves problem related with lack of possibility to call
aio_complete() from cancel callback. It was because it needs to lock
ctx->ctx_lock which is always locked before kiocb_cancel() call. So there
was no way to complete request properly. Now, after cancel() function call,
request and related resources are freed, and event is added to ring buffer,
so there is no need to call aio_complete() in cancel callback function.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 fs/aio.c |   77 ++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..ea275fa 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -471,8 +471,12 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
+void add_event(struct kiocb *iocb, long res, long res2);
+static void kiocb_free(struct kiocb *req);
+
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 {
+	int ret;
 	kiocb_cancel_fn *old, *cancel;
 
 	/*
@@ -488,8 +492,15 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
 		old = cancel;
 		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
 	} while (cancel != old);
-
-	return cancel(kiocb);
+	
+	ret = cancel(kiocb);
+	if (!ret) {
+		list_del_init(&kiocb->ki_list);
+		add_event(kiocb, -EIDRM, -EIDRM);
+		kiocb_free(kiocb);
+		percpu_ref_put(&ctx->reqs);
+	}
+	return ret;
 }
 
 static void free_ioctx(struct work_struct *work)
@@ -906,40 +917,13 @@ out:
 	return ret;
 }
 
-/* aio_complete
- *	Called when the io request on the given iocb is complete.
- */
-void aio_complete(struct kiocb *iocb, long res, long res2)
+void add_event(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned long	flags;
 	unsigned tail, pos;
-
-	/*
-	 * Special case handling for sync iocbs:
-	 *  - events go directly into the iocb for fast handling
-	 *  - the sync task with the iocb in its stack holds the single iocb
-	 *    ref, no other paths have a way to get another ref
-	 *  - the sync task helpfully left a reference to itself in the iocb
-	 */
-	if (is_sync_kiocb(iocb)) {
-		iocb->ki_user_data = res;
-		smp_wmb();
-		iocb->ki_ctx = ERR_PTR(-EXDEV);
-		wake_up_process(iocb->ki_obj.tsk);
-		return;
-	}
-
-	if (iocb->ki_list.next) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
-		list_del(&iocb->ki_list);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	}
-
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->completion_lock to prevent other code from messing with the tail
@@ -983,6 +967,39 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
+}
+
+/* aio_complete
+ *	Called when the io request on the given iocb is complete.
+ */
+void aio_complete(struct kiocb *iocb, long res, long res2)
+{
+	struct kioctx	*ctx = iocb->ki_ctx;
+
+	/*
+	 * Special case handling for sync iocbs:
+	 *  - events go directly into the iocb for fast handling
+	 *  - the sync task with the iocb in its stack holds the single iocb
+	 *    ref, no other paths have a way to get another ref
+	 *  - the sync task helpfully left a reference to itself in the iocb
+	 */
+	if (is_sync_kiocb(iocb)) {
+		iocb->ki_user_data = res;
+		smp_wmb();
+		iocb->ki_ctx = ERR_PTR(-EXDEV);
+		wake_up_process(iocb->ki_obj.tsk);
+		return;
+	}
+
+	if (iocb->ki_list.next) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&iocb->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
+
+	add_event(iocb, res, res2);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
-- 
1.7.9.5

