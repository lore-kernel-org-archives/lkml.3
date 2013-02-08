Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3BHAVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:21:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60230 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3BHAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:21:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 2/2] ACPI / scan: Make container driver use struct acpi_scan_handler
Date: Fri, 08 Feb 2013 01:27:30 +0100
Message-ID: <6697533.ch61jtPBiZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1468930.acVuhKfKYv@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <5090866.2BHgpRnuEZ@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the ACPI container driver use struct acpi_scan_handler for
representing the object used to initialize ACPI containers and remove
the ACPI driver structure used previously and the data structures
created by it, since in fact they were not used for any purpose.

This simplifies the code and reduces the kernel's memory footprint by
avoiding the registration of a struct device_driver object with the
driver core and creation of its sysfs directory which is unnecessary.

In addition to that, make the namespace walk callback used for
installing the notify handlers for ACPI containers more
straightforward.

This change includes fixes from Toshi Kani.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Kconfig     |    2 
 drivers/acpi/container.c |  167 ++++++++++-------------------------------------
 drivers/acpi/internal.h  |    5 +
 drivers/acpi/scan.c      |    1 
 4 files changed, 43 insertions(+), 132 deletions(-)

Index: test/drivers/acpi/container.c
===================================================================
--- test.orig/drivers/acpi/container.c
+++ test/drivers/acpi/container.c
@@ -38,42 +38,31 @@
 
 #define PREFIX "ACPI: "
 
-#define ACPI_CONTAINER_DEVICE_NAME	"ACPI container device"
-#define ACPI_CONTAINER_CLASS		"container"
-
-#define INSTALL_NOTIFY_HANDLER		1
-#define UNINSTALL_NOTIFY_HANDLER	2
-
 #define _COMPONENT			ACPI_CONTAINER_COMPONENT
 ACPI_MODULE_NAME("container");
 
-MODULE_AUTHOR("Anil S Keshavamurthy");
-MODULE_DESCRIPTION("ACPI container driver");
-MODULE_LICENSE("GPL");
-
-static int acpi_container_add(struct acpi_device *device);
-static int acpi_container_remove(struct acpi_device *device);
-
 static const struct acpi_device_id container_device_ids[] = {
 	{"ACPI0004", 0},
 	{"PNP0A05", 0},
 	{"PNP0A06", 0},
 	{"", 0},
 };
-MODULE_DEVICE_TABLE(acpi, container_device_ids);
 
-static struct acpi_driver acpi_container_driver = {
-	.name = "container",
-	.class = ACPI_CONTAINER_CLASS,
+static int container_device_attach(struct acpi_device *device,
+				   const struct acpi_device_id *not_used)
+{
+	/*
+	 * FIXME: This is necessary, so that acpi_eject_store() doesn't return
+	 * -ENODEV for containers.
+	 */
+	return 1;
+}
+
+static struct acpi_scan_handler container_device_handler = {
 	.ids = container_device_ids,
-	.ops = {
-		.add = acpi_container_add,
-		.remove = acpi_container_remove,
-		},
+	.attach = container_device_attach,
 };
 
-/*******************************************************************/
-
 static int is_device_present(acpi_handle handle)
 {
 	acpi_handle temp;
@@ -92,49 +81,6 @@ static int is_device_present(acpi_handle
 	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
-static bool is_container_device(const char *hid)
-{
-	const struct acpi_device_id *container_id;
-
-	for (container_id = container_device_ids;
-	     container_id->id[0]; container_id++) {
-		if (!strcmp((char *)container_id->id, hid))
-			return true;
-	}
-
-	return false;
-}
-
-/*******************************************************************/
-static int acpi_container_add(struct acpi_device *device)
-{
-	struct acpi_container *container;
-
-	container = kzalloc(sizeof(struct acpi_container), GFP_KERNEL);
-	if (!container)
-		return -ENOMEM;
-
-	container->handle = device->handle;
-	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
-	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
-	device->driver_data = container;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
-			  acpi_device_name(device), acpi_device_bid(device)));
-
-	return 0;
-}
-
-static int acpi_container_remove(struct acpi_device *device)
-{
-	acpi_status status = AE_OK;
-	struct acpi_container *pc = NULL;
-
-	pc = acpi_driver_data(device);
-	kfree(pc);
-	return status;
-}
-
 static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 {
 	struct acpi_device *device = NULL;
@@ -199,84 +145,43 @@ static void container_notify_cb(acpi_han
 	return;
 }
 
-static acpi_status
-container_walk_namespace_cb(acpi_handle handle,
-			    u32 lvl, void *context, void **rv)
+static bool is_container(acpi_handle handle)
 {
-	char *hid = NULL;
 	struct acpi_device_info *info;
-	acpi_status status;
-	int *action = context;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status)) {
-		return AE_OK;
-	}
+	bool ret = false;
 
-	if (info->valid & ACPI_VALID_HID)
-		hid = info->hardware_id.string;
+	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
+		return false;
 
-	if (hid == NULL) {
-		goto end;
-	}
-
-	if (!is_container_device(hid))
-		goto end;
+	if (info->valid & ACPI_VALID_HID) {
+		const struct acpi_device_id *id;
 
-	switch (*action) {
-	case INSTALL_NOTIFY_HANDLER:
-		acpi_install_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    container_notify_cb, NULL);
-		break;
-	case UNINSTALL_NOTIFY_HANDLER:
-		acpi_remove_notify_handler(handle,
-					   ACPI_SYSTEM_NOTIFY,
-					   container_notify_cb);
-		break;
-	default:
-		break;
+		for (id = container_device_ids; id->id[0]; id++) {
+			ret = !strcmp((char *)id->id, info->hardware_id.string);
+			if (ret)
+				break;
+		}
 	}
-
-      end:
 	kfree(info);
-
-	return AE_OK;
+	return ret;
 }
 
-static int __init acpi_container_init(void)
+static acpi_status acpi_container_register_notify_handler(acpi_handle handle,
+							  u32 lvl, void *ctxt,
+							  void **retv)
 {
-	int result = 0;
-	int action = INSTALL_NOTIFY_HANDLER;
-
-	result = acpi_bus_register_driver(&acpi_container_driver);
-	if (result < 0) {
-		return (result);
-	}
-
-	/* register notify handler to every container device */
-	acpi_walk_namespace(ACPI_TYPE_DEVICE,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    container_walk_namespace_cb, NULL, &action, NULL);
+	if (is_container(handle))
+		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					    container_notify_cb, NULL);
 
-	return (0);
+	return AE_OK;
 }
 
-static void __exit acpi_container_exit(void)
+void __init acpi_container_init(void)
 {
-	int action = UNINSTALL_NOTIFY_HANDLER;
-
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    container_walk_namespace_cb, NULL, &action, NULL);
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
+			    acpi_container_register_notify_handler, NULL,
+			    NULL, NULL);
 
-	acpi_bus_unregister_driver(&acpi_container_driver);
-
-	return;
+	acpi_scan_add_handler(&container_device_handler);
 }
-
-module_init(acpi_container_init);
-module_exit(acpi_container_exit);
Index: test/drivers/acpi/Kconfig
===================================================================
--- test.orig/drivers/acpi/Kconfig
+++ test/drivers/acpi/Kconfig
@@ -334,7 +334,7 @@ config X86_PM_TIMER
 	  systems require this timer. 
 
 config ACPI_CONTAINER
-	tristate "Container and Module Devices (EXPERIMENTAL)"
+	bool "Container and Module Devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
 	help
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -35,6 +35,11 @@ void acpi_pci_slot_init(void);
 #else
 static inline void acpi_pci_slot_init(void) { }
 #endif
+#ifdef CONFIG_ACPI_CONTAINER
+void acpi_container_init(void);
+#else
+static inline void acpi_container_init(void) {}
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
+	acpi_container_init();
 
 	/*
 	 * Enumerate devices in the ACPI namespace.

