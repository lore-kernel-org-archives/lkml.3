Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaAOAdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:33:47 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45456 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaAOAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:33:42 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Subject: [RFC 3/3] mutex: When there is no owner, stop spinning after too many tries
Date: Tue, 14 Jan 2014 16:33:10 -0800
Message-Id: <1389745990-7069-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running workloads that have high contention in mutexes on an 8 socket
machine, spinners would often spin for a long time with no lock owner.

One of the potential reasons for this is because a thread can be preempted
after clearing lock->owner but before releasing the lock, or preempted after
acquiring the mutex but before setting lock->owner. In those cases, the
spinner cannot check if owner is not on_cpu because lock->owner is NULL.

A solution that would address the preemption part of this problem would
be to disable preemption between acquiring/releasing the mutex and
setting/clearing the lock->owner. However, that will require adding overhead
to the mutex fastpath.

The solution used in this patch is to limit the # of times thread can spin on
lock->count when !owner.

The threshold used in this patch for each spinner was 128, which appeared to
be a generous value, but any suggestions on another method to determine
the threshold are welcomed.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index b500cc7..9465604 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -43,6 +43,7 @@
  * mutex.
  */
 #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
+#define	MUTEX_SPIN_THRESHOLD		(128)
 
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
@@ -418,7 +419,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
-	int ret;
+	int ret, nr_spins = 0;
 	struct mspin_node node;
 
 	preempt_disable();
@@ -453,6 +454,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	mspin_lock(MLOCK(lock), &node);
 	for (;;) {
 		struct task_struct *owner;
+		nr_spins++;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -502,9 +504,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * When there's no owner, we might have preempted between the
 		 * owner acquiring the lock and setting the owner field. If
 		 * we're an RT task that will live-lock because we won't let
-		 * the owner complete.
+		 * the owner complete. Additionally, when there is no owner,
+		 * stop spinning after too many tries.
 		 */
-		if (!owner && (need_resched() || rt_task(task))) {
+		if (!owner && (need_resched() || rt_task(task) ||
+		               nr_spins > MUTEX_SPIN_THRESHOLD)) {
 			mspin_unlock(MLOCK(lock), &node);
 			goto slowpath;
 		}
-- 
1.7.1

