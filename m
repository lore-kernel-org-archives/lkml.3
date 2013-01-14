Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3ANVes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:34:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40737 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012Ab3ANVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:33:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCH 3/5] ACPI / scan: Drop the second argument of acpi_bus_trim()
Date: Mon, 14 Jan 2013 22:37:37 +0100
Message-ID: <17666036.y9B2l88LQ8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3885603.ydrrB7OEKf@vostro.rjw.lan>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

All callers of acpi_bus_trim() pass 1 (true) as the second argument
of it, so remove that argument entirely and change acpi_bus_trim()
to always behave as though it were 1.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |    2 +-
 drivers/acpi/scan.c                |   16 ++++------------
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 drivers/pci/hotplug/sgi_hotplug.c  |    2 +-
 include/acpi/acpi_bus.h            |    2 +-
 5 files changed, 9 insertions(+), 17 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -133,7 +133,7 @@ void acpi_bus_hot_remove_device(void *co
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
 
-	if (acpi_bus_trim(device, 1)) {
+	if (acpi_bus_trim(device)) {
 		printk(KERN_ERR PREFIX
 				"Removing device failed\n");
 		goto err_out;
@@ -1425,7 +1425,7 @@ static void acpi_device_set_id(struct ac
 	}
 }
 
-static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
+static int acpi_bus_remove(struct acpi_device *dev)
 {
 	if (!dev)
 		return -EINVAL;
@@ -1433,9 +1433,6 @@ static int acpi_bus_remove(struct acpi_d
 	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
 	device_release_driver(&dev->dev);
 
-	if (!rmdevice)
-		return 0;
-
 	acpi_device_unregister(dev);
 
 	return 0;
@@ -1647,7 +1644,7 @@ int acpi_bus_add(acpi_handle handle)
 }
 EXPORT_SYMBOL(acpi_bus_add);
 
-int acpi_bus_trim(struct acpi_device *start, int rmdevice)
+int acpi_bus_trim(struct acpi_device *start)
 {
 	acpi_status status;
 	struct acpi_device *parent, *child;
@@ -1673,12 +1670,7 @@ int acpi_bus_trim(struct acpi_device *st
 			acpi_get_parent(phandle, &phandle);
 			child = parent;
 			parent = parent->parent;
-
-			if (level == 0)
-				err = acpi_bus_remove(child, rmdevice);
-			else
-				err = acpi_bus_remove(child, 1);
-
+			err = acpi_bus_remove(child);
 			continue;
 		}
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -387,7 +387,7 @@ int acpi_bus_register_driver(struct acpi
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_add(acpi_handle handle);
 void acpi_bus_hot_remove_device(void *context);
-int acpi_bus_trim(struct acpi_device *start, int rmdevice);
+int acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -339,7 +339,7 @@ static void dock_remove_acpi_device(acpi
 	int ret;
 
 	if (!acpi_bus_get_device(handle, &device)) {
-		ret = acpi_bus_trim(device, 1);
+		ret = acpi_bus_trim(device);
 		if (ret)
 			pr_debug("error removing bus, %x\n", -ret);
 	}
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -742,7 +742,7 @@ static int acpiphp_bus_add(struct acpiph
 		/* this shouldn't be in here, so remove
 		 * the bus then re-add it...
 		 */
-		ret_val = acpi_bus_trim(device, 1);
+		ret_val = acpi_bus_trim(device);
 		dbg("acpi_bus_trim return %x\n", ret_val);
 	}
 
@@ -772,7 +772,7 @@ static int acpiphp_bus_trim(acpi_handle
 		return retval;
 	}
 
-	retval = acpi_bus_trim(device, 1);
+	retval = acpi_bus_trim(device);
 	if (retval)
 		err("cannot remove from acpi list\n");
 
Index: linux-pm/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux-pm/drivers/pci/hotplug/sgi_hotplug.c
@@ -535,7 +535,7 @@ static int disable_slot(struct hotplug_s
 				ret = acpi_bus_get_device(chandle,
 							  &device);
 				if (ACPI_SUCCESS(ret))
-					acpi_bus_trim(device, 1);
+					acpi_bus_trim(device);
 			}
 		}
 
