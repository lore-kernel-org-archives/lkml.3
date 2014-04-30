Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbaD3OQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758872AbaD3OQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:16:48 -0400
Date: Wed, 30 Apr 2014 16:16:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] aio: kill the misleading rcu read locks in
	ioctx_add_table() and kill_ioctx()
Message-ID: <20140430141636.GC18539@redhat.com>
References: <20140429183915.GA32513@redhat.com> <20140429184004.GB32521@redhat.com> <20140429204217.GO14608@kvack.org> <20140429212222.GA28959@kvack.org> <20140430141552.GA18539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430141552.GA18539@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
---
 fs/aio.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3526c2b..a415870 100644
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
1.5.5.1


