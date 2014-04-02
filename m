Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbaDBUTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099AbaDBUTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:19:01 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] nohz: Synchronize sleep time stats with memory barriers
Date: Wed,  2 Apr 2014 22:17:52 +0200
Message-Id: <1396469872-14877-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1396469872-14877-1-git-send-email-dvlasenk@redhat.com>
References: <1396469872-14877-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When some call site uses get_cpu_*_time_us() to read a sleeptime
stat, it deduces the total sleeptime by adding the pending time
to the last sleeptime snapshot if the CPU target is idle.

But this only works if idle_sleeptime, idle_entrytime and idle_active are
read and updated under some disciplined order.

This patch changes updaters to modify idle_entrytime,
{idle,iowait}_sleeptime, and idle_active exactly in this order,
with write barriers on SMP to ensure other CPUs see then in this order too.
Readers are changed read them in the opposite order, with read barriers.
When readers detect a race by seeing cleared idle_entrytime,
they retry the reads.

The "iowait-ness" of every idle period is decided at the moment it starts:
if this CPU's run-queue had tasks waiting on I/O, then this idle
period's duration will be added to iowait_sleeptime.
This, along with proper SMP syncronization, fixes the bug where iowait
counts could go backwards.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/time/tick-sched.c | 79 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 17 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 73ced0c4..ed0c1bd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -409,10 +409,15 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 
 	/* Updates the per cpu time idle statistics counters */
 	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
+	ts->idle_entrytime.tv64 = 0;
+	smp_wmb();
+
+	if (ts->idle_active == 2)
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 	else
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+
+	smp_wmb();
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -423,7 +428,8 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	ktime_t now = ktime_get();
 
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
+	smp_wmb();
+	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
 	sched_clock_idle_sleep_event();
 	return now;
 }
@@ -444,25 +450,44 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, idle;
+	struct tick_sched *ts;
+	ktime_t now, count;
+	int active;
 
 	if (!tick_nohz_active)
 		return -1;
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	now = ktime_get();
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		idle = ktime_add(ts->idle_sleeptime, delta);
+ again:
+	active = ACCESS_ONCE(ts->idle_active);
+	smp_rmb();
+	count = ACCESS_ONCE(ts->idle_sleeptime);
+	if (active == 1) {
+		ktime_t delta, start;
+
+		smp_rmb();
+		start = ACCESS_ONCE(ts->idle_entrytime);
+		if (start.tv64 == 0)
+			/* Other CPU is updating the count.
+			 * We don't know whether fetched count is valid.
+			 */
+			goto again;
+
+		delta = ktime_sub(now, start);
+		count = ktime_add(count, delta);
 	} else {
-		idle = ts->idle_sleeptime;
+		/* Possible concurrent tick_nohz_stop_idle() already
+		 * cleared idle_active. We fetched count *after*
+		 * we fetched idle_active, so count must be valid.
+		 */
 	}
 
-	return ktime_to_us(idle);
-
+	return ktime_to_us(count);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
@@ -482,24 +507,44 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, iowait;
+	struct tick_sched *ts;
+	ktime_t now, count;
+	int active;
 
 	if (!tick_nohz_active)
 		return -1;
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	now = ktime_get();
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		iowait = ktime_add(ts->iowait_sleeptime, delta);
+ again:
+	active = ACCESS_ONCE(ts->idle_active);
+	smp_rmb();
+	count = ACCESS_ONCE(ts->iowait_sleeptime);
+	if (active == 2) {
+		ktime_t delta, start;
+
+		smp_rmb();
+		start = ACCESS_ONCE(ts->idle_entrytime);
+		if (start.tv64 == 0)
+			/* Other CPU is updating the count.
+			 * We don't know whether fetched count is valid.
+			 */
+			goto again;
+
+		delta = ktime_sub(now, start);
+		count = ktime_add(count, delta);
 	} else {
-		iowait = ts->iowait_sleeptime;
+		/* Possible concurrent tick_nohz_stop_idle() already
+		 * cleared idle_active. We fetched count *after*
+		 * we fetched idle_active, so count must be valid.
+		 */
 	}
 
-	return ktime_to_us(iowait);
+	return ktime_to_us(count);
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-- 
1.8.1.4

