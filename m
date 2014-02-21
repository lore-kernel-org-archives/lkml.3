Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaBUKXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:23:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaBUKXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:23:39 -0500
X-IronPort-AV: E=Sophos;i="4.97,517,1389715200"; 
   d="scan'208";a="9575605"
Message-ID: <5307272E.4030101@cn.fujitsu.com>
Date: Fri, 21 Feb 2014 18:15:10 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin <bcrl@kvack.org>
CC: linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] aio: simplify fetching ioctx_table pointer from  mm_struct
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:21:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:21:23,
	Serialize complete at 2014/02/21 18:21:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rcu_dereference_protected() rather than the "rcu_read_lock-->
rcu_dereference-->rcu_read_unlock" group to simplify fetching the
ioctx_table pointer in ioctx_add_table and kill_ioctx, because it
is protected by the ioctx_lock.
And in the exit_aio(), there are no other users manipulating ioctx_table
at this stage, so we can use rcu_access_pointer directly.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |   42 ++++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..d2bce57 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -544,8 +544,8 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 	struct aio_ring *ring;
 
 	spin_lock(&mm->ioctx_lock);
-	rcu_read_lock();
-	table = rcu_dereference(mm->ioctx_table);
+	table = rcu_dereference_protected(mm->ioctx_table,
+					lockdep_is_held(&mm->ioctx_lock));
 
 	while (1) {
 		if (table)
@@ -553,7 +553,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				if (!table->table[i]) {
 					ctx->id = i;
 					table->table[i] = ctx;
-					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
 					ring = kmap_atomic(ctx->ring_pages[0]);
@@ -564,7 +563,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 
 		new_nr = (table ? table->nr : 1) * 4;
 
-		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		table = kzalloc(sizeof(*table) + sizeof(struct kioctx *) *
@@ -575,8 +573,8 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 		table->nr = new_nr;
 
 		spin_lock(&mm->ioctx_lock);
-		rcu_read_lock();
-		old = rcu_dereference(mm->ioctx_table);
+		old = rcu_dereference_protected(mm->ioctx_table,
+					lockdep_is_held(&mm->ioctx_lock));
 
 		if (!old) {
 			rcu_assign_pointer(mm->ioctx_table, table);
@@ -711,12 +709,11 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 		struct kioctx_table *table;
 
 		spin_lock(&mm->ioctx_lock);
-		rcu_read_lock();
-		table = rcu_dereference(mm->ioctx_table);
+		table = rcu_dereference_protected(mm->ioctx_table,
+					lockdep_is_held(&mm->ioctx_lock));
 
 		WARN_ON(ctx != table->table[ctx->id]);
 		table->table[ctx->id] = NULL;
-		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		/* percpu_ref_kill() will do the necessary call_rcu() */
@@ -765,27 +762,17 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
 void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx_table *table;
-	struct kioctx *ctx;
 	unsigned i = 0;
 
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
+	table = rcu_access_pointer(mm->ioctx_table);
+	if (!table)
+		return;
 
-		rcu_read_unlock();
+	while (i < table->nr) {
+		struct kioctx *ctx = table->table[i++];
 
+		if (!ctx)
+			continue;
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -798,6 +785,9 @@ void exit_aio(struct mm_struct *mm)
 
 		kill_ioctx(mm, ctx);
 	}
+
+	rcu_assign_pointer(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
-- 
1.7.7

