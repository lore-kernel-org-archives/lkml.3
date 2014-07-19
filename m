Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaGSNGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:06:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43531 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbaGSNGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:06:07 -0400
Date: Sat, 19 Jul 2014 15:06:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140719130602.GA5101@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

There are machines which do have stable and always-running TSCs but the
last get started at different points in time by the platform, causing
the TSCs to have a small constant diff.

It has been tried a couple of times to resync those during that
sync check but the procedure is error prone and flaky, and not 100%
successful.

So, instead of doing that, let's not touch the TSCs at all but save a
per-CPU TSC offset which we add to the TSC value we've read from the
Time-Stamp Counter. The hope is thus to still salvage the TSC on those
machines.

For that to work, we need to populate the TSC AUX MSR with the core ID
prior to doing the TSC sync check so that RDTSCP can give us the correct
core number and we can add the offset atomically. And yes, we need a
X86_FEATURE_RDTSCP CPU for the whole deal to work. Older ones simply
lose.

See also comment above tsc_sync.c::compute_tsc_offset() for more details.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h |   1 +
 arch/x86/include/asm/tsc.h        |  19 +++++++
 arch/x86/kernel/cpu/common.c      |   2 +
 arch/x86/kernel/tsc_sync.c        | 117 ++++++++++++++++++++++++++++++++++----
 4 files changed, 129 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258d60e7..8c27e55372fb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -244,6 +244,7 @@
 #define X86_BUG_11AP		X86_BUG(5) /* Bad local APIC aka 11AP */
 #define X86_BUG_FXSAVE_LEAK	X86_BUG(6) /* FXSAVE leaks FOP/FIP/FOP */
 #define X86_BUG_CLFLUSH_MONITOR	X86_BUG(7) /* AAI65, CLFLUSH required before MONITOR */
+#define X86_BUG_TSC_OFFSET	X86_BUG(8) /* CPU has skewed but stable TSCs */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94605c0e9cee..a91f439738f9 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -9,6 +9,9 @@
 #define NS_SCALE	10 /* 2^10, carefully chosen */
 #define US_SCALE	32 /* 2^32, arbitralrily chosen */
 
+
+DECLARE_PER_CPU(long long, tsc_offset);
+
 /*
  * Standard way to access the cycle counter.
  */
@@ -32,6 +35,22 @@ static inline cycles_t get_cycles(void)
 	return ret;
 }
 
+static inline cycles_t get_cycles_aux(void)
+{
+	unsigned long long ret = 0;
+	int cpu;
+
+#ifndef CONFIG_X86_TSC
+	if (!cpu_has_tsc)
+		return 0;
+#endif
+	if (static_cpu_has_safe(X86_FEATURE_RDTSCP)) {
+		rdtscpll(ret, cpu);
+		return ret + per_cpu(tsc_offset, cpu);
+	} else
+		return get_cycles();
+}
+
 static __always_inline cycles_t vget_cycles(void)
 {
 	/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ce31eeada362..c67300281790 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -962,6 +962,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
+	if (cpu_has(c, X86_FEATURE_RDTSCP))
+		write_rdtscp_aux(smp_processor_id());
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 26488487bc61..5c0d2eeb5e9b 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <asm/msr-index.h>
 #include <asm/tsc.h>
 
 /*
@@ -28,6 +29,11 @@ static atomic_t start_count;
 static atomic_t stop_count;
 
 /*
+ * TSC offset helper counters.
+ */
+static atomic_t set_offset_on_target, offset_done;
+
+/*
  * We use a raw spinlock in this exceptional case, because
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
@@ -36,7 +42,9 @@ static arch_spinlock_t sync_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
 static cycles_t last_tsc;
 static cycles_t max_warp;
-static int nr_warps;
+static int nr_warps, max_warp_cpu;
+
+DEFINE_PER_CPU(long long, tsc_offset) = { 0 };
 
 /*
  * TSC-warp measurement loop running on both CPUs:
@@ -47,7 +55,7 @@ static void check_tsc_warp(unsigned int timeout)
 	int i;
 
 	rdtsc_barrier();
-	start = get_cycles();
+	start = get_cycles_aux();
 	rdtsc_barrier();
 	/*
 	 * The measurement runs for 'timeout' msecs:
@@ -64,7 +72,7 @@ static void check_tsc_warp(unsigned int timeout)
 		arch_spin_lock(&sync_lock);
 		prev = last_tsc;
 		rdtsc_barrier();
-		now = get_cycles();
+		now = get_cycles_aux();
 		rdtsc_barrier();
 		last_tsc = now;
 		arch_spin_unlock(&sync_lock);
@@ -89,6 +97,10 @@ static void check_tsc_warp(unsigned int timeout)
 			arch_spin_lock(&sync_lock);
 			max_warp = max(max_warp, prev - now);
 			nr_warps++;
+
+			if (prev - now == max_warp)
+				max_warp_cpu = smp_processor_id();
+
 			arch_spin_unlock(&sync_lock);
 		}
 	}
@@ -116,6 +128,69 @@ static inline unsigned int loop_timeout(int cpu)
 	return (cpumask_weight(cpu_core_mask(cpu)) > 1) ? 2 : 20;
 }
 
+static inline bool cpu_should_save_offset(int cpu)
+{
+	bool ret = static_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		   static_cpu_has(X86_FEATURE_NONSTOP_TSC);
+
+	if (ret)
+		set_cpu_bug(&cpu_data(cpu), X86_BUG_TSC_OFFSET);
+
+	return ret;
+}
+
+/*
+ * We're saving a per-core TSC offset only on machines which have a
+ * stable and non-stop TSC but which, for some reason, start their TSCs
+ * on the different nodes at different points in time, thus causing a
+ * small constant diff between them.
+ *
+ * We do this during the TSC sync check which happens between a source
+ * and a target CPU. When we detect the diff, we hold the target CPU by
+ * _not_ incrementing stop_count. What we do instead is we send it into
+ * compute_tsc_offset() below and store the max_warp difference we have
+ * measured above in a per-cpu variable.
+ *
+ * We do pay attention to which CPU saw the max_warp by writing its
+ * number into max_warp_cpu so that we can compute whether the offset
+ * we're going to write into the target's TSC is positive or negative.
+ *
+ * It is positive when the target CPU's TSC has started later than the
+ * source CPU's TSC and thus has a smaller TSC value.
+ *
+ * It is negative when the target CPU's TSC has started earlier than the
+ * source CPU's TSC and thus has a higher TSC value.
+ *
+ * Once we've computed the offset, we let both CPUs do the usual
+ * TSC sync check again, taking the offset into account, see
+ * get_cycles_aux().
+ *
+ * Called on the target.
+ */
+static void compute_tsc_offset(int cpu)
+{
+	long long off;
+
+	/*
+	 * This CPU wrote last the max_warp above, means its TSC is smaller than
+	 * the source CPU which we're doing the sync check with.
+	 */
+	if (cpu == max_warp_cpu)
+		off =  max_warp;
+	else
+		off = -max_warp;
+
+	per_cpu(tsc_offset, cpu) = off;
+	pr_info("CPU%d, saved offset: %lld\n", cpu, off);
+
+	nr_warps = 0;
+	max_warp = 0;
+	last_tsc = 0;
+
+	atomic_inc(&offset_done);
+	atomic_set(&set_offset_on_target, 0);
+}
+
 /*
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
@@ -138,6 +213,7 @@ void check_tsc_sync_source(int cpu)
 		return;
 	}
 
+restart_src:
 	/*
 	 * Reset it - in case this is a second bootup:
 	 */
@@ -155,15 +231,27 @@ void check_tsc_sync_source(int cpu)
 
 	check_tsc_warp(loop_timeout(cpu));
 
+	/*
+	 * Wait for target to finish measurement:
+	 */
 	while (atomic_read(&stop_count) != cpus-1)
 		cpu_relax();
 
+	/* Analyze measurement */
 	if (nr_warps) {
-		pr_warning("TSC synchronization [CPU#%d -> CPU#%d]:\n",
-			smp_processor_id(), cpu);
-		pr_warning("Measured %Ld cycles TSC warp between CPUs, "
-			   "turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable("check_tsc_sync_source failed");
+		if (cpu_should_save_offset(cpu) && !atomic_read(&offset_done)) {
+			pr_warn("TSCs of [CPU#%d -> CPU#%d] %lld cycles out of sync, saving offset.\n",
+				smp_processor_id(), cpu, max_warp);
+
+			atomic_set(&start_count, 0);
+			atomic_set(&set_offset_on_target, 1);
+
+			goto restart_src;
+		} else {
+			pr_warning("Measured %Ld(%d) cycles TSC warp between CPUs, "
+				   "turning off TSC clock.\n", max_warp, max_warp_cpu);
+			mark_tsc_unstable("check_tsc_sync_source failed");
+		}
 	} else {
 		pr_debug("TSC synchronization [CPU#%d -> CPU#%d]: passed\n",
 			smp_processor_id(), cpu);
@@ -173,6 +261,7 @@ void check_tsc_sync_source(int cpu)
 	 * Reset it - just in case we boot another CPU later:
 	 */
 	atomic_set(&start_count, 0);
+	atomic_set(&offset_done, 0);
 	nr_warps = 0;
 	max_warp = 0;
 	last_tsc = 0;
@@ -188,11 +277,16 @@ void check_tsc_sync_source(int cpu)
  */
 void check_tsc_sync_target(void)
 {
+	int this_cpu = smp_processor_id();
 	int cpus = 2;
 
 	if (unsynchronized_tsc() || tsc_clocksource_reliable)
 		return;
 
+restart_tgt:
+	if (atomic_read(&set_offset_on_target))
+		compute_tsc_offset(this_cpu);
+
 	/*
 	 * Register this CPU's participation and wait for the
 	 * source CPU to start the measurement:
@@ -201,7 +295,7 @@ void check_tsc_sync_target(void)
 	while (atomic_read(&start_count) != cpus)
 		cpu_relax();
 
-	check_tsc_warp(loop_timeout(smp_processor_id()));
+	check_tsc_warp(loop_timeout(this_cpu));
 
 	/*
 	 * Ok, we are done:
@@ -211,6 +305,9 @@ void check_tsc_sync_target(void)
 	/*
 	 * Wait for the source CPU to print stuff:
 	 */
-	while (atomic_read(&stop_count) != cpus)
+	while (atomic_read(&stop_count) != cpus) {
+		if (atomic_read(&set_offset_on_target))
+			goto restart_tgt;
 		cpu_relax();
+	}
 }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
