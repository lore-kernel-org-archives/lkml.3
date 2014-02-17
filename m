Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaBQW2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:28:32 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35105 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaBQWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/55] rcutorture: Abstract torture_onoff()
Date: Mon, 17 Feb 2014 14:12:27 -0800
Message-Id: <1392675179-11560-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because online/offline torturing is not specific to RCU, this commit
abstracts it into the kernel/torture.c module to allow other torture
tests to use it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Conflicts:
	include/linux/torture.h
---
 include/linux/torture.h |  12 ++++
 kernel/rcu/rcutorture.c | 162 ++---------------------------------------
 kernel/torture.c        | 186 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+), 158 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 712a355cd817..553c90111585 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -61,6 +61,18 @@ extern bool verbose;
 #define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
+/* Definitions for a non-string torture-test module parameter. */
+#define torture_parm(type, name, init, msg) \
+	static type name = init; \
+	module_param(name, type, 0444); \
+	MODULE_PARM_DESC(name, msg);
+
+/* Definitions for online/offline exerciser. */
+int torture_onoff_init(long ooholdoff, long oointerval);
+void torture_onoff_cleanup(void);
+char *torture_onoff_stats(char *page);
+bool torture_onoff_failures(void);
+
 /* Low-rider random number generator. */
 struct torture_random_state {
 	unsigned long trs_state;
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 7b56da0b8cfe..001e5a42a4b2 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -109,9 +109,6 @@ static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
 static struct task_struct *shutdown_task;
-#ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct *onoff_task;
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static struct task_struct *stall_task;
 static struct task_struct **barrier_cbs_tasks;
 static struct task_struct *barrier_task;
@@ -146,16 +143,6 @@ static long n_rcu_torture_boost_rterror;
 static long n_rcu_torture_boost_failure;
 static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
-static long n_offline_attempts;
-static long n_offline_successes;
-static unsigned long sum_offline;
-static int min_offline = -1;
-static int max_offline;
-static long n_online_attempts;
-static long n_online_successes;
-static unsigned long sum_online;
-static int min_online = -1;
-static int max_online;
 static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
@@ -993,13 +980,7 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	page += sprintf(page,
-		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
-		       n_online_successes, n_online_attempts,
-		       n_offline_successes, n_offline_attempts,
-		       min_online, max_online,
-		       min_offline, max_offline,
-		       sum_online, sum_offline, HZ);
+	page = torture_onoff_stats(page);
 	page += sprintf(page, "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
@@ -1203,140 +1184,6 @@ rcu_torture_shutdown(void *arg)
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-/*
- * Execute random CPU-hotplug operations at the interval specified
- * by the onoff_interval.
- */
-static int
-rcu_torture_onoff(void *arg)
-{
-	int cpu;
-	unsigned long delta;
-	int maxcpu = -1;
-	DEFINE_TORTURE_RANDOM(rand);
-	int ret;
-	unsigned long starttime;
-
-	VERBOSE_TOROUT_STRING("rcu_torture_onoff task started");
-	for_each_online_cpu(cpu)
-		maxcpu = cpu;
-	WARN_ON(maxcpu < 0);
-	if (onoff_holdoff > 0) {
-		VERBOSE_TOROUT_STRING("rcu_torture_onoff begin holdoff");
-		schedule_timeout_interruptible(onoff_holdoff * HZ);
-		VERBOSE_TOROUT_STRING("rcu_torture_onoff end holdoff");
-	}
-	while (!kthread_should_stop()) {
-		cpu = (torture_random(&rand) >> 4) % (maxcpu + 1);
-		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
-			if (verbose)
-				pr_alert("%s" TORTURE_FLAG
-					 "rcu_torture_onoff task: offlining %d\n",
-					 torture_type, cpu);
-			starttime = jiffies;
-			n_offline_attempts++;
-			ret = cpu_down(cpu);
-			if (ret) {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: offline %d failed: errno %d\n",
-						 torture_type, cpu, ret);
-			} else {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: offlined %d\n",
-						 torture_type, cpu);
-				n_offline_successes++;
-				delta = jiffies - starttime;
-				sum_offline += delta;
-				if (min_offline < 0) {
-					min_offline = delta;
-					max_offline = delta;
-				}
-				if (min_offline > delta)
-					min_offline = delta;
-				if (max_offline < delta)
-					max_offline = delta;
-			}
-		} else if (cpu_is_hotpluggable(cpu)) {
-			if (verbose)
-				pr_alert("%s" TORTURE_FLAG
-					 "rcu_torture_onoff task: onlining %d\n",
-					 torture_type, cpu);
-			starttime = jiffies;
-			n_online_attempts++;
-			ret = cpu_up(cpu);
-			if (ret) {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: online %d failed: errno %d\n",
-						 torture_type, cpu, ret);
-			} else {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: onlined %d\n",
-						 torture_type, cpu);
-				n_online_successes++;
-				delta = jiffies - starttime;
-				sum_online += delta;
-				if (min_online < 0) {
-					min_online = delta;
-					max_online = delta;
-				}
-				if (min_online > delta)
-					min_online = delta;
-				if (max_online < delta)
-					max_online = delta;
-			}
-		}
-		schedule_timeout_interruptible(onoff_interval * HZ);
-	}
-	VERBOSE_TOROUT_STRING("rcu_torture_onoff task stopping");
-	return 0;
-}
-
-static int
-rcu_torture_onoff_init(void)
-{
-	int ret;
-
-	if (onoff_interval <= 0)
-		return 0;
-	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
-	if (IS_ERR(onoff_task)) {
-		ret = PTR_ERR(onoff_task);
-		onoff_task = NULL;
-		return ret;
-	}
-	torture_shuffle_task_register(onoff_task);
-	return 0;
-}
-
-static void rcu_torture_onoff_cleanup(void)
-{
-	if (onoff_task == NULL)
-		return;
-	VERBOSE_TOROUT_STRING("Stopping rcu_torture_onoff task");
-	kthread_stop(onoff_task);
-	onoff_task = NULL;
-}
-
-#else /* #ifdef CONFIG_HOTPLUG_CPU */
-
-static int
-rcu_torture_onoff_init(void)
-{
-	return 0;
-}
-
-static void rcu_torture_onoff_cleanup(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * CPU-stall kthread.  It waits as specified by stall_cpu_holdoff, then
  * induces a CPU stall for the time specified by stall_cpu.
@@ -1656,7 +1503,7 @@ rcu_torture_cleanup(void)
 		kthread_stop(shutdown_task);
 	}
 	shutdown_task = NULL;
-	rcu_torture_onoff_cleanup();
+	torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1667,8 +1514,7 @@ rcu_torture_cleanup(void)
 
 	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
-	else if (n_online_successes != n_online_attempts ||
-		 n_offline_successes != n_offline_attempts)
+	else if (torture_onoff_failures())
 		rcu_torture_print_module_parms(cur_ops,
 					       "End of test: RCU_HOTPLUG");
 	else
@@ -1934,7 +1780,7 @@ rcu_torture_init(void)
 		torture_shuffle_task_register(shutdown_task);
 		wake_up_process(shutdown_task);
 	}
-	i = rcu_torture_onoff_init();
+	i = torture_onoff_init(onoff_holdoff * HZ, onoff_interval * HZ);
 	if (i != 0) {
 		firsterr = i;
 		goto unwind;
diff --git a/kernel/torture.c b/kernel/torture.c
index 26058f20ee83..a7ec8a7d561e 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -54,6 +54,192 @@ EXPORT_SYMBOL_GPL(fullstop);
 DEFINE_MUTEX(fullstop_mutex);
 EXPORT_SYMBOL_GPL(fullstop_mutex);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Variables for online-offline handling.  Only present if CPU hotplug
+ * is enabled, otherwise does nothing.
+ */
+
+static struct task_struct *onoff_task;
+static long onoff_holdoff;
+static long onoff_interval;
+static long n_offline_attempts;
+static long n_offline_successes;
+static unsigned long sum_offline;
+static int min_offline = -1;
+static int max_offline;
+static long n_online_attempts;
+static long n_online_successes;
+static unsigned long sum_online;
+static int min_online = -1;
+static int max_online;
+
+/*
+ * Execute random CPU-hotplug operations at the interval specified
+ * by the onoff_interval.
+ */
+static int
+torture_onoff(void *arg)
+{
+	int cpu;
+	unsigned long delta;
+	int maxcpu = -1;
+	DEFINE_TORTURE_RANDOM(rand);
+	int ret;
+	unsigned long starttime;
+
+	VERBOSE_TOROUT_STRING("torture_onoff task started");
+	for_each_online_cpu(cpu)
+		maxcpu = cpu;
+	WARN_ON(maxcpu < 0);
+	if (onoff_holdoff > 0) {
+		VERBOSE_TOROUT_STRING("torture_onoff begin holdoff");
+		schedule_timeout_interruptible(onoff_holdoff);
+		VERBOSE_TOROUT_STRING("torture_onoff end holdoff");
+	}
+	while (!torture_must_stop()) {
+		cpu = (torture_random(&rand) >> 4) % (maxcpu + 1);
+		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				pr_alert("%s" TORTURE_FLAG
+					 "torture_onoff task: offlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
+			n_offline_attempts++;
+			ret = cpu_down(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: offline %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: offlined %d\n",
+						 torture_type, cpu);
+				n_offline_successes++;
+				delta = jiffies - starttime;
+				sum_offline += delta;
+				if (min_offline < 0) {
+					min_offline = delta;
+					max_offline = delta;
+				}
+				if (min_offline > delta)
+					min_offline = delta;
+				if (max_offline < delta)
+					max_offline = delta;
+			}
+		} else if (cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				pr_alert("%s" TORTURE_FLAG
+					 "torture_onoff task: onlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
+			n_online_attempts++;
+			ret = cpu_up(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: online %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: onlined %d\n",
+						 torture_type, cpu);
+				n_online_successes++;
+				delta = jiffies - starttime;
+				sum_online += delta;
+				if (min_online < 0) {
+					min_online = delta;
+					max_online = delta;
+				}
+				if (min_online > delta)
+					min_online = delta;
+				if (max_online < delta)
+					max_online = delta;
+			}
+		}
+		schedule_timeout_interruptible(onoff_interval);
+	}
+	VERBOSE_TOROUT_STRING("torture_onoff task stopping");
+	return 0;
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Initiate online-offline handling.
+ */
+int torture_onoff_init(long ooholdoff, long oointerval)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	int ret;
+
+	onoff_holdoff = ooholdoff;
+	onoff_interval = oointerval;
+	if (onoff_interval <= 0)
+		return 0;
+	onoff_task = kthread_run(torture_onoff, NULL, "torture_onoff");
+	if (IS_ERR(onoff_task)) {
+		ret = PTR_ERR(onoff_task);
+		onoff_task = NULL;
+		return ret;
+	}
+	torture_shuffle_task_register(onoff_task);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(torture_onoff_init);
+
+/*
+ * Clean up after online/offline testing.
+ */
+void torture_onoff_cleanup(void)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	if (onoff_task == NULL)
+		return;
+	VERBOSE_TOROUT_STRING("Stopping torture_onoff task");
+	kthread_stop(onoff_task);
+	onoff_task = NULL;
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+}
+EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
+
+/*
+ * Print online/offline testing statistics.
+ */
+char *torture_onoff_stats(char *page)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	page += sprintf(page,
+		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
+		       n_online_successes, n_online_attempts,
+		       n_offline_successes, n_offline_attempts,
+		       min_online, max_online,
+		       min_offline, max_offline,
+		       sum_online, sum_offline, HZ);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	return page;
+}
+EXPORT_SYMBOL_GPL(torture_onoff_stats);
+
+/*
+ * Were all the online/offline operations successful?
+ */
+bool torture_onoff_failures(void)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	return n_online_successes != n_online_attempts ||
+	       n_offline_successes != n_offline_attempts;
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+	return false;
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+}
+EXPORT_SYMBOL_GPL(torture_onoff_failures);
+
 #define TORTURE_RANDOM_MULT	39916801  /* prime */
 #define TORTURE_RANDOM_ADD	479001701 /* prime */
 #define TORTURE_RANDOM_REFRESH	10000
-- 
1.8.1.5

