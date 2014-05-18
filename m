Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaERH7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:59:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34474 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaERH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:58:57 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 4/6] ipc/sem.c: Change perform_atomic_semop parameters
Date: Sun, 18 May 2014 09:58:35 +0200
Message-Id: <1400399917-17583-5-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-2-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, perform_atomic_semop gets the content of sem_queue as individual
fields.
Changes that, instead pass a pointer to sem_queue.

This is a preparation for the next patch: it uses
sem_queue to store the reason why a task must sleep.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 95d5bc5..7b1585d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -585,21 +585,23 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 /**
  * perform_atomic_semop - Perform (if possible) a semaphore operation
  * @sma: semaphore array
- * @sops: array with operations that should be checked
- * @nsops: number of operations
- * @un: undo array
- * @pid: pid that did the change
+ * @q: struct sem_queue that describes the operation
  *
  * Returns 0 if the operation was possible.
  * Returns 1 if the operation is impossible, the caller must sleep.
  * Negative values are error codes.
  */
-static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
-			     int nsops, struct sem_undo *un, int pid)
+static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
 {
-	int result, sem_op;
+	int result, sem_op, nsops, pid;
 	struct sembuf *sop;
 	struct sem *curr;
+	struct sembuf *sops;
+	struct sem_undo *un;
+
+	sops = q->sops;
+	nsops = q->nsops;
+	un = q->undo;
 
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = sma->sem_base + sop->sem_num;
@@ -627,6 +629,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 	}
 
 	sop--;
+	pid = q->pid;
 	while (sop >= sops) {
 		sma->sem_base[sop->sem_num].sempid = pid;
 		sop--;
@@ -779,8 +782,7 @@ static int wake_const_ops(struct sem_array *sma, int semnum,
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = perform_atomic_semop(sma, q->sops, q->nsops,
-						 q->undo, q->pid);
+		error = perform_atomic_semop(sma, q);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -892,8 +894,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = perform_atomic_semop(sma, q->sops, q->nsops,
-					 q->undo, q->pid);
+		error = perform_atomic_semop(sma, q);
 
 		/* Does q->sleeper still need to sleep? */
 		if (error > 0)
@@ -1871,8 +1872,13 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
-	error = perform_atomic_semop(sma, sops, nsops, un,
-					task_tgid_vnr(current));
+	queue.sops = sops;
+	queue.nsops = nsops;
+	queue.undo = un;
+	queue.pid = task_tgid_vnr(current);
+	queue.alter = alter;
+
+	error = perform_atomic_semop(sma, &queue);
 	if (error == 0) {
 		/* If the operation was successful, then do
 		 * the required updates.
@@ -1889,12 +1895,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * task into the pending queue and go to sleep.
 	 */
 
-	queue.sops = sops;
-	queue.nsops = nsops;
-	queue.undo = un;
-	queue.pid = task_tgid_vnr(current);
-	queue.alter = alter;
-
 	if (nsops == 1) {
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
-- 
1.9.0

