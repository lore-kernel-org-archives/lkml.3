Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab3GQQt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:49:59 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:32834 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3GQQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:45:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 14/18] context_tracking: Split low level state headers
Date: Wed, 17 Jul 2013 18:44:27 +0200
Message-Id: <1374079471-3129-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to use the context tracking static key on inline
vtime APIs. For this we need to include the context tracking
headers from those of vtime.

However vtime headers need to stay low level because they are
included in hardirq.h that mostly contains standalone
definitions. But context_tracking.h includes sched.h for
a few task_struct references, therefore it wouldn't be sensible
to include it from vtime.h

To solve this, lets split the context tracking headers and move
out the pure state definitions that only require a few low level
headers. We can safely include that small part in vtime.h later.

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
 include/linux/context_tracking.h       |   31 +------------------------
 include/linux/context_tracking_state.h |   39 ++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/context_tracking_state.h

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 77f7306..8635dbb 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -2,40 +2,12 @@
 #define _LINUX_CONTEXT_TRACKING_H
 
 #include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/vtime.h>
-#include <linux/static_key.h>
+#include <linux/context_tracking_state.h>
 #include <asm/ptrace.h>
 
-struct context_tracking {
-	/*
-	 * When active is false, probes are unset in order
-	 * to minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool active;
-	enum ctx_state {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
-
 
 #ifdef CONFIG_CONTEXT_TRACKING
-extern struct static_key context_tracking_enabled;
-DECLARE_PER_CPU(struct context_tracking, context_tracking);
-
-static inline bool context_tracking_in_user(void)
-{
-	return __this_cpu_read(context_tracking.state) == IN_USER;
-}
-
-static inline bool context_tracking_active(void)
-{
-	return __this_cpu_read(context_tracking.active);
-}
-
 extern void context_tracking_cpu_set(int cpu);
 
 extern void context_tracking_user_enter(void);
@@ -83,7 +55,6 @@ static inline void context_tracking_task_switch(struct task_struct *prev,
 		__context_tracking_task_switch(prev, next);
 }
 #else
-static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
 static inline enum ctx_state exception_enter(void) { return 0; }
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
new file mode 100644
index 0000000..0f1979d
--- /dev/null
+++ b/include/linux/context_tracking_state.h
@@ -0,0 +1,39 @@
+#ifndef _LINUX_CONTEXT_TRACKING_STATE_H
+#define _LINUX_CONTEXT_TRACKING_STATE_H
+
+#include <linux/percpu.h>
+#include <linux/static_key.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, probes are unset in order
+	 * to minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum ctx_state {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+#ifdef CONFIG_CONTEXT_TRACKING
+extern struct static_key context_tracking_enabled;
+DECLARE_PER_CPU(struct context_tracking, context_tracking);
+
+static inline bool context_tracking_in_user(void)
+{
+	return __this_cpu_read(context_tracking.state) == IN_USER;
+}
+
+static inline bool context_tracking_active(void)
+{
+	return __this_cpu_read(context_tracking.active);
+}
+#else
+static inline bool context_tracking_in_user(void) { return false; }
+static inline bool context_tracking_active(void) { return false; }
+#endif /* CONFIG_CONTEXT_TRACKING */
+
+#endif
-- 
1.7.5.4

