Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3CFWPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:15:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab3CFWPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:15:12 -0500
Date: Wed, 6 Mar 2013 17:13:54 -0500
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
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 5/4] ipc: replace ipc_perm.lock with an rwlock
Message-ID: <20130306171354.72ca320b@cuia.bos.redhat.com>
In-Reply-To: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches go on top of Davidlohr's 4 patches. Performance numbers in patch "7"

---8<---

Replace the ipc_perm.lock with an rwlock, in preparation for
finer grained locking for semaphore operations.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/ipc.h |    2 +-
 ipc/sem.c           |   11 +++--------
 ipc/shm.c           |    2 +-
 ipc/util.c          |   12 ++++++------
 ipc/util.h          |    6 +++---
 5 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 8d861b2..3c5e2aa 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -10,7 +10,7 @@
 /* used by in-kernel data structures */
 struct kern_ipc_perm
 {
-	spinlock_t	lock;
+	rwlock_t	lock;
 	int		deleted;
 	int		id;
 	key_t		key;
diff --git a/ipc/sem.c b/ipc/sem.c
index f06a853..efb49e7 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -260,7 +260,7 @@ static inline void sem_putref(struct sem_array *sma)
  */
 static inline void sem_getref(struct sem_array *sma)
 {
-	spin_lock(&(sma)->sem_perm.lock);
+	write_lock(&(sma)->sem_perm.lock);
 	ipc_rcu_getref(sma);
 	ipc_unlock(&(sma)->sem_perm);
 }
@@ -778,7 +778,6 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct list_head tasks;
 
 	/* Free the existing undo structures for this semaphore set.  */
-	assert_spin_locked(&sma->sem_perm.lock);
 	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
 		list_del(&un->list_id);
 		spin_lock(&un->ulp->lock);
@@ -977,7 +976,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			}
 		}
 
-		spin_lock(&sma->sem_perm.lock);
+		write_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
 		sem_unlock(sma);
@@ -1025,7 +1024,6 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
 
-		assert_spin_locked(&sma->sem_perm.lock);
 		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
@@ -1042,7 +1040,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	if(semnum < 0 || semnum >= nsems)
 		goto out_unlock;
 
-	spin_lock(&sma->sem_perm.lock);
+	write_lock(&sma->sem_perm.lock);
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1067,7 +1065,6 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		if (val > SEMVMX || val < 0)
 			goto out_unlock;
 
-		assert_spin_locked(&sma->sem_perm.lock);
 		list_for_each_entry(un, &sma->list_id, list_id)
 			un->semadj[semnum] = 0;
 
@@ -1345,7 +1342,6 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
 	list_add_rcu(&new->list_proc, &ulp->list_proc);
-	assert_spin_locked(&sma->sem_perm.lock);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
 
@@ -1696,7 +1692,6 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		/* remove un from the linked lists */
-		assert_spin_locked(&sma->sem_perm.lock);
 		list_del(&un->list_id);
 
 		spin_lock(&ulp->lock);
diff --git a/ipc/shm.c b/ipc/shm.c
index cb858df..62b9f1d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -141,7 +141,7 @@ static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
 {
 	rcu_read_lock();
-	spin_lock(&ipcp->shm_perm.lock);
+	write_lock(&ipcp->shm_perm.lock);
 }
 
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
diff --git a/ipc/util.c b/ipc/util.c
index 6a98e62..8a87900 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -263,17 +263,17 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	idr_preload(GFP_KERNEL);
 
-	spin_lock_init(&new->lock);
+	rwlock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
-	spin_lock(&new->lock);
+	write_lock(&new->lock);
 
 	id = idr_alloc(&ids->ipcs_idr, new,
 		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
 		       GFP_NOWAIT);
 	idr_preload_end();
 	if (id < 0) {
-		spin_unlock(&new->lock);
+		write_unlock(&new->lock);
 		rcu_read_unlock();
 		return id;
 	}
@@ -708,7 +708,7 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 	if (IS_ERR(out))
 		goto err1;
 
-	spin_lock(&out->lock);
+	write_lock(&out->lock);
 
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
@@ -718,7 +718,7 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 
 	return out;
 err0:
-	spin_unlock(&out->lock);
+	write_unlock(&out->lock);
 err1:
 	rcu_read_unlock();
 	return ERR_PTR(-EINVAL);
@@ -830,7 +830,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 	if (IS_ERR(ipcp))
 		goto out;
 
-	spin_lock(&ipcp->lock);
+	write_lock(&ipcp->lock);
 out:
 	return ipcp;
 }
diff --git a/ipc/util.h b/ipc/util.h
index c36b997..6f157ab 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -162,18 +162,18 @@ static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
 {
 	rcu_read_lock();
-	spin_lock(&perm->lock);
+	write_lock(&perm->lock);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
-	spin_unlock(&perm->lock);
+	write_unlock(&perm->lock);
 	rcu_read_unlock();
 }
 
 static inline void ipc_lock_object(struct kern_ipc_perm *perm)
 {
-	spin_lock(&perm->lock);
+	write_lock(&perm->lock);
 }
 
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
