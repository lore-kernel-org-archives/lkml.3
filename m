Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3IYWdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:33:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56184 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IYWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:33:14 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCHv4] drivers: power: Detect device suspend/resume lockup and log event in pstore.
Date: Wed, 25 Sep 2013 15:31:53 -0700
Message-Id: <1380148313-763-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Goby <benoit@android.com>

Rather than hard-lock the kernel, dump the suspend/resume thread stack and
panic() to capture a message in pstore when a driver takes too long to
suspend/resume. Default suspend/resume watchdog timeout is set to 12
seconds to be longer than the usbhid 10 second timeout, but could be
changed at compile time.

Exclude from the watchdog the time spent waiting for children that
are resumed asynchronously and time every device, whether or not they
resumed synchronously.

This patch is targeted for mobile devices where a suspend/resume lockup
could cause a system reboot. Information about failing device can be
retrieved in subsequent boot session by mounting pstore and inspecting
the log. Laptops with EFI-enabled pstore could also benefit from
this feature.

The hardware watchdog timer is likely suspended during this time and
couldn't be relied upon. The soft-lockup detector would eventually tell
that tasks are not scheduled, but would provide little context as to why.
The patch hence uses system timer and assumes it is still active while the
devices are suspended/resumed.

This feature can be enabled/disabled during kernel configuration.

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
Original-author: San Mehat <san@google.com>
Signed-off-by: Benoit Goby <benoit@android.com>
[zoran.markovic@linaro.org: Changed printk(KERN_EMERG,...) to pr_emerg(...),
tweaked commit message. Moved call to dpm_wd_set() before device_lock() in
device_resume(). Minor changes to add compile-time inclusion of the feature.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/base/power/main.c |   68 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig      |   16 +++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9f098a8..9b7e6b6 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -30,6 +30,8 @@
 #include <linux/suspend.h>
 #include <trace/events/power.h>
 #include <linux/cpuidle.h>
+#include <linux/timer.h>
+
 #include "../base.h"
 #include "power.h"
 
@@ -55,6 +57,12 @@ struct suspend_stats suspend_stats;
 static DEFINE_MUTEX(dpm_list_mtx);
 static pm_message_t pm_transition;
 
+struct dpm_watchdog {
+	struct device		*dev;
+	struct task_struct	*tsk;
+	struct timer_list	timer;
+};
+
 static int async_error;
 
 static char *pm_verb(int event)
@@ -390,6 +398,60 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 	return error;
 }
 
+#ifdef CONFIG_DPM_WD
+/**
+ * dpm_wd_handler - Driver suspend / resume watchdog handler.
+ *
+ * Called when a driver has timed out suspending or resuming.
+ * There's not much we can do here to recover so panic() to
+ * capture a crash-dump in pstore.
+ */
+static void dpm_wd_handler(unsigned long data)
+{
+	struct dpm_watchdog *wd = (void *)data;
+
+	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
+	show_stack(wd->tsk, NULL);
+	panic("%s %s: unrecoverable failure\n",
+		dev_driver_string(wd->dev), dev_name(wd->dev));
+}
+
+/**
+ * dpm_wd_set - Enable pm watchdog for given device.
+ * @wd: Watchdog. Must be allocated on the stack.
+ * @dev: Device to handle.
+ */
+static void dpm_wd_set(struct dpm_watchdog *wd, struct device *dev)
+{
+	struct timer_list *timer = &wd->timer;
+
+	wd->dev = dev;
+	wd->tsk = get_current();
+
+	init_timer_on_stack(timer);
+	/* use same timeout value for both suspend and resume */
+	timer->expires = jiffies + HZ * CONFIG_DPM_WD_TIMEOUT;
+	timer->function = dpm_wd_handler;
+	timer->data = (unsigned long)wd;
+	add_timer(timer);
+}
+
+/**
+ * dpm_wd_clear - Disable suspend/resume watchdog.
+ * @wd: Watchdog to disable.
+ */
+static void dpm_wd_clear(struct dpm_watchdog *wd)
+{
+	struct timer_list *timer = &wd->timer;
+
+	del_timer_sync(timer);
+	destroy_timer_on_stack(timer);
+}
+#else
+#define dpm_wd_set(x, y)
+#define dpm_wd_clear(x)
+#endif
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -576,6 +638,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 	int error = 0;
+	struct dpm_watchdog wd;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
@@ -584,6 +647,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 		goto Complete;
 
 	dpm_wait(dev->parent, async);
+	dpm_wd_set(&wd, dev);
 	device_lock(dev);
 
 	/*
@@ -642,6 +706,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 
  Unlock:
 	device_unlock(dev);
+	dpm_wd_clear(&wd);
 
  Complete:
 	complete_all(&dev->power.completion);
@@ -1060,6 +1125,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 	int error = 0;
+	struct dpm_watchdog wd;
 
 	dpm_wait_for_children(dev, async);
 
@@ -1083,6 +1149,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	if (dev->power.syscore)
 		goto Complete;
 
+	dpm_wd_set(&wd, dev);
 	device_lock(dev);
 
 	if (dev->pm_domain) {
@@ -1139,6 +1206,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	}
 
 	device_unlock(dev);
+	dpm_wd_clear(&wd);
 
  Complete:
 	complete_all(&dev->power.completion);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index d444c4e..6a6b763 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -178,6 +178,22 @@ config PM_SLEEP_DEBUG
 	def_bool y
 	depends on PM_DEBUG && PM_SLEEP
 
+config DPM_WD
+	bool "Device suspend/resume watchdog"
+	depends on PM_DEBUG && PSTORE
+	---help---
+	  Sets up a watchdog timer to capture drivers that are
+	  locked up attempting to suspend/resume a device.
+	  A detected lockup causes system panic with message
+	  captured in pstore device for inspection in subsequent
+	  boot session.
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

