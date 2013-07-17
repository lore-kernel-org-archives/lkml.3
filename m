Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab3GQQoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:44:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35141 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3GQQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 06/18] context_tracking: Fix runtime CPU off-case
Date: Wed, 17 Jul 2013 18:44:19 +0200
Message-Id: <1374079471-3129-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as the context tracking is enabled on any CPU, even
a single one, all other CPUs need to keep track of their
user <-> kernel boundaries cross as well.

This is because a task can sleep while servicing an exception
that happened in the kernel or in userspace. Then when the task
eventually wakes up and return from the exception, the CPU needs
to know if we resume in userspace or in the kernel. exception_exit()
get this information from exception_enter() that saved the previous
state.

If the CPU where the exception happened didn't keep track of
these informations, exception_exit() doesn't know which state
tracking to restore on the CPU where the task got migrated
and we may return to userspace with the context tracking
subsystem thinking that we are in kernel mode.

This can be fixed in the long term if we move our context tracking
probes on very low level arch fast path user <-> kernel boundary,
although even that is worrisome as an exception can still happen
in the few instructions between the probe and the actual iret.

Also we are not yet ready to set these probes in the fast path given
the potential overhead problem it induces.

So let's fix this by always enable context tracking even on CPUs
that are not in the full dynticks range. OTOH we can spare the
rcu_user_*() and vtime_user_*() calls there because the tick runs
on these CPUs and we can handle RCU state machine and cputime
accounting through it.

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
 kernel/context_tracking.c |   52 ++++++++++++++++++++++++++++----------------
 1 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 1f47119..7b095de 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -54,17 +54,31 @@ void user_enter(void)
 	WARN_ON_ONCE(!current->mm);
 
 	local_irq_save(flags);
-	if (__this_cpu_read(context_tracking.active) &&
-	    __this_cpu_read(context_tracking.state) != IN_USER) {
+	if ( __this_cpu_read(context_tracking.state) != IN_USER) {
+		if (__this_cpu_read(context_tracking.active)) {
+			/*
+			 * At this stage, only low level arch entry code remains and
+			 * then we'll run in userspace. We can assume there won't be
+			 * any RCU read-side critical section until the next call to
+			 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
+			 * on the tick.
+			 */
+			vtime_user_enter(current);
+			rcu_user_enter();
+		}
 		/*
-		 * At this stage, only low level arch entry code remains and
-		 * then we'll run in userspace. We can assume there won't be
-		 * any RCU read-side critical section until the next call to
-		 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
-		 * on the tick.
+		 * Even if context tracking is disabled on this CPU, because it's outside
+		 * the full dynticks mask for example, we still have to keep track of the
+		 * context transitions and states to prevent inconsistency on those of
+		 * other CPUs.
+		 * If a task triggers an exception in userspace, sleep on the exception
+		 * handler and then migrate to another CPU, that new CPU must know where
+		 * the exception returns by the time we call exception_exit().
+		 * This information can only be provided by the previous CPU when it called
+		 * exception_enter().
+		 * OTOH we can spare the calls to vtime and RCU when context_tracking.active
+		 * is false because we know that CPU is not tickless.
 		 */
-		vtime_user_enter(current);
-		rcu_user_enter();
 		__this_cpu_write(context_tracking.state, IN_USER);
 	}
 	local_irq_restore(flags);
@@ -130,12 +144,14 @@ void user_exit(void)
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
-		/*
-		 * We are going to run code that may use RCU. Inform
-		 * RCU core about that (ie: we may need the tick again).
-		 */
-		rcu_user_exit();
-		vtime_user_exit(current);
+		if (__this_cpu_read(context_tracking.active)) {
+			/*
+			 * We are going to run code that may use RCU. Inform
+			 * RCU core about that (ie: we may need the tick again).
+			 */
+			rcu_user_exit();
+			vtime_user_exit(current);
+		}
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
 	}
 	local_irq_restore(flags);
@@ -178,8 +194,6 @@ EXPORT_SYMBOL_GPL(guest_exit);
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
 {
-	if (__this_cpu_read(context_tracking.active)) {
-		clear_tsk_thread_flag(prev, TIF_NOHZ);
-		set_tsk_thread_flag(next, TIF_NOHZ);
-	}
+	clear_tsk_thread_flag(prev, TIF_NOHZ);
+	set_tsk_thread_flag(next, TIF_NOHZ);
 }
-- 
1.7.5.4

