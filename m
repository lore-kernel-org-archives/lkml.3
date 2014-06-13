Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaFMVYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:24:35 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37048 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaFMVYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:24:32 -0400
Date: Fri, 13 Jun 2014 17:24:31 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: torvalds@linux-foundation.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] aio: cleanup: flatten kill_ioctx()
Message-ID: <fa88b6f8803c87c4ced5aac11261ced7cedaa05e.1402694489.git.bcrl@kvack.org>
References: <cover.1402694489.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402694489.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have most of the code in kill_ioctx() indented.  Flatten
it.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 044c1c8..79b7e69 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -730,39 +730,39 @@ err:
 static int kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
 		struct completion *requests_done)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
-		struct kioctx_table *table;
+	struct kioctx_table *table;
 
-		spin_lock(&mm->ioctx_lock);
-		rcu_read_lock();
-		table = rcu_dereference(mm->ioctx_table);
+	if (atomic_xchg(&ctx->dead, 1))
+		return -EINVAL;
 
-		WARN_ON(ctx != table->table[ctx->id]);
-		table->table[ctx->id] = NULL;
-		rcu_read_unlock();
-		spin_unlock(&mm->ioctx_lock);
 
-		/* percpu_ref_kill() will do the necessary call_rcu() */
-		wake_up_all(&ctx->wait);
+	spin_lock(&mm->ioctx_lock);
+	rcu_read_lock();
+	table = rcu_dereference(mm->ioctx_table);
+
+	WARN_ON(ctx != table->table[ctx->id]);
+	table->table[ctx->id] = NULL;
+	rcu_read_unlock();
+	spin_unlock(&mm->ioctx_lock);
 
-		/*
-		 * It'd be more correct to do this in free_ioctx(), after all
-		 * the outstanding kiocbs have finished - but by then io_destroy
-		 * has already returned, so io_setup() could potentially return
-		 * -EAGAIN with no ioctxs actually in use (as far as userspace
-		 *  could tell).
-		 */
-		aio_nr_sub(ctx->max_reqs);
+	/* percpu_ref_kill() will do the necessary call_rcu() */
+	wake_up_all(&ctx->wait);
 
-		if (ctx->mmap_size)
-			vm_munmap(ctx->mmap_base, ctx->mmap_size);
+	/*
+	 * It'd be more correct to do this in free_ioctx(), after all
+	 * the outstanding kiocbs have finished - but by then io_destroy
+	 * has already returned, so io_setup() could potentially return
+	 * -EAGAIN with no ioctxs actually in use (as far as userspace
+	 *  could tell).
+	 */
+	aio_nr_sub(ctx->max_reqs);
 
-		ctx->requests_done = requests_done;
-		percpu_ref_kill(&ctx->users);
-		return 0;
-	}
+	if (ctx->mmap_size)
+		vm_munmap(ctx->mmap_base, ctx->mmap_size);
 
-	return -EINVAL;
+	ctx->requests_done = requests_done;
+	percpu_ref_kill(&ctx->users);
+	return 0;
 }
 
 /* wait_on_sync_kiocb:
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
