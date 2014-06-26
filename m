Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaFZJCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:02:12 -0400
Received: from fgwmail3.fujitsu.co.jp ([164.71.1.134]:47537 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756169AbaFZJCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:02:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE13F.5030203@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:00:47 +0900
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
Subject: [PATCH] nohz: make updating sleep stats local, add seqcount
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since update_ts_time_stats() has no exclusive control while it can
be called from both of local cpu and remote cpu, sleep stats will go
wrong if updates conflict, and stats can be referred while update is
going on. It will cause bloat and/or hiccup (jump and turn back) of
idle/iowait values appeared in /proc/stats.

  - Stop updating from get_cpu_{idle,iowait}_time_us():
    It is hard to get reasonable performance with having exclusive
    locking for multiple writers. To limit the update areas to
    local, remove update functionality from these functions.
    It makes time stats to be updated by woken cpu only, so there
    are only one writer now.

  - Adds seqcount:
    It should be the minimum implementation to avoid possible races
    between multiple readers vs. single writer. This lock protects:
    idle_active, idle_entrytime, idle_sleeptime, iowait_sleeptime.

Minor cleanups included:

  - Rename last_update_time to wall:
    Now these function do not perform update. Change arg name and
    comments to fit new behavior.

  - Now there is no other way to reach update_ts_time_stats(), fold
    this static routine into tick_nohz_stop_idle().

v5: rebased onto v3.16-rc2.
    update patch description, separate from following changes.
    (patch body does not changed from 1/2 of v4)
v1-4: https://lkml.org/lkml/2014/4/17/120

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
index 6558b7a..44eb187 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -406,33 +406,23 @@ static void tick_nohz_update_jiffies(ktime_t now)
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
 
@@ -440,8 +430,11 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
@@ -449,10 +442,9 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
@@ -460,19 +452,22 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
 
@@ -480,7 +475,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		} else {
 			idle = ts->idle_sleeptime;
 		}
-	}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
 
@@ -490,10 +485,9 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
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
@@ -501,19 +495,22 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
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
 
@@ -521,7 +518,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		} else {
 			iowait = ts->iowait_sleeptime;
 		}
-	}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(iowait);
 }
-- 
1.7.1


