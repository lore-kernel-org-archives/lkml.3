Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3CTUP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:15:57 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38949 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3CTUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:52 -0400
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@surriel.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 7/7] ipc,sem: fine grained locking for semtimedop
Date: Wed, 20 Mar 2013 15:55:37 -0400
Message-Id: <1363809337-29718-8-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce finer grained locking for semtimedop, to handle the
common case of a program wanting to manipulate one semaphore
from an array with multiple semaphores.

If the call is a semop manipulating just one semaphore in
an array with multiple semaphores, only take the lock for
that semaphore itself.

If the call needs to manipulate multiple semaphores, or
another caller is in a transaction that manipulates multiple
semaphores, the sem_array lock is taken, as well as all the
locks for the individual semaphores.

On a 24 CPU system, performance numbers with the semop-multi
test with N threads and N semaphores, look like this:

	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
threads			patches		rwlock patches	v3 patches
10	610652		726325		1783589		2142206
20	341570		365699		1520453		1977878
30	288102		307037		1498167		2037995
40	290714		305955		1612665		2256484
50	288620		312890		1733453		2650292
60	289987		306043		1649360		2388008
70	291298		306347		1723167		2717486
80	290948		305662		1729545		2763582
90	290996		306680		1736021		2757524
100	292243		306700		1773700		3059159

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 ipc/sem.c |  152 ++++++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 105 insertions(+), 47 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 468e2c1..483eb6b 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -94,6 +94,7 @@
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head sem_pending; /* pending single-sop operations */
 };
 
@@ -137,7 +138,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
@@ -190,19 +190,83 @@ void __init sem_init (void)
 }
 
 /*
+ * If the sem_array contains just one semaphore, or if multiple
+ * semops are performed in one syscall, or if there are complex
+ * operations pending, the whole sem_array is locked.
+ * If one semop is performed on an array with multiple semaphores,
+ * get a shared lock on the array, and lock the individual semaphore.
+ *
+ * Carefully guard against sma->complex_count changing between zero
+ * and non-zero while we are spinning for the lock. The value of
+ * sma->complex_count cannot change while we are holding the lock,
+ * so sem_unlock should be fine.
+ */
+static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
+			      int nsops)
+{
+	int locknum;
+	if (nsops == 1 && !sma->complex_count) {
+		struct sem *sem = sma->sem_base + sops->sem_num;
+
+		/* Lock just the semaphore we are interested in. */
+		spin_lock(&sem->lock);
+
+		/*
+		 * If sma->complex_count was set while we were spinning,
+		 * we may need to look at things we did not lock here.
+		 */
+		if (unlikely(sma->complex_count)) {
+			spin_unlock(&sma->sem_perm.lock);
+			goto lock_all;
+		}
+		locknum = sops->sem_num;
+	} else {
+		int i;
+		/* Lock the sem_array, and all the semaphore locks */
+ lock_all:
+		spin_lock(&sma->sem_perm.lock);
+		for (i = 0; i < sma->sem_nsems; i++) {
+			struct sem *sem = sma->sem_base + i;
+			spin_lock(&sem->lock);
+		}
+		locknum = -1;
+	}
+	return locknum;
+}
+
+static inline void sem_unlock(struct sem_array *sma, int locknum)
+{
+	if (locknum == -1) {
+		int i;
+		for (i = 0; i < sma->sem_nsems; i++) {
+			struct sem *sem = sma->sem_base + i;
+			spin_unlock(&sem->lock);
+		}
+		spin_unlock(&sma->sem_perm.lock);
+	} else {
+		struct sem *sem = sma->sem_base + locknum;
+		spin_unlock(&sem->lock);
+	}
+	rcu_read_unlock();
+}
+
+/*
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns,
+			int id, struct sembuf *sops, int nsops, int *locknum)
 {
 	struct kern_ipc_perm *ipcp;
+	struct sem_array *sma;
 
 	rcu_read_lock();
 	ipcp = ipc_obtain_object(&sem_ids(ns), id);
 	if (IS_ERR(ipcp))
 		goto err1;
 
-	spin_lock(&ipcp->lock);
+	sma = container_of(ipcp, struct sem_array, sem_perm);
+	*locknum = sem_lock(sma, sops, nsops);
 
 	/* ipc_rmid() may have already freed the ID while sem_lock
 	 * was spinning: verify that the structure is still valid
@@ -210,9 +274,9 @@ static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id
 	if (ipcp->deleted)
 		goto err0;
 
-	return container_of(ipcp, struct sem_array, sem_perm);
+	return sma;
 err0:
-	spin_unlock(&ipcp->lock);
+	sem_unlock(sma, *locknum);
 err1:
 	rcu_read_unlock();
 	return ERR_PTR(-EINVAL);
@@ -228,17 +292,6 @@ static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
-static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return ERR_CAST(ipcp);
-
-	return container_of(ipcp, struct sem_array, sem_perm);
-}
-
 static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns,
 							int id)
 {
@@ -252,21 +305,21 @@ static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns
 
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
+	rcu_read_lock();
+	sem_lock(sma, NULL, -1);
 	ipc_rcu_putref(sma);
 }
 
 static inline void sem_getref_and_unlock(struct sem_array *sma)
 {
 	ipc_rcu_getref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_unlock(sma, -1);
 }
 
 static inline void sem_putref(struct sem_array *sma)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
-	ipc_rcu_putref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_lock_and_putref(sma);
+	sem_unlock(sma, -1);
 }
 
 /*
@@ -274,9 +327,9 @@ static inline void sem_putref(struct sem_array *sma)
  */
 static inline void sem_getref(struct sem_array *sma)
 {
-	spin_lock(&(sma)->sem_perm.lock);
+	sem_lock(sma, NULL, -1);
 	ipc_rcu_getref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_unlock(sma, -1);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -369,15 +422,18 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sma->sem_base = (struct sem *) &sma[1];
 
-	for (i = 0; i < nsems; i++)
+	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+		spin_lock_init(&sma->sem_base[i].lock);
+		spin_lock(&sma->sem_base[i].lock);
+	}
 
 	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 
 	return sma->sem_perm.id;
 }
@@ -816,7 +872,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 
 	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
@@ -990,16 +1046,16 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma);
+				sem_unlock(sma, -1);
 				err = -EIDRM;
 				goto out_free;
 			}
 		}
 
-		spin_lock(&sma->sem_perm.lock);
+		sem_lock(sma, NULL, -1);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		err = 0;
 		if(copy_to_user(array, sem_io, nsems*sizeof(ushort)))
 			err = -EFAULT;
@@ -1036,7 +1092,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma);
+			sem_unlock(sma, -1);
 			err = -EIDRM;
 			goto out_free;
 		}
@@ -1061,7 +1117,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	if(semnum < 0 || semnum >= nsems)
 		goto out_unlock;
 
-	spin_lock(&sma->sem_perm.lock);
+	sem_lock(sma, NULL, -1);
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1101,7 +1157,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1169,11 +1225,11 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 
 	switch(cmd){
 	case IPC_RMID:
-		ipc_lock_object(&sma->sem_perm);
+		sem_lock(sma, NULL, -1);
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipc_lock_object(&sma->sem_perm);
+		sem_lock(sma, NULL, -1);
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
 			goto out_unlock;
@@ -1186,7 +1242,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out_up:
 	up_write(&sem_ids(ns).rw_mutex);
 	return err;
@@ -1343,7 +1399,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	/* step 3: Acquire the lock on semaphore array */
 	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1371,7 +1427,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 success:
 	spin_unlock(&ulp->lock);
 	rcu_read_lock();
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out:
 	return un;
 }
@@ -1411,7 +1467,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sembuf fast_sops[SEMOPM_FAST];
 	struct sembuf* sops = fast_sops, *sop;
 	struct sem_undo *un;
-	int undos = 0, alter = 0, max;
+	int undos = 0, alter = 0, max, locknum;
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
@@ -1501,7 +1557,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
-	ipc_lock_object(&sma->sem_perm);
+	locknum = sem_lock(sma, sops, nsops);
 	if (un) {
 		if (un->semid == -1) {
 			rcu_read_unlock();
@@ -1558,7 +1614,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
-	sem_unlock(sma);
+	sem_unlock(sma, locknum);
 
 	if (timeout)
 		jiffies_left = schedule_timeout(jiffies_left);
@@ -1580,7 +1636,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		goto out_free;
 	}
 
-	sma = sem_obtain_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
@@ -1619,7 +1675,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
-	sem_unlock(sma);
+	sem_unlock(sma, locknum);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1693,12 +1749,14 @@ void exit_sem(struct task_struct *tsk)
 			semid = -1;
 		 else
 			semid = un->semid;
-		rcu_read_unlock();
 
-		if (semid == -1)
+		if (semid == -1) {
+			rcu_read_unlock();
 			break;
+		}
 
-		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
+		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);
+		sem_lock(sma, NULL, -1);
 
 		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (IS_ERR(sma))
@@ -1709,7 +1767,7 @@ void exit_sem(struct task_struct *tsk)
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
 			 */
-			sem_unlock(sma);
+			sem_unlock(sma, -1);
 			continue;
 		}
 
@@ -1749,7 +1807,7 @@ void exit_sem(struct task_struct *tsk)
 		/* maybe some queued-up processes were waiting for this */
 		INIT_LIST_HEAD(&tasks);
 		do_smart_update(sma, NULL, 0, 1, &tasks);
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		wake_up_sem_queue_do(&tasks);
 
 		kfree_rcu(un, rcu);
-- 
1.7.7.6

