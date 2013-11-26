Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3KZOoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:44:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3KZOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:44:23 -0500
Date: Tue, 26 Nov 2013 15:44:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        fweisbec@gmail.com, Paul Turner <pjt@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] sched, fair: Rework sched_fair time accounting
Message-ID: <20131126144405.GM10022@twins.programming.kicks-ass.net>
References: <20131116223740.3cd579cb@spike>
 <20131118140224.GA3330@redhat.com>
 <20131118172706.GI3866@twins.programming.kicks-ass.net>
 <20131120120815.GA12860@redhat.com>
 <20131125014302.6a4394ce@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125014302.6a4394ce@spike>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:43:02AM +0100, Christian Engelmayer wrote:
> I had this patch applied during daily use. No systematic testing, but no user
> perceived regressions either. The originally reported divide by 0 scenario
> could no longer be reproduced with this change.

Thanks! slightly updated version below.

I took some care to make sure the patch compiles into two 32x32->64
multiplications in the common case for 32bit.

Sadly GCC is too smart and completely fails to get the hint; the line:

 fact = (u64)(u32)fact * lw->inv_weight;

Is converted into a double imul+mul monster for -O2. The only way to get
the proper single mul is by forcing it into a noinline function, but
that adds call/stack overhead.

That said, given a sensible compiler (ha!) the common case for 32bit
should be equal or better than before.

---
Subject: sched, fair: Rework sched_fair time accounting
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 18 Nov 2013 18:27:06 +0100

Christian suffers from a bad BIOS that wrecks his i5's TSC sync. This
results in him occasionally seeing time going backwards.

Most of our time accounting can actually handle that except the most
common one; the tick time update of sched_fair.

There is a further problem with that code; previously we assumed that
because we get a tick every TICK_NSEC our time delta could never
exceed 32bits and math was simpler.

However, ever since Frederic managed to get NO_HZ_FULL merged; this is
no longer the case since now a task can run for a long time indeed
without getting a tick. It only takes about ~4.2 seconds to overflow
our u32 in nanoseconds.

This means we not only need to better deal with time going backwards;
but also means we need to be able to deal with large deltas.

This patch reworks the entire code and introduces mul_u64_u32_shr() as
proposed by Andy a long while ago.

We express our virtual time scale factor in a u32 multiplier and shift
right and the 32bit mul_u64_u32_shr() implementation reduces to a
single 32x32->64 multiply if the time delta is still short (common
case).

For 64bit a 64x64->128 multiply can be used if ARCH_SUPPORTS_INT128; I
didn't want to write fallback code for now, but we could.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: Paul Turner <pjt@google.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>
Reported-by: Christian Engelmayer <cengelma@gmx.at>
Tested-by: Christian Engelmayer <cengelma@gmx.at>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/Kconfig       |    1 
 include/linux/math64.h |   30 ++++++++++
 include/linux/sched.h  |    3 -
 init/Kconfig           |    6 ++
 kernel/sched/fair.c    |  144 +++++++++++++++++++++----------------------------
 5 files changed, 103 insertions(+), 81 deletions(-)

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
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -133,4 +133,34 @@ __iter_div_u64_rem(u64 dividend, u32 div
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
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -932,7 +932,8 @@ struct pipe_inode_info;
 struct uts_namespace;
 
 struct load_weight {
-	unsigned long weight, inv_weight;
+	unsigned long weight;
+	u32 inv_weight;
 };
 
 struct sched_avg {
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
-
-	/*
-	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
-	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
-	 * 2^SCHED_LOAD_RESOLUTION.
-	 */
-	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
-		tmp = (u64)delta_exec * scale_load_down(weight);
-	else
-		tmp = (u64)delta_exec;
+	u64 fact = scale_load_down(weight);
+	int shift = WMULT_SHIFT;
 
-	if (!lw->inv_weight) {
-		unsigned long w = scale_load_down(lw->weight);
+	__update_inv_weight(lw);
 
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
 
-	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
+	while (fact >> 32) {
+		fact >>= 1;
+		shift--;
+	}
+
+	return mul_u64_u32_shr(delta_exec, fact, shift);
 }
 
 
@@ -443,7 +445,7 @@ find_matching_se(struct sched_entity **s
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -612,11 +614,10 @@ int sched_proc_update_handler(struct ctl
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
@@ -665,7 +666,7 @@ static u64 sched_slice(struct cfs_rq *cf
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
 		}
-		slice = calc_delta_mine(slice, se->load.weight, load);
+		slice = __calc_delta(slice, se->load.weight, load);
 	}
 	return slice;
 }
@@ -703,47 +704,32 @@ void init_task_runnable_average(struct t
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
 
@@ -3015,8 +3001,7 @@ static void expire_cfs_rq_runtime(struct
 	}
 }
 
-static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec)
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
@@ -3034,7 +3019,7 @@ static void __account_cfs_rq_runtime(str
 }
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -3574,8 +3559,7 @@ static inline u64 cfs_rq_clock_task(stru
 	return rq_clock_task(rq_of(cfs_rq));
 }
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
