Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaBYMih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:38:37 -0500
Received: from asav4.altibox.net ([81.167.36.153]:49796 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaBYMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:40 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/6] Expose do_timer CPU as RO variable to userspace via sysctl
Date: Tue, 25 Feb 2014 13:33:58 +0100
Message-Id: <1393331641-14016-4-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

This allows userspace to see which CPU is currently responsible for
handling the do_timer update of the time machinery.

     sysctl kernel.current_timer_cpu
     /proc/sys/kernel/current_timer_cpu

Note that this value can be fleeting if CONFIG_NO_HZ_FULL is enabled. If
not read, no additional overhead is generated in the system.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 include/linux/clocksource.h |   11 +++++++++++
 kernel/sysctl.c             |    8 ++++++++
 kernel/time/timekeeping.c   |   21 +++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 67301a4..cfd39e8 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_CLOCKSOURCE_H
 #define _LINUX_CLOCKSOURCE_H
 
+#include <linux/sysctl.h>
 #include <linux/types.h>
 #include <linux/timex.h>
 #include <linux/time.h>
@@ -358,4 +359,14 @@ static inline void clocksource_of_init(void) {}
 		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
 #endif
 
+/*
+ * expose the CPU that handles the timer-tick.
+ */
+extern int expose_tick_do_timer_cpu;
+extern int timekeeping_expose_timer_cpu(struct ctl_table *table,
+					int write,
+					void __user *buffer,
+					size_t *lenp,
+					loff_t *ppos);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..a882c9e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -63,6 +63,7 @@
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
 #include <linux/kexec.h>
+#include <linux/clocksource.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -424,6 +425,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
 	},
+	{
+		.procname  = "current_timer_cpu",
+		.data      = &expose_tick_do_timer_cpu,
+		.maxlen	   = sizeof(int),
+		.mode	   = 0444,
+		.proc_handler	= timekeeping_expose_timer_cpu,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7c6b1f..55428f9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -30,6 +30,13 @@
 #include "timekeeping_internal.h"
 
 /*
+ * Hold the current value of tick_do_timer_cpu. We could expose this directly,
+ * but putting this will prevent a casual update of the mode in sysctl.c to
+ * suddenly change the timer-cpu.
+ */
+int expose_tick_do_timer_cpu;
+
+/*
  * sysfs interface to timer-cpu
  */
 static ssize_t current_cpu_show(struct kobject *kobj,
@@ -1782,3 +1789,17 @@ void xtime_update(unsigned long ticks)
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();
 }
+
+/*
+ * sysctl interface for exposing timer tick CPU
+ */
+int timekeeping_expose_timer_cpu(struct ctl_table *table,
+				 int write,
+				 void __user *buffer,
+				 size_t *lenp,
+				 loff_t *ppos)
+{
+	/* proc_dointvec will update the buffer written userspace. */
+	expose_tick_do_timer_cpu = tick_expose_cpu();
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+}
-- 
1.7.9.5

