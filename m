Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3EYIzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 04:55:22 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33301 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3EYIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 04:55:19 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: fix lockup, restore FIFO behavior
Date: Sat, 25 May 2013 10:54:55 +0200
Message-Id: <1369472095-30195-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

I came up with a completely different approach:

The patch
a) fixes a lockup due to a missing restart.
b) makes the code again FIFO.

Changes:
- the wait-for-zero operations are moved into seperate lists. Thus they can
  be checked seperately, without rescanning the whole queue.
- If a complex operating arrives, then all pending change operations are
  moved into the global queue. This allows to keep everything FIFO.

Advantage:
- Fewer restarts in update_queue(), because pending wait-for-zero do not
  force a restart anymore.
- Efficient handling of wait-for-zero semops, both simple and complex.
- FIFO. Dropping FIFO is a user visible change, and I'm a coward.
- simpler check_restart logic.

Disadvantage:
When one complex operation arrives, then the semaphore array goes into a
complex_present mode that always acquires the global lock. Even when the
complex operations have completed, pending simple decrease operations
prevent the array from switching back. The switch happens when
there are only simple wait-for-zero semops (or no semops at all).

But: Let's wait if this really exists: An application that does rarely
complex operations (and that doesn't prefer FIFO semantics).

Other changes:
- try_atomic_semop() also performs the semop. Thus rename the function.

It passes tests with qemu, but not boot-tested due to EFI problems.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

---
diff --git a/include/linux/sem.h b/include/linux/sem.h
index 53d4265..3f2c6c8 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -15,10 +15,14 @@ struct sem_array {
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
-	struct list_head	sem_pending;	/* pending operations to be processed */
+	struct list_head	pending_alter;	/* pending operations */
+						/* that alter the array */
+	struct list_head	pending_const;	/* pending complex operations */
+						/* that do not alter semvals */
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
-	int			complex_count;	/* pending complex operations */
+	int			complex_present;
+						/* pending complex semops? */
 };
 
 #ifdef CONFIG_SYSVIPC
diff --git a/ipc/sem.c b/ipc/sem.c
index a7e40ed..bf220de 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -95,7 +95,10 @@ struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
-	struct list_head sem_pending; /* pending single-sop operations */
+	struct list_head pending_alter; /* pending single-sop operations */
+					/* that alter the semaphore */
+	struct list_head pending_const; /* pending single-sop operations */
+					/* that do not alter the semaphore*/
 };
 
 /* One queue for each sleeping process in the system. */
@@ -150,12 +153,15 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
- * linked list protection:
+ * Locking:
  *	sem_undo.id_next,
- *	sem_array.sem_pending{,last},
- *	sem_array.sem_undo: sem_lock() for read/write
+ *	sem_array.complex_present,
+ *	sem_array.pending{_alter,_cont},
+ *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
  *	
+ *	sem_array.sem_base[i].pending_{const,alter}:
+ *		global or semaphore sem_lock() for read/write
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -196,9 +202,9 @@ void __init sem_init (void)
  * multiple semaphores in our own semops, or we need to look at
  * semaphores from other pending complex operations.
  *
- * Carefully guard against sma->complex_count changing between zero
+ * Carefully guard against sma->complex_present changing between zero
  * and non-zero while we are spinning for the lock. The value of
- * sma->complex_count cannot change while we are holding the lock,
+ * sma->complex_present cannot change while we are holding the lock,
  * so sem_unlock should be fine.
  *
  * The global lock path checks that all the local locks have been released,
@@ -210,17 +216,17 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 {
 	int locknum;
  again:
-	if (nsops == 1 && !sma->complex_count) {
+	if (nsops == 1 && !sma->complex_present) {
 		struct sem *sem = sma->sem_base + sops->sem_num;
 
 		/* Lock just the semaphore we are interested in. */
 		spin_lock(&sem->lock);
 
 		/*
-		 * If sma->complex_count was set while we were spinning,
+		 * If sma->complex_present was set while we were spinning,
 		 * we may need to look at things we did not lock here.
 		 */
-		if (unlikely(sma->complex_count)) {
+		if (unlikely(sma->complex_present)) {
 			spin_unlock(&sem->lock);
 			goto lock_array;
 		}
@@ -256,9 +262,28 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 	return locknum;
 }
 
+/**
+ * update_complex_present - set complex_present
+ * @sma: semaphore array
+ *
+ * The function checks that the complex_count field is set properly.
+ * It is called prior to dropping the global semaphore array lock.
+ *
+ */
+
+static void update_complex_present(struct sem_array *sma)
+{
+	if (list_empty(&sma->pending_const) && list_empty(&sma->pending_alter))
+		sma->complex_present = 0;
+	else
+		sma->complex_present = 1;
+}
+
+
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
+		update_complex_present(sma);
 		spin_unlock(&sma->sem_perm.lock);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -337,7 +362,7 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  * Without the check/retry algorithm a lockless wakeup is possible:
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
- *	* unlinking the queue entry from sma->sem_pending
+ *	* unlinking the queue entry from the pending list
  *	* setting queue.status to IN_WAKEUP
  *	  This is the notification for the blocked thread that a
  *	  result value is imminent.
@@ -418,12 +443,14 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	sma->sem_base = (struct sem *) &sma[1];
 
 	for (i = 0; i < nsems; i++) {
-		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+		INIT_LIST_HEAD(&sma->sem_base[i].pending_alter);
+		INIT_LIST_HEAD(&sma->sem_base[i].pending_const);
 		spin_lock_init(&sma->sem_base[i].lock);
 	}
 
-	sma->complex_count = 0;
-	INIT_LIST_HEAD(&sma->sem_pending);
+	sma->complex_present = 0;
+	INIT_LIST_HEAD(&sma->pending_alter);
+	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
@@ -482,12 +509,19 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/*
- * Determine whether a sequence of semaphore operations would succeed
- * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
+/** perform_atomic_semop - Perform (if possible) a semaphore operation
+ * @sma: semaphore array
+ * @sops: array with operations that should be checked
+ * @nsems: number of sops
+ * @un: undo array
+ * @pid: pid that did the change
+ *
+ * Returns 0 if the operation was possible.
+ * Returns 1 if the operation is impossible, the caller must sleep.
+ * Negative values are error codes.
  */
 
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
+static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
 	int result, sem_op;
@@ -598,8 +632,6 @@ static void wake_up_sem_queue_do(struct list_head *pt)
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 {
 	list_del(&q->list);
-	if (q->nsops > 1)
-		sma->complex_count--;
 }
 
 /** check_restart(sma, q)
@@ -609,60 +641,131 @@ static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
  * update_queue is O(N^2) when it restarts scanning the whole queue of
  * waiting operations. Therefore this function checks if the restart is
  * really necessary. It is called after a previously waiting operation
- * was completed.
+ * modified the array.
+ * Note that wait-for-zero operations are handled without restart.
  */
 static int check_restart(struct sem_array *sma, struct sem_queue *q)
 {
-	struct sem *curr;
-	struct sem_queue *h;
-
-	/* if the operation didn't modify the array, then no restart */
-	if (q->alter == 0)
-		return 0;
-
 	/* pending complex operations are too difficult to analyse */
-	if (sma->complex_count)
+	if (!list_empty(&sma->pending_alter))
 		return 1;
 
 	/* we were a sleeping complex operation. Too difficult */
 	if (q->nsops > 1)
 		return 1;
 
-	curr = sma->sem_base + q->sops[0].sem_num;
+	/* It is impossible that someone waits for the new value:
+	 * - complex operations always restart.
+	 * - wait-for-zero are handled seperately.
+	 * - q is a previously sleeping simple operation that
+	 *   altered the array. It must be a decrement, because
+	 *   simple increments never sleep.
+	 * - If there are older (higher priority) decrements
+	 *   in the queue, then they have observed the original
+	 *   semval value and couldn't proceed. The operation
+	 *   decremented to value - thus they won't proceed either.
+	 */
 
-	/* No-one waits on this queue */
-	if (list_empty(&curr->sem_pending))
-		return 0;
+	return 0;
+}
+
+/**
+ * wake_const_ops(sma, semnum, pt) - Wake up non-alter tasks
+ * @sma: semaphore array.
+ * @semnum: semaphore that was modified.
+ * @pt: list head for the tasks that must be woken up.
+ *
+ * update_queue must be called after a semaphore in a semaphore array
+ * was set to 0. If complex const operations are pending, wake_const_ops must
+ * be called with semnum = -1, as well as with the number of each modified
+ * semaphore.
+ * The tasks that must be woken up are added to @pt. The return code
+ * is stored in q->pid.
+ * The function returns 1 if at least one operation was completed successfully.
+ */
+static int wake_const_ops(struct sem_array *sma, int semnum,
+				struct list_head *pt)
+{
+	struct sem_queue *q;
+	struct list_head *walk;
+	struct list_head *pending_list;
+	int semop_completed = 0;
+
+	if (semnum == -1)
+		pending_list = &sma->pending_const;
+	else
+		pending_list = &sma->sem_base[semnum].pending_const;
+
+	walk = pending_list->next;
+	while (walk != pending_list) {
+		int error;
+
+		q = container_of(walk, struct sem_queue, list);
+		walk = walk->next;
+
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
+					 q->undo, q->pid);
+
+		if (error <= 0) {
+			/* operation completed, remove from queue & wakeup */
+
+			unlink_queue(sma, q);
+
+			wake_up_sem_queue_prepare(pt, q, error);
+			if (error == 0)
+				semop_completed = 1;
+		}
+	}
+	return semop_completed;
+}
+
+/**
+ * do_smart_wakeup_zero(sma, sops, nsops, pt) - wakeup all wait for zero tasks
+ * @sma: semaphore array
+ * @sops: operations that were performed
+ * @nsops: number of operations
+ * @pt: list head of the tasks that must be woken up.
+ *
+ * do_smart_wakeup_zero() checks all required queue for wait-for-zero
+ * operations, based on the actual changes that were performed on the
+ * semaphore array.
+ * The function returns 1 if at least one operation was completed successfully.
+ */
+static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
+					int nsops, struct list_head *pt)
+{
+	int i;
+	int semop_completed = 0;
+	int got_zero = 0;
+
+	/* first: the per-semaphore queues, if known */
+	if (sops) {
+		for (i = 0; i < nsops; i++) {
+			int num = sops[i].sem_num;
 
-	/* the new semaphore value */
-	if (curr->semval) {
-		/* It is impossible that someone waits for the new value:
-		 * - q is a previously sleeping simple operation that
-		 *   altered the array. It must be a decrement, because
-		 *   simple increments never sleep.
-		 * - The value is not 0, thus wait-for-zero won't proceed.
-		 * - If there are older (higher priority) decrements
-		 *   in the queue, then they have observed the original
-		 *   semval value and couldn't proceed. The operation
-		 *   decremented to value - thus they won't proceed either.
+			if (sma->sem_base[num].semval == 0) {
+				got_zero = 1;
+				semop_completed |= wake_const_ops(sma, num, pt);
+			}
+		}
+	} else {
+		/*
+		 * No sops means modified semaphores not known.
+		 * Assume all were changed.
 		 */
-		BUG_ON(q->sops[0].sem_op >= 0);
-		return 0;
+		for (i = 0; i < sma->sem_nsems; i++) {
+			if (sma->sem_base[i].semval == 0)
+				semop_completed |= wake_const_ops(sma, i, pt);
+		}
 	}
 	/*
-	 * semval is 0. Check if there are wait-for-zero semops.
-	 * They must be the first entries in the per-semaphore queue
+	 * If one of the modified semaphores got 0,
+	 * then check the global queue, too.
 	 */
-	h = list_first_entry(&curr->sem_pending, struct sem_queue, list);
-	BUG_ON(h->nsops != 1);
-	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
-
-	/* Yes, there is a wait-for-zero semop. Restart */
-	if (h->sops[0].sem_op == 0)
-		return 1;
+	if (got_zero)
+		semop_completed |= wake_const_ops(sma, -1, pt);
 
-	/* Again - no-one is waiting for the new value. */
-	return 0;
+	return semop_completed;
 }
 
 
@@ -678,6 +781,8 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * semaphore.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
+ * The function internally checks if const operations can now succeed.
+ *
  * The function return 1 if at least one semop was completed successfully.
  */
 static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
@@ -688,48 +793,47 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 	int semop_completed = 0;
 
 	if (semnum == -1)
-		pending_list = &sma->sem_pending;
+		pending_list = &sma->pending_alter;
 	else
-		pending_list = &sma->sem_base[semnum].sem_pending;
+		pending_list = &sma->sem_base[semnum].pending_alter;
 
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
-		int error, restart;
+		int error;
 
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
 		/* If we are scanning the single sop, per-semaphore list of
 		 * one semaphore and that semaphore is 0, then it is not
-		 * necessary to scan the "alter" entries: simple increments
+		 * necessary to scan further: simple increments
 		 * that affect only one entry succeed immediately and cannot
-		 * be in the  per semaphore pending queue, and decrements
+		 * be in the per semaphore pending queue, and decrements
 		 * cannot be successful if the value is already 0.
 		 */
-		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
-				q->alter)
+		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
-		/* Does q->sleeper still need to sleep? */
-		if (error > 0)
-			continue;
+		if (error <= 0) {
+			/* the operation was performed */
 
-		unlink_queue(sma, q);
+			unlink_queue(sma, q);
+			wake_up_sem_queue_prepare(pt, q, error);
 
-		if (error) {
-			restart = 0;
-		} else {
-			semop_completed = 1;
-			restart = check_restart(sma, q);
-		}
+			if (!error) {
+				semop_completed = 1;
 
-		wake_up_sem_queue_prepare(pt, q, error);
-		if (restart)
-			goto again;
+				do_smart_wakeup_zero(sma, q->sops,
+							q->nsops, pt);
+
+				if (check_restart(sma, q))
+					goto again;
+			}
+		}
 	}
 	return semop_completed;
 }
@@ -742,40 +846,48 @@ again:
  * @otime: force setting otime
  * @pt: list head of the tasks that must be woken up.
  *
- * do_smart_update() does the required called to update_queue, based on the
- * actual changes that were performed on the semaphore array.
+ * do_smart_update() does the required calls to update_queue and wakeup_zero,
+ * based on the actual changes that were performed on the semaphore array.
  * Note that the function does not do the actual wake-up: the caller is
  * responsible for calling wake_up_sem_queue_do(@pt).
  * It is safe to perform this call after dropping all locks.
  */
-static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
-			int otime, struct list_head *pt)
+static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int
+				nsops, int otime, struct list_head *pt)
 {
 	int i;
 
-	if (sma->complex_count || sops == NULL) {
-		if (update_queue(sma, -1, pt))
-			otime = 1;
-	}
+	otime |= do_smart_wakeup_zero(sma, sops, nsops, pt);
 
-	if (!sops) {
-		/* No semops; something special is going on. */
-		for (i = 0; i < sma->sem_nsems; i++) {
-			if (update_queue(sma, i, pt))
-				otime = 1;
+	if (!list_empty(&sma->pending_alter)) {
+		/* semaphore array uses the global queue - just process it. */
+		otime |= update_queue(sma, -1, pt);
+	} else {
+		if (!sops) {
+			/*
+			 * No sops, thus the modified semaphores are not
+			 * known. Check all.
+			 */
+			for (i = 0; i < sma->sem_nsems; i++)
+				otime |= update_queue(sma, i, pt);
+		} else {
+			/*
+			 * Check the semaphores that were increased:
+			 * - No complex ops, thus all sleeping ops are
+			 *   decrease.
+			 * - if we decreased the value, then any sleeping
+			 *   semaphore ops wont be able to run: If the
+			 *   previous value was too small, then the new
+			 *   value will be too small, too.
+			 */
+			for (i = 0; i < nsops; i++) {
+				if (sops[i].sem_op > 0) {
+					otime |= update_queue(sma,
+							sops[i].sem_num, pt);
+				}
+			}
 		}
-		goto done;
 	}
-
-	/* Check the semaphores that were modified. */
-	for (i = 0; i < nsops; i++) {
-		if (sops[i].sem_op > 0 ||
-			(sops[i].sem_op < 0 &&
-				sma->sem_base[sops[i].sem_num].semval == 0))
-			if (update_queue(sma, sops[i].sem_num, pt))
-				otime = 1;
-	}
-done:
 	if (otime)
 		sma->sem_otime = get_seconds();
 }
@@ -796,14 +908,14 @@ static int count_semncnt (struct sem_array * sma, ushort semnum)
 	struct sem_queue * q;
 
 	semncnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+	list_for_each_entry(q, &sma->sem_base[semnum].pending_alter, list) {
 		struct sembuf * sops = q->sops;
 		BUG_ON(sops->sem_num != semnum);
 		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
 			semncnt++;
 	}
 
-	list_for_each_entry(q, &sma->sem_pending, list) {
+	list_for_each_entry(q, &sma->pending_alter, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -822,14 +934,14 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	struct sem_queue * q;
 
 	semzcnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+	list_for_each_entry(q, &sma->sem_base[semnum].pending_const, list) {
 		struct sembuf * sops = q->sops;
 		BUG_ON(sops->sem_num != semnum);
 		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
 			semzcnt++;
 	}
 
-	list_for_each_entry(q, &sma->sem_pending, list) {
+	list_for_each_entry(q, &sma->pending_const, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -867,13 +979,22 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	INIT_LIST_HEAD(&tasks);
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
+	list_for_each_entry_safe(q, tq, &sma->pending_const, list) {
+		unlink_queue(sma, q);
+		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+	}
+
+	list_for_each_entry_safe(q, tq, &sma->pending_alter, list) {
 		unlink_queue(sma, q);
 		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 	}
 	for (i = 0; i < sma->sem_nsems; i++) {
 		struct sem *sem = sma->sem_base + i;
-		list_for_each_entry_safe(q, tq, &sem->sem_pending, list) {
+		list_for_each_entry_safe(q, tq, &sem->pending_const, list) {
+			unlink_queue(sma, q);
+			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		}
+		list_for_each_entry_safe(q, tq, &sem->pending_alter, list) {
 			unlink_queue(sma, q);
 			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 		}
@@ -1516,6 +1637,25 @@ static int get_queue_result(struct sem_queue *q)
 	return error;
 }
 
+/**
+ * merge_lists - Merge single semop queues into global queue
+ * @sma: semaphore array
+ *
+ * This function merges all per-semaphore queues into the global queue.
+ * It is necessary to achieve FIFO ordering for the pending single-sop
+ * operations when global operations arrive.
+ * Only the alter operations must be moved, the const operations can stay.
+ */
+
+static void merge_lists(struct sem_array *sma)
+{
+	int i;
+	for (i = 0; i < sma->sem_nsems; i++) {
+		struct sem *sem = sma->sem_base + i;
+
+		list_splice_init(&sem->pending_alter, &sma->pending_alter);
+	}
+}
 
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
@@ -1614,7 +1754,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = perform_atomic_semop(sma, sops, nsops, un,
+					task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
 			do_smart_update(sma, sops, nsops, 1, &tasks);
@@ -1636,16 +1777,27 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
 
-		if (alter)
-			list_add_tail(&queue.list, &curr->sem_pending);
-		else
-			list_add(&queue.list, &curr->sem_pending);
+		if (alter) {
+			if (sma->complex_present) {
+				list_add_tail(&queue.list,
+						&sma->pending_alter);
+			} else {
+				list_add_tail(&queue.list,
+						&curr->pending_alter);
+			}
+		} else {
+			list_add_tail(&queue.list, &curr->pending_const);
+		}
 	} else {
+		if (!sma->complex_present)
+			merge_lists(sma);
+
 		if (alter)
-			list_add_tail(&queue.list, &sma->sem_pending);
+			list_add_tail(&queue.list, &sma->pending_alter);
 		else
-			list_add(&queue.list, &sma->sem_pending);
-		sma->complex_count++;
+			list_add_tail(&queue.list, &sma->pending_const);
+
+		sma->complex_present = 1;
 	}
 
 	queue.status = -EINTR;
