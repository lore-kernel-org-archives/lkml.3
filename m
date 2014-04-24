Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaDXWYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:24:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63514 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932465AbaDXWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:24:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
Date: Fri, 25 Apr 2014 00:37:41 +0200
Message-ID: <2381177.mrXhZ4Wotn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5039115.7hOuWtlQhG@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1402271001190.1150-100000@iolanthe.rowland.org> <5039115.7hOuWtlQhG@vostro.rjw.lan>
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
should be able to tell the PM core about that.  For that reason, add
two new device PM flags, power.resume_not_needed and
power.use_runtime_resume, such that:

 (1) If power.resume_not_needed is set for the given device and for
     all of its children and the device is runtime-suspended during
     device_suspend(), the remaining device's system suspend/resume
     callbacks need not be executed.

 (2) If power.use_runtime_resume is set for the given device and the
     device is runtime-suspended in device_suspend_late(), its late/early
     and noirq system suspend/resume callbacks should be skipped and
     it should be resumed through pm_runtime_resume() in device_resume().

Those flags are cleared by the PM core in dpm_prepare() for all
devices.  Next, subsystems (or drivers) are supposed to set
power.resume_not_needed in their ->prepare() callbacks for devices
whose remaining system suspend/resume callbacks are generally safe to
be skipped if they are runtime-suspended already.  Finally, for each
runtime-suspended device with power.resume_not_needed set during
device_suspend(), its subsystem (or driver) may set the device's
power.use_runtime_resume in its ->suspend() callback without changing
the device's state, in which case the PM core will skip all of the
subsequent system suspend/resume callbacks for it and will resume it
in device_resume() using pm_runtime_resume().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/pm.h        |    2 ++
 2 files changed, 36 insertions(+), 7 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -546,6 +546,8 @@ struct dev_pm_info {
 	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			resume_not_needed:1;
+	bool			use_runtime_resume:1;
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
+	if (dev->power.syscore || dev->power.use_runtime_resume)
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -605,7 +605,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.use_runtime_resume)
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -735,6 +735,11 @@ static int device_resume(struct device *
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (dev->power.use_runtime_resume) {
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
+	if (dev->power.syscore || dev->power.use_runtime_resume)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1146,7 +1151,7 @@ static int __device_suspend_late(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.use_runtime_resume)
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1383,9 +1388,29 @@ static int __device_suspend(struct devic
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
+			 * Subsystems are supposed to set resume_not_needed in
+			 * their ->prepare() callbacks for devices whose
+			 * remaining system suspend and resume callbacks are
+			 * generally safe to be skipped if the devices are
+			 * runtime-suspended.
+			 *
+			 * If the device's resume_not_needed is not set at this
+			 * point, it has to be cleared for its parent too (even
+			 * if the subsystem has set that flag for it).
+			 */
+			if (!dev->power.resume_not_needed)
+				dev->parent->power.resume_not_needed = false;
+
+			spin_unlock_irq(&dev->parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1553,6 +1578,8 @@ int dpm_prepare(pm_message_t state)
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
+		dev->power.use_runtime_resume = false;
+		dev->power.resume_not_needed = false;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);

