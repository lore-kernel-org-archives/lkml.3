Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3KRR1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:27:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45871 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KRR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:27:16 -0500
Date: Mon, 18 Nov 2013 18:27:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        fweisbec@gmail.com, Paul Turner <pjt@google.com>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131118172706.GI3866@twins.programming.kicks-ass.net>
References: <20131116223740.3cd579cb@spike>
 <20131118140224.GA3330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118140224.GA3330@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:02:24PM +0100, Stanislaw Gruszka wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c70201..f02a567 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -727,7 +727,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
>  	u64 now = rq_clock_task(rq_of(cfs_rq));
>  	unsigned long delta_exec;
>  
> -	if (unlikely(!curr))
> +	if (unlikely(!curr || now <= curr->exec_start))
>  		return;

That is not actually correct in the case time wraps.

There's a further problem with this code though -- ever since Frederic
added NO_HZ_FULL a CPU can in fact aggregate a runtime delta larger than
4 seconds, due to running without a tick.

Therefore we need to be able to deal with u64 deltas.

The below is a compile tested only attempt to deal with both these
problems. Comments?

---
 arch/x86/Kconfig       |   1 +
 include/linux/math64.h |  32 +++++++++++
 init/Kconfig           |   6 +++
 kernel/sched/fair.c    | 144 ++++++++++++++++++++++---------------------------
 4 files changed, 102 insertions(+), 81 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c84cf90ca693..33544dbed7bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_INT128
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/include/linux/math64.h b/include/linux/math64.h
index 69ed5f5e9f6e..67d8c8258fbd 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -133,4 +133,36 @@ __iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
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
+	u64 t1, t2;
+
+	al = a;
+	ah = a >> 32;
+
+	t1 = ((u64)al * mul) >> shift;
+	if (ah) {
+		t2 = ((u64)ah * mul) << (32 - shift);
+		t1 += t2;
+	}
+
+	return t1;
+}
+#endif /* mul_u64_u32_shr */
+
+#endif
+
 #endif /* _LINUX_MATH64_H */
diff --git a/init/Kconfig b/init/Kconfig
index 3fc8a2f2fac4..8654d2c94625 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -823,6 +823,12 @@ config GENERIC_SCHED_CLOCK
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652ebe027..ceee8421720f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -178,59 +178,59 @@ void sched_init_granularity(void)
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
-
-/*
- * delta *= weight / lw
- */
-static unsigned long
-calc_delta_mine(unsigned long delta_exec, unsigned long weight,
-		struct load_weight *lw)
+static void __update_inv_weight(struct load_weight *lw)
 {
-	u64 tmp;
+	unsigned long w;
 
-	/*
-	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
-	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
-	 * 2^SCHED_LOAD_RESOLUTION.
-	 */
-	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
-		tmp = (u64)delta_exec * scale_load_down(weight);
+	if (lw->inv_weight)
+		return;
+
+	w = scale_load_down(lw->weight);
+
+	if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
+		lw->inv_weight = 1;
+	else if (unlikely(!w))
+		lw->inv_weight = WMULT_CONST;
 	else
-		tmp = (u64)delta_exec;
+		lw->inv_weight = WMULT_CONST / w;
+}
+
+/* 
+ * delta_exec * weight / lw.weight
+ *   OR
+ * (delta_exec * (weight * lw->inv_weight)) >> WMULT_SHIFT
+ *
+ * Either weight := NICE_0_LOAD and lw \e prio_to_wmult[], in which case
+ * we're guaranteed shift stays positive because inv_weight is guaranteed to
+ * fit 32 bits, and NICE_0_LOAD gives another 10 bits; therefore shift >= 22.
+ *
+ * Or, weight =< lw.weight (because lw.weight is the runqueue weight), thus
+ * XXX mind got twisted, but I'm fairly sure shift will stay positive.
+ *
+ */
+static u64 __calc_delta(u64 delta_exec, unsigned long weight, struct load_weight *lw)
+{
+	int shift = WMULT_SHIFT;
+	u64 fact = scale_load_down(weight);
 
-	if (!lw->inv_weight) {
-		unsigned long w = scale_load_down(lw->weight);
+	__update_inv_weight(lw);
 
-		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
-			lw->inv_weight = 1;
-		else if (unlikely(!w))
-			lw->inv_weight = WMULT_CONST;
-		else
-			lw->inv_weight = WMULT_CONST / w;
+	while (fact >> 32) {
+		fact >>= 1;
+		shift--;
 	}
 
-	/*
-	 * Check whether we'd overflow the 64-bit multiplication:
-	 */
-	if (unlikely(tmp > WMULT_CONST))
-		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
-			WMULT_SHIFT/2);
-	else
-		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
+	fact *= lw->inv_weight;
 
-	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
+	while (fact >> 32) {
+		fact >>= 1;
+		shift--;
+	}
+
+	return mul_u64_u32_shr(delta_exec, fact, shift);
 }
 
 
@@ -443,7 +443,7 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -612,11 +612,10 @@ int sched_proc_update_handler(struct ctl_table *table, int write,
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
@@ -665,7 +664,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
 		}
-		slice = calc_delta_mine(slice, se->load.weight, load);
+		slice = __calc_delta(slice, se->load.weight, load);
 	}
 	return slice;
 }
@@ -703,47 +702,32 @@ void init_task_runnable_average(struct task_struct *p)
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
+	if ((s64)delta_exec < 0)
 		return;
 
-	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
 
+	schedstat_set(curr->statistics.exec_max,
+		      max((u64)delta_exec, curr->statistics.exec_max));
+
+	curr->sum_exec_runtime += delta_exec;
+	schedstat_add(cfs_rq, exec_clock, delta_exec);
+
+	curr->vruntime += calc_delta_fair(delta_exec, curr);
+	update_min_vruntime(cfs_rq);
+
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
@@ -3015,8 +2999,7 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	}
 }
 
-static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec)
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
@@ -3034,7 +3017,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 }
 
 static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -3574,8 +3557,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	return rq_clock_task(rq_of(cfs_rq));
 }
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
