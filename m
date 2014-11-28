Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaK1S0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:26:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36159 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaK1SY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:56 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 25/30] cputime: Remove temporary irqtime states
Date: Fri, 28 Nov 2014 19:23:55 +0100
Message-Id: <1417199040-21044-26-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the temporary irqtime storage has become unnecessary, lets
remove it.

This involves to move the u64_stat_sync seqlock to the kcpustat directly
in order to keep coherent irqtime reads from the scheduler.

This seqlock can be used as well for other kcpustat. The need hasn't
yet arised as nobody seem to complain about possible erroneous
/proc/cpustat values due to 64 bits values read in two passes in 32 bits
CPUs. But at least we are prepared for that.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/kernel_stat.h |  2 ++
 kernel/sched/cputime.c      | 40 ++++++++++++++++++++++------------------
 kernel/sched/sched.h        | 22 ++++++----------------
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4e..585ced4 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -10,6 +10,7 @@
 #include <linux/vtime.h>
 #include <asm/irq.h>
 #include <linux/cputime.h>
+#include <linux/u64_stats_sync.h>
 
 /*
  * 'kernel_stat.h' contains the definitions needed for doing
@@ -33,6 +34,7 @@ enum cpu_usage_stat {
 
 struct kernel_cpustat {
 	u64 cpustat[NR_STATS];
+	struct u64_stats_sync stats_sync;
 };
 
 struct kernel_stat {
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 6e3beba..f675008 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -8,6 +8,23 @@
 
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
+struct cpu_irqtime {
+	u64			irq_start_time;
+	u64			tick_skip;
+};
+static DEFINE_PER_CPU(struct cpu_irqtime, cpu_irqtime);
+
+static int sched_clock_irqtime;
+
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+
+void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
 
 /*
  * There are no locks covering percpu hardirq/softirq time.
@@ -20,19 +37,6 @@
  * task when irq is in progress while we read rq->clock. That is a worthy
  * compromise in place of having locks on each irq in account_system_time.
  */
-DEFINE_PER_CPU(struct cpu_irqtime, cpu_irqtime);
-
-static int sched_clock_irqtime;
-
-void enable_sched_clock_irqtime(void)
-{
-	sched_clock_irqtime = 1;
-}
-
-void disable_sched_clock_irqtime(void)
-{
-	sched_clock_irqtime = 0;
-}
 
 /*
  * Called before incrementing preempt_count on {soft,}irq_enter
@@ -40,6 +44,7 @@ void disable_sched_clock_irqtime(void)
  */
 void irqtime_account_irq(struct task_struct *curr)
 {
+	struct kernel_cpustat *kcpustat;
 	u64 *cpustat;
 	unsigned long flags;
 	s64 delta;
@@ -48,7 +53,8 @@ void irqtime_account_irq(struct task_struct *curr)
 	if (!sched_clock_irqtime)
 		return;
 
-	cpustat = kcpustat_this_cpu->cpustat;
+	kcpustat = kcpustat_this_cpu;
+	cpustat = kcpustat->cpustat;
 
 	local_irq_save(flags);
 
@@ -56,7 +62,7 @@ void irqtime_account_irq(struct task_struct *curr)
 	delta = sched_clock_cpu(cpu) - __this_cpu_read(cpu_irqtime.irq_start_time);
 	__this_cpu_add(cpu_irqtime.irq_start_time, delta);
 
-	u64_stats_update_begin(this_cpu_ptr(&cpu_irqtime.stats_sync));
+	u64_stats_update_begin(&kcpustat->stats_sync);
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
@@ -64,16 +70,14 @@ void irqtime_account_irq(struct task_struct *curr)
 	 * that do not consume any time, but still wants to run.
 	 */
 	if (hardirq_count()) {
-		__this_cpu_add(cpu_irqtime.hardirq_time, delta);
 		cpustat[CPUTIME_IRQ] += delta;
 		__this_cpu_add(cpu_irqtime.tick_skip, delta);
 	} else if (in_serving_softirq() && curr != this_cpu_ksoftirqd()) {
-		__this_cpu_add(cpu_irqtime.softirq_time, delta);
 		cpustat[CPUTIME_SOFTIRQ] += delta;
 		__this_cpu_add(cpu_irqtime.tick_skip, delta);
 	}
 
-	u64_stats_update_end(this_cpu_ptr(&cpu_irqtime.stats_sync));
+	u64_stats_update_end(&kcpustat->stats_sync);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(irqtime_account_irq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f613053..1ca6c82 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,7 +8,7 @@
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
 #include <linux/slab.h>
-#include <linux/u64_stats_sync.h>
+#include <linux/kernel_stat.h>
 
 #include "cpupri.h"
 #include "cpudeadline.h"
@@ -1521,28 +1521,18 @@ enum rq_nohz_flag_bits {
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-
-struct cpu_irqtime {
-	u64			hardirq_time;
-	u64			softirq_time;
-	u64			irq_start_time;
-	u64			tick_skip;
-	struct u64_stats_sync	stats_sync;
-};
-
-DECLARE_PER_CPU(struct cpu_irqtime, cpu_irqtime);
-
 /* Must be called with preemption disabled */
 static inline u64 irq_time_read(int cpu)
 {
+	struct kernel_cpustat *kcpustat = &kcpustat_cpu(cpu);
 	u64 irq_time;
 	unsigned seq;
 
 	do {
-		seq = __u64_stats_fetch_begin(&per_cpu(cpu_irqtime, cpu).stats_sync);
-		irq_time = per_cpu(cpu_irqtime.softirq_time, cpu) +
-			   per_cpu(cpu_irqtime.hardirq_time, cpu);
-	} while (__u64_stats_fetch_retry(&per_cpu(cpu_irqtime, cpu).stats_sync, seq));
+		seq = __u64_stats_fetch_begin(&kcpustat->stats_sync);
+		irq_time = kcpustat->cpustat[CPUTIME_SOFTIRQ] +
+			   kcpustat->cpustat[CPUTIME_IRQ];
+	} while (__u64_stats_fetch_retry(&kcpustat->stats_sync, seq));
 
 	return irq_time;
 }
-- 
2.1.3

