Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3I3JOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:14:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45539 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3I3JN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:13:59 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: synchronize semop and semctl with IPC_RMID
Date: Mon, 30 Sep 2013 11:13:43 +0200
Message-Id: <1380532423-19613-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After acquiring the semlock spinlock, the operations must test that the
array is still valid.

- semctl() and exit_sem() would walk stale linked lists (ugly, but should
  be ok: all lists are empty)

- semtimedop() would sleep forever - and if woken up due to a signal -
  access memory after free.

The patch standardizes the tests for .deleted, so that all tests in one
function leave the function with the same approach.

Right now, it's a mixture of "goto cleanup", some cleanup and then
"goto further_cleanup" and all cleanup+"return -EIDRM" - that makes the
review much harder.

Davidlohr: Could you please review the patch?
I did some stress test, but probably I didn't hit exactly the modified
lines.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 19c8b98..a2fa795 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1229,6 +1229,12 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 
 	sem_lock(sma, NULL, -1);
 
+	if (sma->sem_perm.deleted) {
+		sem_unlock(sma, -1);
+		rcu_read_unlock();
+		return -EIDRM;
+	}
+
 	curr = &sma->sem_base[semnum];
 
 	ipc_assert_locked_object(&sma->sem_perm);
@@ -1285,10 +1291,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		sem_lock(sma, NULL, -1);
 		if(nsems > SEMMSL_FAST) {
 			if (!ipc_rcu_getref(sma)) {
-				sem_unlock(sma, -1);
-				rcu_read_unlock();
 				err = -EIDRM;
-				goto out_free;
+				goto out_unlock;
 			}
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
@@ -1301,10 +1305,13 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			rcu_read_lock();
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma, -1);
-				rcu_read_unlock();
 				err = -EIDRM;
-				goto out_free;
+				goto out_unlock;
+			}
+		} else {
+			if (sma->sem_perm.deleted) {
+				err = -EIDRM;
+				goto out_unlock;
 			}
 		}
 		for (i = 0; i < sma->sem_nsems; i++)
@@ -1322,8 +1329,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		struct sem_undo *un;
 
 		if (!ipc_rcu_getref(sma)) {
-			rcu_read_unlock();
-			return -EIDRM;
+			err = -EIDRM;
+			goto out_rcu_wakeup;
 		}
 		rcu_read_unlock();
 
@@ -1351,10 +1358,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		rcu_read_lock();
 		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma, -1);
-			rcu_read_unlock();
 			err = -EIDRM;
-			goto out_free;
+			goto out_unlock;
 		}
 
 		for (i = 0; i < nsems; i++)
@@ -1378,6 +1383,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		goto out_rcu_wakeup;
 
 	sem_lock(sma, NULL, -1);
+	if (sma->sem_perm.deleted) {
+		err = -EIDRM;
+		goto out_unlock;
+	}
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1783,6 +1792,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (error)
 		goto out_rcu_wakeup;
 
+	error = -EIDRM;
+	locknum = sem_lock(sma, sops, nsops);
+	if (sma->sem_perm.deleted)
+		goto out_unlock_free;
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
@@ -1790,8 +1803,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * This case can be detected checking un->semid. The existence of
 	 * "un" itself is guaranteed by rcu.
 	 */
-	error = -EIDRM;
-	locknum = sem_lock(sma, sops, nsops);
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
@@ -1999,6 +2010,12 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		sem_lock(sma, NULL, -1);
+		/* exit_sem raced with IPC_RMID, nothing to do */
+		if (sma->sem_perm.deleted) {
+			sem_unlock(sma, -1);
+			rcu_read_unlock();
+			continue;
+		}
 		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
-- 
1.8.3.1

