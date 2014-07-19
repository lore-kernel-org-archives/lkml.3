Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaGSViN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:38:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62632 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751191AbaGSViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:38:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Use ACPI_COMPANION() instead of ACPI_HANDLE()
Date: Sat, 19 Jul 2014 23:56:31 +0200
Message-ID: <1850188.af4fKDc87v@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI_HANDLE() macro evaluates ACPI_COMPANION() internally to
return the handle of the device's ACPI companion, so it is much
more straightforward and efficient to use ACPI_COMPANION()
directly to obtain the device's ACPI companion object instead of
using ACPI_HANDLE() and acpi_bus_get_device() on the returned
handle for the same thing.

Do that in three places in the ACPI device PM code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of https://patchwork.kernel.org/patch/4589941/

---
 drivers/acpi/device_pm.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -558,7 +558,6 @@ static int acpi_dev_pm_get_state(struct
  */
 int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
-	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 	int ret, d_min, d_max;
 
@@ -573,8 +572,9 @@ int acpi_pm_device_sleep_state(struct de
 			d_max_in = ACPI_STATE_D3_HOT;
 	}
 
-	if (!handle || acpi_bus_get_device(handle, &adev)) {
-		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
+	adev = ACPI_COMPANION(dev);
+	if (!adev) {
+		dev_dbg(dev, "ACPI companion missing in %s!\n", __func__);
 		return -ENODEV;
 	}
 
@@ -664,15 +664,13 @@ static void acpi_device_pm_event(acpi_ha
 int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
 {
 	struct acpi_device *adev;
-	acpi_handle handle;
 
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
 
-	handle = ACPI_HANDLE(phys_dev);
-	if (!handle || acpi_bus_get_device(handle, &adev)) {
-		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
-			__func__);
+	adev = ACPI_COMPANION(phys_dev);
+	if (!adev) {
+		dev_dbg(phys_dev, "ACPI companion missing in %s!\n", __func__);
 		return -ENODEV;
 	}
 
@@ -692,16 +690,15 @@ static inline void acpi_device_pm_event(
  */
 int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
-	acpi_handle handle;
 	struct acpi_device *adev;
 	int error;
 
 	if (!device_can_wakeup(dev))
 		return -EINVAL;
 
-	handle = ACPI_HANDLE(dev);
-	if (!handle || acpi_bus_get_device(handle, &adev)) {
-		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
+	adev = ACPI_COMPANION(dev);
+	if (!adev) {
+		dev_dbg(dev, "ACPI companion missing in %s!\n", __func__);
 		return -ENODEV;
 	}
 

