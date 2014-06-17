Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbaFQR3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:29:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46255 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555AbaFQR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:45 -0400
From: Jack Miller <millerjo@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com
Subject: [PATCH 2/3] shm: Allow exit_shm in parallel if only marking orphans
Date: Tue, 17 Jun 2014 12:27:46 -0500
Message-Id: <1403026067-14272-3-git-send-email-millerjo@us.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061717-1344-0000-0000-00000242A7C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If shm_rmid_force (the default state) is not set then the shmids are only
marked as orphaned and does not require any add, delete, or locking of the tree
structure.

Seperate the sysctl on and off case, and only obtain the read lock. The newly
added list head can be deleted under the read lock because we are only called
with current and will only change the semids allocated by this task and not
manipulate the list.

This commit assumes that up_read includes a sufficient memory barrier for the
writes to be seen my others that later obtain a write lock.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
---
 ipc/shm.c | 67 +++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 9790a0e..0dde176 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -269,32 +269,6 @@ static void shm_close(struct vm_area_struct *vma)
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
-static void shm_mark_orphan(struct shmid_kernel *shp, struct ipc_namespace *ns)
-{
-	if (WARN_ON(shp->shm_creator != current)) /* Remove me when it works */
-		return;
-
-	/*
-	 * Mark it as orphaned to destroy the segment when
-	 * kernel.shm_rmid_forced is changed.
-	 * It is noop if the following shm_may_destroy() returns true.
-	 */
-	shp->shm_creator = NULL;
-
-	/*
-	 * Don't even try to destroy it.  If shm_rmid_forced=0 and IPC_RMID
-	 * is not set, it shouldn't be deleted here.
-	 */
-	if (!ns->shm_rmid_forced)
-		return;
-
-	if (shm_may_destroy(ns, shp)) {
-		shm_lock_by_ptr(shp);
-		shm_destroy(ns, shp);
-	}
-}
-
-/* Called with ns->shm_ids(ns).rwsem locked */
 static int shm_try_destroy_orphaned(int id, void *p, void *data)
 {
 	struct ipc_namespace *ns = data;
@@ -325,20 +299,49 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 	up_write(&shm_ids(ns).rwsem);
 }
 
-
+/* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 	struct shmid_kernel *shp, *n;
 
-	if (shm_ids(ns).in_use == 0)
+	if (list_empty(&task->sysvshm.shm_clist))
+		return;
+
+	/*
+	 * If kernel.shm_rmid_forced is not set then only keep track of
+	 * which shmids are orphaned, so that a later set of the sysctl
+	 * can clean them up.
+	 */
+	if (!ns->shm_rmid_forced) {
+		down_read(&shm_ids(ns).rwsem);
+		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
+			shp->shm_creator = NULL;
+		/*
+		 * Only under read lock but we are only called on current
+		 * so no entry on the list will be shared.
+		 */
+		list_del(&task->sysvshm.shm_clist);
+		up_read(&shm_ids(ns).rwsem);
 		return;
+	}
 
-	/* Destroy all already created segments, but not mapped yet */
+	/*
+	 * Destroy all already created segments, that were not yet mapped,
+	 * and mark any mapped as orphan to cover the sysctl toggling.
+	 * Destroy is skipped if shm_may_destroy() returns false.
+	 */
 	down_write(&shm_ids(ns).rwsem);
-	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist)
-		shm_mark_orphan(shp, ns);
-	/* remove the list head from any segments still attached */
+	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
+		shp->shm_creator = NULL;
+
+		if (shm_may_destroy(ns, shp)) {
+			shm_lock_by_ptr(shp);
+			shm_destroy(ns, shp);
+		}
+	}
+
+	/* Remove the list head from any segments still attached. */
 	list_del(&task->sysvshm.shm_clist);
 	up_write(&shm_ids(ns).rwsem);
 }
-- 
1.9.1

