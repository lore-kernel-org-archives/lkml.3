Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbaDJJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:14:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41498 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934776AbaDJJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:14:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534660D2.1080505@jp.fujitsu.com>
Date: Thu, 10 Apr 2014 18:13:54 +0900
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
Subject: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
References: <53465F54.708@jp.fujitsu.com>
In-Reply-To: <53465F54.708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is v3 of patch set to fix an issue that idle/iowait
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

My former patch happily changes get_cpu_{idle,iowait}_time_us()
not to update sleeping cpu's time stats from observing cpu.
It makes time stats to be updated by woken cpu only, so there
are only one writer now!

In summary there are races between one writer and multiple
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
even if cpu is sleeping. So it can happen that:

  given:
    idle time stats: idle=1000, iowait=100
    stamp at idle entry: entry=50
    nr tasks waiting io: nr_iowait=1

  observer temporary assigns delta as iowait at 1st place,
  (but does not do update (=account delta to time stats)):
    1st reader's query @ now = 60:
      idle=1000
      iowait=110 (=100+(60-50))

  then blocked tasks are migrated all:
    nr_iowait=0

  and at last in 2nd turn observer assign delta as idle:
    2nd reader's query @ now = 70:
      idle=1020 (=1000+(70-50))
      iowait=100

You will see that iowait is decreased from 110 to 100.

In summary iowait accounting has fundamental problem and needs
to be precisely reworked. It implies that some user interfaces
might be replaced completely. It will take long time to be
solved, so workaround for compatibility will be appreciated.

[WHAT THIS PATCH PROPOSED]:

To fix problem 1, this patch adds seqcount for NO_HZ idle
accounting to avoid possible races between reader/writer.

And to cope with problem 2, I introduced delayed iowait
accounting to get approximate value without making observers
to writers. Refer comment in patch for the detail.

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

  My previous patch set:
    [PATCH 0/2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/3/23/256
    [PATCH 0/2 v2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/3/30/315

v3: use seqcount instead of seqlock
    (achieved by inserting cleanup as former patch)
    plus introduce delayed iowait accounting

v2: update comments and description about problem 2.
    include fix for minor typo

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
 include/linux/tick.h     |    2 +
 kernel/time/tick-sched.c |   82 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 70a69d7..cec32e4 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -62,11 +62,13 @@ struct tick_sched {
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
 	int				idle_active;
+	seqcount_t			idle_sleeptime_seq;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	ktime_t				iowait_pending;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3887a05..03bc1c0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -407,15 +407,42 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
 	ktime_t delta;
 
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
+
 	/* Updates the per cpu time idle statistics counters */
 	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
+
+	/*
+	 * Perform delayed iowait accounting:
+	 *
+	 * We account sleep time as iowait when nr_iowait of cpu indicates
+	 * there are taskes blocked by io, at the end of idle (=here).
+	 * It means we can not determine whether the sleep time will be idle
+	 * or iowait on the fly.
+	 * Therefore introduce a new rule:
+	 * - basically observers assign delta to idle
+	 * - if cpu find nr_iowait>0 at idle exit, accumulate delta as missed
+	 *   iowait, and account it in next turn of sleep instead.
+	 * - if observer find accumulated iowait while cpu is in sleep, it
+	 *   can calculate proper value to be accounted.
+	 */
+	if (ktime_compare(ts->iowait_pending, delta) > 0) {
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	ts->idle_entrytime = now;
+		ts->iowait_pending = ktime_sub(ts->iowait_pending, delta);
+	} else {
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
+					ktime_sub(delta, ts->iowait_pending));
+		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
+						 ts->iowait_pending);
+		ts->iowait_pending = ktime_set(0, 0);
+	}
+	if (nr_iowait_cpu(smp_processor_id()) > 0)
+		ts->iowait_pending = ktime_add(ts->iowait_pending, delta);
+
 	ts->idle_active = 0;
 
+	write_seqcount_end(&ts->idle_sleeptime_seq);
+
 	sched_clock_idle_wakeup_event(0);
 }
 
@@ -423,8 +450,11 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
@@ -445,7 +475,8 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, idle;
+	ktime_t now, idle, delta;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
@@ -454,16 +485,21 @@ u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 	if (wall)
 		*wall = ktime_to_us(now);
 
-	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-
-		idle = ktime_add(ts->idle_sleeptime, delta);
-	} else {
+	do {
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-	}
 
-	return ktime_to_us(idle);
+		if (ts->idle_active) {
+			/* delta is sum of unaccounted idle/iowait */
+			delta = ktime_sub(now, ts->idle_entrytime);
+			if (ktime_compare(delta, ts->iowait_pending) > 0) {
+				delta = ktime_sub(delta, ts->iowait_pending);
+				idle = ktime_add(idle, delta);
+			}
+		}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
+	return ktime_to_us(idle);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
@@ -483,7 +519,8 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, iowait;
+	ktime_t now, iowait, delta;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
@@ -492,13 +529,20 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 	if (wall)
 		*wall = ktime_to_us(now);
 
-	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-
-		iowait = ktime_add(ts->iowait_sleeptime, delta);
-	} else {
+	do {
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		iowait = ts->iowait_sleeptime;
-	}
+
+		if (ts->idle_active) {
+			/* delta is sum of unaccounted idle/iowait */
+			delta = ktime_sub(now, ts->idle_entrytime);
+			if (ktime_compare(delta, ts->iowait_pending) < 0) {
+				iowait = ktime_add(iowait, delta);
+			} else {
+				iowait = ktime_add(iowait, ts->iowait_pending);
+			}
+		}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(iowait);
 }
-- 
1.7.1


