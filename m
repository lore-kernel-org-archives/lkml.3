Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaGVMFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:05:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbaGVMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:05:38 -0400
Date: Tue, 22 Jul 2014 14:05:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140722120534.GD6462@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140719130602.GA5101@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's the preempt-version we were talking about.

Please don't look at the vdso hunk - I had to make it build. Will fix
properly later once we've established whether this actually makes sense
at all first.

:-)

--
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
index 94605c0e9cee..904bc182a16b 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -4,11 +4,11 @@
 #ifndef _ASM_X86_TSC_H
 #define _ASM_X86_TSC_H
 
-#include <asm/processor.h>
-
 #define NS_SCALE	10 /* 2^10, carefully chosen */
 #define US_SCALE	32 /* 2^32, arbitralrily chosen */
 
+DECLARE_PER_CPU(long long, tsc_offset);
+
 /*
  * Standard way to access the cycle counter.
  */
@@ -27,7 +27,10 @@ static inline cycles_t get_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
+	preempt_disable();
 	rdtscll(ret);
+	ret += this_cpu_read_8(tsc_offset);
+	preempt_enable();
 
 	return ret;
 }
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 26488487bc61..97293b66fa65 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -28,6 +28,11 @@ static atomic_t start_count;
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
@@ -36,7 +41,10 @@ static arch_spinlock_t sync_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
 static cycles_t last_tsc;
 static cycles_t max_warp;
-static int nr_warps;
+static int nr_warps, max_warp_cpu;
+
+DEFINE_PER_CPU(long long, tsc_offset) = { 0 };
+EXPORT_PER_CPU_SYMBOL_GPL(tsc_offset);
 
 /*
  * TSC-warp measurement loop running on both CPUs:
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
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index 175cc72c0f68..d5cba62bbf46 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -25,6 +25,9 @@
 
 #define BUILD_VDSO32_64
 
+#undef this_cpu_read_8
+#define this_cpu_read_8(dummy) (0)
+
 #endif
 
 #include "../vclock_gettime.c"

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
