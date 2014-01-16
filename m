Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaAPPmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:42:11 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55219 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaAPPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:42:02 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 1/4] tick: Rename tick_check_idle() to tick_irq_enter()
Date: Thu, 16 Jan 2014 16:41:49 +0100
Message-Id: <1389886912-4783-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
References: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code more symetric against the existing tick functions
called on irq exit: tick_irq_exit() and tick_nohz_irq_exit().

These function are also symetric as they mirror each other's action:
we start to account idle time on irq exit and we stop this accounting
on irq entry. Also the tick is stopped on irq exit and timekeeping
catches up with the tickless time elapsed until we reach irq entry.

This rename was suggested by Peter Zijlstra a long while ago but it
got forgotten in the mass.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1387320692-28460-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h     | 6 +++---
 kernel/softirq.c         | 2 +-
 kernel/time/tick-sched.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0175d86..b84773c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -104,7 +104,7 @@ extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
-extern void tick_check_idle(void);
+extern void tick_irq_enter(void);
 extern int tick_oneshot_mode_active(void);
 #  ifndef arch_needs_cpu
 #   define arch_needs_cpu(cpu) (0)
@@ -112,7 +112,7 @@ extern int tick_oneshot_mode_active(void);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(void) { }
+static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
 
@@ -121,7 +121,7 @@ static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(void) { }
+static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11348de..ca9cb35 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -318,7 +318,7 @@ void irq_enter(void)
 		 * here, as softirq will be serviced on return from interrupt.
 		 */
 		local_bh_disable();
-		tick_check_idle();
+		tick_irq_enter();
 		_local_bh_enable();
 	}
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0ddd020..e4d0f09 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1023,7 +1023,7 @@ static void tick_nohz_kick_tick(struct tick_sched *ts, ktime_t now)
 #endif
 }
 
-static inline void tick_check_nohz_this_cpu(void)
+static inline void tick_nohz_irq_enter(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
@@ -1042,17 +1042,17 @@ static inline void tick_check_nohz_this_cpu(void)
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
-static inline void tick_check_nohz_this_cpu(void) { }
+static inline void tick_nohz_irq_enter(void) { }
 
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
  */
-void tick_check_idle(void)
+void tick_irq_enter(void)
 {
 	tick_check_oneshot_broadcast_this_cpu();
-	tick_check_nohz_this_cpu();
+	tick_nohz_irq_enter();
 }
 
 /*
-- 
1.8.3.1

