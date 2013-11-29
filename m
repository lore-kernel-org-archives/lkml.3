Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3K2Rsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:48:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50498 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2Rsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:38 -0500
Message-Id: <20131129174430.222164799@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:37:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 7/7] sched: Use a static_key for sched_clock_stable
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-sched_clock_static_key.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid the runtime condition check turn sched_clock_stable
into a static_key.

Also provide a shorter implementation of local_clock() and
cpu_clock(int) when sched_clock_stable==1.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/amd.c        |    2 -
 arch/x86/kernel/cpu/intel.c      |    2 -
 arch/x86/kernel/cpu/perf_event.c |    2 -
 arch/x86/kernel/tsc.c            |    6 ++---
 include/linux/sched.h            |    4 ++-
 kernel/sched/clock.c             |   41 ++++++++++++++++++++++++++++++++-------
 kernel/sched/debug.c             |    2 -
 kernel/time/tick-sched.c         |    2 -
 kernel/trace/ring_buffer.c       |    2 -
 9 files changed, 46 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -487,7 +487,7 @@ static void early_init_amd(struct cpuinf
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 #ifdef CONFIG_X86_64
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -93,7 +93,7 @@ static void early_init_intel(struct cpui
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1898,7 +1898,7 @@ void arch_perf_update_userpage(struct pe
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	do {
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -786,7 +786,7 @@ static unsigned long long cyc2ns_suspend
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -806,7 +806,7 @@ void tsc_restore_sched_clock_state(void)
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	local_irq_save(flags);
@@ -948,7 +948,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		sched_clock_stable = 0;
+		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
 		pr_info("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1880,7 +1880,9 @@ static inline void sched_clock_idle_wake
  * but then during bootup it turns out that sched_clock()
  * is reliable after all:
  */
-extern int sched_clock_stable;
+extern int sched_clock_stable(void);
+extern void set_sched_clock_stable(void);
+extern void clear_sched_clock_stable(void);
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -58,6 +58,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/static_key.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -74,7 +75,27 @@ EXPORT_SYMBOL_GPL(sched_clock);
 __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-__read_mostly int sched_clock_stable;
+static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+
+int sched_clock_stable(void)
+{
+	if (static_key_false(&__sched_clock_stable))
+		return false;
+	return true;
+}
+
+void set_sched_clock_stable(void)
+{
+	if (!sched_clock_stable())
+		static_key_slow_inc(&__sched_clock_stable);
+}
+
+void clear_sched_clock_stable(void)
+{
+	/* XXX worry about clock continuity */
+	if (sched_clock_stable())
+		static_key_slow_dec(&__sched_clock_stable);
+}
 
 struct sched_clock_data {
 	u64			tick_raw;
@@ -236,7 +257,7 @@ u64 sched_clock_cpu(int cpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return sched_clock();
 
 	if (unlikely(!sched_clock_running))
@@ -257,7 +278,7 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd;
 	u64 now, now_gtod;
 
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return;
 
 	if (unlikely(!sched_clock_running))
@@ -308,7 +329,10 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeu
  */
 u64 cpu_clock(int cpu)
 {
-	return sched_clock_cpu(cpu);
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(cpu);
+
+	return sched_clock();
 }
 
 /*
@@ -320,7 +344,10 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	return sched_clock_cpu(smp_processor_id());
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(smp_processor_id());
+
+	return sched_clock();
 }
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
@@ -340,12 +367,12 @@ u64 sched_clock_cpu(int cpu)
 
 u64 cpu_clock(int cpu)
 {
-	return sched_clock_cpu(cpu);
+	return sched_clock();
 }
 
 u64 local_clock(void)
 {
-	return sched_clock_cpu(0);
+	return sched_clock();
 }
 
 #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -371,7 +371,7 @@ static void sched_debug_header(struct se
 	PN(cpu_clk);
 	P(jiffies);
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-	P(sched_clock_stable);
+	P(sched_clock_stable());
 #endif
 #undef PN
 #undef P
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -177,7 +177,7 @@ static bool can_stop_full_tick(void)
 	 * TODO: kick full dynticks CPUs when
 	 * sched_clock_stable is set.
 	 */
-	if (!sched_clock_stable) {
+	if (!sched_clock_stable()) {
 		trace_tick_stop(0, "unstable sched clock\n");
 		/*
 		 * Don't allow the user to think they can get
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2558,7 +2558,7 @@ rb_reserve_next_event(struct ring_buffer
 		if (unlikely(test_time_stamp(delta))) {
 			int local_clock_stable = 1;
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-			local_clock_stable = sched_clock_stable;
+			local_clock_stable = sched_clock_stable();
 #endif
 			WARN_ONCE(delta > (1ULL << 59),
 				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",


