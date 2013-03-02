Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3CBAQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:16:52 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44169 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3CBAQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:16:48 -0500
Message-ID: <1362183404.3420.25.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 2/2] ipc: semaphores: do not hold ipc lock more than
 necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Cc: "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 01 Mar 2013 16:16:44 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of holding the ipc lock for permissions and security
checks, among others, only acquire it when necessary.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/sem.c | 94 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 28 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 58d31f1..b74a6f7 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -204,6 +204,16 @@ static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
+static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&sem_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
+	return container_of(ipcp, struct sem_array, sem_perm);
+}
+
 static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
 						int id)
 {
@@ -215,6 +225,17 @@ static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
+static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns,
+							int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&sem_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
+	return container_of(ipcp, struct sem_array, sem_perm);
+}
+
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
 	ipc_lock_by_ptr(&sma->sem_perm);
@@ -234,6 +255,16 @@ static inline void sem_putref(struct sem_array *sma)
 	ipc_unlock(&(sma)->sem_perm);
 }
 
+/*
+ * Call inside the rcu read section.
+ */
+static inline void sem_getref(struct sem_array *sma)
+{
+	spin_lock(&(sma)->sem_perm.lock);
+	ipc_rcu_getref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -842,18 +873,19 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 	case SEM_STAT:
 	{
 		struct semid64_ds tbuf;
-		int id;
+		int id = 0;
+
+		memset(&tbuf, 0, sizeof(tbuf));
 
 		if (cmd == SEM_STAT) {
-			sma = sem_lock(ns, semid);
+			sma = sem_obtain_object(ns, semid);
 			if (IS_ERR(sma))
 				return PTR_ERR(sma);
 			id = sma->sem_perm.id;
 		} else {
-			sma = sem_lock_check(ns, semid);
+			sma = sem_obtain_object_check(ns, semid);
 			if (IS_ERR(sma))
 				return PTR_ERR(sma);
-			id = 0;
 		}
 
 		err = -EACCES;
@@ -864,13 +896,11 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
 		tbuf.sem_ctime  = sma->sem_ctime;
 		tbuf.sem_nsems  = sma->sem_nsems;
-		sem_unlock(sma);
+		rcu_read_unlock();
 		if (copy_semid_to_user (arg.buf, &tbuf, version))
 			return -EFAULT;
 		return id;
@@ -879,7 +909,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		return -EINVAL;
 	}
 out_unlock:
-	sem_unlock(sma);
+	rcu_read_unlock();
 	return err;
 }
 
@@ -894,11 +924,12 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	int nsems;
 	struct list_head tasks;
 
-	sma = sem_lock_check(ns, semid);
+	INIT_LIST_HEAD(&tasks);
+
+	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
-	INIT_LIST_HEAD(&tasks);
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
@@ -918,7 +949,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 
 		if(nsems > SEMMSL_FAST) {
-			sem_getref_and_unlock(sma);
+			sem_getref(sma);
 
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
@@ -934,6 +965,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			}
 		}
 
+		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
 		sem_unlock(sma);
@@ -947,7 +979,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 		struct sem_undo *un;
 
-		sem_getref_and_unlock(sma);
+		ipc_rcu_getref(sma);
+		rcu_read_unlock();
 
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
@@ -997,6 +1030,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	if(semnum < 0 || semnum >= nsems)
 		goto out_unlock;
 
+	spin_lock(&sma->sem_perm.lock);
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1101,9 +1135,11 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 
 	switch(cmd){
 	case IPC_RMID:
+		spin_lock(&sma->sem_perm.lock);
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
+		spin_lock(&sma->sem_perm.lock);
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
 			goto out_unlock;
@@ -1252,12 +1288,13 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 
 	/* no undo structure around - allocate one. */
 	/* step 1: figure out the size of the semaphore array */
-	sma = sem_lock_check(ns, semid);
+	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma))
 		return ERR_CAST(sma);
 
 	nsems = sma->sem_nsems;
-	sem_getref_and_unlock(sma);
+	ipc_rcu_getref(sma);
+	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
@@ -1392,7 +1429,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	INIT_LIST_HEAD(&tasks);
 
-	sma = sem_lock_check(ns, semid);
+	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma)) {
 		if (un)
 			rcu_read_unlock();
@@ -1400,6 +1437,18 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		goto out_free;
 	}
 
+	error = -EFBIG;
+	if (max >= sma->sem_nsems)
+		goto out_unlock_free;
+
+	error = -EACCES;
+	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
+		goto out_unlock_free;
+
+	error = security_sem_semop(sma, sops, nsops, alter);
+	if (error)
+		goto out_unlock_free;
+
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
@@ -1408,6 +1457,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
+	spin_lock(&sma->sem_perm.lock);
 	if (un) {
 		if (un->semid == -1) {
 			rcu_read_unlock();
@@ -1425,18 +1475,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		}
 	}
 
-	error = -EFBIG;
-	if (max >= sma->sem_nsems)
-		goto out_unlock_free;
-
-	error = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
-		goto out_unlock_free;
-
-	error = security_sem_semop(sma, sops, nsops, alter);
-	if (error)
-		goto out_unlock_free;
-
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
@@ -1476,8 +1514,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	queue.sleeper = current;
 
 sleep_again:
-	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
+	current->state = TASK_INTERRUPTIBLE;
 
 	if (timeout)
 		jiffies_left = schedule_timeout(jiffies_left);
-- 
1.7.11.7




