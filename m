Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab3D3W3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:29:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34549 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab3D3W3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:29:36 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers which lockup during suspend.
Date: Tue, 30 Apr 2013 15:28:33 -0700
Message-Id: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Goby <benoit@android.com>

Below is a patch from android kernel that detects a driver suspend
lockup and captures dump in the kernel log. Please review and provide
comments.

Rather than hard-lock the kernel, dump the suspend thread stack and
BUG() when a driver takes too long to suspend.  The timeout is set to
12 seconds to be longer than the usbhid 10 second timeout.

Exclude from the watchdog the time spent waiting for children that
are resumed asynchronously and time every device, whether or not they
resumed synchronously.

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
tweaked commit message.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/base/power/main.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 15beb50..eb70c0e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -29,6 +29,8 @@
 #include <linux/async.h>
 #include <linux/suspend.h>
 #include <linux/cpuidle.h>
+#include <linux/timer.h>
+
 #include "../base.h"
 #include "power.h"
 
@@ -54,6 +56,12 @@ struct suspend_stats suspend_stats;
 static DEFINE_MUTEX(dpm_list_mtx);
 static pm_message_t pm_transition;
 
+static void dpm_drv_timeout(unsigned long data);
+struct dpm_drv_wd_data {
+	struct device *dev;
+	struct task_struct *tsk;
+};
+
 static int async_error;
 
 /**
@@ -663,6 +671,30 @@ static bool is_async(struct device *dev)
 }
 
 /**
+ *     dpm_drv_timeout - Driver suspend / resume watchdog handler
+ *     @data: struct device which timed out
+ *
+ *     Called when a driver has timed out suspending or resuming.
+ *     There's not much we can do here to recover so
+ *     BUG() out for a crash-dump
+ *
+ */
+static void dpm_drv_timeout(unsigned long data)
+{
+	struct dpm_drv_wd_data *wd_data = (void *)data;
+	struct device *dev = wd_data->dev;
+	struct task_struct *tsk = wd_data->tsk;
+
+	pr_emerg("**** DPM device timeout: %s (%s)\n", dev_name(dev),
+		(dev->driver ? dev->driver->name : "no driver"));
+
+	pr_emerg("dpm suspend stack:\n");
+	show_stack(tsk, NULL);
+
+	BUG();
+}
+
+/**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
  *
@@ -1053,6 +1085,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 	int error = 0;
+	struct timer_list timer;
+	struct dpm_drv_wd_data data;
 
 	dpm_wait_for_children(dev, async);
 
@@ -1076,6 +1110,14 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	if (dev->power.syscore)
 		goto Complete;
 
+	data.dev = dev;
+	data.tsk = get_current();
+	init_timer_on_stack(&timer);
+	timer.expires = jiffies + HZ * 12;
+	timer.function = dpm_drv_timeout;
+	timer.data = (unsigned long)&data;
+	add_timer(&timer);
+
 	device_lock(dev);
 
 	if (dev->pm_domain) {
@@ -1131,6 +1173,9 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 
 	device_unlock(dev);
 
+	del_timer_sync(&timer);
+	destroy_timer_on_stack(&timer);
+
  Complete:
 	complete_all(&dev->power.completion);
 	if (error)
-- 
1.7.9.5

