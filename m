Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaEVXJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:09:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58462 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753410AbaEVXI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:08:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] PM / sleep: Add state field to pm_states[] entries
Date: Fri, 23 May 2014 01:22:24 +0200
Message-ID: <2258749.vsRvoZXRiE@vostro.rjw.lan>
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

To allow sleep states corresponding to the "mem", "standby" and
"freeze" lables to be different from the pm_states[] indexes of
those strings, introduce struct pm_sleep_state, consisting of
a string label and a state number, and turn pm_states[] into an
array of objects of that type.

This modification should not lead to any functional changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/main.c         |   14 +++++++-------
 kernel/power/power.h        |    7 ++++++-
 kernel/power/suspend.c      |   12 ++++++------
 kernel/power/suspend_test.c |   20 +++++++++-----------
 4 files changed, 28 insertions(+), 25 deletions(-)

Index: linux-pm/kernel/power/power.h
===================================================================
--- linux-pm.orig/kernel/power/power.h
+++ linux-pm/kernel/power/power.h
@@ -178,8 +178,13 @@ extern void swsusp_show_speed(struct tim
 				unsigned int, char *);
 
 #ifdef CONFIG_SUSPEND
+struct pm_sleep_state {
+	const char *label;
+	suspend_state_t state;
+};
+
 /* kernel/power/suspend.c */
-extern const char *const pm_states[];
+extern struct pm_sleep_state pm_states[];
 
 extern bool valid_state(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -31,10 +31,10 @@
 
 #include "power.h"
 
-const char *const pm_states[PM_SUSPEND_MAX] = {
-	[PM_SUSPEND_FREEZE]	= "freeze",
-	[PM_SUSPEND_STANDBY]	= "standby",
-	[PM_SUSPEND_MEM]	= "mem",
+struct pm_sleep_state pm_states[PM_SUSPEND_MAX] = {
+	[PM_SUSPEND_FREEZE] = { "freeze", PM_SUSPEND_FREEZE },
+	[PM_SUSPEND_STANDBY] = { "standby", PM_SUSPEND_STANDBY },
+	[PM_SUSPEND_MEM] = { "mem", PM_SUSPEND_MEM },
 };
 
 static const struct platform_suspend_ops *suspend_ops;
@@ -358,7 +358,7 @@ static int enter_state(suspend_state_t s
 	sys_sync();
 	printk("done.\n");
 
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
+	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state].label);
 	error = suspend_prepare(state);
 	if (error)
 		goto Unlock;
@@ -366,7 +366,7 @@ static int enter_state(suspend_state_t s
 	if (suspend_test(TEST_FREEZER))
 		goto Finish;
 
-	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pr_debug("PM: Entering %s sleep\n", pm_states[state].label);
 	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
 	pm_restore_gfp_mask();
Index: linux-pm/kernel/power/suspend_test.c
===================================================================
--- linux-pm.orig/kernel/power/suspend_test.c
+++ linux-pm/kernel/power/suspend_test.c
@@ -92,13 +92,13 @@ static void __init test_wakealarm(struct
 	}
 
 	if (state == PM_SUSPEND_MEM) {
-		printk(info_test, pm_states[state]);
+		printk(info_test, pm_states[state].label);
 		status = pm_suspend(state);
 		if (status == -ENODEV)
 			state = PM_SUSPEND_STANDBY;
 	}
 	if (state == PM_SUSPEND_STANDBY) {
-		printk(info_test, pm_states[state]);
+		printk(info_test, pm_states[state].label);
 		status = pm_suspend(state);
 	}
 	if (status < 0)
@@ -140,14 +140,12 @@ static int __init setup_test_suspend(cha
 
 	/* "=mem" ==> "mem" */
 	value++;
-	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (!pm_states[i])
-			continue;
-		if (strcmp(pm_states[i], value) != 0)
-			continue;
-		test_state = (__force suspend_state_t) i;
-		return 0;
-	}
+	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
+		if (!strcmp(pm_states[i].label, value)) {
+			test_state = pm_states[i].state;
+			return 0;
+		}
+
 	printk(warn_bad_state, value);
 	return 0;
 }
@@ -165,7 +163,7 @@ static int __init test_suspend(void)
 	if (test_state == PM_SUSPEND_ON)
 		goto done;
 	if (!valid_state(test_state)) {
-		printk(warn_bad_state, pm_states[test_state]);
+		printk(warn_bad_state, pm_states[test_state].label);
 		goto done;
 	}
 
Index: linux-pm/kernel/power/main.c
===================================================================
--- linux-pm.orig/kernel/power/main.c
+++ linux-pm/kernel/power/main.c
@@ -295,10 +295,10 @@ static ssize_t state_show(struct kobject
 #ifdef CONFIG_SUSPEND
 	int i;
 
-	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (pm_states[i] && valid_state(i))
-			s += sprintf(s,"%s ", pm_states[i]);
-	}
+	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
+		if (valid_state(i))
+			s += sprintf(s,"%s ", pm_states[i].label);
+
 #endif
 #ifdef CONFIG_HIBERNATION
 	s += sprintf(s, "%s\n", "disk");
@@ -314,7 +314,7 @@ static suspend_state_t decode_state(cons
 {
 #ifdef CONFIG_SUSPEND
 	suspend_state_t state = PM_SUSPEND_MIN;
-	const char * const *s;
+	struct pm_sleep_state *s;
 #endif
 	char *p;
 	int len;
@@ -328,7 +328,7 @@ static suspend_state_t decode_state(cons
 
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
-		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
+		if (len == strlen(s->label) && !strncmp(buf, s->label, len))
 			return state;
 #endif
 
@@ -448,7 +448,7 @@ static ssize_t autosleep_show(struct kob
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
 		return sprintf(buf, "%s\n", valid_state(state) ?
-						pm_states[state] : "error");
+					pm_states[state].label : "error");
 #endif
 #ifdef CONFIG_HIBERNATION
 	return sprintf(buf, "disk\n");

