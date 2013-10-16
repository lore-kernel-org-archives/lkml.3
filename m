Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386Ab3JPSOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:14:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761421Ab3JPRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 46/69] ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), docu update
Date: Wed, 16 Oct 2013 10:44:55 -0700
Message-Id: <20131016174318.525572384@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit 758a6ba39ef6df4cdc615e5edd7bd86eab81a5f7 upstream.

Cleanup: Some minor points that I noticed while writing the previous
patches

1) The name try_atomic_semop() is misleading: The function performs the
   operation (if it is possible).

2) Some documentation updates.

No real code change, a rename and documentation changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -154,12 +154,15 @@ static int sysvipc_sem_proc_show(struct
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
@@ -536,12 +539,19 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
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
@@ -724,8 +734,8 @@ static int wake_const_ops(struct sem_arr
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
-						q->undo, q->pid);
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
+						 q->undo, q->pid);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -838,7 +848,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
@@ -1686,7 +1696,6 @@ static int get_queue_result(struct sem_q
 	return error;
 }
 
-
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1784,7 +1793,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = perform_atomic_semop(sma, sops, nsops, un,
+					task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
 			do_smart_update(sma, sops, nsops, 1, &tasks);


