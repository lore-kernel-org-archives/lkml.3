Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaBSMmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:42:14 -0500
Received: from asav4.altibox.net ([81.167.36.153]:35886 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaBSMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:42:12 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 07:42:12 EST
From: henrik@austad.us
To: linux-kernel@vger.kernel.org
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH Resend] Expose do_timer CPU via sysctl to userspace as R/W
Date: Wed, 19 Feb 2014 13:32:58 +0100
Message-Id: <1392813178-25095-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

Looks like this got dropped by vger a few days ago, resending.

This allows everybody in a system to read which core is currently
running do_timer() as well as letting root change this.

A few things to keep in mind

- This is intended as a debug-feature, except for testing whether or not
  the target CPU is present or not, the logic will not care -one- bit if
  moving the do_timer to that particular CPU is a good idea.
- It introduces more ifdeffery in the kernel.

On the positive side, it allows you to quickly change where the timer
runs, which is nice if you have interrupts flooding the core where the
timer is updated.

It is exposed via sysctl as

     /proc/sys/kernel/time_tick_cpu
     kernel:time_tick_cpu

Enable/disable via CONFIG_EXPOSE_TICK_CPU, disabling this will not lead
to an increased image size.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 include/linux/clocksource.h |   15 +++++++++++++++
 kernel/sysctl.c             |   13 +++++++++++++
 kernel/time/Kconfig         |   16 ++++++++++++++++
 kernel/time/tick-common.c   |   25 +++++++++++++++++++++++++
 kernel/time/tick-internal.h |    5 +++++
 kernel/time/timekeeping.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 116 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 67301a4..b61c893 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -18,6 +18,10 @@
 #include <asm/div64.h>
 #include <asm/io.h>
 
+#ifdef CONFIG_EXPOSE_TICK_CPU
+#include <linux/sysctl.h>
+#endif
+
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 struct clocksource;
@@ -359,3 +363,14 @@ static inline void clocksource_of_init(void) {}
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */
+#ifdef CONFIG_EXPOSE_TICK_CPU
+/*
+ * expose the CPU that handles the timer-tick and allow userspace to change it.
+ */
+extern int sysctl_tick_do_timer_cpu;
+extern int timekeeping_expose_timer_cpu(struct ctl_table *table,
+					int write,
+					void __user *buffer,
+					size_t *lenp,
+					loff_t *ppos);
+#endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..c6613f5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -64,6 +64,10 @@
 #include <linux/sched/sysctl.h>
 #include <linux/kexec.h>
 
+#ifdef CONFIG_EXPOSE_TICK_CPU
+#include <linux/clocksource.h>
+#endif
+
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 
@@ -424,6 +428,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
 	},
+#ifdef CONFIG_EXPOSE_TICK_CPU
+	{
+		.procname  = "timer_tick_cpu",
+		.data      = &sysctl_tick_do_timer_cpu,
+		.maxlen	   = sizeof(int),
+		.mode	   = 0644,
+		.proc_handler	= timekeeping_expose_timer_cpu,
+	},
+#endif
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3ce6e8c..45460de 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -202,3 +202,19 @@ config HIGH_RES_TIMERS
 
 endmenu
 endif
+
+config EXPOSE_TICK_CPU
+         bool "Expose which CPU is responsible for timer-tick"
+	 default False
+	 help
+	   This option exposes which CPU is responsible from the
+	   periodic timer-tick. It also alows userspace to change the
+	   CPU, letting userspace move the peridic update away from a
+	   CPU.
+
+	   Note: if the CPU goes offline, the underlying machinery will
+	   move the handler away, and once the CPU is brought back
+	   online, there is absolutely *no* guarantee that the handling
+	   will be moved back to this CPU.
+
+
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..54dbd7f 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -347,6 +347,31 @@ void tick_handover_do_timer(int *cpup)
 	}
 }
 
+#ifdef CONFIG_EXPOSE_TICK_CPU
+/* part of the expose-tick sysctl interface for r/w which core to run
+ * the do_timer update */
+int tick_expose_cpu(void)
+{
+	return tick_do_timer_cpu;
+}
+int tick_set_cpu(int new_cpu)
+{
+	int old_cpu, current_cpu;
+	if (!cpu_present(new_cpu)) {
+		pr_err("Illegal value for tick_do_timer_cpu, requested CPU (%d) not present\n",
+			new_cpu);
+		return -EINVAL;
+	}
+
+	current_cpu = tick_do_timer_cpu;
+	if ((old_cpu = cmpxchg(&tick_do_timer_cpu, tick_do_timer_cpu, new_cpu)) != current_cpu) {
+		pr_err("Error updating timer-cpu!\n");
+		return -EBADE;
+	}
+	return 0;
+}
+#endif	/* CONFIG_EXPOSE_TICK_CPU */
+
 /*
  * Shutdown an event device on a given cpu:
  *
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 8329669..6c960d6 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -154,5 +154,10 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 
 #endif
 
+#ifdef CONFIG_EXPOSE_TICK_CPU
+extern int tick_expose_cpu(void);
+extern int tick_set_cpu(int new_cpu);
+#endif
+
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..09cebda 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -27,6 +27,10 @@
 #include "ntp_internal.h"
 #include "timekeeping_internal.h"
 
+#ifdef CONFIG_EXPOSE_TICK_CPU
+int sysctl_tick_do_timer_cpu;
+#endif
+
 #define TK_CLEAR_NTP		(1 << 0)
 #define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
@@ -1583,6 +1587,7 @@ void do_timer(unsigned long ticks)
 	calc_global_load(ticks);
 }
 
+
 /**
  * get_xtime_and_monotonic_and_sleep_offset() - get xtime, wall_to_monotonic,
  *    and sleep offsets.
@@ -1739,3 +1744,40 @@ void xtime_update(unsigned long ticks)
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();
 }
+
+#ifdef CONFIG_EXPOSE_TICK_CPU
+/*
+ *sysctl interface for exposing timer tick CPU
+ *
+ * Note that setting the timer-cpu will not be persistent accross
+ * sleep/resumes or other events that end up changing the do_timer_cpu.
+ */
+int timekeeping_expose_timer_cpu(struct ctl_table *table,
+				 int write,
+				 void __user *buffer,
+				 size_t *lenp,
+				 loff_t *ppos)
+{
+	static DEFINE_MUTEX(expose_mutex);
+	int ret = -EINVAL;
+
+	mutex_lock(&expose_mutex);
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret || !write) {
+		goto out;
+	}
+
+	/*
+	 * tick_set_cpu will do rudimentary check of value.
+	 *
+	 * We could update tick_do_timer_cpu here, but better leave this
+	 * to tick-common.c
+	 */
+	ret = tick_set_cpu(sysctl_tick_do_timer_cpu);
+out:
+	/* blind update/reset for sysctl value */
+	sysctl_tick_do_timer_cpu = tick_expose_cpu();
+	mutex_unlock(&expose_mutex);
+	return ret;
+}
+#endif	/* CONFIG_EXPOSE_TICK_CPU */
-- 
1.7.10.4

