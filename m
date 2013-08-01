Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3HAAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:38:23 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53488 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3HAAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:32:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 11/23] context_tracking: User/kernel broundary cross trace events
Date: Thu,  1 Aug 2013 02:31:28 +0200
Message-Id: <1375317100-20651-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be useful to track all kernel/user round trips.
And it's also helpful to debug the context tracking subsystem.

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
 include/trace/events/context_tracking.h |   58 +++++++++++++++++++++++++++++++
 kernel/context_tracking.c               |    5 +++
 2 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/context_tracking.h

diff --git a/include/trace/events/context_tracking.h b/include/trace/events/context_tracking.h
new file mode 100644
index 0000000..ce8007c
--- /dev/null
+++ b/include/trace/events/context_tracking.h
@@ -0,0 +1,58 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM context_tracking
+
+#if !defined(_TRACE_CONTEXT_TRACKING_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CONTEXT_TRACKING_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(context_tracking_user,
+
+	TP_PROTO(int dummy),
+
+	TP_ARGS(dummy),
+
+	TP_STRUCT__entry(
+		__field( int,	dummy	)
+	),
+
+	TP_fast_assign(
+		__entry->dummy		= dummy;
+	),
+
+	TP_printk("%s", "")
+);
+
+/**
+ * user_enter - called when the kernel resumes to userspace
+ * @dummy:	dummy arg to make trace event macro happy
+ *
+ * This event occurs when the kernel resumes to userspace  after
+ * an exception or a syscall.
+ */
+DEFINE_EVENT(context_tracking_user, user_enter,
+
+	TP_PROTO(int dummy),
+
+	TP_ARGS(dummy)
+);
+
+/**
+ * user_exit - called when userspace enters the kernel
+ * @dummy:	dummy arg to make trace event macro happy
+ *
+ * This event occurs when userspace enters the kernel through
+ * an exception or a syscall.
+ */
+DEFINE_EVENT(context_tracking_user, user_exit,
+
+	TP_PROTO(int dummy),
+
+	TP_ARGS(dummy)
+);
+
+
+#endif /*  _TRACE_CONTEXT_TRACKING_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index ef21e4f..688efe4 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -20,6 +20,9 @@
 #include <linux/hardirq.h>
 #include <linux/export.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/context_tracking.h>
+
 struct static_key context_tracking_enabled = STATIC_KEY_INIT_FALSE;
 EXPORT_SYMBOL_GPL(context_tracking_enabled);
 
@@ -64,6 +67,7 @@ void context_tracking_user_enter(void)
 	local_irq_save(flags);
 	if ( __this_cpu_read(context_tracking.state) != IN_USER) {
 		if (__this_cpu_read(context_tracking.active)) {
+			trace_user_enter(0);
 			/*
 			 * At this stage, only low level arch entry code remains and
 			 * then we'll run in userspace. We can assume there won't be
@@ -159,6 +163,7 @@ void context_tracking_user_exit(void)
 			 */
 			rcu_user_exit();
 			vtime_user_exit(current);
+			trace_user_exit(0);
 		}
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
 	}
-- 
1.7.5.4

