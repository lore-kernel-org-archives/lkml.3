Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab3E1V0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63726 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3E1V0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:25 -0400
From: Kent Overstreet <koverstreet@google.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH] aio: Use call_rcu() instead of synchronize_rcu() in kill_ioctx()
Date: Tue, 28 May 2013 14:26:18 -0700
Message-Id: <1369776378-27921-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just making ioctx shutdown asynchronous so as not to block io_destroy()
- and percpu refcounts for the ioctx are going to need a RCU barrier in
the same place anyways.

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
---
 fs/aio.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7fe5bde..2bbcacf 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -141,9 +141,6 @@ static void aio_free_ring(struct kioctx *ctx)
 	for (i = 0; i < ctx->nr_pages; i++)
 		put_page(ctx->ring_pages[i]);
 
-	if (ctx->mmap_size)
-		vm_munmap(ctx->mmap_base, ctx->mmap_size);
-
 	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
 		kfree(ctx->ring_pages);
 }
@@ -322,11 +319,6 @@ static void free_ioctx(struct kioctx *ctx)
 
 	aio_free_ring(ctx);
 
-	spin_lock(&aio_nr_lock);
-	BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
-	aio_nr -= ctx->max_reqs;
-	spin_unlock(&aio_nr_lock);
-
 	pr_debug("freeing %p\n", ctx);
 
 	/*
@@ -435,17 +427,24 @@ static void kill_ioctx(struct kioctx *ctx)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
 		hlist_del_rcu(&ctx->list);
-		/* Between hlist_del_rcu() and dropping the initial ref */
-		synchronize_rcu();
 
 		/*
-		 * We can't punt to workqueue here because put_ioctx() ->
-		 * free_ioctx() will unmap the ringbuffer, and that has to be
-		 * done in the original process's context. kill_ioctx_rcu/work()
-		 * exist for exit_aio(), as in that path free_ioctx() won't do
-		 * the unmap.
+		 * It'd be more correct to do this in free_ioctx(), after all
+		 * the outstanding kiocbs have finished - but by then io_destroy
+		 * has already returned, so io_setup() could potentially return
+		 * -EAGAIN with no ioctxs actually in use (as far as userspace
+		 *  could tell).
 		 */
-		kill_ioctx_work(&ctx->rcu_work);
+		spin_lock(&aio_nr_lock);
+		BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
+		aio_nr -= ctx->max_reqs;
+		spin_unlock(&aio_nr_lock);
+
+		if (ctx->mmap_size)
+			vm_munmap(ctx->mmap_base, ctx->mmap_size);
+
+		/* Between hlist_del_rcu() and dropping the initial ref */
+		call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 	}
 }
 
@@ -495,10 +494,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
-			hlist_del_rcu(&ctx->list);
-			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
-		}
+		kill_ioctx(ctx);
 	}
 }
 
-- 
1.8.2.1

