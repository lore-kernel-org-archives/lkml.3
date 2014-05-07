Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaEGXRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:17:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53207 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752140AbaEGXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:16:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Thu, 08 May 2014 01:29:47 +0200
Message-ID: <2703563.1xTcfTGG98@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2333255.ofrK1CRRL4@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405071126340.1325-100000@iolanthe.rowland.org> <2333255.ofrK1CRRL4@vostro.rjw.lan>
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
descendants can remain runtime suspended until the resume stage of system
resume.

To this end, introduce dev->power.leave_runtime_suspended.
If a subsystem or driver sets this flag during the ->prepare() callback,
and if the flag is set in all of the device's descendants, and if the
device is still in runtime suspend at the beginning of the ->suspend()
callback, that callback is allowed to return 0 without clearing
power.leave_runtime_suspended and without changing the state of the
device, unless the current state of the device is not appropriate for
the upcoming system sleep state (for example, the device is supposed to
wake up the system from that state and its current wakeup settings are
not suitable for that).  Then, the PM core will not invoke the device's
->suspend_late(), ->suspend_irq(), ->resume_irq(), ->resume_early(), or
->resume() callbacks.  Instead, it will invoke ->runtime_resume() during
the device resume stage of system resume.

By leaving this flag set after ->suspend(), a driver or subsystem tells
the PM core that the device is runtime suspended, it is in a suitable
state for system suspend (for example, the wakeup setting does not
need to be changed), and it does not need to return to full
power until the resume stage.

Changelog based on an Alan Stern's description of the idea
(http://marc.info/?l=linux-pm&m=139940466625569&w=2).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c    |   31 ++++++++++++++++++++++++-------
 drivers/base/power/runtime.c |   10 ++++++++++
 include/linux/pm.h           |    3 +++
 include/linux/pm_runtime.h   |   16 ++++++++++++++++
 kernel/power/Kconfig         |    4 ++++
 5 files changed, 57 insertions(+), 7 deletions(-)

Index: linux-pm/kernel/power/Kconfig
===================================================================
--- linux-pm.orig/kernel/power/Kconfig
+++ linux-pm/kernel/power/Kconfig
@@ -147,6 +147,10 @@ config PM
 	def_bool y
 	depends on PM_SLEEP || PM_RUNTIME
 
+config PM_BOTH
+	def_bool y
+	depends on PM_SLEEP && PM_RUNTIME
+
 config PM_DEBUG
 	bool "Power Management Debug Support"
 	depends on PM
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -583,6 +583,9 @@ struct dev_pm_info {
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
 #endif
+#ifdef CONFIG_PM_BOTH
+	bool			leave_runtime_suspended:1;
+#endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
 	void (*set_latency_tolerance)(struct device *, s32);
 	struct dev_pm_qos	*qos;
Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -264,4 +264,20 @@ static inline void pm_runtime_dont_use_a
 	__pm_runtime_use_autosuspend(dev, false);
 }
 
+#ifdef CONFIG_PM_BOTH
+static inline void __set_leave_runtime_suspended(struct device *dev, bool val)
+{
+	dev->power.leave_runtime_suspended = val;
+}
+extern void pm_set_leave_runtime_suspended(struct device *dev, bool val);
+static inline bool pm_leave_runtime_suspended(struct device *dev)
+{
+	return dev->power.leave_runtime_suspended;
+}
+#else
+static inline void __set_leave_runtime_suspended(struct device *dev, bool val) {}
+static inline void pm_set_leave_runtime_suspended(struct device *dev, bool val) {}
+static inline bool pm_leave_runtime_suspended(struct device *dev) { return false; }
+#endif
+
 #endif
Index: linux-pm/drivers/base/power/runtime.c
===================================================================
--- linux-pm.orig/drivers/base/power/runtime.c
+++ linux-pm/drivers/base/power/runtime.c
@@ -732,6 +732,7 @@ static int rpm_resume(struct device *dev
 	}
  skip_parent:
 
+	__set_leave_runtime_suspended(dev, false);
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
@@ -1485,3 +1486,12 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pm_runtime_force_resume);
+
+#ifdef CONFIG_PM_BOTH
+void pm_set_leave_runtime_suspended(struct device *dev, bool val)
+{
+	spin_lock_irq(&dev->power.lock);
+	__set_leave_runtime_suspended(dev, val);
+	spin_unlock_irq(&dev->power.lock);
+}
+#endif
Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -479,7 +479,7 @@ static int device_resume_noirq(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_leave_runtime_suspended(dev))
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -605,7 +605,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_leave_runtime_suspended(dev))
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -735,6 +735,11 @@ static int device_resume(struct device *
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (pm_leave_runtime_suspended(dev)) {
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
+	if (dev->power.syscore || pm_leave_runtime_suspended(dev))
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1146,7 +1151,7 @@ static int __device_suspend_late(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_leave_runtime_suspended(dev))
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1382,10 +1387,21 @@ static int __device_suspend(struct devic
 
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
+			if (dev->power.wakeup_path
+			    && !parent->power.ignore_children)
+				parent->power.wakeup_path = true;
+
+			if (!pm_leave_runtime_suspended(dev))
+				__set_leave_runtime_suspended(parent, false);
+
+			spin_unlock_irq(&parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1553,6 +1569,7 @@ int dpm_prepare(pm_message_t state)
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
+		pm_set_leave_runtime_suspended(dev, false);
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);

