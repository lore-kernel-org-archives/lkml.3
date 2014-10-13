Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaJMO0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaJMO0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:26:12 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH 1/1] watchdog: parameters to control hard and soft lockup detector individually
Date: Mon, 13 Oct 2014 16:32:42 +0200
Message-Id: <1413210762-4532-2-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413210762-4532-1-git-send-email-uobergfe@redhat.com>
References: <1413210762-4532-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current user interface of the watchdog mechanism it is only
possible to disable or enable both lockup detectors at the same time.
This patch introduces new kernel parameters and changes the semantics
of some existing kernel parameters, so that the hard lockup detector
and the soft lockup detector can be disabled or enabled individually.
With this patch applied, the user interface is as follows.

- parameters in /proc/sys/kernel

  . soft_watchdog
    This is a new parameter to control and examine the run state of
    the soft lockup detector.

  . nmi_watchdog
    The semantics of this parameter have changed. It can now be used
    to control and examine the run state of the hard lockup detector.

  . watchdog
    This parameter is still available to control the run state of both
    lockup detectors at the same time. If this parameter is examined,
    it shows the logical OR of soft_watchdog and nmi_watchdog.

  . watchdog_thresh
    The semantics of this parameter are not affected by the patch.

- kernel command line parameters

  . nosoftlockup
    The semantics of this parameter have changed. It can now be used
    to disable the soft lockup detector at boot time.

  . nmi_watchdog=0 or nmi_watchdog=1
    Disable or enable the hard lockup detector at boot time. The patch
    introduces '=1' as a new option.

  . nowatchdog
    The semantics of this parameter are not affected by the patch. It
    is still available to disable both lockup detectors at boot time.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 include/linux/nmi.h |  12 ++-
 kernel/sysctl.c     |  21 ++++-
 kernel/watchdog.c   | 250 +++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 236 insertions(+), 47 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 1d2a6ab..b52567f 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -55,12 +55,20 @@ static inline bool trigger_allbutself_cpu_backtrace(void)
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
+extern int nmi_watchdog_enabled;
+extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
-extern int proc_dowatchdog(struct ctl_table *, int ,
-			   void __user *, size_t *, loff_t *);
+extern int proc_watchdog_thresh(struct ctl_table *, int ,
+				void __user *, size_t *, loff_t *);
+extern int proc_watchdog(struct ctl_table *, int ,
+			 void __user *, size_t *, loff_t *);
+extern int proc_nmi_watchdog(struct ctl_table *, int ,
+			     void __user *, size_t *, loff_t *);
+extern int proc_soft_watchdog(struct ctl_table *, int ,
+			      void __user *, size_t *, loff_t *);
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9118098..90fe466 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -838,7 +838,7 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
+		.proc_handler   = proc_watchdog,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -847,7 +847,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &watchdog_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dowatchdog,
+		.proc_handler	= proc_watchdog_thresh,
 		.extra1		= &zero,
 		.extra2		= &sixty,
 	},
@@ -873,10 +873,23 @@ static struct ctl_table kern_table[] = {
 #endif /* CONFIG_SMP */
 	{
 		.procname       = "nmi_watchdog",
-		.data           = &watchdog_user_enabled,
+		.data           = &nmi_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= &zero,
+#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
+		.extra2		= &one,
+#else
+		.extra2		= &zero,
+#endif
+	},
+	{
+		.procname       = "soft_watchdog",
+		.data           = &soft_watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
+		.proc_handler   = proc_soft_watchdog,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7b223b2..2e68b85 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -29,8 +29,33 @@
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
-int watchdog_user_enabled = 1;
+/*
+ * The run state of the lockup detectors is controlled by the content of the
+ * 'watchdog_enabled' variable. Each lockup detector has its dedicated bit -
+ * bit 0 for the hard lockup detector and bit 1 for the soft lockup detector.
+ *
+ * 'watchdog_user_enabled', 'nmi_watchdog_enabled' and 'soft_watchdog_enabled'
+ * are variables that are only used as an 'interface' between the parameters
+ * in /proc/sys/kernel and the internal state bits in 'watchdog_enabled'. The
+ * 'watchdog_thresh' variable is handled differently because its value is not
+ * boolean, and the lockup detectors are 'suspended' while 'watchdog_thresh'
+ * is equal zero.
+ */
+#define NMI_WATCHDOG_ENABLED_BIT   0
+#define SOFT_WATCHDOG_ENABLED_BIT  1
+#define NMI_WATCHDOG_ENABLED      (1 << NMI_WATCHDOG_ENABLED_BIT)
+#define SOFT_WATCHDOG_ENABLED     (1 << SOFT_WATCHDOG_ENABLED_BIT)
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
+#else
+unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
+#endif
+int __read_mostly watchdog_user_enabled;
+int __read_mostly nmi_watchdog_enabled;
+int __read_mostly soft_watchdog_enabled;
 int __read_mostly watchdog_thresh = 10;
+
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 #else
@@ -71,7 +96,9 @@ static int __init hardlockup_panic_setup(char *str)
 	else if (!strncmp(str, "nopanic", 7))
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
-		watchdog_user_enabled = 0;
+		watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
+	else if (!strncmp(str, "1", 1))
+		watchdog_enabled |= NMI_WATCHDOG_ENABLED;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -90,19 +117,18 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	watchdog_user_enabled = 0;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
 
-/* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	watchdog_user_enabled = 0;
+	watchdog_enabled &= ~SOFT_WATCHDOG_ENABLED;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
-/*  */
+
 #ifdef CONFIG_SMP
 static int __init softlockup_all_cpu_backtrace_setup(char *str)
 {
@@ -217,10 +243,11 @@ static int is_softlockup(unsigned long touch_ts)
 {
 	unsigned long now = get_timestamp();
 
-	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + get_softlockup_thresh()))
-		return now - touch_ts;
-
+	if (watchdog_enabled & SOFT_WATCHDOG_ENABLED) {
+		/* Warn about unreasonable delays. */
+		if (time_after(now, touch_ts + get_softlockup_thresh()))
+			return now - touch_ts;
+	}
 	return 0;
 }
 
@@ -455,6 +482,15 @@ static void watchdog(unsigned int cpu)
 	__this_cpu_write(soft_lockup_hrtimer_cnt,
 			 __this_cpu_read(hrtimer_interrupts));
 	__touch_watchdog();
+
+	/*
+	 * watchdog_nmi_enable() clears the NMI_WATCHDOG_ENABLED bit in the
+	 * failure path. Check for failures that can occur asynchronously -
+	 * for example, when CPUs are on-lined - and shut down the hardware
+	 * perf event on each CPU accordingly.
+	 */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		watchdog_nmi_disable(cpu);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -470,6 +506,10 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/* nothing to do if the hard lockup detector is disabled */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		goto out;
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -495,6 +535,15 @@ static int watchdog_nmi_enable(unsigned int cpu)
 		goto out_save;
 	}
 
+	/*
+	 * Disable the hard lockup detector if _any_ CPU fails to set up
+	 * set up the hardware perf event. The watchdog() function checks
+	 * the NMI_WATCHDOG_ENABLED bit periodically.
+	 */
+	smp_mb__before_atomic();
+	clear_bit(NMI_WATCHDOG_ENABLED_BIT, &watchdog_enabled);
+	smp_mb__after_atomic();
+
 	/* skip displaying the same error again */
 	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
 		return PTR_ERR(event);
@@ -565,7 +614,7 @@ static void restart_watchdog_hrtimer(void *info)
 				HRTIMER_MODE_REL_PINNED);
 }
 
-static void update_timers(int cpu)
+static void update_watchdog(int cpu)
 {
 	/*
 	 * Make sure that perf event counter will adopt to a new
@@ -580,17 +629,17 @@ static void update_timers(int cpu)
 	watchdog_nmi_enable(cpu);
 }
 
-static void update_timers_all_cpus(void)
+static void update_watchdog_all_cpus(void)
 {
 	int cpu;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		update_timers(cpu);
+		update_watchdog(cpu);
 	put_online_cpus();
 }
 
-static int watchdog_enable_all_cpus(bool sample_period_changed)
+static int watchdog_enable_all_cpus(void)
 {
 	int err = 0;
 
@@ -600,15 +649,21 @@ static int watchdog_enable_all_cpus(bool sample_period_changed)
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
-	} else if (sample_period_changed) {
-		update_timers_all_cpus();
+	} else {
+		/*
+		 * Enable/disable the lockup detectors or
+		 * change the sample period 'on the fly'.
+		 */
+		update_watchdog_all_cpus();
 	}
 
 	return err;
 }
 
-/* prepare/enable/disable routines */
-/* sysctl functions */
+/*
+ * handlers for parameters in /proc/sys/kernel
+ */
+
 #ifdef CONFIG_SYSCTL
 static void watchdog_disable_all_cpus(void)
 {
@@ -618,50 +673,163 @@ static void watchdog_disable_all_cpus(void)
 	}
 }
 
+static DEFINE_MUTEX(watchdog_proc_mutex);
+
 /*
- * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
+ * Update the run state of the lockup detectors.
  */
+static int proc_watchdog_update(void)
+{
+	int err = 0;
 
-int proc_dowatchdog(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
+	/*
+	 * Watchdog threads won't be started if they are already active.
+	 * The 'watchdog_running' variable in watchdog_*_all_cpus() takes
+	 * care of this. If those threads are already active, the sample
+	 * period will be updated and the lockup detectors will be enabled
+	 * or disabled 'on the fly'.
+	 */
+	if (watchdog_enabled && watchdog_thresh)
+		err = watchdog_enable_all_cpus();
+	else
+		watchdog_disable_all_cpus();
+
+	return err;
+
+}
+
+/*
+ * common function for watchdog, nmi_watchdog and soft_watchdog parameter
+ *
+ * caller             | table->data points to | 'which' contains the flag(s)
+ * -------------------|-----------------------|-----------------------------
+ * proc_watchdog      | watchdog_user_enabled | NMI_WATCHDOG_ENABLED or'ed
+ *                    |                       | with SOFT_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_nmi_watchdog  | nmi_watchdog_enabled  | NMI_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_soft_watchdog | soft_watchdog_enabled | SOFT_WATCHDOG_ENABLED
+ */
+static int proc_watchdog_common(int which, struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int err, old_thresh, old_enabled;
-	static DEFINE_MUTEX(watchdog_proc_mutex);
+	int err, old, new;
+	int *watchdog_param = (int *)table->data;
 
 	mutex_lock(&watchdog_proc_mutex);
-	old_thresh = ACCESS_ONCE(watchdog_thresh);
-	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
 
+	/*
+	 * If the parameter is being read return the state of the corresponding
+	 * bit(s) in 'watchdog_enabled', else update 'watchdog_enabled' and the
+	 * run state of the lockup detectors.
+	 */
+	if (!write) {
+		*watchdog_param = (watchdog_enabled & which) != 0;
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	} else {
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+		if (err)
+			goto out;
+
+		/*
+		 * There is a race window between fetching the current value
+		 * from 'watchdog_enabled' and storing the new value. During
+		 * this race window, watchdog_nmi_enable() can sneak in and
+		 * clear the NMI_WATCHDOG_ENABLED bit in 'watchdog_enabled'.
+		 * The 'cmpxchg' detects this race and the loop retries. [We
+		 * cannot use a spinlock or a mutex to address this problem,
+		 * because the code would become prone to deadlock situations
+		 * in connection with parking/unparking the watchdog threads.]
+		 */
+		do {
+			old = watchdog_enabled;
+			/*
+			 * If the parameter value is not zero set the
+			 * corresponding bit(s), else clear it(them).
+			 */
+			if (*watchdog_param)
+				new = old | which;
+			else
+				new = old & ~which;
+		} while (cmpxchg(&watchdog_enabled, old, new) != old);
+
+		/*
+		 * Update the run state of the lockup detectors.
+		 * Restore 'watchdog_enabled' on failure.
+		 */
+		err = proc_watchdog_update();
+		if (err)
+			watchdog_enabled = old;
+	}
+out:
+	mutex_unlock(&watchdog_proc_mutex);
+	return err;
+}
+
+/*
+ * /proc/sys/kernel/watchdog_thresh
+ */
+int proc_watchdog_thresh(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, old;
+
+	mutex_lock(&watchdog_proc_mutex);
+
+	old = ACCESS_ONCE(watchdog_thresh);
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
 	if (err || !write)
 		goto out;
 
-	set_sample_period();
 	/*
-	 * Watchdog threads shouldn't be enabled if they are
-	 * disabled. The 'watchdog_running' variable check in
-	 * watchdog_*_all_cpus() function takes care of this.
+	 * Update the sample period.
+	 * Restore 'watchdog_thresh' on failure.
 	 */
-	if (watchdog_user_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
-	else
-		watchdog_disable_all_cpus();
-
-	/* Restore old values on failure */
-	if (err) {
-		watchdog_thresh = old_thresh;
-		watchdog_user_enabled = old_enabled;
-	}
+	set_sample_period();
+	err = proc_watchdog_update();
+	if (err)
+		watchdog_thresh = old;
 out:
 	mutex_unlock(&watchdog_proc_mutex);
 	return err;
 }
+
+/*
+ * /proc/sys/kernel/watchdog
+ */
+int proc_watchdog(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED|SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/nmi_watchdog
+ */
+int proc_nmi_watchdog(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/soft_watchdog
+ */
+int proc_soft_watchdog(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
 #endif /* CONFIG_SYSCTL */
 
 void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
-	if (watchdog_user_enabled)
-		watchdog_enable_all_cpus(false);
+	if (watchdog_enabled)
+		watchdog_enable_all_cpus();
 }
-- 
1.7.11.7

