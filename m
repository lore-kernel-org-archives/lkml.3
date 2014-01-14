Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaANTJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:09:15 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:45377 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaANTHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:23 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
Date: Tue, 14 Jan 2014 14:06:53 -0500
Message-Id: <1389726414-30990-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not really feasible to do deadlock detection with FL_FILE_PVT
locks since they aren't owned by a single task, per-se. Deadlock
detection also tends to be rather expensive so just skip it for
these sorts of locks.

Also, add a FIXME comment about adding more limited deadlock detection
that just applies to ro -> rw upgrades, per Andy's request.

Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index f8cd6d7..8c5bc07 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -564,7 +564,7 @@ static void __locks_insert_block(struct file_lock *blocker,
 	BUG_ON(!list_empty(&waiter->fl_block));
 	waiter->fl_next = blocker;
 	list_add_tail(&waiter->fl_block, &blocker->fl_block);
-	if (IS_POSIX(blocker))
+	if (IS_POSIX(blocker) && !IS_FILE_PVT(blocker))
 		locks_insert_global_blocked(waiter);
 }
 
@@ -757,8 +757,16 @@ EXPORT_SYMBOL(posix_test_lock);
  * Note: the above assumption may not be true when handling lock
  * requests from a broken NFS client. It may also fail in the presence
  * of tasks (such as posix threads) sharing the same open file table.
- *
  * To handle those cases, we just bail out after a few iterations.
+ *
+ * For FL_FILE_PVT locks, the owner is the filp, not the files_struct.
+ * Because the owner is not even nominally tied to a thread of
+ * execution, the deadlock detection below can't reasonably work well. Just
+ * skip it for those.
+ *
+ * In principle, we could do a more limited deadlock detection on FL_FILE_PVT
+ * locks that just checks for the case where two tasks are attempting to
+ * upgrade from read to write locks on the same inode.
  */
 
 #define MAX_DEADLK_ITERATIONS 10
@@ -781,6 +789,13 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
 {
 	int i = 0;
 
+	/*
+	 * This deadlock detector can't reasonably detect deadlocks with
+	 * FL_FILE_PVT locks, since they aren't owned by a process, per-se.
+	 */
+	if (IS_FILE_PVT(caller_fl))
+		return 0;
+
 	while ((block_fl = what_owner_is_waiting_for(block_fl))) {
 		if (i++ > MAX_DEADLK_ITERATIONS)
 			return 0;
-- 
1.8.4.2

