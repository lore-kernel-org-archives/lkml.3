Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3HAAd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:33:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63501 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3HAAcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:32:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 23/23] nohz: Optimize full dynticks's sched hooks with static keys
Date: Thu,  1 Aug 2013 02:31:40 +0200
Message-Id: <1375317100-20651-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduler IPIs and task context switches are serious fast path.
Let's try to hide as much as we can the impact of full
dynticks APIs' off case that are called on these sites
through the use of static keys.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/linux/tick.h     |   20 ++++++++++++++++----
 kernel/time/tick-sched.c |    8 ++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index c60b079..a7ef1d6 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -180,20 +180,32 @@ static inline bool tick_nohz_full_cpu(int cpu)
 }
 
 extern void tick_nohz_init(void);
-extern void tick_nohz_full_check(void);
+extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
-extern void tick_nohz_task_switch(struct task_struct *tsk);
+extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
 static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
-static inline void tick_nohz_full_check(void) { }
+static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
-static inline void tick_nohz_task_switch(struct task_struct *tsk) { }
+static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
 
+static inline void tick_nohz_full_check(void)
+{
+	if (tick_nohz_full_enabled())
+		__tick_nohz_full_check();
+}
+
+static inline void tick_nohz_task_switch(struct task_struct *tsk)
+{
+	if (tick_nohz_full_enabled())
+		__tick_nohz_task_switch(tsk);
+}
+
 
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6d6bd6e..73997be 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -197,7 +197,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
  * Re-evaluate the need for the tick on the current CPU
  * and restart it if necessary.
  */
-void tick_nohz_full_check(void)
+void __tick_nohz_full_check(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
@@ -211,7 +211,7 @@ void tick_nohz_full_check(void)
 
 static void nohz_full_kick_work_func(struct irq_work *work)
 {
-	tick_nohz_full_check();
+	__tick_nohz_full_check();
 }
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
@@ -230,7 +230,7 @@ void tick_nohz_full_kick(void)
 
 static void nohz_full_kick_ipi(void *info)
 {
-	tick_nohz_full_check();
+	__tick_nohz_full_check();
 }
 
 /*
@@ -253,7 +253,7 @@ void tick_nohz_full_kick_all(void)
  * It might need the tick due to per task/process properties:
  * perf events, posix cpu timers, ...
  */
-void tick_nohz_task_switch(struct task_struct *tsk)
+void __tick_nohz_task_switch(struct task_struct *tsk)
 {
 	unsigned long flags;
 
-- 
1.7.5.4

