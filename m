Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaEVXLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:11:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52211 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753401AbaEVXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:08:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] PM / sleep: Use valid_state() for platform-dependent sleep states only
Date: Fri, 23 May 2014 01:23:26 +0200
Message-ID: <2601919.clnGLsRA6D@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1817539.9KW2IGGbDV@vostro.rjw.lan>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Use the observation that, for platform-dependent sleep states
(PM_SUSPEND_STANDBY, PM_SUSPEND_MEM), a given state is either
always supported or always unsupported and store that information
in pm_states[] instead of calling valid_state() every time we
need to check it.

Also do not use valid_state() for PM_SUSPEND_FREEZE, which is always
valid, and move the pm_test_level validity check for PM_SUSPEND_FREEZE
directly into enter_state().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/main.c         |    9 ++++----
 kernel/power/power.h        |    2 -
 kernel/power/suspend.c      |   46 ++++++++++++++++++++++++--------------------
 kernel/power/suspend_test.c |    2 -
 4 files changed, 32 insertions(+), 27 deletions(-)

Index: linux-pm/kernel/power/main.c
===================================================================
--- linux-pm.orig/kernel/power/main.c
+++ linux-pm/kernel/power/main.c
@@ -296,7 +296,7 @@ static ssize_t state_show(struct kobject
 	int i;
 
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
Index: linux-pm/kernel/power/power.h
===================================================================
--- linux-pm.orig/kernel/power/power.h
+++ linux-pm/kernel/power/power.h
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
Index: linux-pm/kernel/power/suspend_test.c
===================================================================
--- linux-pm.orig/kernel/power/suspend_test.c
+++ linux-pm/kernel/power/suspend_test.c
@@ -162,7 +162,7 @@ static int __init test_suspend(void)
 	/* PM is initialized by now; is that state testable? */
 	if (test_state == PM_SUSPEND_ON)
 		goto done;
-	if (!valid_state(test_state)) {
+	if (!pm_states[test_state].state) {
 		printk(warn_bad_state, pm_states[test_state].label);
 		goto done;
 	}
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -88,30 +88,28 @@ void suspend_set_ops(const struct platfo
 }
 EXPORT_SYMBOL_GPL(suspend_set_ops);
 
-bool valid_state(suspend_state_t state)
+static bool valid_state(suspend_state_t state)
 {
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
 	/*
-	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEMORY states need lowlevel
-	 * support and need to be valid to the lowlevel
+	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEM states need low level
+	 * support and need to be valid to the low level
 	 * implementation, no valid callback implies that none are valid.
 	 */
 	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
 }
 
+static int __init pm_suspend_states_init(void)
+{
+	suspend_state_t i;
+
+	for (i = PM_SUSPEND_STANDBY; i <= PM_SUSPEND_MEM; i++)
+		if (!valid_state(i))
+			pm_states[i].state = 0;
+
+	return 0;
+}
+fs_initcall(pm_suspend_states_init);
+
 /**
  * suspend_valid_only_mem - Generic memory-only valid callback.
  *
@@ -345,9 +343,17 @@ static int enter_state(suspend_state_t s
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
 
