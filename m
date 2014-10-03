Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbaJCWOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:14:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbaJCWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.14 228/238] PM / sleep: Use valid_state() for platform-dependent sleep states only
Date: Fri,  3 Oct 2014 14:32:23 -0700
Message-Id: <20141003212920.956175510@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 43e8317b0bba1d6eb85f38a4a233d82d7c20d732 upstream.

Use the observation that, for platform-dependent sleep states
(PM_SUSPEND_STANDBY, PM_SUSPEND_MEM), a given state is either
always supported or always unsupported and store that information
in pm_states[] instead of calling valid_state() every time we
need to check it.

Also do not use valid_state() for PM_SUSPEND_FREEZE, which is always
valid, and move the pm_test_level validity check for PM_SUSPEND_FREEZE
directly into enter_state().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/main.c         |    9 +++---
 kernel/power/power.h        |    2 -
 kernel/power/suspend.c      |   60 ++++++++++++++++++++++----------------------
 kernel/power/suspend_test.c |    2 -
 4 files changed, 36 insertions(+), 37 deletions(-)

--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -296,7 +296,7 @@ static ssize_t state_show(struct kobject
 	suspend_state_t i;
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
-		if (valid_state(i))
+		if (pm_states[i].state)
 			s += sprintf(s,"%s ", pm_states[i].label);
 
 #endif
@@ -328,8 +328,9 @@ static suspend_state_t decode_state(cons
 
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
-		if (len == strlen(s->label) && !strncmp(buf, s->label, len))
-			return state;
+		if (s->state && len == strlen(s->label)
+		    && !strncmp(buf, s->label, len))
+			return s->state;
 #endif
 
 	return PM_SUSPEND_ON;
@@ -447,7 +448,7 @@ static ssize_t autosleep_show(struct kob
 
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
-		return sprintf(buf, "%s\n", valid_state(state) ?
+		return sprintf(buf, "%s\n", pm_states[state].state ?
 					pm_states[state].label : "error");
 #endif
 #ifdef CONFIG_HIBERNATION
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -183,14 +183,12 @@ struct pm_sleep_state {
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
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -30,9 +30,9 @@
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
@@ -62,42 +62,34 @@ void freeze_wake(void)
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
@@ -324,9 +316,17 @@ static int enter_state(suspend_state_t s
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


