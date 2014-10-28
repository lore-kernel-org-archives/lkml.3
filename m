Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaJ1LNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:13:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaJ1LNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:13:18 -0400
Date: Tue, 28 Oct 2014 04:12:15 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-3427445afd26bd2395f29241319283a93f362cd0@git.kernel.org>
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, jbaron@akamai.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        alex.elder@linaro.org, davej@redhat.com, torvalds@linux-foundation.org,
        axel.lin@ingics.com, dborkman@redhat.com, tglx@linutronix.de
Reply-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, peterz@infradead.org,
        mingo@kernel.org, jbaron@akamai.com, hpa@zytor.com,
        alex.elder@linaro.org, dborkman@redhat.com, tglx@linutronix.de,
        axel.lin@ingics.com, davej@redhat.com, torvalds@linux-foundation.org
In-Reply-To: <20140924082242.656559952@infradead.org>
References: <20140924082242.656559952@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Exclude cond_resched()
  from nested sleep test
Git-Commit-ID: 3427445afd26bd2395f29241319283a93f362cd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3427445afd26bd2395f29241319283a93f362cd0
Gitweb:     http://git.kernel.org/tip/3427445afd26bd2395f29241319283a93f362cd0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:57 +0100

sched: Exclude cond_resched() from nested sleep test

cond_resched() is a preemption point, not strictly a blocking
primitive, so exclude it from the ->state test.

In particular, preemption preserves task_struct::state.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: oleg@redhat.com
Cc: Alex Elder <alex.elder@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140924082242.656559952@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kernel.h |  3 +++
 include/linux/sched.h  |  6 +++---
 kernel/sched/core.c    | 12 +++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5068a0d..446d76a 100644
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
 # define sched_annotate_sleep()	__set_current_state(TASK_RUNNING)
 #else
+  static inline void ___might_sleep(const char *file, int line,
+				   int preempt_offset) { }
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4648e07..4400ddc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2806,7 +2806,7 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 extern int _cond_resched(void);
 
 #define cond_resched() ({			\
-	__might_sleep(__FILE__, __LINE__, 0);	\
+	___might_sleep(__FILE__, __LINE__, 0);	\
 	_cond_resched();			\
 })
 
@@ -2819,14 +2819,14 @@ extern int __cond_resched_lock(spinlock_t *lock);
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
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5b4b96b..b9f78f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7296,8 +7296,6 @@ static inline int preempt_count_equals(int preempt_offset)
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
-	static unsigned long prev_jiffy;	/* ratelimiting */
-
 	/*
 	 * Blocking primitives will set (and therefore destroy) current->state,
 	 * since we will exit with TASK_RUNNING make sure we enter with it,
@@ -7311,6 +7309,14 @@ void __might_sleep(const char *file, int line, int preempt_offset)
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
@@ -7340,7 +7346,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 #endif
 	dump_stack();
 }
-EXPORT_SYMBOL(__might_sleep);
+EXPORT_SYMBOL(___might_sleep);
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
