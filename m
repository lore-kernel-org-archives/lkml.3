Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaJCW2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:28:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaJCW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.10 131/143] PM / sleep: Add state field to pm_states[] entries
Date: Fri,  3 Oct 2014 14:35:26 -0700
Message-Id: <20141003213318.411193358@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 27ddcc6596e50cb8f03d2e83248897667811d8f6 upstream.

To allow sleep states corresponding to the "mem", "standby" and
"freeze" lables to be different from the pm_states[] indexes of
those strings, introduce struct pm_sleep_state, consisting of
a string label and a state number, and turn pm_states[] into an
array of objects of that type.

This modification should not lead to any functional changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/main.c         |   16 ++++++++--------
 kernel/power/power.h        |    7 ++++++-
 kernel/power/suspend.c      |   12 ++++++------
 kernel/power/suspend_test.c |   22 ++++++++++------------
 4 files changed, 30 insertions(+), 27 deletions(-)

--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -293,12 +293,12 @@ static ssize_t state_show(struct kobject
 {
 	char *s = buf;
 #ifdef CONFIG_SUSPEND
-	int i;
+	suspend_state_t i;
+
+	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
+		if (valid_state(i))
+			s += sprintf(s,"%s ", pm_states[i].label);
 
-	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (pm_states[i] && valid_state(i))
-			s += sprintf(s,"%s ", pm_states[i]);
-	}
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
 
@@ -446,7 +446,7 @@ static ssize_t autosleep_show(struct kob
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
 		return sprintf(buf, "%s\n", valid_state(state) ?
-						pm_states[state] : "error");
+					pm_states[state].label : "error");
 #endif
 #ifdef CONFIG_HIBERNATION
 	return sprintf(buf, "disk\n");
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -175,8 +175,13 @@ extern void swsusp_show_speed(struct tim
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
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -29,10 +29,10 @@
 
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
@@ -337,7 +337,7 @@ static int enter_state(suspend_state_t s
 	sys_sync();
 	printk("done.\n");
 
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
+	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state].label);
 	error = suspend_prepare(state);
 	if (error)
 		goto Unlock;
@@ -345,7 +345,7 @@ static int enter_state(suspend_state_t s
 	if (suspend_test(TEST_FREEZER))
 		goto Finish;
 
-	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pr_debug("PM: Entering %s sleep\n", pm_states[state].label);
 	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
 	pm_restore_gfp_mask();
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
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
@@ -136,18 +136,16 @@ static char warn_bad_state[] __initdata
 
 static int __init setup_test_suspend(char *value)
 {
-	unsigned i;
+	suspend_state_t i;
 
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
 


