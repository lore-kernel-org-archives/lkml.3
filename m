Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3KQQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:25:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55278 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751564Ab3KQQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 10/10] ACPI: Introduce acpi_set_device_status()
Date: Sun, 17 Nov 2013 17:38:03 +0100
Message-ID: <6533906.Nyl3k7HNDi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Introduce a static inline function for setting the status field
of struct acpi_device on the basis of a supplied u32 number,
acpi_set_device_status(), and use it instead of the horrible
horrible STRUCT_TO_INT() macro wherever applicable.  Having done
that, drop STRUCT_TO_INT() (and pretend that it has never existed).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |   11 +++--------
 drivers/acpi/scan.c     |    5 ++---
 include/acpi/acpi_bus.h |    5 +++++
 3 files changed, 10 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -52,9 +52,6 @@ struct acpi_device *acpi_root;
 struct proc_dir_entry *acpi_root_dir;
 EXPORT_SYMBOL(acpi_root_dir);
 
-#define STRUCT_TO_INT(s)	(*((int*)&s))
-
-
 #ifdef CONFIG_X86
 static int set_copy_dsdt(const struct dmi_system_id *id)
 {
@@ -115,18 +112,16 @@ int acpi_bus_get_status(struct acpi_devi
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	STRUCT_TO_INT(device->status) = (int) sta;
+	acpi_set_device_status(device, sta);
 
 	if (device->status.functional && !device->status.present) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] status [%08x]: "
 		       "functional but not present;\n",
-			device->pnp.bus_id,
-			(u32) STRUCT_TO_INT(device->status)));
+			device->pnp.bus_id, (u32)sta));
 	}
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] status [%08x]\n",
-			  device->pnp.bus_id,
-			  (u32) STRUCT_TO_INT(device->status)));
+			  device->pnp.bus_id, (u32)sta));
 	return 0;
 }
 EXPORT_SYMBOL(acpi_bus_get_status);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -20,7 +20,6 @@
 
 #define _COMPONENT		ACPI_BUS_COMPONENT
 ACPI_MODULE_NAME("scan");
-#define STRUCT_TO_INT(s)	(*((int*)&s))
 extern struct acpi_device *acpi_root;
 
 #define ACPI_BUS_CLASS			"system_bus"
@@ -1683,7 +1682,7 @@ void acpi_init_device_object(struct acpi
 	device->device_type = type;
 	device->handle = handle;
 	device->parent = acpi_bus_get_parent(handle);
-	STRUCT_TO_INT(device->status) = sta;
+	acpi_set_device_status(device, sta);
 	acpi_device_get_busid(device);
 	acpi_set_pnp_ids(handle, &device->pnp, type);
 	acpi_bus_get_flags(device);
@@ -1927,7 +1926,7 @@ static acpi_status acpi_bus_device_attac
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
-	STRUCT_TO_INT(device->status) = sta;
+	acpi_set_device_status(device, sta);
 	/* Skip devices that are not present. */
 	if (!acpi_device_is_present(device))
 		goto err;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -320,6 +320,11 @@ static inline void *acpi_driver_data(str
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
+static inline void acpi_set_device_status(struct acpi_device *adev, u32 sta)
+{
+	*((u32 *)&adev->status) = sta;
+}
+
 /* acpi_device.dev.bus == &acpi_bus_type */
 extern struct bus_type acpi_bus_type;
 

