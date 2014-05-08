Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaEHW1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:27:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50766 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756143AbaEHW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:26:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Fri, 09 May 2014 00:41:18 +0200
Message-ID: <3786444.hNhCASz73P@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4232134.uNVe9bptuo@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405081718200.995-100000@iolanthe.rowland.org> <2356017.WpDFDYKWcr@vostro.rjw.lan> <4232134.uNVe9bptuo@vostro.rjw.lan>
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

To this end, introduce a new device PM flag, power.direct_resume.
If a subsystem or driver sets this flag during the ->prepare()
callback, and if the flag is set in all of the device's descendants,
and if the device is still in runtime suspend at the beginning of the
->suspend() callback, that callback is allowed to return 0 without
clearing power.direct_resume and without changing the state of the
device, unless the current state of the device is not appropriate for
the upcoming system sleep state (for example, the device is supposed
to wake up the system from that state and its current wakeup settings
are not suitable for that).  Then, the PM core will not invoke the
device's ->suspend_late(), ->suspend_irq(), ->resume_irq(), or
->resume_early() callbacks.  Instead, it will only invoke ->resume()
during the device resume stage of system resume and that callback
will be entirely responsible for resuming the device as appropriate.

By leaving this flag set after ->suspend(), a driver or subsystem tells
the PM core that the device is runtime suspended, it is in a suitable
state for system suspend (for example, the wakeup setting does not
need to be changed), and it does not need to return to full power
until the resume stage.

Changelog based on an Alan Stern's description of the idea
(http://marc.info/?l=linux-pm&m=139940466625569&w=2).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c    |   26 +++++++++++++++++++-------
 drivers/base/power/runtime.c |    8 ++++++++
 include/linux/pm.h           |    1 +
 include/linux/pm_runtime.h   |   13 +++++++++++++
 4 files changed, 41 insertions(+), 7 deletions(-)

Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -574,6 +574,7 @@ struct dev_pm_info {
 	unsigned int		use_autosuspend:1;
 	unsigned int		timer_autosuspends:1;
 	unsigned int		memalloc_noio:1;
+	bool			direct_resume:1;	/* For system suspend */
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -57,6 +57,7 @@ extern unsigned long pm_runtime_autosusp
 extern void pm_runtime_update_max_time_suspended(struct device *dev,
 						 s64 delta_ns);
 extern void pm_runtime_set_memalloc_noio(struct device *dev, bool enable);
+extern void pm_set_direct_resume(struct device *dev, bool val);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -116,6 +117,15 @@ static inline void pm_runtime_mark_last_
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+static inline void __set_direct_resume(struct device *dev, bool val)
+{
+	dev->power.direct_resume = val;
+}
+
+static inline bool pm_direct_resume_is_set(struct device *dev)
+{
+	return dev->power.direct_resume;
+}
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -165,6 +175,9 @@ static inline unsigned long pm_runtime_a
 				struct device *dev) { return 0; }
 static inline void pm_runtime_set_memalloc_noio(struct device *dev,
 						bool enable){}
+static inline void __set_direct_resume(struct device *dev, bool val) {}
+static inline void pm_set_direct_resume(struct device *dev, bool val) {}
+static inline bool pm_direct_resume_is_set(struct device *dev) { return false; }
 
 #endif /* !CONFIG_PM_RUNTIME */
 
Index: linux-pm/drivers/base/power/runtime.c
===================================================================
--- linux-pm.orig/drivers/base/power/runtime.c
+++ linux-pm/drivers/base/power/runtime.c
@@ -732,6 +732,7 @@ static int rpm_resume(struct device *dev
 	}
  skip_parent:
 
+	__set_direct_resume(dev, false);
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
@@ -1485,3 +1486,10 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pm_runtime_force_resume);
+
+void pm_set_direct_resume(struct device *dev, bool val)
+{
+	spin_lock_irq(&dev->power.lock);
+	__set_direct_resume(dev, val);
+	spin_unlock_irq(&dev->power.lock);
+}
Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -479,7 +479,7 @@ static int device_resume_noirq(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_direct_resume_is_set(dev))
 		goto Out;
 
 	if (!dev->power.is_noirq_suspended)
@@ -605,7 +605,7 @@ static int device_resume_early(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_direct_resume_is_set(dev))
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
@@ -1007,7 +1007,7 @@ static int __device_suspend_noirq(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_direct_resume_is_set(dev))
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1146,7 +1146,7 @@ static int __device_suspend_late(struct
 		goto Complete;
 	}
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || pm_direct_resume_is_set(dev))
 		goto Complete;
 
 	dpm_wait_for_children(dev, async);
@@ -1382,10 +1382,21 @@ static int __device_suspend(struct devic
 
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
+			if (!pm_direct_resume_is_set(dev))
+				__set_direct_resume(parent, false);
+
+			spin_unlock_irq(&parent->power.lock);
+		}
 	}
 
 	device_unlock(dev);
@@ -1553,6 +1564,7 @@ int dpm_prepare(pm_message_t state)
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
+		pm_set_direct_resume(dev, false);
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_prepare(dev, state);

