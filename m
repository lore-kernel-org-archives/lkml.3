Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaBRPft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbaBRPfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:35:47 -0500
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] aio: simplify exit_aio
Date: Tue, 18 Feb 2014 16:35:39 +0100
Message-Id: <1392737739-21685-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are no other callers which can manipulate ioctx_table at
this stage it is not necessary to reload table pointer each time nor
to traverse it under rcu_read_lock

While here convert the loop to more readable for () and fix the
comment (aio_free_ring -> kill_ioctx).

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
---
 fs/aio.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..0701181 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -766,38 +766,35 @@ void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx_table *table;
 	struct kioctx *ctx;
-	unsigned i = 0;
+	unsigned i;
 
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
+	rcu_read_lock();
+	table = rcu_dereference(mm->ioctx_table);
+	rcu_read_unlock();
 
-			ctx = table->table[i++];
-		} while (!ctx);
+	if (!table)
+		return;
 
-		rcu_read_unlock();
+	for (i = 0; i < table->nr; i++) {
+		ctx = table->table[i];
+		if (!ctx)
+			continue;
 
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
+		 * Since kill_ioctx() uses non-zero ->mmap_size
 		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
+		 * just set it to 0; kill_ioctx() is the only
 		 * place that uses ->mmap_size, so it's safe.
 		 */
 		ctx->mmap_size = 0;
 
 		kill_ioctx(mm, ctx);
 	}
+
+	rcu_assign_pointer(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
-- 
1.8.3.1

