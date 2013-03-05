Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab3CECRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:17:33 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:55434 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab3CECRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:17:31 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] lglock: update lockdep annotations to report recursive local locks
Date: Mon,  4 Mar 2013 18:17:25 -0800
Message-Id: <1362449845-7492-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362449845-7492-1-git-send-email-walken@google.com>
References: <1362449845-7492-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov recently noticed that the lockdep annotations in lglock.c
are not sufficient to detect some obvious deadlocks, such as
lg_local_lock(LOCK) + lg_local_lock(LOCK) or
spin_lock(X) + lg_local_lock(Y) vs lg_local_lock(Y) + spin_lock(X).

Both issues are easily fixed by indicating to lockdep that lglock's local
locks are not recursive. We shouldn't use the rwlock acquire/release
functions here, as lglock doesn't share the same semantics. Instead
we can base our lockdep annotations on the lock_acquire_shared
(for local lglock) and lock_acquire_exclusive (for global lglock)
helpers.

I am not proposing new lglock specific helpers as I don't see the point
of the existing second level of helpers :)

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 kernel/lglock.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/lglock.c b/kernel/lglock.c
index 6535a667a5a7..86ae2aebf004 100644
--- a/kernel/lglock.c
+++ b/kernel/lglock.c
@@ -21,7 +21,7 @@ void lg_local_lock(struct lglock *lg)
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_lock(lock);
 }
@@ -31,7 +31,7 @@ void lg_local_unlock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -43,7 +43,7 @@ void lg_local_lock_cpu(struct lglock *lg, int cpu)
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_lock(lock);
 }
@@ -53,7 +53,7 @@ void lg_local_unlock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -65,7 +65,7 @@ void lg_global_lock(struct lglock *lg)
 	int i;
 
 	preempt_disable();
-	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
@@ -78,7 +78,7 @@ void lg_global_unlock(struct lglock *lg)
 {
 	int i;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
-- 
1.8.1.3
