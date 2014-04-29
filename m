Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbaD2Sjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:39:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbaD2Sjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:39:41 -0400
Date: Tue, 29 Apr 2014 20:39:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aio: change exit_aio() to load mm->ioctx_table
	once and avoid rcu_read_lock()
Message-ID: <20140429183930.GA32521@redhat.com>
References: <20140429183915.GA32513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429183915.GA32513@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. We can read ->ioctx_table only once and we do not read rcu_read_lock()
   or even rcu_dereference().

   This mm has no users, nobody else can play with ->ioctx_table. Otherwise
   the code is buggy anyway, if we need rcu_read_lock() in a loop because
   ->ioctx_table can be updated then kfree(table) is obviously wrong.

2. Update the comment. "exit_mmap(mm) is coming" is the good reason to avoid
   munmap(), but another reason is that we simply can't do vm_munmap() unless
   current->mm == mm and this is not true in general, the caller is mmput().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/aio.c |   47 ++++++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0..5fd1fe7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -777,40 +777,29 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
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
-
-			ctx = table->table[i++];
-		} while (!ctx);
+	struct kioctx_table *table = rcu_dereference_raw(mm->ioctx_table);
+	int i;
 
-		rcu_read_unlock();
+	if (!table)
+		return;
 
+	for (i = 0; i < table->nr; ++i) {
+		struct kioctx *ctx = table->table[i];
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
-		ctx->mmap_size = 0;
-
-		kill_ioctx(mm, ctx);
+		if (ctx) {
+			ctx->mmap_size = 0;
+			kill_ioctx(mm, ctx);
+		}
 	}
+
+	rcu_assign_pointer(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
-- 
1.5.5.1


