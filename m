Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaCaCJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:09:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38331 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaCaCJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:09:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5338CE43.2000402@jp.fujitsu.com>
Date: Mon, 31 Mar 2014 11:09:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 2/2] nohz, procfs: introduce get_cpu_idle/iowait_time_coarse
References: <5338CC86.9080602@jp.fujitsu.com>
In-Reply-To: <5338CC86.9080602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is 2/2 of patch set to fix an issue that idle/iowait
of /proc/stat can go backward. Originally reported by Tetsuo and
Fernando at last year, Mar 2013.

Now it is clear that get_cpu_{idle,iowait}_time_us() is not monotonic.
Using this for /proc/stats will cause troubles in innocent userland
who believe these counters are definitely monotonic.

Given that:

  - If observer (=reader of /proc/stats) want to avoid backwarding,
    it must update time stats for next observer. It means observer
    determine delta to idle/iowait and account it for sleeping cpu.

  - Usually the number of observers will not so many (i.e. running
    top on few console or hiring few monitor program will be enough
    for average system admin), but we must predict the worst case.
    In short, make effort to reduce lock contention.

  - The resolution required in /proc/stats is tick-level, not us.

This patch introduces new function get_cpu_idle/iowait_time_coarse()
that guarantees monotonic return value but resolution is low.

Tricks are here:

  - At first this function obtain latest time stats and calculate
    "delta" which indicates duration from time when the time stats
    is updated last time to current time.

  - If delta is less than tick length, use obtained time stats
    as if it was sampled in tick interrupt recently happened.

  - If delta is greater than tick, perform update of time stats
    as if it emulates tick for sleeping observed cpu.

  - As the result the rate of updating time stats by observer is
    limited to once per tick. In other words, in case if there is
    observer who are monitoring sleeping cpu, we leave tick
    emulation job during idle to the observer.

I confirmed this patch fix the monotonicity of /proc/stats, by
running reproducer and stressor for a day. The rate of reproduce
is different for different system, but in my case, running
"git gc" on kernel source repository aside of checker works fine.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Reported-by: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/stat.c           |   16 +++------
 include/linux/tick.h     |    4 ++
 kernel/time/tick-sched.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6f599c6..3dbe282 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -45,32 +45,28 @@ static cputime64_t get_iowait_time(int cpu)
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = -1ULL;
+	u64 idle = -1ULL;
 
 	if (cpu_online(cpu))
-		idle_time = get_cpu_idle_time_us(cpu, NULL);
+		idle = get_cpu_idle_time_coarse(cpu);
 
-	if (idle_time == -1ULL)
+	if (idle == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
-	else
-		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
 }
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = -1ULL;
+	u64 iowait = -1ULL;
 
 	if (cpu_online(cpu))
-		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+		iowait = get_cpu_iowait_time_coarse(cpu);
 
-	if (iowait_time == -1ULL)
+	if (iowait == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
-	else
-		iowait = usecs_to_cputime64(iowait_time);
 
 	return iowait;
 }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f6f4ac1..3b4674d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -140,6 +140,8 @@ extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_idle_time_coarse(int cpu);
+extern u64 get_cpu_iowait_time_coarse(int cpu);
 
 # else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
@@ -158,6 +160,8 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
+static inline u64 get_cpu_idle_time_coarse(int cpu) { return -1; }
+static inline u64 get_cpu_iowait_time_coarse(int cpu) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6641c56..4bf22d2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -592,6 +592,85 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
+/**
+ * get_cpu_idle_time_coarse - get coarse idle time of a cpu
+ * @cpu: CPU number to query
+ *
+ * Return the cumulative idle time (since boot) for a given
+ * CPU, in tick resolution (for traditional UI like /proc/stat).
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_idle_time_coarse(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, idle, delta;
+	unsigned int seq;
+
+	if (!tick_nohz_active)
+		return -1;
+
+	if (!ts->idle_active)
+		return usecs_to_cputime64(ktime_to_us(ts->idle_sleeptime));
+
+	now = ktime_get();
+
+	do {
+		seq = read_seqbegin(&ts->idle_sleeptime_seq);
+		idle = ts->idle_sleeptime;
+		delta = ktime_sub(now, ts->idle_entrytime);
+	} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
+
+	/*
+	 * If delta is less than tick, use current value and just
+	 * ignore the delta. Otherwise perform update.
+	 */
+	if (ktime_compare(delta, ns_to_ktime(TICK_NSEC)) > 0)
+		update_ts_time_stats(cpu, ts, now, &idle, NULL, 0);
+
+	return usecs_to_cputime64(ktime_to_us(idle));
+
+}
+
+/**
+ * get_cpu_iowait_time_coarse - get coarse iowait time of a cpu
+ * @cpu: CPU number to query
+ *
+ * Return the cumulative iowait time (since boot) for a given
+ * CPU, in tick resolution (for traditional UI like /proc/stat).
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_iowait_time_coarse(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, iowait, delta;
+	unsigned int seq;
+
+	if (!tick_nohz_active)
+		return -1;
+
+	if (!ts->idle_active)
+		return usecs_to_cputime64(ktime_to_us(ts->iowait_sleeptime));
+
+	now = ktime_get();
+
+	do {
+		seq = read_seqbegin(&ts->idle_sleeptime_seq);
+		iowait = ts->iowait_sleeptime;
+		delta = ktime_sub(now, ts->idle_entrytime);
+	} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
+
+	/*
+	 * If delta is less than tick, use current value and just
+	 * ignore the delta. Otherwise perform update.
+	 */
+	if (ktime_compare(delta, ns_to_ktime(TICK_NSEC)) > 0)
+		update_ts_time_stats(cpu, ts, now, NULL, &iowait, 0);
+
+	return usecs_to_cputime64(ktime_to_us(iowait));
+}
+
 static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 					 ktime_t now, int cpu)
 {
-- 
1.7.1


