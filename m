Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3C1U1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:27:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab3C1U1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:27:10 -0400
Date: Thu, 28 Mar 2013 16:23:37 -0400
From: Rik van Riel <riel@surriel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 -mm -next] ipc,sem: fix lockdep false positive
Message-ID: <20130328162337.3003ccd4@cuia.bos.redhat.com>
In-Reply-To: <1364373750.5053.54.camel@laptop>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	<1364303965.5053.29.camel@laptop>
	<CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	<1364308023.5053.40.camel@laptop>
	<5151BC78.3030306@surriel.com>
	<1364373750.5053.54.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 09:42:30 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> I since realized there's an ordering problem with ->global_locked, we
> need to use spin_is_locked() or somesuch.
> 
> Two competing sma_lock() operations will screw over the separate
> variable.

I created a worse version of the stress test, one that will have
the first thread always do two semops at a time (creating a complex
operation), and have all the other threads do one at a time. All
the threads issue down and then up, so there is a lot of sleeping
and waking back up with this test.

The patch below should fix the last lockdep issue (the other issue
being fixed by the RCU patch), and is running the various semop
tests just fine on a 48 CPU system.

The locking is a little more complicated than I would have liked,
but a few hundred million semaphore operations suggest there are
probably no race conditions left...

---8<---

Subject: [PATCH -mm -next] ipc,sem: change locking scheme to make lockdep happy

Unfortunately the locking scheme originally proposed has false positives
with lockdep.  This can be fixed by changing the code to only ever take
one lock, and making sure that other relevant locks are not locked, before
entering a critical section.

For the "global lock" case, this is done by taking the sem_array lock,
and then (potentially) waiting for all the semaphore's spinlocks to be
unlocked.

For the "local lock" case, we wait on the sem_array's lock to be free,
before taking the semaphore local lock. To prevent races, we need to
check again after we have taken the local lock.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |   55 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 36500a6..87b74d5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -320,24 +320,39 @@ void __init sem_init (void)
 }
 
 /*
- * If the sem_array contains just one semaphore, or if multiple
- * semops are performed in one syscall, or if there are complex
- * operations pending, the whole sem_array is locked.
- * If one semop is performed on an array with multiple semaphores,
- * get a shared lock on the array, and lock the individual semaphore.
+ * If the request contains only one semaphore operation, and there are
+ * no complex transactions pending, lock only the semaphore involved.
+ * Otherwise, lock the entire semaphore array, since we either have
+ * multiple semaphores in our own semops, or we need to look at
+ * semaphores from other pending complex operations.
  *
  * Carefully guard against sma->complex_count changing between zero
  * and non-zero while we are spinning for the lock. The value of
  * sma->complex_count cannot change while we are holding the lock,
  * so sem_unlock should be fine.
+ *
+ * The global lock path checks that all the local locks have been released,
+ * checking each local lock once. This means that the local lock paths
+ * cannot start their critical sections while the global lock is held.
  */
 static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 			      int nsops)
 {
 	int locknum;
+ again:
 	if (nsops == 1 && !sma->complex_count) {
 		struct sem *sem = sma->sem_base + sops->sem_num;
 
+		/*
+		 * Another process is holding the global lock on the
+		 * sem_array. Wait for that process to release the lock,
+		 * before acquiring our lock.
+		 */
+		if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
+			spin_unlock_wait(&sma->sem_perm.lock);
+			goto again;
+		}
+
 		/* Lock just the semaphore we are interested in. */
 		spin_lock(&sem->lock);
 
@@ -347,17 +362,33 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		 */
 		if (unlikely(sma->complex_count)) {
 			spin_unlock(&sem->lock);
-			goto lock_all;
+			goto lock_array;
+		}
+
+		/*
+		 * Another process is holding the global lock on the
+		 * sem_array; we cannot enter our critical section,
+		 * but have to wait for the global lock to be released.
+		 */
+		if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
+			spin_unlock(&sem->lock);
+			goto again;
 		}
+
 		locknum = sops->sem_num;
 	} else {
 		int i;
-		/* Lock the sem_array, and all the semaphore locks */
- lock_all:
+		/*
+		 * Lock the semaphore array, and wait for all of the
+		 * individual semaphore locks to go away.  The code
+		 * above ensures no new single-lock holders will enter
+		 * their critical section while the array lock is held.
+		 */
+ lock_array:
 		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
-			spin_lock(&sem->lock);
+			spin_unlock_wait(&sem->lock);
 		}
 		locknum = -1;
 	}
@@ -367,11 +398,6 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
-		int i;
-		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem *sem = sma->sem_base + i;
-			spin_unlock(&sem->lock);
-		}
 		spin_unlock(&sma->sem_perm.lock);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -558,7 +584,6 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
 		spin_lock_init(&sma->sem_base[i].lock);
-		spin_lock(&sma->sem_base[i].lock);
 	}
 
 	sma->complex_count = 0;
