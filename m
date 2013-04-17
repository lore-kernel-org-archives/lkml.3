Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719Ab3DQTYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:24:18 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33372 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab3DQTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:23:40 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v4 1/4] mutex: Move mutex spinning code from sched/core.c back to mutex.c
Date: Wed, 17 Apr 2013 15:23:11 -0400
Message-Id: <1366226594-5506-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Ingo, the SCHED_FEAT_OWNER_SPIN scheduler feature
bit was really just an early hack to make with/without mutex-spinning
testable. So it is no longer necessary.

This patch removes the SCHED_FEAT_OWNER_SPIN feature bit and move the
mutex spinning code from kernel/sched/core.c back to kernel/mutex.c
which is where they should belong.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/sched.h   |    1 -
 kernel/mutex.c          |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c     |   45 ---------------------------------------------
 kernel/sched/features.h |    7 -------
 4 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..2d02c76 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -321,7 +321,6 @@ extern signed long schedule_timeout_killable(signed long timeout);
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
index 67d0465..4205354 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2999,51 +2999,6 @@ void __sched schedule_preempt_disabled(void)
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
-- 
1.7.1

