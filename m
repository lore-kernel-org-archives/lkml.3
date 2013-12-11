Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3LKOjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:39:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49516 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3LKOjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:39:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [3.11.y.z extended stable] Patch "aio: restore locking of ioctx list on removal" has been added to staging queue
Date: Wed, 11 Dec 2013 14:39:09 +0000
Message-Id: <1386772749-7418-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    aio: restore locking of ioctx list on removal

to the linux-3.11.y-queue branch of the 3.11.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.11.y-queue

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.11.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Luis

------

>From 642763a516a569734c2d6b424aec0e719a9fda21 Mon Sep 17 00:00:00 2001
From: Mateusz Guzik <mguzik@redhat.com>
Date: Thu, 5 Dec 2013 11:09:02 +0100
Subject: aio: restore locking of ioctx list on removal

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
Acked-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/aio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9b5ca11..975a5d5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -425,10 +425,12 @@ static void kill_ioctx_rcu(struct rcu_head *head)
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
@@ -496,7 +498,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;

-		kill_ioctx(ctx);
+		kill_ioctx(mm, ctx);
 	}
 }

@@ -854,7 +856,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			kill_ioctx(ioctx);
+			kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 	}

@@ -872,7 +874,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		kill_ioctx(ioctx);
+		kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}
--
1.8.3.2

