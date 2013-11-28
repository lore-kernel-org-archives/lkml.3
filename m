Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3K1Suj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:50:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55795 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab3K1Sud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:50:33 -0500
Date: Thu, 28 Nov 2013 19:50:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, David Miller <davem@davemloft.net>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 7/8] sched, net: Fixup busy_loop_us_clock()
Message-ID: <20131128185000.GM3694@twins.programming.kicks-ass.net>
References: <20131126155743.116756708@infradead.org>
 <20131126160815.293633156@infradead.org>
 <529773FC.6020707@linux.intel.com>
 <20131128174001.GH10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128174001.GH10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 06:40:01PM +0100, Peter Zijlstra wrote:
> That said; let me see if I can come up with a few patches to optimize
> the entire thing; that'd be something we all benefit from.

OK, so the below compiles, I currently haven't got time to see if it
runs or not.

I've got it as series of 6 patches, but for convenience I'll just put the
entire folded diff below.

Obviously I still need to fix the #if 0 bits and do ia64 which would add
another few patches.

---
 arch/x86/Kconfig                 |   1 +
 arch/x86/include/asm/timer.h     |  64 +---------------
 arch/x86/kernel/cpu/amd.c        |   2 +-
 arch/x86/kernel/cpu/intel.c      |   2 +-
 arch/x86/kernel/cpu/perf_event.c |   4 +-
 arch/x86/kernel/tsc.c            | 153 +++++++++++++++++++++++++--------------
 include/linux/math64.h           |  30 ++++++++
 include/linux/sched.h            |   4 +-
 init/Kconfig                     |   6 ++
 kernel/sched/clock.c             |  63 ++++++++--------
 kernel/sched/debug.c             |   2 +-
 kernel/time/tick-sched.c         |   2 +-
 kernel/trace/ring_buffer.c       |   2 +-
 13 files changed, 181 insertions(+), 154 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c84cf90ca693..bd1f30159689 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 34baa0eb5d0c..125cdd1371da 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -4,6 +4,7 @@
 #include <linux/pm.h>
 #include <linux/percpu.h>
 #include <linux/interrupt.h>
+#include <linux/math64.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -12,68 +13,5 @@ extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- *
- * In:
- *
- * ns = cycles * cyc2ns_scale / SC
- *
- * Although we may still have enough bits to store the value of ns,
- * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
- * leading to an incorrect result.
- *
- * To avoid this, we can decompose 'cycles' into quotient and remainder
- * of division by SC.  Then,
- *
- * ns = (quot * SC + rem) * cyc2ns_scale / SC
- *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
- *
- *			- sqazi@google.com
- */
-
-DECLARE_PER_CPU(unsigned long, cyc2ns);
-DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
-{
-	int cpu = smp_processor_id();
-	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
-			(1UL << CYC2NS_SCALE_FACTOR));
-	return ns;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	unsigned long long ns;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	ns = __cycles_2_ns(cyc);
-	local_irq_restore(flags);
-
-	return ns;
-}
 
 #endif /* _ASM_X86_TIMER_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023bdd6b2..8bc79cddd9a2 100644
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
index dc1ec0dff939..d6a93c1f64db 100644
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
index 98f845bdee5a..0b214d398c81 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1895,7 +1895,8 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!sched_clock_stable)
+#if 0
+	if (!sched_clock_stable())
 		return;
 
 	userpg->cap_user_time = 1;
@@ -1905,6 +1906,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 
 	userpg->cap_user_time_zero = 1;
 	userpg->time_zero = this_cpu_read(cyc2ns_offset);
+#endif
 }
 
 /*
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d48f560..68c84d7b7658 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -11,6 +11,7 @@
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
+#include <linux/static_key.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -37,7 +38,95 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
+static struct static_key __use_tsc = STATIC_KEY_INIT;
+
 int tsc_clocksource_reliable;
+
+/* Accelerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *              ns = cycles / (freq / ns_per_sec)
+ *              ns = cycles * (ns_per_sec / freq)
+ *              ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *              ns = cycles * (10^6 / cpu_khz)
+ *
+ *      Then we use scaling math (suggested by george@mvista.com) to get:
+ *              ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *              ns = cycles * cyc2ns_scale / SC
+ *
+ *      And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+
+struct cyc2ns_data {
+	unsigned long cyc2ns_mul;
+	unsigned long long cyc2ns_offset;
+};
+
+struct cyc2ns_latch {
+	unsigned int head, tail;
+	struct cyc2ns_data data[2];
+};
+
+static DEFINE_PER_CPU(struct cyc2ns_latch, cyc2ns);
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	unsigned long long ns;
+	unsigned int tail, idx;
+
+again:
+	tail = this_cpu_read(cyc2ns.tail);
+	smp_rmb();
+	idx = tail & 1;
+	ns = this_cpu_read(cyc2ns.data[idx].cyc2ns_offset);
+	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns.data[idx].cyc2ns_mul),
+			CYC2NS_SCALE_FACTOR);
+	smp_rmb();
+	if (unlikely(this_cpu_read(cyc2ns.head) - tail >= 2))
+		goto again;
+
+	return ns;
+}
+
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+{
+	unsigned long long tsc_now, ns_now;
+	struct cyc2ns_latch *latch = &per_cpu(cyc2ns, cpu);
+	struct cyc2ns_data *data;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	if (!cpu_khz)
+		goto done;
+
+	latch->head++;
+	smp_wmb();
+	data = latch->data + (latch->head & 1);
+
+	rdtscll(tsc_now);
+	ns_now = cycles_2_ns(tsc_now);
+
+	data->cyc2ns_mul = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) + cpu_khz / 2) / cpu_khz;
+	data->cyc2ns_offset = ns_now - mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+	smp_wmb();
+	latch->tail++;
+
+done:
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
+}
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -53,7 +142,7 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (unlikely(tsc_disabled)) {
+	if (static_key_false(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
@@ -62,7 +151,7 @@ u64 native_sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return __cycles_2_ns(this_offset);
+	return cycles_2_ns(this_offset);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -589,61 +678,11 @@ int recalibrate_cpu_khz(void)
 EXPORT_SYMBOL(recalibrate_cpu_khz);
 
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *              ns = cycles / (freq / ns_per_sec)
- *              ns = cycles * (ns_per_sec / freq)
- *              ns = cycles * (10^9 / (cpu_khz * 10^3))
- *              ns = cycles * (10^6 / cpu_khz)
- *
- *      Then we use scaling math (suggested by george@mvista.com) to get:
- *              ns = cycles * (10^6 * SC / cpu_khz) / SC
- *              ns = cycles * cyc2ns_scale / SC
- *
- *      And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
-
-static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
-{
-	unsigned long long tsc_now, ns_now, *offset;
-	unsigned long flags, *scale;
-
-	local_irq_save(flags);
-	sched_clock_idle_sleep_event();
-
-	scale = &per_cpu(cyc2ns, cpu);
-	offset = &per_cpu(cyc2ns_offset, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	if (cpu_khz) {
-		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
-				cpu_khz / 2) / cpu_khz;
-		*offset = ns_now - mult_frac(tsc_now, *scale,
-					     (1UL << CYC2NS_SCALE_FACTOR));
-	}
-
-	sched_clock_idle_wakeup_event(0);
-	local_irq_restore(flags);
-}
-
 static unsigned long long cyc2ns_suspend;
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -659,11 +698,12 @@ void tsc_save_sched_clock_state(void)
  */
 void tsc_restore_sched_clock_state(void)
 {
+#if 0
 	unsigned long long offset;
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	local_irq_save(flags);
@@ -675,6 +715,7 @@ void tsc_restore_sched_clock_state(void)
 		per_cpu(cyc2ns_offset, cpu) = offset;
 
 	local_irq_restore(flags);
+#endif
 }
 
 #ifdef CONFIG_CPU_FREQ
@@ -795,7 +836,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		sched_clock_stable = 0;
+		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
 		pr_info("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
@@ -1002,7 +1043,9 @@ void __init tsc_init(void)
 		return;
 
 	/* now allow native_sched_clock() to use rdtsc */
+
 	tsc_disabled = 0;
+	static_key_slow_inc(&__use_tsc);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();
diff --git a/include/linux/math64.h b/include/linux/math64.h
index 69ed5f5e9f6e..c45c089bfdac 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -133,4 +133,34 @@ __iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 	return ret;
 }
 
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	return (u64)(((unsigned __int128)a * mul) >> shift);
+}
+#endif /* mul_u64_u32_shr */
+
+#else
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	u32 ah, al;
+	u64 ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = ((u64)al * mul) >> shift;
+	if (ah)
+		ret += ((u64)ah * mul) << (32 - shift);
+
+	return ret;
+}
+#endif /* mul_u64_u32_shr */
+
+#endif
+
 #endif /* _LINUX_MATH64_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bf14c215af1e..44fbcbff8dde 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1880,7 +1880,9 @@ static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
  * but then during bootup it turns out that sched_clock()
  * is reliable after all:
  */
-extern int sched_clock_stable;
+extern int sched_clock_stable(void);
+extern void set_sched_clock_stable(void);
+extern void clear_sched_clock_stable(void);
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
diff --git a/init/Kconfig b/init/Kconfig
index 79383d3aa5dc..4e5d96ab2034 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -809,6 +809,12 @@ config GENERIC_SCHED_CLOCK
 config ARCH_SUPPORTS_NUMA_BALANCING
 	bool
 
+#
+# For architectures that know their GCC __int128 support is sound
+#
+config ARCH_SUPPORTS_INT128
+	bool
+
 # For architectures that (ab)use NUMA to represent different memory regions
 # all cpu-local but of different latencies, such as SuperH.
 #
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae1446461c..35a14f76d633 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -26,9 +26,10 @@
  * at 0 on boot (but people really shouldn't rely on that).
  *
  * cpu_clock(i)       -- can be used from any context, including NMI.
- * sched_clock_cpu(i) -- must be used with local IRQs disabled (implied by NMI)
  * local_clock()      -- is cpu_clock() on the current cpu.
  *
+ * sched_clock_cpu(i)
+ *
  * How:
  *
  * The implementation either uses sched_clock() when
@@ -50,15 +51,6 @@
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
- *
- * Notes:
- *
- * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
- * like cpufreq interrupts that can change the base clock (TSC) multiplier
- * and cause funny jumps in time -- although the filtering provided by
- * sched_clock_cpu() should mitigate serious artifacts we cannot rely on it
- * in general since for !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK we fully rely on
- * sched_clock().
  */
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
@@ -66,6 +58,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/static_key.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -82,7 +75,27 @@ EXPORT_SYMBOL_GPL(sched_clock);
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
@@ -244,7 +257,7 @@ u64 sched_clock_cpu(int cpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return sched_clock();
 
 	if (unlikely(!sched_clock_running))
@@ -265,7 +278,7 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd;
 	u64 now, now_gtod;
 
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return;
 
 	if (unlikely(!sched_clock_running))
@@ -316,14 +329,10 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
  */
 u64 cpu_clock(int cpu)
 {
-	u64 clock;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(cpu);
 
-	return clock;
+	return sched_clock();
 }
 
 /*
@@ -335,14 +344,10 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	u64 clock;
-	unsigned long flags;
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(smp_processor_id());
 
-	local_irq_save(flags);
-	clock = sched_clock_cpu(smp_processor_id());
-	local_irq_restore(flags);
-
-	return clock;
+	return sched_clock();
 }
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
@@ -362,12 +367,12 @@ u64 sched_clock_cpu(int cpu)
 
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
index 5c34d1817e8f..71934842baaf 100644
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
index a12df5abde0b..8be2dca1e1d7 100644
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
index cc2f66f68dc5..294b8a271a04 100644
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
