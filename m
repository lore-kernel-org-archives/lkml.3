Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3CTUPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:15:50 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38946 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3CTUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:44 -0400
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@surriel.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 6/7] ipc,sem: have only one list in struct sem_queue
Date: Wed, 20 Mar 2013 15:55:36 -0400
Message-Id: <1363809337-29718-7-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having only one list in struct sem_queue, and only queueing simple
semaphore operations on the list for the semaphore involved, allows
us to introduce finer grained locking for semtimedop.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |   65 +++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index d25f9b6..468e2c1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -99,7 +99,6 @@ struct sem {
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-	struct list_head	simple_list; /* queue of pending operations */
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
@@ -517,7 +516,7 @@ static void wake_up_sem_queue_prepare(struct list_head *pt,
 	q->status = IN_WAKEUP;
 	q->pid = error;
 
-	list_add_tail(&q->simple_list, pt);
+	list_add_tail(&q->list, pt);
 }
 
 /**
@@ -535,7 +534,7 @@ static void wake_up_sem_queue_do(struct list_head *pt)
 	int did_something;
 
 	did_something = !list_empty(pt);
-	list_for_each_entry_safe(q, t, pt, simple_list) {
+	list_for_each_entry_safe(q, t, pt, list) {
 		wake_up_process(q->sleeper);
 		/* q can disappear immediately after writing q->status. */
 		smp_wmb();
@@ -548,9 +547,7 @@ static void wake_up_sem_queue_do(struct list_head *pt)
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 {
 	list_del(&q->list);
-	if (q->nsops == 1)
-		list_del(&q->simple_list);
-	else
+	if (q->nsops > 1)
 		sma->complex_count--;
 }
 
@@ -603,9 +600,9 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
 	}
 	/*
 	 * semval is 0. Check if there are wait-for-zero semops.
-	 * They must be the first entries in the per-semaphore simple queue
+	 * They must be the first entries in the per-semaphore queue
 	 */
-	h = list_first_entry(&curr->sem_pending, struct sem_queue, simple_list);
+	h = list_first_entry(&curr->sem_pending, struct sem_queue, list);
 	BUG_ON(h->nsops != 1);
 	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
 
@@ -625,8 +622,9 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * @pt: list head for the tasks that must be woken up.
  *
  * update_queue must be called after a semaphore in a semaphore array
- * was modified. If multiple semaphore were modified, then @semnum
- * must be set to -1.
+ * was modified. If multiple semaphores were modified, update_queue must
+ * be called with semnum = -1, as well as with the number of each modified
+ * semaphore.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
  * The function return 1 if at least one semop was completed successfully.
@@ -636,30 +634,19 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
-	int offset;
 	int semop_completed = 0;
 
-	/* if there are complex operations around, then knowing the semaphore
-	 * that was modified doesn't help us. Assume that multiple semaphores
-	 * were modified.
-	 */
-	if (sma->complex_count)
-		semnum = -1;
-
-	if (semnum == -1) {
+	if (semnum == -1)
 		pending_list = &sma->sem_pending;
-		offset = offsetof(struct sem_queue, list);
-	} else {
+	else
 		pending_list = &sma->sem_base[semnum].sem_pending;
-		offset = offsetof(struct sem_queue, simple_list);
-	}
 
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
 		int error, restart;
 
-		q = (struct sem_queue *)((char *)walk - offset);
+		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
 		/* If we are scanning the single sop, per-semaphore list of
@@ -718,9 +705,18 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 	if (sma->complex_count || sops == NULL) {
 		if (update_queue(sma, -1, pt))
 			otime = 1;
+	}
+
+	if (!sops) {
+		/* No semops; something special is going on. */
+		for (i = 0; i < sma->sem_nsems; i++) {
+			if (update_queue(sma, i, pt))
+				otime = 1;
+		}
 		goto done;
 	}
 
+	/* Check the semaphores that were modified. */
 	for (i = 0; i < nsops; i++) {
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
@@ -791,6 +787,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 	struct list_head tasks;
+	int i;
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -809,6 +806,13 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		unlink_queue(sma, q);
 		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 	}
+	for (i = 0; i < sma->sem_nsems; i++) {
+		struct sem *sem = sma->sem_base + i;
+		list_for_each_entry_safe(q, tq, &sem->sem_pending, list) {
+			unlink_queue(sma, q);
+			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		}
+	}
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
@@ -1532,21 +1536,20 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
 	queue.alter = alter;
-	if (alter)
-		list_add_tail(&queue.list, &sma->sem_pending);
-	else
-		list_add(&queue.list, &sma->sem_pending);
 
 	if (nsops == 1) {
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
 
 		if (alter)
-			list_add_tail(&queue.simple_list, &curr->sem_pending);
+			list_add_tail(&queue.list, &curr->sem_pending);
 		else
-			list_add(&queue.simple_list, &curr->sem_pending);
+			list_add(&queue.list, &curr->sem_pending);
 	} else {
-		INIT_LIST_HEAD(&queue.simple_list);
+		if (alter)
+			list_add_tail(&queue.list, &sma->sem_pending);
+		else
+			list_add(&queue.list, &sma->sem_pending);
 		sma->complex_count++;
 	}
 
-- 
1.7.7.6

