Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaCXDLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:11:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60457 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCXDLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:11:03 -0400
Message-ID: <532FA20E.7090709@jp.fujitsu.com>
Date: Mon, 24 Mar 2014 12:10:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats
References: <532FA0E8.4050106@jp.fujitsu.com>
In-Reply-To: <532FA0E8.4050106@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is 1/2 of patch set to fix an issue that idle/iowait
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
cpufreq module. Calling this function with this feature in
periodically manner works like emulating tick for sleeping cpu.

In summary there are races between multiple writer and multiple
reader but no exclusive control on this idle time stats dataset.

[PROBLEM 2]: broken iowait accounting.

As historical nature, cpu's idle time was accounted as either
idle or iowait depending on the presence of tasks blocked by
I/O. No one complain about it for a long time. However:

  > Still trying to wrap my head around it, but conceptually
  > get_cpu_iowait_time_us() doesn't make any kind of sense.
  > iowait isn't per cpu since effectively tasks that aren't
  > running aren't assigned a cpu (as Oleg already pointed out).
  -- Peter Zijlstra

Now some kernel folks realized that accounting iowait as per-cpu
does not make sense in SMP world. When we were in traditional
UP era, cpu is considered to be waiting I/O if it is idle while
nr_iowait > 0. But in these days with SMP systems, tasks easily
migrate from a cpu where they issued an I/O to another cpu where
they are queued after I/O completion.

Back to NO_HZ mechanism. Totally terrible thing here is that
observer need to handle duration "delta" without knowing that
nr_iowait of sleeping cpu can be changed easily by migration
even if cpu is sleeping. So it can happen that observer temporary
assign delta as iowait at 1st place, then blocked tasks are
migrated all, and at last in 2nd turn observer assign delta as
idle. You will see that delta have moved from iowait to idle.

In summary iowait accounting has fundamental problem and needs
to be precisely reworked. It implies that some user interfaces
might be replaced completely.

[WHAT THIS PATCH PROPOSED]: fix problem 1 first.

To fix problem 1, this patch adds seqlock for NO_HZ idle
accounting to avoid possible races between multiple reader/writer.

And to cope with problem 2, I add comments to note that there
is known issues.

Thanks,
H.Seto

References:
  First report from Fernando:
    [RFC] iowait/idle time accounting hiccups in NOHZ kernels
    https://lkml.org/lkml/2013/3/18/962
  Steps to reproduce guided by Tetsuo:
    https://lkml.org/lkml/2013/4/1/201

  1st patchset from Frederic:
    [PATCH 0/4] nohz: Fix racy sleeptime stats
    https://lkml.org/lkml/2013/8/8/638
    [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
    https://lkml.org/lkml/2013/8/16/274

  2nd patchset from Frederic:
    [RFC PATCH 0/5] nohz: Fix racy sleeptime stats v2
    https://lkml.org/lkml/2013/10/19/86

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
---
 include/linux/tick.h     |    1 +
 kernel/time/tick-sched.c |   92 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..f6f4ac1 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -62,6 +62,7 @@ struct tick_sched {
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
 	int				idle_active;
+	seqlock_t			idle_sleeptime_seq;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..da37125 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -407,11 +407,23 @@ static void tick_nohz_update_jiffies(ktime_t now)
  * Updates the per cpu time idle statistics counters
  */
 static void
-update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now,
+		     ktime_t *idle, ktime_t *iowait, int last)
 {
 	ktime_t delta;
 
-	if (ts->idle_active) {
+	write_seqlock(&ts->idle_sleeptime_seq);
+
+	/* now must be newer/greater than entrytime */
+	if (ts->idle_active && (ktime_compare(now, ts->idle_entrytime) > 0)) {
+		/*
+		 * FIXME: Since nr_iowait of sleeping cpu can change from/to
+		 * 0 while in this span from idle_entrytime to now, we have no
+		 * idea how to divide the delta to idle_sleeptime and/or
+		 * iowait_sleeptime.
+		 * So as traditional non-proper estimation for workaround,
+		 * take the delta depending on the current value of nr_iowait.
+		 */
 		delta = ktime_sub(now, ts->idle_entrytime);
 		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
@@ -420,16 +432,19 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 		ts->idle_entrytime = now;
 	}
 
-	if (last_update_time)
-		*last_update_time = ktime_to_us(now);
+	if (idle)
+		*idle = ts->idle_sleeptime;
+	if (iowait)
+		*iowait = ts->iowait_sleeptime;
+	if (last)
+		ts->idle_active = 0;
 
+	write_sequnlock(&ts->idle_sleeptime_seq);
 }
 
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
-	ts->idle_active = 0;
-
+	update_ts_time_stats(smp_processor_id(), ts, now, NULL, NULL, 1);
 	sched_clock_idle_wakeup_event(0);
 }
 
@@ -437,8 +452,11 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
+	write_seqlock(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	write_sequnlock(&ts->idle_sleeptime_seq);
+
 	sched_clock_idle_sleep_event();
 	return now;
 }
@@ -455,6 +473,10 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  * This time is measured via accounting rather than sampling,
  * and is as accurate as ktime_get() is.
  *
+ * Known bug: Return value is not monotonic in case if @last_update_time
+ * is NULL and therefore update is not performed. Because it includes
+ * cputime which is not determined idle or iowait so not accounted yet.
+ *
  * This function returns -1 if NOHZ is not enabled.
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
@@ -467,16 +489,28 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 
 	now = ktime_get();
 	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		idle = ts->idle_sleeptime;
+		update_ts_time_stats(cpu, ts, now, &idle, NULL, 0);
+		*last_update_time = ktime_to_us(now);
 	} else {
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		unsigned int seq;
 
-			idle = ktime_add(ts->idle_sleeptime, delta);
-		} else {
+		do {
+			seq = read_seqbegin(&ts->idle_sleeptime_seq);
 			idle = ts->idle_sleeptime;
-		}
+			/*
+			 * FIXME: At this point, delta is determined neither
+			 * idle nor iowait. This function temporarily treat
+			 * this delta depending on the value of nr_iowait
+			 * when this function reaches here. It will result
+			 * in non-monotonic return value. So user of this
+			 * function must not expect monotonicity here.
+			 */
+			if (ts->idle_active && !nr_iowait_cpu(cpu)
+			    && (ktime_compare(now, ts->idle_entrytime) > 0)) {
+				ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+				idle = ktime_add(ts->idle_sleeptime, delta);
+			}
+		} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
 	}
 
 	return ktime_to_us(idle);
@@ -496,6 +530,10 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  * This time is measured via accounting rather than sampling,
  * and is as accurate as ktime_get() is.
  *
+ * Known bug: Return value is not monotonic in case if @last_update_time
+ * is NULL and therefore update is not performed. Because it includes
+ * cputime which is not determined idle or iowait so not accounted yet.
+ *
  * This function returns -1 if NOHZ is not enabled.
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
@@ -508,16 +546,28 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 
 	now = ktime_get();
 	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		iowait = ts->iowait_sleeptime;
+		update_ts_time_stats(cpu, ts, now, NULL, &iowait, 0);
+		*last_update_time = ktime_to_us(now);
 	} else {
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		unsigned int seq;
 
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
-		} else {
+		do {
+			seq = read_seqbegin(&ts->idle_sleeptime_seq);
 			iowait = ts->iowait_sleeptime;
-		}
+			/*
+			 * FIXME: At this point, delta is determined neither
+			 * idle nor iowait. This function temporarily treat
+			 * this delta depending on the value of nr_iowait
+			 * when this function reaches here. It will result
+			 * in non-monotonic return value. So user of this
+			 * function must not expect monotonicity here.
+			 */
+			if (ts->idle_active && nr_iowait_cpu(cpu) > 0
+			    && (ktime_compare(now, ts->idle_entrytime) > 0)) {
+				ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+				iowait = ktime_add(ts->iowait_sleeptime, delta);
+			}
+		} while (read_seqretry(&ts->idle_sleeptime_seq, seq));
 	}
 
 	return ktime_to_us(iowait);
-- 
1.7.1


