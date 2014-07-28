Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaG1RjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:39:16 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55731 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaG1RiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:38:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Date: Mon, 28 Jul 2014 19:37:33 +0200
Message-Id: <1406569056-30217-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timekeeper gets initialized to the value of the CPU where the
first clockevent device is setup. This works well because the timekeeper
can be any online CPU in most configs.

Full dynticks has its own requirement though and needs the timekeeper
to always be 0. And this requirement seem to accomodate pretty well with
the above described boot timekeeper setting because the first clockevent
device happens to be initialized, most of the time, on the boot CPU
(which should be CPU 0).

However there is no mention of such a guarantee anywhere. This assumption
might well be defeated on some corner case now or in the future.

So lets wipe out the FUD and force tick_do_timer_cpu to CPU 0 on boot
when full dynticks is used.

This way we can even remove some corner case code that handled scenarios
where all clockevent devices were setup on full dynticks CPUs.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-common.c | 6 +++---
 kernel/time/tick-sched.c  | 6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0a0608e..cb57bce 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -179,10 +179,10 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			if (!tick_nohz_full_cpu(cpu))
-				tick_do_timer_cpu = cpu;
+			if (tick_nohz_full_enabled())
+				tick_do_timer_cpu = TICK_DO_TIMER_DEFAULT;
 			else
-				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+				tick_do_timer_cpu = cpu;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 		}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3d63944..2ea2143 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -741,12 +741,6 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		 */
 		if (tick_do_timer_cpu == cpu)
 			return false;
-		/*
-		 * Boot safety: make sure the timekeeping duty has been
-		 * assigned before entering dyntick-idle mode,
-		 */
-		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
-			return false;
 	}
 
 	return true;
-- 
1.8.3.1

