Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3AVXPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:15:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64306 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3AVXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:59 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/6] ipc: object locking updates to account for queue spinlock api change
Date: Tue, 22 Jan 2013 15:13:35 -0800
Message-Id: <1358896415-28569-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1358896415-28569-1-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to the previous change updating the ipc subsystem to use
queue spinlocks, this is very minimal. The changes are:

- As we run in process context without disabling BH processing, it is
  possible that we get interrupted in the middle of a spinlock acquisition.
  Use q_spin_lock_process() instead of q_spin_lock() in order to account
  for that by using the per-CPU token that is reserved for such process
  context processing.

- Deal with the possibility of running out of memory as we initialize
  a dynamically allocated IPC object's spinlock, and destroy the spinlock
  when the ipc object is freed. There is a bit of complexity here as IPC
  objects use a scheme where object deletion is delayed by one RCU grace
  period, during which the object lock may still be accessed. In order to
  address this we have to make the ipc rcu allocation/freeing system
  aware of where the object spinlocks are located within the allocated
  object. This is not too hard in practice, as all ipc objects start
  with the kern_ipc_perm structure, which is where the object's spinlock
  is located.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/ipc.h |    5 +--
 include/linux/msg.h |    2 +-
 include/linux/shm.h |    2 +-
 ipc/sem.c           |    3 +-
 ipc/util.c          |   77 ++++++++++++++++++++++++++++++++++----------------
 ipc/util.h          |    4 +-
 6 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 81693a8a5177..4bc1751664fe 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -7,9 +7,8 @@
 
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 
-/* used by in-kernel data structures */
-struct kern_ipc_perm
-{
+/* used by in-kernel data structures, must be placed first */
+struct kern_ipc_perm {
 	struct q_spinlock	lock;
 	int		deleted;
 	int		id;
diff --git a/include/linux/msg.h b/include/linux/msg.h
index 7a4b9e97d29a..36a69d8d9a95 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -16,7 +16,7 @@ struct msg_msg {
 
 /* one msq_queue structure for each present queue on the system */
 struct msg_queue {
-	struct kern_ipc_perm q_perm;
+	struct kern_ipc_perm q_perm;	/* permissions, must be first */
 	time_t q_stime;			/* last msgsnd time */
 	time_t q_rtime;			/* last msgrcv time */
 	time_t q_ctime;			/* last change time */
diff --git a/include/linux/shm.h b/include/linux/shm.h
index bcf8a6a3ec00..2e74b96922df 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -8,7 +8,7 @@
 #include <asm/shmparam.h>
 struct shmid_kernel /* private to the kernel */
 {	
-	struct kern_ipc_perm	shm_perm;
+	struct kern_ipc_perm	shm_perm;	/* must be first */
 	struct file *		shm_file;
 	unsigned long		shm_nattch;
 	unsigned long		shm_segsz;
diff --git a/ipc/sem.c b/ipc/sem.c
index 84b7f3b2c632..e1f24942b294 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -309,7 +309,6 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	if (!sma) {
 		return -ENOMEM;
 	}
-	memset (sma, 0, size);
 
 	sma->sem_perm.mode = (semflg & S_IRWXUGO);
 	sma->sem_perm.key = key;
@@ -330,6 +329,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+	memset (sma->sem_base, 0, nsems * sizeof (struct sem));
 
 	for (i = 0; i < nsems; i++)
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
@@ -338,6 +338,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
+	sma->sem_otime = 0;
 	sma->sem_ctime = get_seconds();
 	sem_unlock(sma, &node);
 
diff --git a/ipc/util.c b/ipc/util.c
index b4232f0cb473..f4f94b0c2e1b 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -255,20 +255,21 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size,
 	kgid_t egid;
 	int id, err;
 
+	assert_q_spin_unlocked(&new->lock);
+
 	if (size > IPCMNI)
 		size = IPCMNI;
 
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	q_spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
-	q_spin_lock(&new->lock, node);
+	q_spin_lock_process(&new->lock, node);
 
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
 	if (err) {
-		q_spin_unlock(&new->lock, node);
+		q_spin_unlock_process(&new->lock, node);
 		rcu_read_unlock();
 		return err;
 	}
@@ -480,28 +481,28 @@ void ipc_free(void* ptr, int size)
  * - [only if vmalloc]: ipc_rcu_sched.
  * Their lifetime doesn't overlap, thus the headers share the same memory.
  * Unlike a normal union, they are right-aligned, thus some container_of
- * forward/backward casting is necessary:
+ * forward/backward casting is necessary.
+ * Note that the first data field following these headers is always
+ * of type struct kern_ipc_perm.
  */
 struct ipc_rcu_hdr
 {
 	int refcount;
 	int is_vmalloc;
-	void *data[0];
+	struct kern_ipc_perm data[0];
 };
 
 
 struct ipc_rcu_grace
 {
 	struct rcu_head rcu;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
+	struct kern_ipc_perm data[0];
 };
 
 struct ipc_rcu_sched
 {
 	struct work_struct work;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
+	struct kern_ipc_perm data[0];
 };
 
 #define HDRLEN_KMALLOC		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
@@ -528,24 +529,33 @@ static inline int rcu_use_vmalloc(int size)
  
 void* ipc_rcu_alloc(int size)
 {
-	void* out;
+	void* alloc;
+	struct kern_ipc_perm *out = NULL;
 	/* 
 	 * We prepend the allocation with the rcu struct, and
 	 * workqueue if necessary (for vmalloc). 
 	 */
 	if (rcu_use_vmalloc(size)) {
-		out = vmalloc(HDRLEN_VMALLOC + size);
-		if (out) {
-			out += HDRLEN_VMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
+		alloc = vmalloc(HDRLEN_VMALLOC + size);
+		if (alloc) {
+			out = alloc + HDRLEN_VMALLOC;
+			if (q_spin_lock_init(&out->lock)) {
+				vfree(alloc);
+				return NULL;
+			}
+			container_of(out, struct ipc_rcu_hdr, data[0])->is_vmalloc = 1;
+			container_of(out, struct ipc_rcu_hdr, data[0])->refcount = 1;
 		}
 	} else {
-		out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
-		if (out) {
-			out += HDRLEN_KMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
+		alloc = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
+		if (alloc) {
+			out = alloc + HDRLEN_KMALLOC;
+			if (q_spin_lock_init(&out->lock)) {
+				kfree(alloc);
+				return NULL;
+			}
+			container_of(out, struct ipc_rcu_hdr, data[0])->is_vmalloc = 0;
+			container_of(out, struct ipc_rcu_hdr, data[0])->refcount = 1;
 		}
 	}
 
@@ -575,13 +585,29 @@ static void ipc_schedule_free(struct rcu_head *head)
 	struct ipc_rcu_sched *sched;
 
 	grace = container_of(head, struct ipc_rcu_grace, rcu);
-	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched,
-				data[0]);
+	assert_q_spin_unlocked(&grace->data[0].lock);
+	q_spin_lock_destroy(&grace->data[0].lock);
 
+	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched, data[0]);
 	INIT_WORK(&sched->work, ipc_do_vfree);
 	schedule_work(&sched->work);
 }
 
+/**
+ * ipc_immediate_free - free ipc + rcu space
+ * @head: RCU callback structure that contains pointer to be freed
+ *
+ * Free from the RCU callback context.
+ */
+static void ipc_immediate_free(struct rcu_head *head)
+{
+	struct ipc_rcu_grace *free =
+		container_of(head, struct ipc_rcu_grace, rcu);
+	assert_q_spin_unlocked(&free->data[0].lock);
+	q_spin_lock_destroy(&free->data[0].lock);
+	kfree(free);
+}
+
 void ipc_rcu_putref(void *ptr)
 {
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
@@ -591,7 +617,8 @@ void ipc_rcu_putref(void *ptr)
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
-		kfree_rcu(container_of(ptr, struct ipc_rcu_grace, data), rcu);
+		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
+				ipc_immediate_free);
 	}
 }
 
@@ -697,13 +724,13 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id,
 		return ERR_PTR(-EINVAL);
 	}
 
-	q_spin_lock(&out->lock, node);
+	q_spin_lock_process(&out->lock, node);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
 	if (out->deleted) {
-		q_spin_unlock(&out->lock, node);
+		q_spin_unlock_process(&out->lock, node);
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/ipc/util.h b/ipc/util.h
index f03c36188cc3..eb547e35ffbe 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -165,13 +165,13 @@ static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm,
 				   struct q_spinlock_node *node)
 {
 	rcu_read_lock();
-	q_spin_lock(&perm->lock, node);
+	q_spin_lock_process(&perm->lock, node);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm,
 			      struct q_spinlock_node *node)
 {
-	q_spin_unlock(&perm->lock, node);
+	q_spin_unlock_process(&perm->lock, node);
 	rcu_read_unlock();
 }
 
-- 
1.7.7.3
