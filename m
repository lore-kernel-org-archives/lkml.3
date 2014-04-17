Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaDQJjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:39:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51407 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDQJjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:39:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534FA11C.60709@jp.fujitsu.com>
Date: Thu, 17 Apr 2014 18:38:36 +0900
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
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] nohz: make updating sleep stats local
References: <534FA04B.8080906@jp.fujitsu.com>
In-Reply-To: <534FA04B.8080906@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is 1/2 of v4 patch set to fix an issue that idle/iowait
of /proc/stat can go backward. Originally reported by Tetsuo and
Fernando at last year, Mar 2013.

[BACKGROUNDS]: idle accounting on NO_HZ

  If NO_HZ is enabled, cpu stops tick interrupt for itself before
  go sleep to be idle. It means that time stats of the sleeping cpu
  will not be updated in tick interrupt. Instead when cpu wakes up,
  it updates time stats by calculating idle duration time from
  timestamp at entering idle and current time as exiting idle.

  OTOH, it can happen that there are some kind of observer who want
  to know how long the sleeping cpu have been idle. Imagine that
  userland runs top command or application who read /proc/stats.
  Therefore kernel provides get_cpu_{idle,iowait}_time_us() function
  for user to obtain current idle time stats of such sleeping cpu.
  This function reads time stats and timestamp at entering idle,
  and then return current idle time by adding duration calculated
  from timestamp and current time.

  There are 2 problems:
  (this patch 1/2 targets one, and following 2/2 targets another)

[PROBLEM 1]: there is no exclusive control.

  It is easy to understand that there are 2 different cpu - an
  observing cpu where running a program observing idle cpu's stat
  and an observed cpu where performing idle. It means race can
  happen if observed cpu wakes up while it is observed. Observer
  can accidentally add calculated duration time (say delta) to
  time stats which is just updated by woken cpu. Soon correct
  idle time is returned in next turn, so it will result in
  backward time. Therefore readers must be excluded by writer.

  Then time stats are updated by woken cpu so there are only one
  writer, right? No, unfortunately no. I'm not sure why are they,
  but in some reason the function get_cpu_{idle,iowait}_time_us()
  has ability to update sleeping cpu's time stats from observing
  cpu. From grep of today's kernel tree, this feature is used by
  cpuspeed module. Calling this function with this feature in
  periodically manner works like emulating tick for sleeping cpu.

  In summary there are races between multiple writer and mutiple
  reader but no exclusive control on this idle time stats dataset.

[WHAT THIS PATCH PROPOSED]:

  To fix problem 1, this patch 1/2 does following changes:

  - Stop updating from get_cpu_{idle,iowait}_time_us():
    It is hard to get reasonable performance with having exclusive
    locking for multiple writers. To limit the update areas to
    local, remove update functionality from these functions.
    It makes time stats to be updated by woken cpu only, so there
    are only one writer now!

  - Adds seqcount as exclusive locking for NO_HZ idle:
    It shoud be the minimum implemetation to avoid possible races
    between multiple readers vs. single writer. This lock protects:
    idle_active, idle_entrytime, idle_sleeptime, iowait_sleeptime.

  Now there is no other way to reach update_ts_time_stats(), fold
  this static routine into tick_nohz_stop_idle().

(Still there is problem 2. Continue to following patch 2/2.)

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reported-by: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/tick.h     |    5 ++-
 kernel/time/tick-sched.c |   75 ++++++++++++++++++++++------------------------
 2 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..00dd98d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -62,6 +62,7 @@ struct tick_sched {
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
 	int				idle_active;
+	seqcount_t			idle_sleeptime_seq;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
@@ -137,8 +138,8 @@ extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
-extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
-extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_idle_time_us(int cpu, u64 *wall);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *wall);
 
 # else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..c8314a1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -403,33 +403,23 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	touch_softlockup_watchdog();
 }
 
-/*
- * Updates the per cpu time idle statistics counters
- */
-static void
-update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
 	ktime_t delta;
 
-	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		if (nr_iowait_cpu(cpu) > 0)
-			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-		else
-			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		ts->idle_entrytime = now;
-	}
-
-	if (last_update_time)
-		*last_update_time = ktime_to_us(now);
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
 
-}
-
-static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
-{
-	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
+	/* Updates the per cpu time idle statistics counters */
+	delta = ktime_sub(now, ts->idle_entrytime);
+	if (nr_iowait_cpu(smp_processor_id()) > 0)
+		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+	else
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	ts->idle_entrytime = now;
 	ts->idle_active = 0;
 
+	write_seqcount_end(&ts->idle_sleeptime_seq);
+
 	sched_clock_idle_wakeup_event(0);
 }
 
@@ -437,8 +427,11 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	write_seqcount_end(&ts->idle_sleeptime_seq);
+
 	sched_clock_idle_sleep_event();
 	return now;
 }
@@ -446,10 +439,9 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
+ * @wall: variable to store current wall time in.
  *
- * Return the cummulative idle time (since boot) for a given
+ * Return the cumulative idle time (since boot) for a given
  * CPU, in microseconds.
  *
  * This time is measured via accounting rather than sampling,
@@ -457,19 +449,22 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  *
  * This function returns -1 if NOHZ is not enabled.
  */
-u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		idle = ts->idle_sleeptime;
-	} else {
+	if (wall)
+		*wall = ktime_to_us(now);
+
+	do {
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
+ 
 		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
@@ -477,7 +472,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		} else {
 			idle = ts->idle_sleeptime;
 		}
-	}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
 
@@ -487,10 +482,9 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 /**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
+ * @wall: variable to store current wall time in.
  *
- * Return the cummulative iowait time (since boot) for a given
+ * Return the cumulative iowait time (since boot) for a given
  * CPU, in microseconds.
  *
  * This time is measured via accounting rather than sampling,
@@ -498,19 +492,22 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  *
  * This function returns -1 if NOHZ is not enabled.
  */
-u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		iowait = ts->iowait_sleeptime;
-	} else {
+	if (wall)
+		*wall = ktime_to_us(now);
+
+	do {
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
+ 
 		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
@@ -518,7 +515,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		} else {
 			iowait = ts->iowait_sleeptime;
 		}
-	}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(iowait);
 }
-- 
1.7.1


