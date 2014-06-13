Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaFMVY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:24:28 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37002 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaFMVYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:24:25 -0400
Date: Fri, 13 Jun 2014 17:24:24 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: torvalds@linux-foundation.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] aio: report error from io_destroy() when threads race in io_destroy()
Message-ID: <fb2d44838320b78e6e3b5eb2e35b70f62f262e4c.1402694489.git.bcrl@kvack.org>
References: <cover.1402694489.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402694489.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Anatol Pomozov, io_destroy() fails to report an error when
it loses the race to destroy a given ioctx.  Since there is a difference in
behaviour between the thread that wins the race (which blocks on outstanding
io requests) versus lthe thread that loses (which returns immediately), wire
up a return code from kill_ioctx() to the io_destroy() syscall.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/aio.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 908006e..044c1c8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -727,7 +727,7 @@ err:
  *	when the processes owning a context have all exited to encourage
  *	the rapid destruction of the kioctx.
  */
-static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
+static int kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
 		struct completion *requests_done)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
@@ -759,10 +759,10 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
 
 		ctx->requests_done = requests_done;
 		percpu_ref_kill(&ctx->users);
-	} else {
-		if (requests_done)
-			complete(requests_done);
+		return 0;
 	}
+
+	return -EINVAL;
 }
 
 /* wait_on_sync_kiocb:
@@ -1219,21 +1219,23 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 	if (likely(NULL != ioctx)) {
 		struct completion requests_done =
 			COMPLETION_INITIALIZER_ONSTACK(requests_done);
+		int ret;
 
 		/* Pass requests_done to kill_ioctx() where it can be set
 		 * in a thread-safe way. If we try to set it here then we have
 		 * a race condition if two io_destroy() called simultaneously.
 		 */
-		kill_ioctx(current->mm, ioctx, &requests_done);
+		ret = kill_ioctx(current->mm, ioctx, &requests_done);
 		percpu_ref_put(&ioctx->users);
 
 		/* Wait until all IO for the context are done. Otherwise kernel
 		 * keep using user-space buffers even if user thinks the context
 		 * is destroyed.
 		 */
-		wait_for_completion(&requests_done);
+		if (!ret)
+			wait_for_completion(&requests_done);
 
-		return 0;
+		return ret;
 	}
 	pr_debug("EINVAL: io_destroy: invalid context id\n");
 	return -EINVAL;
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
