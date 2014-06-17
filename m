Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903AbaFQR2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:28:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60270 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbaFQR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:44 -0400
From: Jack Miller <millerjo@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com
Subject: [PATCH 1/3] shm: Make exit_shm work proportional to task activity
Date: Tue, 17 Jun 2014 12:27:45 -0500
Message-Id: <1403026067-14272-2-git-send-email-millerjo@us.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061717-0928-0000-0000-000002C2C05E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_shm obtains the ipc_ns shm rwsem for write and holds it while
it walks every shared memory segment in the namespace.  Thus the
amount of work is related to the number of shm segments in the
namespace not the number of segments that might need to be cleaned.

In addition, this occurs after the task has been notified the
thread has exited, so the number of tasks waiting for the ns shm
rwsem can grow without bound until memory is exausted.

Add a list to the task struct of all shmids allocated by this task.
Init the list head in copy_process.  Use the ns->rwsem for locking.
Add segments after id is added, remove before removing from id.

On unshare of NEW_IPCNS orphan any ids as if the task had exited,
similar to handling of semaphore undo.

I chose a define for the init sequence since its a simple list init,
otherwise it would require a function call to avoid include loops
between the semaphore code and the task struct.  Converting the
list_del to list_del_init for the unshare cases would remove the
exit followed by init, but I left it blow up if not inited.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
---
 include/linux/sched.h |  2 ++
 include/linux/shm.h   | 16 +++++++++++++++-
 ipc/shm.c             | 22 +++++++++++-----------
 kernel/fork.c         |  6 ++++++
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 221b2bd..4833ecf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -33,6 +33,7 @@ struct sched_param {
 
 #include <linux/smp.h>
 #include <linux/sem.h>
+#include <linux/shm.h>
 #include <linux/signal.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
@@ -1344,6 +1345,7 @@ struct task_struct {
 #ifdef CONFIG_SYSVIPC
 /* ipc stuff */
 	struct sysv_sem sysvsem;
+	struct sysv_shm sysvshm;
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
diff --git a/include/linux/shm.h b/include/linux/shm.h
index 1e2cd2e..38a70a2 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_SHM_H_
 #define _LINUX_SHM_H_
 
+#include <linux/list.h>
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
 
@@ -21,6 +22,7 @@ struct shmid_kernel /* private to the kernel */
 
 	/* The task created the shm object.  NULL if the task is dead. */
 	struct task_struct	*shm_creator;
+	struct list_head	shm_clist;	/* list by creator */
 };
 
 /* shm_mode upper byte flags */
@@ -45,11 +47,20 @@ struct shmid_kernel /* private to the kernel */
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
 
 #ifdef CONFIG_SYSVIPC
+struct sysv_shm {
+	struct list_head shm_clist;
+};
+
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
 extern int is_file_shm_hugepages(struct file *file);
-extern void exit_shm(struct task_struct *task);
+void exit_shm(struct task_struct *task);
+#define shm_init_task(task) INIT_LIST_HEAD(&(task)->sysvshm.shm_clist)
 #else
+struct sysv_shm {
+	/* empty */
+};
+
 static inline long do_shmat(int shmid, char __user *shmaddr,
 			    int shmflg, unsigned long *addr,
 			    unsigned long shmlba)
@@ -63,6 +74,9 @@ static inline int is_file_shm_hugepages(struct file *file)
 static inline void exit_shm(struct task_struct *task)
 {
 }
+static inline void shm_init_task(struct task_struct *task)
+{
+}
 #endif
 
 #endif /* _LINUX_SHM_H_ */
diff --git a/ipc/shm.c b/ipc/shm.c
index 7645961..9790a0e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -178,6 +178,7 @@ static void shm_rcu_free(struct rcu_head *head)
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
+	list_del(&s->shm_clist);
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
@@ -268,14 +269,10 @@ static void shm_close(struct vm_area_struct *vma)
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
-static int shm_try_destroy_current(int id, void *p, void *data)
+static void shm_mark_orphan(struct shmid_kernel *shp, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *ns = data;
-	struct kern_ipc_perm *ipcp = p;
-	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
-
-	if (shp->shm_creator != current)
-		return 0;
+	if (WARN_ON(shp->shm_creator != current)) /* Remove me when it works */
+		return;
 
 	/*
 	 * Mark it as orphaned to destroy the segment when
@@ -289,13 +286,12 @@ static int shm_try_destroy_current(int id, void *p, void *data)
 	 * is not set, it shouldn't be deleted here.
 	 */
 	if (!ns->shm_rmid_forced)
-		return 0;
+		return;
 
 	if (shm_may_destroy(ns, shp)) {
 		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
 	}
-	return 0;
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
@@ -333,14 +329,17 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
+	struct shmid_kernel *shp, *n;
 
 	if (shm_ids(ns).in_use == 0)
 		return;
 
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rwsem);
-	if (shm_ids(ns).in_use)
-		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
+	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist)
+		shm_mark_orphan(shp, ns);
+	/* remove the list head from any segments still attached */
+	list_del(&task->sysvshm.shm_clist);
 	up_write(&shm_ids(ns).rwsem);
 }
 
@@ -557,6 +556,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26..5301efb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1328,6 +1328,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (retval)
 		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
+	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_audit;
@@ -1867,6 +1868,11 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 			 */
 			exit_sem(current);
 		}
+		if (unshare_flags & CLONE_NEWIPC) {
+			/* Orphan segments in old ns (see sem above). */
+			exit_shm(current);
+			shm_init_task(current);
+		}
 
 		if (new_nsproxy)
 			switch_task_namespaces(current, new_nsproxy);
-- 
1.9.1

