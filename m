Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbbAFTqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:46:01 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:54770 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbbAFTp6 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 14:45:58 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 5/6] locking: Use [READ,ASSIGN]_ONCE() for non-scalar types
Date: Tue,  6 Jan 2015 11:45:08 -0800
Message-Id: <1420573509-24774-6-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145).

Change the generic locking code to replace ACCESS_ONCE with the
new calls. I guess everyone will eventually have to update, so
lets see what happens; we also become the first users of ASSIGN_ONCE.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
---
 kernel/locking/mcs_spinlock.h | 6 +++---
 kernel/locking/mutex.c        | 8 ++++----
 kernel/locking/osq_lock.c     | 8 ++++----
 kernel/locking/rwsem-xadd.c   | 4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index d1fe2ba..903009a 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -78,7 +78,7 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		 */
 		return;
 	}
-	ACCESS_ONCE(prev->next) = node;
+	ASSIGN_ONCE(node, prev->next);
 
 	/* Wait until the lock holder passes the lock down. */
 	arch_mcs_spin_lock_contended(&node->locked);
@@ -91,7 +91,7 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 static inline
 void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
-	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
+	struct mcs_spinlock *next = READ_ONCE(node->next);
 
 	if (likely(!next)) {
 		/*
@@ -100,7 +100,7 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		if (likely(cmpxchg(lock, node, NULL) == node))
 			return;
 		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
+		while (!(next = READ_ONCE(node->next)))
 			cpu_relax_lowlatency();
 	}
 
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 2ac48e0..0082705 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -269,7 +269,7 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 		return 0;
 
 	rcu_read_lock();
-	owner = ACCESS_ONCE(lock->owner);
+	owner = READ_ONCE(lock->owner);
 	if (owner)
 		retval = owner->on_cpu;
 	rcu_read_unlock();
@@ -343,7 +343,7 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 			 * As such, when deadlock detection needs to be
 			 * performed the optimistic spinning cannot be done.
 			 */
-			if (ACCESS_ONCE(ww->ctx))
+			if (READ_ONCE(ww->ctx))
 				break;
 		}
 
@@ -351,7 +351,7 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		owner = ACCESS_ONCE(lock->owner);
+		owner = READ_ONCE(lock->owner);
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
@@ -490,7 +490,7 @@ static inline int __sched
 __ww_mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
-	struct ww_acquire_ctx *hold_ctx = ACCESS_ONCE(ww->ctx);
+	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
 
 	if (!hold_ctx)
 		return 0;
diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index ec83d4d..9c6e251 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -98,7 +98,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 
 	prev = decode_cpu(old);
 	node->prev = prev;
-	ACCESS_ONCE(prev->next) = node;
+	ASSIGN_ONCE(node, prev->next);
 
 	/*
 	 * Normally @prev is untouchable after the above store; because at that
@@ -148,7 +148,7 @@ unqueue:
 		 * Or we race against a concurrent unqueue()'s step-B, in which
 		 * case its step-C will write us a new @node->prev pointer.
 		 */
-		prev = ACCESS_ONCE(node->prev);
+		prev = READ_ONCE(node->prev);
 	}
 
 	/*
@@ -170,8 +170,8 @@ unqueue:
 	 * it will wait in Step-A.
 	 */
 
-	ACCESS_ONCE(next->prev) = prev;
-	ACCESS_ONCE(prev->next) = next;
+	ASSIGN_ONCE(prev, next->prev);
+	ASSIGN_ONCE(next, prev->next);
 
 	return false;
 }
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 7628c3f..2e651f6 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -294,7 +294,7 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 		return false;
 
 	rcu_read_lock();
-	owner = ACCESS_ONCE(sem->owner);
+	owner = READ_ONCE(sem->owner);
 	if (owner)
 		on_cpu = owner->on_cpu;
 	rcu_read_unlock();
@@ -359,7 +359,7 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 		goto done;
 
 	while (true) {
-		owner = ACCESS_ONCE(sem->owner);
+		owner = READ_ONCE(sem->owner);
 		if (owner && !rwsem_spin_on_owner(sem, owner))
 			break;
 
-- 
2.1.2

