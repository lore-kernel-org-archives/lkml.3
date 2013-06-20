Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3FTJGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:06:11 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54165 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTJGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:06:07 -0400
Date: Thu, 20 Jun 2013 11:06:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130620090601.GA6812@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 29bb9e5a75684106a37593ad75ec75ff8312731b tracing/context-tracking: Add preempt_schedule_context() for tracing

Two smaller fixes - plus a context tracking tracing fix that is a bit 
bigger.

 Thanks,

	Ingo

------------------>
Andrew Jones (1):
      sched/x86: Construct all sibling maps if smt

Steven Rostedt (1):
      tracing/context-tracking: Add preempt_schedule_context() for tracing

Vincent Guittot (1):
      sched: Fix clear NOHZ_BALANCE_KICK


 arch/x86/kernel/smpboot.c |  8 ++++----
 include/linux/preempt.h   | 18 +++++++++++++++++-
 kernel/context_tracking.c | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c       | 21 +++++++++++++++++----
 4 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51..bfd348e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -372,15 +372,15 @@ static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
-	bool has_mc = boot_cpu_data.x86_max_cores > 1;
 	bool has_smt = smp_num_siblings > 1;
+	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct cpuinfo_x86 *o;
 	int i;
 
 	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
-	if (!has_smt && !has_mc) {
+	if (!has_mp) {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
@@ -394,7 +394,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_smt && match_smt(c, o)))
 			link_mask(sibling, cpu, i);
 
-		if ((i == cpu) || (has_mc && match_llc(c, o)))
+		if ((i == cpu) || (has_mp && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
 
 	}
@@ -406,7 +406,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
-		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+		if ((i == cpu) || (has_mp && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 
 			/*
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 87a03c7..f5d4723 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -33,9 +33,25 @@ do { \
 		preempt_schedule(); \
 } while (0)
 
+#ifdef CONFIG_CONTEXT_TRACKING
+
+void preempt_schedule_context(void);
+
+#define preempt_check_resched_context() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule_context(); \
+} while (0)
+#else
+
+#define preempt_check_resched_context() preempt_check_resched()
+
+#endif /* CONFIG_CONTEXT_TRACKING */
+
 #else /* !CONFIG_PREEMPT */
 
 #define preempt_check_resched()		do { } while (0)
+#define preempt_check_resched_context()	do { } while (0)
 
 #endif /* CONFIG_PREEMPT */
 
@@ -88,7 +104,7 @@ do { \
 do { \
 	preempt_enable_no_resched_notrace(); \
 	barrier(); \
-	preempt_check_resched(); \
+	preempt_check_resched_context(); \
 } while (0)
 
 #else /* !CONFIG_PREEMPT_COUNT */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..6667700 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -71,6 +71,46 @@ void user_enter(void)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_PREEMPT
+/**
+ * preempt_schedule_context - preempt_schedule called by tracing
+ *
+ * The tracing infrastructure uses preempt_enable_notrace to prevent
+ * recursion and tracing preempt enabling caused by the tracing
+ * infrastructure itself. But as tracing can happen in areas coming
+ * from userspace or just about to enter userspace, a preempt enable
+ * can occur before user_exit() is called. This will cause the scheduler
+ * to be called when the system is still in usermode.
+ *
+ * To prevent this, the preempt_enable_notrace will use this function
+ * instead of preempt_schedule() to exit user context if needed before
+ * calling the scheduler.
+ */
+void __sched notrace preempt_schedule_context(void)
+{
+	struct thread_info *ti = current_thread_info();
+	enum ctx_state prev_ctx;
+
+	if (likely(ti->preempt_count || irqs_disabled()))
+		return;
+
+	/*
+	 * Need to disable preemption in case user_exit() is traced
+	 * and the tracer calls preempt_enable_notrace() causing
+	 * an infinite recursion.
+	 */
+	preempt_disable_notrace();
+	prev_ctx = exception_enter();
+	preempt_enable_no_resched_notrace();
+
+	preempt_schedule();
+
+	preempt_disable_notrace();
+	exception_exit(prev_ctx);
+	preempt_enable_notrace();
+}
+EXPORT_SYMBOL_GPL(preempt_schedule_context);
+#endif /* CONFIG_PREEMPT */
 
 /**
  * user_exit - Inform the context tracking that the CPU is
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..919bee6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -633,7 +633,19 @@ void wake_up_nohz_cpu(int cpu)
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
-	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+
+	if (!test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+		return false;
+
+	if (idle_cpu(cpu) && !need_resched())
+		return true;
+
+	/*
+	 * We can't run Idle Load Balance on this CPU for this time so we
+	 * cancel it and clear NOHZ_BALANCE_KICK
+	 */
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+	return false;
 }
 
 #else /* CONFIG_NO_HZ_COMMON */
@@ -1393,8 +1405,9 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
-	    && !tick_nohz_full_cpu(smp_processor_id()))
+	if (llist_empty(&this_rq()->wake_list)
+			&& !tick_nohz_full_cpu(smp_processor_id())
+			&& !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1417,7 +1430,7 @@ void scheduler_ipi(void)
 	/*
 	 * Check if someone kicked us for doing the nohz idle load balance.
 	 */
-	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
+	if (unlikely(got_nohz_idle_kick())) {
 		this_rq()->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	}
