Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3LLJwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:52:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LLJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:46 -0500
Date: Thu, 12 Dec 2013 01:52:01 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9dbdb155532395ba000c5d5d187658b0e17e529f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        luto@amacapital.net, akpm@linux-foundation.org, tglx@linutronix.de,
        cengelma@gmx.at, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        luto@amacapital.net, akpm@linux-foundation.org, tglx@linutronix.de,
        sgruszka@redhat.com, cengelma@gmx.at
In-Reply-To: <20131118172706.GI3866@twins.programming.kicks-ass.net>
References: <20131118172706.GI3866@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/fair: Rework sched_fair time accounting
Git-Commit-ID: 9dbdb155532395ba000c5d5d187658b0e17e529f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 01:52:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dbdb155532395ba000c5d5d187658b0e17e529f
Gitweb:     http://git.kernel.org/tip/9dbdb155532395ba000c5d5d187658b0e17e529f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 18 Nov 2013 18:27:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 11 Dec 2013 15:52:35 +0100

sched/fair: Rework sched_fair time accounting

Christian suffers from a bad BIOS that wrecks his i5's TSC sync. This
results in him occasionally seeing time going backwards - which
crashes the scheduler ...

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

This patch reworks the entire code and uses mul_u64_u32_shr() as
proposed by Andy a long while ago.

We express our virtual time scale factor in a u32 multiplier and shift
right and the 32bit mul_u64_u32_shr() implementation reduces to a
single 32x32->64 multiply if the time delta is still short (common
case).

For 64bit a 64x64->128 multiply can be used if ARCH_SUPPORTS_INT128.

Reported-and-Tested-by: Christian Engelmayer <cengelma@gmx.at>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: fweisbec@gmail.com
Cc: Paul Turner <pjt@google.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131118172706.GI3866@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |   3 +-
 kernel/sched/fair.c   | 144 ++++++++++++++++++++++----------------------------
 2 files changed, 66 insertions(+), 81 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 96d674b..53f97eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -930,7 +930,8 @@ struct pipe_inode_info;
 struct uts_namespace;
 
 struct load_weight {
-	unsigned long weight, inv_weight;
+	unsigned long weight;
+	u32 inv_weight;
 };
 
 struct sched_avg {
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
