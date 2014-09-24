Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIXI1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaIXI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:18 -0400
Message-Id: <20140924082242.656559952@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/11] sched: Exclude cond_resched() from nested sleep test
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep-cond_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cond_resched() is a preemption point, not strictly a blocking
primitive, so exclude it from the ->state test.

In particular, preemption preserves task_struct::state.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/kernel.h |    3 +++
 include/linux/sched.h  |    6 +++---
 kernel/sched/core.c    |   12 +++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -162,6 +162,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+  void ___might_sleep(const char *file, int line, int preempt_offset);
   void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
@@ -177,6 +178,8 @@ extern int _cond_resched(void);
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 # define fixup_sleep()	__set_current_state(TASK_RUNNING)
 #else
+  static inline void ___might_sleep(const char *file, int line,
+				   int preempt_offset) { }
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2787,7 +2787,7 @@ static inline int signal_pending_state(l
 extern int _cond_resched(void);
 
 #define cond_resched() ({			\
-	__might_sleep(__FILE__, __LINE__, 0);	\
+	___might_sleep(__FILE__, __LINE__, 0);	\
 	_cond_resched();			\
 })
 
@@ -2800,14 +2800,14 @@ extern int __cond_resched_lock(spinlock_
 #endif
 
 #define cond_resched_lock(lock) ({				\
-	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
 	__cond_resched_lock(lock);				\
 })
 
 extern int __cond_resched_softirq(void);
 
 #define cond_resched_softirq() ({					\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	___might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
 	__cond_resched_softirq();					\
 })
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7141,8 +7141,6 @@ static inline int preempt_count_equals(i
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
-	static unsigned long prev_jiffy;	/* ratelimiting */
-
 	/*
 	 * Blocking primitives will set (and therefore destroy) current->state,
 	 * since we will exit with TASK_RUNNING make sure we enter with it,
@@ -7156,6 +7154,14 @@ void __might_sleep(const char *file, int
 			(void *)current->task_state_change))
 		__set_current_state(TASK_RUNNING);
 
+	___might_sleep(file, line, preempt_offset);
+}
+EXPORT_SYMBOL(__might_sleep);
+
+void ___might_sleep(const char *file, int line, int preempt_offset)
+{
+	static unsigned long prev_jiffy;	/* ratelimiting */
+
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
 	     !is_idle_task(current)) ||
@@ -7185,7 +7191,7 @@ void __might_sleep(const char *file, int
 #endif
 	dump_stack();
 }
-EXPORT_SYMBOL(__might_sleep);
+EXPORT_SYMBOL(___might_sleep);
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ


