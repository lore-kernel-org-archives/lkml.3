Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaDQJmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:42:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55369 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaDQJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:42:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534FA1D5.7040808@jp.fujitsu.com>
Date: Thu, 17 Apr 2014 18:41:41 +0900
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
Subject: [PATCH 2/2] nohz: delayed iowait accounting for nohz idle time stats
References: <534FA04B.8080906@jp.fujitsu.com>
In-Reply-To: <534FA04B.8080906@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is 2/2 of v4 patch set to fix an issue that idle/iowait
of /proc/stat can go backward. Originally reported by Tetsuo and
Fernando at last year, Mar 2013.

(Continued from previous patch 1/2.)

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
  nr_iowait of sleeping cpu can be changed easily by woken tasks
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

    then blocked task is queued to runqueue of other active cpu,
    woken up from io_schedule{,_timeout}() and do atomic_dec()
    from the remote:
      nr_iowait=0

    and at last in 2nd turn observer assign delta as idle:
      2nd reader's query @ now = 70:
        idle=1020 (=1000+(70-50))
        iowait=100

  You will see that iowait is decreased from 110 to 100.

  In summary, the original problem that iowait of /proc/stats can
  go backward is a kind of hidden bug, while at the same time iowait
  accounting has fundamental problem and needs to be precisely
  reworked.

[TARGET OF THIS PATCH]:

  Complete rework for iowait accounting implies that some user
  interfaces might be replaced completely. It will introduce new
  counter or so, and kill per-cpu iowait counter which is known to
  being nonsense. It will take long time to be achieved, considering
  time to make the problem to a public knowledge, and also time for
  interface transition. Anyway as long as linux try to be reliable OS,
  such drastic change must be placed on mainline kernel in development
  sooner or later.

  OTOH, drastic change like above is not acceptable for conservative
  environment, such as stable kernels, some distributor's kernel and
  so on, due to respect for compatibility. Still these kernel expects
  per-cpu iowait counter works as well as it might have been.
  Therefore for such environment, applying a simple patch to fix
  behavior of counter will be appreciated rather than replacing an
  over-used interface or changing an existing usage/semantics.

  This patch targets latter kernels mainly. It does not do too much,
  but intend to fix the idle stats counters to be monotonic. I believe
  that mainline kernel should pick up this patch too, because it
  surely fix a hidden bug and does not intercept upcoming drastic
  change.

  Again, in summary, this patch does not do drastic change to cope
  with problem 2. But it just fix behavior of idle/iowait counter of
  /proc/stats.

[WHAT THIS PATCH PROPOSED]:

  The main reason of the bug is that observers have no idea to
  determine the delta to be idle or iowait at the first place.

  So I introduced delayed iowait accounting to allow observers to
  assign delta based on status of observed cpu at idle entry.

  Refer comment in patch for the detail.

[References]:

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
    [PATCH v3 0/2] nohz: fix idle accounting in NO_HZ kernels
    https://lkml.org/lkml/2014/4/10/133

v4: rework delayed iowait accounting: check nr_iowait at entry
    (not to account iowait at out of io boundary)
    update description/comments to explain more details

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
 include/linux/tick.h     |    1 +
 kernel/time/tick-sched.c |  122 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 00dd98d..cec32e4 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -68,6 +68,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	ktime_t				iowait_pending;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c8314a1..95e18bd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -405,16 +405,90 @@ static void tick_nohz_update_jiffies(ktime_t now)
 
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
+	static const ktime_t ktime_zero = { .tv64 = 0 };
 	ktime_t delta;
 
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 
 	/* Updates the per cpu time idle statistics counters */
 	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
-		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
+
+	if (ts->idle_active == 1) {
+		/* delta is idle */
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	} else {
+		/*
+		 * delta is sum of idle/iowait:
+		 *
+		 * We account sleep time as iowait when nr_iowait of cpu
+		 * indicates there are tasks blocked by io, at the end of
+		 * idle (=here).
+		 * It means observers (=who query sleeping cpu's idle stats)
+		 * can not determine whether the unaccounted sleep time will
+		 * be idle or iowait on the fly.
+		 *
+		 * Therefore introduce following mechanism:
+		 *
+		 * [PHASE_1]: assign delta to idle
+		 *  - pending is 0
+		 *  - observers assign delta to idle
+		 *  - when cpu wakes up and come here:
+		 *    - If nr_iowait is 0:
+		 *        Account delta as idle, and continue PHASE_1.
+		 *    - If nr_iowait is >0:
+		 *        We'd like to account delta to iowait but it will
+		 *        be inconsistent with observers who already assigned
+		 *        a part of delta as idle. So here we account delta
+		 *        to idle and also pending as missed iowait. Then
+		 *        move to PHASE_2 from next turn.
+		 *
+		 * [PHASE_2]: we have missed iowait
+		 *  - pending is >0
+		 *  - observers assign delta to iowait until pending and over
+		 *    to idle.
+		 *  - when cpu wakes up and come here:
+		 *    - Account delta to iowait until pending and over to idle
+		 *      (=in same manner as observers).
+		 *    - Subtract accounted iowait from pending.
+		 *    - If nr_iowait is >0:
+		 *        The sleep time just finished was used to account
+		 *        pending iowait, so now we got new missed iowait.
+		 *        Accumulate delta as missed iowait, and wait next
+		 *        turn to let it be accounted. Continue PHASE_2.
+		 *    - If nr_iowait is 0:
+		 *        The sleep time just finished was considered as idle
+		 *        but utilized to account missed iowait. It is not
+		 *        problem because we just exchange excess idle for
+		 *        missed iowait. If we still have pending continue
+		 *        PHASE_2, otherwise move to PHASE_1 from next turn.
+		 */
+		ktime_t *idle = &ts->idle_sleeptime;
+		ktime_t *iowait = &ts->iowait_sleeptime;
+		ktime_t *pending = &ts->iowait_pending;
+
+		if (ktime_compare(*pending, ktime_zero) == 0) {
+			/* PHASE_1 */
+			*idle = ktime_add(*idle, delta);
+			if (nr_iowait_cpu(smp_processor_id()) > 0)
+				*pending = delta;
+		} else {
+			/* PHASE_2 */
+			if (ktime_compare(*pending, delta) > 0) {
+				*iowait = ktime_add(*iowait, delta);
+				if (!nr_iowait_cpu(smp_processor_id()))
+					*pending = ktime_sub(*pending, delta);
+			} else {
+				*idle = ktime_add(*idle, ktime_sub(delta,
+								   *pending));
+				*iowait = ktime_add(*iowait, *pending);
+				if (nr_iowait_cpu(smp_processor_id()) > 0)
+					*pending = delta;
+				else
+					*pending = ktime_zero;
+			}
+		}
+	}
+
 	ts->idle_entrytime = now;
 	ts->idle_active = 0;
 
@@ -429,7 +503,13 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
+	/*
+	 * idle_active:
+	 *  0: cpu is not idle
+	 *  1: cpu is performing idle
+	 *  2: cpu is performing iowait and idle
+	 */
+	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_sleep_event();
@@ -464,18 +544,23 @@ u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 
 	do {
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
- 
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		idle = ts->idle_sleeptime;
 
-			idle = ktime_add(ts->idle_sleeptime, delta);
-		} else {
-			idle = ts->idle_sleeptime;
+		if (ts->idle_active == 2) {
+			/* delta is sum of unaccounted idle/iowait */
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			if (ktime_compare(delta, ts->iowait_pending) > 0) {
+				delta = ktime_sub(delta, ts->iowait_pending);
+				idle = ktime_add(idle, delta);
+			}
+		} else if (ts->idle_active == 1) {
+			/* delta is unaccounted idle */
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(idle, delta);
 		}
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
-
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
@@ -507,13 +592,16 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 
 	do {
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
- 
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		iowait = ts->iowait_sleeptime;
 
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
-		} else {
-			iowait = ts->iowait_sleeptime;
+		if (ts->idle_active == 2) {
+			/* delta is sum of unaccounted idle/iowait */
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			if (ktime_compare(delta, ts->iowait_pending) > 0) {
+				iowait = ktime_add(iowait, ts->iowait_pending);
+			} else {
+				iowait = ktime_add(iowait, delta);
+			}
 		}
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
-- 
1.7.1


