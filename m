Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3LFNyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:54:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3LFNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Manfred Spraul <manfred@colorfullife.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/272] ipc/sem.c: synchronize semop and semctl with IPC_RMID
Date: Fri,  6 Dec 2013 12:56:30 +0000
Message-Id: <1386334761-25517-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit 6e224f94597842c5eb17f1fc2208d20b6f7f7d49 upstream.

After acquiring the semlock spinlock, operations must test that the
array is still valid.

 - semctl() and exit_sem() would walk stale linked lists (ugly, but
   should be ok: all lists are empty)

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
the presence in ids->ipcs_idr is equivalent to !.deleted, thus no
additional test is required.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 ipc/sem.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 8e2bf30..3d9a8af 100644
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
1.8.3.2

