Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3LQWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:53:29 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44201 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LQWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:49 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 10/13] nohz: Hand over timekeeping duty on cpu offlining
Date: Tue, 17 Dec 2013 23:51:29 +0100
Message-Id: <1387320692-28460-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are full dynticks CPUs around and the timekeeper goes
offline, we have to hand over the timekeeping duty to another potential
timekeeper.

The default timekeeper (aka CPU 0) is the perfect candidate for this
task since it can't be offlined itself.

So lets send an IPI to the default timekeeping when the current
timekeeper goes offline, so that the duty is relayed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/linux/tick.h     |  2 ++
 kernel/time/tick-sched.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index af98d2c..bd3c32e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -218,6 +218,7 @@ extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
+extern void tick_nohz_full_kick_timekeeping(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 # else
 static inline void tick_nohz_init(void) { }
@@ -227,6 +228,7 @@ static inline bool tick_timekeeping_cpu(int cpu) { return true; }
 static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
+static inline void tick_nohz_full_kick_timekeeping(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 527b501..94b6901 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -217,6 +217,12 @@ static u64 tick_timekeeping_max_deferment(struct tick_sched *ts)
 		return timekeeping_max_deferment();
 
 	/*
+	 * Order tick_do_timer_cpu read against the IPI, pairs with
+	 * tick_nohz_full_kick_timekeeping()
+	 */
+	smp_rmb();
+
+	/*
 	 * If we are the timekeeper and all full dynticks CPUs are idle,
 	 * then we can finally sleep.
 	 */
@@ -293,6 +299,22 @@ void tick_nohz_full_kick_all(void)
 	preempt_enable();
 }
 
+/**
+ * tick_nohz_full_kick_timekeeping - kick the default timekeeper
+ *
+ * kick the default timekeeper when a secondary timekeeper goes offline.
+ */
+void tick_nohz_full_kick_timekeeping(void)
+{
+	tick_do_timer_cpu = tick_timekeeping_default_cpu();
+	/*
+	 * Order tick_do_timer_cpu against the IPI, pairs with
+	 * tick_timekeeping_max_deferment on irq exit.
+	 */
+	smp_wmb();
+	smp_send_reschedule(tick_timekeeping_default_cpu());
+}
+
 /*
  * Re-evaluate the need for the tick as we switch the current task.
  * It might need the tick due to per task/process properties:
@@ -351,6 +373,15 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		if (tick_nohz_full_running && tick_timekeeping_default_cpu() == cpu)
 			return NOTIFY_BAD;
 		break;
+
+	case CPU_DYING:
+		/*
+		 * Notify default timekeeper if we are giving up
+		 * timekeeping duty
+		 */
+		if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
+			tick_nohz_full_kick_timekeeping();
+		break;
 	}
 	return NOTIFY_OK;
 }
-- 
1.8.3.1

