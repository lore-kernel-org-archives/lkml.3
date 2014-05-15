Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaEOVNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:13:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64496 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753506AbaEOVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:13:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Hold ACPI scan lock over the "freeze" sleep state
Date: Thu, 15 May 2014 23:29:57 +0200
Message-ID: <9592270.SopCIMyJ0g@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The "freeze" sleep state suffers from the same issue that was
addressed by commit ad07277e82de (ACPI / PM: Hold acpi_scan_lock over
system PM transitions) for ACPI sleep states, that is, things break
if ->remove() is called for devices whose system resume callbacks
haven't been executed yet.

It also can be addressed in the same way, by holding the ACPI scan
lock over the "freeze" sleep state and PM transitions to and from
that state, but ->begin() and ->end() platform operations for the
"freeze" sleep state are needed for this purpose.

This change has been tested on Acer Aspire S5 with Thunderbolt.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/sleep.c    |   18 ++++++++++++++++++
 include/linux/suspend.h |    7 +++++++
 kernel/power/suspend.c  |   15 +++++++++++++++
 3 files changed, 40 insertions(+)

Index: linux-pm/include/linux/suspend.h
===================================================================
--- linux-pm.orig/include/linux/suspend.h
+++ linux-pm/include/linux/suspend.h
@@ -187,6 +187,11 @@ struct platform_suspend_ops {
 	void (*recover)(void);
 };
 
+struct platform_freeze_ops {
+	int (*begin)(void);
+	void (*end)(void);
+};
+
 #ifdef CONFIG_SUSPEND
 /**
  * suspend_set_ops - set platform dependent suspend operations
@@ -194,6 +199,7 @@ struct platform_suspend_ops {
  */
 extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
+extern void freeze_set_ops(const struct platform_freeze_ops *ops);
 extern void freeze_wake(void);
 
 /**
@@ -220,6 +226,7 @@ extern int pm_suspend(suspend_state_t st
 
 static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
+static inline void freeze_set_ops(const struct platform_freeze_ops *ops) {}
 static inline void freeze_wake(void) {}
 #endif /* !CONFIG_SUSPEND */
 
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -38,6 +38,7 @@ const char *const pm_states[PM_SUSPEND_M
 };
 
 static const struct platform_suspend_ops *suspend_ops;
+static const struct platform_freeze_ops *freeze_ops;
 
 static bool need_suspend_ops(suspend_state_t state)
 {
@@ -47,6 +48,13 @@ static bool need_suspend_ops(suspend_sta
 static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
 static bool suspend_freeze_wake;
 
+void freeze_set_ops(const struct platform_freeze_ops *ops)
+{
+	lock_system_sleep();
+	freeze_ops = ops;
+	unlock_system_sleep();
+}
+
 static void freeze_begin(void)
 {
 	suspend_freeze_wake = false;
@@ -271,6 +279,10 @@ int suspend_devices_and_enter(suspend_st
 		error = suspend_ops->begin(state);
 		if (error)
 			goto Close;
+	} else if (state == PM_SUSPEND_FREEZE && freeze_ops->begin) {
+		error = freeze_ops->begin();
+		if (error)
+			goto Close;
 	}
 	suspend_console();
 	suspend_test_start();
@@ -296,6 +308,9 @@ int suspend_devices_and_enter(suspend_st
  Close:
 	if (need_suspend_ops(state) && suspend_ops->end)
 		suspend_ops->end();
+	else if (state == PM_SUSPEND_FREEZE && freeze_ops->end)
+		freeze_ops->end();
+
 	trace_machine_suspend(PWR_EVENT_EXIT);
 	return error;
 
Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -611,6 +611,22 @@ static const struct platform_suspend_ops
 	.recover = acpi_pm_finish,
 };
 
+static int acpi_freeze_begin(void)
+{
+	acpi_scan_lock_acquire();
+	return 0;
+}
+
+static void acpi_freeze_end(void)
+{
+	acpi_scan_lock_release();
+}
+
+static const struct platform_freeze_ops acpi_freeze_ops = {
+	.begin = acpi_freeze_begin,
+	.end = acpi_freeze_end,
+};
+
 static void acpi_sleep_suspend_setup(void)
 {
 	int i;
@@ -621,7 +637,9 @@ static void acpi_sleep_suspend_setup(voi
 
 	suspend_set_ops(old_suspend_ordering ?
 		&acpi_suspend_ops_old : &acpi_suspend_ops);
+	freeze_set_ops(&acpi_freeze_ops);
 }
+
 #else /* !CONFIG_SUSPEND */
 static inline void acpi_sleep_suspend_setup(void) {}
 #endif /* !CONFIG_SUSPEND */

