Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3HAAcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:32:01 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41691 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3HAAb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:31:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 08/23] context_tracking: Optimize main APIs off case with static key
Date: Thu,  1 Aug 2013 02:31:25 +0200
Message-Id: <1375317100-20651-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize user and exception entry/exit APIs with static
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
 include/linux/context_tracking.h |   27 ++++++++++++++++++++++-----
 kernel/context_tracking.c        |   12 ++++++------
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index f9356eb..e5ec0c9 100644
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
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index f07505c..657f668 100644
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
 
-- 
1.7.5.4

