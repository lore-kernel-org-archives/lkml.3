Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaHORYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:24:31 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34677 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaHORY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:24:29 -0400
Date: Fri, 15 Aug 2014 13:24:29 -0400
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] aio: kill the misleading rcu read locks in ioctx_add_table() and kill_ioctx()
Message-ID: <855ef0dec7271ff7be7381feaaf3f4aed80bd503.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctx_add_table() is the writer, it does not need rcu_read_lock() to
protect ->ioctx_table. It relies on mm->ioctx_lock and rcu locks just
add the confusion.

And it doesn't need rcu_dereference() by the same reason, it must see
any updates previously done under the same ->ioctx_lock. We could use
rcu_dereference_protected() but the patch uses rcu_dereference_raw(),
the function is simple enough.

The same for kill_ioctx(), although it does not update the pointer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b669646..c1d8c48 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -554,8 +554,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 	struct aio_ring *ring;
 
 	spin_lock(&mm->ioctx_lock);
-	rcu_read_lock();
-	table = rcu_dereference(mm->ioctx_table);
+	table = rcu_dereference_raw(mm->ioctx_table);
 
 	while (1) {
 		if (table)
@@ -563,7 +562,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				if (!table->table[i]) {
 					ctx->id = i;
 					table->table[i] = ctx;
-					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
 					/* While kioctx setup is in progress,
@@ -577,8 +575,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				}
 
 		new_nr = (table ? table->nr : 1) * 4;
-
-		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		table = kzalloc(sizeof(*table) + sizeof(struct kioctx *) *
@@ -589,8 +585,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 		table->nr = new_nr;
 
 		spin_lock(&mm->ioctx_lock);
-		rcu_read_lock();
-		old = rcu_dereference(mm->ioctx_table);
+		old = rcu_dereference_raw(mm->ioctx_table);
 
 		if (!old) {
 			rcu_assign_pointer(mm->ioctx_table, table);
@@ -737,12 +732,9 @@ static int kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
 
 
 	spin_lock(&mm->ioctx_lock);
-	rcu_read_lock();
-	table = rcu_dereference(mm->ioctx_table);
-
+	table = rcu_dereference_raw(mm->ioctx_table);
 	WARN_ON(ctx != table->table[ctx->id]);
 	table->table[ctx->id] = NULL;
-	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 
 	/* percpu_ref_kill() will do the necessary call_rcu() */
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
