Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043AbaDJJLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:11:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41317 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783AbaDJJLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:11:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53466027.3040705@jp.fujitsu.com>
Date: Thu, 10 Apr 2014 18:11:03 +0900
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
Subject: [PATCH 1/2] nohz: stop updating sleep stats from get_cpu_{idle,iowait}_time_us()
References: <53465F54.708@jp.fujitsu.com>
In-Reply-To: <53465F54.708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It easily cause race because multiple caller can write data without
any exclusive locking. To limit the update areas to local, remove update
functionality from these functions.

Now there is no other way to reach update_ts_time_stats(), fold this
static routine into tick_nohz_stop_idle().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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
 include/linux/tick.h     |    4 +-
 kernel/time/tick-sched.c |   76 +++++++++++++++++-----------------------------
 2 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..70a69d7 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -137,8 +137,8 @@ extern void tick_nohz_idle_enter(void);
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
index 9f8af69..3887a05 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -403,31 +403,17 @@ static void tick_nohz_update_jiffies(ktime_t now)
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
-
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
 
 	sched_clock_idle_wakeup_event(0);
@@ -446,8 +432,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
+ * @wall: variable to store current wall time in.
  *
  * Return the cummulative idle time (since boot) for a given
  * CPU, in microseconds.
@@ -457,7 +442,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  *
  * This function returns -1 if NOHZ is not enabled.
  */
-u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
@@ -466,17 +451,15 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		idle = ts->idle_sleeptime;
-	} else {
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+	if (wall)
+		*wall = ktime_to_us(now);
 
-			idle = ktime_add(ts->idle_sleeptime, delta);
-		} else {
-			idle = ts->idle_sleeptime;
-		}
+	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+
+		idle = ktime_add(ts->idle_sleeptime, delta);
+	} else {
+		idle = ts->idle_sleeptime;
 	}
 
 	return ktime_to_us(idle);
@@ -487,8 +470,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 /**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
+ * @wall: variable to store current wall time in.
  *
  * Return the cummulative iowait time (since boot) for a given
  * CPU, in microseconds.
@@ -498,7 +480,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  *
  * This function returns -1 if NOHZ is not enabled.
  */
-u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
@@ -507,17 +489,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		iowait = ts->iowait_sleeptime;
-	} else {
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+	if (wall)
+		*wall = ktime_to_us(now);
 
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
-		} else {
-			iowait = ts->iowait_sleeptime;
-		}
+	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+
+		iowait = ktime_add(ts->iowait_sleeptime, delta);
+	} else {
+		iowait = ts->iowait_sleeptime;
 	}
 
 	return ktime_to_us(iowait);
-- 
1.7.1


