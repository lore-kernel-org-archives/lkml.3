Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaAIOWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:22:34 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54991 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaAIOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
Date: Thu,  9 Jan 2014 09:19:46 -0500
Message-Id: <1389277187-18211-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not really feasible to do deadlock detection with FL_FILE_PVT
locks since they aren't owned by a single task, per-se. Deadlock
detection also tends to be rather expensive so just skip it for
these sorts of locks.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index f8cd6d7..94bcca6 100644
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
 
@@ -757,8 +757,12 @@ EXPORT_SYMBOL(posix_test_lock);
  * Note: the above assumption may not be true when handling lock
  * requests from a broken NFS client. It may also fail in the presence
  * of tasks (such as posix threads) sharing the same open file table.
- *
  * To handle those cases, we just bail out after a few iterations.
+ *
+ * For FL_FILE_PVT locks, the owner is the filp, not the files_struct.
+ * Because the owner is not even nominally tied to a thread of
+ * execution, deadlock detection can't reasonably work well. Just skip
+ * it for those.
  */
 
 #define MAX_DEADLK_ITERATIONS 10
@@ -781,6 +785,10 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
 {
 	int i = 0;
 
+	/* Can't reasonably detect deadlocks with FL_FILE_PVT locks */
+	if (IS_FILE_PVT(caller_fl))
+		return 0;
+
 	while ((block_fl = what_owner_is_waiting_for(block_fl))) {
 		if (i++ > MAX_DEADLK_ITERATIONS)
 			return 0;
-- 
1.8.4.2

