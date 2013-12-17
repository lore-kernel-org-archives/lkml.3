Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3LQTEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:04:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab3LQTD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:03:59 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] ipc: introduce ipc_valid_object() helper to sort out IPC_RMID races
Date: Tue, 17 Dec 2013 17:03:41 -0200
Message-Id: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the locking semantics for the SysV IPC API got improved, a couple of
IPC_RMID race windows were opened because we ended up dropping the
'kern_ipc_perm.deleted' check performed way down in ipc_lock().
The spotted races got sorted out by re-introducing the old test within
the racy critical sections.

This patch introduces ipc_valid_object() to consolidate the way we cope with
IPC_RMID races by using the same abstraction across the API implementation.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
 ipc/msg.c  |  7 ++++---
 ipc/sem.c  |  8 ++++----
 ipc/shm.c  | 16 ++++++++--------
 ipc/util.h | 13 +++++++++++++
 4 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 558aa91..8983ea5 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -696,7 +696,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 			goto out_unlock0;
 
 		/* raced with RMID? */
-		if (msq->q_perm.deleted) {
+		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
 			goto out_unlock0;
 		}
@@ -731,7 +731,8 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		ipc_lock_object(&msq->q_perm);
 
 		ipc_rcu_putref(msq, ipc_rcu_free);
-		if (msq->q_perm.deleted) {
+		/* raced with RMID? */
+		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
 			goto out_unlock0;
 		}
@@ -909,7 +910,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		ipc_lock_object(&msq->q_perm);
 
 		/* raced with RMID? */
-		if (msq->q_perm.deleted) {
+		if (!ipc_valid_object(&msq->q_perm)) {
 			msg = ERR_PTR(-EIDRM);
 			goto out_unlock0;
 		}
diff --git a/ipc/sem.c b/ipc/sem.c
index db9d241..f4fad32 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1282,7 +1282,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 
 	sem_lock(sma, NULL, -1);
 
-	if (sma->sem_perm.deleted) {
+	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
 		return -EIDRM;
@@ -1342,7 +1342,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 
 		sem_lock(sma, NULL, -1);
-		if (sma->sem_perm.deleted) {
+		if (!ipc_valid_object(&sma->sem_perm)) {
 			err = -EIDRM;
 			goto out_unlock;
 		}
@@ -1435,7 +1435,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		goto out_rcu_wakeup;
 
 	sem_lock(sma, NULL, -1);
-	if (sma->sem_perm.deleted) {
+	if (!ipc_valid_object(&sma->sem_perm)) {
 		err = -EIDRM;
 		goto out_unlock;
 	}
@@ -2068,7 +2068,7 @@ void exit_sem(struct task_struct *tsk)
 
 		sem_lock(sma, NULL, -1);
 		/* exit_sem raced with IPC_RMID, nothing to do */
-		if (sma->sem_perm.deleted) {
+		if (!ipc_valid_object(&sma->sem_perm)) {
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
 			continue;
diff --git a/ipc/shm.c b/ipc/shm.c
index 7a51443..1bc68f1 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -975,6 +975,13 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			goto out_unlock1;
 
 		ipc_lock_object(&shp->shm_perm);
+
+		/* check if shm_destroy() is tearing down shp */
+		if (!ipc_valid_object(&shp->shm_perm)) {
+			err = -EIDRM;
+			goto out_unlock0;
+		}
+
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
@@ -989,13 +996,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		}
 
 		shm_file = shp->shm_file;
-
-		/* check if shm_destroy() is tearing down shp */
-		if (shm_file == NULL) {
-			err = -EIDRM;
-			goto out_unlock0;
-		}
-
 		if (is_file_hugepages(shm_file))
 			goto out_unlock0;
 
@@ -1116,7 +1116,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	ipc_lock_object(&shp->shm_perm);
 
 	/* check if shm_destroy() is tearing down shp */
-	if (shp->shm_file == NULL) {
+	if (!ipc_valid_object(&shp->shm_perm)) {
 		ipc_unlock_object(&shp->shm_perm);
 		err = -EIDRM;
 		goto out_unlock;
diff --git a/ipc/util.h b/ipc/util.h
index 59d78aa..3a5f0d0 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -185,6 +185,19 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
 	rcu_read_unlock();
 }
 
+/*
+ * ipc_valid_object() - helper to sort out IPC_RMID races for codepaths
+ * where the respective ipc_ids.rwsem is not being held down.
+ * Checks whether the ipc object is still around or if it's gone already, as
+ * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
+ * Needs to be called with kern_ipc_perm.lock held.
+ */
+static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
+{
+	assert_spin_locked(&perm->lock);
+	return perm->deleted == 0;
+}
+
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
-- 
1.8.3.1

