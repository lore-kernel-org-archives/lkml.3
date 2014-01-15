Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaAONnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:43:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54176 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751725AbaAONnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:43:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Update][RFC][PATCH 3/3] ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
Date: Wed, 15 Jan 2014 14:57:03 +0100
Message-ID: <8541144.96Rt7mpIsi@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2417673.F2yu8qohk7@vostro.rjw.lan>
References: <5420830.W4laSGaAU9@vostro.rjw.lan> <2417673.F2yu8qohk7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend

Rework the ACPI PM domain's PM callbacks to avoid resuming devices
during system suspend in order to modify their wakeup settings if
that isn't necessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Changes from the previous version:

 - I don't think it is really necessary to clear power.no_suspend from
   acpi_dev_runtime_resume(), because __device_suspend() will run for
   children before it runs for the parent, so it is sufficient to clear
   power.no_suspend for the parent from there.

   At the same time, since the parent can only be runtime-suspended if the
   children are runtime-suspended, the children with power.no_suspend clear
   have to be runtime-resumed before __device_suspend() is executed for
   them and that will trigger runtime resume of the parent.

 - To avoid problems related to possible differences between runtime resume
   and system resume driver callbacks, use pm_runtime_resume() to resume
   devices whose power.no_suspend was set during the suspend we're resuming
   from.

Thanks,
Rafael

---
 drivers/acpi/device_pm.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -912,12 +912,28 @@ EXPORT_SYMBOL_GPL(acpi_dev_resume_early)
  */
 int acpi_subsys_prepare(struct device *dev)
 {
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	u32 target_state;
+	int error, state;
+
+	if (!adev || !pm_runtime_enabled_and_suspended(dev))
+		return pm_generic_prepare(dev);
+
+	target_state = acpi_target_system_state();
+	error = acpi_dev_pm_get_state(dev, adev, target_state, NULL, &state);
+	if (error || state != adev->power.state
+	    || device_may_wakeup(dev) != !!adev->wakeup.prepare_count) {
+		pm_runtime_resume(dev);
+		return pm_generic_prepare(dev);
+	}
 	/*
-	 * Follow PCI and resume devices suspended at run time before running
-	 * their system suspend callbacks.
+	 * If this is a wakeup device, wakeup power has been enabled already for
+	 * it during the preceding runtime suspend.  Caveat: "sleep state" is
+	 * one of the _DSW arguments, but that shouldn't matter for the devices
+	 * using acpi_general_pm_domain.
 	 */
-	pm_runtime_resume(dev);
-	return pm_generic_prepare(dev);
+	error =  pm_generic_prepare(dev);
+	return error ? error : 1;
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
 
@@ -945,10 +961,27 @@ EXPORT_SYMBOL_GPL(acpi_subsys_suspend_la
  */
 int acpi_subsys_resume_early(struct device *dev)
 {
-	int ret = acpi_dev_resume_early(dev);
+	int ret;
+
+	if (dev->power.no_suspend)
+		return 0;
+
+	ret = acpi_dev_resume_early(dev);
 	return ret ? ret : pm_generic_resume_early(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_resume_early);
+
+/**
+ * acpi_subsys_resume - Resume device using ACPI (if not resumed before).
+ * @dev: Device to resume.
+ *
+ * If power.no_suspend is set for @dev, run pm_runtime_resume() for it.
+ */
+int acpi_subsys_resume(struct device *dev)
+{
+	return dev->power.no_suspend ? pm_runtime_resume(dev) : 0;
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_resume);
 #endif /* CONFIG_PM_SLEEP */
 
 static struct dev_pm_domain acpi_general_pm_domain = {
@@ -961,8 +994,10 @@ static struct dev_pm_domain acpi_general
 		.prepare = acpi_subsys_prepare,
 		.suspend_late = acpi_subsys_suspend_late,
 		.resume_early = acpi_subsys_resume_early,
+		.resume = acpi_subsys_resume,
 		.poweroff_late = acpi_subsys_suspend_late,
 		.restore_early = acpi_subsys_resume_early,
+		.restore = acpi_subsys_resume,
 #endif
 	},
 };

