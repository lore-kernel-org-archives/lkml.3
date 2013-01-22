Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3AVXOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:14:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3AVXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:55 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/6] ipc: convert ipc objects to use queue spinlock API
Date: Tue, 22 Jan 2013 15:13:32 -0800
Message-Id: <1358896415-28569-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1358896415-28569-1-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change converts the IPC message queues, semaphores and shm segments
to use the queue spinlock API.

This is relatively large, but mostly mechanical, mostly adding
struct q_spinlock_node variables before locking ipc objects and passing
them all the way to the actual locking and unlocking functions.

In most cases the struct q_spinlock_node is allocated on stack, but
there are exceptions such as the sysvipc_proc_seqops allocating it
within their iterator structure.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/ipc.h |    4 +-
 ipc/msg.c           |   61 ++++++++++++++++------------
 ipc/namespace.c     |    8 ++-
 ipc/sem.c           |  112 ++++++++++++++++++++++++++++----------------------
 ipc/shm.c           |   95 ++++++++++++++++++++++++-------------------
 ipc/util.c          |   55 ++++++++++++++----------
 ipc/util.h          |   25 +++++++----
 7 files changed, 207 insertions(+), 153 deletions(-)

diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 8d861b2651f7..81693a8a5177 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_IPC_H
 #define _LINUX_IPC_H
 
-#include <linux/spinlock.h>
+#include <linux/queue_spinlock.h>
 #include <linux/uidgid.h>
 #include <uapi/linux/ipc.h>
 
@@ -10,7 +10,7 @@
 /* used by in-kernel data structures */
 struct kern_ipc_perm
 {
-	spinlock_t	lock;
+	struct q_spinlock	lock;
 	int		deleted;
 	int		id;
 	key_t		key;
diff --git a/ipc/msg.c b/ipc/msg.c
index a71af5a65abf..aeb32d539f6e 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -69,9 +69,10 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-#define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
+#define msg_unlock(msq,node)		ipc_unlock(&(msq)->q_perm, node)
 
-static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
+static void freeque(struct ipc_namespace *, struct kern_ipc_perm *,
+		    struct q_spinlock_node *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
@@ -144,9 +145,10 @@ void __init msg_init(void)
  * msg_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
+static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id,
+					 struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct msg_queue *)ipcp;
@@ -155,9 +157,10 @@ static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
 }
 
 static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
-						int id)
+					       int id,
+					       struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct msg_queue *)ipcp;
@@ -183,6 +186,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	int id, retval;
 	key_t key = params->key;
 	int msgflg = params->flg;
+	struct q_spinlock_node node;
 
 	msq = ipc_rcu_alloc(sizeof(*msq));
 	if (!msq)
@@ -201,7 +205,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	/*
 	 * ipc_addid() locks msq
 	 */
-	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
+	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni, &node);
 	if (id < 0) {
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
@@ -217,7 +221,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	msg_unlock(msq);
+	msg_unlock(msq, &node);
 
 	return msq->q_perm.id;
 }
@@ -276,7 +280,8 @@ static void expunge_all(struct msg_queue *msq, int res)
  * msg_ids.rw_mutex (writer) and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.rw_mutex remains locked on exit.
  */
-static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp,
+		    struct q_spinlock_node *node)
 {
 	struct list_head *tmp;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
@@ -284,7 +289,7 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
 	msg_rmid(ns, msq);
-	msg_unlock(msq);
+	msg_unlock(msq, node);
 
 	tmp = msq->q_messages.next;
 	while (tmp != &msq->q_messages) {
@@ -415,6 +420,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 	struct msqid64_ds uninitialized_var(msqid64);
 	struct msg_queue *msq;
 	int err;
+	struct q_spinlock_node node;
 
 	if (cmd == IPC_SET) {
 		if (copy_msqid_from_user(&msqid64, buf, version))
@@ -422,7 +428,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 	}
 
 	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
-			       &msqid64.msg_perm, msqid64.msg_qbytes);
+			       &msqid64.msg_perm, msqid64.msg_qbytes, &node);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
@@ -434,7 +440,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 
 	switch (cmd) {
 	case IPC_RMID:
-		freeque(ns, ipcp);
+		freeque(ns, ipcp, &node);
 		goto out_up;
 	case IPC_SET:
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
@@ -463,7 +469,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		err = -EINVAL;
 	}
 out_unlock:
-	msg_unlock(msq);
+	msg_unlock(msq, &node);
 out_up:
 	up_write(&msg_ids(ns).rw_mutex);
 	return err;
@@ -474,6 +480,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 	struct msg_queue *msq;
 	int err, version;
 	struct ipc_namespace *ns;
+	struct q_spinlock_node node;
 
 	if (msqid < 0 || cmd < 0)
 		return -EINVAL;
@@ -531,12 +538,12 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 			return -EFAULT;
 
 		if (cmd == MSG_STAT) {
-			msq = msg_lock(ns, msqid);
+			msq = msg_lock(ns, msqid, &node);
 			if (IS_ERR(msq))
 				return PTR_ERR(msq);
 			success_return = msq->q_perm.id;
 		} else {
-			msq = msg_lock_check(ns, msqid);
+			msq = msg_lock_check(ns, msqid, &node);
 			if (IS_ERR(msq))
 				return PTR_ERR(msq);
 			success_return = 0;
@@ -560,7 +567,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 		tbuf.msg_qbytes = msq->q_qbytes;
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
-		msg_unlock(msq);
+		msg_unlock(msq, &node);
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
 		return success_return;
@@ -574,7 +581,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 	}
 
 out_unlock:
-	msg_unlock(msq);
+	msg_unlock(msq, &node);
 	return err;
 }
 
@@ -642,6 +649,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	struct msg_msg *msg;
 	int err;
 	struct ipc_namespace *ns;
+	struct q_spinlock_node node;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -657,7 +665,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	msg->m_type = mtype;
 	msg->m_ts = msgsz;
 
-	msq = msg_lock_check(ns, msqid);
+	msq = msg_lock_check(ns, msqid, &node);
 	if (IS_ERR(msq)) {
 		err = PTR_ERR(msq);
 		goto out_free;
@@ -686,10 +694,10 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		}
 		ss_add(msq, &s);
 		ipc_rcu_getref(msq);
-		msg_unlock(msq);
+		msg_unlock(msq, &node);
 		schedule();
 
-		ipc_lock_by_ptr(&msq->q_perm);
+		ipc_lock_by_ptr(&msq->q_perm, &node);
 		ipc_rcu_putref(msq);
 		if (msq->q_perm.deleted) {
 			err = -EIDRM;
@@ -719,7 +727,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	msg = NULL;
 
 out_unlock_free:
-	msg_unlock(msq);
+	msg_unlock(msq, &node);
 out_free:
 	if (msg != NULL)
 		free_msg(msg);
@@ -762,13 +770,14 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+	struct q_spinlock_node node;
 
 	if (msqid < 0 || (long) msgsz < 0)
 		return -EINVAL;
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
-	msq = msg_lock_check(ns, msqid);
+	msq = msg_lock_check(ns, msqid, &node);
 	if (IS_ERR(msq))
 		return PTR_ERR(msq);
 
@@ -819,7 +828,7 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
 			ss_wakeup(&msq->q_senders, 0);
-			msg_unlock(msq);
+			msg_unlock(msq, &node);
 			break;
 		}
 		/* No message waiting. Wait for a message */
@@ -837,7 +846,7 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 			msr_d.r_maxsize = msgsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
-		msg_unlock(msq);
+		msg_unlock(msq, &node);
 
 		schedule();
 
@@ -876,7 +885,7 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 		/* Lockless receive, part 3:
 		 * Acquire the queue spinlock.
 		 */
-		ipc_lock_by_ptr(&msq->q_perm);
+		ipc_lock_by_ptr(&msq->q_perm, &node);
 		rcu_read_unlock();
 
 		/* Lockless receive, part 4:
@@ -890,7 +899,7 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 		if (signal_pending(current)) {
 			msg = ERR_PTR(-ERESTARTNOHAND);
 out_unlock:
-			msg_unlock(msq);
+			msg_unlock(msq, &node);
 			break;
 		}
 	}
diff --git a/ipc/namespace.c b/ipc/namespace.c
index f362298c5ce4..ba4f87c18870 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -70,11 +70,13 @@ struct ipc_namespace *copy_ipcs(unsigned long flags,
  * Called for each kind of ipc when an ipc_namespace exits.
  */
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-	       void (*free)(struct ipc_namespace *, struct kern_ipc_perm *))
+	       void (*free)(struct ipc_namespace *, struct kern_ipc_perm *,
+			    struct q_spinlock_node *))
 {
 	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
+	struct q_spinlock_node node;
 
 	down_write(&ids->rw_mutex);
 
@@ -84,8 +86,8 @@ void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
 		perm = idr_find(&ids->ipcs_idr, next_id);
 		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(perm);
-		free(ns, perm);
+		ipc_lock_by_ptr(perm, &node);
+		free(ns, perm, &node);
 		total++;
 	}
 	up_write(&ids->rw_mutex);
diff --git a/ipc/sem.c b/ipc/sem.c
index 58d31f1c1eb5..84b7f3b2c632 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -138,11 +138,12 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
+#define sem_unlock(sma,node)		ipc_unlock(&(sma)->sem_perm, node)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
-static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
+static void freeary(struct ipc_namespace *, struct kern_ipc_perm *,
+		    struct q_spinlock_node *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #endif
@@ -194,9 +195,10 @@ void __init sem_init (void)
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id,
+					 struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct sem_array *)ipcp;
@@ -205,9 +207,10 @@ static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
 }
 
 static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
-						int id)
+					       int id,
+					       struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct sem_array *)ipcp;
@@ -215,23 +218,26 @@ static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
-static inline void sem_lock_and_putref(struct sem_array *sma)
+static inline void sem_lock_and_putref(struct sem_array *sma,
+				       struct q_spinlock_node *node)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
+	ipc_lock_by_ptr(&sma->sem_perm, node);
 	ipc_rcu_putref(sma);
 }
 
-static inline void sem_getref_and_unlock(struct sem_array *sma)
+static inline void sem_getref_and_unlock(struct sem_array *sma,
+					 struct q_spinlock_node *node)
 {
 	ipc_rcu_getref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	ipc_unlock(&(sma)->sem_perm, node);
 }
 
 static inline void sem_putref(struct sem_array *sma)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
+	struct q_spinlock_node node;
+	ipc_lock_by_ptr(&sma->sem_perm, &node);
 	ipc_rcu_putref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	ipc_unlock(&(sma)->sem_perm, &node);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -291,6 +297,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
 	int i;
+	struct q_spinlock_node node;
 
 	if (!nsems)
 		return -EINVAL;
@@ -314,7 +321,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 		return retval;
 	}
 
-	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni, &node);
 	if (id < 0) {
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
@@ -332,7 +339,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 
 	return sma->sem_perm.id;
 }
@@ -739,7 +746,8 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
  */
-static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp,
+		    struct q_spinlock_node *node)
 {
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
@@ -747,7 +755,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct list_head tasks;
 
 	/* Free the existing undo structures for this semaphore set.  */
-	assert_spin_locked(&sma->sem_perm.lock);
+	assert_q_spin_locked(&sma->sem_perm.lock);
 	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
 		list_del(&un->list_id);
 		spin_lock(&un->ulp->lock);
@@ -766,7 +774,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
-	sem_unlock(sma);
+	sem_unlock(sma, node);
 
 	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
@@ -803,6 +811,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 {
 	int err;
 	struct sem_array *sma;
+	struct q_spinlock_node node;
 
 	switch(cmd) {
 	case IPC_INFO:
@@ -845,12 +854,12 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		int id;
 
 		if (cmd == SEM_STAT) {
-			sma = sem_lock(ns, semid);
+			sma = sem_lock(ns, semid, &node);
 			if (IS_ERR(sma))
 				return PTR_ERR(sma);
 			id = sma->sem_perm.id;
 		} else {
-			sma = sem_lock_check(ns, semid);
+			sma = sem_lock_check(ns, semid, &node);
 			if (IS_ERR(sma))
 				return PTR_ERR(sma);
 			id = 0;
@@ -870,7 +879,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		tbuf.sem_otime  = sma->sem_otime;
 		tbuf.sem_ctime  = sma->sem_ctime;
 		tbuf.sem_nsems  = sma->sem_nsems;
-		sem_unlock(sma);
+		sem_unlock(sma, &node);
 		if (copy_semid_to_user (arg.buf, &tbuf, version))
 			return -EFAULT;
 		return id;
@@ -879,7 +888,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		return -EINVAL;
 	}
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 	return err;
 }
 
@@ -893,8 +902,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	ushort* sem_io = fast_sem_io;
 	int nsems;
 	struct list_head tasks;
+	struct q_spinlock_node node;
 
-	sma = sem_lock_check(ns, semid);
+	sma = sem_lock_check(ns, semid, &node);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
@@ -918,7 +928,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 
 		if(nsems > SEMMSL_FAST) {
-			sem_getref_and_unlock(sma);
+			sem_getref_and_unlock(sma, &node);
 
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
@@ -926,9 +936,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 				return -ENOMEM;
 			}
 
-			sem_lock_and_putref(sma);
+			sem_lock_and_putref(sma, &node);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma);
+				sem_unlock(sma, &node);
 				err = -EIDRM;
 				goto out_free;
 			}
@@ -936,7 +946,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
-		sem_unlock(sma);
+		sem_unlock(sma, &node);
 		err = 0;
 		if(copy_to_user(array, sem_io, nsems*sizeof(ushort)))
 			err = -EFAULT;
@@ -947,7 +957,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 		struct sem_undo *un;
 
-		sem_getref_and_unlock(sma);
+		sem_getref_and_unlock(sma, &node);
 
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
@@ -970,9 +980,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 				goto out_free;
 			}
 		}
-		sem_lock_and_putref(sma);
+		sem_lock_and_putref(sma, &node);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma);
+			sem_unlock(sma, &node);
 			err = -EIDRM;
 			goto out_free;
 		}
@@ -980,7 +990,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
 
-		assert_spin_locked(&sma->sem_perm.lock);
+		assert_q_spin_locked(&sma->sem_perm.lock);
 		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
@@ -1021,7 +1031,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		if (val > SEMVMX || val < 0)
 			goto out_unlock;
 
-		assert_spin_locked(&sma->sem_perm.lock);
+		assert_q_spin_locked(&sma->sem_perm.lock);
 		list_for_each_entry(un, &sma->list_id, list_id)
 			un->semadj[semnum] = 0;
 
@@ -1035,7 +1045,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	}
 	}
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 	wake_up_sem_queue_do(&tasks);
 
 out_free:
@@ -1082,6 +1092,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	int err;
 	struct semid64_ds semid64;
 	struct kern_ipc_perm *ipcp;
+	struct q_spinlock_node node;
 
 	if(cmd == IPC_SET) {
 		if (copy_semid_from_user(&semid64, arg.buf, version))
@@ -1089,7 +1100,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	}
 
 	ipcp = ipcctl_pre_down(ns, &sem_ids(ns), semid, cmd,
-			       &semid64.sem_perm, 0);
+			       &semid64.sem_perm, 0, &node);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
@@ -1101,7 +1112,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 
 	switch(cmd){
 	case IPC_RMID:
-		freeary(ns, ipcp);
+		freeary(ns, ipcp, &node);
 		goto out_up;
 	case IPC_SET:
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
@@ -1114,7 +1125,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 out_up:
 	up_write(&sem_ids(ns).rw_mutex);
 	return err;
@@ -1237,6 +1248,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	struct sem_undo *un, *new;
 	int nsems;
 	int error;
+	struct q_spinlock_node node;
 
 	error = get_undo_list(&ulp);
 	if (error)
@@ -1252,12 +1264,12 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 
 	/* no undo structure around - allocate one. */
 	/* step 1: figure out the size of the semaphore array */
-	sma = sem_lock_check(ns, semid);
+	sma = sem_lock_check(ns, semid, &node);
 	if (IS_ERR(sma))
 		return ERR_CAST(sma);
 
 	nsems = sma->sem_nsems;
-	sem_getref_and_unlock(sma);
+	sem_getref_and_unlock(sma, &node);
 
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
@@ -1267,9 +1279,9 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	}
 
 	/* step 3: Acquire the lock on semaphore array */
-	sem_lock_and_putref(sma);
+	sem_lock_and_putref(sma, &node);
 	if (sma->sem_perm.deleted) {
-		sem_unlock(sma);
+		sem_unlock(sma, &node);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1290,14 +1302,14 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
 	list_add_rcu(&new->list_proc, &ulp->list_proc);
-	assert_spin_locked(&sma->sem_perm.lock);
+	assert_q_spin_locked(&sma->sem_perm.lock);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
 
 success:
 	spin_unlock(&ulp->lock);
 	rcu_read_lock();
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 out:
 	return un;
 }
@@ -1342,6 +1354,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
 	struct list_head tasks;
+	struct q_spinlock_node node;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1392,7 +1405,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	INIT_LIST_HEAD(&tasks);
 
-	sma = sem_lock_check(ns, semid);
+	sma = sem_lock_check(ns, semid, &node);
 	if (IS_ERR(sma)) {
 		if (un)
 			rcu_read_unlock();
@@ -1477,7 +1490,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 
 	if (timeout)
 		jiffies_left = schedule_timeout(jiffies_left);
@@ -1499,7 +1512,7 @@ sleep_again:
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
+	sma = sem_lock(ns, semid, &node);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
@@ -1538,7 +1551,7 @@ sleep_again:
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
-	sem_unlock(sma);
+	sem_unlock(sma, &node);
 
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1604,6 +1617,7 @@ void exit_sem(struct task_struct *tsk)
 		struct list_head tasks;
 		int semid;
 		int i;
+		struct q_spinlock_node node;
 
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
@@ -1617,7 +1631,7 @@ void exit_sem(struct task_struct *tsk)
 		if (semid == -1)
 			break;
 
-		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
+		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid, &node);
 
 		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (IS_ERR(sma))
@@ -1628,12 +1642,12 @@ void exit_sem(struct task_struct *tsk)
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
 			 */
-			sem_unlock(sma);
+			sem_unlock(sma, &node);
 			continue;
 		}
 
 		/* remove un from the linked lists */
-		assert_spin_locked(&sma->sem_perm.lock);
+		assert_q_spin_locked(&sma->sem_perm.lock);
 		list_del(&un->list_id);
 
 		spin_lock(&ulp->lock);
@@ -1668,7 +1682,7 @@ void exit_sem(struct task_struct *tsk)
 		/* maybe some queued-up processes were waiting for this */
 		INIT_LIST_HEAD(&tasks);
 		do_smart_update(sma, NULL, 0, 1, &tasks);
-		sem_unlock(sma);
+		sem_unlock(sma, &node);
 		wake_up_sem_queue_do(&tasks);
 
 		kfree_rcu(un, rcu);
diff --git a/ipc/shm.c b/ipc/shm.c
index dff40c9f73c9..67645b4de436 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -58,13 +58,14 @@ static const struct vm_operations_struct shm_vm_ops;
 
 #define shm_ids(ns)	((ns)->ids[IPC_SHM_IDS])
 
-#define shm_unlock(shp)			\
-	ipc_unlock(&(shp)->shm_perm)
+#define shm_unlock(shp,node)			\
+	ipc_unlock(&(shp)->shm_perm,node)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
-static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
+static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp,
+			 struct q_spinlock_node *node);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
@@ -83,7 +84,8 @@ void shm_init_ns(struct ipc_namespace *ns)
  * Called with shm_ids.rw_mutex (writer) and the shp structure locked.
  * Only shm_ids.rw_mutex remains locked on exit.
  */
-static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp,
+			struct q_spinlock_node *node)
 {
 	struct shmid_kernel *shp;
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
@@ -92,9 +94,9 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		shp->shm_perm.mode |= SHM_DEST;
 		/* Do not find it any more */
 		shp->shm_perm.key = IPC_PRIVATE;
-		shm_unlock(shp);
+		shm_unlock(shp, node);
 	} else
-		shm_destroy(ns, shp);
+		shm_destroy(ns, shp, node);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -128,9 +130,10 @@ void __init shm_init (void)
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
  * is not necessarily held.
  */
-static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
+static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id,
+					    struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct shmid_kernel *)ipcp;
@@ -138,16 +141,17 @@ static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
-static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
+static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp,
+				   struct q_spinlock_node *node)
 {
-	rcu_read_lock();
-	spin_lock(&ipcp->shm_perm.lock);
+	ipc_lock_by_ptr(&ipcp->shm_perm, node);
 }
 
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
-						int id)
+						  int id,
+						  struct q_spinlock_node *node)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id, node);
 
 	if (IS_ERR(ipcp))
 		return (struct shmid_kernel *)ipcp;
@@ -167,13 +171,14 @@ static void shm_open(struct vm_area_struct *vma)
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
+	struct q_spinlock_node node;
 
-	shp = shm_lock(sfd->ns, sfd->id);
+	shp = shm_lock(sfd->ns, sfd->id, &node);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_nattch++;
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 }
 
 /*
@@ -185,11 +190,12 @@ static void shm_open(struct vm_area_struct *vma)
  * It has to be called with shp and shm_ids.rw_mutex (writer) locked,
  * but returns with shp unlocked and freed.
  */
-static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp,
+			struct q_spinlock_node *node)
 {
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	shm_rmid(ns, shp);
-	shm_unlock(shp);
+	shm_unlock(shp, node);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
 	else if (shp->mlock_user)
@@ -229,18 +235,19 @@ static void shm_close(struct vm_area_struct *vma)
 	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns = sfd->ns;
+	struct q_spinlock_node node;
 
 	down_write(&shm_ids(ns).rw_mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock(ns, sfd->id);
+	shp = shm_lock(ns, sfd->id, &node);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
 	if (shm_may_destroy(ns, shp))
-		shm_destroy(ns, shp);
+		shm_destroy(ns, shp, &node);
 	else
-		shm_unlock(shp);
+		shm_unlock(shp, &node);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
@@ -269,8 +276,9 @@ static int shm_try_destroy_current(int id, void *p, void *data)
 		return 0;
 
 	if (shm_may_destroy(ns, shp)) {
-		shm_lock_by_ptr(shp);
-		shm_destroy(ns, shp);
+		struct q_spinlock_node node;
+		shm_lock_by_ptr(shp, &node);
+		shm_destroy(ns, shp, &node);
 	}
 	return 0;
 }
@@ -292,8 +300,9 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
 		return 0;
 
 	if (shm_may_destroy(ns, shp)) {
-		shm_lock_by_ptr(shp);
-		shm_destroy(ns, shp);
+		struct q_spinlock_node node;
+		shm_lock_by_ptr(shp, &node);
+		shm_destroy(ns, shp, &node);
 	}
 	return 0;
 }
@@ -467,6 +476,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	char name[13];
 	int id;
 	vm_flags_t acctflag = 0;
+	struct q_spinlock_node node;
 
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
@@ -510,7 +520,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (IS_ERR(file))
 		goto no_file;
 
-	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
+	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni, &node);
 	if (id < 0) {
 		error = id;
 		goto no_id;
@@ -532,7 +542,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 	return error;
 
 no_id:
@@ -737,6 +747,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 	struct shmid64_ds shmid64;
 	struct shmid_kernel *shp;
 	int err;
+	struct q_spinlock_node node;
 
 	if (cmd == IPC_SET) {
 		if (copy_shmid_from_user(&shmid64, buf, version))
@@ -744,7 +755,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 	}
 
 	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid, cmd,
-			       &shmid64.shm_perm, 0);
+			       &shmid64.shm_perm, 0, &node);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
@@ -755,7 +766,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 		goto out_unlock;
 	switch (cmd) {
 	case IPC_RMID:
-		do_shm_rmid(ns, ipcp);
+		do_shm_rmid(ns, ipcp, &node);
 		goto out_up;
 	case IPC_SET:
 		err = ipc_update_perm(&shmid64.shm_perm, ipcp);
@@ -767,7 +778,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 		err = -EINVAL;
 	}
 out_unlock:
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 out_up:
 	up_write(&shm_ids(ns).rw_mutex);
 	return err;
@@ -778,6 +789,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	struct shmid_kernel *shp;
 	int err, version;
 	struct ipc_namespace *ns;
+	struct q_spinlock_node node;
 
 	if (cmd < 0 || shmid < 0) {
 		err = -EINVAL;
@@ -845,14 +857,14 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		int result;
 
 		if (cmd == SHM_STAT) {
-			shp = shm_lock(ns, shmid);
+			shp = shm_lock(ns, shmid, &node);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
 				goto out;
 			}
 			result = shp->shm_perm.id;
 		} else {
-			shp = shm_lock_check(ns, shmid);
+			shp = shm_lock_check(ns, shmid, &node);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
 				goto out;
@@ -874,7 +886,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
-		shm_unlock(shp);
+		shm_unlock(shp, &node);
 		if(copy_shmid_to_user (buf, &tbuf, version))
 			err = -EFAULT;
 		else
@@ -886,7 +898,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	{
 		struct file *shm_file;
 
-		shp = shm_lock_check(ns, shmid);
+		shp = shm_lock_check(ns, shmid, &node);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out;
@@ -929,7 +941,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		shp->shm_perm.mode &= ~SHM_LOCKED;
 		shp->mlock_user = NULL;
 		get_file(shm_file);
-		shm_unlock(shp);
+		shm_unlock(shp, &node);
 		shmem_unlock_mapping(shm_file->f_mapping);
 		fput(shm_file);
 		goto out;
@@ -943,7 +955,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	}
 
 out_unlock:
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 out:
 	return err;
 }
@@ -971,6 +983,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	struct shm_file_data *sfd;
 	struct path path;
 	fmode_t f_mode;
+	struct q_spinlock_node node;
 
 	err = -EINVAL;
 	if (shmid < 0)
@@ -1012,7 +1025,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock_check(ns, shmid);
+	shp = shm_lock_check(ns, shmid, &node);
 	if (IS_ERR(shp)) {
 		err = PTR_ERR(shp);
 		goto out;
@@ -1030,7 +1043,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	path_get(&path);
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
@@ -1082,20 +1095,20 @@ out_fput:
 
 out_nattch:
 	down_write(&shm_ids(ns).rw_mutex);
-	shp = shm_lock(ns, shmid);
+	shp = shm_lock(ns, shmid, &node);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if (shm_may_destroy(ns, shp))
-		shm_destroy(ns, shp);
+		shm_destroy(ns, shp, &node);
 	else
-		shm_unlock(shp);
+		shm_unlock(shp, &node);
 	up_write(&shm_ids(ns).rw_mutex);
 
 out:
 	return err;
 
 out_unlock:
-	shm_unlock(shp);
+	shm_unlock(shp, &node);
 	goto out;
 
 out_free:
diff --git a/ipc/util.c b/ipc/util.c
index 72fd0785ac94..b4232f0cb473 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -178,7 +178,8 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
  *	If key is found ipc points to the owning ipc structure
  */
  
-static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
+static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key,
+					 struct q_spinlock_node *node)
 {
 	struct kern_ipc_perm *ipc;
 	int next_id;
@@ -195,7 +196,7 @@ static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 			continue;
 		}
 
-		ipc_lock_by_ptr(ipc);
+		ipc_lock_by_ptr(ipc, node);
 		return ipc;
 	}
 
@@ -247,7 +248,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	Called with ipc_ids.rw_mutex held as a writer.
  */
  
-int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
+int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size,
+	      struct q_spinlock_node *node)
 {
 	kuid_t euid;
 	kgid_t egid;
@@ -259,14 +261,14 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	spin_lock_init(&new->lock);
+	q_spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
-	spin_lock(&new->lock);
+	q_spin_lock(&new->lock, node);
 
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
 	if (err) {
-		spin_unlock(&new->lock);
+		q_spin_unlock(&new->lock, node);
 		rcu_read_unlock();
 		return err;
 	}
@@ -368,6 +370,7 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
 	int err;
+	struct q_spinlock_node node;
 retry:
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
@@ -376,7 +379,7 @@ retry:
 	 * a new entry + read locks are not "upgradable"
 	 */
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_findkey(ids, params->key);
+	ipcp = ipc_findkey(ids, params->key, &node);
 	if (ipcp == NULL) {
 		/* key not used */
 		if (!(flg & IPC_CREAT))
@@ -401,7 +404,7 @@ retry:
 				 */
 				err = ipc_check_perms(ns, ipcp, ops, params);
 		}
-		ipc_unlock(ipcp);
+		ipc_unlock(ipcp, &node);
 	}
 	up_write(&ids->rw_mutex);
 
@@ -681,7 +684,8 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
  * The ipc object is locked on exit.
  */
 
-struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id,
+			       struct q_spinlock_node *node)
 {
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
@@ -693,13 +697,13 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock(&out->lock);
+	q_spin_lock(&out->lock, node);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
 	if (out->deleted) {
-		spin_unlock(&out->lock);
+		q_spin_unlock(&out->lock, node);
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
@@ -707,16 +711,17 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 	return out;
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
+struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id,
+				     struct q_spinlock_node *node)
 {
 	struct kern_ipc_perm *out;
 
-	out = ipc_lock(ids, id);
+	out = ipc_lock(ids, id, node);
 	if (IS_ERR(out))
 		return out;
 
 	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
+		ipc_unlock(out, node);
 		return ERR_PTR(-EIDRM);
 	}
 
@@ -781,14 +786,15 @@ int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out)
  */
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm)
+				      struct ipc64_perm *perm, int extra_perm,
+				      struct q_spinlock_node *node)
 {
 	struct kern_ipc_perm *ipcp;
 	kuid_t euid;
 	int err;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check(ids, id);
+	ipcp = ipc_lock_check(ids, id, node);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
@@ -805,7 +811,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 		return ipcp;
 
 	err = -EPERM;
-	ipc_unlock(ipcp);
+	ipc_unlock(ipcp, node);
 out_up:
 	up_write(&ids->rw_mutex);
 	return ERR_PTR(err);
@@ -839,13 +845,15 @@ int ipc_parse_version (int *cmd)
 struct ipc_proc_iter {
 	struct ipc_namespace *ns;
 	struct ipc_proc_iface *iface;
+	struct q_spinlock_node node;
 };
 
 /*
  * This routine locks the ipc structure found at least at position pos.
  */
 static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
-					      loff_t *new_pos)
+					      loff_t *new_pos,
+					      struct q_spinlock_node *node)
 {
 	struct kern_ipc_perm *ipc;
 	int total, id;
@@ -864,7 +872,7 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
-			ipc_lock_by_ptr(ipc);
+			ipc_lock_by_ptr(ipc, node);
 			return ipc;
 		}
 	}
@@ -881,9 +889,10 @@ static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
 
 	/* If we had an ipc id locked before, unlock it */
 	if (ipc && ipc != SEQ_START_TOKEN)
-		ipc_unlock(ipc);
+		ipc_unlock(ipc, &iter->node);
 
-	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], *pos, pos);
+	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], *pos, pos,
+				&iter->node);
 }
 
 /*
@@ -913,7 +922,7 @@ static void *sysvipc_proc_start(struct seq_file *s, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	/* Find the (pos-1)th ipc */
-	return sysvipc_find_ipc(ids, *pos - 1, pos);
+	return sysvipc_find_ipc(ids, *pos - 1, pos, &iter->node);
 }
 
 static void sysvipc_proc_stop(struct seq_file *s, void *it)
@@ -925,7 +934,7 @@ static void sysvipc_proc_stop(struct seq_file *s, void *it)
 
 	/* If we had a locked structure, release it */
 	if (ipc && ipc != SEQ_START_TOKEN)
-		ipc_unlock(ipc);
+		ipc_unlock(ipc, &iter->node);
 
 	ids = &iter->ns->ids[iface->ids];
 	/* Release the lock we took in start() */
diff --git a/ipc/util.h b/ipc/util.h
index c8fe2f7631e9..f03c36188cc3 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -94,7 +94,8 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
 
 /* must be called with ids->rw_mutex acquired for writing */
-int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
+int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int,
+	      struct q_spinlock_node *);
 
 /* must be called with ids->rw_mutex acquired for reading */
 int ipc_get_maxid(struct ipc_ids *);
@@ -121,14 +122,16 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int,
+			       struct q_spinlock_node *);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm);
+				      struct ipc64_perm *perm, int extra_perm,
+				      struct q_spinlock_node *node);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
@@ -158,21 +161,25 @@ static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 	return 0;
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm,
+				   struct q_spinlock_node *node)
 {
 	rcu_read_lock();
-	spin_lock(&perm->lock);
+	q_spin_lock(&perm->lock, node);
 }
 
-static inline void ipc_unlock(struct kern_ipc_perm *perm)
+static inline void ipc_unlock(struct kern_ipc_perm *perm,
+			      struct q_spinlock_node *node)
 {
-	spin_unlock(&perm->lock);
+	q_spin_unlock(&perm->lock, node);
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id,
+				     struct q_spinlock_node *node);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
+	       void (*free)(struct ipc_namespace *, struct kern_ipc_perm *,
+			    struct q_spinlock_node *));
 #endif
-- 
1.7.7.3
