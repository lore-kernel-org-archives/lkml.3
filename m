Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JCN07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:26:59 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61866 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3JCN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:26:58 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH v2] ipc/sem.c: synchronize semop and semctl with IPC_RMID
Date: Thu,  3 Oct 2013 15:26:46 +0200
Message-Id: <1380806806-3722-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After acquiring the semlock spinlock, operations must test that the
array is still valid.

- semctl() and exit_sem() would walk stale linked lists (ugly, but should
  be ok: all lists are empty)

- semtimedop() would sleep forever - and if woken up due to a signal -
  access memory after free.

The patch also:
- standardizes the tests for .deleted, so that all tests in one
  function leave the function with the same approach.
- unconditionally tests for .deleted immediately after every call to
  sem_lock - even it it means that for semctl(GETALL), .deleted will be
  tested twice.

Both changes make the review simpler: After every sem_lock, there must
be a test of .deleted, followed by a goto to the cleanup code (if the
function uses "goto cleanup").
The only exception is semctl_down(): If sem_ids().rwsem is locked, then
the presence in ids->ipcs_idr is equivalent to !.deleted, thus no additional
test is required.

Davidlohr: What do you think?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 8c4f59b..db9d241 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1282,6 +1282,12 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 
 	sem_lock(sma, NULL, -1);
 
+	if (sma->sem_perm.deleted) {
+		sem_unlock(sma, -1);
+		rcu_read_unlock();
+		return -EIDRM;
+	}
+
 	curr = &sma->sem_base[semnum];
 
 	ipc_assert_locked_object(&sma->sem_perm);
@@ -1336,12 +1342,14 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 
 		sem_lock(sma, NULL, -1);
+		if (sma->sem_perm.deleted) {
+			err = -EIDRM;
+			goto out_unlock;
+		}
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
@@ -1354,10 +1362,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			rcu_read_lock();
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma, -1);
-				rcu_read_unlock();
 				err = -EIDRM;
-				goto out_free;
+				goto out_unlock;
 			}
 		}
 		for (i = 0; i < sma->sem_nsems; i++)
@@ -1375,8 +1381,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		struct sem_undo *un;
 
 		if (!ipc_rcu_getref(sma)) {
-			rcu_read_unlock();
-			return -EIDRM;
+			err = -EIDRM;
+			goto out_rcu_wakeup;
 		}
 		rcu_read_unlock();
 
@@ -1404,10 +1410,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
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
@@ -1431,6 +1435,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		goto out_rcu_wakeup;
 
 	sem_lock(sma, NULL, -1);
+	if (sma->sem_perm.deleted) {
+		err = -EIDRM;
+		goto out_unlock;
+	}
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1836,6 +1844,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (error)
 		goto out_rcu_wakeup;
 
+	error = -EIDRM;
+	locknum = sem_lock(sma, sops, nsops);
+	if (sma->sem_perm.deleted)
+		goto out_unlock_free;
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
@@ -1843,8 +1855,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * This case can be detected checking un->semid. The existence of
 	 * "un" itself is guaranteed by rcu.
 	 */
-	error = -EIDRM;
-	locknum = sem_lock(sma, sops, nsops);
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
@@ -2057,6 +2067,12 @@ void exit_sem(struct task_struct *tsk)
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

