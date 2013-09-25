Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3IYQjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3IYQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:39:02 -0400
Date: Wed, 25 Sep 2013 09:38:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-orxrbycjozopqfhb4dxdkdvb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Introduce preempt_count accessor functions
Git-Commit-ID: 4a2b4b222743bb07fedf985b884550f2ca067ea9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:38:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a2b4b222743bb07fedf985b884550f2ca067ea9
Gitweb:     http://git.kernel.org/tip/4a2b4b222743bb07fedf985b884550f2ca067ea9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 Aug 2013 14:55:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:32 +0200

sched: Introduce preempt_count accessor functions

Replace the single preempt_count() 'function' that's an lvalue with
two proper functions:

 preempt_count() - returns the preempt_count value as rvalue
 preempt_count_set() - Allows setting the preempt-count value

Also provide preempt_count_ptr() as a convenience wrapper to implement
all modifying operations.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-orxrbycjozopqfhb4dxdkdvb@git.kernel.org
[ Fixed build failure. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/preempt.h | 25 +++++++++++++++++++------
 init/main.c             |  2 +-
 kernel/sched/core.c     |  4 ++--
 kernel/softirq.c        |  4 ++--
 kernel/timer.c          |  8 ++++----
 lib/locking-selftest.c  |  2 +-
 lib/smp_processor_id.c  |  3 +--
 7 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index f5d4723..eaac52a 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,19 +10,32 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
+static __always_inline int preempt_count(void)
+{
+	return current_thread_info()->preempt_count;
+}
+
+static __always_inline int *preempt_count_ptr(void)
+{
+	return &current_thread_info()->preempt_count;
+}
+
+static __always_inline void preempt_count_set(int pc)
+{
+	*preempt_count_ptr() = pc;
+}
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_preempt_count(val)	do { *preempt_count_ptr() += (val); } while (0)
+# define sub_preempt_count(val)	do { *preempt_count_ptr() -= (val); } while (0)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
-
 #ifdef CONFIG_PREEMPT
 
 asmlinkage void preempt_schedule(void);
@@ -81,9 +94,9 @@ do { \
 
 /* For debugging and tracer internals only! */
 #define add_preempt_count_notrace(val)			\
-	do { preempt_count() += (val); } while (0)
+	do { *preempt_count_ptr() += (val); } while (0)
 #define sub_preempt_count_notrace(val)			\
-	do { preempt_count() -= (val); } while (0)
+	do { *preempt_count_ptr() -= (val); } while (0)
 #define inc_preempt_count_notrace() add_preempt_count_notrace(1)
 #define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
 
diff --git a/init/main.c b/init/main.c
index af310af..7cc4b78 100644
--- a/init/main.c
+++ b/init/main.c
@@ -692,7 +692,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
 
 	if (preempt_count() != count) {
 		sprintf(msgbuf, "preemption imbalance ");
-		preempt_count() = count;
+		preempt_count_set(count);
 	}
 	if (irqs_disabled()) {
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 242da0c..fe89afa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2219,7 +2219,7 @@ void __kprobes add_preempt_count(int val)
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	preempt_count() += val;
+	add_preempt_count_notrace(val);
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -2250,7 +2250,7 @@ void __kprobes sub_preempt_count(int val)
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	preempt_count() -= val;
+	sub_preempt_count_notrace(val);
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 53cc09c..a90de70 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -106,7 +106,7 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	preempt_count() += cnt;
+	add_preempt_count_notrace(cnt);
 	/*
 	 * Were softirqs turned off above:
 	 */
@@ -256,7 +256,7 @@ restart:
 				       " exited with %08x?\n", vec_nr,
 				       softirq_to_name[vec_nr], h->action,
 				       prev_count, preempt_count());
-				preempt_count() = prev_count;
+				preempt_count_set(prev_count);
 			}
 
 			rcu_bh_qs(cpu);
diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..6582b82 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1092,7 +1092,7 @@ static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 			  unsigned long data)
 {
-	int preempt_count = preempt_count();
+	int count = preempt_count();
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1119,16 +1119,16 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 
 	lock_map_release(&lockdep_map);
 
-	if (preempt_count != preempt_count()) {
+	if (count != preempt_count()) {
 		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
-			  fn, preempt_count, preempt_count());
+			  fn, count, preempt_count());
 		/*
 		 * Restore the preempt count. That gives us a decent
 		 * chance to survive and extract information. If the
 		 * callback kept a lock held, bad luck, but not worse
 		 * than the BUG() we had.
 		 */
-		preempt_count() = preempt_count;
+		preempt_count_set(count);
 	}
 }
 
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 6dc09d8..872a15a 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1002,7 +1002,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	 * Some tests (e.g. double-unlock) might corrupt the preemption
 	 * count, so restore it:
 	 */
-	preempt_count() = saved_preempt_count;
+	preempt_count_set(saved_preempt_count);
 #ifdef CONFIG_TRACE_IRQFLAGS
 	if (softirq_count())
 		current->softirqs_enabled = 0;
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..04abe53 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -9,10 +9,9 @@
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
 
-	if (likely(preempt_count))
+	if (likely(preempt_count()))
 		goto out;
 
 	if (irqs_disabled())
