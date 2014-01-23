Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaAWHN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:13:58 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61982 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:13:56 -0500
From: Len Brown <lenb@kernel.org>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 1/1] suspend: make sync() on suspend-to-RAM optional
Date: Thu, 23 Jan 2014 02:11:03 -0500
Message-Id: <ce1b9fc9cdcfd1fe8f9f3b8570421271dc15ae75.1390460951.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.3.2
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Linux suspend-to-RAM was unreliable when first developed,
and so sys_sync() was invoked inside the kernel at the
start of every suspend flow.

Today, many devices are invoking suspend with
high reliability and high frequency, and they don't
want to be forced to pay for sync on every suspend.

So here we make it optional.
De-select CONFIG_PM_SLEEP_SYNC to delete the call entirely.
or keep CONFIG_PM_SLEEP and you can now clear the
sys/power/sleep_sync attribte to disable the sync
from user-space.

As we have had this call for a long time,
the default remains to keep the call, and to
invoke it on every suspend.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 kernel/power/Kconfig   |  8 ++++++++
 kernel/power/main.c    | 33 +++++++++++++++++++++++++++++++++
 kernel/power/power.h   |  1 +
 kernel/power/suspend.c | 10 +++++++---
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2fac9cc..d2927ce 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -102,6 +102,14 @@ config PM_SLEEP_SMP
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
 
+config PM_SLEEP_SYNC
+	bool "Suspend to RAM starts with in-kernel call to sync()"
+	default y
+	depends on PM_SLEEP
+	---help---
+	Build a call to sync() into the Linux kernel suspend to RAM flow.
+	The sync can still be skipped by clearing /sys/power/sleep_sync.
+
 config PM_AUTOSLEEP
 	bool "Opportunistic sleep"
 	depends on PM_SLEEP
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1d1bf63..1102871 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -71,6 +71,36 @@ static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 power_attr(pm_async);
 
+#ifdef CONFIG_PM_SLEEP_SYNC
+
+/* If set, sync file systems at start of suspend flow */
+int pm_sleep_sync_enabled = 1;
+
+static ssize_t pm_sleep_sync_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", pm_sleep_sync_enabled);
+}
+
+static ssize_t pm_sleep_sync_store(struct kobject *kobj, struct kobj_attribute *attr,
+			      const char *buf, size_t n)
+{
+	unsigned long val;
+
+	if (kstrtoul(buf, 10, &val))
+		return -EINVAL;
+
+	if (val > 1)
+		return -EINVAL;
+
+	pm_sleep_sync_enabled = val;
+	return n;
+}
+
+power_attr(pm_sleep_sync);
+
+#endif /* CONFIG_PM_SLEEP_SYNC */
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -592,6 +622,9 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+#ifdef CONFIG_PM_SLEEP_SYNC
+	&pm_sleep_sync_attr.attr,
+#endif
 #ifdef CONFIG_PM_AUTOSLEEP
 	&autosleep_attr.attr,
 #endif
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d4b7ff..dca60a7 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -200,6 +200,7 @@ static inline void suspend_test_finish(const char *label) {}
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+extern int pm_sleep_sync_enabled;
 #endif
 
 #ifdef CONFIG_HIGHMEM
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 62ee437..2fb2f51 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -333,9 +333,13 @@ static int enter_state(suspend_state_t state)
 	if (state == PM_SUSPEND_FREEZE)
 		freeze_begin();
 
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
-	sys_sync();
-	printk("done.\n");
+#ifdef CONFIG_PM_SLEEP_SYNC
+	if (pm_sleep_sync_enabled) {
+		printk(KERN_INFO "PM: Syncing filesystems ... ");
+		sys_sync();
+		printk("done.\n");
+	}
+#endif /* CONFIG_PM_SLEEP_SYNC */
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	error = suspend_prepare(state);
-- 
1.8.3.2

