Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaIDVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:21:19 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38763 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaIDVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:21:17 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10.y+] PM / sleep: Use valid_state() for platform-dependent sleep states only
Date: Thu,  4 Sep 2014 14:21:05 -0700
Message-Id: <1409865665-5375-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1849024.CHOUso6H2K@vostro.rjw.lan>
References: <1849024.CHOUso6H2K@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[Upstream commit 43e8317b0bba1d6eb85f38a4a233d82d7c20d732]

Use the observation that, for platform-dependent sleep states
(PM_SUSPEND_STANDBY, PM_SUSPEND_MEM), a given state is either
always supported or always unsupported and store that information
in pm_states[] instead of calling valid_state() every time we
need to check it.

Also do not use valid_state() for PM_SUSPEND_FREEZE, which is always
valid, and move the pm_test_level validity check for PM_SUSPEND_FREEZE
directly into enter_state().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@vger.kernel.org> # 3.10+: 27ddcc6596e5: PM / sleep: Add state field to pm_states[] entries
Cc: <stable@vger.kernel.org> # 3.10+
---
This is a backport request for these two commits upstream:

    27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries
    43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only

Rafael ack'd this:

  https://lkml.org/lkml/2014/9/4/543

I've tested these on 3.14, and it looks like they could go back as far as 3.10.

 kernel/power/main.c         |  9 ++++---
 kernel/power/power.h        |  2 --
 kernel/power/suspend.c      | 60 ++++++++++++++++++++++-----------------------
 kernel/power/suspend_test.c |  2 +-
 4 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 8e818432253c..9f51f0ab3d86 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -296,7 +296,7 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 	suspend_state_t i;
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
-		if (valid_state(i))
+		if (pm_states[i].state)
 			s += sprintf(s,"%s ", pm_states[i].label);
 
 #endif
@@ -328,8 +328,9 @@ static suspend_state_t decode_state(const char *buf, size_t n)
 
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
-		if (len == strlen(s->label) && !strncmp(buf, s->label, len))
-			return state;
+		if (s->state && len == strlen(s->label)
+		    && !strncmp(buf, s->label, len))
+			return s->state;
 #endif
 
 	return PM_SUSPEND_ON;
@@ -447,7 +448,7 @@ static ssize_t autosleep_show(struct kobject *kobj,
 
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
-		return sprintf(buf, "%s\n", valid_state(state) ?
+		return sprintf(buf, "%s\n", pm_states[state].state ?
 					pm_states[state].label : "error");
 #endif
 #ifdef CONFIG_HIBERNATION
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 99539c5da844..c60f13b5270a 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -186,14 +186,12 @@ struct pm_sleep_state {
 /* kernel/power/suspend.c */
 extern struct pm_sleep_state pm_states[];
 
-extern bool valid_state(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 static inline int suspend_devices_and_enter(suspend_state_t state)
 {
 	return -ENOSYS;
 }
-static inline bool valid_state(suspend_state_t state) { return false; }
 #endif /* !CONFIG_SUSPEND */
 
 #ifdef CONFIG_PM_TEST_SUSPEND
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 5d93b138a2d4..00aca60904b0 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -32,9 +32,9 @@
 #include "power.h"
 
 struct pm_sleep_state pm_states[PM_SUSPEND_MAX] = {
-	[PM_SUSPEND_FREEZE] = { "freeze", PM_SUSPEND_FREEZE },
-	[PM_SUSPEND_STANDBY] = { "standby", PM_SUSPEND_STANDBY },
-	[PM_SUSPEND_MEM] = { "mem", PM_SUSPEND_MEM },
+	[PM_SUSPEND_FREEZE] = { .label = "freeze", .state = PM_SUSPEND_FREEZE },
+	[PM_SUSPEND_STANDBY] = { .label = "standby", },
+	[PM_SUSPEND_MEM] = { .label = "mem", },
 };
 
 static const struct platform_suspend_ops *suspend_ops;
@@ -68,42 +68,34 @@ void freeze_wake(void)
 }
 EXPORT_SYMBOL_GPL(freeze_wake);
 
+static bool valid_state(suspend_state_t state)
+{
+	/*
+	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEM states need low level
+	 * support and need to be valid to the low level
+	 * implementation, no valid callback implies that none are valid.
+	 */
+	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
+}
+
 /**
  * suspend_set_ops - Set the global suspend method table.
  * @ops: Suspend operations to use.
  */
 void suspend_set_ops(const struct platform_suspend_ops *ops)
 {
+	suspend_state_t i;
+
 	lock_system_sleep();
+
 	suspend_ops = ops;
+	for (i = PM_SUSPEND_STANDBY; i <= PM_SUSPEND_MEM; i++)
+		pm_states[i].state = valid_state(i) ? i : 0;
+
 	unlock_system_sleep();
 }
 EXPORT_SYMBOL_GPL(suspend_set_ops);
 
-bool valid_state(suspend_state_t state)
-{
-	if (state == PM_SUSPEND_FREEZE) {
-#ifdef CONFIG_PM_DEBUG
-		if (pm_test_level != TEST_NONE &&
-		    pm_test_level != TEST_FREEZER &&
-		    pm_test_level != TEST_DEVICES &&
-		    pm_test_level != TEST_PLATFORM) {
-			printk(KERN_WARNING "Unsupported pm_test mode for "
-					"freeze state, please choose "
-					"none/freezer/devices/platform.\n");
-			return false;
-		}
-#endif
-			return true;
-	}
-	/*
-	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEMORY states need lowlevel
-	 * support and need to be valid to the lowlevel
-	 * implementation, no valid callback implies that none are valid.
-	 */
-	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
-}
-
 /**
  * suspend_valid_only_mem - Generic memory-only valid callback.
  *
@@ -330,9 +322,17 @@ static int enter_state(suspend_state_t state)
 {
 	int error;
 
-	if (!valid_state(state))
-		return -ENODEV;
-
+	if (state == PM_SUSPEND_FREEZE) {
+#ifdef CONFIG_PM_DEBUG
+		if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
+			pr_warning("PM: Unsupported test mode for freeze state,"
+				   "please choose none/freezer/devices/platform.\n");
+			return -EAGAIN;
+		}
+#endif
+	} else if (!valid_state(state)) {
+		return -EINVAL;
+	}
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index d4e3ab167a73..269b097e78ea 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -162,7 +162,7 @@ static int __init test_suspend(void)
 	/* PM is initialized by now; is that state testable? */
 	if (test_state == PM_SUSPEND_ON)
 		goto done;
-	if (!valid_state(test_state)) {
+	if (!pm_states[test_state].state) {
 		printk(warn_bad_state, pm_states[test_state].label);
 		goto done;
 	}
-- 
1.9.1

