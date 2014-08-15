Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaHORYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:24:18 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34631 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaHORYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:24:16 -0400
Date: Fri, 15 Aug 2014 13:24:15 -0400
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()
Message-ID: <4b70ac5fd9b58bfaa5f25b4ea48f528aefbf3308.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Benjamin LaHaise wrote:
>
> > -		ctx->mmap_size = 0;
> > -
> > -		kill_ioctx(mm, ctx, NULL);
> > +		if (ctx) {
> > +			ctx->mmap_size = 0;
> > +			kill_ioctx(mm, ctx, NULL);
> > +		}
>
> Rather than indenting and moving the two lines changing mmap_size and the
> kill_ioctx() call, why not just do "if (!ctx) ... continue;"?  That reduces
> the number of lines changed and avoid excessive indentation.

OK. To me the code looks better/simpler with "if (ctx)", but this is subjective
of course, I won't argue.

The patch still removes the empty line between mmap_size = 0 and kill_ioctx(),
we reset mmap_size only for kill_ioctx(). But feel free to remove this change.

-------------------------------------------------------------------------------
Subject: [PATCH v3 1/2] aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()

1. We can read ->ioctx_table only once and we do not read rcu_read_lock()
   or even rcu_dereference().

   This mm has no users, nobody else can play with ->ioctx_table. Otherwise
   the code is buggy anyway, if we need rcu_read_lock() in a loop because
   ->ioctx_table can be updated then kfree(table) is obviously wrong.

2. Update the comment. "exit_mmap(mm) is coming" is the good reason to avoid
   munmap(), but another reason is that we simply can't do vm_munmap() unless
   current->mm == mm and this is not true in general, the caller is mmput().

3. We do not really need to nullify mm->ioctx_table before return, probably
   the current code does this to catch the potential problems. But in this
   case RCU_INIT_POINTER(NULL) looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 955947e..b669646 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -791,40 +791,30 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
  */
 void exit_aio(struct mm_struct *mm)
 {
-	struct kioctx_table *table;
-	struct kioctx *ctx;
-	unsigned i = 0;
-
-	while (1) {
-		rcu_read_lock();
-		table = rcu_dereference(mm->ioctx_table);
-
-		do {
-			if (!table || i >= table->nr) {
-				rcu_read_unlock();
-				rcu_assign_pointer(mm->ioctx_table, NULL);
-				if (table)
-					kfree(table);
-				return;
-			}
+	struct kioctx_table *table = rcu_dereference_raw(mm->ioctx_table);
+	int i;
 
-			ctx = table->table[i++];
-		} while (!ctx);
+	if (!table)
+		return;
 
-		rcu_read_unlock();
+	for (i = 0; i < table->nr; ++i) {
+		struct kioctx *ctx = table->table[i];
 
+		if (!ctx)
+			continue;
 		/*
-		 * We don't need to bother with munmap() here -
-		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
-		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
-		 * place that uses ->mmap_size, so it's safe.
+		 * We don't need to bother with munmap() here - exit_mmap(mm)
+		 * is coming and it'll unmap everything. And we simply can't,
+		 * this is not necessarily our ->mm.
+		 * Since kill_ioctx() uses non-zero ->mmap_size as indicator
+		 * that it needs to unmap the area, just set it to 0.
 		 */
 		ctx->mmap_size = 0;
-
 		kill_ioctx(mm, ctx, NULL);
 	}
+
+	RCU_INIT_POINTER(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
