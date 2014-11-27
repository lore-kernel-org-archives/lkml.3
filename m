Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaK0AUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:20:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49739 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753434AbaK0AU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:20:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] PM: Drop CONFIG_PM_RUNTIME from the driver core
Date: Thu, 27 Nov 2014 01:39:12 +0100
Message-ID: <3778413.eKNVGsvndA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <37310416.jZXoh5nfSC@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so quite a few
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM or even may be dropped entirely in some cases.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in the PM core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/clock_ops.c       |   69 +----------------------------------
 drivers/base/power/domain.c          |   34 +----------------
 drivers/base/power/domain_governor.c |   11 -----
 drivers/base/power/power.h           |   56 ++++++++++++----------------
 drivers/base/power/qos.c             |    5 --
 drivers/base/power/runtime.c         |    9 ----
 drivers/base/power/sysfs.c           |   19 ---------
 include/linux/pm.h                   |    2 -
 include/linux/pm_domain.h            |    8 +---
 include/linux/pm_qos.h               |   38 ++++++++-----------
 include/linux/pm_runtime.h           |   21 ++++------
 kernel/power/Kconfig                 |    4 --
 12 files changed, 60 insertions(+), 216 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -563,7 +563,7 @@ struct dev_pm_info {
 #else
 	unsigned int		should_wakeup:1;
 #endif
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	struct timer_list	suspend_timer;
 	unsigned long		timer_expires;
 	struct work_struct	work;
Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -35,16 +35,6 @@ extern int pm_generic_runtime_suspend(st
 extern int pm_generic_runtime_resume(struct device *dev);
 extern int pm_runtime_force_suspend(struct device *dev);
 extern int pm_runtime_force_resume(struct device *dev);
-#else
-static inline bool queue_pm_work(struct work_struct *work) { return false; }
-
-static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
-static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
-static inline int pm_runtime_force_suspend(struct device *dev) { return 0; }
-static inline int pm_runtime_force_resume(struct device *dev) { return 0; }
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
 
 extern int __pm_runtime_idle(struct device *dev, int rpmflags);
 extern int __pm_runtime_suspend(struct device *dev, int rpmflags);
@@ -128,7 +118,14 @@ static inline void pm_runtime_mark_last_
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
-#else /* !CONFIG_PM_RUNTIME */
+#else /* !CONFIG_PM */
+
+static inline bool queue_pm_work(struct work_struct *work) { return false; }
+
+static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
+static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
+static inline int pm_runtime_force_suspend(struct device *dev) { return 0; }
+static inline int pm_runtime_force_resume(struct device *dev) { return 0; }
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
 {
@@ -179,7 +176,7 @@ static inline unsigned long pm_runtime_a
 static inline void pm_runtime_set_memalloc_noio(struct device *dev,
 						bool enable){}
 
-#endif /* !CONFIG_PM_RUNTIME */
+#endif /* !CONFIG_PM */
 
 static inline int pm_runtime_idle(struct device *dev)
 {
Index: linux-pm/drivers/base/power/power.h
===================================================================
--- linux-pm.orig/drivers/base/power/power.h
+++ linux-pm/drivers/base/power/power.h
@@ -9,7 +9,7 @@ static inline void device_pm_init_common
 	}
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 static inline void pm_runtime_early_init(struct device *dev)
 {
@@ -20,7 +20,21 @@ static inline void pm_runtime_early_init
 extern void pm_runtime_init(struct device *dev);
 extern void pm_runtime_remove(struct device *dev);
 
-#else /* !CONFIG_PM_RUNTIME */
+/*
+ * sysfs.c
+ */
+
+extern int dpm_sysfs_add(struct device *dev);
+extern void dpm_sysfs_remove(struct device *dev);
+extern void rpm_sysfs_remove(struct device *dev);
+extern int wakeup_sysfs_add(struct device *dev);
+extern void wakeup_sysfs_remove(struct device *dev);
+extern int pm_qos_sysfs_add_resume_latency(struct device *dev);
+extern void pm_qos_sysfs_remove_resume_latency(struct device *dev);
+extern int pm_qos_sysfs_add_flags(struct device *dev);
+extern void pm_qos_sysfs_remove_flags(struct device *dev);
+
+#else /* CONFIG_PM */
 
 static inline void pm_runtime_early_init(struct device *dev)
 {
@@ -30,7 +44,15 @@ static inline void pm_runtime_early_init
 static inline void pm_runtime_init(struct device *dev) {}
 static inline void pm_runtime_remove(struct device *dev) {}
 
-#endif /* !CONFIG_PM_RUNTIME */
+static inline int dpm_sysfs_add(struct device *dev) { return 0; }
+static inline void dpm_sysfs_remove(struct device *dev) {}
+static inline void rpm_sysfs_remove(struct device *dev) {}
+static inline int wakeup_sysfs_add(struct device *dev) { return 0; }
+static inline void wakeup_sysfs_remove(struct device *dev) {}
+static inline int pm_qos_sysfs_add(struct device *dev) { return 0; }
+static inline void pm_qos_sysfs_remove(struct device *dev) {}
+
+#endif
 
 #ifdef CONFIG_PM_SLEEP
 
@@ -77,31 +99,3 @@ static inline void device_pm_init(struct
 	device_pm_sleep_init(dev);
 	pm_runtime_init(dev);
 }
-
-#ifdef CONFIG_PM
-
-/*
- * sysfs.c
- */
-
-extern int dpm_sysfs_add(struct device *dev);
-extern void dpm_sysfs_remove(struct device *dev);
-extern void rpm_sysfs_remove(struct device *dev);
-extern int wakeup_sysfs_add(struct device *dev);
-extern void wakeup_sysfs_remove(struct device *dev);
-extern int pm_qos_sysfs_add_resume_latency(struct device *dev);
-extern void pm_qos_sysfs_remove_resume_latency(struct device *dev);
-extern int pm_qos_sysfs_add_flags(struct device *dev);
-extern void pm_qos_sysfs_remove_flags(struct device *dev);
-
-#else /* CONFIG_PM */
-
-static inline int dpm_sysfs_add(struct device *dev) { return 0; }
-static inline void dpm_sysfs_remove(struct device *dev) {}
-static inline void rpm_sysfs_remove(struct device *dev) {}
-static inline int wakeup_sysfs_add(struct device *dev) { return 0; }
-static inline void wakeup_sysfs_remove(struct device *dev) {}
-static inline int pm_qos_sysfs_add(struct device *dev) { return 0; }
-static inline void pm_qos_sysfs_remove(struct device *dev) {}
-
-#endif
Index: linux-pm/drivers/base/power/clock_ops.c
===================================================================
--- linux-pm.orig/drivers/base/power/clock_ops.c
+++ linux-pm/drivers/base/power/clock_ops.c
@@ -256,10 +256,6 @@ void pm_clk_destroy(struct device *dev)
 	}
 }
 
-#endif /* CONFIG_PM */
-
-#ifdef CONFIG_PM_RUNTIME
-
 /**
  * pm_clk_suspend - Disable clocks in a device's PM clock list.
  * @dev: Device to disable the clocks for.
@@ -373,68 +369,7 @@ static int pm_clk_notify(struct notifier
 	return 0;
 }
 
-#else /* !CONFIG_PM_RUNTIME */
-
-#ifdef CONFIG_PM
-
-/**
- * pm_clk_suspend - Disable clocks in a device's PM clock list.
- * @dev: Device to disable the clocks for.
- */
-int pm_clk_suspend(struct device *dev)
-{
-	struct pm_subsys_data *psd = dev_to_psd(dev);
-	struct pm_clock_entry *ce;
-	unsigned long flags;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	/* If there is no driver, the clocks are already disabled. */
-	if (!psd || !dev->driver)
-		return 0;
-
-	spin_lock_irqsave(&psd->lock, flags);
-
-	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			if (ce->status == PCE_STATUS_ENABLED)
-				clk_disable(ce->clk);
-			ce->status = PCE_STATUS_ACQUIRED;
-		}
-	}
-
-	spin_unlock_irqrestore(&psd->lock, flags);
-
-	return 0;
-}
-
-/**
- * pm_clk_resume - Enable clocks in a device's PM clock list.
- * @dev: Device to enable the clocks for.
- */
-int pm_clk_resume(struct device *dev)
-{
-	struct pm_subsys_data *psd = dev_to_psd(dev);
-	struct pm_clock_entry *ce;
-	unsigned long flags;
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	/* If there is no driver, the clocks should remain disabled. */
-	if (!psd || !dev->driver)
-		return 0;
-
-	spin_lock_irqsave(&psd->lock, flags);
-
-	list_for_each_entry(ce, &psd->clock_list, node)
-		__pm_clk_enable(dev, ce);
-
-	spin_unlock_irqrestore(&psd->lock, flags);
-
-	return 0;
-}
-
-#endif /* CONFIG_PM */
+#else /* !CONFIG_PM */
 
 /**
  * enable_clock - Enable a device clock.
@@ -514,7 +449,7 @@ static int pm_clk_notify(struct notifier
 	return 0;
 }
 
-#endif /* !CONFIG_PM_RUNTIME */
+#endif /* !CONFIG_PM */
 
 /**
  * pm_clk_add_notifier - Add bus type notifier for power management clocks.
Index: linux-pm/drivers/base/power/domain.c
===================================================================
--- linux-pm.orig/drivers/base/power/domain.c
+++ linux-pm/drivers/base/power/domain.c
@@ -317,8 +317,6 @@ int pm_genpd_name_poweron(const char *do
 	return genpd ? pm_genpd_poweron(genpd) : -EINVAL;
 }
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int genpd_start_dev_no_timing(struct generic_pm_domain *genpd,
 				     struct device *dev)
 {
@@ -777,24 +775,6 @@ static int __init genpd_poweroff_unused(
 }
 late_initcall(genpd_poweroff_unused);
 
-#else
-
-static inline int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
-					    unsigned long val, void *ptr)
-{
-	return NOTIFY_DONE;
-}
-
-static inline void
-genpd_queue_power_off_work(struct generic_pm_domain *genpd) {}
-
-static inline void genpd_power_off_work_fn(struct work_struct *work) {}
-
-#define pm_genpd_runtime_suspend	NULL
-#define pm_genpd_runtime_resume		NULL
-
-#endif /* CONFIG_PM_RUNTIME */
-
 #ifdef CONFIG_PM_SLEEP
 
 /**
@@ -1383,7 +1363,7 @@ void pm_genpd_syscore_poweron(struct dev
 }
 EXPORT_SYMBOL_GPL(pm_genpd_syscore_poweron);
 
-#else
+#else /* !CONFIG_PM_SLEEP */
 
 #define pm_genpd_prepare		NULL
 #define pm_genpd_suspend		NULL
@@ -2240,7 +2220,7 @@ int genpd_dev_pm_attach(struct device *d
 	return 0;
 }
 EXPORT_SYMBOL_GPL(genpd_dev_pm_attach);
-#endif
+#endif /* CONFIG_PM_GENERIC_DOMAINS_OF */
 
 
 /***        debugfs support        ***/
@@ -2256,10 +2236,8 @@ static struct dentry *pm_genpd_debugfs_d
 
 /*
  * TODO: This function is a slightly modified version of rtpm_status_show
- * from sysfs.c, but dependencies between PM_GENERIC_DOMAINS and PM_RUNTIME
- * are too loose to generalize it.
+ * from sysfs.c, so generalize it.
  */
-#ifdef CONFIG_PM_RUNTIME
 static void rtpm_status_str(struct seq_file *s, struct device *dev)
 {
 	static const char * const status_lookup[] = {
@@ -2281,12 +2259,6 @@ static void rtpm_status_str(struct seq_f
 
 	seq_puts(s, p);
 }
-#else
-static void rtpm_status_str(struct seq_file *s, struct device *dev)
-{
-	seq_puts(s, "active");
-}
-#endif
 
 static int pm_genpd_summary_one(struct seq_file *s,
 		struct generic_pm_domain *gpd)
Index: linux-pm/drivers/base/power/domain_governor.c
===================================================================
--- linux-pm.orig/drivers/base/power/domain_governor.c
+++ linux-pm/drivers/base/power/domain_governor.c
@@ -11,8 +11,6 @@
 #include <linux/pm_qos.h>
 #include <linux/hrtimer.h>
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int dev_update_qos_constraint(struct device *dev, void *data)
 {
 	s64 *constraint_ns_p = data;
@@ -227,15 +225,6 @@ static bool always_on_power_down_ok(stru
 	return false;
 }
 
-#else /* !CONFIG_PM_RUNTIME */
-
-static inline bool default_stop_ok(struct device *dev) { return false; }
-
-#define default_power_down_ok	NULL
-#define always_on_power_down_ok	NULL
-
-#endif /* !CONFIG_PM_RUNTIME */
-
 struct dev_power_governor simple_qos_governor = {
 	.stop_ok = default_stop_ok,
 	.power_down_ok = default_power_down_ok,
Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -599,7 +599,6 @@ int dev_pm_qos_add_ancestor_request(stru
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_ancestor_request);
 
-#ifdef CONFIG_PM_RUNTIME
 static void __dev_pm_qos_drop_user_request(struct device *dev,
 					   enum dev_pm_qos_req_type type)
 {
@@ -880,7 +879,3 @@ int dev_pm_qos_update_user_latency_toler
 	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
 }
-#else /* !CONFIG_PM_RUNTIME */
-static void __dev_pm_qos_hide_latency_limit(struct device *dev) {}
-static void __dev_pm_qos_hide_flags(struct device *dev) {}
-#endif /* CONFIG_PM_RUNTIME */
Index: linux-pm/drivers/base/power/runtime.c
===================================================================
--- linux-pm.orig/drivers/base/power/runtime.c
+++ linux-pm/drivers/base/power/runtime.c
@@ -45,8 +45,6 @@ static pm_callback_t __rpm_get_callback(
 #define RPM_GET_CALLBACK(dev, callback) \
 		__rpm_get_callback(dev, offsetof(struct dev_pm_ops, callback))
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int rpm_resume(struct device *dev, int rpmflags);
 static int rpm_suspend(struct device *dev, int rpmflags);
 
@@ -1399,7 +1397,6 @@ void pm_runtime_remove(struct device *de
 	if (dev->power.irq_safe && dev->parent)
 		pm_runtime_put(dev->parent);
 }
-#endif
 
 /**
  * pm_runtime_force_suspend - Force a device into suspend state if needed.
@@ -1419,12 +1416,6 @@ int pm_runtime_force_suspend(struct devi
 	int ret = 0;
 
 	pm_runtime_disable(dev);
-
-	/*
-	 * Note that pm_runtime_status_suspended() returns false while
-	 * !CONFIG_PM_RUNTIME, which means the device will be put into low
-	 * power state.
-	 */
 	if (pm_runtime_status_suspended(dev))
 		return 0;
 
Index: linux-pm/drivers/base/power/sysfs.c
===================================================================
--- linux-pm.orig/drivers/base/power/sysfs.c
+++ linux-pm/drivers/base/power/sysfs.c
@@ -95,7 +95,6 @@
 const char power_group_name[] = "power";
 EXPORT_SYMBOL_GPL(power_group_name);
 
-#ifdef CONFIG_PM_RUNTIME
 static const char ctrl_auto[] = "auto";
 static const char ctrl_on[] = "on";
 
@@ -330,7 +329,6 @@ static ssize_t pm_qos_remote_wakeup_stor
 
 static DEVICE_ATTR(pm_qos_remote_wakeup, 0644,
 		   pm_qos_remote_wakeup_show, pm_qos_remote_wakeup_store);
-#endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
 static const char _enabled[] = "enabled";
@@ -531,8 +529,6 @@ static DEVICE_ATTR(wakeup_prevent_sleep_
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_ADVANCED_DEBUG
-#ifdef CONFIG_PM_RUNTIME
-
 static ssize_t rtpm_usagecount_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -562,10 +558,7 @@ static DEVICE_ATTR(runtime_usage, 0444,
 static DEVICE_ATTR(runtime_active_kids, 0444, rtpm_children_show, NULL);
 static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show, NULL);
 
-#endif
-
 #ifdef CONFIG_PM_SLEEP
-
 static ssize_t async_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
@@ -595,7 +588,7 @@ static ssize_t async_store(struct device
 
 static DEVICE_ATTR(async, 0644, async_show, async_store);
 
-#endif
+#endif /* CONFIG_PM_SLEEP */
 #endif /* CONFIG_PM_ADVANCED_DEBUG */
 
 static struct attribute *power_attrs[] = {
@@ -603,12 +596,10 @@ static struct attribute *power_attrs[] =
 #ifdef CONFIG_PM_SLEEP
 	&dev_attr_async.attr,
 #endif
-#ifdef CONFIG_PM_RUNTIME
 	&dev_attr_runtime_status.attr,
 	&dev_attr_runtime_usage.attr,
 	&dev_attr_runtime_active_kids.attr,
 	&dev_attr_runtime_enabled.attr,
-#endif
 #endif /* CONFIG_PM_ADVANCED_DEBUG */
 	NULL,
 };
@@ -640,7 +631,6 @@ static struct attribute_group pm_wakeup_
 };
 
 static struct attribute *runtime_attrs[] = {
-#ifdef CONFIG_PM_RUNTIME
 #ifndef CONFIG_PM_ADVANCED_DEBUG
 	&dev_attr_runtime_status.attr,
 #endif
@@ -648,7 +638,6 @@ static struct attribute *runtime_attrs[]
 	&dev_attr_runtime_suspended_time.attr,
 	&dev_attr_runtime_active_time.attr,
 	&dev_attr_autosuspend_delay_ms.attr,
-#endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
 static struct attribute_group pm_runtime_attr_group = {
@@ -657,9 +646,7 @@ static struct attribute_group pm_runtime
 };
 
 static struct attribute *pm_qos_resume_latency_attrs[] = {
-#ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_resume_latency_us.attr,
-#endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
 static struct attribute_group pm_qos_resume_latency_attr_group = {
@@ -668,9 +655,7 @@ static struct attribute_group pm_qos_res
 };
 
 static struct attribute *pm_qos_latency_tolerance_attrs[] = {
-#ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_latency_tolerance_us.attr,
-#endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
 static struct attribute_group pm_qos_latency_tolerance_attr_group = {
@@ -679,10 +664,8 @@ static struct attribute_group pm_qos_lat
 };
 
 static struct attribute *pm_qos_flags_attrs[] = {
-#ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_no_power_off.attr,
 	&dev_attr_pm_qos_remote_wakeup.attr,
-#endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
 static struct attribute_group pm_qos_flags_attr_group = {
Index: linux-pm/include/linux/pm_domain.h
===================================================================
--- linux-pm.orig/include/linux/pm_domain.h
+++ linux-pm/include/linux/pm_domain.h
@@ -152,6 +152,7 @@ extern void pm_genpd_init(struct generic
 
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
 extern int pm_genpd_name_poweron(const char *domain_name);
+extern void pm_genpd_poweroff_unused(void);
 
 extern struct dev_power_governor simple_qos_governor;
 extern struct dev_power_governor pm_domain_always_on_gov;
@@ -226,6 +227,7 @@ static inline int pm_genpd_name_poweron(
 {
 	return -ENOSYS;
 }
+static inline void pm_genpd_poweroff_unused(void) {}
 #define simple_qos_governor NULL
 #define pm_domain_always_on_gov NULL
 #endif
@@ -242,12 +244,6 @@ static inline int pm_genpd_name_add_devi
 	return __pm_genpd_name_add_device(domain_name, dev, NULL);
 }
 
-#ifdef CONFIG_PM_GENERIC_DOMAINS_RUNTIME
-extern void pm_genpd_poweroff_unused(void);
-#else
-static inline void pm_genpd_poweroff_unused(void) {}
-#endif
-
 #ifdef CONFIG_PM_GENERIC_DOMAINS_SLEEP
 extern void pm_genpd_syscore_poweroff(struct device *dev);
 extern void pm_genpd_syscore_poweron(struct device *dev);
Index: linux-pm/kernel/power/Kconfig
===================================================================
--- linux-pm.orig/kernel/power/Kconfig
+++ linux-pm/kernel/power/Kconfig
@@ -298,10 +298,6 @@ config PM_GENERIC_DOMAINS_SLEEP
 	def_bool y
 	depends on PM_SLEEP && PM_GENERIC_DOMAINS
 
-config PM_GENERIC_DOMAINS_RUNTIME
-	def_bool y
-	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
-
 config PM_GENERIC_DOMAINS_OF
 	def_bool y
 	depends on PM_GENERIC_DOMAINS && OF
Index: linux-pm/include/linux/pm_qos.h
===================================================================
--- linux-pm.orig/include/linux/pm_qos.h
+++ linux-pm/include/linux/pm_qos.h
@@ -154,6 +154,23 @@ void dev_pm_qos_constraints_destroy(stru
 int dev_pm_qos_add_ancestor_request(struct device *dev,
 				    struct dev_pm_qos_request *req,
 				    enum dev_pm_qos_req_type type, s32 value);
+int dev_pm_qos_expose_latency_limit(struct device *dev, s32 value);
+void dev_pm_qos_hide_latency_limit(struct device *dev);
+int dev_pm_qos_expose_flags(struct device *dev, s32 value);
+void dev_pm_qos_hide_flags(struct device *dev);
+int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set);
+s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev);
+int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val);
+
+static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev)
+{
+	return dev->power.qos->resume_latency_req->data.pnode.prio;
+}
+
+static inline s32 dev_pm_qos_requested_flags(struct device *dev)
+{
+	return dev->power.qos->flags_req->data.flr.flags;
+}
 #else
 static inline enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev,
 							  s32 mask)
@@ -200,27 +217,6 @@ static inline int dev_pm_qos_add_ancesto
 						  enum dev_pm_qos_req_type type,
 						  s32 value)
 			{ return 0; }
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
-int dev_pm_qos_expose_latency_limit(struct device *dev, s32 value);
-void dev_pm_qos_hide_latency_limit(struct device *dev);
-int dev_pm_qos_expose_flags(struct device *dev, s32 value);
-void dev_pm_qos_hide_flags(struct device *dev);
-int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set);
-s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev);
-int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val);
-
-static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev)
-{
-	return dev->power.qos->resume_latency_req->data.pnode.prio;
-}
-
-static inline s32 dev_pm_qos_requested_flags(struct device *dev)
-{
-	return dev->power.qos->flags_req->data.flr.flags;
-}
-#else
 static inline int dev_pm_qos_expose_latency_limit(struct device *dev, s32 value)
 			{ return 0; }
 static inline void dev_pm_qos_hide_latency_limit(struct device *dev) {}

