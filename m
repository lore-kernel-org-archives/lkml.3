Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbaGXKNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGXKNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:13:49 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: uobergfe@redhat.com, dzickus@redhat.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, mingo@redhat.com
Subject: [PATCH 2/3] watchdog: control hard lockup detection default
Date: Thu, 24 Jul 2014 12:13:30 +0200
Message-Id: <1406196811-5384-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1406196811-5384-1-git-send-email-drjones@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

In some cases we don't want hard lockup detection enabled by default.
An example is when running as a guest. Introduce

  watchdog_enable_hardlockup_detector(bool)

allowing those cases to disable hard lockup detection. This must be
executed early by the boot processor from e.g. smp_prepare_boot_cpu,
in order to allow kernel command line arguments to override it, as
well as to avoid hard lockup detection being enabled before we've
had a chance to indicate that it's unwanted. In summary,

  initial boot:					default=enabled
  smp_prepare_boot_cpu
    watchdog_enable_hardlockup_detector(false):	default=disabled
  cmdline has 'nmi_watchdog=1':			default=enabled

The running kernel still has the ability to enable/disable at any
time with /proc/sys/kernel/nmi_watchdog us usual. However even
when the default has been overridden /proc/sys/kernel/nmi_watchdog
will initially show '1'. To truly turn it on one must disable/enable
it, i.e.
  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1 > /proc/sys/kernel/nmi_watchdog

This patch will be immediately useful for KVM with the next patch
of this series. Other hypervisor guest types may find it useful as
well.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/linux/nmi.h |  9 +++++++++
 kernel/watchdog.c   | 45 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 447775ee2c4b0..72aacf4e3d539 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -17,11 +17,20 @@
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
+extern void watchdog_enable_hardlockup_detector(bool val);
+extern bool watchdog_hardlockup_detector_is_enabled(void);
 #else
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
+static inline void watchdog_enable_hardlockup_detector(bool)
+{
+}
+static inline bool watchdog_hardlockup_detector_is_enabled(void)
+{
+	return true;
+}
 #endif
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c985a21926545..34eca29e28a4c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -63,6 +63,25 @@ static unsigned long soft_lockup_nmi_warn;
 static int hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 
+static bool hardlockup_detector_enabled = true;
+/*
+ * We may not want to enable hard lockup detection by default in all cases,
+ * for example when running the kernel as a guest on a hypervisor. In these
+ * cases this function can be called to disable hard lockup detection. This
+ * function should only be executed once by the boot processor before the
+ * kernel command line parameters are parsed, because otherwise it is not
+ * possible to override this in hardlockup_panic_setup().
+ */
+void watchdog_enable_hardlockup_detector(bool val)
+{
+	hardlockup_detector_enabled = val;
+}
+
+bool watchdog_hardlockup_detector_is_enabled(void)
+{
+	return hardlockup_detector_enabled;
+}
+
 static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
@@ -71,6 +90,14 @@ static int __init hardlockup_panic_setup(char *str)
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_user_enabled = 0;
+	else if (!strncmp(str, "1", 1) || !strncmp(str, "2", 1)) {
+		/*
+		 * Setting 'nmi_watchdog=1' or 'nmi_watchdog=2' (legacy option)
+		 * has the same effect.
+		 */
+		watchdog_user_enabled = 1;
+		watchdog_enable_hardlockup_detector(true);
+	}
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -451,6 +478,15 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/*
+	 * Some kernels need to default hard lockup detection to
+	 * 'disabled', for example a guest on a hypervisor.
+	 */
+	if (!watchdog_hardlockup_detector_is_enabled()) {
+		event = ERR_PTR(-ENOENT);
+		goto handle_err;
+	}
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -465,6 +501,7 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 
+handle_err:
 	/* save cpu0 error for future comparision */
 	if (cpu == 0 && IS_ERR(event))
 		cpu0_err = PTR_ERR(event);
@@ -610,11 +647,13 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old_thresh, old_enabled;
+	bool old_hardlockup;
 	static DEFINE_MUTEX(watchdog_proc_mutex);
 
 	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
 	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
+	old_hardlockup = watchdog_hardlockup_detector_is_enabled();
 
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (err || !write)
@@ -626,15 +665,17 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * disabled. The 'watchdog_running' variable check in
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
-	if (watchdog_user_enabled && watchdog_thresh)
+	if (watchdog_user_enabled && watchdog_thresh) {
+		watchdog_enable_hardlockup_detector(true);
 		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
-	else
+	} else
 		watchdog_disable_all_cpus();
 
 	/* Restore old values on failure */
 	if (err) {
 		watchdog_thresh = old_thresh;
 		watchdog_user_enabled = old_enabled;
+		watchdog_enable_hardlockup_detector(old_hardlockup);
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
-- 
1.9.3

