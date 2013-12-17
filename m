Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3LQNk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:40:29 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54470 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3LQNkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:40:24 -0500
Date: Tue, 17 Dec 2013 14:40:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20131217134016.GA29397@gmail.com>
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

   # HEAD: 9dbdb155532395ba000c5d5d187658b0e17e529f sched/fair: Rework sched_fair time accounting

Three fixes for scheduler crashes, each triggers in relatively rare, 
hardware environment dependent situations.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (4):
      sched: Initialize power_orig for overlapping groups
      sched: Remove PREEMPT_NEED_RESCHED from generic code
      math64: Add mul_u64_u32_shr()
      sched/fair: Rework sched_fair time accounting


 arch/x86/Kconfig               |   1 +
 arch/x86/include/asm/preempt.h |  11 ++++
 include/asm-generic/preempt.h  |  35 ++++------
 include/linux/math64.h         |  30 +++++++++
 include/linux/sched.h          |   5 +-
 init/Kconfig                   |   6 ++
 kernel/sched/core.c            |   1 +
 kernel/sched/fair.c            | 144 ++++++++++++++++++-----------------------
 8 files changed, 126 insertions(+), 107 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e903c71..0952ecd 100644
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
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 8729723..c8b0519 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -8,6 +8,12 @@
 DECLARE_PER_CPU(int, __preempt_count);
 
 /*
+ * We use the PREEMPT_NEED_RESCHED bit as an inverted NEED_RESCHED such
+ * that a decrement hitting 0 means we can and should reschedule.
+ */
+#define PREEMPT_ENABLED	(0 + PREEMPT_NEED_RESCHED)
+
+/*
  * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
  * that think a non-zero value indicates we cannot preempt.
  */
@@ -74,6 +80,11 @@ static __always_inline void __preempt_count_sub(int val)
 	__this_cpu_add_4(__preempt_count, -val);
 }
 
+/*
+ * Because we keep PREEMPT_NEED_RESCHED set when we do _not_ need to reschedule
+ * a decrement which hits zero means we have no preempt_count and should
+ * reschedule.
+ */
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
 	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), "e");
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index ddf2b42..1cd3f5d 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -3,13 +3,11 @@
 
 #include <linux/thread_info.h>
 
-/*
- * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
- * that think a non-zero value indicates we cannot preempt.
- */
+#define PREEMPT_ENABLED	(0)
+
 static __always_inline int preempt_count(void)
 {
-	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
+	return current_thread_info()->preempt_count;
 }
 
 static __always_inline int *preempt_count_ptr(void)
@@ -17,11 +15,6 @@ static __always_inline int *preempt_count_ptr(void)
 	return &current_thread_info()->preempt_count;
 }
 
-/*
- * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
- * alternative is loosing a reschedule. Better schedule too often -- also this
- * should be a very rare operation.
- */
 static __always_inline void preempt_count_set(int pc)
 {
 	*preempt_count_ptr() = pc;
@@ -41,28 +34,17 @@ static __always_inline void preempt_count_set(int pc)
 	task_thread_info(p)->preempt_count = PREEMPT_ENABLED; \
 } while (0)
 
-/*
- * We fold the NEED_RESCHED bit into the preempt count such that
- * preempt_enable() can decrement and test for needing to reschedule with a
- * single instruction.
- *
- * We invert the actual bit, so that when the decrement hits 0 we know we both
- * need to resched (the bit is cleared) and can resched (no preempt count).
- */
-
 static __always_inline void set_preempt_need_resched(void)
 {
-	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline void clear_preempt_need_resched(void)
 {
-	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline bool test_preempt_need_resched(void)
 {
-	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+	return false;
 }
 
 /*
@@ -81,7 +63,12 @@ static __always_inline void __preempt_count_sub(int val)
 
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
-	return !--*preempt_count_ptr();
+	/*
+	 * Because of load-store architectures cannot do per-cpu atomic
+	 * operations; we cannot use PREEMPT_NEED_RESCHED because it might get
+	 * lost.
+	 */
+	return !--*preempt_count_ptr() && tif_need_resched();
 }
 
 /*
@@ -89,7 +76,7 @@ static __always_inline bool __preempt_count_dec_and_test(void)
  */
 static __always_inline bool should_resched(void)
 {
-	return unlikely(!*preempt_count_ptr());
+	return unlikely(!preempt_count() && tif_need_resched());
 }
 
 #ifdef CONFIG_PREEMPT
diff --git a/include/linux/math64.h b/include/linux/math64.h
index 69ed5f5..c45c089 100644
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
index 768b037..53f97eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -440,8 +440,6 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
-#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
-
 #ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
 #else
@@ -932,7 +930,8 @@ struct pipe_inode_info;
 struct uts_namespace;
 
 struct load_weight {
-	unsigned long weight, inv_weight;
+	unsigned long weight;
+	u32 inv_weight;
 };
 
 struct sched_avg {
diff --git a/init/Kconfig b/init/Kconfig
index 79383d3..4e5d96a 100644
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda2..19af58f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5112,6 +5112,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * die on a /0 trap.
 		 */
 		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+		sg->sgp->power_orig = sg->sgp->power;
 
 		/*
 		 * Make sure the first group of this domain contains the
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd773ad..9030da7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -178,59 +178,61 @@ void sched_init_granularity(void)
 	update_sysctl();
 }
 
-#if BITS_PER_LONG == 32
-# define WMULT_CONST	(~0UL)
-#else
-# define WMULT_CONST	(1UL << 32)
-#endif
-
+#define WMULT_CONST	(~0U)
 #define WMULT_SHIFT	32
 
-/*
- * Shift right and round:
- */
-#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
+static void __update_inv_weight(struct load_weight *lw)
+{
+	unsigned long w;
+
+	if (likely(lw->inv_weight))
+		return;
+
+	w = scale_load_down(lw->weight);
+
+	if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
+		lw->inv_weight = 1;
+	else if (unlikely(!w))
+		lw->inv_weight = WMULT_CONST;
+	else
+		lw->inv_weight = WMULT_CONST / w;
+}
 
 /*
- * delta *= weight / lw
+ * delta_exec * weight / lw.weight
+ *   OR
+ * (delta_exec * (weight * lw->inv_weight)) >> WMULT_SHIFT
+ *
+ * Either weight := NICE_0_LOAD and lw \e prio_to_wmult[], in which case
+ * we're guaranteed shift stays positive because inv_weight is guaranteed to
+ * fit 32 bits, and NICE_0_LOAD gives another 10 bits; therefore shift >= 22.
+ *
+ * Or, weight =< lw.weight (because lw.weight is the runqueue weight), thus
+ * weight/lw.weight <= 1, and therefore our shift will also be positive.
  */
-static unsigned long
-calc_delta_mine(unsigned long delta_exec, unsigned long weight,
-		struct load_weight *lw)
+static u64 __calc_delta(u64 delta_exec, unsigned long weight, struct load_weight *lw)
 {
-	u64 tmp;
+	u64 fact = scale_load_down(weight);
+	int shift = WMULT_SHIFT;
 
-	/*
-	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
-	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
-	 * 2^SCHED_LOAD_RESOLUTION.
-	 */
-	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
-		tmp = (u64)delta_exec * scale_load_down(weight);
-	else
-		tmp = (u64)delta_exec;
+	__update_inv_weight(lw);
 
-	if (!lw->inv_weight) {
-		unsigned long w = scale_load_down(lw->weight);
-
-		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
-			lw->inv_weight = 1;
-		else if (unlikely(!w))
-			lw->inv_weight = WMULT_CONST;
-		else
-			lw->inv_weight = WMULT_CONST / w;
+	if (unlikely(fact >> 32)) {
+		while (fact >> 32) {
+			fact >>= 1;
+			shift--;
+		}
 	}
 
-	/*
-	 * Check whether we'd overflow the 64-bit multiplication:
-	 */
-	if (unlikely(tmp > WMULT_CONST))
-		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
-			WMULT_SHIFT/2);
-	else
-		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
+	/* hint to use a 32x32->64 mul */
+	fact = (u64)(u32)fact * lw->inv_weight;
+
+	while (fact >> 32) {
+		fact >>= 1;
+		shift--;
+	}
 
-	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
+	return mul_u64_u32_shr(delta_exec, fact, shift);
 }
 
 
@@ -443,7 +445,7 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -612,11 +614,10 @@ int sched_proc_update_handler(struct ctl_table *table, int write,
 /*
  * delta /= w
  */
-static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
+static inline u64 calc_delta_fair(u64 delta, struct sched_entity *se)
 {
 	if (unlikely(se->load.weight != NICE_0_LOAD))
-		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
+		delta = __calc_delta(delta, NICE_0_LOAD, &se->load);
 
 	return delta;
 }
@@ -665,7 +666,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
 		}
-		slice = calc_delta_mine(slice, se->load.weight, load);
+		slice = __calc_delta(slice, se->load.weight, load);
 	}
 	return slice;
 }
@@ -703,47 +704,32 @@ void init_task_runnable_average(struct task_struct *p)
 #endif
 
 /*
- * Update the current task's runtime statistics. Skip current tasks that
- * are not in our scheduling class.
+ * Update the current task's runtime statistics.
  */
-static inline void
-__update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
-	      unsigned long delta_exec)
-{
-	unsigned long delta_exec_weighted;
-
-	schedstat_set(curr->statistics.exec_max,
-		      max((u64)delta_exec, curr->statistics.exec_max));
-
-	curr->sum_exec_runtime += delta_exec;
-	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
-
-	curr->vruntime += delta_exec_weighted;
-	update_min_vruntime(cfs_rq);
-}
-
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
 	u64 now = rq_clock_task(rq_of(cfs_rq));
-	unsigned long delta_exec;
+	u64 delta_exec;
 
 	if (unlikely(!curr))
 		return;
 
-	/*
-	 * Get the amount of time the current task was running
-	 * since the last time we changed load (this cannot
-	 * overflow on 32 bits):
-	 */
-	delta_exec = (unsigned long)(now - curr->exec_start);
-	if (!delta_exec)
+	delta_exec = now - curr->exec_start;
+	if (unlikely((s64)delta_exec <= 0))
 		return;
 
-	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
 
+	schedstat_set(curr->statistics.exec_max,
+		      max(delta_exec, curr->statistics.exec_max));
+
+	curr->sum_exec_runtime += delta_exec;
+	schedstat_add(cfs_rq, exec_clock, delta_exec);
+
+	curr->vruntime += calc_delta_fair(delta_exec, curr);
+	update_min_vruntime(cfs_rq);
+
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
@@ -3015,8 +3001,7 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	}
 }
 
-static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec)
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
@@ -3034,7 +3019,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 }
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -3574,8 +3559,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	return rq_clock_task(rq_of(cfs_rq));
 }
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
