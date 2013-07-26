Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327Ab3GZXnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:43:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55864 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936Ab3GZXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:43:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 09/21] context_tracking: Optimize guest APIs off case with static key
Date: Sat, 27 Jul 2013 01:42:32 +0200
Message-Id: <1374882164-32519-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
References: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize guest entry/exit APIs with static keys. This minimize
the overhead for those who enable CONFIG_NO_HZ_FULL without
always using it. Having no range passed to nohz_full= should
result in the probes overhead to be minimized.

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
 include/linux/context_tracking.h |   19 +++++++++++++++++--
 kernel/context_tracking.c        |   23 ++---------------------
 kernel/sched/cputime.c           |    2 ++
 3 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e5ec0c9..03a32b0 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -87,8 +87,23 @@ static inline void context_tracking_task_switch(struct task_struct *prev,
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-extern void guest_enter(void);
-extern void guest_exit(void);
+static inline void guest_enter(void)
+{
+	if (static_key_false(&context_tracking_enabled) &&
+	    vtime_accounting_enabled())
+		vtime_guest_enter(current);
+	else
+		current->flags |= PF_VCPU;
+}
+
+static inline void guest_exit(void)
+{
+	if (static_key_false(&context_tracking_enabled) &&
+	    vtime_accounting_enabled())
+		vtime_guest_exit(current);
+	else
+		current->flags &= ~PF_VCPU;
+}
 #else
 static inline void guest_enter(void)
 {
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 657f668..5afa36b 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -21,8 +21,10 @@
 #include <linux/export.h>
 
 struct static_key context_tracking_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL_GPL(context_tracking_enabled);
 
 DEFINE_PER_CPU(struct context_tracking, context_tracking);
+EXPORT_SYMBOL_GPL(context_tracking);
 
 void context_tracking_cpu_set(int cpu)
 {
@@ -163,27 +165,6 @@ void context_tracking_user_exit(void)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-void guest_enter(void)
-{
-	if (vtime_accounting_enabled())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
-}
-EXPORT_SYMBOL_GPL(guest_enter);
-
-void guest_exit(void)
-{
-	if (vtime_accounting_enabled())
-		vtime_guest_exit(current);
-	else
-		current->flags &= ~PF_VCPU;
-}
-EXPORT_SYMBOL_GPL(guest_exit);
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
-
-
 /**
  * context_tracking_task_switch - context switch the syscall callbacks
  * @prev: the task that is being switched out
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 223a35e..bb6b29a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -724,6 +724,7 @@ void vtime_guest_enter(struct task_struct *tsk)
 	current->flags |= PF_VCPU;
 	write_sequnlock(&tsk->vtime_seqlock);
 }
+EXPORT_SYMBOL_GPL(vtime_guest_enter);
 
 void vtime_guest_exit(struct task_struct *tsk)
 {
@@ -732,6 +733,7 @@ void vtime_guest_exit(struct task_struct *tsk)
 	current->flags &= ~PF_VCPU;
 	write_sequnlock(&tsk->vtime_seqlock);
 }
+EXPORT_SYMBOL_GPL(vtime_guest_exit);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
-- 
1.7.5.4

