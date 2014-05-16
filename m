Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaEPWBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:01:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56575 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754443AbaEPWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:01:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3/3][update] ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
Date: Sat, 17 May 2014 00:18:13 +0200
Message-ID: <37853320.Ciz4qVIJCi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1523744.XGJjEBjYbG@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405141041360.1432-100000@iolanthe.rowland.org> <1596386.YnYCCm2UQG@vostro.rjw.lan> <1523744.XGJjEBjYbG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend

Rework the ACPI PM domain's PM callbacks to avoid resuming devices
during system suspend (in order to modify their wakeup settings etc.)
if that isn't necessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

I sent an outdated patch previously, sorry about that.  This is what was meant
to be sent.

Thanks!

---
 drivers/acpi/device_pm.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

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
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -900,18 +900,46 @@ EXPORT_SYMBOL_GPL(acpi_dev_resume_early)
  */
 int acpi_subsys_prepare(struct device *dev)
 {
-	/*
-	 * Devices having power.ignore_children set may still be necessary for
-	 * suspending their children in the next phase of device suspend.
-	 */
-	if (dev->power.ignore_children)
-		pm_runtime_resume(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	u32 sys_target;
+	int ret, state;
+
+	ret = pm_generic_prepare(dev);
+	if (ret < 0)
+		return ret;
+
+	if (!adev || !pm_runtime_suspended(dev)
+	    || device_may_wakeup(dev) != !!adev->wakeup.prepare_count)
+		return 0;
+
+	sys_target = acpi_target_system_state();
+	if (sys_target == ACPI_STATE_S0)
+		return 1;
+
+	if (adev->power.flags.dsw_present)
+		return 0;
 
-	return pm_generic_prepare(dev);
+	ret = acpi_dev_pm_get_state(dev, adev, sys_target, NULL, &state);
+	return !ret && state == adev->power.state;
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
 
 /**
+ * acpi_subsys_complete - Finalize device's resume during system resume.
+ * @dev: Device to handle.
+ */
+void acpi_subsys_complete(struct device *dev)
+{
+	/*
+	 * If the device had been runtime-suspended before the system went into
+	 * the sleep state it is going out of and it has never been resumed till
+	 * now, resume it in case the firmware powered it up.
+	 */
+	if (dev->power.direct_complete)
+		pm_request_resume(dev);
+}
+
+/**
  * acpi_subsys_suspend - Run the device driver's suspend callback.
  * @dev: Device to handle.
  *
@@ -979,6 +1007,7 @@ static struct dev_pm_domain acpi_general
 #endif
 #ifdef CONFIG_PM_SLEEP
 		.prepare = acpi_subsys_prepare,
+		.complete = acpi_subsys_complete,
 		.suspend = acpi_subsys_suspend,
 		.suspend_late = acpi_subsys_suspend_late,
 		.resume_early = acpi_subsys_resume_early,

