Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaAWHy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:54:29 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37338 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaAWHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:54:27 -0500
From: Len Brown <lenb@kernel.org>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH v2] suspend: make sync() on suspend-to-RAM optional
Date: Thu, 23 Jan 2014 02:52:17 -0500
Message-Id: <8734cf076bed8f66d1858329233d270111512713.1390463498.git.len.brown@intel.com>
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
De-select CONFIG_PM_SUSPEND_SYNC to delete the call entirely.
or keep CONFIG_PM_SUSPEND_SYNC and you can now clear the
sys/power/suspend_sync attribte to disable the sync
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
index 2fac9cc..61c7bd1 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -102,6 +102,14 @@ config PM_SLEEP_SMP
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
 
+config SUSPEND_SYNC
+	bool "Suspend to RAM starts with in-kernel call to sync()"
+	default y
+	depends on SUSPEND
+	---help---
+	Build a call to sync() into the Linux kernel suspend to RAM flow.
+	The sync can still be skipped by clearing /sys/power/suspend_sync.
+
 config PM_AUTOSLEEP
 	bool "Opportunistic sleep"
 	depends on PM_SLEEP
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1d1bf63..bd7eeeb 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -71,6 +71,36 @@ static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 power_attr(pm_async);
 
+#ifdef CONFIG_SUSPEND_SYNC
+
+/* If set, sync file systems at start of suspend flow */
+int suspend_sync_enabled = 1;
+
+static ssize_t suspend_sync_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", suspend_sync_enabled);
+}
+
+static ssize_t suspend_sync_store(struct kobject *kobj, struct kobj_attribute *attr,
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
+	suspend_sync_enabled = val;
+	return n;
+}
+
+power_attr(suspend_sync);
+
+#endif /* CONFIG_SUSPEND_SYNC */
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -592,6 +622,9 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+#ifdef CONFIG_PM_SLEEP_SYNC
+	&suspend_sync_attr.attr,
+#endif
 #ifdef CONFIG_PM_AUTOSLEEP
 	&autosleep_attr.attr,
 #endif
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d4b7ff..7dd66ff 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -200,6 +200,7 @@ static inline void suspend_test_finish(const char *label) {}
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+extern int suspend_sync_enabled;
 #endif
 
 #ifdef CONFIG_HIGHMEM
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 62ee437..5155cb9 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -333,9 +333,13 @@ static int enter_state(suspend_state_t state)
 	if (state == PM_SUSPEND_FREEZE)
 		freeze_begin();
 
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
-	sys_sync();
-	printk("done.\n");
+#ifdef CONFIG_SUSPEND_SYNC
+	if (suspend_sync_enabled) {
+		printk(KERN_INFO "PM: Syncing filesystems ... ");
+		sys_sync();
+		printk("done.\n");
+	}
+#endif /* CONFIG_SUSPEND_SYNC */
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	error = suspend_prepare(state);
-- 
1.8.3.2

