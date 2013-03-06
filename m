Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3CFWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:16:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab3CFWQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:16:56 -0500
Date: Wed, 6 Mar 2013 17:15:46 -0500
From: Rik van Riel <riel@redhat.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, hhuang@redhat.com
Subject: [PATCH v2 7/4] ipc: fine grained locking for semtimedop
Message-ID: <20130306171546.63471bc0@cuia.bos.redhat.com>
In-Reply-To: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce finer grained locking for semtimedop, to handle the
common case of a program wanting to manipulate one semaphore
from an array with multiple semaphores.

Each semaphore array has a read/write lock. If something
complex is going on (manipulation of the array, of multiple
semaphores in one syscall, etc), the lock is taken in exclusive
mode.

If the call is a semop manipulating just one semaphore in
an array with multiple semaphores, the read/write lock for
the semaphore array is taken in shared (read) mode, and the
individual semaphore's lock is taken.

On a 24 CPU system, performance numbers with the semop-multi
test with N threads and N semaphores, look like this:

	vanilla		Davidlohr's	Davidlohr's +
threads			patches		rwlock patches
10	610652		726325		1783589
20	341570		365699		1520453
30	288102		307037		1498167
40	290714		305955		1612665
50	288620		312890		1733453
60	289987		306043		1649360
70	291298		306347		1723167
80	290948		305662		1729545
90	290996		306680		1736021
100	292243		306700		1773700

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index d92ba32..3ab9385 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -94,6 +94,7 @@
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head sem_pending; /* pending single-sop operations */
 };
 
@@ -138,7 +139,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
@@ -191,19 +191,75 @@ void __init sem_init (void)
 }
 
 /*
+ * If the sem_array contains just one semaphore, or if multiple
+ * semops are performed in one syscall, or if there are complex
+ * operations pending, the whole sem_array is locked exclusively.
+ * If one semop is performed on an array with multiple semaphores,
+ * get a shared lock on the array, and lock the individual semaphore.
+ *
+ * Carefully guard against sma->complex_count changing between zero
+ * and non-zero while we are spinning for the lock. The value of
+ * sma->complex_count cannot change while we are holding the lock,
+ * so sem_unlock should be fine.
+ */
+static inline void sem_lock(struct sem_array *sma, struct sembuf *sops,
+			      int nsops)
+{
+ again:
+	if (nsops == 1 && sma->sem_nsems > 1 && !sma->complex_count) {
+		struct sem *sem = sma->sem_base + sops->sem_num;
+		/* Shared access to the sem_array. */
+		read_lock(&sma->sem_perm.lock);
+
+		/* Was sma->complex_count set while we were spinning? */
+		if (unlikely(sma->complex_count)) {
+			read_unlock(&sma->sem_perm.lock);
+			goto again;
+		}
+
+		/* Lock the one semaphore we are interested in. */
+		spin_lock(&sem->lock);
+	} else {
+		/* Lock the sem_array for exclusive access. */
+		write_lock(&sma->sem_perm.lock);
+
+		/* Was sma->complex_count reset while we were spinning? */
+		if (unlikely(!sma->complex_count && nsops == 1 &&
+						sma->sem_nsems > 1)) {
+			write_unlock(&sma->sem_perm.lock);
+			goto again;
+		}
+	}
+}
+
+static inline void sem_unlock(struct sem_array *sma, struct sembuf *sops,
+			      int nsops)
+{
+	if (nsops == 1 && sma->sem_nsems > 1 && !sma->complex_count) {
+		struct sem *sem = sma->sem_base + sops->sem_num;
+		spin_unlock(&sem->lock);
+		read_unlock(&sma->sem_perm.lock);
+	} else
+		write_unlock(&sma->sem_perm.lock);
+}
+
+/*
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns,
+				int id, struct sembuf *sops, int nsops)
 {
 	struct kern_ipc_perm *ipcp;
+	struct sem_array *sma;
 
 	rcu_read_lock();
 	ipcp = ipc_obtain_object(&sem_ids(ns), id);
 	if (IS_ERR(ipcp))
 		goto err1;
 
-	write_lock(&ipcp->lock);
+	sma = container_of(ipcp, struct sem_array, sem_perm);
+	sem_lock(sma, sops, nsops);
 
 	/* ipc_rmid() may have already freed the ID while write_lock
 	 * was spinning: verify that the structure is still valid
@@ -211,9 +267,9 @@ static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id
 	if (ipcp->deleted)
 		goto err0;
 
-	return container_of(ipcp, struct sem_array, sem_perm);
+	return sma;
 err0:
-	write_unlock(&ipcp->lock);
+	sem_unlock(sma, sops, nsops);
 err1:
 	rcu_read_unlock();
 	return ERR_PTR(-EINVAL);
@@ -370,15 +426,17 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sma->sem_base = (struct sem *) &sma[1];
 
-	for (i = 0; i < nsems; i++)
+	for (i = 0; i < nsems; i++) {
+		spin_lock_init(&sma->sem_base[i].lock);
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+	}
 
 	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
-	sem_unlock(sma);
+	sem_unlock(sma, NULL, -1);
 
 	return sma->sem_perm.id;
 }
@@ -811,7 +869,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
-	sem_unlock(sma);
+	sem_unlock(sma, NULL, -1);
 
 	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
@@ -985,7 +1043,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma);
+				sem_unlock(sma, NULL, -1);
 				err = -EIDRM;
 				goto out_free;
 			}
@@ -994,7 +1052,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		write_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
-		sem_unlock(sma);
+		sem_unlock(sma, NULL, -1);
 		err = 0;
 		if(copy_to_user(array, sem_io, nsems*sizeof(ushort)))
 			err = -EFAULT;
@@ -1031,7 +1089,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma);
+			sem_unlock(sma, NULL, -1);
 			err = -EIDRM;
 			goto out_free;
 		}
@@ -1094,7 +1152,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, NULL, -1);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1179,7 +1237,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, NULL, -1);
 out_up:
 	up_write(&sem_ids(ns).rw_mutex);
 	return err;
@@ -1336,7 +1394,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	/* step 3: Acquire the lock on semaphore array */
 	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
-		sem_unlock(sma);
+		sem_unlock(sma, NULL, -1);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1363,7 +1421,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 success:
 	spin_unlock(&ulp->lock);
 	rcu_read_lock();
-	sem_unlock(sma);
+	sem_unlock(sma, NULL, -1);
 out:
 	return un;
 }
@@ -1493,7 +1551,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
-	ipc_lock_object(&sma->sem_perm);
+	sem_lock(sma, sops, nsops);
 	if (un) {
 		if (un->semid == -1) {
 			rcu_read_unlock();
@@ -1550,7 +1608,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	queue.sleeper = current;
 
 sleep_again:
-	sem_unlock(sma);
+	sem_unlock(sma, sops, nsops);
 	current->state = TASK_INTERRUPTIBLE;
 
 	if (timeout)
@@ -1573,7 +1631,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		goto out_free;
 	}
 
-	sma = sem_obtain_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid, sops, nsops);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
@@ -1612,7 +1670,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
-	sem_unlock(sma);
+	sem_unlock(sma, sops, nsops);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1702,7 +1760,7 @@ void exit_sem(struct task_struct *tsk)
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
 			 */
-			sem_unlock(sma);
+			sem_unlock(sma, NULL, -1);
 			continue;
 		}
 
@@ -1741,7 +1799,7 @@ void exit_sem(struct task_struct *tsk)
 		/* maybe some queued-up processes were waiting for this */
 		INIT_LIST_HEAD(&tasks);
 		do_smart_update(sma, NULL, 0, 1, &tasks);
-		sem_unlock(sma);
+		sem_unlock(sma, NULL, -1);
 		wake_up_sem_queue_do(&tasks);
 
 		kfree_rcu(un, rcu);

