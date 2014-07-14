Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaGNUS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:18:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51692 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754870AbaGNUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:18:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / sleep: Simplify sleep states sysfs interface code
Date: Mon, 14 Jul 2014 22:37:07 +0200
Message-ID: <1643406.eWpK0Q1mYZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Simplify the sleep states sysfs interface /sys/power/state code by
redefining pm_states[] as an array of pointers to constant strings
such that only the entries corresponding to valid states are set.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/main.c         |   21 +++++++++++----------
 kernel/power/power.h        |    7 +------
 kernel/power/suspend.c      |   34 ++++++++++++++--------------------
 kernel/power/suspend_test.c |   12 ++++++------
 4 files changed, 32 insertions(+), 42 deletions(-)

Index: linux-pm/kernel/power/power.h
===================================================================
--- linux-pm.orig/kernel/power/power.h
+++ linux-pm/kernel/power/power.h
@@ -178,13 +178,8 @@ extern void swsusp_show_speed(struct tim
 				unsigned int, char *);
 
 #ifdef CONFIG_SUSPEND
-struct pm_sleep_state {
-	const char *label;
-	suspend_state_t state;
-};
-
 /* kernel/power/suspend.c */
-extern struct pm_sleep_state pm_states[];
+extern const char *pm_states[];
 
 extern int suspend_devices_and_enter(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -31,11 +31,8 @@
 
 #include "power.h"
 
-struct pm_sleep_state pm_states[PM_SUSPEND_MAX] = {
-	[PM_SUSPEND_FREEZE] = { .label = "freeze", .state = PM_SUSPEND_FREEZE },
-	[PM_SUSPEND_STANDBY] = { .label = "standby", },
-	[PM_SUSPEND_MEM] = { .label = "mem", },
-};
+static const char *pm_labels[] = { "mem", "standby", "freeze", };
+const char *pm_states[PM_SUSPEND_MAX];
 
 static const struct platform_suspend_ops *suspend_ops;
 static const struct platform_freeze_ops *freeze_ops;
@@ -97,10 +94,7 @@ static bool relative_states;
 static int __init sleep_states_setup(char *str)
 {
 	relative_states = !strncmp(str, "1", 1);
-	if (relative_states) {
-		pm_states[PM_SUSPEND_MEM].state = PM_SUSPEND_FREEZE;
-		pm_states[PM_SUSPEND_FREEZE].state = 0;
-	}
+	pm_states[PM_SUSPEND_FREEZE] = pm_labels[relative_states ? 0 : 2];
 	return 1;
 }
 
@@ -113,20 +107,20 @@ __setup("relative_sleep_states=", sleep_
 void suspend_set_ops(const struct platform_suspend_ops *ops)
 {
 	suspend_state_t i;
-	int j = PM_SUSPEND_MAX - 1;
+	int j = 0;
 
 	lock_system_sleep();
 
 	suspend_ops = ops;
 	for (i = PM_SUSPEND_MEM; i >= PM_SUSPEND_STANDBY; i--)
-		if (valid_state(i))
-			pm_states[j--].state = i;
-		else if (!relative_states)
-			pm_states[j--].state = 0;
-
-	pm_states[j--].state = PM_SUSPEND_FREEZE;
-	while (j >= PM_SUSPEND_MIN)
-		pm_states[j--].state = 0;
+		if (valid_state(i)) {
+			pm_states[i] = pm_labels[j++];
+		} else if (!relative_states) {
+			pm_states[i] = NULL;
+			j++;
+		}
+
+	pm_states[PM_SUSPEND_FREEZE] = pm_labels[j];
 
 	unlock_system_sleep();
 }
@@ -395,7 +389,7 @@ static int enter_state(suspend_state_t s
 	printk("done.\n");
 	trace_suspend_resume(TPS("sync_filesystems"), 0, false);
 
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state].label);
+	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	error = suspend_prepare(state);
 	if (error)
 		goto Unlock;
@@ -404,7 +398,7 @@ static int enter_state(suspend_state_t s
 		goto Finish;
 
 	trace_suspend_resume(TPS("suspend_enter"), state, false);
-	pr_debug("PM: Entering %s sleep\n", pm_states[state].label);
+	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
 	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
 	pm_restore_gfp_mask();
Index: linux-pm/kernel/power/main.c
===================================================================
--- linux-pm.orig/kernel/power/main.c
+++ linux-pm/kernel/power/main.c
@@ -296,8 +296,8 @@ static ssize_t state_show(struct kobject
 	suspend_state_t i;
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
-		if (pm_states[i].state)
-			s += sprintf(s,"%s ", pm_states[i].label);
+		if (pm_states[i])
+			s += sprintf(s,"%s ", pm_states[i]);
 
 #endif
 	if (hibernation_available())
@@ -311,8 +311,7 @@ static ssize_t state_show(struct kobject
 static suspend_state_t decode_state(const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
-	suspend_state_t state = PM_SUSPEND_MIN;
-	struct pm_sleep_state *s;
+	suspend_state_t state;
 #endif
 	char *p;
 	int len;
@@ -325,10 +324,12 @@ static suspend_state_t decode_state(cons
 		return PM_SUSPEND_MAX;
 
 #ifdef CONFIG_SUSPEND
-	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
-		if (s->state && len == strlen(s->label)
-		    && !strncmp(buf, s->label, len))
-			return s->state;
+	for (state = PM_SUSPEND_MIN; state < PM_SUSPEND_MAX; state++) {
+		const char *label = pm_states[state];
+
+		if (label && len == strlen(label) && !strncmp(buf, label, len))
+			return state;
+	}
 #endif
 
 	return PM_SUSPEND_ON;
@@ -446,8 +447,8 @@ static ssize_t autosleep_show(struct kob
 
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
-		return sprintf(buf, "%s\n", pm_states[state].state ?
-					pm_states[state].label : "error");
+		return sprintf(buf, "%s\n", pm_states[state] ?
+					pm_states[state] : "error");
 #endif
 #ifdef CONFIG_HIBERNATION
 	return sprintf(buf, "disk\n");
Index: linux-pm/kernel/power/suspend_test.c
===================================================================
--- linux-pm.orig/kernel/power/suspend_test.c
+++ linux-pm/kernel/power/suspend_test.c
@@ -92,13 +92,13 @@ static void __init test_wakealarm(struct
 	}
 
 	if (state == PM_SUSPEND_MEM) {
-		printk(info_test, pm_states[state].label);
+		printk(info_test, pm_states[state]);
 		status = pm_suspend(state);
 		if (status == -ENODEV)
 			state = PM_SUSPEND_STANDBY;
 	}
 	if (state == PM_SUSPEND_STANDBY) {
-		printk(info_test, pm_states[state].label);
+		printk(info_test, pm_states[state]);
 		status = pm_suspend(state);
 	}
 	if (status < 0)
@@ -141,8 +141,8 @@ static int __init setup_test_suspend(cha
 	/* "=mem" ==> "mem" */
 	value++;
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
-		if (!strcmp(pm_states[i].label, value)) {
-			test_state = pm_states[i].state;
+		if (!strcmp(pm_states[i], value)) {
+			test_state = i;
 			return 0;
 		}
 
@@ -162,8 +162,8 @@ static int __init test_suspend(void)
 	/* PM is initialized by now; is that state testable? */
 	if (test_state == PM_SUSPEND_ON)
 		goto done;
-	if (!pm_states[test_state].state) {
-		printk(warn_bad_state, pm_states[test_state].label);
+	if (!pm_states[test_state]) {
+		printk(warn_bad_state, pm_states[test_state]);
 		goto done;
 	}
 

