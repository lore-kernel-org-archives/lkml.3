Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307Ab3DDV7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:59:39 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34197 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760606Ab3DDV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:59:38 -0400
Date: Tue, 26 Mar 2013 16:00:59 -0400
From: Rik van Riel <riel@surriel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -mm -next] ipc,sem: untangle RCU locking with
 find_alloc_undo
Message-ID: <20130326160059.7b466a8d@annuminas.surriel.com>
In-Reply-To: <5151E3D2.1070103@oracle.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5151DBD3.6080201@oracle.com>
	<1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>
	<5151E3D2.1070103@oracle.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 14:07:14 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> > Not necessarily, we do release everything at the end of the function: 
> >     out_unlock_free:
> > 	sem_unlock(sma, locknum);
> 
> Ow, there's a rcu_read_unlock() in sem_unlock()? This complicates things even
> more I suspect. If un is non-NULL we'll be unlocking rcu lock twice?

Sasha, this patch should resolve the RCU tangle, by making sure
we only ever take the rcu_read_lock once in semtimedop.

---8<---

The ipc semaphore code has a nasty RCU locking tangle, with both
find_alloc_undo and semtimedop taking the rcu_read_lock(). The
code can be cleaned up somewhat by only taking the rcu_read_lock
once.

There are no other callers to find_alloc_undo.

This should also solve the trinity issue reported by Sasha Levin.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index f46441a..2ec2945 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1646,22 +1646,23 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 			alter = 1;
 	}
 
+	INIT_LIST_HEAD(&tasks);
+
 	if (undos) {
+		/* On success, find_alloc_undo takes the rcu_read_lock */
 		un = find_alloc_undo(ns, semid);
 		if (IS_ERR(un)) {
 			error = PTR_ERR(un);
 			goto out_free;
 		}
-	} else
+	} else {
 		un = NULL;
+		rcu_read_lock();
+	}
 
-	INIT_LIST_HEAD(&tasks);
-
-	rcu_read_lock();
 	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma)) {
-		if (un)
-			rcu_read_unlock();
+		rcu_read_unlock();
 		error = PTR_ERR(sma);
 		goto out_free;
 	}
@@ -1693,22 +1694,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 */
 	error = -EIDRM;
 	locknum = sem_lock(sma, sops, nsops);
-	if (un) {
-		if (un->semid == -1) {
-			rcu_read_unlock();
-			goto out_unlock_free;
-		} else {
-			/*
-			 * rcu lock can be released, "un" cannot disappear:
-			 * - sem_lock is acquired, thus IPC_RMID is
-			 *   impossible.
-			 * - exit_sem is impossible, it always operates on
-			 *   current (or a dead task).
-			 */
-
-			rcu_read_unlock();
-		}
-	}
+	if (un && un->semid == -1)
+		goto out_unlock_free;
 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
