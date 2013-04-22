Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3DVTAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:16 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47369 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3DVTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:11 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/10] nohz: Re-evaluate the tick for the new task after a context switch
Date: Mon, 22 Apr 2013 20:59:45 +0200
Message-Id: <1366657186-20556-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task is scheduled in, it may have some properties
of its own that could make the CPU reconsider the need for
the tick: posix cpu timers, perf events, ...

So notify the full dynticks subsystem when a task gets
scheduled in and re-check the tick dependency at this
stage. This is done through a self IPI to avoid messing
up with any current lock scenario.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tick.h     |    2 ++
 kernel/sched/core.c      |    2 ++
 kernel/time/tick-sched.c |   20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index e31e676..9180f4b 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -163,12 +163,14 @@ extern int tick_nohz_full_cpu(int cpu);
 extern void tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
+extern void tick_nohz_task_switch(struct task_struct *tsk);
 #else
 static inline void tick_nohz_init(void) { }
 static inline int tick_nohz_full_cpu(int cpu) { return 0; }
 static inline void tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
+static inline void tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9ad3500..dd09def 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1896,6 +1896,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+
+	tick_nohz_task_switch(current);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d0ed190..12a900d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -232,6 +232,26 @@ void tick_nohz_full_kick_all(void)
 	preempt_enable();
 }
 
+/*
+ * Re-evaluate the need for the tick as we switch the current task.
+ * It might need the tick due to per task/process properties:
+ * perf events, posix cpu timers, ...
+ */
+void tick_nohz_task_switch(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	if (!tick_nohz_full_cpu(smp_processor_id()))
+		return;
+
+	local_irq_save(flags);
+
+	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
+		tick_nohz_full_kick();
+
+	local_irq_restore(flags);
+}
+
 int tick_nohz_full_cpu(int cpu)
 {
 	if (!have_nohz_full_mask)
-- 
1.7.5.4

