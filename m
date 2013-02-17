Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3BQPVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:21:25 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39019 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab3BQPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 7/7] ACPI / scan: Make memory hotplug driver use struct acpi_scan_handler
Date: Sun, 17 Feb 2013 16:27:18 +0100
Message-ID: <2200731.3okUfey51A@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3260206.bhaAobGhpZ@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the ACPI memory hotplug driver use struct acpi_scan_handler
for representing the object used to set up ACPI memory hotplug
functionality and to remove hotplug memory ranges and data
structures used by the driver before unregistering ACPI device
nodes representing memory.  Register the new struct acpi_scan_handler
object with the help of acpi_scan_add_handler_with_hotplug() to allow
user space to manipulate the attributes of the memory hotplug
profile.

This results in a significant reduction of the drvier's code size
and removes some ACPI hotplug code duplication.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Kconfig           |    3 
 drivers/acpi/acpi_memhotplug.c |  310 +++++------------------------------------
 drivers/acpi/internal.h        |    5 
 drivers/acpi/scan.c            |    1 
 4 files changed, 46 insertions(+), 273 deletions(-)

Index: test/drivers/acpi/Kconfig
===================================================================
--- test.orig/drivers/acpi/Kconfig
+++ test/drivers/acpi/Kconfig
@@ -350,9 +350,8 @@ config ACPI_CONTAINER
 	  the module will be called container.
 
 config ACPI_HOTPLUG_MEMORY
-	tristate "Memory Hotplug"
+	bool "Memory Hotplug"
 	depends on MEMORY_HOTPLUG
-	default n
 	help
 	  This driver supports ACPI memory hotplug.  The driver
 	  fields notifications on ACPI memory devices (PNP0C80),
Index: test/drivers/acpi/acpi_memhotplug.c
===================================================================
--- test.orig/drivers/acpi/acpi_memhotplug.c
+++ test/drivers/acpi/acpi_memhotplug.c
@@ -1,5 +1,7 @@
 /*
- * Copyright (C) 2004 Intel Corporation <naveen.b.s@intel.com>
+ * Copyright (C) 2004, 2013 Intel Corporation
+ * Author: Naveen B S <naveen.b.s@intel.com>
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  *
  * All rights reserved.
  *
@@ -25,14 +27,10 @@
  * ranges.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/memory_hotplug.h>
-#include <linux/slab.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/memory_hotplug.h>
+
+#include "internal.h"
 
 #define ACPI_MEMORY_DEVICE_CLASS		"memory"
 #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
@@ -44,32 +42,29 @@
 #define 	PREFIX		"ACPI:memory_hp:"
 
 ACPI_MODULE_NAME("acpi_memhotplug");
-MODULE_AUTHOR("Naveen B S <naveen.b.s@intel.com>");
-MODULE_DESCRIPTION("Hotplug Mem Driver");
-MODULE_LICENSE("GPL");
 
 /* Memory Device States */
 #define MEMORY_INVALID_STATE	0
 #define MEMORY_POWER_ON_STATE	1
 #define MEMORY_POWER_OFF_STATE	2
 
-static int acpi_memory_device_add(struct acpi_device *device);
-static int acpi_memory_device_remove(struct acpi_device *device);
+static int acpi_memory_device_add(struct acpi_device *device,
+				  const struct acpi_device_id *not_used);
+static void acpi_memory_device_remove(struct acpi_device *device);
 
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
 	{"", 0},
 };
-MODULE_DEVICE_TABLE(acpi, memory_device_ids);
 
-static struct acpi_driver acpi_memory_device_driver = {
-	.name = "acpi_memhotplug",
-	.class = ACPI_MEMORY_DEVICE_CLASS,
+static struct acpi_scan_handler memory_device_handler = {
 	.ids = memory_device_ids,
-	.ops = {
-		.add = acpi_memory_device_add,
-		.remove = acpi_memory_device_remove,
-		},
+	.attach = acpi_memory_device_add,
+	.detach = acpi_memory_device_remove,
+	.hotplug = {
+		.enabled = true,
+		.autoeject = true,
+	},
 };
 
 struct acpi_memory_info {
@@ -153,48 +148,6 @@ acpi_memory_get_device_resources(struct
 	return 0;
 }
 
-static int acpi_memory_get_device(acpi_handle handle,
-				  struct acpi_memory_device **mem_device)
-{
-	struct acpi_device *device = NULL;
-	int result = 0;
-
-	acpi_scan_lock_acquire();
-
-	acpi_bus_get_device(handle, &device);
-	if (device)
-		goto end;
-
-	/*
-	 * Now add the notified device.  This creates the acpi_device
-	 * and invokes .add function
-	 */
-	result = acpi_bus_scan(handle);
-	if (result) {
-		acpi_handle_warn(handle, "ACPI namespace scan failed\n");
-		result = -EINVAL;
-		goto out;
-	}
-	result = acpi_bus_get_device(handle, &device);
-	if (result) {
-		acpi_handle_warn(handle, "Missing device object\n");
-		result = -EINVAL;
-		goto out;
-	}
-
- end:
-	*mem_device = acpi_driver_data(device);
-	if (!(*mem_device)) {
-		dev_err(&device->dev, "driver data not found\n");
-		result = -ENODEV;
-		goto out;
-	}
-
- out:
-	acpi_scan_lock_release();
-	return result;
-}
-
 static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
 {
 	unsigned long long current_status;
@@ -306,95 +259,21 @@ static int acpi_memory_remove_memory(str
 	return result;
 }
 
-static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
-{
-	struct acpi_memory_device *mem_device;
-	struct acpi_device *device;
-	struct acpi_eject_event *ej_event = NULL;
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
-	acpi_status status;
-
-	switch (event) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "\nReceived BUS CHECK notification for device\n"));
-		/* Fall Through */
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		if (event == ACPI_NOTIFY_DEVICE_CHECK)
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "\nReceived DEVICE CHECK notification for device\n"));
-		if (acpi_memory_get_device(handle, &mem_device)) {
-			acpi_handle_err(handle, "Cannot find driver data\n");
-			break;
-		}
-
-		ost_code = ACPI_OST_SC_SUCCESS;
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "\nReceived EJECT REQUEST notification for device\n"));
-
-		status = AE_ERROR;
-		acpi_scan_lock_acquire();
-
-		if (acpi_bus_get_device(handle, &device)) {
-			acpi_handle_err(handle, "Device doesn't exist\n");
-			goto unlock;
-		}
-		mem_device = acpi_driver_data(device);
-		if (!mem_device) {
-			acpi_handle_err(handle, "Driver Data is NULL\n");
-			goto unlock;
-		}
-
-		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
-		if (!ej_event) {
-			pr_err(PREFIX "No memory, dropping EJECT\n");
-			goto unlock;
-		}
-
-		get_device(&device->dev);
-		ej_event->device = device;
-		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
-		/* The eject is carried out asynchronously. */
-		status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
-						 ej_event);
-		if (ACPI_FAILURE(status)) {
-			put_device(&device->dev);
-			kfree(ej_event);
-		}
-
- unlock:
-		acpi_scan_lock_release();
-		if (ACPI_SUCCESS(status))
-			return;
-	default:
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Unsupported event [0x%x]\n", event));
-
-		/* non-hotplug event; possibly handled by other handler */
-		return;
-	}
-
-	/* Inform firmware that the hotplug operation has completed */
-	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
-}
-
 static void acpi_memory_device_free(struct acpi_memory_device *mem_device)
 {
 	if (!mem_device)
 		return;
 
 	acpi_memory_free_device_resources(mem_device);
+	mem_device->device->driver_data = NULL;
 	kfree(mem_device);
 }
 
-static int acpi_memory_device_add(struct acpi_device *device)
+static int acpi_memory_device_add(struct acpi_device *device,
+				  const struct acpi_device_id *not_used)
 {
+	struct acpi_memory_device *mem_device;
 	int result;
-	struct acpi_memory_device *mem_device = NULL;
-
 
 	if (!device)
 		return -EINVAL;
@@ -419,147 +298,36 @@ static int acpi_memory_device_add(struct
 	/* Set the device state */
 	mem_device->state = MEMORY_POWER_ON_STATE;
 
-	pr_debug("%s\n", acpi_device_name(device));
+	result = acpi_memory_check_device(mem_device);
+	if (result) {
+		acpi_memory_device_free(mem_device);
+		return 0;
+	}
 
-	if (!acpi_memory_check_device(mem_device)) {
-		/* call add_memory func */
-		result = acpi_memory_enable_device(mem_device);
-		if (result) {
-			dev_err(&device->dev,
-				"Error in acpi_memory_enable_device\n");
-			acpi_memory_device_free(mem_device);
-		}
+	result = acpi_memory_enable_device(mem_device);
+	if (result) {
+		dev_err(&device->dev, "acpi_memory_enable_device() error\n");
+		acpi_memory_device_free(mem_device);
+		return -ENODEV;
 	}
-	return result;
+
+	dev_dbg(&device->dev, "Memory device configured by ACPI\n");
+	return 1;
 }
 
-static int acpi_memory_device_remove(struct acpi_device *device)
+static void acpi_memory_device_remove(struct acpi_device *device)
 {
-	struct acpi_memory_device *mem_device = NULL;
-	int result;
+	struct acpi_memory_device *mem_device;
 
 	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
+		return;
 
 	mem_device = acpi_driver_data(device);
-
-	result = acpi_memory_remove_memory(mem_device);
-	if (result)
-		return result;
-
+	acpi_memory_remove_memory(mem_device);
 	acpi_memory_device_free(mem_device);
-
-	return 0;
-}
-
-/*
- * Helper function to check for memory device
- */
-static acpi_status is_memory_device(acpi_handle handle)
-{
-	char *hardware_id;
-	acpi_status status;
-	struct acpi_device_info *info;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	if (!(info->valid & ACPI_VALID_HID)) {
-		kfree(info);
-		return AE_ERROR;
-	}
-
-	hardware_id = info->hardware_id.string;
-	if ((hardware_id == NULL) ||
-	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
-		status = AE_ERROR;
-
-	kfree(info);
-	return status;
-}
-
-static acpi_status
-acpi_memory_register_notify_handler(acpi_handle handle,
-				    u32 level, void *ctxt, void **retv)
-{
-	acpi_status status;
-
-
-	status = is_memory_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* continue */
-
-	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					     acpi_memory_device_notify, NULL);
-	/* continue */
-	return AE_OK;
-}
-
-static acpi_status
-acpi_memory_deregister_notify_handler(acpi_handle handle,
-				      u32 level, void *ctxt, void **retv)
-{
-	acpi_status status;
-
-
-	status = is_memory_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* continue */
-
-	status = acpi_remove_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    acpi_memory_device_notify);
-
-	return AE_OK;	/* continue */
-}
-
-static int __init acpi_memory_device_init(void)
-{
-	int result;
-	acpi_status status;
-
-
-	result = acpi_bus_register_driver(&acpi_memory_device_driver);
-
-	if (result < 0)
-		return -ENODEV;
-
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX,
-				     acpi_memory_register_notify_handler, NULL,
-				     NULL, NULL);
-
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status, "walk_namespace failed"));
-		acpi_bus_unregister_driver(&acpi_memory_device_driver);
-		return -ENODEV;
-	}
-
-	return 0;
 }
 
-static void __exit acpi_memory_device_exit(void)
+void __init acpi_memory_hotplug_init(void)
 {
-	acpi_status status;
-
-
-	/*
-	 * Adding this to un-install notification handlers for all the device
-	 * handles.
-	 */
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX,
-				     acpi_memory_deregister_notify_handler, NULL,
-				     NULL, NULL);
-
-	if (ACPI_FAILURE(status))
-		ACPI_EXCEPTION((AE_INFO, status, "walk_namespace failed"));
-
-	acpi_bus_unregister_driver(&acpi_memory_device_driver);
-
-	return;
+	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
 }
-
-module_init(acpi_memory_device_init);
-module_exit(acpi_memory_device_exit);
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -35,6 +35,11 @@ void acpi_container_init(void);
 #else
 static inline void acpi_container_init(void) {}
 #endif
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+void acpi_memory_hotplug_init(void);
+#else
+static inline void acpi_memory_hotplug_init(void) {}
+#endif
 
 void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
 				    const char *name);
Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -2024,6 +2024,7 @@ int __init acpi_scan_init(void)
 	acpi_platform_init();
 	acpi_csrt_init();
 	acpi_container_init();
+	acpi_memory_hotplug_init();
 
 	mutex_lock(&acpi_scan_lock);
 	/*

