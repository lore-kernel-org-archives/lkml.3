Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3ETQCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34735 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3ETQCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH 7/8] watchdog: Rename confusing state variable
Date: Mon, 20 May 2013 18:01:55 +0200
Message-Id: <1369065716-22801-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two very conflicting state variable names in the
watchdog:

* watchdog_enabled: This one reflects the user interface. It's
set to 1 by default and can be overriden with boot options
or sysctl/procfs interface.

* watchdog_disabled: This is the internal toggle state that
tells if watchdog threads, timers and NMI events are currently
running or not. This state depends on the user settings and
hardware support. It's a convenient state latch.

Now we really need to find clearer names because those
are just too confusing to encourage deep review.

watchdog_enabled now becomes watchdog_user_enabled to reflect
its purpose as an interface.

watchdog_disabled becomes watchdog_running to suggest its
role as a pure internal state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/nmi.h |    2 +-
 kernel/sysctl.c     |    4 ++--
 kernel/watchdog.c   |   32 ++++++++++++++++----------------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..6a45fb5 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -46,7 +46,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
-extern int watchdog_enabled;
+extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..b080565 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -801,7 +801,7 @@ static struct ctl_table kern_table[] = {
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
-		.data           = &watchdog_enabled,
+		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
@@ -828,7 +828,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname       = "nmi_watchdog",
-		.data           = &watchdog_enabled,
+		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7e1a021..10776fe 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -29,9 +29,9 @@
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled = 1;
+int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
-static int __read_mostly watchdog_disabled;
+static int __read_mostly watchdog_running = 1;
 static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -63,7 +63,7 @@ static int __init hardlockup_panic_setup(char *str)
 	else if (!strncmp(str, "nopanic", 7))
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
-		watchdog_enabled = 0;
+		watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -82,7 +82,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	watchdog_enabled = 0;
+	watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
@@ -90,7 +90,7 @@ __setup("nowatchdog", nowatchdog_setup);
 /* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	watchdog_enabled = 0;
+	watchdog_user_enabled = 0;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
@@ -158,7 +158,7 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_enabled) {
+	if (watchdog_user_enabled) {
 		unsigned cpu;
 
 		for_each_present_cpu(cpu) {
@@ -347,7 +347,7 @@ static void watchdog_enable(unsigned int cpu)
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
 
-	if (!watchdog_enabled) {
+	if (!watchdog_user_enabled) {
 		kthread_park(current);
 		return;
 	}
@@ -482,8 +482,8 @@ static void watchdog_enable_all_cpus(void)
 {
 	unsigned int cpu;
 
-	if (watchdog_disabled) {
-		watchdog_disabled = 0;
+	if (!watchdog_running) {
+		watchdog_running = 1;
 		for_each_online_cpu(cpu)
 			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
 	}
@@ -493,8 +493,8 @@ static void watchdog_disable_all_cpus(void)
 {
 	unsigned int cpu;
 
-	if (!watchdog_disabled) {
-		watchdog_disabled = 1;
+	if (watchdog_running) {
+		watchdog_running = 0;
 		for_each_online_cpu(cpu)
 			kthread_park(per_cpu(softlockup_watchdog, cpu));
 	}
@@ -509,7 +509,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 {
 	int ret;
 
-	if (watchdog_disabled < 0)
+	if (watchdog_running < 0)
 		return -ENODEV;
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
@@ -522,7 +522,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * disabled. The 'watchdog_disabled' variable check in
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
-	if (watchdog_enabled && watchdog_thresh)
+	if (watchdog_user_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
@@ -544,14 +544,14 @@ static struct smp_hotplug_thread watchdog_threads = {
 void __init lockup_detector_init(void)
 {
 #ifdef CONFIG_NO_HZ_FULL
-	watchdog_enabled = 0;
-	watchdog_disabled = 1;
+	watchdog_user_enabled = 0;
+	watchdog_running = 0;
 	pr_warning("Disabled lockup detectors by default because of full dynticks\n");
 	pr_warning("You can overwrite that with 'sysctl -w kernel.watchdog=1'\n");
 #endif
 	set_sample_period();
 	if (smpboot_register_percpu_thread(&watchdog_threads)) {
 		pr_err("Failed to create watchdog threads, disabled\n");
-		watchdog_disabled = -ENODEV;
+		watchdog_running = -ENODEV;
 	}
 }
-- 
1.7.5.4

