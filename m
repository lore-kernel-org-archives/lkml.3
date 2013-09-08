Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3IHOKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 10:10:54 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:55689 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3IHOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 10:10:52 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: bcrl@kvack.org
Cc: viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] aio: rcu_read_lock protection for new rcu_dereference calls
Date: Sun,  8 Sep 2013 18:10:43 +0400
Message-Id: <1378649444-28054-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "aio: fix rcu sparse warnings introduced by ioctx table lookup patch"
(77d30b14d24e557f89c41980011d72428514d729 in linux-next.git) introduced a
couple of new rcu_dereference calls which are not protected by rcu_read_lock
and result in following warnings during syscall fuzzing(trinity):

[  471.646379] ===============================
[  471.649727] [ INFO: suspicious RCU usage. ]
[  471.653919] 3.11.0-next-20130906+ #496 Not tainted
[  471.657792] -------------------------------
[  471.661235] fs/aio.c:503 suspicious rcu_dereference_check() usage!
[  471.665968]
[  471.665968] other info that might help us debug this:
[  471.665968]
[  471.672141]
[  471.672141] rcu_scheduler_active = 1, debug_locks = 1
[  471.677549] 1 lock held by trinity-child0/3774:
[  471.681675]  #0:  (&(&mm->ioctx_lock)->rlock){+.+...}, at: [<c119ba1a>] SyS_io_setup+0x63a/0xc70
[  471.688721]
[  471.688721] stack backtrace:
[  471.692488] CPU: 1 PID: 3774 Comm: trinity-child0 Not tainted 3.11.0-next-20130906+ #496
[  471.698437] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  471.703151]  00000000 00000000 c58bbf30 c18a814b de2234c0 c58bbf58 c10a4ec6 c1b0d824
[  471.709544]  c1b0f60e 00000001 00000001 c1af61b0 00000000 cb670ac0 c3aca000 c58bbfac
[  471.716251]  c119bc7c 00000002 00000001 00000000 c119b8dd 00000000 c10cf684 c58bbfb4
[  471.722902] Call Trace:
[  471.724859]  [<c18a814b>] dump_stack+0x4b/0x66
[  471.728772]  [<c10a4ec6>] lockdep_rcu_suspicious+0xc6/0x100
[  471.733716]  [<c119bc7c>] SyS_io_setup+0x89c/0xc70
[  471.737806]  [<c119b8dd>] ? SyS_io_setup+0x4fd/0xc70
[  471.741689]  [<c10cf684>] ? __audit_syscall_entry+0x94/0xe0
[  471.746080]  [<c18b1fcc>] syscall_call+0x7/0xb
[  471.749723]  [<c1080000>] ? task_fork_fair+0x240/0x260

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 fs/aio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 9b8f9fa..2fb9160 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -470,6 +470,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 	struct aio_ring *ring;
 
 	spin_lock(&mm->ioctx_lock);
+	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
 
 	while (1) {
@@ -478,6 +479,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				if (!table->table[i]) {
 					ctx->id = i;
 					table->table[i] = ctx;
+					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
 					ring = kmap_atomic(ctx->ring_pages[0]);
@@ -488,6 +490,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 
 		new_nr = (table ? table->nr : 1) * 4;
 
+		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		table = kzalloc(sizeof(*table) + sizeof(struct kioctx *) *
@@ -498,6 +501,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 		table->nr = new_nr;
 
 		spin_lock(&mm->ioctx_lock);
+		rcu_read_lock();
 		old = rcu_dereference(mm->ioctx_table);
 
 		if (!old) {
@@ -622,10 +626,12 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 		struct kioctx_table *table;
 
 		spin_lock(&mm->ioctx_lock);
+		rcu_read_lock();
 		table = rcu_dereference(mm->ioctx_table);
 
 		WARN_ON(ctx != table->table[ctx->id]);
 		table->table[ctx->id] = NULL;
+		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		/* percpu_ref_kill() will do the necessary call_rcu() */
-- 
1.8.4

