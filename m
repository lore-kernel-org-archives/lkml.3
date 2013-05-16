Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3EPBKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:10:39 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41922 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3EPBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:14 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 04/11] ipc: move locking out of ipcctl_pre_down_nolock
Date: Wed, 15 May 2013 18:08:03 -0700
Message-Id: <1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function currently acquires both the rw_mutex and the rcu lock on
successful lookups, leaving the callers to explicitly unlock them, creating
another two level locking situation.

Make the callers (including those that still use ipcctl_pre_down()) explicitly
lock and unlock the rwsem and rcu lock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c  | 24 +++++++++++++++++-------
 ipc/sem.c  | 27 ++++++++++++++++-----------
 ipc/shm.c  | 23 +++++++++++++++++------
 ipc/util.c | 21 ++++++---------------
 4 files changed, 56 insertions(+), 39 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 7a6f344..4eaeb08 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -409,31 +409,38 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 			return -EFAULT;
 	}
 
+	down_write(&msg_ids(ns).rw_mutex);
+	rcu_read_lock();
+
 	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
 			       &msqid64.msg_perm, msqid64.msg_qbytes);
-	if (IS_ERR(ipcp))
-		return PTR_ERR(ipcp);
+	if (IS_ERR(ipcp)) {
+		err = PTR_ERR(ipcp);
+		/* the ipc lock is not held upon failure */
+		goto out_unlock1;
+	}
 
 	msq = container_of(ipcp, struct msg_queue, q_perm);
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
-		goto out_unlock;
+		goto out_unlock0;
 
 	switch (cmd) {
 	case IPC_RMID:
+		/* freeque unlocks the ipc object and rcu */
 		freeque(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
-			goto out_unlock;
+			goto out_unlock0;
 		}
 
 		err = ipc_update_perm(&msqid64.msg_perm, ipcp);
 		if (err)
-			goto out_unlock;
+			goto out_unlock0;
 
 		msq->q_qbytes = msqid64.msg_qbytes;
 
@@ -450,8 +457,11 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 	default:
 		err = -EINVAL;
 	}
-out_unlock:
-	msg_unlock(msq);
+
+out_unlock0:
+	ipc_unlock_object(&msq->q_perm);
+out_unlock1:
+	rcu_read_unlock();
 out_up:
 	up_write(&msg_ids(ns).rw_mutex);
 	return err;
diff --git a/ipc/sem.c b/ipc/sem.c
index 7854fc8..f7d99f9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1274,39 +1274,44 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 			return -EFAULT;
 	}
 
+	down_write(&sem_ids(ns).rw_mutex);
+	rcu_read_lock();
+
 	ipcp = ipcctl_pre_down_nolock(ns, &sem_ids(ns), semid, cmd,
 				      &semid64.sem_perm, 0);
-	if (IS_ERR(ipcp))
-		return PTR_ERR(ipcp);
+	if (IS_ERR(ipcp)) {
+		err = PTR_ERR(ipcp);
+		/* the ipc lock is not held upon failure */
+		goto out_unlock1;
+	}
 
 	sma = container_of(ipcp, struct sem_array, sem_perm);
 
 	err = security_sem_semctl(sma, cmd);
-	if (err) {
-		rcu_read_unlock();
-		goto out_up;
-	}
+	if (err)
+		goto out_unlock1;
 
-	switch(cmd){
+	switch (cmd) {
 	case IPC_RMID:
 		sem_lock(sma, NULL, -1);
+		/* freeary unlocks the ipc object and rcu */
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
 		sem_lock(sma, NULL, -1);
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
-			goto out_unlock;
+			goto out_unlock0;
 		sma->sem_ctime = get_seconds();
 		break;
 	default:
-		rcu_read_unlock();
 		err = -EINVAL;
-		goto out_up;
+		goto out_unlock1;
 	}
 
-out_unlock:
+out_unlock0:
 	sem_unlock(sma, -1);
+out_unlock1:
 	rcu_read_unlock();
 out_up:
 	up_write(&sem_ids(ns).rw_mutex);
diff --git a/ipc/shm.c b/ipc/shm.c
index 1fd3d05f..078cc19 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -759,31 +759,42 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 			return -EFAULT;
 	}
 
+	down_write(&shm_ids(ns).rw_mutex);
+	rcu_read_lock();
+
 	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid, cmd,
 			       &shmid64.shm_perm, 0);
-	if (IS_ERR(ipcp))
-		return PTR_ERR(ipcp);
+	if (IS_ERR(ipcp)) {
+		err = PTR_ERR(ipcp);
+		/* the ipc lock is not held upon failure */
+		goto out_unlock1;
+	}
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
 	err = security_shm_shmctl(shp, cmd);
 	if (err)
-		goto out_unlock;
+		goto out_unlock0;
+
 	switch (cmd) {
 	case IPC_RMID:
+		/* do_shm_rmid unlocks the ipc object and rcu */
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
 		err = ipc_update_perm(&shmid64.shm_perm, ipcp);
 		if (err)
-			goto out_unlock;
+			goto out_unlock0;
 		shp->shm_ctim = get_seconds();
 		break;
 	default:
 		err = -EINVAL;
 	}
-out_unlock:
-	shm_unlock(shp);
+
+out_unlock0:
+	ipc_unlock_object(&shp->shm_perm);
+out_unlock1:
+	rcu_read_unlock();
 out_up:
 	up_write(&shm_ids(ns).rw_mutex);
 	return err;
diff --git a/ipc/util.c b/ipc/util.c
index 92f0242..a746abb 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -745,8 +745,10 @@ int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out)
  * It must be called without any lock held and
  *  - retrieves the ipc with the given id in the given table.
  *  - performs some audit and permission check, depending on the given cmd
- *  - returns the ipc with both ipc and rw_mutex locks held in case of success
+ *  - returns the ipc with the ipc lock held in case of success
  *    or an err-code without any lock held otherwise.
+ *
+ * Call holding the both the rw_mutex and the rcu read lock.
  */
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
@@ -771,13 +773,10 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 	int err = -EPERM;
 	struct kern_ipc_perm *ipcp;
 
-	down_write(&ids->rw_mutex);
-	rcu_read_lock();
-
 	ipcp = ipc_obtain_object_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		goto out_up;
+		goto err;
 	}
 
 	audit_ipc_obj(ipcp);
@@ -788,16 +787,8 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
 	    ns_capable(ns->user_ns, CAP_SYS_ADMIN))
-		return ipcp;
-
-out_up:
-	/*
-	 * Unsuccessful lookup, unlock and return
-	 * the corresponding error.
-	 */
-	rcu_read_unlock();
-	up_write(&ids->rw_mutex);
-
+		return ipcp; /* successful lookup */
+err:
 	return ERR_PTR(err);
 }
 
-- 
1.7.11.7

