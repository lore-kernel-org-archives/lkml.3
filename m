Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3LQWzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:55:47 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:47159 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3LQWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:40 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 02/13] time: New helper to check CPU eligibility to handle timekeeping
Date: Tue, 17 Dec 2013 23:51:21 +0100
Message-Id: <1387320692-28460-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally, all online CPUs in the system are allowed to handle
the timekeeping duty.

Now with the full dynticks subsystem, we don't want the busy CPUs
running tickless to be bothered with housekeeping duties that
require periodic interrupts because that would defeat the main purpose
of running tickless in the first place.

As such, the following rules apply to define the timekeeping duty affinity:

* If we run in full dynticks mode, CPU 0 handles the timekeeping on
  behalf of all other CPUs in the system. No other CPU is allowed to
  take that duty. This behaviour will soon be subject to change though
  as we plan to balance this duty over all the CPUs outside the full
  dynticks range with CONFIG_NO_HZ_FULL=y in order to improve power
  consumption.

* On any other environment (strict periodic or dynticks idle kernel),
  the timekeeping duty can be handled by any CPU.

In order to enforce and consolidate this behaviour, provide an API that
core subsystems can use to check if a CPU is allowed to handle the
timekeeping duty.

This is going to be used by the timer subsystem before assigning a
timekeeper and by RCU for the full sysidle detection.

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
 include/linux/tick.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..cf2fd34 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -179,15 +179,35 @@ static inline bool tick_nohz_full_cpu(int cpu)
 	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
 }
 
+/**
+ * tick_timeeping_cpu - check if a CPU is elligble to handle timekeeping duty
+ * @cpu:	the cpu to check
+ *
+ * @return true if the CPU is elligible to perform timekeeping duty.
+ */
+static inline bool tick_timekeeping_cpu(int cpu)
+{
+	/*
+	 * If there are full dynticks CPUs around,
+	 * CPU 0 must stay periodic to update timekeeping.
+	 */
+	if (tick_nohz_full_enabled())
+		return cpu == 0;
+
+	/* Otherwise any CPU is elligible for timekeeping duty */
+	return true;
+}
+
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
-#else
+# else
 static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
+static inline bool tick_timekeeping_cpu(int cpu) { return true; }
 static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
-- 
1.8.3.1

