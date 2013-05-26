Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab3EZJKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:10:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57772 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3EZJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:10:24 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 4/4] ipc/sem.c: Rename try_atomic_semop() to perform_atomic_semop(), docu update
Date: Sun, 26 May 2013 11:08:55 +0200
Message-Id: <1369559335-13491-5-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final cleanup: Some minor points that I noticed while writing the
previous 3 patches

1) The name try_atomic_semop() is misleading: The function performs the
   operation (if it is possible).

2) Some documentation updates.

No real code change, a rename and documentation changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 9ed3853..1dbb2fa 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -153,12 +153,15 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
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
@@ -535,12 +538,19 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
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
@@ -723,8 +733,8 @@ static int wake_const_ops(struct sem_array *sma, int semnum,
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
-						q->undo, q->pid);
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
+						 q->undo, q->pid);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -835,7 +845,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
@@ -1658,7 +1668,6 @@ static int get_queue_result(struct sem_queue *q)
 	return error;
 }
 
-
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1756,7 +1765,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
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

