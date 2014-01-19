Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaASPYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 10:24:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63894 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752231AbaASPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 10:24:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ACPI / PM: Use ACPI_COMPANION() to get ACPI companions of devices
Date: Sun, 19 Jan 2014 16:38:33 +0100
Message-ID: <3698474.jasU9n7YCg@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI device PM code in device_pm.c uses a special function,
acpi_dev_pm_get_node(), to obtain an ACPI companion object of a given
device.  However, that is not necessary any more after recent changes
that introduced the ACPI_COMPANION() macro serving exactly the same
purpose, but working in a much more straightforward way.  For this
reason, drop acpi_dev_pm_get_node() and use ACPI_COMPANION() instead
of it everywhere.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -727,18 +727,6 @@ int acpi_pm_device_sleep_wake(struct dev
 #endif /* CONFIG_PM_SLEEP */
 
 /**
- * acpi_dev_pm_get_node - Get ACPI device node for the given physical device.
- * @dev: Device to get the ACPI node for.
- */
-struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
-{
-	acpi_handle handle = ACPI_HANDLE(dev);
-	struct acpi_device *adev;
-
-	return handle && !acpi_bus_get_device(handle, &adev) ? adev : NULL;
-}
-
-/**
  * acpi_dev_pm_low_power - Put ACPI device into a low-power state.
  * @dev: Device to put into a low-power state.
  * @adev: ACPI device node corresponding to @dev.
@@ -778,7 +766,7 @@ static int acpi_dev_pm_full_power(struct
  */
 int acpi_dev_runtime_suspend(struct device *dev)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	bool remote_wakeup;
 	int error;
 
@@ -809,7 +797,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_runtime_suspe
  */
 int acpi_dev_runtime_resume(struct device *dev)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	int error;
 
 	if (!adev)
@@ -862,7 +850,7 @@ EXPORT_SYMBOL_GPL(acpi_subsys_runtime_re
  */
 int acpi_dev_suspend_late(struct device *dev)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	u32 target_state;
 	bool wakeup;
 	int error;
@@ -894,7 +882,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_suspend_late)
  */
 int acpi_dev_resume_early(struct device *dev)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	int error;
 
 	if (!adev)
@@ -985,7 +973,7 @@ static struct dev_pm_domain acpi_general
  */
 int acpi_dev_pm_attach(struct device *dev, bool power_on)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 
 	if (!adev)
 		return -ENODEV;
@@ -1017,7 +1005,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
  */
 void acpi_dev_pm_detach(struct device *dev, bool power_off)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 
 	if (adev && dev->pm_domain == &acpi_general_pm_domain) {
 		dev->pm_domain = NULL;

