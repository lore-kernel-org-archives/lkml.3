Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaBPXjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:39:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63703 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752883AbaBPXij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:38:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Mon, 17 Feb 2014 00:50:39 +0100
Message-ID: <21442757.ztmIxNHa8O@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1829141.MEZji1aIKp@vostro.rjw.lan>
References: <5420830.W4laSGaAU9@vostro.rjw.lan> <1829141.MEZji1aIKp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
resume all runtime-suspended devices during system suspend, mostly
because those devices may need to be reprogrammed due to different
wakeup settings for system sleep and for runtime PM.  However, at
least in some cases, that isn't really necessary, because the wakeup
settings may not be really different.

The idea here is that subsystems should know whether or not it is
necessary to reprogram a given device during system suspend and they
should be able to tell the PM core about that.  For this reason,
modify the PM core so that if the .prepare() callback returns a
positive value for certain device, the core will set a new
power.fast_suspend flag for it.  Then, if that flag is set, the core
will skip all of the subsequent suspend callbacks for that device.
It also will skip all of the system resume callbacks for the device
during the subsequent system resume and pm_request_resume() will be
executed to trigger a runtime PM resume of the device after the
system device resume sequence has been finished.

However, since parents may need to be resumed so that their children
can be reprogrammed, make the PM core clear power.fast_suspend for
devices whose children don't have power.fast_suspend set (the
power.ignore_children flag doesn't matter here, because a parent
whose children are normally ignored for runtime PM may still need to
be accessible for their children to be prepare for system suspend
properly).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   49 +++++++++++++++++++++++++++++++---------------
 include/linux/pm.h        |    1 
 2 files changed, 35 insertions(+), 15 deletions(-)

Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -478,7 +478,7 @@ static int device_resume_noirq(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.fast_suspend)
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -599,7 +599,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.fast_suspend)
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -724,6 +724,11 @@ static int device_resume(struct device *
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.fast_suspend) {
+		pm_request_resume(dev);
+		goto Complete;
+	}
+
 	dpm_wait(dev->parent, async);
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
@@ -994,7 +999,7 @@ static int __device_suspend_noirq(struct
 		return async_error;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.fast_suspend)
 		return 0;
 
 	if (dev->pm_domain) {
@@ -1127,7 +1132,7 @@ static int __device_suspend_late(struct
 		return async_error;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.fast_suspend)
 		return 0;
 
 	if (dev->pm_domain) {
@@ -1296,8 +1301,10 @@ static int __device_suspend(struct devic
 	 * for it, this is equivalent to the device signaling wakeup, so the
 	 * system suspend operation should be aborted.
 	 */
-	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+	if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
 		pm_wakeup_event(dev, 0);
+		dev->power.fast_suspend = false;
+	}
 
 	if (pm_wakeup_pending()) {
 		async_error = -EBUSY;
@@ -1310,6 +1317,9 @@ static int __device_suspend(struct devic
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
 
+	if (dev->power.fast_suspend)
+		goto End;
+
 	if (dev->pm_domain) {
 		info = "power domain ";
 		callback = pm_op(&dev->pm_domain->ops, state);
@@ -1358,9 +1368,14 @@ static int __device_suspend(struct devic
  End:
 	if (!error) {
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path
-		    && dev->parent && !dev->parent->power.ignore_children)
-			dev->parent->power.wakeup_path = true;
+		if (dev->parent) {
+			if (!dev->parent->power.ignore_children
+			    && dev->power.wakeup_path)
+				dev->parent->power.wakeup_path = true;
+
+			if (!dev->power.fast_suspend)
+				dev->parent->power.fast_suspend = false;
+		}
 	}
 
 	device_unlock(dev);
@@ -1460,7 +1475,7 @@ static int device_prepare(struct device
 {
 	int (*callback)(struct device *) = NULL;
 	char *info = NULL;
-	int error = 0;
+	int ret = 0;
 
 	if (dev->power.syscore)
 		return 0;
@@ -1476,6 +1491,7 @@ static int device_prepare(struct device
 	device_lock(dev);
 
 	dev->power.wakeup_path = device_may_wakeup(dev);
+	dev->power.fast_suspend = false;
 
 	if (dev->pm_domain) {
 		info = "preparing power domain ";
@@ -1497,16 +1513,19 @@ static int device_prepare(struct device
 	}
 
 	if (callback) {
-		error = callback(dev);
-		suspend_report_result(callback, error);
+		ret = callback(dev);
+		suspend_report_result(callback, ret);
 	}
 
 	device_unlock(dev);
 
-	if (error)
+	if (ret < 0) {
 		pm_runtime_put(dev);
-
-	return error;
+		return ret;
+	} else if (ret > 0) {
+		dev->power.fast_suspend = true;
+	}
+	return 0;
 }
 
 /**
@@ -1575,7 +1594,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_start);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
-	if (ret)
+	if (ret < 0)
 		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -546,6 +546,7 @@ struct dev_pm_info {
 	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			fast_suspend:1;	/* Owned by the PM core */
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;

