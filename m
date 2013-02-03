Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3BCXla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:41:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60229 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab3BCXl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:41:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ACPI / scan: Make memory hotplug driver use struct acpi_scan_handler
Date: Mon, 04 Feb 2013 00:46:02 +0100
Message-ID: <1576039.47sgQOUcLU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3164478.OcagzIMET0@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan> <3164478.OcagzIMET0@vostro.rjw.lan>
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
nodes representing memory.

This simplifies the code and reduces the kernel's memory footprint by
avoiding the registration of a struct device_driver object with the
driver core and creation of its sysfs directory which is unnecessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Kconfig           |    3 
 drivers/acpi/acpi_memhotplug.c |  180 ++++++++++-------------------------------
 drivers/acpi/internal.h        |    5 +
 drivers/acpi/scan.c            |    1 
 4 files changed, 54 insertions(+), 135 deletions(-)

Index: test/drivers/acpi/Kconfig
===================================================================
--- test.orig/drivers/acpi/Kconfig
+++ test/drivers/acpi/Kconfig
@@ -347,9 +347,8 @@ config ACPI_CONTAINER
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
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 2004 Intel Corporation <naveen.b.s@intel.com>
+ * Copyright (C) 2004 Intel Corporation
+ * Author: Naveen B S <naveen.b.s@intel.com>
  *
  * All rights reserved.
  *
@@ -44,17 +45,15 @@
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
@@ -62,14 +61,10 @@ static const struct acpi_device_id memor
 };
 MODULE_DEVICE_TABLE(acpi, memory_device_ids);
 
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
 };
 
 struct acpi_memory_info {
@@ -369,14 +364,15 @@ static void acpi_memory_device_free(stru
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
@@ -401,147 +397,65 @@ static int acpi_memory_device_add(struct
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
 }
 
-/*
- * Helper function to check for memory device
- */
-static acpi_status is_memory_device(acpi_handle handle)
+static bool is_memory_device(acpi_handle handle)
 {
-	char *hardware_id;
-	acpi_status status;
 	struct acpi_device_info *info;
+	bool ret = false;
 
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	if (!(info->valid & ACPI_VALID_HID)) {
-		kfree(info);
-		return AE_ERROR;
-	}
+	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
+		return false;
 
-	hardware_id = info->hardware_id.string;
-	if ((hardware_id == NULL) ||
-	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
-		status = AE_ERROR;
+	if (info->valid & ACPI_VALID_HID)
+		ret = !strcmp(info->hardware_id.string, ACPI_MEMORY_DEVICE_HID);
 
 	kfree(info);
-	return status;
+	return ret;
 }
 
-static acpi_status
-acpi_memory_register_notify_handler(acpi_handle handle,
-				    u32 level, void *ctxt, void **retv)
+static acpi_status acpi_memory_register_notify_handler(acpi_handle handle,
+						       u32 lvl, void *ctxt,
+						       void **retv)
 {
-	acpi_status status;
+	if (is_memory_device(handle))
+		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					    acpi_memory_device_notify, NULL);
 
-
-	status = is_memory_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* continue */
-
-	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					     acpi_memory_device_notify, NULL);
-	/* continue */
 	return AE_OK;
 }
 
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
-}
-
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
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
+			    acpi_memory_register_notify_handler, NULL,
+			    NULL, NULL);
+	acpi_scan_add_handler(&memory_device_handler);
 }
-
-module_init(acpi_memory_device_init);
-module_exit(acpi_memory_device_exit);
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -35,6 +35,11 @@ void acpi_pci_slot_init(void);
 #else
 static inline void acpi_pci_slot_init(void) { }
 #endif
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+void acpi_memory_hotplug_init(void);
+#else
+static inline void acpi_memory_hotplug_init(void) {}
+#endif
 
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *acpi_debugfs_dir;
Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1762,6 +1762,7 @@ int __init acpi_scan_init(void)
 	acpi_pci_slot_init();
 	acpi_platform_init();
 	acpi_csrt_init();
+	acpi_memory_hotplug_init();
 
 	/*
 	 * Enumerate devices in the ACPI namespace.

