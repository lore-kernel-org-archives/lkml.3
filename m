Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaK1SYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:55 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64356 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaK1SYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:53 -0500
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
Subject: [RFC PATCH 23/30] cputime: Convert irq_time_accounting to use u64_stats_sync
Date: Fri, 28 Nov 2014 19:23:53 +0100
Message-Id: <1417199040-21044-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irqtime accounting internals uses open-coded u64_stats_sync. Lets
consolidate it with the relevant APIs.

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
 kernel/sched/cputime.c | 24 +++++++++---------------
 kernel/sched/sched.h   | 47 +++++++++++++----------------------------------
 2 files changed, 22 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index eefe1ec..f55633f 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -20,10 +20,8 @@
  * task when irq is in progress while we read rq->clock. That is a worthy
  * compromise in place of having locks on each irq in account_system_time.
  */
-DEFINE_PER_CPU(u64, cpu_hardirq_time);
-DEFINE_PER_CPU(u64, cpu_softirq_time);
+DEFINE_PER_CPU(struct cpu_irqtime, cpu_irqtime);
 
-static DEFINE_PER_CPU(u64, irq_start_time);
 static int sched_clock_irqtime;
 
 void enable_sched_clock_irqtime(void)
@@ -36,10 +34,6 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-#ifndef CONFIG_64BIT
-DEFINE_PER_CPU(seqcount_t, irq_time_seq);
-#endif /* CONFIG_64BIT */
-
 /*
  * Called before incrementing preempt_count on {soft,}irq_enter
  * and before decrementing preempt_count on {soft,}irq_exit.
@@ -56,10 +50,10 @@ void irqtime_account_irq(struct task_struct *curr)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
-	__this_cpu_add(irq_start_time, delta);
+	delta = sched_clock_cpu(cpu) - __this_cpu_read(cpu_irqtime.irq_start_time);
+	__this_cpu_add(cpu_irqtime.irq_start_time, delta);
 
-	irq_time_write_begin();
+	u64_stats_update_begin(this_cpu_ptr(&cpu_irqtime.stats_sync));
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
@@ -67,11 +61,11 @@ void irqtime_account_irq(struct task_struct *curr)
 	 * that do not consume any time, but still wants to run.
 	 */
 	if (hardirq_count())
-		__this_cpu_add(cpu_hardirq_time, delta);
+		__this_cpu_add(cpu_irqtime.hardirq_time, delta);
 	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
-		__this_cpu_add(cpu_softirq_time, delta);
+		__this_cpu_add(cpu_irqtime.softirq_time, delta);
 
-	irq_time_write_end();
+	u64_stats_update_end(this_cpu_ptr(&cpu_irqtime.stats_sync));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(irqtime_account_irq);
@@ -84,7 +78,7 @@ static int irqtime_account_hi_update(u64 threshold)
 	int ret = 0;
 
 	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_hardirq_time);
+	latest_ns = this_cpu_read(cpu_irqtime.hardirq_time);
 	if (latest_ns - cpustat[CPUTIME_IRQ] > threshold)
 		ret = 1;
 	local_irq_restore(flags);
@@ -99,7 +93,7 @@ static int irqtime_account_si_update(u64 threshold)
 	int ret = 0;
 
 	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_softirq_time);
+	latest_ns = this_cpu_read(cpu_irqtime.softirq_time);
 	if (latest_ns - cpustat[CPUTIME_SOFTIRQ] > threshold)
 		ret = 1;
 	local_irq_restore(flags);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..bb3e66f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,6 +8,7 @@
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
 #include <linux/slab.h>
+#include <linux/u64_stats_sync.h>
 
 #include "cpupri.h"
 #include "cpudeadline.h"
@@ -1521,49 +1522,27 @@ enum rq_nohz_flag_bits {
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
-DECLARE_PER_CPU(u64, cpu_hardirq_time);
-DECLARE_PER_CPU(u64, cpu_softirq_time);
+struct cpu_irqtime {
+	u64			hardirq_time;
+	u64			softirq_time;
+	u64			irq_start_time;
+	struct u64_stats_sync	stats_sync;
+};
 
-#ifndef CONFIG_64BIT
-DECLARE_PER_CPU(seqcount_t, irq_time_seq);
-
-static inline void irq_time_write_begin(void)
-{
-	__this_cpu_inc(irq_time_seq.sequence);
-	smp_wmb();
-}
-
-static inline void irq_time_write_end(void)
-{
-	smp_wmb();
-	__this_cpu_inc(irq_time_seq.sequence);
-}
+DECLARE_PER_CPU(struct cpu_irqtime, cpu_irqtime);
 
+/* Must be called with preemption disabled */
 static inline u64 irq_time_read(int cpu)
 {
 	u64 irq_time;
 	unsigned seq;
 
 	do {
-		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
-		irq_time = per_cpu(cpu_softirq_time, cpu) +
-			   per_cpu(cpu_hardirq_time, cpu);
-	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
+		seq = __u64_stats_fetch_begin(&per_cpu(cpu_irqtime, cpu).stats_sync);
+		irq_time = per_cpu(cpu_irqtime.softirq_time, cpu) +
+			   per_cpu(cpu_irqtime.hardirq_time, cpu);
+	} while (__u64_stats_fetch_retry(&per_cpu(cpu_irqtime, cpu).stats_sync, seq));
 
 	return irq_time;
 }
-#else /* CONFIG_64BIT */
-static inline void irq_time_write_begin(void)
-{
-}
-
-static inline void irq_time_write_end(void)
-{
-}
-
-static inline u64 irq_time_read(int cpu)
-{
-	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
-}
-#endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-- 
2.1.3

