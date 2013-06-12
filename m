Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3FLODs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:03:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47896 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3FLOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:02:50 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/6] watchdog: Register / unregister watchdog kthreads on sysctl control
Date: Wed, 12 Jun 2013 16:02:35 +0200
Message-Id: <1371045758-5296-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user activation/deactivation of the watchdog through boot parameters
or systcl is currently implemented with a dance involving kthreads parking
and unparking methods: the threads are unconditionally registered on
boot and they park as soon as the user want the watchdog to be disabled.

This method involves a few noisy details to handle though: the watchdog
kthreads may be unparked anytime due to hotplug operations, after which
the watchdog internals have to decide to park again if it is user-disabled.

As a result the setup() and unpark() methods need to be able to request a
reparking. This is not currently supported in the kthread infrastructure
so this piece of the watchdog code only works halfway.

Besides, unparking/reparking the watchdog kthreads consume unnecessary
cputime on hotplug operations when those could be simply ignored in the
first place.

As suggested by Srivatsa, let's instead only register the watchdog
threads when they are needed. This way we don't need to think about
hotplug operations and we don't burden the CPU onlining when the watchdog
is simply disabled.

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anish Singh <anish198519851985@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   87 ++++++++++++++++++++++++++++------------------------
 1 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 05039e3..52c9a9b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,7 +31,7 @@
 
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
-static int __read_mostly watchdog_disabled;
+static int __read_mostly watchdog_disabled = 1;
 static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -347,11 +347,6 @@ static void watchdog_enable(unsigned int cpu)
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
 
-	if (!watchdog_enabled) {
-		kthread_park(current);
-		return;
-	}
-
 	/* Enable the perf event */
 	watchdog_nmi_enable(cpu);
 
@@ -374,6 +369,11 @@ static void watchdog_disable(unsigned int cpu)
 	watchdog_nmi_disable(cpu);
 }
 
+static void watchdog_cleanup(unsigned int cpu, bool online)
+{
+	watchdog_disable(cpu);
+}
+
 static int watchdog_should_run(unsigned int cpu)
 {
 	return __this_cpu_read(hrtimer_interrupts) !=
@@ -475,28 +475,40 @@ static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
 static void watchdog_nmi_disable(unsigned int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
-/* prepare/enable/disable routines */
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
-static void watchdog_enable_all_cpus(void)
+static struct smp_hotplug_thread watchdog_threads = {
+	.store			= &softlockup_watchdog,
+	.thread_should_run	= watchdog_should_run,
+	.thread_fn		= watchdog,
+	.thread_comm		= "watchdog/%u",
+	.setup			= watchdog_enable,
+	.cleanup		= watchdog_cleanup,
+	.park			= watchdog_disable,
+	.unpark			= watchdog_enable,
+};
+
+static int watchdog_enable_all_cpus(void)
 {
-	unsigned int cpu;
+	int err = 0;
 
 	if (watchdog_disabled) {
-		watchdog_disabled = 0;
-		for_each_online_cpu(cpu)
-			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+		err = smpboot_register_percpu_thread(&watchdog_threads);
+		if (err)
+			pr_err("Failed to create watchdog threads, disabled\n");
+		else
+			watchdog_disabled = 0;
 	}
+
+	return err;
 }
 
+/* prepare/enable/disable routines */
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
 static void watchdog_disable_all_cpus(void)
 {
-	unsigned int cpu;
-
 	if (!watchdog_disabled) {
 		watchdog_disabled = 1;
-		for_each_online_cpu(cpu)
-			kthread_park(per_cpu(softlockup_watchdog, cpu));
+		smpboot_unregister_percpu_thread(&watchdog_threads);
 	}
 }
 
@@ -507,14 +519,14 @@ static void watchdog_disable_all_cpus(void)
 int proc_dowatchdog(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int ret;
+	int err, old_thresh, old_enabled;
 
-	if (watchdog_disabled < 0)
-		return -ENODEV;
+	old_thresh = ACCESS_ONCE(watchdog_thresh);
+	old_enabled = ACCESS_ONCE(watchdog_enabled);
 
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret || !write)
-		return ret;
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (err || !write)
+		return err;
 
 	set_sample_period();
 	/*
@@ -523,29 +535,24 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
 	if (watchdog_enabled && watchdog_thresh)
-		watchdog_enable_all_cpus();
+		err = watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
-	return ret;
+	/* Restore old values on failure */
+	if (err) {
+		watchdog_thresh = old_thresh;
+		watchdog_enabled = old_enabled;
+	}
+
+	return err;
 }
 #endif /* CONFIG_SYSCTL */
 
-static struct smp_hotplug_thread watchdog_threads = {
-	.store			= &softlockup_watchdog,
-	.thread_should_run	= watchdog_should_run,
-	.thread_fn		= watchdog,
-	.thread_comm		= "watchdog/%u",
-	.setup			= watchdog_enable,
-	.park			= watchdog_disable,
-	.unpark			= watchdog_enable,
-};
-
 void __init lockup_detector_init(void)
 {
 	set_sample_period();
-	if (smpboot_register_percpu_thread(&watchdog_threads)) {
-		pr_err("Failed to create watchdog threads, disabled\n");
-		watchdog_disabled = -ENODEV;
-	}
+
+	if (watchdog_enabled)
+		watchdog_enable_all_cpus();
 }
-- 
1.7.5.4

