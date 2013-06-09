Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3FIWJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:09:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60932 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3FIWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:09:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [Update][PATCH] ACPI / scan: Simplify ACPI driver probing
Date: Mon, 10 Jun 2013 00:18:38 +0200
Message-ID: <9524864.uKH8yPZA91@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2159292.upDGjkPUz6@vostro.rjw.lan>
References: <2159292.upDGjkPUz6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / scan: Simplify ACPI driver probing

There is no particular reason why acpi_bus_driver_init() needs to be
a separate function and its location with respect to its only caller,
acpi_device_probe(), makes the code a bit difficult to follow.

Besides, it doesn't really make sense to check if 'device' is not
NULL in acpi_bus_driver_init(), because we've already dereferenced
dev->driver in acpi_device_probe() at that point and, moreover,
'device' cannot be NULL then, because acpi_device_probe() is called
via really_probe() (which also sets dev->driver for that matter).

For these reasons, drop acpi_bus_driver_init() altogether and move
the remaining code from it directly into acpi_device_probe().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

It's in the bleeding-edge branch of the linux-pm.git tree already.

Thanks,
Rafael

---
 drivers/acpi/scan.c |   81 +++++++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -933,32 +933,40 @@ static void acpi_device_remove_notify_ha
 					   acpi_device_notify);
 }
 
-static int acpi_bus_driver_init(struct acpi_device *, struct acpi_driver *);
-static int acpi_device_probe(struct device * dev)
+static int acpi_device_probe(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
-	ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
-	if (!ret) {
-		if (acpi_drv->ops.notify) {
-			ret = acpi_device_install_notify_handler(acpi_dev);
-			if (ret) {
-				if (acpi_drv->ops.remove)
-					acpi_drv->ops.remove(acpi_dev);
-				acpi_dev->driver = NULL;
-				acpi_dev->driver_data = NULL;
-				return ret;
-			}
-		}
+	if (!acpi_drv->ops.add)
+		return -ENOSYS;
+
+	ret = acpi_drv->ops.add(acpi_dev);
+	if (ret)
+		return ret;
 
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			"Found driver [%s] for device [%s]\n",
-			acpi_drv->name, acpi_dev->pnp.bus_id));
-		get_device(dev);
+	acpi_dev->driver = acpi_drv;
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			  "Driver [%s] successfully bound to device [%s]\n",
+			  acpi_drv->name, acpi_dev->pnp.bus_id));
+
+	if (acpi_drv->ops.notify) {
+		ret = acpi_device_install_notify_handler(acpi_dev);
+		if (ret) {
+			if (acpi_drv->ops.remove)
+				acpi_drv->ops.remove(acpi_dev);
+
+			acpi_dev->driver = NULL;
+			acpi_dev->driver_data = NULL;
+			return ret;
+		}
 	}
-	return ret;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Found driver [%s] for device [%s]\n",
+			  acpi_drv->name, acpi_dev->pnp.bus_id));
+	get_device(dev);
+	return 0;
 }
 
 static int acpi_device_remove(struct device * dev)
@@ -1114,41 +1122,6 @@ static void acpi_device_unregister(struc
                                  Driver Management
    -------------------------------------------------------------------------- */
 /**
- * acpi_bus_driver_init - add a device to a driver
- * @device: the device to add and initialize
- * @driver: driver for the device
- *
- * Used to initialize a device via its device driver.  Called whenever a
- * driver is bound to a device.  Invokes the driver's add() ops.
- */
-static int
-acpi_bus_driver_init(struct acpi_device *device, struct acpi_driver *driver)
-{
-	int result = 0;
-
-	if (!device || !driver)
-		return -EINVAL;
-
-	if (!driver->ops.add)
-		return -ENOSYS;
-
-	result = driver->ops.add(device);
-	if (result)
-		return result;
-
-	device->driver = driver;
-
-	/*
-	 * TBD - Configuration Management: Assign resources to device based
-	 * upon possible configuration and currently allocated resources.
-	 */
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			  "Driver successfully bound to device\n"));
-	return 0;
-}
-
-/**
  * acpi_bus_register_driver - register a driver with the ACPI bus
  * @driver: driver being registered
  *

