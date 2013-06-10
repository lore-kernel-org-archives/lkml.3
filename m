Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3FJRRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:17:31 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48352 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3FJRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:17:24 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 6/6] ipc/sem.c: Rename try_atomic_semop() to perform_atomic_semop(), docu update
Date: Mon, 10 Jun 2013 19:16:51 +0200
Message-Id: <1370884611-3861-7-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370884611-3861-6-git-send-email-manfred@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-2-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-3-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-4-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-5-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-6-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup: Some minor points that I noticed while writing the
previous patches

1) The name try_atomic_semop() is misleading: The function performs the
   operation (if it is possible).

2) Some documentation updates.

No real code change, a rename and documentation changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index e6d21f6..f9d1c06 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -154,12 +154,15 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
- * linked list protection:
+ * Locking:
  *	sem_undo.id_next,
+ *	sem_array.complex_count,
  *	sem_array.pending{_alter,_cont},
- *	sem_array.sem_undo: sem_lock() for read/write
+ *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
  *	
+ *	sem_array.sem_base[i].pending_{const,alter}:
+ *		global or semaphore sem_lock() for read/write
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -536,12 +539,19 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
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
@@ -724,8 +734,8 @@ static int wake_const_ops(struct sem_array *sma, int semnum,
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
-						q->undo, q->pid);
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
+						 q->undo, q->pid);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -836,7 +846,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
@@ -1680,7 +1690,6 @@ static int get_queue_result(struct sem_queue *q)
 	return error;
 }
 
-
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1778,7 +1787,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = perform_atomic_semop(sma, sops, nsops, un,
+					task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
 			do_smart_update(sma, sops, nsops, 1, &tasks);
-- 
1.8.1.4

