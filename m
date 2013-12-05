Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3LEKJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:09:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3LEKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:09:08 -0500
From: Mateusz Guzik <mguzik@redhat.com>
To: stable@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3.10] aio: restore locking of ioctx list on removal
Date: Thu,  5 Dec 2013 11:09:02 +0100
Message-Id: <1386238142-21792-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
"aio: refcounting cleanup" resulted in ioctx_lock not being held
during ctx removal, leaving the list susceptible to corruptions.

In mainline kernel the issue went away as a side effect of
db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
table lookup v3".

Fix the problem by restoring appropriate locking.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reported-by: Eryu Guan <eguan@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org

---
 fs/aio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2bbcacf..ebd06fd 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -423,10 +423,12 @@ static void kill_ioctx_rcu(struct rcu_head *head)
  *	when the processes owning a context have all exited to encourage
  *	the rapid destruction of the kioctx.
  */
-static void kill_ioctx(struct kioctx *ctx)
+static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
+		spin_lock(&mm->ioctx_lock);
 		hlist_del_rcu(&ctx->list);
+		spin_unlock(&mm->ioctx_lock);
 
 		/*
 		 * It'd be more correct to do this in free_ioctx(), after all
@@ -494,7 +496,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		kill_ioctx(ctx);
+		kill_ioctx(mm, ctx);
 	}
 }
 
@@ -852,7 +854,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			kill_ioctx(ioctx);
+			kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 	}
 
@@ -870,7 +872,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		kill_ioctx(ioctx);
+		kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}
-- 
1.8.3.1

