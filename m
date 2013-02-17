Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3BQPWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:22:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39045 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab3BQPVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 3/7] ACPI / container: Use common hotplug code
Date: Sun, 17 Feb 2013 16:22:37 +0100
Message-ID: <1952859.usdjHblmSJ@vostro.rjw.lan>
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

Switch the ACPI container driver to using common device hotplug code
introduced previously.  This reduces the driver down to a trivial
definition and registration of a struct acpi_scan_handler object.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/container.c |  146 +++--------------------------------------------
 1 file changed, 10 insertions(+), 136 deletions(-)

Index: test/drivers/acpi/container.c
===================================================================
--- test.orig/drivers/acpi/container.c
+++ test/drivers/acpi/container.c
@@ -1,12 +1,12 @@
 /*
- * acpi_container.c  - ACPI Generic Container Driver
- * ($Revision: )
+ * container.c  - ACPI Generic Container Driver
  *
  * Copyright (C) 2004 Anil S Keshavamurthy (anil.s.keshavamurthy@intel.com)
  * Copyright (C) 2004 Keiichiro Tokunaga (tokunaga.keiich@jp.fujitsu.com)
  * Copyright (C) 2004 Motoyuki Ito (motoyuki@soft.fujitsu.com)
- * Copyright (C) 2004 Intel Corp.
  * Copyright (C) 2004 FUJITSU LIMITED
+ * Copyright (C) 2004, 2013 Intel Corp.
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
@@ -26,14 +26,9 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/types.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+
+#include "internal.h"
 
 #define PREFIX "ACPI: "
 
@@ -50,141 +45,20 @@ static const struct acpi_device_id conta
 static int container_device_attach(struct acpi_device *device,
 				   const struct acpi_device_id *not_used)
 {
-	/*
-	 * FIXME: This is necessary, so that acpi_eject_store() doesn't return
-	 * -ENODEV for containers.
-	 */
+	/* This is necessary for container hotplug to work. */
 	return 1;
 }
 
 static struct acpi_scan_handler container_device_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
+	.hotplug = {
+		.enabled = true,
+		.uevents = true,
+	},
 };
 
-static int is_device_present(acpi_handle handle)
-{
-	acpi_handle temp;
-	acpi_status status;
-	unsigned long long sta;
-
-
-	status = acpi_get_handle(handle, "_STA", &temp);
-	if (ACPI_FAILURE(status))
-		return 1;	/* _STA not found, assume device present */
-
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status))
-		return 0;	/* Firmware error */
-
-	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
-}
-
-static void container_notify_cb(acpi_handle handle, u32 type, void *context)
-{
-	struct acpi_device *device = NULL;
-	int result;
-	int present;
-	acpi_status status;
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
-
-	acpi_scan_lock_acquire();
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		/* Fall through */
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		pr_debug("Container driver received %s event\n",
-		       (type == ACPI_NOTIFY_BUS_CHECK) ?
-		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
-
-		present = is_device_present(handle);
-		status = acpi_bus_get_device(handle, &device);
-		if (!present) {
-			if (ACPI_SUCCESS(status)) {
-				/* device exist and this is a remove request */
-				device->flags.eject_pending = 1;
-				kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-				goto out;
-			}
-			break;
-		}
-
-		if (!ACPI_FAILURE(status) || device)
-			break;
-
-		result = acpi_bus_scan(handle);
-		if (result) {
-			acpi_handle_warn(handle, "Failed to add container\n");
-			break;
-		}
-		result = acpi_bus_get_device(handle, &device);
-		if (result) {
-			acpi_handle_warn(handle, "Missing device object\n");
-			break;
-		}
-
-		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
-		ost_code = ACPI_OST_SC_SUCCESS;
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		if (!acpi_bus_get_device(handle, &device) && device) {
-			device->flags.eject_pending = 1;
-			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-			goto out;
-		}
-		break;
-
-	default:
-		/* non-hotplug event; possibly handled by other handler */
-		goto out;
-	}
-
-	/* Inform firmware that the hotplug operation has completed */
-	(void) acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
-
- out:
-	acpi_scan_lock_release();
-}
-
-static bool is_container(acpi_handle handle)
-{
-	struct acpi_device_info *info;
-	bool ret = false;
-
-	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
-		return false;
-
-	if (info->valid & ACPI_VALID_HID) {
-		const struct acpi_device_id *id;
-
-		for (id = container_device_ids; id->id[0]; id++) {
-			ret = !strcmp((char *)id->id, info->hardware_id.string);
-			if (ret)
-				break;
-		}
-	}
-	kfree(info);
-	return ret;
-}
-
-static acpi_status acpi_container_register_notify_handler(acpi_handle handle,
-							  u32 lvl, void *ctxt,
-							  void **retv)
-{
-	if (is_container(handle))
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					    container_notify_cb, NULL);
-
-	return AE_OK;
-}
-
 void __init acpi_container_init(void)
 {
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
-			    acpi_container_register_notify_handler, NULL,
-			    NULL, NULL);
-
 	acpi_scan_add_handler(&container_device_handler);
 }

