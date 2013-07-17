Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3GQQov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:44:51 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:46591 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3GQQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 04/18] context_tracing: Fix guest accounting with native vtime
Date: Wed, 17 Jul 2013 18:44:17 +0200
Message-Id: <1374079471-3129-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) If context tracking is enabled with native vtime accounting (which
combo is useless except for dev testing), we call vtime_guest_enter()
and vtime_guest_exit() on host <-> guest switches. But those are stubs
in this configurations. As a result, cputime is not correctly flushed
on kvm context switches.

2) If context tracking runs but is disabled on some CPUs, those
CPUs end up calling __guest_enter/__guest_exit which in turn
call vtime_account_system(). We don't want to call this because we
run in tick based accounting for these CPUs.

Refactor the guest_enter/guest_exit code such that all combinations
finally work.

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
 include/linux/context_tracking.h |   52 ++++++++++++++++----------------------
 kernel/context_tracking.c        |    6 +++-
 2 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index fc09d7b..5984f25 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -20,25 +20,6 @@ struct context_tracking {
 	} state;
 };
 
-static inline void __guest_enter(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags |= PF_VCPU;
-}
-
-static inline void __guest_exit(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags &= ~PF_VCPU;
-}
 
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
@@ -56,9 +37,6 @@ static inline bool context_tracking_active(void)
 extern void user_enter(void);
 extern void user_exit(void);
 
-extern void guest_enter(void);
-extern void guest_exit(void);
-
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
@@ -81,21 +59,35 @@ extern void context_tracking_task_switch(struct task_struct *prev,
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+static inline enum ctx_state exception_enter(void) { return 0; }
+static inline void exception_exit(enum ctx_state prev_ctx) { }
+static inline void context_tracking_task_switch(struct task_struct *prev,
+						struct task_struct *next) { }
+#endif /* !CONFIG_CONTEXT_TRACKING */
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void guest_enter(void);
+extern void guest_exit(void);
+#else
 static inline void guest_enter(void)
 {
-	__guest_enter();
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags |= PF_VCPU;
 }
 
 static inline void guest_exit(void)
 {
-	__guest_exit();
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
 }
-
-static inline enum ctx_state exception_enter(void) { return 0; }
-static inline void exception_exit(enum ctx_state prev_ctx) { }
-static inline void context_tracking_task_switch(struct task_struct *prev,
-						struct task_struct *next) { }
-#endif /* !CONFIG_CONTEXT_TRACKING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
 
 #endif
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 942835c..1f47119 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -141,12 +141,13 @@ void user_exit(void)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 void guest_enter(void)
 {
 	if (vtime_accounting_enabled())
 		vtime_guest_enter(current);
 	else
-		__guest_enter();
+		current->flags |= PF_VCPU;
 }
 EXPORT_SYMBOL_GPL(guest_enter);
 
@@ -155,9 +156,10 @@ void guest_exit(void)
 	if (vtime_accounting_enabled())
 		vtime_guest_exit(current);
 	else
-		__guest_exit();
+		current->flags &= ~PF_VCPU;
 }
 EXPORT_SYMBOL_GPL(guest_exit);
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
 
 
 /**
-- 
1.7.5.4

