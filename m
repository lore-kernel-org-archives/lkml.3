Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3ANGKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 01:10:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:56011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3ANGKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 01:10:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="scan'208,223";a="276506643"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V3 2/2] Xen ACPI memory hotplug
Thread-Topic: [PATCH V3 2/2] Xen ACPI memory hotplug
Thread-Index: Ac3yHeHpCTGxaz8oQTSp4S/1fI5jvg==
Date: Mon, 14 Jan 2013 06:10:43 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C24E4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353C24E4SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353C24E4SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From f33394556e8c642d5c146a3db244f6e8619748a4 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 8 Jan 2013 11:18:17 +0800
Subject: [PATCH 2/2] Xen ACPI memory hotplug

This patch implements real Xen acpi memory hotplug driver as module.
When loaded, it replaces Xen stub driver.

When an acpi memory device hotadd event occurs, it notifies OS and
invokes notification callback, adding related memory device and parsing
memory information, finally hypercall to xen hypervisor to add memory.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig               |   11 +
 drivers/xen/Makefile              |    1 +
 drivers/xen/xen-acpi-memhotplug.c |  501 +++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h  |   13 +-
 4 files changed, 522 insertions(+), 4 deletions(-)
 create mode 100644 drivers/xen/xen-acpi-memhotplug.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 1dcb5fc..2dc7022 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -191,6 +191,17 @@ config XEN_STUB
=20
 	  To enable Xen features like cpu and memory hotplug, select Y here.
=20
+config XEN_ACPI_HOTPLUG_MEMORY
+	tristate "Xen ACPI memory hotplug"
+	depends on XEN_STUB && ACPI
+	default n
+	help
+	  This is Xen ACPI memory hotplug.
+
+	  Currently Xen only support ACPI memory hot-add. If you want
+	  to hot-add memory at runtime (the hot-added memory cannot be
+	  removed until machine stop), select Y/M here, otherwise select N.
+
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index b63edd8..1605f59 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_STUB)			+=3D xen-stub.o
+obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+=3D xen-acpi-memhotplug.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
new file mode 100644
index 0000000..346d80b
--- /dev/null
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -0,0 +1,501 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *    Author: Liu Jinsong <jinsong.liu@intel.com>
+ *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include <xen/acpi.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+
+#define PREFIX "ACPI:xen_memory_hotplug:"
+
+struct acpi_memory_info {
+	struct list_head list;
+	u64 start_addr;		/* Memory Range start physical addr */
+	u64 length;		/* Memory Range length */
+	unsigned short caching;	/* memory cache attribute */
+	unsigned short write_protect;	/* memory read/write attribute */
+				/* copied from buffer getting from _CRS */
+	unsigned int enabled:1;
+};
+
+struct acpi_memory_device {
+	struct acpi_device *device;
+	struct list_head res_list;
+};
+
+static bool acpi_hotmem_initialized __read_mostly;
+
+static int xen_hotadd_memory(int pxm, struct acpi_memory_info *info)
+{
+	int rc;
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_mem_hotadd;
+	op.u.mem_add.spfn =3D info->start_addr >> PAGE_SHIFT;
+	op.u.mem_add.epfn =3D (info->start_addr + info->length) >> PAGE_SHIFT;
+	op.u.mem_add.pxm =3D pxm;
+
+	rc =3D HYPERVISOR_dom0_op(&op);
+	if (rc)
+		pr_err(PREFIX "Xen Hotplug Memory Add failed on "
+			"0x%lx -> 0x%lx, _PXM: %d, error: %d\n",
+			(unsigned long)info->start_addr,
+			(unsigned long)(info->start_addr + info->length),
+			pxm, rc);
+
+	return rc;
+}
+
+static int xen_acpi_get_pxm(acpi_handle h)
+{
+	unsigned long long pxm;
+	acpi_status status;
+	acpi_handle handle;
+	acpi_handle phandle =3D h;
+
+	do {
+		handle =3D phandle;
+		status =3D acpi_evaluate_integer(handle, "_PXM", NULL, &pxm);
+		if (ACPI_SUCCESS(status))
+			return pxm;
+		status =3D acpi_get_parent(handle, &phandle);
+	} while (ACPI_SUCCESS(status));
+
+	return -ENXIO;
+}
+
+static int xen_acpi_memory_enable_device(struct acpi_memory_device *mem_de=
vice)
+{
+	int pxm, result;
+	int num_enabled =3D 0;
+	struct acpi_memory_info *info;
+
+	if (!mem_device)
+		return -EINVAL;
+
+	pxm =3D xen_acpi_get_pxm(mem_device->device->handle);
+	if (pxm < 0)
+		return pxm;
+
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		if (info->enabled) { /* just sanity check...*/
+			num_enabled++;
+			continue;
+		}
+
+		if (!info->length)
+			continue;
+
+		result =3D xen_hotadd_memory(pxm, info);
+		if (result)
+			continue;
+		info->enabled =3D 1;
+		num_enabled++;
+	}
+
+	if (!num_enabled)
+		return -ENODEV;
+
+	return 0;
+}
+
+static acpi_status
+acpi_memory_get_resource(struct acpi_resource *resource, void *context)
+{
+	struct acpi_memory_device *mem_device =3D context;
+	struct acpi_resource_address64 address64;
+	struct acpi_memory_info *info, *new;
+	acpi_status status;
+
+	status =3D acpi_resource_to_address64(resource, &address64);
+	if (ACPI_FAILURE(status) ||
+	    (address64.resource_type !=3D ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		if ((info->caching =3D=3D address64.info.mem.caching) &&
+		    (info->write_protect =3D=3D address64.info.mem.write_protect) &&
+		    (info->start_addr + info->length =3D=3D address64.minimum)) {
+			info->length +=3D address64.address_length;
+			return AE_OK;
+		}
+	}
+
+	new =3D kzalloc(sizeof(struct acpi_memory_info), GFP_KERNEL);
+	if (!new)
+		return AE_ERROR;
+
+	INIT_LIST_HEAD(&new->list);
+	new->caching =3D address64.info.mem.caching;
+	new->write_protect =3D address64.info.mem.write_protect;
+	new->start_addr =3D address64.minimum;
+	new->length =3D address64.address_length;
+	list_add_tail(&new->list, &mem_device->res_list);
+
+	return AE_OK;
+}
+
+static int
+acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
+{
+	acpi_status status;
+	struct acpi_memory_info *info, *n;
+
+	if (!list_empty(&mem_device->res_list))
+		return 0;
+
+	status =3D acpi_walk_resources(mem_device->device->handle,
+		METHOD_NAME__CRS, acpi_memory_get_resource, mem_device);
+
+	if (ACPI_FAILURE(status)) {
+		list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+			kfree(info);
+		INIT_LIST_HEAD(&mem_device->res_list);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+acpi_memory_get_device(acpi_handle handle,
+		       struct acpi_memory_device **mem_device)
+{
+	acpi_status status;
+	acpi_handle phandle;
+	struct acpi_device *device =3D NULL;
+	struct acpi_device *pdevice =3D NULL;
+	int result;
+
+	if (!acpi_bus_get_device(handle, &device) && device)
+		goto end;
+
+	status =3D acpi_get_parent(handle, &phandle);
+	if (ACPI_FAILURE(status)) {
+		pr_warn(PREFIX "Cannot find acpi parent\n");
+		return -EINVAL;
+	}
+
+	/* Get the parent device */
+	result =3D acpi_bus_get_device(phandle, &pdevice);
+	if (result) {
+		pr_warn(PREFIX "Cannot get acpi bus device\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Now add the notified device.  This creates the acpi_device
+	 * and invokes .add function
+	 */
+	result =3D acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	if (result) {
+		pr_warn(PREFIX "Cannot add acpi bus\n");
+		return -EINVAL;
+	}
+
+end:
+	*mem_device =3D acpi_driver_data(device);
+	if (!(*mem_device)) {
+		pr_err(PREFIX "Driver data not found\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
+{
+	unsigned long long current_status;
+
+	/* Get device present/absent information from the _STA */
+	if (ACPI_FAILURE(acpi_evaluate_integer(mem_device->device->handle,
+				"_STA", NULL, &current_status)))
+		return -ENODEV;
+	/*
+	 * Check for device status. Device should be
+	 * present/enabled/functioning.
+	 */
+	if (!((current_status & ACPI_STA_DEVICE_PRESENT)
+	      && (current_status & ACPI_STA_DEVICE_ENABLED)
+	      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int acpi_memory_disable_device(struct acpi_memory_device *mem_devic=
e)
+{
+	pr_debug(PREFIX "Xen does not support memory hotremove\n");
+
+	return -ENOSYS;
+}
+
+static void acpi_memory_device_notify(acpi_handle handle, u32 event, void =
*data)
+{
+	struct acpi_memory_device *mem_device;
+	struct acpi_device *device;
+	u32 ost_code =3D ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
+
+	switch (event) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived BUS CHECK notification for device\n"));
+		/* Fall Through */
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		if (event =3D=3D ACPI_NOTIFY_DEVICE_CHECK)
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived DEVICE CHECK notification for device\n"));
+
+		if (acpi_memory_get_device(handle, &mem_device)) {
+			pr_err(PREFIX "Cannot find driver data\n");
+			break;
+		}
+
+		ost_code =3D ACPI_OST_SC_SUCCESS;
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived EJECT REQUEST notification for device\n"));
+
+		if (acpi_bus_get_device(handle, &device)) {
+			pr_err(PREFIX "Device doesn't exist\n");
+			break;
+		}
+		mem_device =3D acpi_driver_data(device);
+		if (!mem_device) {
+			pr_err(PREFIX "Driver Data is NULL\n");
+			break;
+		}
+
+		/*
+		 * TBD: implement acpi_memory_disable_device and invoke
+		 * acpi_bus_remove if Xen support hotremove in the future
+		 */
+		acpi_memory_disable_device(mem_device);
+		break;
+
+	default:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Unsupported event [0x%x]\n", event));
+		/* non-hotplug event; possibly handled by other handler */
+		return;
+	}
+
+	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
+	return;
+}
+
+static int xen_acpi_memory_device_add(struct acpi_device *device)
+{
+	int result;
+	struct acpi_memory_device *mem_device =3D NULL;
+
+
+	if (!device)
+		return -EINVAL;
+
+	mem_device =3D kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
+	if (!mem_device)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mem_device->res_list);
+	mem_device->device =3D device;
+	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
+	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
+	device->driver_data =3D mem_device;
+
+	/* Get the range from the _CRS */
+	result =3D acpi_memory_get_device_resources(mem_device);
+	if (result) {
+		kfree(mem_device);
+		return result;
+	}
+
+	/*
+	 * For booting existed memory devices, early boot code has recognized
+	 * memory area by EFI/E820. If DSDT shows these memory devices on boot,
+	 * hotplug is not necessary for them.
+	 * For hot-added memory devices during runtime, it need hypercall to
+	 * Xen hypervisor to add memory.
+	 */
+	if (!acpi_hotmem_initialized)
+		return 0;
+
+	if (!acpi_memory_check_device(mem_device))
+		result =3D xen_acpi_memory_enable_device(mem_device);
+
+	return result;
+}
+
+static int xen_acpi_memory_device_remove(struct acpi_device *device, int t=
ype)
+{
+	struct acpi_memory_device *mem_device =3D NULL;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	mem_device =3D acpi_driver_data(device);
+	kfree(mem_device);
+
+	return 0;
+}
+
+/*
+ * Helper function to check for memory device
+ */
+static acpi_status is_memory_device(acpi_handle handle)
+{
+	char *hardware_id;
+	acpi_status status;
+	struct acpi_device_info *info;
+
+	status =3D acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (!(info->valid & ACPI_VALID_HID)) {
+		kfree(info);
+		return AE_ERROR;
+	}
+
+	hardware_id =3D info->hardware_id.string;
+	if ((hardware_id =3D=3D NULL) ||
+	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
+		status =3D AE_ERROR;
+
+	kfree(info);
+	return status;
+}
+
+static acpi_status
+acpi_memory_register_notify_handler(acpi_handle handle,
+				    u32 level, void *ctxt, void **retv)
+{
+	acpi_status status;
+
+	status =3D is_memory_device(handle);
+	if (ACPI_FAILURE(status))
+		return AE_OK;	/* continue */
+
+	status =3D acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					     acpi_memory_device_notify, NULL);
+	/* continue */
+	return AE_OK;
+}
+
+static acpi_status
+acpi_memory_deregister_notify_handler(acpi_handle handle,
+				      u32 level, void *ctxt, void **retv)
+{
+	acpi_status status;
+
+	status =3D is_memory_device(handle);
+	if (ACPI_FAILURE(status))
+		return AE_OK;	/* continue */
+
+	status =3D acpi_remove_notify_handler(handle,
+					    ACPI_SYSTEM_NOTIFY,
+					    acpi_memory_device_notify);
+
+	return AE_OK;	/* continue */
+}
+
+static const struct acpi_device_id memory_device_ids[] =3D {
+	{ACPI_MEMORY_DEVICE_HID, 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, memory_device_ids);
+
+static struct acpi_driver xen_acpi_memory_device_driver =3D {
+	.name =3D "acpi_memhotplug",
+	.class =3D ACPI_MEMORY_DEVICE_CLASS,
+	.ids =3D memory_device_ids,
+	.ops =3D {
+		.add =3D xen_acpi_memory_device_add,
+		.remove =3D xen_acpi_memory_device_remove,
+		},
+};
+
+static int __init xen_acpi_memory_device_init(void)
+{
+	int result;
+	acpi_status status;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* unregister the stub which only used to reserve driver space */
+	acpi_bus_unregister_driver(&xen_stub_memory_device_driver);
+
+	result =3D acpi_bus_register_driver(&xen_acpi_memory_device_driver);
+	if (result < 0) {
+		acpi_bus_register_driver(&xen_stub_memory_device_driver);
+		return -ENODEV;
+	}
+
+	status =3D acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX,
+				     acpi_memory_register_notify_handler,
+				     NULL, NULL, NULL);
+
+	if (ACPI_FAILURE(status)) {
+		pr_warn(PREFIX "walk_namespace failed\n");
+		acpi_bus_unregister_driver(&xen_acpi_memory_device_driver);
+		acpi_bus_register_driver(&xen_stub_memory_device_driver);
+		return -ENODEV;
+	}
+
+	acpi_hotmem_initialized =3D true;
+	return 0;
+}
+
+static void __exit xen_acpi_memory_device_exit(void)
+{
+	acpi_status status;
+
+	if (!xen_initial_domain())
+		return;
+
+	status =3D acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX,
+				     acpi_memory_deregister_notify_handler,
+				     NULL, NULL, NULL);
+	if (ACPI_FAILURE(status))
+		pr_warn(PREFIX "walk_namespace failed\n");
+
+	acpi_bus_unregister_driver(&xen_acpi_memory_device_driver);
+
+	/*
+	 * stub reserve space again to prevent any chance of native
+	 * driver loading.
+	 */
+	acpi_bus_register_driver(&xen_stub_memory_device_driver);
+	return;
+}
+
+module_init(xen_acpi_memory_device_init);
+module_exit(xen_acpi_memory_device_exit);
+ACPI_MODULE_NAME("xen-acpi-memhotplug");
+MODULE_AUTHOR("Liu Jinsong <jinsong.liu@intel.com>");
+MODULE_DESCRIPTION("Xen Hotplug Mem Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 5e36932..2c4fb4b 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,10 +324,14 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
-/*
- * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
- * which are already occupied at Xen hypervisor side.
- */
+#define XENPF_mem_hotadd	59
+struct xenpf_mem_hotadd {
+	uint64_t spfn;
+	uint64_t epfn;
+	uint32_t pxm;
+	uint32_t flags;
+};
+
 #define XENPF_core_parking     60
 struct xenpf_core_parking {
 	/* IN variables */
@@ -357,6 +361,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		uint8_t                        pad[128];
 	} u;
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353C24E4SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Xen-ACPI-memory-hotplug.patch"
Content-Description: 0002-Xen-ACPI-memory-hotplug.patch
Content-Disposition: attachment;
	filename="0002-Xen-ACPI-memory-hotplug.patch"; size=16371;
	creation-date="Mon, 14 Jan 2013 06:06:53 GMT";
	modification-date="Mon, 14 Jan 2013 13:58:48 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmMzMzOTQ1NTZlOGM2NDJkNWMxNDZhM2RiMjQ0ZjZlODYxOTc0OGE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDggSmFuIDIwMTMgMTE6MTg6MTcgKzA4MDAKU3ViamVjdDogW1BBVENIIDIvMl0g
WGVuIEFDUEkgbWVtb3J5IGhvdHBsdWcKClRoaXMgcGF0Y2ggaW1wbGVtZW50cyByZWFsIFhlbiBh
Y3BpIG1lbW9yeSBob3RwbHVnIGRyaXZlciBhcyBtb2R1bGUuCldoZW4gbG9hZGVkLCBpdCByZXBs
YWNlcyBYZW4gc3R1YiBkcml2ZXIuCgpXaGVuIGFuIGFjcGkgbWVtb3J5IGRldmljZSBob3RhZGQg
ZXZlbnQgb2NjdXJzLCBpdCBub3RpZmllcyBPUyBhbmQKaW52b2tlcyBub3RpZmljYXRpb24gY2Fs
bGJhY2ssIGFkZGluZyByZWxhdGVkIG1lbW9yeSBkZXZpY2UgYW5kIHBhcnNpbmcKbWVtb3J5IGlu
Zm9ybWF0aW9uLCBmaW5hbGx5IGh5cGVyY2FsbCB0byB4ZW4gaHlwZXJ2aXNvciB0byBhZGQgbWVt
b3J5LgoKU2lnbmVkLW9mZi1ieTogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
LS0tCiBkcml2ZXJzL3hlbi9LY29uZmlnICAgICAgICAgICAgICAgfCAgIDExICsKIGRyaXZlcnMv
eGVuL01ha2VmaWxlICAgICAgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy94ZW4veGVuLWFjcGkt
bWVtaG90cGx1Zy5jIHwgIDUwMSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaCAgfCAgIDEzICstCiA0IGZpbGVzIGNo
YW5nZWQsIDUyMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAw
NjQ0IGRyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYwoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMveGVuL0tjb25maWcgYi9kcml2ZXJzL3hlbi9LY29uZmlnCmluZGV4IDFkY2I1ZmMuLjJkYzcw
MjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL0tjb25maWcKKysrIGIvZHJpdmVycy94ZW4vS2Nv
bmZpZwpAQCAtMTkxLDYgKzE5MSwxNyBAQCBjb25maWcgWEVOX1NUVUIKIAogCSAgVG8gZW5hYmxl
IFhlbiBmZWF0dXJlcyBsaWtlIGNwdSBhbmQgbWVtb3J5IGhvdHBsdWcsIHNlbGVjdCBZIGhlcmUu
CiAKK2NvbmZpZyBYRU5fQUNQSV9IT1RQTFVHX01FTU9SWQorCXRyaXN0YXRlICJYZW4gQUNQSSBt
ZW1vcnkgaG90cGx1ZyIKKwlkZXBlbmRzIG9uIFhFTl9TVFVCICYmIEFDUEkKKwlkZWZhdWx0IG4K
KwloZWxwCisJICBUaGlzIGlzIFhlbiBBQ1BJIG1lbW9yeSBob3RwbHVnLgorCisJICBDdXJyZW50
bHkgWGVuIG9ubHkgc3VwcG9ydCBBQ1BJIG1lbW9yeSBob3QtYWRkLiBJZiB5b3Ugd2FudAorCSAg
dG8gaG90LWFkZCBtZW1vcnkgYXQgcnVudGltZSAodGhlIGhvdC1hZGRlZCBtZW1vcnkgY2Fubm90
IGJlCisJICByZW1vdmVkIHVudGlsIG1hY2hpbmUgc3RvcCksIHNlbGVjdCBZL00gaGVyZSwgb3Ro
ZXJ3aXNlIHNlbGVjdCBOLgorCiBjb25maWcgWEVOX0FDUElfUFJPQ0VTU09SCiAJdHJpc3RhdGUg
IlhlbiBBQ1BJIHByb2Nlc3NvciIKIAlkZXBlbmRzIG9uIFhFTiAmJiBYODYgJiYgQUNQSV9QUk9D
RVNTT1IgJiYgQ1BVX0ZSRVEKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJp
dmVycy94ZW4vTWFrZWZpbGUKaW5kZXggYjYzZWRkOC4uMTYwNWY1OSAxMDA2NDQKLS0tIGEvZHJp
dmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTMxLDYgKzMx
LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9NQ0VfTE9HKQkJKz0gbWNlbG9nLm8KIG9iai0kKENPTkZJ
R19YRU5fUENJREVWX0JBQ0tFTkQpCSs9IHhlbi1wY2liYWNrLwogb2JqLSQoQ09ORklHX1hFTl9Q
UklWQ01EKQkJKz0geGVuLXByaXZjbWQubwogb2JqLSQoQ09ORklHX1hFTl9TVFVCKQkJCSs9IHhl
bi1zdHViLm8KK29iai0kKENPTkZJR19YRU5fQUNQSV9IT1RQTFVHX01FTU9SWSkJKz0geGVuLWFj
cGktbWVtaG90cGx1Zy5vCiBvYmotJChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkrPSB4ZW4t
YWNwaS1wcm9jZXNzb3IubwogeGVuLWV2dGNobi15CQkJCTo9IGV2dGNobi5vCiB4ZW4tZ250ZGV2
LXkJCQkJOj0gZ250ZGV2Lm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhv
dHBsdWcuYyBiL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi4zNDZkODBiCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy94ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jCkBAIC0wLDAgKzEsNTAxIEBACisvKgorICogQ29w
eXJpZ2h0IChDKSAyMDEyIEludGVsIENvcnBvcmF0aW9uCisgKiAgICBBdXRob3I6IExpdSBKaW5z
b25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiAgICBBdXRob3I6IEppYW5nIFl1bmhvbmcg
PHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNv
ZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisgKiBpdCB1bmRl
ciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hl
ZCBieQorICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBv
ZiB0aGUgTGljZW5zZSwgb3IgKGF0CisgKiB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
CisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQg
d2lsbCBiZSB1c2VmdWwsIGJ1dAorICogV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZl
biB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogTUVSQ0hBTlRBQklMSVRZIE9SIEZJVE5FU1Mg
Rk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLCBHT09EIFRJVExFIG9yCisgKiBOT04gSU5GUklOR0VN
RU5ULiAgU2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZQorICogZGV0
YWlscy4KKyAqLworCisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgv
bW9kdWxlLmg+CisjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVz
Lmg+CisjaW5jbHVkZSA8bGludXgvYWNwaS5oPgorI2luY2x1ZGUgPGFjcGkvYWNwaV9kcml2ZXJz
Lmg+CisjaW5jbHVkZSA8eGVuL2FjcGkuaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKworI2RlZmluZSBQUkVGSVgg
IkFDUEk6eGVuX21lbW9yeV9ob3RwbHVnOiIKKworc3RydWN0IGFjcGlfbWVtb3J5X2luZm8gewor
CXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKKwl1NjQgc3RhcnRfYWRkcjsJCS8qIE1lbW9yeSBSYW5n
ZSBzdGFydCBwaHlzaWNhbCBhZGRyICovCisJdTY0IGxlbmd0aDsJCS8qIE1lbW9yeSBSYW5nZSBs
ZW5ndGggKi8KKwl1bnNpZ25lZCBzaG9ydCBjYWNoaW5nOwkvKiBtZW1vcnkgY2FjaGUgYXR0cmli
dXRlICovCisJdW5zaWduZWQgc2hvcnQgd3JpdGVfcHJvdGVjdDsJLyogbWVtb3J5IHJlYWQvd3Jp
dGUgYXR0cmlidXRlICovCisJCQkJLyogY29waWVkIGZyb20gYnVmZmVyIGdldHRpbmcgZnJvbSBf
Q1JTICovCisJdW5zaWduZWQgaW50IGVuYWJsZWQ6MTsKK307CisKK3N0cnVjdCBhY3BpX21lbW9y
eV9kZXZpY2UgeworCXN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlOworCXN0cnVjdCBsaXN0X2hl
YWQgcmVzX2xpc3Q7Cit9OworCitzdGF0aWMgYm9vbCBhY3BpX2hvdG1lbV9pbml0aWFsaXplZCBf
X3JlYWRfbW9zdGx5OworCitzdGF0aWMgaW50IHhlbl9ob3RhZGRfbWVtb3J5KGludCBweG0sIHN0
cnVjdCBhY3BpX21lbW9yeV9pbmZvICppbmZvKQoreworCWludCByYzsKKwlzdHJ1Y3QgeGVuX3Bs
YXRmb3JtX29wIG9wOworCisJb3AuY21kID0gWEVOUEZfbWVtX2hvdGFkZDsKKwlvcC51Lm1lbV9h
ZGQuc3BmbiA9IGluZm8tPnN0YXJ0X2FkZHIgPj4gUEFHRV9TSElGVDsKKwlvcC51Lm1lbV9hZGQu
ZXBmbiA9IChpbmZvLT5zdGFydF9hZGRyICsgaW5mby0+bGVuZ3RoKSA+PiBQQUdFX1NISUZUOwor
CW9wLnUubWVtX2FkZC5weG0gPSBweG07CisKKwlyYyA9IEhZUEVSVklTT1JfZG9tMF9vcCgmb3Ap
OworCWlmIChyYykKKwkJcHJfZXJyKFBSRUZJWCAiWGVuIEhvdHBsdWcgTWVtb3J5IEFkZCBmYWls
ZWQgb24gIgorCQkJIjB4JWx4IC0+IDB4JWx4LCBfUFhNOiAlZCwgZXJyb3I6ICVkXG4iLAorCQkJ
KHVuc2lnbmVkIGxvbmcpaW5mby0+c3RhcnRfYWRkciwKKwkJCSh1bnNpZ25lZCBsb25nKShpbmZv
LT5zdGFydF9hZGRyICsgaW5mby0+bGVuZ3RoKSwKKwkJCXB4bSwgcmMpOworCisJcmV0dXJuIHJj
OworfQorCitzdGF0aWMgaW50IHhlbl9hY3BpX2dldF9weG0oYWNwaV9oYW5kbGUgaCkKK3sKKwl1
bnNpZ25lZCBsb25nIGxvbmcgcHhtOworCWFjcGlfc3RhdHVzIHN0YXR1czsKKwlhY3BpX2hhbmRs
ZSBoYW5kbGU7CisJYWNwaV9oYW5kbGUgcGhhbmRsZSA9IGg7CisKKwlkbyB7CisJCWhhbmRsZSA9
IHBoYW5kbGU7CisJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdlcihoYW5kbGUsICJfUFhN
IiwgTlVMTCwgJnB4bSk7CisJCWlmIChBQ1BJX1NVQ0NFU1Moc3RhdHVzKSkKKwkJCXJldHVybiBw
eG07CisJCXN0YXR1cyA9IGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZwaGFuZGxlKTsKKwl9IHdo
aWxlIChBQ1BJX1NVQ0NFU1Moc3RhdHVzKSk7CisKKwlyZXR1cm4gLUVOWElPOworfQorCitzdGF0
aWMgaW50IHhlbl9hY3BpX21lbW9yeV9lbmFibGVfZGV2aWNlKHN0cnVjdCBhY3BpX21lbW9yeV9k
ZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJaW50IHB4bSwgcmVzdWx0OworCWludCBudW1fZW5hYmxl
ZCA9IDA7CisJc3RydWN0IGFjcGlfbWVtb3J5X2luZm8gKmluZm87CisKKwlpZiAoIW1lbV9kZXZp
Y2UpCisJCXJldHVybiAtRUlOVkFMOworCisJcHhtID0geGVuX2FjcGlfZ2V0X3B4bShtZW1fZGV2
aWNlLT5kZXZpY2UtPmhhbmRsZSk7CisJaWYgKHB4bSA8IDApCisJCXJldHVybiBweG07CisKKwls
aXN0X2Zvcl9lYWNoX2VudHJ5KGluZm8sICZtZW1fZGV2aWNlLT5yZXNfbGlzdCwgbGlzdCkgewor
CQlpZiAoaW5mby0+ZW5hYmxlZCkgeyAvKiBqdXN0IHNhbml0eSBjaGVjay4uLiovCisJCQludW1f
ZW5hYmxlZCsrOworCQkJY29udGludWU7CisJCX0KKworCQlpZiAoIWluZm8tPmxlbmd0aCkKKwkJ
CWNvbnRpbnVlOworCisJCXJlc3VsdCA9IHhlbl9ob3RhZGRfbWVtb3J5KHB4bSwgaW5mbyk7CisJ
CWlmIChyZXN1bHQpCisJCQljb250aW51ZTsKKwkJaW5mby0+ZW5hYmxlZCA9IDE7CisJCW51bV9l
bmFibGVkKys7CisJfQorCisJaWYgKCFudW1fZW5hYmxlZCkKKwkJcmV0dXJuIC1FTk9ERVY7CisK
KwlyZXR1cm4gMDsKK30KKworc3RhdGljIGFjcGlfc3RhdHVzCithY3BpX21lbW9yeV9nZXRfcmVz
b3VyY2Uoc3RydWN0IGFjcGlfcmVzb3VyY2UgKnJlc291cmNlLCB2b2lkICpjb250ZXh0KQorewor
CXN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UgPSBjb250ZXh0OworCXN0cnVj
dCBhY3BpX3Jlc291cmNlX2FkZHJlc3M2NCBhZGRyZXNzNjQ7CisJc3RydWN0IGFjcGlfbWVtb3J5
X2luZm8gKmluZm8sICpuZXc7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RhdHVzID0gYWNw
aV9yZXNvdXJjZV90b19hZGRyZXNzNjQocmVzb3VyY2UsICZhZGRyZXNzNjQpOworCWlmIChBQ1BJ
X0ZBSUxVUkUoc3RhdHVzKSB8fAorCSAgICAoYWRkcmVzczY0LnJlc291cmNlX3R5cGUgIT0gQUNQ
SV9NRU1PUllfUkFOR0UpKQorCQlyZXR1cm4gQUVfT0s7CisKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGluZm8sICZtZW1fZGV2aWNlLT5yZXNfbGlzdCwgbGlzdCkgeworCQlpZiAoKGluZm8tPmNhY2hp
bmcgPT0gYWRkcmVzczY0LmluZm8ubWVtLmNhY2hpbmcpICYmCisJCSAgICAoaW5mby0+d3JpdGVf
cHJvdGVjdCA9PSBhZGRyZXNzNjQuaW5mby5tZW0ud3JpdGVfcHJvdGVjdCkgJiYKKwkJICAgIChp
bmZvLT5zdGFydF9hZGRyICsgaW5mby0+bGVuZ3RoID09IGFkZHJlc3M2NC5taW5pbXVtKSkgewor
CQkJaW5mby0+bGVuZ3RoICs9IGFkZHJlc3M2NC5hZGRyZXNzX2xlbmd0aDsKKwkJCXJldHVybiBB
RV9PSzsKKwkJfQorCX0KKworCW5ldyA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBhY3BpX21lbW9y
eV9pbmZvKSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFuZXcpCisJCXJldHVybiBBRV9FUlJPUjsKKwor
CUlOSVRfTElTVF9IRUFEKCZuZXctPmxpc3QpOworCW5ldy0+Y2FjaGluZyA9IGFkZHJlc3M2NC5p
bmZvLm1lbS5jYWNoaW5nOworCW5ldy0+d3JpdGVfcHJvdGVjdCA9IGFkZHJlc3M2NC5pbmZvLm1l
bS53cml0ZV9wcm90ZWN0OworCW5ldy0+c3RhcnRfYWRkciA9IGFkZHJlc3M2NC5taW5pbXVtOwor
CW5ldy0+bGVuZ3RoID0gYWRkcmVzczY0LmFkZHJlc3NfbGVuZ3RoOworCWxpc3RfYWRkX3RhaWwo
Jm5ldy0+bGlzdCwgJm1lbV9kZXZpY2UtPnJlc19saXN0KTsKKworCXJldHVybiBBRV9PSzsKK30K
Kworc3RhdGljIGludAorYWNwaV9tZW1vcnlfZ2V0X2RldmljZV9yZXNvdXJjZXMoc3RydWN0IGFj
cGlfbWVtb3J5X2RldmljZSAqbWVtX2RldmljZSkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJ
c3RydWN0IGFjcGlfbWVtb3J5X2luZm8gKmluZm8sICpuOworCisJaWYgKCFsaXN0X2VtcHR5KCZt
ZW1fZGV2aWNlLT5yZXNfbGlzdCkpCisJCXJldHVybiAwOworCisJc3RhdHVzID0gYWNwaV93YWxr
X3Jlc291cmNlcyhtZW1fZGV2aWNlLT5kZXZpY2UtPmhhbmRsZSwKKwkJTUVUSE9EX05BTUVfX0NS
UywgYWNwaV9tZW1vcnlfZ2V0X3Jlc291cmNlLCBtZW1fZGV2aWNlKTsKKworCWlmIChBQ1BJX0ZB
SUxVUkUoc3RhdHVzKSkgeworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoaW5mbywgbiwgJm1l
bV9kZXZpY2UtPnJlc19saXN0LCBsaXN0KQorCQkJa2ZyZWUoaW5mbyk7CisJCUlOSVRfTElTVF9I
RUFEKCZtZW1fZGV2aWNlLT5yZXNfbGlzdCk7CisJCXJldHVybiAtRUlOVkFMOworCX0KKworCXJl
dHVybiAwOworfQorCitzdGF0aWMgaW50CithY3BpX21lbW9yeV9nZXRfZGV2aWNlKGFjcGlfaGFu
ZGxlIGhhbmRsZSwKKwkJICAgICAgIHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKiptZW1fZGV2
aWNlKQoreworCWFjcGlfc3RhdHVzIHN0YXR1czsKKwlhY3BpX2hhbmRsZSBwaGFuZGxlOworCXN0
cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlID0gTlVMTDsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2UgKnBk
ZXZpY2UgPSBOVUxMOworCWludCByZXN1bHQ7CisKKwlpZiAoIWFjcGlfYnVzX2dldF9kZXZpY2Uo
aGFuZGxlLCAmZGV2aWNlKSAmJiBkZXZpY2UpCisJCWdvdG8gZW5kOworCisJc3RhdHVzID0gYWNw
aV9nZXRfcGFyZW50KGhhbmRsZSwgJnBoYW5kbGUpOworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVz
KSkgeworCQlwcl93YXJuKFBSRUZJWCAiQ2Fubm90IGZpbmQgYWNwaSBwYXJlbnRcbiIpOworCQly
ZXR1cm4gLUVJTlZBTDsKKwl9CisKKwkvKiBHZXQgdGhlIHBhcmVudCBkZXZpY2UgKi8KKwlyZXN1
bHQgPSBhY3BpX2J1c19nZXRfZGV2aWNlKHBoYW5kbGUsICZwZGV2aWNlKTsKKwlpZiAocmVzdWx0
KSB7CisJCXByX3dhcm4oUFJFRklYICJDYW5ub3QgZ2V0IGFjcGkgYnVzIGRldmljZVxuIik7CisJ
CXJldHVybiAtRUlOVkFMOworCX0KKworCS8qCisJICogTm93IGFkZCB0aGUgbm90aWZpZWQgZGV2
aWNlLiAgVGhpcyBjcmVhdGVzIHRoZSBhY3BpX2RldmljZQorCSAqIGFuZCBpbnZva2VzIC5hZGQg
ZnVuY3Rpb24KKwkgKi8KKwlyZXN1bHQgPSBhY3BpX2J1c19hZGQoJmRldmljZSwgcGRldmljZSwg
aGFuZGxlLCBBQ1BJX0JVU19UWVBFX0RFVklDRSk7CisJaWYgKHJlc3VsdCkgeworCQlwcl93YXJu
KFBSRUZJWCAiQ2Fubm90IGFkZCBhY3BpIGJ1c1xuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0K
KworZW5kOgorCSptZW1fZGV2aWNlID0gYWNwaV9kcml2ZXJfZGF0YShkZXZpY2UpOworCWlmICgh
KCptZW1fZGV2aWNlKSkgeworCQlwcl9lcnIoUFJFRklYICJEcml2ZXIgZGF0YSBub3QgZm91bmRc
biIpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGlu
dCBhY3BpX21lbW9yeV9jaGVja19kZXZpY2Uoc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqbWVt
X2RldmljZSkKK3sKKwl1bnNpZ25lZCBsb25nIGxvbmcgY3VycmVudF9zdGF0dXM7CisKKwkvKiBH
ZXQgZGV2aWNlIHByZXNlbnQvYWJzZW50IGluZm9ybWF0aW9uIGZyb20gdGhlIF9TVEEgKi8KKwlp
ZiAoQUNQSV9GQUlMVVJFKGFjcGlfZXZhbHVhdGVfaW50ZWdlcihtZW1fZGV2aWNlLT5kZXZpY2Ut
PmhhbmRsZSwKKwkJCQkiX1NUQSIsIE5VTEwsICZjdXJyZW50X3N0YXR1cykpKQorCQlyZXR1cm4g
LUVOT0RFVjsKKwkvKgorCSAqIENoZWNrIGZvciBkZXZpY2Ugc3RhdHVzLiBEZXZpY2Ugc2hvdWxk
IGJlCisJICogcHJlc2VudC9lbmFibGVkL2Z1bmN0aW9uaW5nLgorCSAqLworCWlmICghKChjdXJy
ZW50X3N0YXR1cyAmIEFDUElfU1RBX0RFVklDRV9QUkVTRU5UKQorCSAgICAgICYmIChjdXJyZW50
X3N0YXR1cyAmIEFDUElfU1RBX0RFVklDRV9FTkFCTEVEKQorCSAgICAgICYmIChjdXJyZW50X3N0
YXR1cyAmIEFDUElfU1RBX0RFVklDRV9GVU5DVElPTklORykpKQorCQlyZXR1cm4gLUVOT0RFVjsK
KworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGFjcGlfbWVtb3J5X2Rpc2FibGVfZGV2aWNl
KHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJcHJfZGVidWcoUFJF
RklYICJYZW4gZG9lcyBub3Qgc3VwcG9ydCBtZW1vcnkgaG90cmVtb3ZlXG4iKTsKKworCXJldHVy
biAtRU5PU1lTOworfQorCitzdGF0aWMgdm9pZCBhY3BpX21lbW9yeV9kZXZpY2Vfbm90aWZ5KGFj
cGlfaGFuZGxlIGhhbmRsZSwgdTMyIGV2ZW50LCB2b2lkICpkYXRhKQoreworCXN0cnVjdCBhY3Bp
X21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2U7CisJc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2U7
CisJdTMyIG9zdF9jb2RlID0gQUNQSV9PU1RfU0NfTk9OX1NQRUNJRklDX0ZBSUxVUkU7IC8qIGRl
ZmF1bHQgKi8KKworCXN3aXRjaCAoZXZlbnQpIHsKKwljYXNlIEFDUElfTk9USUZZX0JVU19DSEVD
SzoKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLAorCQkJIlxuUmVjZWl2ZWQgQlVT
IENIRUNLIG5vdGlmaWNhdGlvbiBmb3IgZGV2aWNlXG4iKSk7CisJCS8qIEZhbGwgVGhyb3VnaCAq
LworCWNhc2UgQUNQSV9OT1RJRllfREVWSUNFX0NIRUNLOgorCQlpZiAoZXZlbnQgPT0gQUNQSV9O
T1RJRllfREVWSUNFX0NIRUNLKQorCQkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLAor
CQkJIlxuUmVjZWl2ZWQgREVWSUNFIENIRUNLIG5vdGlmaWNhdGlvbiBmb3IgZGV2aWNlXG4iKSk7
CisKKwkJaWYgKGFjcGlfbWVtb3J5X2dldF9kZXZpY2UoaGFuZGxlLCAmbWVtX2RldmljZSkpIHsK
KwkJCXByX2VycihQUkVGSVggIkNhbm5vdCBmaW5kIGRyaXZlciBkYXRhXG4iKTsKKwkJCWJyZWFr
OworCQl9CisKKwkJb3N0X2NvZGUgPSBBQ1BJX09TVF9TQ19TVUNDRVNTOworCQlicmVhazsKKwor
CWNhc2UgQUNQSV9OT1RJRllfRUpFQ1RfUkVRVUVTVDoKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQ
SV9EQl9JTkZPLAorCQkJIlxuUmVjZWl2ZWQgRUpFQ1QgUkVRVUVTVCBub3RpZmljYXRpb24gZm9y
IGRldmljZVxuIikpOworCisJCWlmIChhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRldmlj
ZSkpIHsKKwkJCXByX2VycihQUkVGSVggIkRldmljZSBkb2Vzbid0IGV4aXN0XG4iKTsKKwkJCWJy
ZWFrOworCQl9CisJCW1lbV9kZXZpY2UgPSBhY3BpX2RyaXZlcl9kYXRhKGRldmljZSk7CisJCWlm
ICghbWVtX2RldmljZSkgeworCQkJcHJfZXJyKFBSRUZJWCAiRHJpdmVyIERhdGEgaXMgTlVMTFxu
Iik7CisJCQlicmVhazsKKwkJfQorCisJCS8qCisJCSAqIFRCRDogaW1wbGVtZW50IGFjcGlfbWVt
b3J5X2Rpc2FibGVfZGV2aWNlIGFuZCBpbnZva2UKKwkJICogYWNwaV9idXNfcmVtb3ZlIGlmIFhl
biBzdXBwb3J0IGhvdHJlbW92ZSBpbiB0aGUgZnV0dXJlCisJCSAqLworCQlhY3BpX21lbW9yeV9k
aXNhYmxlX2RldmljZShtZW1fZGV2aWNlKTsKKwkJYnJlYWs7CisKKwlkZWZhdWx0OgorCQlBQ1BJ
X0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQkJICAiVW5zdXBwb3J0ZWQgZXZlbnQgWzB4
JXhdXG4iLCBldmVudCkpOworCQkvKiBub24taG90cGx1ZyBldmVudDsgcG9zc2libHkgaGFuZGxl
ZCBieSBvdGhlciBoYW5kbGVyICovCisJCXJldHVybjsKKwl9CisKKwkodm9pZCkgYWNwaV9ldmFs
dWF0ZV9ob3RwbHVnX29zdChoYW5kbGUsIGV2ZW50LCBvc3RfY29kZSwgTlVMTCk7CisJcmV0dXJu
OworfQorCitzdGF0aWMgaW50IHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfYWRkKHN0cnVjdCBhY3Bp
X2RldmljZSAqZGV2aWNlKQoreworCWludCByZXN1bHQ7CisJc3RydWN0IGFjcGlfbWVtb3J5X2Rl
dmljZSAqbWVtX2RldmljZSA9IE5VTEw7CisKKworCWlmICghZGV2aWNlKQorCQlyZXR1cm4gLUVJ
TlZBTDsKKworCW1lbV9kZXZpY2UgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgYWNwaV9tZW1vcnlf
ZGV2aWNlKSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFtZW1fZGV2aWNlKQorCQlyZXR1cm4gLUVOT01F
TTsKKworCUlOSVRfTElTVF9IRUFEKCZtZW1fZGV2aWNlLT5yZXNfbGlzdCk7CisJbWVtX2Rldmlj
ZS0+ZGV2aWNlID0gZGV2aWNlOworCXNwcmludGYoYWNwaV9kZXZpY2VfbmFtZShkZXZpY2UpLCAi
JXMiLCBBQ1BJX01FTU9SWV9ERVZJQ0VfTkFNRSk7CisJc3ByaW50ZihhY3BpX2RldmljZV9jbGFz
cyhkZXZpY2UpLCAiJXMiLCBBQ1BJX01FTU9SWV9ERVZJQ0VfQ0xBU1MpOworCWRldmljZS0+ZHJp
dmVyX2RhdGEgPSBtZW1fZGV2aWNlOworCisJLyogR2V0IHRoZSByYW5nZSBmcm9tIHRoZSBfQ1JT
ICovCisJcmVzdWx0ID0gYWNwaV9tZW1vcnlfZ2V0X2RldmljZV9yZXNvdXJjZXMobWVtX2Rldmlj
ZSk7CisJaWYgKHJlc3VsdCkgeworCQlrZnJlZShtZW1fZGV2aWNlKTsKKwkJcmV0dXJuIHJlc3Vs
dDsKKwl9CisKKwkvKgorCSAqIEZvciBib290aW5nIGV4aXN0ZWQgbWVtb3J5IGRldmljZXMsIGVh
cmx5IGJvb3QgY29kZSBoYXMgcmVjb2duaXplZAorCSAqIG1lbW9yeSBhcmVhIGJ5IEVGSS9FODIw
LiBJZiBEU0RUIHNob3dzIHRoZXNlIG1lbW9yeSBkZXZpY2VzIG9uIGJvb3QsCisJICogaG90cGx1
ZyBpcyBub3QgbmVjZXNzYXJ5IGZvciB0aGVtLgorCSAqIEZvciBob3QtYWRkZWQgbWVtb3J5IGRl
dmljZXMgZHVyaW5nIHJ1bnRpbWUsIGl0IG5lZWQgaHlwZXJjYWxsIHRvCisJICogWGVuIGh5cGVy
dmlzb3IgdG8gYWRkIG1lbW9yeS4KKwkgKi8KKwlpZiAoIWFjcGlfaG90bWVtX2luaXRpYWxpemVk
KQorCQlyZXR1cm4gMDsKKworCWlmICghYWNwaV9tZW1vcnlfY2hlY2tfZGV2aWNlKG1lbV9kZXZp
Y2UpKQorCQlyZXN1bHQgPSB4ZW5fYWNwaV9tZW1vcnlfZW5hYmxlX2RldmljZShtZW1fZGV2aWNl
KTsKKworCXJldHVybiByZXN1bHQ7Cit9CisKK3N0YXRpYyBpbnQgeGVuX2FjcGlfbWVtb3J5X2Rl
dmljZV9yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UsIGludCB0eXBlKQoreworCXN0
cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UgPSBOVUxMOworCisJaWYgKCFkZXZp
Y2UgfHwgIWFjcGlfZHJpdmVyX2RhdGEoZGV2aWNlKSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlt
ZW1fZGV2aWNlID0gYWNwaV9kcml2ZXJfZGF0YShkZXZpY2UpOworCWtmcmVlKG1lbV9kZXZpY2Up
OworCisJcmV0dXJuIDA7Cit9CisKKy8qCisgKiBIZWxwZXIgZnVuY3Rpb24gdG8gY2hlY2sgZm9y
IG1lbW9yeSBkZXZpY2UKKyAqLworc3RhdGljIGFjcGlfc3RhdHVzIGlzX21lbW9yeV9kZXZpY2Uo
YWNwaV9oYW5kbGUgaGFuZGxlKQoreworCWNoYXIgKmhhcmR3YXJlX2lkOworCWFjcGlfc3RhdHVz
IHN0YXR1czsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2VfaW5mbyAqaW5mbzsKKworCXN0YXR1cyA9IGFj
cGlfZ2V0X29iamVjdF9pbmZvKGhhbmRsZSwgJmluZm8pOworCWlmIChBQ1BJX0ZBSUxVUkUoc3Rh
dHVzKSkKKwkJcmV0dXJuIHN0YXR1czsKKworCWlmICghKGluZm8tPnZhbGlkICYgQUNQSV9WQUxJ
RF9ISUQpKSB7CisJCWtmcmVlKGluZm8pOworCQlyZXR1cm4gQUVfRVJST1I7CisJfQorCisJaGFy
ZHdhcmVfaWQgPSBpbmZvLT5oYXJkd2FyZV9pZC5zdHJpbmc7CisJaWYgKChoYXJkd2FyZV9pZCA9
PSBOVUxMKSB8fAorCSAgICAoc3RyY21wKGhhcmR3YXJlX2lkLCBBQ1BJX01FTU9SWV9ERVZJQ0Vf
SElEKSkpCisJCXN0YXR1cyA9IEFFX0VSUk9SOworCisJa2ZyZWUoaW5mbyk7CisJcmV0dXJuIHN0
YXR1czsKK30KKworc3RhdGljIGFjcGlfc3RhdHVzCithY3BpX21lbW9yeV9yZWdpc3Rlcl9ub3Rp
ZnlfaGFuZGxlcihhY3BpX2hhbmRsZSBoYW5kbGUsCisJCQkJICAgIHUzMiBsZXZlbCwgdm9pZCAq
Y3R4dCwgdm9pZCAqKnJldHYpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RhdHVzID0g
aXNfbWVtb3J5X2RldmljZShoYW5kbGUpOworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkKKwkJ
cmV0dXJuIEFFX09LOwkvKiBjb250aW51ZSAqLworCisJc3RhdHVzID0gYWNwaV9pbnN0YWxsX25v
dGlmeV9oYW5kbGVyKGhhbmRsZSwgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJCQkgICAgIGFjcGlf
bWVtb3J5X2RldmljZV9ub3RpZnksIE5VTEwpOworCS8qIGNvbnRpbnVlICovCisJcmV0dXJuIEFF
X09LOworfQorCitzdGF0aWMgYWNwaV9zdGF0dXMKK2FjcGlfbWVtb3J5X2RlcmVnaXN0ZXJfbm90
aWZ5X2hhbmRsZXIoYWNwaV9oYW5kbGUgaGFuZGxlLAorCQkJCSAgICAgIHUzMiBsZXZlbCwgdm9p
ZCAqY3R4dCwgdm9pZCAqKnJldHYpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RhdHVz
ID0gaXNfbWVtb3J5X2RldmljZShoYW5kbGUpOworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkK
KwkJcmV0dXJuIEFFX09LOwkvKiBjb250aW51ZSAqLworCisJc3RhdHVzID0gYWNwaV9yZW1vdmVf
bm90aWZ5X2hhbmRsZXIoaGFuZGxlLAorCQkJCQkgICAgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJ
CQkgICAgYWNwaV9tZW1vcnlfZGV2aWNlX25vdGlmeSk7CisKKwlyZXR1cm4gQUVfT0s7CS8qIGNv
bnRpbnVlICovCit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQgbWVtb3J5
X2RldmljZV9pZHNbXSA9IHsKKwl7QUNQSV9NRU1PUllfREVWSUNFX0hJRCwgMH0sCisJeyIiLCAw
fSwKK307CitNT0RVTEVfREVWSUNFX1RBQkxFKGFjcGksIG1lbW9yeV9kZXZpY2VfaWRzKTsKKwor
c3RhdGljIHN0cnVjdCBhY3BpX2RyaXZlciB4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2RyaXZlciA9
IHsKKwkubmFtZSA9ICJhY3BpX21lbWhvdHBsdWciLAorCS5jbGFzcyA9IEFDUElfTUVNT1JZX0RF
VklDRV9DTEFTUywKKwkuaWRzID0gbWVtb3J5X2RldmljZV9pZHMsCisJLm9wcyA9IHsKKwkJLmFk
ZCA9IHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfYWRkLAorCQkucmVtb3ZlID0geGVuX2FjcGlfbWVt
b3J5X2RldmljZV9yZW1vdmUsCisJCX0sCit9OworCitzdGF0aWMgaW50IF9faW5pdCB4ZW5fYWNw
aV9tZW1vcnlfZGV2aWNlX2luaXQodm9pZCkKK3sKKwlpbnQgcmVzdWx0OworCWFjcGlfc3RhdHVz
IHN0YXR1czsKKworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCisJCXJldHVybiAtRU5PREVW
OworCisJLyogdW5yZWdpc3RlciB0aGUgc3R1YiB3aGljaCBvbmx5IHVzZWQgdG8gcmVzZXJ2ZSBk
cml2ZXIgc3BhY2UgKi8KKwlhY3BpX2J1c191bnJlZ2lzdGVyX2RyaXZlcigmeGVuX3N0dWJfbWVt
b3J5X2RldmljZV9kcml2ZXIpOworCisJcmVzdWx0ID0gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVy
KCZ4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2RyaXZlcik7CisJaWYgKHJlc3VsdCA8IDApIHsKKwkJ
YWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2RyaXZlcik7
CisJCXJldHVybiAtRU5PREVWOworCX0KKworCXN0YXR1cyA9IGFjcGlfd2Fsa19uYW1lc3BhY2Uo
QUNQSV9UWVBFX0RFVklDRSwgQUNQSV9ST09UX09CSkVDVCwKKwkJCQkgICAgIEFDUElfVUlOVDMy
X01BWCwKKwkJCQkgICAgIGFjcGlfbWVtb3J5X3JlZ2lzdGVyX25vdGlmeV9oYW5kbGVyLAorCQkJ
CSAgICAgTlVMTCwgTlVMTCwgTlVMTCk7CisKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsK
KwkJcHJfd2FybihQUkVGSVggIndhbGtfbmFtZXNwYWNlIGZhaWxlZFxuIik7CisJCWFjcGlfYnVz
X3VucmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2RyaXZlcik7CisJCWFj
cGlfYnVzX3JlZ2lzdGVyX2RyaXZlcigmeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXIpOwor
CQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlhY3BpX2hvdG1lbV9pbml0aWFsaXplZCA9IHRydWU7
CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyB2b2lkIF9fZXhpdCB4ZW5fYWNwaV9tZW1vcnlfZGV2
aWNlX2V4aXQodm9pZCkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisKKwlpZiAoIXhlbl9pbml0
aWFsX2RvbWFpbigpKQorCQlyZXR1cm47CisKKwlzdGF0dXMgPSBhY3BpX3dhbGtfbmFtZXNwYWNl
KEFDUElfVFlQRV9ERVZJQ0UsIEFDUElfUk9PVF9PQkpFQ1QsCisJCQkJICAgICBBQ1BJX1VJTlQz
Ml9NQVgsCisJCQkJICAgICBhY3BpX21lbW9yeV9kZXJlZ2lzdGVyX25vdGlmeV9oYW5kbGVyLAor
CQkJCSAgICAgTlVMTCwgTlVMTCwgTlVMTCk7CisJaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKQor
CQlwcl93YXJuKFBSRUZJWCAid2Fsa19uYW1lc3BhY2UgZmFpbGVkXG4iKTsKKworCWFjcGlfYnVz
X3VucmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2RyaXZlcik7CisKKwkv
KgorCSAqIHN0dWIgcmVzZXJ2ZSBzcGFjZSBhZ2FpbiB0byBwcmV2ZW50IGFueSBjaGFuY2Ugb2Yg
bmF0aXZlCisJICogZHJpdmVyIGxvYWRpbmcuCisJICovCisJYWNwaV9idXNfcmVnaXN0ZXJfZHJp
dmVyKCZ4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2RyaXZlcik7CisJcmV0dXJuOworfQorCittb2R1
bGVfaW5pdCh4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2luaXQpOworbW9kdWxlX2V4aXQoeGVuX2Fj
cGlfbWVtb3J5X2RldmljZV9leGl0KTsKK0FDUElfTU9EVUxFX05BTUUoInhlbi1hY3BpLW1lbWhv
dHBsdWciKTsKK01PRFVMRV9BVVRIT1IoIkxpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5j
b20+Iik7CitNT0RVTEVfREVTQ1JJUFRJT04oIlhlbiBIb3RwbHVnIE1lbSBEcml2ZXIiKTsKK01P
RFVMRV9MSUNFTlNFKCJHUEwiKTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9w
bGF0Zm9ybS5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggNWUzNjkz
Mi4uMmM0ZmI0YiAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgK
KysrIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMyNCwxMCArMzI0LDE0
IEBAIHN0cnVjdCB4ZW5wZl9jcHVfb2wgewogfTsKIERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNU
KHhlbnBmX2NwdV9vbCk7CiAKLS8qCi0gKiBDTUQgNTggYW5kIDU5IGFyZSByZXNlcnZlZCBmb3Ig
Y3B1IGhvdGFkZCBhbmQgbWVtb3J5IGhvdGFkZCwKLSAqIHdoaWNoIGFyZSBhbHJlYWR5IG9jY3Vw
aWVkIGF0IFhlbiBoeXBlcnZpc29yIHNpZGUuCi0gKi8KKyNkZWZpbmUgWEVOUEZfbWVtX2hvdGFk
ZAk1OQorc3RydWN0IHhlbnBmX21lbV9ob3RhZGQgeworCXVpbnQ2NF90IHNwZm47CisJdWludDY0
X3QgZXBmbjsKKwl1aW50MzJfdCBweG07CisJdWludDMyX3QgZmxhZ3M7Cit9OworCiAjZGVmaW5l
IFhFTlBGX2NvcmVfcGFya2luZyAgICAgNjAKIHN0cnVjdCB4ZW5wZl9jb3JlX3Bhcmtpbmcgewog
CS8qIElOIHZhcmlhYmxlcyAqLwpAQCAtMzU3LDYgKzM2MSw3IEBAIHN0cnVjdCB4ZW5fcGxhdGZv
cm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8gc2V0X3BtaW5mbzsK
IAkJc3RydWN0IHhlbnBmX3BjcHVpbmZvICAgICAgICAgIHBjcHVfaW5mbzsKIAkJc3RydWN0IHhl
bnBmX2NwdV9vbCAgICAgICAgICAgIGNwdV9vbDsKKwkJc3RydWN0IHhlbnBmX21lbV9ob3RhZGQg
ICAgICAgIG1lbV9hZGQ7CiAJCXN0cnVjdCB4ZW5wZl9jb3JlX3BhcmtpbmcgICAgICBjb3JlX3Bh
cmtpbmc7CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsKIAl9IHU7
Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923353C24E4SHSMSX101ccrcorpi_--
