Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaEAXrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:47:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50141 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751760AbaEAXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:47:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
Date: Fri, 02 May 2014 02:04:07 +0200
Message-ID: <5908855.HA1MHrW16u@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1898485.lQeVbtvK4U@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405011613200.881-100000@iolanthe.rowland.org> <2117270.jlg4ZsaoxL@vostro.rjw.lan> <1898485.lQeVbtvK4U@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 01:36:38 AM Rafael J. Wysocki wrote:
> On Friday, May 02, 2014 01:15:14 AM Rafael J. Wysocki wrote:

[cut]

> 
> OK, I guess you mean that the first flag (resume_not_needed) should be introduced
> by one patch and the second one by another, but I'm not sure if that would really
> make any difference.  Both of them are needed anyway and resume_not_needed without
> the other flag wouldn't have any effect.
> 
> Well, perhaps I should make __device_suspend() check that use_runtime_resume is
> only set when resume_not_needed is set too and return an error if that's not
> the case.

Below is an updated patch for further discussion.

I tried to improve the changelog and invent better names for the new flags.

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices

Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
resume all runtime-suspended devices during system suspend, mostly
because those devices may need to be reprogrammed due to different
wakeup settings for system sleep and for runtime PM.  However, at
least in some cases, that isn't really necessary, because the wakeup
settings may not be really different.

The idea here is that subsystems should know whether or not it is
necessary to reprogram a given device during system suspend and they
should be able to tell the PM core about that.  For that reason, add
two new device PM flags, power.may_stay_suspended and
power.leave_runtime_suspended, such that:

 (1) If power.may_stay_suspended is set for the given device and the
     device is runtime-suspended during device_suspend(), it is safe to
     skip the remaining system suspend/resume callbacks for the device
     ("If I'm runtime-suspended, I don't mind it if you leave me like
     that").  This flag is for coordination between child and parent
     devices (that is, parents can only have power.may_stay_suspended
     set if it is set for all of their children).

 (2) If power.leave_runtime_suspended is set for the given device (which
     is valid only if power.may_stay_suspended also is set for it) and the
     device is runtime-suspended in device_suspend_late(), its late/early
     and noirq system suspend/resume callbacks are supposed to be skipped
     and pm_runtime_resume() is supposed to be used for resuming the
     device in device_resume().

Those flags are cleared by the PM core in dpm_prepare() for all
devices.  Next, subsystems (or drivers) are supposed to set
power.may_stay_suspended in their ->prepare() callbacks for devices
whose remaining system suspend/resume callbacks are generally safe to
be skipped if they are runtime-suspended already.  Finally, for each
runtime-suspended device with power.may_stay_suspended set during
device_suspend(), its subsystem (or driver) may set the device's
power.leave_runtime_suspended in its ->suspend() callback without changing
the device's state, in which case the PM core will skip all of the
subsequent system suspend/resume callbacks for it and will resume it
in device_resume() using pm_runtime_resume().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   44 +++++++++++++++++++++++++++++++++++++-------
 include/linux/pm.h        |    2 ++
 2 files changed, 39 insertions(+), 7 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -546,6 +546,8 @@ struct dev_pm_info {
 	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			may_stay_suspended:1;
+	bool			leave_runtime_suspended:1;
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
+	if (dev->power.syscore || dev->power.leave_runtime_suspended)
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -605,7 +605,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.leave_runtime_suspended)
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -735,6 +735,11 @@ static int device_resume(struct device *
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.leave_runtime_suspended) {
+		pm_runtime_resume(dev);
+		goto Complete;
+	}
+
 	dpm_wait(dev->parent, async);
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
@@ -1007,7 +1012,7 @@ static int __device_suspend_noirq(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.leave_runtime_suspended)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1146,7 +1151,7 @@ static int __device_suspend_late(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.leave_runtime_suspended)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1379,13 +1384,36 @@ static int __device_suspend(struct devic
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	if (!error && !dev->power.may_stay_suspended
+	  && dev->power.leave_runtime_suspended)
+		error = -EPROTO;
 
  End:
 	if (!error) {
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path
-		    && dev->parent && !dev->parent->power.ignore_children)
-			dev->parent->power.wakeup_path = true;
+		if (dev->parent) {
+			spin_lock_irq(&dev->parent->power.lock);
+
+			if (dev->power.wakeup_path
+			    && !dev->parent->power.ignore_children)
+				dev->parent->power.wakeup_path = true;
+
+			/*
+			 * Subsystems are supposed to set may_stay_suspended in
+			 * their ->prepare() callbacks for devices whose
+			 * remaining system suspend and resume callbacks are
+			 * generally safe to be skipped if the devices are
+			 * runtime-suspended.
+			 *
+			 * If the device's may_stay_suspended is not set at this
+			 * point, it has to be cleared for its parent too (even
+			 * if the subsystem has set that flag for it).
+			 */
+			if (!dev->power.may_stay_suspended)
+				dev->parent->power.may_stay_suspended = false;
+
+			spin_unlock_irq(&dev->parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1553,6 +1581,8 @@ int dpm_prepare(pm_message_t state)
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
+		dev->power.leave_runtime_suspended = false;
+		dev->power.may_stay_suspended = false;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);

