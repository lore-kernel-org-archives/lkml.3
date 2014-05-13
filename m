Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaEMVMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:12:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61805 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752935AbaEMVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:12:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Tue, 13 May 2014 23:29:06 +0200
Message-ID: <16671603.abrivY8Odm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405131211080.1098-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405131211080.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 13, 2014 12:19:14 PM Alan Stern wrote:
> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
> 
> > > Maybe the call to __pm_runtime_disable() should be moved from
> > > __device_suspend_late() to __device_suspend(), after the callback has
> > > been invoked (or skipped, as the case may be).  Then after runtime PM
> > > has been disabled, you can check the device's status has changed and go
> > > back to invoke the callback if necessary.
> > 
> > We moved __pm_runtime_disable() to __device_suspend_late() to be able to
> > use pm_runtime_resume() in __device_suspend() (and we actually do that in
> > some places now).
> > 
> > But, in principle, we can do __pm_runtime_disable() temporarily in some place
> > between ->prepare() and ->suspend(), it doesn't matter if that's in
> > device_prepare() in __device_suspend() really.
> 
> It should be as late as possible, to allow for detecting wakeup 
> requests.

I came to the same conclusion.  It has to be done in __device_suspend(), because
a child's ->suspend() may need to resume the parent, so runtime PM for the parent
cannot be disabled when the child's ->suspend() may be running.

> >  Then, we can check the device's
> > runtime PM status (that'd need to be done carefully to take the disabling into
> > account) and
> > (1) if the device is runtime-suspended, set direct_complete for it without
> >     enabling runtime PM, or
> > (2) if the device is not runtime-suspended, clear direct_complete for it
> >     and re-enable runtime PM.
> > and in case of (1) we would re-enable runtime PM in device_complete().
> > 
> > That should work I suppose?
> 
> Yes; it's similar to what I proposed.  Note that this can be skipped if 
> direct_complete is already clear.

Sure.

> > Of course, question is what ->prepare() is supposed to do then if it needs
> > to check the state of the device before deciding whether or not to return 1.
> > I guess it would need to disable runtime PM around that check too.
> 
> It would be surprising if ->prepare() needed to make any difficult
> checks.  This would imply that the device could have multiple
> runtime-suspend states, some of which are appropriate for system
> suspend while others aren't.  Not impossible, but I wouldn't expect it
> to come up often.

That is the case for every device with ACPI power management in principle. :-)

Please see patch [3/3] for details.

> Besides, as I mentioned before, we never have to worry about status 
> changes.  If one occurs while ->prepare() is running or afterward, it 
> means the device is runtime-resumed and therefore the setting of 
> direct_complete doesn't matter.

That's correct.

OK, I've updated the $subject patch in the meantime and the result is appended
Former patch [1/3] is not necessary any more now and patch [3/3] is still valid.

Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily

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
need to queue up runtime resume requests for the devices with the
help of pm_request_resume().

Changelog partly based on an Alan Stern's description of the idea
(http://marc.info/?l=linux-pm&m=139940466625569&w=2).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   65 +++++++++++++++++++++++++++++++++++-----------
 include/linux/pm.h        |    1 
 2 files changed, 51 insertions(+), 15 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -546,6 +546,7 @@ struct dev_pm_info {
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
@@ -1332,6 +1338,16 @@ static int __device_suspend(struct devic
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.direct_complete) {
+		pm_runtime_disable(dev);
+		if (dev->power.disable_depth == 1
+		    && pm_runtime_status_suspended(dev))
+			goto Complete;
+
+		dev->power.direct_complete = false;
+		pm_runtime_enable(dev);
+	}
+
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
 
@@ -1382,10 +1398,19 @@ static int __device_suspend(struct devic
 
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
@@ -1487,7 +1512,7 @@ static int device_prepare(struct device
 {
 	int (*callback)(struct device *) = NULL;
 	char *info = NULL;
-	int error = 0;
+	int ret = 0;
 
 	if (dev->power.syscore)
 		return 0;
@@ -1523,17 +1548,27 @@ static int device_prepare(struct device
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

