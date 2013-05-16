Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3EPBIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41920 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3EPBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:14 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 03/11] ipc: close open coded spin lock calls
Date: Wed, 15 May 2013 18:08:02 -0700
Message-Id: <1368666490-29055-4-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c  |  2 +-
 ipc/sem.c  | 14 +++++++-------
 ipc/shm.c  |  4 ++--
 ipc/util.h |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 8270511..7a6f344 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -218,7 +218,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	spin_unlock(&msq->q_perm.lock);
+	ipc_unlock_object(&msq->q_perm);
 	rcu_read_unlock();
 
 	return msq->q_perm.id;
diff --git a/ipc/sem.c b/ipc/sem.c
index cee96e6..7854fc8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -246,7 +246,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		 * their critical section while the array lock is held.
 		 */
  lock_array:
-		spin_lock(&sma->sem_perm.lock);
+		ipc_lock_object(&sma->sem_perm);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
 			spin_unlock_wait(&sem->lock);
@@ -259,7 +259,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
-		spin_unlock(&sma->sem_perm.lock);
+		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
 		spin_unlock(&sem->lock);
@@ -857,7 +857,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	int i;
 
 	/* Free the existing undo structures for this semaphore set.  */
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
 		list_del(&un->list_id);
 		spin_lock(&un->ulp->lock);
@@ -1055,7 +1055,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 
 	curr = &sma->sem_base[semnum];
 
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_for_each_entry(un, &sma->list_id, list_id)
 		un->semadj[semnum] = 0;
 
@@ -1184,7 +1184,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
 
-		assert_spin_locked(&sma->sem_perm.lock);
+		ipc_assert_locked_object(&sma->sem_perm);
 		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
@@ -1481,7 +1481,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
 	list_add_rcu(&new->list_proc, &ulp->list_proc);
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
 
@@ -1818,7 +1818,7 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		/* remove un from the linked lists */
-		assert_spin_locked(&sma->sem_perm.lock);
+		ipc_assert_locked_object(&sma->sem_perm);
 		list_del(&un->list_id);
 
 		spin_lock(&ulp->lock);
diff --git a/ipc/shm.c b/ipc/shm.c
index 11dec70..1fd3d05f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -141,7 +141,7 @@ static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
 {
 	rcu_read_lock();
-	spin_lock(&ipcp->shm_perm.lock);
+	ipc_lock_object(&ipcp->shm_perm);
 }
 
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
@@ -547,7 +547,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
 
-	spin_unlock(&shp->shm_perm.lock);
+	ipc_unlock_object(&shp->shm_perm);
 	rcu_read_unlock();
 	return error;
 
diff --git a/ipc/util.h b/ipc/util.h
index da65e8a..b6a6a88 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -177,12 +177,12 @@ static inline void ipc_assert_locked_object(struct kern_ipc_perm *perm)
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
 {
 	rcu_read_lock();
-	spin_lock(&perm->lock);
+	ipc_lock_object(perm);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
-	spin_unlock(&perm->lock);
+	ipc_unlock_object(perm);
 	rcu_read_unlock();
 }
 
-- 
1.7.11.7

