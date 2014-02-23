Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaBWXG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:06:26 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51722 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752212AbaBWXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:06:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/2] ACPI / PM: Resume runtime-suspended devices later during system suspend
Date: Mon, 24 Feb 2014 00:20:11 +0100
Message-ID: <24034179.VSBkt6DiQs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1853950.oxM3KDpyLu@vostro.rjw.lan>
References: <1853950.oxM3KDpyLu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Runtime-suspended devices are resumed during system suspend by
acpi_subsys_prepare() for two reasons: First, because they may need
to be reprogrammed in order to change their wakeup settings and,
second, because they may need to be operatonal for their children
to be successfully suspended.  That is a problem, though, if there
are many runtime-suspended devices that need to be resumed this
way during system suspend, because the .prepare() PM callbacks of
devices are executed sequentially and the times taken by them
accumulate, which may increase the total system suspend time quite
a bit.

For this reason, move the resume of runtime-suspended devices up
to the next phase of device suspend (during system suspend), except
for the ones that have power.ignore_children set.  The exception is
made, because the devices with power.ignore_children set may still
be necessary for their children to be successfully suspended (during
system suspend) and they won't be resumed automatically as a result
of the runtime resume of their children.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -901,15 +901,30 @@ EXPORT_SYMBOL_GPL(acpi_dev_resume_early)
 int acpi_subsys_prepare(struct device *dev)
 {
 	/*
-	 * Follow PCI and resume devices suspended at run time before running
-	 * their system suspend callbacks.
+	 * Devices having power.ignore_children set may still be necessary for
+	 * suspending their children in the next phase of device suspend.
 	 */
-	pm_runtime_resume(dev);
+	if (dev->power.ignore_children)
+		pm_runtime_resume(dev);
+
 	return pm_generic_prepare(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
 
 /**
+ * acpi_subsys_suspend - Run the device driver's suspend callback.
+ * @dev: Device to handle.
+ *
+ * Follow PCI and resume devices suspended at run time before running their
+ * system suspend callbacks.
+ */
+int acpi_subsys_suspend(struct device *dev)
+{
+	pm_runtime_resume(dev);
+	return pm_generic_suspend(dev);
+}
+
+/**
  * acpi_subsys_suspend_late - Suspend device using ACPI.
  * @dev: Device to suspend.
  *
@@ -937,6 +952,23 @@ int acpi_subsys_resume_early(struct devi
 	return ret ? ret : pm_generic_resume_early(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_resume_early);
+
+/**
+ * acpi_subsys_freeze - Run the device driver's freeze callback.
+ * @dev: Device to handle.
+ */
+int acpi_subsys_freeze(struct device *dev)
+{
+	/*
+	 * This used to be done in acpi_subsys_prepare() for all devices and
+	 * some drivers may depend on it, so do it here.  Ideally, however,
+	 * runtime-suspended devices should not be touched during freeze/thaw
+	 * transitions.
+	 */
+	pm_runtime_resume(dev);
+	return pm_generic_freeze(dev);
+}
+
 #endif /* CONFIG_PM_SLEEP */
 
 static struct dev_pm_domain acpi_general_pm_domain = {
@@ -947,8 +979,11 @@ static struct dev_pm_domain acpi_general
 #endif
 #ifdef CONFIG_PM_SLEEP
 		.prepare = acpi_subsys_prepare,
+		.suspend = acpi_subsys_suspend,
 		.suspend_late = acpi_subsys_suspend_late,
 		.resume_early = acpi_subsys_resume_early,
+		.freeze = acpi_subsys_freeze,
+		.poweroff = acpi_subsys_suspend,
 		.poweroff_late = acpi_subsys_suspend_late,
 		.restore_early = acpi_subsys_resume_early,
 #endif

