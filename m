Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaDXSrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbaDXSrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:47:02 -0400
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
Subject: [PATCH 3/4] nohz: Fix idle/iowait counts going backwards
Date: Thu, 24 Apr 2014 20:45:57 +0200
Message-Id: <1398365158-12568-3-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, "iowait-ness" of every idle period is decided
at the moment it starts:
if this CPU's run-queue had tasks waiting on I/O, then this idle
period's duration will be added to iowait_sleeptime.

This fixes the bug where iowait and/or idle counts could go backwards,
but iowait accounting is not precise (it can show more iowait
that there really is).

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
 kernel/time/tick-sched.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8f0f2ee..47ed7cf 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -413,7 +413,7 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 	/* Updates the per cpu time idle statistics counters */
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
+	if (ts->idle_active == 2)
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 	else
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
@@ -429,7 +429,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
+	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_sleep_event();
@@ -469,7 +469,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		if (ts->idle_active == 1) {
 			delta = ktime_sub(now, ts->idle_entrytime);
 			idle = ktime_add(idle, delta);
 		}
@@ -511,7 +511,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		iowait = ts->iowait_sleeptime;
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+		if (ts->idle_active == 2) {
 			delta = ktime_sub(now, ts->idle_entrytime);
 			iowait = ktime_add(ts->iowait_sleeptime, delta);
 		}
-- 
1.8.1.4

