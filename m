Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaK1SY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:58 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42566 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaK1SYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:55 -0500
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
Subject: [RFC PATCH 24/30] cputime: Increment kcpustat directly on irqtime account
Date: Fri, 28 Nov 2014 19:23:54 +0100
Message-Id: <1417199040-21044-25-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irqtime is accounted is nsecs and stored in
cpu_irq_time.hardirq_time and cpu_irq_time.softirq_time. Once the
accumulated amount reaches a new jiffy, this one gets accounted to the
kcpustat.

This was necessary when kcpustat was stored in cputime_t, which could at
worst have a jiffies granularity. But now kcpustat is stored in nsecs
so this whole discretization game with temporary irqtime storage has
become unnecessary.

We can now directly account the irqtime to the kcpustat.

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
 kernel/sched/cputime.c | 48 ++++++++++++++++++++----------------------------
 kernel/sched/sched.h   |  1 +
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index f55633f..6e3beba 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -40,6 +40,7 @@ void disable_sched_clock_irqtime(void)
  */
 void irqtime_account_irq(struct task_struct *curr)
 {
+	u64 *cpustat;
 	unsigned long flags;
 	s64 delta;
 	int cpu;
@@ -47,6 +48,8 @@ void irqtime_account_irq(struct task_struct *curr)
 	if (!sched_clock_irqtime)
 		return;
 
+	cpustat = kcpustat_this_cpu->cpustat;
+
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
@@ -60,42 +63,33 @@ void irqtime_account_irq(struct task_struct *curr)
 	 * in that case, so as not to confuse scheduler with a special task
 	 * that do not consume any time, but still wants to run.
 	 */
-	if (hardirq_count())
+	if (hardirq_count()) {
 		__this_cpu_add(cpu_irqtime.hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+		cpustat[CPUTIME_IRQ] += delta;
+		__this_cpu_add(cpu_irqtime.tick_skip, delta);
+	} else if (in_serving_softirq() && curr != this_cpu_ksoftirqd()) {
 		__this_cpu_add(cpu_irqtime.softirq_time, delta);
+		cpustat[CPUTIME_SOFTIRQ] += delta;
+		__this_cpu_add(cpu_irqtime.tick_skip, delta);
+	}
 
 	u64_stats_update_end(this_cpu_ptr(&cpu_irqtime.stats_sync));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(irqtime_account_irq);
 
-static int irqtime_account_hi_update(u64 threshold)
+static int irqtime_skip_tick(u64 cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
-	u64 latest_ns;
+	u64 skip;
 	int ret = 0;
 
 	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_irqtime.hardirq_time);
-	if (latest_ns - cpustat[CPUTIME_IRQ] > threshold)
-		ret = 1;
-	local_irq_restore(flags);
-	return ret;
-}
-
-static int irqtime_account_si_update(u64 threshold)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	unsigned long flags;
-	u64 latest_ns;
-	int ret = 0;
-
-	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_irqtime.softirq_time);
-	if (latest_ns - cpustat[CPUTIME_SOFTIRQ] > threshold)
+	skip = this_cpu_read(cpu_irqtime.tick_skip);
+	if (cputime >= skip) {
+		__this_cpu_sub(cpu_irqtime.tick_skip, cputime);
 		ret = 1;
+	}
 	local_irq_restore(flags);
 	return ret;
 }
@@ -336,7 +330,6 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 cputime = (__force u64) cputime_one_jiffy;
 	u64 nsec = cputime_to_nsecs(cputime); //TODO: make that build time
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
@@ -344,11 +337,10 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	cputime *= ticks;
 	scaled *= ticks;
 
-	if (irqtime_account_hi_update(nsec)) {
-		cpustat[CPUTIME_IRQ] += nsec;
-	} else if (irqtime_account_si_update(nsec)) {
-		cpustat[CPUTIME_SOFTIRQ] += nsec;
-	} else if (this_cpu_ksoftirqd() == p) {
+	if (irqtime_skip_tick(nsec))
+		return;
+
+	if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb3e66f..f613053 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1526,6 +1526,7 @@ struct cpu_irqtime {
 	u64			hardirq_time;
 	u64			softirq_time;
 	u64			irq_start_time;
+	u64			tick_skip;
 	struct u64_stats_sync	stats_sync;
 };
 
-- 
2.1.3

