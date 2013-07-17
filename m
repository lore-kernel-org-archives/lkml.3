Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3GQQo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:44:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58255 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3GQQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:54 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 08/18] context_tracking: Ground setup for static key use
Date: Wed, 17 Jul 2013 18:44:21 +0200
Message-Id: <1374079471-3129-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for using a static key in the context tracking subsystem.
This will help optimizing the off case on its many users:

* user_enter, user_exit, exception_enter, exception_exit, guest_enter,
  guest_exit, vtime_*()

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
 include/linux/context_tracking.h |    2 ++
 kernel/context_tracking.c        |   26 ++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 2c2b73aa..0007ab4 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/percpu.h>
 #include <linux/vtime.h>
+#include <linux/static_key.h>
 #include <asm/ptrace.h>
 
 struct context_tracking {
@@ -22,6 +23,7 @@ struct context_tracking {
 
 
 #ifdef CONFIG_CONTEXT_TRACKING
+extern struct static_key context_tracking_enabled;
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
 static inline bool context_tracking_in_user(void)
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 72bcb25..f07505c 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -20,15 +20,16 @@
 #include <linux/hardirq.h>
 #include <linux/export.h>
 
-DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
-#ifdef CONFIG_CONTEXT_TRACKING_FORCE
-	.active = true,
-#endif
-};
+struct static_key context_tracking_enabled = STATIC_KEY_INIT_FALSE;
+
+DEFINE_PER_CPU(struct context_tracking, context_tracking);
 
 void context_tracking_cpu_set(int cpu)
 {
-	per_cpu(context_tracking.active, cpu) = true;
+	if (!per_cpu(context_tracking.active, cpu)) {
+		per_cpu(context_tracking.active, cpu) = true;
+		static_key_slow_inc(&context_tracking_enabled);
+	}
 }
 
 /**
@@ -202,3 +203,16 @@ void context_tracking_task_switch(struct task_struct *prev,
 	clear_tsk_thread_flag(prev, TIF_NOHZ);
 	set_tsk_thread_flag(next, TIF_NOHZ);
 }
+
+#ifdef CONFIG_CONTEXT_TRACKING_FORCE
+static int __init context_tracking_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		context_tracking_cpu_set(cpu);
+
+	return 0;
+}
+early_initcall(context_tracking_init);
+#endif
-- 
1.7.5.4

