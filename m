Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaEPAcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:32:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52147 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752276AbaEPAbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:31:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Fri, 16 May 2014 02:46:50 +0200
Message-ID: <7183958.HCss1mGDD2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1596386.YnYCCm2UQG@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405141041360.1432-100000@iolanthe.rowland.org> <1495375.YeObBhD5SE@vostro.rjw.lan> <1596386.YnYCCm2UQG@vostro.rjw.lan>
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
wakeup settings for system sleep and for runtime PM.

For some devices, though, it's OK to remain in runtime suspend 
throughout a complete system suspend/resume cycle (if the device was in
runtime suspend at the start of the cycle).  We would like to do this
whenever possible, to avoid the overhead of extra power-up and power-down
events.

However, problems may arise because the device's descendants may require
it to be at full power at various points during the cycle.  Therefore the
most straightforward way to do this safely is if the device and all its
descendants can remain runtime suspended until the complete stage of
system resume.

To this end, introduce a new device PM flag, power.direct_complete
and modify the PM core to use that flag as follows.

If the ->prepare() callback of a device returns a positive number,
the PM core will regard that as an indication that it may leave the
device runtime-suspended.  It will then check if the system power
transition in progress is a suspend (and not hibernation in particular)
and if the device is, indeed, runtime-suspended.  In that case, the PM
core will set the device's power.direct_complete flag.  Otherwise it
will clear power.direct_complete for the device and it also will later
clear it for the device's parent (if there's one).

Next, the PM core will not invoke the ->suspend() ->suspend_late(),
->suspend_irq(), ->resume_irq(), ->resume_early(), or ->resume()
callbacks for all devices having power.direct_complete set.  It
will invoke their ->complete() callbacks, however, and those
callbacks are then responsible for resuming the devices as
appropriate, if necessary.  For example, in some cases they may
need to queue up runtime resume requests for the devices using
pm_request_resume().

Changelog partly based on an Alan Stern's description of the idea
(http://marc.info/?l=linux-pm&m=139940466625569&w=2).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c  |   66 ++++++++++++++++++++++++++++++++++-----------
 include/linux/pm.h         |   36 +++++++++++++++++++-----
 include/linux/pm_runtime.h |    6 ++++
 3 files changed, 85 insertions(+), 23 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -93,13 +93,23 @@ typedef struct pm_message {
  *	been registered) to recover from the race condition.
  *	This method is executed for all kinds of suspend transitions and is
  *	followed by one of the suspend callbacks: @suspend(), @freeze(), or
- *	@poweroff().  The PM core executes subsystem-level @prepare() for all
- *	devices before starting to invoke suspend callbacks for any of them, so
- *	generally devices may be assumed to be functional or to respond to
- *	runtime resume requests while @prepare() is being executed.  However,
- *	device drivers may NOT assume anything about the availability of user
- *	space at that time and it is NOT valid to request firmware from within
- *	@prepare() (it's too late to do that).  It also is NOT valid to allocate
+ *	@poweroff().  If the transition is a suspend to memory or standby (that
+ *	is, not related to hibernation), the return value of @prepare() may be
+ *	used to indicate to the PM core to leave the device in runtime suspend
+ *	if applicable.  Namely, if @prepare() returns a positive number, the PM
+ *	core will understand that as a declaration that the device appears to be
+ *	runtime-suspended and it may be left in that state during the entire
+ *	transition and during the subsequent resume if all of its descendants
+ *	are left in runtime suspend too.  If that happens, @complete() will be
+ *	executed directly after @prepare() and it must ensure the proper
+ *	functioning of the device after the system resume.
+ *	The PM core executes subsystem-level @prepare() for all devices before
+ *	starting to invoke suspend callbacks for any of them, so generally
+ *	devices may be assumed to be functional or to respond to runtime resume
+ *	requests while @prepare() is being executed.  However, device drivers
+ *	may NOT assume anything about the availability of user space at that
+ *	time and it is NOT valid to request firmware from within @prepare()
+ *	(it's too late to do that).  It also is NOT valid to allocate
  *	substantial amounts of memory from @prepare() in the GFP_KERNEL mode.
  *	[To work around these limitations, drivers may register suspend and
  *	hibernation notifiers to be executed before the freezing of tasks.]
@@ -112,7 +122,16 @@ typedef struct pm_message {
  *	of the other devices that the PM core has unsuccessfully attempted to
  *	suspend earlier).
  *	The PM core executes subsystem-level @complete() after it has executed
- *	the appropriate resume callbacks for all devices.
+ *	the appropriate resume callbacks for all devices.  If the corresponding
+ *	@prepare() at the beginning of the suspend transition returned a
+ *	positive number and the device was left in runtime suspend (without
+ *	executing any suspend and resume callbacks for it), @complete() will be
+ *	the only callback executed for the device during resume.  In that case,
+ *	@complete() must be prepared to do whatever is necessary to ensure the
+ *	proper functioning of the device after the system resume.  To this end,
+ *	@complete() can check the power.direct_complete flag of the device to
+ *	learn whether (unset) or not (set) the previous suspend and resume
+ *	callbacks have been executed for it.
  *
  * @suspend: Executed before putting the system into a sleep state in which the
  *	contents of main memory are preserved.  The exact action to perform
@@ -546,6 +565,7 @@ struct dev_pm_info {
 	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			direct_complete:1;	/* Owned by the PM core */
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -479,7 +479,7 @@ static int device_resume_noirq(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.direct_complete)
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -605,7 +605,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.direct_complete)
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -735,6 +735,12 @@ static int device_resume(struct device *
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.direct_complete) {
+		/* Match the pm_runtime_disable() in __device_suspend(). */
+		pm_runtime_enable(dev);
+		goto Complete;
+	}
+
 	dpm_wait(dev->parent, async);
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
@@ -1007,7 +1013,7 @@ static int __device_suspend_noirq(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.direct_complete)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1146,7 +1152,7 @@ static int __device_suspend_late(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.direct_complete)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1332,6 +1338,17 @@ static int __device_suspend(struct devic
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.direct_complete) {
+		if (pm_runtime_status_suspended(dev)) {
+			pm_runtime_disable(dev);
+			if (pm_runtime_suspended_if_enabled(dev))
+				goto Complete;
+
+			pm_runtime_enable(dev);
+		}
+		dev->power.direct_complete = false;
+	}
+
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
 
@@ -1382,10 +1399,19 @@ static int __device_suspend(struct devic
 
  End:
 	if (!error) {
+		struct device *parent = dev->parent;
+
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path
-		    && dev->parent && !dev->parent->power.ignore_children)
-			dev->parent->power.wakeup_path = true;
+		if (parent) {
+			spin_lock_irq(&parent->power.lock);
+
+			dev->parent->power.direct_complete = false;
+			if (dev->power.wakeup_path
+			    && !dev->parent->power.ignore_children)
+				dev->parent->power.wakeup_path = true;
+
+			spin_unlock_irq(&parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1487,7 +1513,7 @@ static int device_prepare(struct device
 {
 	int (*callback)(struct device *) = NULL;
 	char *info = NULL;
-	int error = 0;
+	int ret = 0;
 
 	if (dev->power.syscore)
 		return 0;
@@ -1523,17 +1549,27 @@ static int device_prepare(struct device
 		callback = dev->driver->pm->prepare;
 	}
 
-	if (callback) {
-		error = callback(dev);
-		suspend_report_result(callback, error);
-	}
+	if (callback)
+		ret = callback(dev);
 
 	device_unlock(dev);
 
-	if (error)
+	if (ret < 0) {
+		suspend_report_result(callback, ret);
 		pm_runtime_put(dev);
-
-	return error;
+		return ret;
+	}
+	/*
+	 * A positive return value from ->prepare() means "this device appears
+	 * to be runtime-suspended and its state is fine, so if it really is
+	 * runtime-suspended, you can leave it in that state provided that you
+	 * will do the same thing with all of its descendants".  This only
+	 * applies to suspend transitions, however.
+	 */
+	spin_lock_irq(&dev->power.lock);
+	dev->power.direct_complete = ret > 0 && state.event == PM_EVENT_SUSPEND;
+	spin_unlock_irq(&dev->power.lock);
+	return 0;
 }
 
 /**
Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -101,6 +101,11 @@ static inline bool pm_runtime_status_sus
 	return dev->power.runtime_status == RPM_SUSPENDED;
 }
 
+static inline bool pm_runtime_suspended_if_enabled(struct device *dev)
+{
+	return pm_runtime_status_suspended(dev) && dev->power.disable_depth == 1;
+}
+
 static inline bool pm_runtime_enabled(struct device *dev)
 {
 	return !dev->power.disable_depth;
@@ -150,6 +155,7 @@ static inline void device_set_run_wake(s
 static inline bool pm_runtime_suspended(struct device *dev) { return false; }
 static inline bool pm_runtime_active(struct device *dev) { return true; }
 static inline bool pm_runtime_status_suspended(struct device *dev) { return false; }
+static inline bool pm_runtime_suspended_if_enabled(struct device *dev) { return false; }
 static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
 static inline void pm_runtime_no_callbacks(struct device *dev) {}

