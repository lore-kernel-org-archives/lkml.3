Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaGRWYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:24:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53300 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755400AbaGRWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:24:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] PM / sleep: Move platform suspend operations to separate functions
Date: Sat, 19 Jul 2014 00:42:31 +0200
Message-ID: <7305139.n04xFAvSbJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After the introduction of freeze_ops it makes more sense to move
all of the platform suspend operations to separate functions that
each will do all of the necessary checks and choose the right
callback to execute istead of doing all that in the core code
which makes it generally harder to follow.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This is on top of the master branch of linux-pm.git.

---
 kernel/power/suspend.c |  120 +++++++++++++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 43 deletions(-)

Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -36,12 +36,6 @@ const char *pm_states[PM_SUSPEND_MAX];
 
 static const struct platform_suspend_ops *suspend_ops;
 static const struct platform_freeze_ops *freeze_ops;
-
-static bool need_suspend_ops(suspend_state_t state)
-{
-	return state > PM_SUSPEND_FREEZE;
-}
-
 static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
 static bool suspend_freeze_wake;
 
@@ -139,6 +133,65 @@ int suspend_valid_only_mem(suspend_state
 }
 EXPORT_SYMBOL_GPL(suspend_valid_only_mem);
 
+static bool sleep_state_supported(suspend_state_t state)
+{
+	return state == PM_SUSPEND_FREEZE || (suspend_ops && suspend_ops->enter);
+}
+
+static int platform_suspend_prepare(suspend_state_t state)
+{
+	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare ?
+		suspend_ops->prepare() : 0;
+}
+
+static int platform_suspend_prepare_late(suspend_state_t state)
+{
+	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare_late ?
+		suspend_ops->prepare_late() : 0;
+}
+
+static void platform_suspend_wake(suspend_state_t state)
+{
+	if (state != PM_SUSPEND_FREEZE && suspend_ops->wake)
+		suspend_ops->wake();
+}
+
+static void platform_suspend_finish(suspend_state_t state)
+{
+	if (state != PM_SUSPEND_FREEZE && suspend_ops->finish)
+		suspend_ops->finish();
+}
+
+static int platform_suspend_begin(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->begin)
+		return freeze_ops->begin();
+	else if (suspend_ops->begin)
+		return suspend_ops->begin(state);
+	else
+		return 0;
+}
+
+static void platform_suspend_end(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->end)
+		freeze_ops->end();
+	else if (suspend_ops->end)
+		suspend_ops->end();
+}
+
+static void platform_suspend_recover(suspend_state_t state)
+{
+	if (state != PM_SUSPEND_FREEZE && suspend_ops->recover)
+		suspend_ops->recover();
+}
+
+static bool platform_suspend_again(suspend_state_t state)
+{
+	return state != PM_SUSPEND_FREEZE && suspend_ops->suspend_again ?
+		suspend_ops->suspend_again() : false;
+}
+
 static int suspend_test(int level)
 {
 #ifdef CONFIG_PM_DEBUG
@@ -162,7 +215,7 @@ static int suspend_prepare(suspend_state
 {
 	int error;
 
-	if (need_suspend_ops(state) && (!suspend_ops || !suspend_ops->enter))
+	if (!sleep_state_supported(state))
 		return -EPERM;
 
 	pm_prepare_console();
@@ -208,23 +261,18 @@ static int suspend_enter(suspend_state_t
 {
 	int error;
 
-	if (need_suspend_ops(state) && suspend_ops->prepare) {
-		error = suspend_ops->prepare();
-		if (error)
-			goto Platform_finish;
-	}
+	error = platform_suspend_prepare(state);
+	if (error)
+		goto Platform_finish;
 
 	error = dpm_suspend_end(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Platform_finish;
 	}
-
-	if (need_suspend_ops(state) && suspend_ops->prepare_late) {
-		error = suspend_ops->prepare_late();
-		if (error)
-			goto Platform_wake;
-	}
+	error = platform_suspend_prepare_late(state);
+	if (error)
+		goto Platform_wake;
 
 	if (suspend_test(TEST_PLATFORM))
 		goto Platform_wake;
@@ -272,15 +320,11 @@ static int suspend_enter(suspend_state_t
 	ftrace_start();
 
  Platform_wake:
-	if (need_suspend_ops(state) && suspend_ops->wake)
-		suspend_ops->wake();
-
+	platform_suspend_wake(state);
 	dpm_resume_start(PMSG_RESUME);
 
  Platform_finish:
-	if (need_suspend_ops(state) && suspend_ops->finish)
-		suspend_ops->finish();
-
+	platform_suspend_finish(state);
 	return error;
 }
 
@@ -293,18 +337,13 @@ int suspend_devices_and_enter(suspend_st
 	int error;
 	bool wakeup = false;
 
-	if (need_suspend_ops(state) && !suspend_ops)
+	if (!sleep_state_supported(state))
 		return -ENOSYS;
 
-	if (need_suspend_ops(state) && suspend_ops->begin) {
-		error = suspend_ops->begin(state);
-		if (error)
-			goto Close;
-	} else if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->begin) {
-		error = freeze_ops->begin();
-		if (error)
-			goto Close;
-	}
+	error = platform_suspend_begin(state);
+	if (error)
+		goto Close;
+
 	suspend_console();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
@@ -318,25 +357,20 @@ int suspend_devices_and_enter(suspend_st
 
 	do {
 		error = suspend_enter(state, &wakeup);
-	} while (!error && !wakeup && need_suspend_ops(state)
-		&& suspend_ops->suspend_again && suspend_ops->suspend_again());
+	} while (!error && !wakeup && platform_suspend_again(state));
 
  Resume_devices:
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
 	resume_console();
- Close:
-	if (need_suspend_ops(state) && suspend_ops->end)
-		suspend_ops->end();
-	else if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->end)
-		freeze_ops->end();
 
+ Close:
+	platform_suspend_end(state);
 	return error;
 
  Recover_platform:
-	if (need_suspend_ops(state) && suspend_ops->recover)
-		suspend_ops->recover();
+	platform_suspend_recover(state);
 	goto Resume_devices;
 }
 

