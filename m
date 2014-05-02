Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaEBPZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:25:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59953 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991AbaEBPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:25:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
Date: Fri, 02 May 2014 17:41:33 +0200
Message-ID: <6199158.2qqefUVTXs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5908855.HA1MHrW16u@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405011613200.881-100000@iolanthe.rowland.org> <1898485.lQeVbtvK4U@vostro.rjw.lan> <5908855.HA1MHrW16u@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 02:04:07 AM Rafael J. Wysocki wrote:
> On Friday, May 02, 2014 01:36:38 AM Rafael J. Wysocki wrote:
> > On Friday, May 02, 2014 01:15:14 AM Rafael J. Wysocki wrote:
> 
> [cut]
> 
> > 
> > OK, I guess you mean that the first flag (resume_not_needed) should be introduced
> > by one patch and the second one by another, but I'm not sure if that would really
> > make any difference.  Both of them are needed anyway and resume_not_needed without
> > the other flag wouldn't have any effect.
> > 
> > Well, perhaps I should make __device_suspend() check that use_runtime_resume is
> > only set when resume_not_needed is set too and return an error if that's not
> > the case.
> 
> Below is an updated patch for further discussion.
> 
> I tried to improve the changelog and invent better names for the new flags.

Well, I have a second update.

It has different flag names and changelog (that should explain things better
hopefully) and the purpose of both flags should be more clear now (patch [3/3]
would need to be reworked on top of this, but for now let's just discuss the
core changes).

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
necessary to resume a given device during system suspend as long as
they know that the device's children will not need it to be functional
during the late/early and noirq phases of their suspend and resume.
To help them with that, introduce two new device PM flags:
power.parent_needed and power.leave_runtime_suspended supposed to work
as follows.

The PM core will clear power.leave_runtime_suspended and will set
power.parent_needed for all devices in dpm_prepare().  Next, the
subsystem (or driver) of a device that in principle may not need
to be resumed during system suspend, if runtume-suspended already,
will set power.leave_runtime_suspended in its ->prepare() callback.
Also the subsystems (or drivers) of devices whose parents need not
be resumed during system suspend, if runtime-suspended already,
are supposed to clear power.parent_needed for them.  The PM core
will then clear power.leave_runtime_suspended for the parents of
all devices having power.parent_needed set in __device_suspend().

Now, if the ->suspend() callback is executed for a device whose
power.leave_runtime_suspended is set, it can simply return 0 after
checking the device's state if that state is appropriate for
system suspend.  The PM core will then skip the late/early and
noirq system suspend/resume callbacks for that device and will
use pm_runtime_resume() to resume it in device_resume().

If the state of a device with power.leave_runtime_suspended is not
appropriate for system suspend, the ->suspend() callback should
resume it using pm_runtime_resume() and clear
power.leave_runtime_suspended for it.

Note: Drivers (or bus types etc.) can reasonably expect that the
next PM callback executed after ->runtime_suspend() will be
->runtime_resume() rather than ->resume_noirq() or ->resume_early().
This change is designed with that expectation in mind.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   33 ++++++++++++++++++++++++++-------
 include/linux/pm.h        |    2 ++
 2 files changed, 28 insertions(+), 7 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -546,6 +546,8 @@ struct dev_pm_info {
 	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			parent_needed:1;
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
@@ -1383,9 +1388,21 @@ static int __device_suspend(struct devic
  End:
 	if (!error) {
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path
-		    && dev->parent && !dev->parent->power.ignore_children)
-			dev->parent->power.wakeup_path = true;
+		if (dev->power.leave_runtime_suspended)
+			dev->power.parent_needed = false;
+
+		if (dev->parent) {
+			spin_lock_irq(&dev->parent->power.lock);
+
+			if (dev->power.wakeup_path
+			    && !dev->parent->power.ignore_children)
+				dev->parent->power.wakeup_path = true;
+
+			if (dev->power.parent_needed)
+				dev->parent->power.leave_runtime_suspended = false;
+
+			spin_unlock_irq(&dev->parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1553,6 +1570,8 @@ int dpm_prepare(pm_message_t state)
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
+		dev->power.leave_runtime_suspended = false;
+		dev->power.parent_needed = true;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);

