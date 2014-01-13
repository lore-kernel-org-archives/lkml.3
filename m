Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaAMP6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:58:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaAMP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:27 -0500
Date: Mon, 13 Jan 2014 07:57:55 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-eummbdechzz37mwmpags1gjr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock, x86:
  Use a static_key for sched_clock_stable
Git-Commit-ID: 35af99e646c7f7ea46dc2977601e9e71a51dadd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:58:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35af99e646c7f7ea46dc2977601e9e71a51dadd5
Gitweb:     http://git.kernel.org/tip/35af99e646c7f7ea46dc2977601e9e71a51dadd5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 28 Nov 2013 19:38:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:13:13 +0100

sched/clock, x86: Use a static_key for sched_clock_stable

In order to avoid the runtime condition and variable load turn
sched_clock_stable into a static_key.

Also provide a shorter implementation of local_clock() and
cpu_clock(int) when sched_clock_stable==1.

                        MAINLINE   PRE       POST

    sched_clock_stable: 1          1         1
    (cold) sched_clock: 329841     221876    215295
    (cold) local_clock: 301773     234692    220773
    (warm) sched_clock: 38375      25602     25659
    (warm) local_clock: 100371     33265     27242
    (warm) rdtsc:       27340      24214     24208
    sched_clock_stable: 0          0         0
    (cold) sched_clock: 382634     235941    237019
    (cold) local_clock: 396890     297017    294819
    (warm) sched_clock: 38194      25233     25609
    (warm) local_clock: 143452     71234     71232
    (warm) rdtsc:       27345      24245     24243

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-eummbdechzz37mwmpags1gjr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/amd.c        |  2 +-
 arch/x86/kernel/cpu/intel.c      |  2 +-
 arch/x86/kernel/cpu/perf_event.c |  2 +-
 arch/x86/kernel/tsc.c            |  6 +++---
 include/linux/sched.h            |  4 +++-
 kernel/sched/clock.c             | 41 +++++++++++++++++++++++++++++++++-------
 kernel/sched/debug.c             |  2 +-
 kernel/time/tick-sched.c         |  2 +-
 kernel/trace/ring_buffer.c       |  2 +-
 9 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..8bc79cd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -487,7 +487,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ea04b34..1a439c0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -93,7 +93,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9f97bd0..b886451 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1890,7 +1890,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	data = cyc2ns_read_begin();
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 92b090b..53c1235 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -822,7 +822,7 @@ static unsigned long long cyc2ns_suspend;
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -842,7 +842,7 @@ void tsc_restore_sched_clock_state(void)
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	local_irq_save(flags);
@@ -984,7 +984,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		sched_clock_stable = 0;
+		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
 		pr_info("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a196cb7..a038752 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1994,7 +1994,9 @@ static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
  * but then during bootup it turns out that sched_clock()
  * is reliable after all:
  */
-extern int sched_clock_stable;
+extern int sched_clock_stable(void);
+extern void set_sched_clock_stable(void);
+extern void clear_sched_clock_stable(void);
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 5937154..c9b34c4 100644
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
+		static_key_slow_dec(&__sched_clock_stable);
+}
+
+void clear_sched_clock_stable(void)
+{
+	/* XXX worry about clock continuity */
+	if (sched_clock_stable())
+		static_key_slow_inc(&__sched_clock_stable);
+}
 
 struct sched_clock_data {
 	u64			tick_raw;
@@ -234,7 +255,7 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd;
 	u64 clock;
 
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
@@ -308,7 +329,10 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
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
-	return sched_clock_cpu(raw_smp_processor_id());
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(raw_smp_processor_id());
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
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 374fe04..dd52e7f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -371,7 +371,7 @@ static void sched_debug_header(struct seq_file *m)
 	PN(cpu_clk);
 	P(jiffies);
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-	P(sched_clock_stable);
+	P(sched_clock_stable());
 #endif
 #undef PN
 #undef P
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ea20f7d..c833249 100644
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
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cc2f66f..294b8a2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2558,7 +2558,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		if (unlikely(test_time_stamp(delta))) {
 			int local_clock_stable = 1;
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-			local_clock_stable = sched_clock_stable;
+			local_clock_stable = sched_clock_stable();
 #endif
 			WARN_ONCE(delta > (1ULL << 59),
 				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
