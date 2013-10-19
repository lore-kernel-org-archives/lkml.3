Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3JSPSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:18:07 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47053 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3JSPRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:17:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4/5] sched: Refactor iowait accounting
Date: Sat, 19 Oct 2013 17:17:20 +0200
Message-Id: <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iowait time accounting has awkward semantics. It is performed per
CPU. The iowait time of a CPU starts when a task sleeps on IO on
this CPU and stops when that task later wakes up on any CPU.

This assumes that a sleeping task is still assigned to the CPU
it was running on last until it wakes up. As such the iowait time stays
affine to that CPU until the io completes and the task runs again.

These assumptions are buggy given that a sleeping task is actually not
assigned to any CPU: it can be woken up to run on any target, not just
the CPU that dequeued it last. Thereby io wait time should be accounted
globally instead, or per the set of CPUs a task is allowed to run on.

Although it's tempting to remove such a buggy stat, it's important to
note that some subsystems rely on this accounting: the cpufreq subsystem
and also the procfs subsystem that displays this per cpu value through
the /proc/stat file. Even though we can work around the cpufreq case where
it appears that only few residual users rely on the iowait accounting,
the procfs file made a user ABI on top of it now. So it's not going to
be removed easily.

So we probably need to keep it on the short term. Now the way it is
implemented around the idle loop is racy. For example if CPU 0 sleeps
with pending IO for a while, then the sleeping task wakes up on CPU 1
while CPU 0 also exits idle to schedule a task, the iowait time may be
incidentally accounted twice or worse.

Since it can be updated concurrently, we need some sort of synchronization
there. This patch is inspired by a proposition of Peter Zijlstra.

We move the iowait accounting to the io schedule code and synchronize
the writers and readers with seqlocks.

Note that changes the iowait accounting semantics because the iowait
time was previously only called when the CPU was idle. Now it's
accounted as long as there is a task sleeping on IO.

Two issues with this:

* This breaks the idle_sleeptime accounting that computes a difference
against iowait time.

* Also the seqlock + local_clock is probably too much overhead for the
io schedule path.

So this patch is a just a fresher base to debate on a better solution.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h    |  1 +
 include/linux/tick.h     |  4 ---
 kernel/sched/core.c      | 68 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/cputime.c   |  2 +-
 kernel/sched/sched.h     |  5 +++-
 kernel/time/tick-sched.c | 44 +++----------------------------
 6 files changed, 71 insertions(+), 53 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 833eed5..a542fa9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -102,6 +102,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index a004f66..7a66bf6 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -47,7 +47,6 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
- * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
@@ -66,7 +65,6 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
-	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -138,7 +136,6 @@ extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
-extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 
 # else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
@@ -156,7 +153,6 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
-static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c3feeb..b3fa17a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2157,7 +2157,7 @@ unsigned long nr_iowait(void)
 	unsigned long i, sum = 0;
 
 	for_each_possible_cpu(i)
-		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+		sum += cpu_rq(i)->nr_iowait;
 
 	return sum;
 }
@@ -2165,7 +2165,7 @@ unsigned long nr_iowait(void)
 unsigned long nr_iowait_cpu(int cpu)
 {
 	struct rq *this = cpu_rq(cpu);
-	return atomic_read(&this->nr_iowait);
+	return this->nr_iowait;
 }
 
 #ifdef CONFIG_SMP
@@ -4064,6 +4064,59 @@ out_irq:
 }
 EXPORT_SYMBOL_GPL(yield_to);
 
+/**
+ * get_cpu_iowait_time_us - get the total iowait time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
+ *
+ * Return the cummulative iowait time (since boot) for a given
+ * CPU, in microseconds.
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ */
+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	ktime_t iowait, delta = { .tv64 = 0 };
+	struct rq *rq = cpu_rq(cpu);
+	ktime_t now = ktime_get();
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&rq->iowait_lock);
+		if (rq->nr_iowait)
+			delta = ktime_sub(now, rq->iowait_start);
+		iowait = ktime_add(rq->iowait_time, delta);
+	} while (read_seqretry(&rq->iowait_lock, seq));
+
+	if (last_update_time)
+		*last_update_time = ktime_to_us(now);
+
+	return ktime_to_us(iowait);
+}
+EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
+
+static void cpu_iowait_start(struct rq *rq)
+{
+	write_seqlock(&rq->iowait_lock);
+	if (!rq->nr_iowait++)
+		rq->iowait_start = ktime_get();
+	write_sequnlock(&rq->iowait_lock);
+}
+
+static void cpu_iowait_end(struct rq *rq)
+{
+	ktime_t delta;
+	write_seqlock(&rq->iowait_lock);
+	if (!--rq->nr_iowait) {
+		delta = ktime_sub(ktime_get(), rq->iowait_start);
+		rq->iowait_time = ktime_add(rq->iowait_time, delta);
+	}
+	write_sequnlock(&rq->iowait_lock);
+}
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
@@ -4073,12 +4126,12 @@ void __sched io_schedule(void)
 	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	cpu_iowait_start(rq);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	cpu_iowait_end(rq);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4089,12 +4142,12 @@ long __sched io_schedule_timeout(long timeout)
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	cpu_iowait_start(rq);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	cpu_iowait_end(rq);
 	delayacct_blkio_end();
 	return ret;
 }
@@ -6673,7 +6726,8 @@ void __init sched_init(void)
 #endif
 #endif
 		init_rq_hrtick(rq);
-		atomic_set(&rq->nr_iowait, 0);
+		rq->nr_iowait = 0;
+		seqlock_init(&rq->iowait_lock);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..4ba6cd2 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -248,7 +248,7 @@ void account_idle_time(cputime_t cputime)
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
-	if (atomic_read(&rq->nr_iowait) > 0)
+	if (rq->nr_iowait > 0)
 		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
 	else
 		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d69cb32..a385bae 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -457,7 +457,10 @@ struct rq {
 	u64 clock;
 	u64 clock_task;
 
-	atomic_t nr_iowait;
+	unsigned int nr_iowait;
+	ktime_t iowait_start;
+	ktime_t iowait_time;
+	seqlock_t iowait_lock;
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fbcb249..a038d4e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -408,9 +408,6 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 
 	/* Updates the per cpu time idle statistics counters */
 	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
-		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-
 	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
 
@@ -463,6 +460,10 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 
 	iowait = get_cpu_iowait_time_us(cpu, NULL);
 
+	/*
+	 * FIXME: Now that iowait time is accounted also when the CPU is non-idle,
+	 * this difference is broken.
+	 */
 	if (ktime_compare(idle, us_to_ktime(iowait)) > 0)
 		idle = ktime_sub_us(idle, iowait);
 
@@ -471,43 +472,6 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
-/**
- * get_cpu_iowait_time_us - get the total iowait time of a cpu
- * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
- *
- * Return the cummulative iowait time (since boot) for a given
- * CPU, in microseconds.
- *
- * This time is measured via accounting rather than sampling,
- * and is as accurate as ktime_get() is.
- *
- * This function returns -1 if NOHZ is not enabled.
- */
-u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
-{
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, iowait;
-
-	if (!tick_nohz_enabled)
-		return -1;
-
-	now = ktime_get();
-	if (last_update_time)
-		*last_update_time = ktime_to_us(now);
-
-	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		iowait = ktime_add(ts->iowait_sleeptime, delta);
-	} else {
-		iowait = ts->iowait_sleeptime;
-	}
-
-	return ktime_to_us(iowait);
-}
-EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
-
 static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 					 ktime_t now, int cpu)
 {
-- 
1.8.3.1

