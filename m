Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3ETQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:03:58 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43825 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3ETQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Kevin Hilman <khilman@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 4/8] kvm: Move guest entry/exit APIs to context_tracking
Date: Mon, 20 May 2013 18:01:52 +0200
Message-Id: <1369065716-22801-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm_host.h header file doesn't handle well
inclusion when archs don't support KVM.

This results in build crashes for such archs when they
want to implement context tracking because this subsystem
includes kvm_host.h in order to implement the
guest_enter/exit APIs but it doesn't handle KVM off case.

To fix this, move the guest_enter()/guest_exit()
declarations and generic implementation to the context
tracking headers. These generic APIs actually belong to
this subsystem, besides other domains boundary tracking
like user_enter() et al.

KVM now properly becomes a user of this library, not the
other buggy way around.

Reported-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
---
 include/linux/context_tracking.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h         |   37 +------------------------------------
 kernel/context_tracking.c        |    1 -
 3 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 365f4a6..fc09d7b 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,7 @@
 
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <linux/vtime.h>
 #include <asm/ptrace.h>
 
 struct context_tracking {
@@ -19,6 +20,26 @@ struct context_tracking {
 	} state;
 };
 
+static inline void __guest_enter(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags |= PF_VCPU;
+}
+
+static inline void __guest_exit(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
+}
+
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
@@ -35,6 +56,9 @@ static inline bool context_tracking_active(void)
 extern void user_enter(void);
 extern void user_exit(void);
 
+extern void guest_enter(void);
+extern void guest_exit(void);
+
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
@@ -57,6 +81,17 @@ extern void context_tracking_task_switch(struct task_struct *prev,
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+
+static inline void guest_enter(void)
+{
+	__guest_enter();
+}
+
+static inline void guest_exit(void)
+{
+	__guest_exit();
+}
+
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0eea07..8db53cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,6 +23,7 @@
 #include <linux/ratelimit.h>
 #include <linux/err.h>
 #include <linux/irqflags.h>
+#include <linux/context_tracking.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -760,42 +761,6 @@ static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
 }
 #endif
 
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
-
-#ifdef CONFIG_CONTEXT_TRACKING
-extern void guest_enter(void);
-extern void guest_exit(void);
-
-#else /* !CONFIG_CONTEXT_TRACKING */
-static inline void guest_enter(void)
-{
-	__guest_enter();
-}
-
-static inline void guest_exit(void)
-{
-	__guest_exit();
-}
-#endif /* !CONFIG_CONTEXT_TRACKING */
-
 static inline void kvm_guest_enter(void)
 {
 	unsigned long flags;
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..85bdde1 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/context_tracking.h>
-#include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
-- 
1.7.5.4

