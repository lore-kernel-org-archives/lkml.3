Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3AYI4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:56:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:44905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3AYI4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208,223";a="195013898"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V4 2/2] Xen ACPI memory hotplug
Thread-Topic: [PATCH V4 2/2] Xen ACPI memory hotplug
Thread-Index: Ac362dZA5C8ERyUESX27IOzVVg2OKQ==
Date: Fri, 25 Jan 2013 08:56:17 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD6D6@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353DD6D6SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6D6SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 8e9d4d9b17bfb3831c6a49ad9b72c1395bde2d6b Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Thu, 24 Jan 2013 20:19:47 +0800
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
index c1c8566..dcffad1 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -191,6 +191,17 @@ config XEN_STUB
=20
 	  To enable Xen features like cpu and memory hotplug, select Y here.
=20
+config XEN_ACPI_HOTPLUG_MEMORY
+	tristate "Xen ACPI memory hotplug"
+	depends on XEN_DOM0 && XEN_STUB && ACPI
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
index 0000000..2c3759a
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
+	xen_stub_memory_device_exit();
+
+	result =3D acpi_bus_register_driver(&xen_acpi_memory_device_driver);
+	if (result < 0) {
+		xen_stub_memory_device_init();
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
+		xen_stub_memory_device_init();
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
+	xen_stub_memory_device_init();
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

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6D6SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Xen-ACPI-memory-hotplug.patch"
Content-Description: 0002-Xen-ACPI-memory-hotplug.patch
Content-Disposition: attachment;
	filename="0002-Xen-ACPI-memory-hotplug.patch"; size=16274;
	creation-date="Fri, 25 Jan 2013 08:52:32 GMT";
	modification-date="Fri, 25 Jan 2013 16:45:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4ZTlkNGQ5YjE3YmZiMzgzMWM2YTQ5YWQ5YjcyYzEzOTViZGUyZDZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUaHUsIDI0IEphbiAyMDEzIDIwOjE5OjQ3ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IFhlbiBBQ1BJIG1lbW9yeSBob3RwbHVnCgpUaGlzIHBhdGNoIGltcGxlbWVudHMgcmVhbCBYZW4g
YWNwaSBtZW1vcnkgaG90cGx1ZyBkcml2ZXIgYXMgbW9kdWxlLgpXaGVuIGxvYWRlZCwgaXQgcmVw
bGFjZXMgWGVuIHN0dWIgZHJpdmVyLgoKV2hlbiBhbiBhY3BpIG1lbW9yeSBkZXZpY2UgaG90YWRk
IGV2ZW50IG9jY3VycywgaXQgbm90aWZpZXMgT1MgYW5kCmludm9rZXMgbm90aWZpY2F0aW9uIGNh
bGxiYWNrLCBhZGRpbmcgcmVsYXRlZCBtZW1vcnkgZGV2aWNlIGFuZCBwYXJzaW5nCm1lbW9yeSBp
bmZvcm1hdGlvbiwgZmluYWxseSBoeXBlcmNhbGwgdG8geGVuIGh5cGVydmlzb3IgdG8gYWRkIG1l
bW9yeS4KClNpZ25lZC1vZmYtYnk6IExpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+
Ci0tLQogZHJpdmVycy94ZW4vS2NvbmZpZyAgICAgICAgICAgICAgIHwgICAxMSArCiBkcml2ZXJz
L3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgfCAgICAxICsKIGRyaXZlcnMveGVuL3hlbi1hY3Bp
LW1lbWhvdHBsdWcuYyB8ICA1MDEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggIHwgICAxMyArLQogNCBmaWxlcyBj
aGFuZ2VkLCA1MjIgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVycy94ZW4vS2NvbmZpZwppbmRleCBjMWM4NTY2Li5kY2Zm
YWQxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9LY29uZmlnCisrKyBiL2RyaXZlcnMveGVuL0tj
b25maWcKQEAgLTE5MSw2ICsxOTEsMTcgQEAgY29uZmlnIFhFTl9TVFVCCiAKIAkgIFRvIGVuYWJs
ZSBYZW4gZmVhdHVyZXMgbGlrZSBjcHUgYW5kIG1lbW9yeSBob3RwbHVnLCBzZWxlY3QgWSBoZXJl
LgogCitjb25maWcgWEVOX0FDUElfSE9UUExVR19NRU1PUlkKKwl0cmlzdGF0ZSAiWGVuIEFDUEkg
bWVtb3J5IGhvdHBsdWciCisJZGVwZW5kcyBvbiBYRU5fRE9NMCAmJiBYRU5fU1RVQiAmJiBBQ1BJ
CisJZGVmYXVsdCBuCisJaGVscAorCSAgVGhpcyBpcyBYZW4gQUNQSSBtZW1vcnkgaG90cGx1Zy4K
KworCSAgQ3VycmVudGx5IFhlbiBvbmx5IHN1cHBvcnQgQUNQSSBtZW1vcnkgaG90LWFkZC4gSWYg
eW91IHdhbnQKKwkgIHRvIGhvdC1hZGQgbWVtb3J5IGF0IHJ1bnRpbWUgKHRoZSBob3QtYWRkZWQg
bWVtb3J5IGNhbm5vdCBiZQorCSAgcmVtb3ZlZCB1bnRpbCBtYWNoaW5lIHN0b3ApLCBzZWxlY3Qg
WS9NIGhlcmUsIG90aGVyd2lzZSBzZWxlY3QgTi4KKwogY29uZmlnIFhFTl9BQ1BJX1BST0NFU1NP
UgogCXRyaXN0YXRlICJYZW4gQUNQSSBwcm9jZXNzb3IiCiAJZGVwZW5kcyBvbiBYRU4gJiYgWDg2
ICYmIEFDUElfUFJPQ0VTU09SICYmIENQVV9GUkVRCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9N
YWtlZmlsZSBiL2RyaXZlcnMveGVuL01ha2VmaWxlCmluZGV4IGI2M2VkZDguLjE2MDVmNTkgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMveGVuL01ha2VmaWxlCisrKyBiL2RyaXZlcnMveGVuL01ha2VmaWxl
CkBAIC0zMSw2ICszMSw3IEBAIG9iai0kKENPTkZJR19YRU5fTUNFX0xPRykJCSs9IG1jZWxvZy5v
CiBvYmotJChDT05GSUdfWEVOX1BDSURFVl9CQUNLRU5EKQkrPSB4ZW4tcGNpYmFjay8KIG9iai0k
KENPTkZJR19YRU5fUFJJVkNNRCkJCSs9IHhlbi1wcml2Y21kLm8KIG9iai0kKENPTkZJR19YRU5f
U1RVQikJCQkrPSB4ZW4tc3R1Yi5vCitvYmotJChDT05GSUdfWEVOX0FDUElfSE9UUExVR19NRU1P
UlkpCSs9IHhlbi1hY3BpLW1lbWhvdHBsdWcubwogb2JqLSQoQ09ORklHX1hFTl9BQ1BJX1BST0NF
U1NPUikJKz0geGVuLWFjcGktcHJvY2Vzc29yLm8KIHhlbi1ldnRjaG4teQkJCQk6PSBldnRjaG4u
bwogeGVuLWdudGRldi15CQkJCTo9IGdudGRldi5vCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94
ZW4tYWNwaS1tZW1ob3RwbHVnLmMgYi9kcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMK
bmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uMmMzNzU5YQotLS0gL2Rldi9udWxs
CisrKyBiL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYwpAQCAtMCwwICsxLDUwMSBA
QAorLyoKKyAqIENvcHlyaWdodCAoQykgMjAxMiBJbnRlbCBDb3Jwb3JhdGlvbgorICogICAgQXV0
aG9yOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgorICogICAgQXV0aG9yOiBK
aWFuZyBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dy
YW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlm
eQorICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSBhcyBwdWJsaXNoZWQgYnkKKyAqIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhl
ciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdAorICogeW91ciBvcHRpb24pIGFueSBs
YXRlciB2ZXJzaW9uLgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUg
aG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQKKyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZ
OyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqIE1FUkNIQU5UQUJJTElU
WSBPUiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSwgR09PRCBUSVRMRSBvcgorICog
Tk9OIElORlJJTkdFTUVOVC4gIFNlZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9y
IG1vcmUKKyAqIGRldGFpbHMuCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2lu
Y2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRl
IDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGxpbnV4L2FjcGkuaD4KKyNpbmNsdWRlIDxhY3Bp
L2FjcGlfZHJpdmVycy5oPgorI2luY2x1ZGUgPHhlbi9hY3BpLmg+CisjaW5jbHVkZSA8eGVuL2lu
dGVyZmFjZS9wbGF0Zm9ybS5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisKKyNk
ZWZpbmUgUFJFRklYICJBQ1BJOnhlbl9tZW1vcnlfaG90cGx1ZzoiCisKK3N0cnVjdCBhY3BpX21l
bW9yeV9pbmZvIHsKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJdTY0IHN0YXJ0X2FkZHI7CQkv
KiBNZW1vcnkgUmFuZ2Ugc3RhcnQgcGh5c2ljYWwgYWRkciAqLworCXU2NCBsZW5ndGg7CQkvKiBN
ZW1vcnkgUmFuZ2UgbGVuZ3RoICovCisJdW5zaWduZWQgc2hvcnQgY2FjaGluZzsJLyogbWVtb3J5
IGNhY2hlIGF0dHJpYnV0ZSAqLworCXVuc2lnbmVkIHNob3J0IHdyaXRlX3Byb3RlY3Q7CS8qIG1l
bW9yeSByZWFkL3dyaXRlIGF0dHJpYnV0ZSAqLworCQkJCS8qIGNvcGllZCBmcm9tIGJ1ZmZlciBn
ZXR0aW5nIGZyb20gX0NSUyAqLworCXVuc2lnbmVkIGludCBlbmFibGVkOjE7Cit9OworCitzdHJ1
Y3QgYWNwaV9tZW1vcnlfZGV2aWNlIHsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZTsKKwlz
dHJ1Y3QgbGlzdF9oZWFkIHJlc19saXN0OworfTsKKworc3RhdGljIGJvb2wgYWNwaV9ob3RtZW1f
aW5pdGlhbGl6ZWQgX19yZWFkX21vc3RseTsKKworc3RhdGljIGludCB4ZW5faG90YWRkX21lbW9y
eShpbnQgcHhtLCBzdHJ1Y3QgYWNwaV9tZW1vcnlfaW5mbyAqaW5mbykKK3sKKwlpbnQgcmM7CisJ
c3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcDsKKworCW9wLmNtZCA9IFhFTlBGX21lbV9ob3RhZGQ7
CisJb3AudS5tZW1fYWRkLnNwZm4gPSBpbmZvLT5zdGFydF9hZGRyID4+IFBBR0VfU0hJRlQ7CisJ
b3AudS5tZW1fYWRkLmVwZm4gPSAoaW5mby0+c3RhcnRfYWRkciArIGluZm8tPmxlbmd0aCkgPj4g
UEFHRV9TSElGVDsKKwlvcC51Lm1lbV9hZGQucHhtID0gcHhtOworCisJcmMgPSBIWVBFUlZJU09S
X2RvbTBfb3AoJm9wKTsKKwlpZiAocmMpCisJCXByX2VycihQUkVGSVggIlhlbiBIb3RwbHVnIE1l
bW9yeSBBZGQgZmFpbGVkIG9uICIKKwkJCSIweCVseCAtPiAweCVseCwgX1BYTTogJWQsIGVycm9y
OiAlZFxuIiwKKwkJCSh1bnNpZ25lZCBsb25nKWluZm8tPnN0YXJ0X2FkZHIsCisJCQkodW5zaWdu
ZWQgbG9uZykoaW5mby0+c3RhcnRfYWRkciArIGluZm8tPmxlbmd0aCksCisJCQlweG0sIHJjKTsK
KworCXJldHVybiByYzsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9nZXRfcHhtKGFjcGlfaGFu
ZGxlIGgpCit7CisJdW5zaWduZWQgbG9uZyBsb25nIHB4bTsKKwlhY3BpX3N0YXR1cyBzdGF0dXM7
CisJYWNwaV9oYW5kbGUgaGFuZGxlOworCWFjcGlfaGFuZGxlIHBoYW5kbGUgPSBoOworCisJZG8g
eworCQloYW5kbGUgPSBwaGFuZGxlOworCQlzdGF0dXMgPSBhY3BpX2V2YWx1YXRlX2ludGVnZXIo
aGFuZGxlLCAiX1BYTSIsIE5VTEwsICZweG0pOworCQlpZiAoQUNQSV9TVUNDRVNTKHN0YXR1cykp
CisJCQlyZXR1cm4gcHhtOworCQlzdGF0dXMgPSBhY3BpX2dldF9wYXJlbnQoaGFuZGxlLCAmcGhh
bmRsZSk7CisJfSB3aGlsZSAoQUNQSV9TVUNDRVNTKHN0YXR1cykpOworCisJcmV0dXJuIC1FTlhJ
TzsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9tZW1vcnlfZW5hYmxlX2RldmljZShzdHJ1Y3Qg
YWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlKQoreworCWludCBweG0sIHJlc3VsdDsKKwlp
bnQgbnVtX2VuYWJsZWQgPSAwOworCXN0cnVjdCBhY3BpX21lbW9yeV9pbmZvICppbmZvOworCisJ
aWYgKCFtZW1fZGV2aWNlKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXB4bSA9IHhlbl9hY3BpX2dl
dF9weG0obWVtX2RldmljZS0+ZGV2aWNlLT5oYW5kbGUpOworCWlmIChweG0gPCAwKQorCQlyZXR1
cm4gcHhtOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShpbmZvLCAmbWVtX2RldmljZS0+cmVzX2xp
c3QsIGxpc3QpIHsKKwkJaWYgKGluZm8tPmVuYWJsZWQpIHsgLyoganVzdCBzYW5pdHkgY2hlY2su
Li4qLworCQkJbnVtX2VuYWJsZWQrKzsKKwkJCWNvbnRpbnVlOworCQl9CisKKwkJaWYgKCFpbmZv
LT5sZW5ndGgpCisJCQljb250aW51ZTsKKworCQlyZXN1bHQgPSB4ZW5faG90YWRkX21lbW9yeShw
eG0sIGluZm8pOworCQlpZiAocmVzdWx0KQorCQkJY29udGludWU7CisJCWluZm8tPmVuYWJsZWQg
PSAxOworCQludW1fZW5hYmxlZCsrOworCX0KKworCWlmICghbnVtX2VuYWJsZWQpCisJCXJldHVy
biAtRU5PREVWOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1cworYWNwaV9t
ZW1vcnlfZ2V0X3Jlc291cmNlKHN0cnVjdCBhY3BpX3Jlc291cmNlICpyZXNvdXJjZSwgdm9pZCAq
Y29udGV4dCkKK3sKKwlzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlID0gY29u
dGV4dDsKKwlzdHJ1Y3QgYWNwaV9yZXNvdXJjZV9hZGRyZXNzNjQgYWRkcmVzczY0OworCXN0cnVj
dCBhY3BpX21lbW9yeV9pbmZvICppbmZvLCAqbmV3OworCWFjcGlfc3RhdHVzIHN0YXR1czsKKwor
CXN0YXR1cyA9IGFjcGlfcmVzb3VyY2VfdG9fYWRkcmVzczY0KHJlc291cmNlLCAmYWRkcmVzczY0
KTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykgfHwKKwkgICAgKGFkZHJlc3M2NC5yZXNvdXJj
ZV90eXBlICE9IEFDUElfTUVNT1JZX1JBTkdFKSkKKwkJcmV0dXJuIEFFX09LOworCisJbGlzdF9m
b3JfZWFjaF9lbnRyeShpbmZvLCAmbWVtX2RldmljZS0+cmVzX2xpc3QsIGxpc3QpIHsKKwkJaWYg
KChpbmZvLT5jYWNoaW5nID09IGFkZHJlc3M2NC5pbmZvLm1lbS5jYWNoaW5nKSAmJgorCQkgICAg
KGluZm8tPndyaXRlX3Byb3RlY3QgPT0gYWRkcmVzczY0LmluZm8ubWVtLndyaXRlX3Byb3RlY3Qp
ICYmCisJCSAgICAoaW5mby0+c3RhcnRfYWRkciArIGluZm8tPmxlbmd0aCA9PSBhZGRyZXNzNjQu
bWluaW11bSkpIHsKKwkJCWluZm8tPmxlbmd0aCArPSBhZGRyZXNzNjQuYWRkcmVzc19sZW5ndGg7
CisJCQlyZXR1cm4gQUVfT0s7CisJCX0KKwl9CisKKwluZXcgPSBremFsbG9jKHNpemVvZihzdHJ1
Y3QgYWNwaV9tZW1vcnlfaW5mbyksIEdGUF9LRVJORUwpOworCWlmICghbmV3KQorCQlyZXR1cm4g
QUVfRVJST1I7CisKKwlJTklUX0xJU1RfSEVBRCgmbmV3LT5saXN0KTsKKwluZXctPmNhY2hpbmcg
PSBhZGRyZXNzNjQuaW5mby5tZW0uY2FjaGluZzsKKwluZXctPndyaXRlX3Byb3RlY3QgPSBhZGRy
ZXNzNjQuaW5mby5tZW0ud3JpdGVfcHJvdGVjdDsKKwluZXctPnN0YXJ0X2FkZHIgPSBhZGRyZXNz
NjQubWluaW11bTsKKwluZXctPmxlbmd0aCA9IGFkZHJlc3M2NC5hZGRyZXNzX2xlbmd0aDsKKwls
aXN0X2FkZF90YWlsKCZuZXctPmxpc3QsICZtZW1fZGV2aWNlLT5yZXNfbGlzdCk7CisKKwlyZXR1
cm4gQUVfT0s7Cit9CisKK3N0YXRpYyBpbnQKK2FjcGlfbWVtb3J5X2dldF9kZXZpY2VfcmVzb3Vy
Y2VzKHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJYWNwaV9zdGF0
dXMgc3RhdHVzOworCXN0cnVjdCBhY3BpX21lbW9yeV9pbmZvICppbmZvLCAqbjsKKworCWlmICgh
bGlzdF9lbXB0eSgmbWVtX2RldmljZS0+cmVzX2xpc3QpKQorCQlyZXR1cm4gMDsKKworCXN0YXR1
cyA9IGFjcGlfd2Fsa19yZXNvdXJjZXMobWVtX2RldmljZS0+ZGV2aWNlLT5oYW5kbGUsCisJCU1F
VEhPRF9OQU1FX19DUlMsIGFjcGlfbWVtb3J5X2dldF9yZXNvdXJjZSwgbWVtX2RldmljZSk7CisK
KwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZl
KGluZm8sIG4sICZtZW1fZGV2aWNlLT5yZXNfbGlzdCwgbGlzdCkKKwkJCWtmcmVlKGluZm8pOwor
CQlJTklUX0xJU1RfSEVBRCgmbWVtX2RldmljZS0+cmVzX2xpc3QpOworCQlyZXR1cm4gLUVJTlZB
TDsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludAorYWNwaV9tZW1vcnlfZ2V0X2Rl
dmljZShhY3BpX2hhbmRsZSBoYW5kbGUsCisJCSAgICAgICBzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2
aWNlICoqbWVtX2RldmljZSkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJYWNwaV9oYW5kbGUg
cGhhbmRsZTsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSA9IE5VTEw7CisJc3RydWN0IGFj
cGlfZGV2aWNlICpwZGV2aWNlID0gTlVMTDsKKwlpbnQgcmVzdWx0OworCisJaWYgKCFhY3BpX2J1
c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRldmljZSkgJiYgZGV2aWNlKQorCQlnb3RvIGVuZDsKKwor
CXN0YXR1cyA9IGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZwaGFuZGxlKTsKKwlpZiAoQUNQSV9G
QUlMVVJFKHN0YXR1cykpIHsKKwkJcHJfd2FybihQUkVGSVggIkNhbm5vdCBmaW5kIGFjcGkgcGFy
ZW50XG4iKTsKKwkJcmV0dXJuIC1FSU5WQUw7CisJfQorCisJLyogR2V0IHRoZSBwYXJlbnQgZGV2
aWNlICovCisJcmVzdWx0ID0gYWNwaV9idXNfZ2V0X2RldmljZShwaGFuZGxlLCAmcGRldmljZSk7
CisJaWYgKHJlc3VsdCkgeworCQlwcl93YXJuKFBSRUZJWCAiQ2Fubm90IGdldCBhY3BpIGJ1cyBk
ZXZpY2VcbiIpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwkvKgorCSAqIE5vdyBhZGQgdGhl
IG5vdGlmaWVkIGRldmljZS4gIFRoaXMgY3JlYXRlcyB0aGUgYWNwaV9kZXZpY2UKKwkgKiBhbmQg
aW52b2tlcyAuYWRkIGZ1bmN0aW9uCisJICovCisJcmVzdWx0ID0gYWNwaV9idXNfYWRkKCZkZXZp
Y2UsIHBkZXZpY2UsIGhhbmRsZSwgQUNQSV9CVVNfVFlQRV9ERVZJQ0UpOworCWlmIChyZXN1bHQp
IHsKKwkJcHJfd2FybihQUkVGSVggIkNhbm5vdCBhZGQgYWNwaSBidXNcbiIpOworCQlyZXR1cm4g
LUVJTlZBTDsKKwl9CisKK2VuZDoKKwkqbWVtX2RldmljZSA9IGFjcGlfZHJpdmVyX2RhdGEoZGV2
aWNlKTsKKwlpZiAoISgqbWVtX2RldmljZSkpIHsKKwkJcHJfZXJyKFBSRUZJWCAiRHJpdmVyIGRh
dGEgbm90IGZvdW5kXG4iKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCisJcmV0dXJuIDA7Cit9
CisKK3N0YXRpYyBpbnQgYWNwaV9tZW1vcnlfY2hlY2tfZGV2aWNlKHN0cnVjdCBhY3BpX21lbW9y
eV9kZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJdW5zaWduZWQgbG9uZyBsb25nIGN1cnJlbnRfc3Rh
dHVzOworCisJLyogR2V0IGRldmljZSBwcmVzZW50L2Fic2VudCBpbmZvcm1hdGlvbiBmcm9tIHRo
ZSBfU1RBICovCisJaWYgKEFDUElfRkFJTFVSRShhY3BpX2V2YWx1YXRlX2ludGVnZXIobWVtX2Rl
dmljZS0+ZGV2aWNlLT5oYW5kbGUsCisJCQkJIl9TVEEiLCBOVUxMLCAmY3VycmVudF9zdGF0dXMp
KSkKKwkJcmV0dXJuIC1FTk9ERVY7CisJLyoKKwkgKiBDaGVjayBmb3IgZGV2aWNlIHN0YXR1cy4g
RGV2aWNlIHNob3VsZCBiZQorCSAqIHByZXNlbnQvZW5hYmxlZC9mdW5jdGlvbmluZy4KKwkgKi8K
KwlpZiAoISgoY3VycmVudF9zdGF0dXMgJiBBQ1BJX1NUQV9ERVZJQ0VfUFJFU0VOVCkKKwkgICAg
ICAmJiAoY3VycmVudF9zdGF0dXMgJiBBQ1BJX1NUQV9ERVZJQ0VfRU5BQkxFRCkKKwkgICAgICAm
JiAoY3VycmVudF9zdGF0dXMgJiBBQ1BJX1NUQV9ERVZJQ0VfRlVOQ1RJT05JTkcpKSkKKwkJcmV0
dXJuIC1FTk9ERVY7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBhY3BpX21lbW9yeV9k
aXNhYmxlX2RldmljZShzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlKQorewor
CXByX2RlYnVnKFBSRUZJWCAiWGVuIGRvZXMgbm90IHN1cHBvcnQgbWVtb3J5IGhvdHJlbW92ZVxu
Iik7CisKKwlyZXR1cm4gLUVOT1NZUzsKK30KKworc3RhdGljIHZvaWQgYWNwaV9tZW1vcnlfZGV2
aWNlX25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUsIHUzMiBldmVudCwgdm9pZCAqZGF0YSkKK3sK
KwlzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlOworCXN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlOworCXUzMiBvc3RfY29kZSA9IEFDUElfT1NUX1NDX05PTl9TUEVDSUZJQ19G
QUlMVVJFOyAvKiBkZWZhdWx0ICovCisKKwlzd2l0Y2ggKGV2ZW50KSB7CisJY2FzZSBBQ1BJX05P
VElGWV9CVVNfQ0hFQ0s6CisJCUFDUElfREVCVUdfUFJJTlQoKEFDUElfREJfSU5GTywKKwkJCSJc
blJlY2VpdmVkIEJVUyBDSEVDSyBub3RpZmljYXRpb24gZm9yIGRldmljZVxuIikpOworCQkvKiBG
YWxsIFRocm91Z2ggKi8KKwljYXNlIEFDUElfTk9USUZZX0RFVklDRV9DSEVDSzoKKwkJaWYgKGV2
ZW50ID09IEFDUElfTk9USUZZX0RFVklDRV9DSEVDSykKKwkJCUFDUElfREVCVUdfUFJJTlQoKEFD
UElfREJfSU5GTywKKwkJCSJcblJlY2VpdmVkIERFVklDRSBDSEVDSyBub3RpZmljYXRpb24gZm9y
IGRldmljZVxuIikpOworCisJCWlmIChhY3BpX21lbW9yeV9nZXRfZGV2aWNlKGhhbmRsZSwgJm1l
bV9kZXZpY2UpKSB7CisJCQlwcl9lcnIoUFJFRklYICJDYW5ub3QgZmluZCBkcml2ZXIgZGF0YVxu
Iik7CisJCQlicmVhazsKKwkJfQorCisJCW9zdF9jb2RlID0gQUNQSV9PU1RfU0NfU1VDQ0VTUzsK
KwkJYnJlYWs7CisKKwljYXNlIEFDUElfTk9USUZZX0VKRUNUX1JFUVVFU1Q6CisJCUFDUElfREVC
VUdfUFJJTlQoKEFDUElfREJfSU5GTywKKwkJCSJcblJlY2VpdmVkIEVKRUNUIFJFUVVFU1Qgbm90
aWZpY2F0aW9uIGZvciBkZXZpY2VcbiIpKTsKKworCQlpZiAoYWNwaV9idXNfZ2V0X2RldmljZSho
YW5kbGUsICZkZXZpY2UpKSB7CisJCQlwcl9lcnIoUFJFRklYICJEZXZpY2UgZG9lc24ndCBleGlz
dFxuIik7CisJCQlicmVhazsKKwkJfQorCQltZW1fZGV2aWNlID0gYWNwaV9kcml2ZXJfZGF0YShk
ZXZpY2UpOworCQlpZiAoIW1lbV9kZXZpY2UpIHsKKwkJCXByX2VycihQUkVGSVggIkRyaXZlciBE
YXRhIGlzIE5VTExcbiIpOworCQkJYnJlYWs7CisJCX0KKworCQkvKgorCQkgKiBUQkQ6IGltcGxl
bWVudCBhY3BpX21lbW9yeV9kaXNhYmxlX2RldmljZSBhbmQgaW52b2tlCisJCSAqIGFjcGlfYnVz
X3JlbW92ZSBpZiBYZW4gc3VwcG9ydCBob3RyZW1vdmUgaW4gdGhlIGZ1dHVyZQorCQkgKi8KKwkJ
YWNwaV9tZW1vcnlfZGlzYWJsZV9kZXZpY2UobWVtX2RldmljZSk7CisJCWJyZWFrOworCisJZGVm
YXVsdDoKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLAorCQkJCSAgIlVuc3VwcG9y
dGVkIGV2ZW50IFsweCV4XVxuIiwgZXZlbnQpKTsKKwkJLyogbm9uLWhvdHBsdWcgZXZlbnQ7IHBv
c3NpYmx5IGhhbmRsZWQgYnkgb3RoZXIgaGFuZGxlciAqLworCQlyZXR1cm47CisJfQorCisJKHZv
aWQpIGFjcGlfZXZhbHVhdGVfaG90cGx1Z19vc3QoaGFuZGxlLCBldmVudCwgb3N0X2NvZGUsIE5V
TEwpOworCXJldHVybjsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2Fk
ZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKK3sKKwlpbnQgcmVzdWx0OworCXN0cnVjdCBh
Y3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UgPSBOVUxMOworCisKKwlpZiAoIWRldmljZSkK
KwkJcmV0dXJuIC1FSU5WQUw7CisKKwltZW1fZGV2aWNlID0ga3phbGxvYyhzaXplb2Yoc3RydWN0
IGFjcGlfbWVtb3J5X2RldmljZSksIEdGUF9LRVJORUwpOworCWlmICghbWVtX2RldmljZSkKKwkJ
cmV0dXJuIC1FTk9NRU07CisKKwlJTklUX0xJU1RfSEVBRCgmbWVtX2RldmljZS0+cmVzX2xpc3Qp
OworCW1lbV9kZXZpY2UtPmRldmljZSA9IGRldmljZTsKKwlzcHJpbnRmKGFjcGlfZGV2aWNlX25h
bWUoZGV2aWNlKSwgIiVzIiwgQUNQSV9NRU1PUllfREVWSUNFX05BTUUpOworCXNwcmludGYoYWNw
aV9kZXZpY2VfY2xhc3MoZGV2aWNlKSwgIiVzIiwgQUNQSV9NRU1PUllfREVWSUNFX0NMQVNTKTsK
KwlkZXZpY2UtPmRyaXZlcl9kYXRhID0gbWVtX2RldmljZTsKKworCS8qIEdldCB0aGUgcmFuZ2Ug
ZnJvbSB0aGUgX0NSUyAqLworCXJlc3VsdCA9IGFjcGlfbWVtb3J5X2dldF9kZXZpY2VfcmVzb3Vy
Y2VzKG1lbV9kZXZpY2UpOworCWlmIChyZXN1bHQpIHsKKwkJa2ZyZWUobWVtX2RldmljZSk7CisJ
CXJldHVybiByZXN1bHQ7CisJfQorCisJLyoKKwkgKiBGb3IgYm9vdGluZyBleGlzdGVkIG1lbW9y
eSBkZXZpY2VzLCBlYXJseSBib290IGNvZGUgaGFzIHJlY29nbml6ZWQKKwkgKiBtZW1vcnkgYXJl
YSBieSBFRkkvRTgyMC4gSWYgRFNEVCBzaG93cyB0aGVzZSBtZW1vcnkgZGV2aWNlcyBvbiBib290
LAorCSAqIGhvdHBsdWcgaXMgbm90IG5lY2Vzc2FyeSBmb3IgdGhlbS4KKwkgKiBGb3IgaG90LWFk
ZGVkIG1lbW9yeSBkZXZpY2VzIGR1cmluZyBydW50aW1lLCBpdCBuZWVkIGh5cGVyY2FsbCB0bwor
CSAqIFhlbiBoeXBlcnZpc29yIHRvIGFkZCBtZW1vcnkuCisJICovCisJaWYgKCFhY3BpX2hvdG1l
bV9pbml0aWFsaXplZCkKKwkJcmV0dXJuIDA7CisKKwlpZiAoIWFjcGlfbWVtb3J5X2NoZWNrX2Rl
dmljZShtZW1fZGV2aWNlKSkKKwkJcmVzdWx0ID0geGVuX2FjcGlfbWVtb3J5X2VuYWJsZV9kZXZp
Y2UobWVtX2RldmljZSk7CisKKwlyZXR1cm4gcmVzdWx0OworfQorCitzdGF0aWMgaW50IHhlbl9h
Y3BpX21lbW9yeV9kZXZpY2VfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQg
dHlwZSkKK3sKKwlzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlID0gTlVMTDsK
KworCWlmICghZGV2aWNlIHx8ICFhY3BpX2RyaXZlcl9kYXRhKGRldmljZSkpCisJCXJldHVybiAt
RUlOVkFMOworCisJbWVtX2RldmljZSA9IGFjcGlfZHJpdmVyX2RhdGEoZGV2aWNlKTsKKwlrZnJl
ZShtZW1fZGV2aWNlKTsKKworCXJldHVybiAwOworfQorCisvKgorICogSGVscGVyIGZ1bmN0aW9u
IHRvIGNoZWNrIGZvciBtZW1vcnkgZGV2aWNlCisgKi8KK3N0YXRpYyBhY3BpX3N0YXR1cyBpc19t
ZW1vcnlfZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwljaGFyICpoYXJkd2FyZV9pZDsK
KwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJc3RydWN0IGFjcGlfZGV2aWNlX2luZm8gKmluZm87CisK
KwlzdGF0dXMgPSBhY3BpX2dldF9vYmplY3RfaW5mbyhoYW5kbGUsICZpbmZvKTsKKwlpZiAoQUNQ
SV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiBzdGF0dXM7CisKKwlpZiAoIShpbmZvLT52YWxp
ZCAmIEFDUElfVkFMSURfSElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0dXJuIEFFX0VSUk9S
OworCX0KKworCWhhcmR3YXJlX2lkID0gaW5mby0+aGFyZHdhcmVfaWQuc3RyaW5nOworCWlmICgo
aGFyZHdhcmVfaWQgPT0gTlVMTCkgfHwKKwkgICAgKHN0cmNtcChoYXJkd2FyZV9pZCwgQUNQSV9N
RU1PUllfREVWSUNFX0hJRCkpKQorCQlzdGF0dXMgPSBBRV9FUlJPUjsKKworCWtmcmVlKGluZm8p
OworCXJldHVybiBzdGF0dXM7Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1cworYWNwaV9tZW1vcnlf
cmVnaXN0ZXJfbm90aWZ5X2hhbmRsZXIoYWNwaV9oYW5kbGUgaGFuZGxlLAorCQkJCSAgICB1MzIg
bGV2ZWwsIHZvaWQgKmN0eHQsIHZvaWQgKipyZXR2KQoreworCWFjcGlfc3RhdHVzIHN0YXR1czsK
KworCXN0YXR1cyA9IGlzX21lbW9yeV9kZXZpY2UoaGFuZGxlKTsKKwlpZiAoQUNQSV9GQUlMVVJF
KHN0YXR1cykpCisJCXJldHVybiBBRV9PSzsJLyogY29udGludWUgKi8KKworCXN0YXR1cyA9IGFj
cGlfaW5zdGFsbF9ub3RpZnlfaGFuZGxlcihoYW5kbGUsIEFDUElfU1lTVEVNX05PVElGWSwKKwkJ
CQkJICAgICBhY3BpX21lbW9yeV9kZXZpY2Vfbm90aWZ5LCBOVUxMKTsKKwkvKiBjb250aW51ZSAq
LworCXJldHVybiBBRV9PSzsKK30KKworc3RhdGljIGFjcGlfc3RhdHVzCithY3BpX21lbW9yeV9k
ZXJlZ2lzdGVyX25vdGlmeV9oYW5kbGVyKGFjcGlfaGFuZGxlIGhhbmRsZSwKKwkJCQkgICAgICB1
MzIgbGV2ZWwsIHZvaWQgKmN0eHQsIHZvaWQgKipyZXR2KQoreworCWFjcGlfc3RhdHVzIHN0YXR1
czsKKworCXN0YXR1cyA9IGlzX21lbW9yeV9kZXZpY2UoaGFuZGxlKTsKKwlpZiAoQUNQSV9GQUlM
VVJFKHN0YXR1cykpCisJCXJldHVybiBBRV9PSzsJLyogY29udGludWUgKi8KKworCXN0YXR1cyA9
IGFjcGlfcmVtb3ZlX25vdGlmeV9oYW5kbGVyKGhhbmRsZSwKKwkJCQkJICAgIEFDUElfU1lTVEVN
X05PVElGWSwKKwkJCQkJICAgIGFjcGlfbWVtb3J5X2RldmljZV9ub3RpZnkpOworCisJcmV0dXJu
IEFFX09LOwkvKiBjb250aW51ZSAqLworfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2
aWNlX2lkIG1lbW9yeV9kZXZpY2VfaWRzW10gPSB7CisJe0FDUElfTUVNT1JZX0RFVklDRV9ISUQs
IDB9LAorCXsiIiwgMH0sCit9OworTU9EVUxFX0RFVklDRV9UQUJMRShhY3BpLCBtZW1vcnlfZGV2
aWNlX2lkcyk7CisKK3N0YXRpYyBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX2FjcGlfbWVtb3J5X2Rl
dmljZV9kcml2ZXIgPSB7CisJLm5hbWUgPSAiYWNwaV9tZW1ob3RwbHVnIiwKKwkuY2xhc3MgPSBB
Q1BJX01FTU9SWV9ERVZJQ0VfQ0xBU1MsCisJLmlkcyA9IG1lbW9yeV9kZXZpY2VfaWRzLAorCS5v
cHMgPSB7CisJCS5hZGQgPSB4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2FkZCwKKwkJLnJlbW92ZSA9
IHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfcmVtb3ZlLAorCQl9LAorfTsKKworc3RhdGljIGludCBf
X2luaXQgeGVuX2FjcGlfbWVtb3J5X2RldmljZV9pbml0KHZvaWQpCit7CisJaW50IHJlc3VsdDsK
KwlhY3BpX3N0YXR1cyBzdGF0dXM7CisKKwlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQorCQly
ZXR1cm4gLUVOT0RFVjsKKworCS8qIHVucmVnaXN0ZXIgdGhlIHN0dWIgd2hpY2ggb25seSB1c2Vk
IHRvIHJlc2VydmUgZHJpdmVyIHNwYWNlICovCisJeGVuX3N0dWJfbWVtb3J5X2RldmljZV9leGl0
KCk7CisKKwlyZXN1bHQgPSBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9hY3BpX21lbW9y
eV9kZXZpY2VfZHJpdmVyKTsKKwlpZiAocmVzdWx0IDwgMCkgeworCQl4ZW5fc3R1Yl9tZW1vcnlf
ZGV2aWNlX2luaXQoKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCisJc3RhdHVzID0gYWNwaV93
YWxrX25hbWVzcGFjZShBQ1BJX1RZUEVfREVWSUNFLCBBQ1BJX1JPT1RfT0JKRUNULAorCQkJCSAg
ICAgQUNQSV9VSU5UMzJfTUFYLAorCQkJCSAgICAgYWNwaV9tZW1vcnlfcmVnaXN0ZXJfbm90aWZ5
X2hhbmRsZXIsCisJCQkJICAgICBOVUxMLCBOVUxMLCBOVUxMKTsKKworCWlmIChBQ1BJX0ZBSUxV
UkUoc3RhdHVzKSkgeworCQlwcl93YXJuKFBSRUZJWCAid2Fsa19uYW1lc3BhY2UgZmFpbGVkXG4i
KTsKKwkJYWNwaV9idXNfdW5yZWdpc3Rlcl9kcml2ZXIoJnhlbl9hY3BpX21lbW9yeV9kZXZpY2Vf
ZHJpdmVyKTsKKwkJeGVuX3N0dWJfbWVtb3J5X2RldmljZV9pbml0KCk7CisJCXJldHVybiAtRU5P
REVWOworCX0KKworCWFjcGlfaG90bWVtX2luaXRpYWxpemVkID0gdHJ1ZTsKKwlyZXR1cm4gMDsK
K30KKworc3RhdGljIHZvaWQgX19leGl0IHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfZXhpdCh2b2lk
KQoreworCWFjcGlfc3RhdHVzIHN0YXR1czsKKworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkp
CisJCXJldHVybjsKKworCXN0YXR1cyA9IGFjcGlfd2Fsa19uYW1lc3BhY2UoQUNQSV9UWVBFX0RF
VklDRSwgQUNQSV9ST09UX09CSkVDVCwKKwkJCQkgICAgIEFDUElfVUlOVDMyX01BWCwKKwkJCQkg
ICAgIGFjcGlfbWVtb3J5X2RlcmVnaXN0ZXJfbm90aWZ5X2hhbmRsZXIsCisJCQkJICAgICBOVUxM
LCBOVUxMLCBOVUxMKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXByX3dhcm4oUFJF
RklYICJ3YWxrX25hbWVzcGFjZSBmYWlsZWRcbiIpOworCisJYWNwaV9idXNfdW5yZWdpc3Rlcl9k
cml2ZXIoJnhlbl9hY3BpX21lbW9yeV9kZXZpY2VfZHJpdmVyKTsKKworCS8qCisJICogc3R1YiBy
ZXNlcnZlIHNwYWNlIGFnYWluIHRvIHByZXZlbnQgYW55IGNoYW5jZSBvZiBuYXRpdmUKKwkgKiBk
cml2ZXIgbG9hZGluZy4KKwkgKi8KKwl4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQoKTsKKwly
ZXR1cm47Cit9CisKK21vZHVsZV9pbml0KHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfaW5pdCk7Citt
b2R1bGVfZXhpdCh4ZW5fYWNwaV9tZW1vcnlfZGV2aWNlX2V4aXQpOworQUNQSV9NT0RVTEVfTkFN
RSgieGVuLWFjcGktbWVtaG90cGx1ZyIpOworTU9EVUxFX0FVVEhPUigiTGl1IEppbnNvbmcgPGpp
bnNvbmcubGl1QGludGVsLmNvbT4iKTsKK01PRFVMRV9ERVNDUklQVElPTigiWGVuIEhvdHBsdWcg
TWVtIERyaXZlciIpOworTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaAppbmRleCA1ZTM2OTMyLi4yYzRmYjRiIDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApA
QCAtMzI0LDEwICszMjQsMTQgQEAgc3RydWN0IHhlbnBmX2NwdV9vbCB7CiB9OwogREVGSU5FX0dV
RVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1X29sKTsKIAotLyoKLSAqIENNRCA1OCBhbmQgNTkg
YXJlIHJlc2VydmVkIGZvciBjcHUgaG90YWRkIGFuZCBtZW1vcnkgaG90YWRkLAotICogd2hpY2gg
YXJlIGFscmVhZHkgb2NjdXBpZWQgYXQgWGVuIGh5cGVydmlzb3Igc2lkZS4KLSAqLworI2RlZmlu
ZSBYRU5QRl9tZW1faG90YWRkCTU5CitzdHJ1Y3QgeGVucGZfbWVtX2hvdGFkZCB7CisJdWludDY0
X3Qgc3BmbjsKKwl1aW50NjRfdCBlcGZuOworCXVpbnQzMl90IHB4bTsKKwl1aW50MzJfdCBmbGFn
czsKK307CisKICNkZWZpbmUgWEVOUEZfY29yZV9wYXJraW5nICAgICA2MAogc3RydWN0IHhlbnBm
X2NvcmVfcGFya2luZyB7CiAJLyogSU4gdmFyaWFibGVzICovCkBAIC0zNTcsNiArMzYxLDcgQEAg
c3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3Bt
aW5mbyBzZXRfcG1pbmZvOwogCQlzdHJ1Y3QgeGVucGZfcGNwdWluZm8gICAgICAgICAgcGNwdV9p
bmZvOwogCQlzdHJ1Y3QgeGVucGZfY3B1X29sICAgICAgICAgICAgY3B1X29sOworCQlzdHJ1Y3Qg
eGVucGZfbWVtX2hvdGFkZCAgICAgICAgbWVtX2FkZDsKIAkJc3RydWN0IHhlbnBmX2NvcmVfcGFy
a2luZyAgICAgIGNvcmVfcGFya2luZzsKIAkJdWludDhfdCAgICAgICAgICAgICAgICAgICAgICAg
IHBhZFsxMjhdOwogCX0gdTsKLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6D6SHSMSX101ccrcorpi_--
