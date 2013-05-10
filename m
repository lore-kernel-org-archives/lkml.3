Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3EJV3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:29:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50872 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3EJV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:29:49 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, Benoit Goby <benoit@android.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCHv2 2/2] PM: compile-time configuration of device suspend/resume watchdogs.
Date: Fri, 10 May 2013 14:28:49 -0700
Message-Id: <1368221329-1841-3-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power management debug option to configure device suspend/resume watchdogs.
Available options are:
  1. Enable/disable the feature.
  2. Select triggered watchdog action between:
        - system panic (default)
        - dump stacktrace
        - log event
  3. Select timeout value for the watchdog(s).

Minor changes were made to watchdog code to accommodate this feature.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Todd Poynor <toddpoynor@google.com>
Cc: San Mehat <san@google.com>
Cc: Benoit Goby <benoit@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/base/power/main.c |   37 ++++++++++++++++++++++++++--------
 kernel/power/Kconfig      |   48 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index a6a02c0..8e0bb33 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -392,6 +392,26 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 	return error;
 }
 
+#ifdef CONFIG_DPM_WD
+/**
+ * dpm_wd_action - recovery from suspend/resume watchdog timeout
+ * @wd: Watchdog. Must be allocated on the stack.
+ */
+#if defined(CONFIG_DPM_WD_ACTION_STACKTRACE)
+static inline void dpm_wd_action(struct dpm_watchdog *wd)
+{
+	show_stack(wd->tsk, NULL);
+}
+#elif defined(CONFIG_DPM_WD_ACTION_PANIC)
+static inline void dpm_wd_action(struct dpm_watchdog *wd)
+{
+	panic("%s: unrecoverable failure\n", dev_name(wd->dev));
+}
+#else /* CONFIG_DPM_WD_ACTION_LOG */
+/* event already logged in dpm_wd_handler() */
+#define dpm_wd_action(x)
+#endif
+
 /**
  * dpm_wd_handler - Driver suspend / resume watchdog handler.
  *
@@ -402,13 +422,9 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 static void dpm_wd_handler(unsigned long data)
 {
 	struct dpm_watchdog *wd = (void *)data;
-	struct device *dev      = wd->dev;
-	struct task_struct *tsk = wd->tsk;
-
-	dev_emerg(dev, "**** DPM device timeout ****\n");
-	show_stack(tsk, NULL);
 
-	BUG();
+	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
+	dpm_wd_action(wd);
 }
 
 /**
@@ -424,14 +440,15 @@ static void dpm_wd_set(struct dpm_watchdog *wd, struct device *dev)
 	wd->tsk = get_current();
 
 	init_timer_on_stack(timer);
-	timer->expires = jiffies + HZ * 12;
+	/* use same timeout value for both suspend and resume */
+	timer->expires = jiffies + HZ * CONFIG_DPM_WD_TIMEOUT;
 	timer->function = dpm_wd_handler;
 	timer->data = (unsigned long)wd;
 	add_timer(timer);
 }
 
 /**
- * dpm_wd_clear - Disable pm watchdog.
+ * dpm_wd_clear - Disable suspend/resume watchdog.
  * @wd: Watchdog to disable.
  */
 static void dpm_wd_clear(struct dpm_watchdog *wd)
@@ -441,6 +458,10 @@ static void dpm_wd_clear(struct dpm_watchdog *wd)
 	del_timer_sync(timer);
 	destroy_timer_on_stack(timer);
 }
+#else
+#define dpm_wd_set(x, y)
+#define dpm_wd_clear(x)
+#endif
 
 /*------------------------- Resume routines -------------------------*/
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index edc8bdd..339caa1 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -179,6 +179,54 @@ config PM_SLEEP_DEBUG
 	def_bool y
 	depends on PM_DEBUG && PM_SLEEP
 
+config DPM_WD
+	bool "Device suspend/resume watchdog"
+	depends on PM_DEBUG
+	---help---
+	  Sets up a watchdog timer to capture drivers that are
+	  locked up attempting to suspend/resume a device.
+	  A detected lockup causes a configurable watchdog action,
+	  such as logging the event, dumping the stack trace or
+	  kernel panic.
+
+choice
+	prompt "Watchdog recovery action"
+	default DPM_WD_ACTION_PANIC
+	depends on DPM_WD
+	---help---
+	  Select recovery action triggered by suspend/resume watchdog.
+
+config DPM_WD_ACTION_PANIC
+	bool "System panic"
+	---help---
+	  When selected, a lockup during device's suspend or
+	  resume would cause a system panic. This would immediately 
+	  capture user's attention. Panic message can be observed in 
+	  subsequent boot session using pstore.
+
+config DPM_WD_ACTION_STACKTRACE
+	bool "Dump stack"
+	---help---
+	  When selected, a lockup during device's suspend or
+	  resume would cause the caller's stack to be
+	  captured in the system log. The stack trace shows
+	  which driver call caused a lockup.
+
+config DPM_WD_ACTION_LOG
+	bool "Log event"
+	---help---
+	  When selected, a lockup during device's suspend or
+	  resume would cause the watchdog timeout event to be
+	  logged in the system log.
+
+endchoice
+
+config DPM_WD_TIMEOUT
+	int "Watchdog timeout in seconds"
+	range 1 120
+	default 12
+	depends on DPM_WD
+
 config PM_TRACE
 	bool
 	help
-- 
1.7.9.5

