Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3AWR4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:56:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52143 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab3AWR4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:56:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [Update][PATCH 1/5] ACPI / scan: Prevent device add uevents from racing with user space
Date: Wed, 23 Jan 2013 18:58:31 +0100
Message-ID: <4119653.FS5BMPMa9z@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1551140.kO91IOVbjI@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2760421.6nE3tkh92K@vostro.rjw.lan> <1551140.kO91IOVbjI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI core adds sysfs device files after the given devices have been
registered with device_register(), which is not appropriate, because
it may lead to race conditions with user space tools using those
files.

Fix the problem by delaying the KOBJ_ADD uevent for ACPI devices
until after all of the devices' sysfs files have been created.

This also fixes a use-after-free in acpi_device_unregister().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    5 +++--
 drivers/acpi/power.c    |    3 ++-
 drivers/acpi/scan.c     |   20 +++++++++++++++-----
 3 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -40,10 +40,11 @@ static inline void acpi_debugfs_init(voi
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
 			  ACPI_STA_DEVICE_UI | ACPI_STA_DEVICE_FUNCTIONING)
 
-int acpi_device_register(struct acpi_device *device,
-			 void (*release)(struct device *));
+int acpi_device_add(struct acpi_device *device,
+		    void (*release)(struct device *));
 void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 			     int type, unsigned long long sta);
+void acpi_device_add_finalize(struct acpi_device *device);
 void acpi_free_ids(struct acpi_device *device);
 
 /* --------------------------------------------------------------------------
Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -719,13 +719,14 @@ int acpi_add_power_resource(acpi_handle
 	       acpi_device_bid(device), state ? "on" : "off");
 
 	device->flags.match_driver = true;
-	result = acpi_device_register(device, acpi_release_power_resource);
+	result = acpi_device_add(device, acpi_release_power_resource);
 	if (result)
 		goto err;
 
 	mutex_lock(&power_resource_list_lock);
 	list_add(&resource->list_node, &acpi_power_resource_list);
 	mutex_unlock(&power_resource_list_lock);
+	acpi_device_add_finalize(device);
 	return 0;
 
  err:
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -633,8 +633,8 @@ struct bus_type acpi_bus_type = {
 	.uevent		= acpi_device_uevent,
 };
 
-int acpi_device_register(struct acpi_device *device,
-			 void (*release)(struct device *))
+int acpi_device_add(struct acpi_device *device,
+		    void (*release)(struct device *))
 {
 	int result;
 	struct acpi_device_bus_id *acpi_device_bus_id, *new_bus_id;
@@ -704,7 +704,7 @@ int acpi_device_register(struct acpi_dev
 		device->dev.parent = &device->parent->dev;
 	device->dev.bus = &acpi_bus_type;
 	device->dev.release = release;
-	result = device_register(&device->dev);
+	result = device_add(&device->dev);
 	if (result) {
 		dev_err(&device->dev, "Error registering device\n");
 		goto err;
@@ -743,12 +743,13 @@ static void acpi_device_unregister(struc
 
 	acpi_power_add_remove_device(device, false);
 	acpi_device_remove_files(device);
-	device_unregister(&device->dev);
+	device_del(&device->dev);
 	/*
 	 * Drop the reference counts of all power resources the device depends
 	 * on and turn off the ones that have no more references.
 	 */
 	acpi_power_transition(device, ACPI_STATE_D3_COLD);
+	put_device(&device->dev);
 }
 
 /* --------------------------------------------------------------------------
@@ -1390,6 +1391,14 @@ void acpi_init_device_object(struct acpi
 	acpi_device_get_busid(device);
 	acpi_device_set_id(device);
 	acpi_bus_get_flags(device);
+	device_initialize(&device->dev);
+	dev_set_uevent_suppress(&device->dev, true);
+}
+
+void acpi_device_add_finalize(struct acpi_device *device)
+{
+	dev_set_uevent_suppress(&device->dev, false);
+	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
 }
 
 static int acpi_add_single_object(struct acpi_device **child,
@@ -1411,13 +1420,14 @@ static int acpi_add_single_object(struct
 	acpi_bus_get_wakeup_device_flags(device);
 
 	device->flags.match_driver = match_driver;
-	result = acpi_device_register(device, acpi_device_release);
+	result = acpi_device_add(device, acpi_device_release);
 	if (result) {
 		acpi_device_release(&device->dev);
 		return result;
 	}
 
 	acpi_power_add_remove_device(device, true);
+	acpi_device_add_finalize(device);
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Added %s [%s] parent %s\n",
 		dev_name(&device->dev), (char *) buffer.pointer,

