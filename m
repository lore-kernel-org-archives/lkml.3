Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989Ab3GLNcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:32:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab3GLNcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:32:48 -0400
Date: Fri, 12 Jul 2013 06:29:29 -0700
From: tip-bot for Michel Lespinasse <tipbot@zytor.com>
Message-ID: <tip-c4be9cb4f19cbd534a6c4c334cd48d8bb483e17a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, paulmck@us.ibm.com, ak@linux.intel.com,
        tglx@linutronix.de, oleg@redhat.com, walken@google.com,
        laijs@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@us.ibm.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, ak@linux.intel.com,
        oleg@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        walken@google.com
In-Reply-To: <20130708212352.1769031C15E@corp2gmr1-1.hot.corp.google.com>
References: <20130708212352.1769031C15E@corp2gmr1-1.hot.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lglock:
  Update lockdep annotations to report recursive local locks
Git-Commit-ID: c4be9cb4f19cbd534a6c4c334cd48d8bb483e17a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4be9cb4f19cbd534a6c4c334cd48d8bb483e17a
Gitweb:     http://git.kernel.org/tip/c4be9cb4f19cbd534a6c4c334cd48d8bb483e17a
Author:     Michel Lespinasse <walken@google.com>
AuthorDate: Mon, 8 Jul 2013 14:23:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 13:51:19 +0200

lglock: Update lockdep annotations to report recursive local locks

Oleg Nesterov recently noticed that the lockdep annotations in lglock.c
are not sufficient to detect some obvious deadlocks, such as
lg_local_lock(LOCK) + lg_local_lock(LOCK) or spin_lock(X) +
lg_local_lock(Y) vs lg_local_lock(Y) + spin_lock(X).

Both issues are easily fixed by indicating to lockdep that lglock's local
locks are not recursive.  We shouldn't use the rwlock acquire/release
functions here, as lglock doesn't share the same semantics.  Instead we
can base our lockdep annotations on the lock_acquire_shared (for local
lglock) and lock_acquire_exclusive (for global lglock) helpers.

I am not proposing new lglock specific helpers as I don't see the point of
the existing second level of helpers :)

Noticed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130708212352.1769031C15E@corp2gmr1-1.hot.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lglock.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/lglock.c b/kernel/lglock.c
index 6535a66..86ae2ae 100644
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
