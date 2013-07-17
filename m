Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3GQQur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:50:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62409 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab3GQQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 10/18] context_tracking: Optimize context switch off case with static keys
Date: Wed, 17 Jul 2013 18:44:23 +0200
Message-Id: <1374079471-3129-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for syscall slowpath if no CPU is full dynticks,
rather nop this in this case.

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
 include/linux/context_tracking.h |   11 +++++++++--
 kernel/context_tracking.c        |    6 +++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 8eba58c..77f7306 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -40,6 +40,8 @@ extern void context_tracking_cpu_set(int cpu);
 
 extern void context_tracking_user_enter(void);
 extern void context_tracking_user_exit(void);
+extern void __context_tracking_task_switch(struct task_struct *prev,
+					   struct task_struct *next);
 
 static inline void user_enter(void)
 {
@@ -74,8 +76,12 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 	}
 }
 
-extern void context_tracking_task_switch(struct task_struct *prev,
-					 struct task_struct *next);
+static inline void context_tracking_task_switch(struct task_struct *prev,
+						struct task_struct *next)
+{
+	if (static_key_false(&context_tracking_enabled))
+		__context_tracking_task_switch(prev, next);
+}
 #else
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
@@ -104,6 +110,7 @@ static inline void guest_exit(void)
 	else
 		current->flags &= ~PF_VCPU;
 }
+
 #else
 static inline void guest_enter(void)
 {
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 7b0a22d..5323a5c 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -164,7 +164,7 @@ void context_tracking_user_exit(void)
 }
 
 /**
- * context_tracking_task_switch - context switch the syscall callbacks
+ * __context_tracking_task_switch - context switch the syscall callbacks
  * @prev: the task that is being switched out
  * @next: the task that is being switched in
  *
@@ -176,8 +176,8 @@ void context_tracking_user_exit(void)
  * migrate to some CPU that doesn't do the context tracking. As such the TIF
  * flag may not be desired there.
  */
-void context_tracking_task_switch(struct task_struct *prev,
-			     struct task_struct *next)
+void __context_tracking_task_switch(struct task_struct *prev,
+				    struct task_struct *next)
 {
 	clear_tsk_thread_flag(prev, TIF_NOHZ);
 	set_tsk_thread_flag(next, TIF_NOHZ);
-- 
1.7.5.4

