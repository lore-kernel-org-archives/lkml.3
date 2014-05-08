Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaEHW0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:26:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56604 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755964AbaEHW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:26:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC][PATCH 2/3] PM / runtime: Routine for checking device status during system suspend
Date: Fri, 09 May 2014 00:41:59 +0200
Message-ID: <3848796.OqSGUVFgr8@vostro.rjw.lan>
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

Add a new helper routine, pm_runtime_enabled_and_suspended(), to
allow subsystems (or PM domains) to check the runtime PM status of
devices during system suspend (possibly to avoid resuming those
devices upfront at that time).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/runtime.c |   27 +++++++++++++++++++++++++++
 include/linux/pm_runtime.h   |    2 ++
 2 files changed, 29 insertions(+)

Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -57,6 +57,7 @@ extern unsigned long pm_runtime_autosusp
 extern void pm_runtime_update_max_time_suspended(struct device *dev,
 						 s64 delta_ns);
 extern void pm_runtime_set_memalloc_noio(struct device *dev, bool enable);
+extern bool pm_runtime_enabled_and_suspended(struct device *dev);
 extern void pm_set_direct_resume(struct device *dev, bool val);
 
 static inline bool pm_children_suspended(struct device *dev)
@@ -175,6 +176,7 @@ static inline unsigned long pm_runtime_a
 				struct device *dev) { return 0; }
 static inline void pm_runtime_set_memalloc_noio(struct device *dev,
 						bool enable){}
+static inline bool pm_runtime_enabled_and_suspended(struct device *dev) { return false; }
 static inline void __set_direct_resume(struct device *dev, bool val) {}
 static inline void pm_set_direct_resume(struct device *dev, bool val) {}
 static inline bool pm_direct_resume_is_set(struct device *dev) { return false; }
Index: linux-pm/drivers/base/power/runtime.c
===================================================================
--- linux-pm.orig/drivers/base/power/runtime.c
+++ linux-pm/drivers/base/power/runtime.c
@@ -1196,6 +1196,33 @@ void pm_runtime_enable(struct device *de
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
 /**
+ * pm_runtime_enabled_and_suspended - Check runtime PM status of a device.
+ * @dev: Device to handle.
+ *
+ * This routine is to be executed during system suspend only, after
+ * device_prepare() has been executed for @dev.
+ *
+ * Return false if runtime PM is disabled for the device.  Otherwise, wait
+ * for pending transitions to complete and check the runtime PM status of the
+ * device after that.  Return true if it is RPM_SUSPENDED.
+ */
+bool pm_runtime_enabled_and_suspended(struct device *dev)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	if (dev->power.disable_depth) {
+		ret = false;
+	} else {
+		__pm_runtime_barrier(dev);
+		ret = pm_runtime_status_suspended(dev);
+	}
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	return ret;
+}
+
+/**
  * pm_runtime_forbid - Block runtime PM of a device.
  * @dev: Device to handle.
  *

