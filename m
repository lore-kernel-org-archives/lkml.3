Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab3GQQvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:51:38 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:53645 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3GQQo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 09/18] context_tracking: Optimize main APIs off case with static key
Date: Wed, 17 Jul 2013 18:44:22 +0200
Message-Id: <1374079471-3129-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize user, exception and guest entry/exit APIs with static
keys. This minimize the overhead for those who enable
CONFIG_NO_HZ_FULL without always using it. Having no range
passed to nohz_full= should result in the probes to be nopped
(at least we hope so...).

If this proves not be enough in the long term, we'll need
to bring an exception slow path by re-routing the exception
handlers.

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
 include/linux/context_tracking.h |   46 ++++++++++++++++++++++++++++++++-----
 kernel/context_tracking.c        |   33 +++++----------------------
 kernel/sched/cputime.c           |    2 +
 3 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 0007ab4..8eba58c 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -38,23 +38,40 @@ static inline bool context_tracking_active(void)
 
 extern void context_tracking_cpu_set(int cpu);
 
-extern void user_enter(void);
-extern void user_exit(void);
+extern void context_tracking_user_enter(void);
+extern void context_tracking_user_exit(void);
+
+static inline void user_enter(void)
+{
+	if (static_key_false(&context_tracking_enabled))
+		context_tracking_user_enter();
+
+}
+static inline void user_exit(void)
+{
+	if (static_key_false(&context_tracking_enabled))
+		context_tracking_user_exit();
+}
 
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
 
+	if (!static_key_false(&context_tracking_enabled))
+		return 0;
+
 	prev_ctx = this_cpu_read(context_tracking.state);
-	user_exit();
+	context_tracking_user_exit();
 
 	return prev_ctx;
 }
 
 static inline void exception_exit(enum ctx_state prev_ctx)
 {
-	if (prev_ctx == IN_USER)
-		user_enter();
+	if (static_key_false(&context_tracking_enabled)) {
+		if (prev_ctx == IN_USER)
+			context_tracking_user_enter();
+	}
 }
 
 extern void context_tracking_task_switch(struct task_struct *prev,
@@ -70,8 +87,23 @@ static inline void context_tracking_task_switch(struct task_struct *prev,
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
index f07505c..7b0a22d 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -33,15 +33,15 @@ void context_tracking_cpu_set(int cpu)
 }
 
 /**
- * user_enter - Inform the context tracking that the CPU is going to
- *              enter userspace mode.
+ * context_tracking_user_enter - Inform the context tracking that the CPU is going to
+ *                               enter userspace mode.
  *
  * This function must be called right before we switch from the kernel
  * to userspace, when it's guaranteed the remaining kernel instructions
  * to execute won't use any RCU read side critical section because this
  * function sets RCU in extended quiescent state.
  */
-void user_enter(void)
+void context_tracking_user_enter(void)
 {
 	unsigned long flags;
 
@@ -131,8 +131,8 @@ EXPORT_SYMBOL_GPL(preempt_schedule_context);
 #endif /* CONFIG_PREEMPT */
 
 /**
- * user_exit - Inform the context tracking that the CPU is
- *             exiting userspace mode and entering the kernel.
+ * context_tracking_user_exit - Inform the context tracking that the CPU is
+ *                              exiting userspace mode and entering the kernel.
  *
  * This function must be called after we entered the kernel from userspace
  * before any use of RCU read side critical section. This potentially include
@@ -141,7 +141,7 @@ EXPORT_SYMBOL_GPL(preempt_schedule_context);
  * This call supports re-entrancy. This way it can be called from any exception
  * handler without needing to know if we came from userspace or not.
  */
-void user_exit(void)
+void context_tracking_user_exit(void)
 {
 	unsigned long flags;
 
@@ -163,27 +163,6 @@ void user_exit(void)
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

