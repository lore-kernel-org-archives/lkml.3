Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaGSWFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 18:05:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62510 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755760AbaGSWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 18:05:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] ACPI / PNP: Use ACPI_COMPANION() instead of ACPI_HANDLE()
Date: Sun, 20 Jul 2014 00:23:51 +0200
Message-ID: <3900370.F3rVfSBEAR@vostro.rjw.lan>
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

Do that in several places in the ACPI PNP core code.

Also use acpi_device_set_power() and acpi_device_power_manageable()
instead of acpi_bus_set_power() and acpi_bus_power_manageable(),
respectively, because the former two are more efficient if the
ACPI device object is already available.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pnp/pnpacpi/core.c |   51 ++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -67,8 +67,8 @@ static int pnpacpi_set_resources(struct
 
 	pnp_dbg(&dev->dev, "set resources\n");
 
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
+	acpi_dev = ACPI_COMPANION(&dev->dev);
+	if (!acpi_dev) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return -ENODEV;
 	}
@@ -76,6 +76,7 @@ static int pnpacpi_set_resources(struct
 	if (WARN_ON_ONCE(acpi_dev != dev->data))
 		dev->data = acpi_dev;
 
+	handle = acpi_dev->handle;
 	if (acpi_has_method(handle, METHOD_NAME__SRS)) {
 		struct acpi_buffer buffer;
 
@@ -93,8 +94,8 @@ static int pnpacpi_set_resources(struct
 		}
 		kfree(buffer.pointer);
 	}
-	if (!ret && acpi_bus_power_manageable(handle))
-		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
+	if (!ret && acpi_device_power_manageable(acpi_dev))
+		ret = acpi_device_set_power(acpi_dev, ACPI_STATE_D0);
 
 	return ret;
 }
@@ -102,23 +103,22 @@ static int pnpacpi_set_resources(struct
 static int pnpacpi_disable_resources(struct pnp_dev *dev)
 {
 	struct acpi_device *acpi_dev;
-	acpi_handle handle;
 	acpi_status status;
 
 	dev_dbg(&dev->dev, "disable resources\n");
 
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
+	acpi_dev = ACPI_COMPANION(&dev->dev);
+	if (!acpi_dev) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return 0;
 	}
 
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	if (acpi_bus_power_manageable(handle))
-		acpi_bus_set_power(handle, ACPI_STATE_D3_COLD);
+	if (acpi_device_power_manageable(acpi_dev))
+		acpi_device_set_power(acpi_dev, ACPI_STATE_D3_COLD);
 
-	/* continue even if acpi_bus_set_power() fails */
-	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
+	/* continue even if acpi_device_set_power() fails */
+	status = acpi_evaluate_object(acpi_dev->handle, "_DIS", NULL, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
 		return -ENODEV;
 
@@ -128,26 +128,22 @@ static int pnpacpi_disable_resources(str
 #ifdef CONFIG_ACPI_SLEEP
 static bool pnpacpi_can_wakeup(struct pnp_dev *dev)
 {
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
+	struct acpi_device *acpi_dev = ACPI_COMPANION(&dev->dev);
 
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
+	if (!acpi_dev) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return false;
 	}
 
-	return acpi_bus_can_wakeup(handle);
+	return acpi_bus_can_wakeup(acpi_dev->handle);
 }
 
 static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 {
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
+	struct acpi_device *acpi_dev = ACPI_COMPANION(&dev->dev);
 	int error = 0;
 
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
+	if (!acpi_dev) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return 0;
 	}
@@ -159,7 +155,7 @@ static int pnpacpi_suspend(struct pnp_de
 			return error;
 	}
 
-	if (acpi_bus_power_manageable(handle)) {
+	if (acpi_device_power_manageable(acpi_dev)) {
 		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL,
 							ACPI_STATE_D3_COLD);
 		if (power_state < 0)
@@ -167,12 +163,12 @@ static int pnpacpi_suspend(struct pnp_de
 					ACPI_STATE_D0 : ACPI_STATE_D3_COLD;
 
 		/*
-		 * acpi_bus_set_power() often fails (keyboard port can't be
+		 * acpi_device_set_power() can fail (keyboard port can't be
 		 * powered-down?), and in any case, our return value is ignored
 		 * by pnp_bus_suspend().  Hence we don't revert the wakeup
 		 * setting if the set_power fails.
 		 */
-		error = acpi_bus_set_power(handle, power_state);
+		error = acpi_device_set_power(acpi_dev, power_state);
 	}
 
 	return error;
@@ -180,11 +176,10 @@ static int pnpacpi_suspend(struct pnp_de
 
 static int pnpacpi_resume(struct pnp_dev *dev)
 {
-	struct acpi_device *acpi_dev;
-	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	struct acpi_device *acpi_dev = ACPI_COMPANION(&dev->dev);
 	int error = 0;
 
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
+	if (!acpi_dev) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return -ENODEV;
 	}
@@ -192,8 +187,8 @@ static int pnpacpi_resume(struct pnp_dev
 	if (device_may_wakeup(&dev->dev))
 		acpi_pm_device_sleep_wake(&dev->dev, false);
 
-	if (acpi_bus_power_manageable(handle))
-		error = acpi_bus_set_power(handle, ACPI_STATE_D0);
+	if (acpi_device_power_manageable(acpi_dev))
+		error = acpi_device_set_power(acpi_dev, ACPI_STATE_D0);
 
 	return error;
 }

