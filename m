Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaIDAGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:06:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39694 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaIDAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:06:30 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: "Rafael J. Wysocki\"" <rjw@rjwysocki.net>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] PM / sleep: add configurable delay for pm_test
Date: Wed,  3 Sep 2014 16:55:35 -0700
Message-Id: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM_DEBUG=y, we provide a sysfs file (/sys/power/pm_test) for
selecting one of a few suspend test modes, where rather than entering a
full suspend state, the kernel will perform some subset of suspend
steps, wait 5 seconds, and then resume back to normal operation.

This mode is useful for (among other things) observing the state of the
system just before entering a sleep mode, for debugging or analysis
purposes. However, a constant 5 second wait is not sufficient for some
sorts of analysis; for example, on an SoC, one might want to use
external tools to probe the power states of various on-chip controllers
or clocks.

This patch adds a companion sysfs file (/sys/power/pm_test_delay) that
allows user-space to configure how long the system waits in this test
state before resuming. It also updates the PM debugging documentation to
mention the new file.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 Documentation/power/basic-pm-debugging.txt | 14 ++++++++------
 kernel/power/main.c                        | 27 +++++++++++++++++++++++++++
 kernel/power/power.h                       |  5 +++++
 kernel/power/suspend.c                     |  8 ++++++--
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
index edeecd447d23..bd9f27ae99fe 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
@@ -75,12 +75,14 @@ you should do the following:
 # echo platform > /sys/power/disk
 # echo disk > /sys/power/state
 
-Then, the kernel will try to freeze processes, suspend devices, wait 5 seconds,
-resume devices and thaw processes.  If "platform" is written to
-/sys/power/pm_test , then after suspending devices the kernel will additionally
-invoke the global control methods (eg. ACPI global control methods) used to
-prepare the platform firmware for hibernation.  Next, it will wait 5 seconds and
-invoke the platform (eg. ACPI) global methods used to cancel hibernation etc.
+Then, the kernel will try to freeze processes, suspend devices, wait a few
+seconds (5 by default, but configurable via /sys/power/pm_test_delay), resume
+devices and thaw processes.  If "platform" is written to /sys/power/pm_test,
+then after suspending devices the kernel will additionally invoke the global
+control methods (eg. ACPI global control methods) used to prepare the platform
+firmware for hibernation.  Next, it will wait a configurable number of seconds
+and invoke the platform (eg. ACPI) global methods used to cancel hibernation
+etc.
 
 Writing "none" to /sys/power/pm_test causes the kernel to switch to the normal
 hibernation/suspend operations.  Also, when open for reading, /sys/power/pm_test
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 9a59d042ea84..4d242c8b43a0 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -73,6 +73,7 @@ power_attr(pm_async);
 
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
+int pm_test_seconds = PM_TEST_DELAY_DEFAULT;
 
 static const char * const pm_tests[__TEST_AFTER_LAST] = {
 	[TEST_NONE] = "none",
@@ -132,6 +133,31 @@ static ssize_t pm_test_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 
 power_attr(pm_test);
+
+static ssize_t pm_test_delay_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", pm_test_seconds);
+}
+
+static ssize_t pm_test_delay_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	int val;
+
+	if (kstrtoint(buf, 10, &val))
+		return -EINVAL;
+
+	if (val < 0)
+		return -EINVAL;
+
+	pm_test_seconds = val;
+
+	return n;
+}
+
+power_attr(pm_test_delay);
 #endif /* CONFIG_PM_DEBUG */
 
 #ifdef CONFIG_DEBUG_FS
@@ -601,6 +627,7 @@ static struct attribute * g[] = {
 #endif
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
+	&pm_test_delay_attr.attr,
 #endif
 #ifdef CONFIG_PM_SLEEP_DEBUG
 	&pm_print_times_attr.attr,
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 5d49dcac2537..28111795da71 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -230,6 +230,11 @@ enum {
 
 extern int pm_test_level;
 
+/* Default to 5 second delay */
+#define PM_TEST_DELAY_DEFAULT		5
+
+extern int pm_test_seconds;
+
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6dadb25cb0d8..2372a99d4356 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -196,8 +196,12 @@ static int suspend_test(int level)
 {
 #ifdef CONFIG_PM_DEBUG
 	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
+		int i;
+
+		pr_info("suspend debug: waiting for %d second(s)\n",
+				pm_test_seconds);
+		for (i = 0; i < pm_test_seconds; i++)
+			mdelay(1000);
 		return 1;
 	}
 #endif /* !CONFIG_PM_DEBUG */
-- 
1.9.1

