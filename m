Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaEGXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:16:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55534 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751729AbaEGXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:16:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/3] ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
Date: Thu, 08 May 2014 01:33:24 +0200
Message-ID: <2719001.qTQrFyBHGg@vostro.rjw.lan>
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

Rework the ACPI PM domain's PM callbacks to avoid resuming devices
during system suspend (in order to modify their wakeup settings etc.)
if that isn't necessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   31 ++++++++++++++++++++++++++++---
 drivers/acpi/scan.c      |    4 ++++
 include/acpi/acpi_bus.h  |    3 ++-
 3 files changed, 34 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -907,6 +907,7 @@ int acpi_subsys_prepare(struct device *d
 	if (dev->power.ignore_children)
 		pm_runtime_resume(dev);
 
+	pm_set_leave_runtime_suspended(dev, true);
 	return pm_generic_prepare(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
@@ -914,13 +915,37 @@ EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
 /**
  * acpi_subsys_suspend - Run the device driver's suspend callback.
  * @dev: Device to handle.
- *
- * Follow PCI and resume devices suspended at run time before running their
- * system suspend callbacks.
  */
 int acpi_subsys_suspend(struct device *dev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	u32 sys_target;
+
+	if (!adev || !pm_runtime_enabled_and_suspended(dev)) {
+		pm_set_leave_runtime_suspended(dev, false);
+		goto out;
+	}
+	if (!pm_leave_runtime_suspended(dev)
+	    || device_may_wakeup(dev) != !!adev->wakeup.prepare_count)
+		goto resume;
+
+	sys_target = acpi_target_system_state();
+	if (sys_target != ACPI_STATE_S0) {
+		int ret, state;
+
+		if (adev->power.flags.dsw_present)
+			goto resume;
+
+		ret = acpi_dev_pm_get_state(dev, adev, sys_target, NULL, &state);
+		if (ret || state != adev->power.state)
+			goto resume;
+	}
+	return 0;
+
+ resume:
 	pm_runtime_resume(dev);
+
+ out:
 	return pm_generic_suspend(dev);
 }
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -261,7 +261,8 @@ struct acpi_device_power_flags {
 	u32 inrush_current:1;	/* Serialize Dx->D0 */
 	u32 power_removed:1;	/* Optimize Dx->D0 */
 	u32 ignore_parent:1;	/* Power is independent of parent power state */
-	u32 reserved:27;
+	u32 dsw_present:1;	/* _DSW present? */
+	u32 reserved:26;
 };
 
 struct acpi_device_power_state {
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1551,9 +1551,13 @@ static void acpi_bus_get_power_flags(str
 	 */
 	if (acpi_has_method(device->handle, "_PSC"))
 		device->power.flags.explicit_get = 1;
+
 	if (acpi_has_method(device->handle, "_IRC"))
 		device->power.flags.inrush_current = 1;
 
+	if (acpi_has_method(device->handle, "_DSW"))
+		device->power.flags.dsw_present = 1;
+
 	/*
 	 * Enumerate supported power management states
 	 */

