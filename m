Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967946Ab3DSI6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:58:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab3DSI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:57:59 -0400
Date: Fri, 19 Apr 2013 01:57:17 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-41fcb9f230bf773656d1768b73000ef720bf00c3@git.kernel.org>
Cc: mingo@kernel.org, williams@redhat.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        scott.norton@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        davidlohr.bueso@hp.com, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, williams@redhat.com, peterz@infradead.org,
        riel@redhat.com, Waiman.Long@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, davidlohr.bueso@hp.com, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, aswin@hp.com
In-Reply-To: <1366226594-5506-2-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-2-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Move mutex spinning code from sched/
 core.c back to mutex.c
Git-Commit-ID: 41fcb9f230bf773656d1768b73000ef720bf00c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Apr 2013 01:57:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41fcb9f230bf773656d1768b73000ef720bf00c3
Gitweb:     http://git.kernel.org/tip/41fcb9f230bf773656d1768b73000ef720bf00c3
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Wed, 17 Apr 2013 15:23:11 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Apr 2013 09:33:34 +0200

mutex: Move mutex spinning code from sched/core.c back to mutex.c

As mentioned by Ingo, the SCHED_FEAT_OWNER_SPIN scheduler
feature bit was really just an early hack to make with/without
mutex-spinning testable. So it is no longer necessary.

This patch removes the SCHED_FEAT_OWNER_SPIN feature bit and
move the mutex spinning code from kernel/sched/core.c back to
kernel/mutex.c which is where they should belong.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chandramouleeswaran Aswin <aswin@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Norton Scott J <scott.norton@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366226594-5506-2-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   |  1 -
 kernel/mutex.c          | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c     | 45 ---------------------------------------------
 kernel/sched/features.h |  7 -------
 4 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..aefe45d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -320,7 +320,6 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 52f2301..262d717 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -95,6 +95,52 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+/*
+ * Mutex spinning code migrated from kernel/sched/core.c
+ */
+
+static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
+{
+	if (lock->owner != owner)
+		return false;
+
+	/*
+	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
+	 * lock->owner still matches owner, if that fails, owner might
+	 * point to free()d memory, if it still matches, the rcu_read_lock()
+	 * ensures the memory stays valid.
+	 */
+	barrier();
+
+	return owner->on_cpu;
+}
+
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+static noinline
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
+{
+	rcu_read_lock();
+	while (owner_running(lock, owner)) {
+		if (need_resched())
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+	rcu_read_unlock();
+
+	/*
+	 * We break out the loop above on need_resched() and when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when lock->owner is NULL.
+	 */
+	return lock->owner == NULL;
+}
+#endif
+
 static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..b37a22b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2997,51 +2997,6 @@ void __sched schedule_preempt_disabled(void)
 	preempt_disable();
 }
 
-#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-
-static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
-{
-	if (lock->owner != owner)
-		return false;
-
-	/*
-	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
-	 * lock->owner still matches owner, if that fails, owner might
-	 * point to free()d memory, if it still matches, the rcu_read_lock()
-	 * ensures the memory stays valid.
-	 */
-	barrier();
-
-	return owner->on_cpu;
-}
-
-/*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
- */
-int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
-{
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
-
-	rcu_read_lock();
-	while (owner_running(lock, owner)) {
-		if (need_resched())
-			break;
-
-		arch_mutex_cpu_relax();
-	}
-	rcu_read_unlock();
-
-	/*
-	 * We break out the loop above on need_resched() and when the
-	 * owner changed, which is a sign for heavy contention. Return
-	 * success only when lock->owner is NULL.
-	 */
-	return lock->owner == NULL;
-}
-#endif
-
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 1ad1d2b..99399f8 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -46,13 +46,6 @@ SCHED_FEAT(DOUBLE_TICK, false)
 SCHED_FEAT(LB_BIAS, true)
 
 /*
- * Spin-wait on mutex acquisition when the mutex owner is running on
- * another cpu -- assumes that when the owner is running, it will soon
- * release the lock. Decreases scheduling overhead.
- */
-SCHED_FEAT(OWNER_SPIN, true)
-
-/*
  * Decrement CPU power based on time not spent running tasks
  */
 SCHED_FEAT(NONTASK_POWER, true)
