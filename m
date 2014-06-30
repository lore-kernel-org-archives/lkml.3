Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaF3MW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:22:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51924 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/181] aio: block io_destroy() until all context requests are completed
Date: Mon, 30 Jun 2014 13:51:09 +0200
Message-Id: <d8ae3edcc37feb317ffb58ab9b9a0ccec962cd81.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anatol Pomozov <anatol.pomozov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c upstream.

deletes aio context and all resources related to. It makes sense that
no IO operations connected to the context should be running after the context
is destroyed. As we removed io_context we have no chance to
get requests status or call io_getevents().

man page for io_destroy says that this function may block until
all context's requests are completed. Before kernel 3.11 io_destroy()
blocked indeed, but since aio refactoring in 3.11 it is not true anymore.

Here is a pseudo-code that shows a testcase for a race condition discovered
in 3.11:

  initialize io_context
  io_submit(read to buffer)
  io_destroy()

  // context is destroyed so we can free the resources
  free(buffers);

  // if the buffer is allocated by some other user he'll be surprised
  // to learn that the buffer still filled by an outstanding operation
  // from the destroyed io_context

The fix is straight-forward - add a completion struct and wait on it
in io_destroy, complete() should be called when number of in-fligh requests
reaches zero.

If two or more io_destroy() called for the same context simultaneously then
only the first one waits for IO completion, other calls behaviour is undefined.

Tested: ran http://pastebin.com/LrPsQ4RL testcase for several hours and
  do not see the race condition anymore.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 04cd7686555d..a0ed6c7d2cd2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -112,6 +112,11 @@ struct kioctx {
 
 	struct work_struct	free_work;
 
+	/*
+	 * signals when all in-flight requests are done
+	 */
+	struct completion *requests_done;
+
 	struct {
 		/*
 		 * This counts the number of available slots in the ringbuffer,
@@ -508,6 +513,10 @@ static void free_ioctx_reqs(struct percpu_ref *ref)
 {
 	struct kioctx *ctx = container_of(ref, struct kioctx, reqs);
 
+	/* At this point we know that there are no any in-flight requests */
+	if (ctx->requests_done)
+		complete(ctx->requests_done);
+
 	INIT_WORK(&ctx->free_work, free_ioctx);
 	schedule_work(&ctx->free_work);
 }
@@ -718,7 +727,8 @@ err:
  *	when the processes owning a context have all exited to encourage
  *	the rapid destruction of the kioctx.
  */
-static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
+static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
+		struct completion *requests_done)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
 		struct kioctx_table *table;
@@ -747,7 +757,11 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 		if (ctx->mmap_size)
 			vm_munmap(ctx->mmap_base, ctx->mmap_size);
 
+		ctx->requests_done = requests_done;
 		percpu_ref_kill(&ctx->users);
+	} else {
+		if (requests_done)
+			complete(requests_done);
 	}
 }
 
@@ -809,7 +823,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		kill_ioctx(mm, ctx);
+		kill_ioctx(mm, ctx, NULL);
 	}
 }
 
@@ -1185,7 +1199,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			kill_ioctx(current->mm, ioctx);
+			kill_ioctx(current->mm, ioctx, NULL);
 		percpu_ref_put(&ioctx->users);
 	}
 
@@ -1203,8 +1217,22 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		kill_ioctx(current->mm, ioctx);
+		struct completion requests_done =
+			COMPLETION_INITIALIZER_ONSTACK(requests_done);
+
+		/* Pass requests_done to kill_ioctx() where it can be set
+		 * in a thread-safe way. If we try to set it here then we have
+		 * a race condition if two io_destroy() called simultaneously.
+		 */
+		kill_ioctx(current->mm, ioctx, &requests_done);
 		percpu_ref_put(&ioctx->users);
+
+		/* Wait until all IO for the context are done. Otherwise kernel
+		 * keep using user-space buffers even if user thinks the context
+		 * is destroyed.
+		 */
+		wait_for_completion(&requests_done);
+
 		return 0;
 	}
 	pr_debug("EINVAL: io_destroy: invalid context id\n");
-- 
2.0.0

