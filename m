Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3A0APe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:15:34 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49253 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab3A0APa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:30 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Alessio Igor Bogani <abogani@kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH tip/core/rcu 10/10] context_tracking: Add comments on interface and internals
Date: Sat, 26 Jan 2013 16:15:12 -0800
Message-Id: <1359245712-3843-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7182-0000-0000-000004BAF1A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

This subsystem lacks many explanations on its purpose and
design. Add these missing comments.

v4: Document function parameter to be more kernel-doc
friendly, as per Namhyung suggestion.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/context_tracking.c |   75 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index e0e07fd..d566aba 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -1,3 +1,19 @@
+/*
+ * Context tracking: Probe on high level context boundaries such as kernel
+ * and userspace. This includes syscalls and exceptions entry/exit.
+ *
+ * This is used by RCU to remove its dependency on the timer tick while a CPU
+ * runs in userspace.
+ *
+ *  Started by Frederic Weisbecker:
+ *
+ * Copyright (C) 2012 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Many thanks to Gilad Ben-Yossef, Paul McKenney, Ingo Molnar, Andrew Morton,
+ * Steven Rostedt, Peter Zijlstra for suggestions and improvements.
+ *
+ */
+
 #include <linux/context_tracking.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
@@ -6,8 +22,8 @@
 
 struct context_tracking {
 	/*
-	 * When active is false, hooks are not set to
-	 * minimize overhead: TIF flags are cleared
+	 * When active is false, probes are unset in order
+	 * to minimize overhead: TIF flags are cleared
 	 * and calls to user_enter/exit are ignored. This
 	 * may be further optimized using static keys.
 	 */
@@ -24,6 +40,15 @@ static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #endif
 };
 
+/**
+ * user_enter - Inform the context tracking that the CPU is going to
+ *              enter userspace mode.
+ *
+ * This function must be called right before we switch from the kernel
+ * to userspace, when it's guaranteed the remaining kernel instructions
+ * to execute won't use any RCU read side critical section because this
+ * function sets RCU in extended quiescent state.
+ */
 void user_enter(void)
 {
 	unsigned long flags;
@@ -39,40 +64,70 @@ void user_enter(void)
 	if (in_interrupt())
 		return;
 
+	/* Kernel threads aren't supposed to go to userspace */
 	WARN_ON_ONCE(!current->mm);
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.active) &&
 	    __this_cpu_read(context_tracking.state) != IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_USER);
+		/*
+		 * At this stage, only low level arch entry code remains and
+		 * then we'll run in userspace. We can assume there won't be
+		 * any RCU read-side critical section until the next call to
+		 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
+		 * on the tick.
+		 */
 		rcu_user_enter();
 	}
 	local_irq_restore(flags);
 }
 
+
+/**
+ * user_exit - Inform the context tracking that the CPU is
+ *             exiting userspace mode and entering the kernel.
+ *
+ * This function must be called after we entered the kernel from userspace
+ * before any use of RCU read side critical section. This potentially include
+ * any high level kernel code like syscalls, exceptions, signal handling, etc...
+ *
+ * This call supports re-entrancy. This way it can be called from any exception
+ * handler without needing to know if we came from userspace or not.
+ */
 void user_exit(void)
 {
 	unsigned long flags;
 
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
 	if (in_interrupt())
 		return;
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
+		/*
+		 * We are going to run code that may use RCU. Inform
+		 * RCU core about that (ie: we may need the tick again).
+		 */
 		rcu_user_exit();
 	}
 	local_irq_restore(flags);
 }
 
+
+/**
+ * context_tracking_task_switch - context switch the syscall callbacks
+ * @prev: the task that is being switched out
+ * @next: the task that is being switched in
+ *
+ * The context tracking uses the syscall slow path to implement its user-kernel
+ * boundaries probes on syscalls. This way it doesn't impact the syscall fast
+ * path on CPUs that don't do context tracking.
+ *
+ * But we need to clear the flag on the previous task because it may later
+ * migrate to some CPU that doesn't do the context tracking. As such the TIF
+ * flag may not be desired there.
+ */
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
 {
-- 
1.7.8

