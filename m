Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaBYMiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:38:00 -0500
Received: from asav4.altibox.net ([81.167.36.153]:49812 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaBYMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:40 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 5/6] Expose the forced_timer_cpu to userspace via sysctl as R/W
Date: Tue, 25 Feb 2014 13:34:00 +0100
Message-Id: <1393331641-14016-6-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

This allows userspace to set a specific CPU as the only core able
to handle do_timer() updates via

     cat sysctl kernel.forced_timer_cpu
     /proc/sys/kernel/forced_timer_cpu

and for writing:

     sysctl -w kernel.forced_timer_cpu=2
     /bin/echo 2 > /proc/sys/kernel/forced_timer_cpu

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 include/linux/clocksource.h |    8 ++++++++
 kernel/sysctl.c             |    7 +++++++
 kernel/time/timekeeping.c   |   24 +++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index cfd39e8..4ef47e7 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -361,6 +361,8 @@ static inline void clocksource_of_init(void) {}
 
 /*
  * expose the CPU that handles the timer-tick.
+ *
+ * Both the current as well as the forced value.
  */
 extern int expose_tick_do_timer_cpu;
 extern int timekeeping_expose_timer_cpu(struct ctl_table *table,
@@ -368,5 +370,11 @@ extern int timekeeping_expose_timer_cpu(struct ctl_table *table,
 					void __user *buffer,
 					size_t *lenp,
 					loff_t *ppos);
+extern int expose_tick_forced_timer_cpu;
+int timekeeping_expose_forced_timer_cpu(struct ctl_table *table,
+					int write,
+					void __user *buffer,
+					size_t *lenp,
+					loff_t *ppos);
 
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a882c9e..c84c17a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -432,6 +432,13 @@ static struct ctl_table kern_table[] = {
 		.mode	   = 0444,
 		.proc_handler	= timekeeping_expose_timer_cpu,
 	},
+	{
+		.procname  = "forced_timer_cpu",
+		.data      = &expose_tick_forced_timer_cpu,
+		.maxlen	   = sizeof(int),
+		.mode	   = 0644,
+		.proc_handler	= timekeeping_expose_forced_timer_cpu,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 55428f9..4bdfa11 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -37,6 +37,11 @@
 int expose_tick_do_timer_cpu;
 
 /*
+ * Hold the current value of forced CPU.
+ */
+int expose_tick_forced_timer_cpu = -1;
+
+/*
  * sysfs interface to timer-cpu
  */
 static ssize_t current_cpu_show(struct kobject *kobj,
@@ -1791,7 +1796,7 @@ void xtime_update(unsigned long ticks)
 }
 
 /*
- * sysctl interface for exposing timer tick CPU
+ * sysctl-interface exposing timer tick CPU
  */
 int timekeeping_expose_timer_cpu(struct ctl_table *table,
 				 int write,
@@ -1803,3 +1808,20 @@ int timekeeping_expose_timer_cpu(struct ctl_table *table,
 	expose_tick_do_timer_cpu = tick_expose_cpu();
 	return proc_dointvec(table, write, buffer, lenp, ppos);
 }
+
+int timekeeping_expose_forced_timer_cpu(struct ctl_table *table,
+					int write,
+					void __user *buffer,
+					size_t *lenp,
+					loff_t *ppos)
+{
+	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		goto out;
+
+	ret = tick_set_forced_cpu(expose_tick_forced_timer_cpu);
+	BUG_ON(tick_expose_cpu() != expose_tick_forced_timer_cpu);
+out:
+	expose_tick_forced_timer_cpu = tick_get_forced_cpu();
+	return ret;
+}
-- 
1.7.9.5

