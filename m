Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3AOMeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:34:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:60289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab3AOMeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208,223";a="272233811"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V1 3/3] Xen processor driver
Thread-Topic: [PATCH V1 3/3] Xen processor driver
Thread-Index: Ac3zHJb08/CFWeJCRuaAEtbm5gHOzg==
Date: Tue, 15 Jan 2013 12:33:58 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C3DE6@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353C3DE6SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DE6SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From c0166fed6d7ec8b902900157f02ad1eb189777d5 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 14 Jan 2013 15:21:24 +0800
Subject: [PATCH 3/3] Xen processor driver

This patch implement real Xen processor driver as module.
When loaded, it replaces Xen processor stub driver.

For booting existed processor devices, Xen processor driver
enumerates them. For hotadded processor devices, which added
at runtime and notify OS via device or container event, Xen
processor driver is invoked to add them, parsing processors
information, hypercalling to Xen hypervisor to add processors,
and finally setting up new /sys interface for them.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig              |   12 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/pcpu.c               |   30 +++
 drivers/xen/xen-processor.c      |  466 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/acpi.h               |    2 +
 include/xen/interface/platform.h |    8 +
 6 files changed, 519 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-processor.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 2dc7022..ca2535a 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -202,6 +202,18 @@ config XEN_ACPI_HOTPLUG_MEMORY
 	  to hot-add memory at runtime (the hot-added memory cannot be
 	  removed until machine stop), select Y/M here, otherwise select N.
=20
+config XEN_PROCESSOR
+	tristate "Xen processor driver"
+	depends on XEN_STUB && ACPI
+	select ACPI_CONTAINER
+	default n
+	help
+	  Xen processor enumerating and hotplugging
+
+	  For hotplugging, currently Xen only support ACPI cpu hotadd.
+	  If you want to hotadd cpu at runtime (the hotadded cpu cannot
+	  be removed until machine stop), select Y/M here, otherwise N.
+
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 1605f59..82163e6 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_STUB)			+=3D xen-stub.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+=3D xen-acpi-memhotplug.o
+obj-$(CONFIG_XEN_PROCESSOR)		+=3D xen-processor.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 067fcfa..2fd5e78 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -333,6 +333,36 @@ static irqreturn_t xen_pcpu_interrupt(int irq, void *d=
ev_id)
 	return IRQ_HANDLED;
 }
=20
+void xen_pcpu_hotplug_sync(void)
+{
+	schedule_work(&xen_pcpu_work);
+}
+EXPORT_SYMBOL_GPL(xen_pcpu_hotplug_sync);
+
+int xen_pcpu_id(uint32_t acpi_id)
+{
+	int cpu_id =3D 0, max_id =3D 0;
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_get_cpuinfo;
+	while (cpu_id <=3D max_id) {
+		op.u.pcpu_info.xen_cpuid =3D cpu_id;
+		if (HYPERVISOR_dom0_op(&op)) {
+			cpu_id++;
+			continue;
+		}
+
+		if (acpi_id =3D=3D op.u.pcpu_info.acpi_id)
+			return cpu_id;
+		if (op.u.pcpu_info.max_present > max_id)
+			max_id =3D op.u.pcpu_info.max_present;
+		cpu_id++;
+	}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(xen_pcpu_id);
+
 static int __init xen_pcpu_init(void)
 {
 	int irq, ret;
diff --git a/drivers/xen/xen-processor.c b/drivers/xen/xen-processor.c
new file mode 100644
index 0000000..c5e39b6
--- /dev/null
+++ b/drivers/xen/xen-processor.c
@@ -0,0 +1,466 @@
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
+#include <linux/cpu.h>
+#include <linux/acpi.h>
+#include <linux/uaccess.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/processor.h>
+
+#include <xen/acpi.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+
+#define PREFIX "ACPI:xen_cpu_hotplug:"
+
+#define INSTALL_NOTIFY_HANDLER		0
+#define UNINSTALL_NOTIFY_HANDLER	1
+
+static acpi_status xen_acpi_cpu_hotadd(struct acpi_processor *pr);
+
+/* -----------------------------------------------------------------------=
---
+				Driver Interface
+--------------------------------------------------------------------------=
 */
+
+static int xen_acpi_processor_enable(struct acpi_device *device)
+{
+	acpi_status status =3D 0;
+	unsigned long long value;
+	union acpi_object object =3D { 0 };
+	struct acpi_buffer buffer =3D { sizeof(union acpi_object), &object };
+	struct acpi_processor *pr;
+
+	pr =3D acpi_driver_data(device);
+	if (!pr) {
+		pr_err(PREFIX "Cannot find driver data\n");
+		return -EINVAL;
+	}
+
+	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_OBJECT_HID)) {
+		/* Declared with "Processor" statement; match ProcessorID */
+		status =3D acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status)) {
+			pr_err(PREFIX "Evaluating processor object\n");
+			return -ENODEV;
+		}
+
+		pr->acpi_id =3D object.processor.proc_id;
+	} else {
+		/* Declared with "Device" statement; match _UID */
+		status =3D acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
+						NULL, &value);
+		if (ACPI_FAILURE(status)) {
+			pr_err(PREFIX "Evaluating processor _UID\n");
+			return -ENODEV;
+		}
+
+		pr->acpi_id =3D value;
+	}
+
+	pr->id =3D xen_pcpu_id(pr->acpi_id);
+
+	if ((int)pr->id < 0)
+		if (ACPI_FAILURE(xen_acpi_cpu_hotadd(pr))) {
+			pr_err(PREFIX "Hotadd CPU (acpi_id =3D %d) fail.\n",
+					pr->acpi_id);
+			return -ENODEV;
+		}
+
+	return 0;
+}
+
+static int __cpuinit xen_acpi_processor_add(struct acpi_device *device)
+{
+	int ret;
+	struct acpi_processor *pr;
+
+	if (!device)
+		return -EINVAL;
+
+	pr =3D kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+	if (!pr)
+		return -ENOMEM;
+
+	pr->handle =3D device->handle;
+	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
+	device->driver_data =3D pr;
+
+	ret =3D xen_acpi_processor_enable(device);
+	if (ret)
+		pr_err(PREFIX "Error when enable Xen processor\n");
+
+	return ret;
+}
+
+static int xen_acpi_processor_remove(struct acpi_device *device, int type)
+{
+	struct acpi_processor *pr;
+
+	if (!device)
+		return -EINVAL;
+
+	pr =3D acpi_driver_data(device);
+	if (!pr)
+		return -EINVAL;
+
+	kfree(pr);
+	return 0;
+}
+
+/*--------------------------------------------------------------
+		Acpi processor hotplug support
+--------------------------------------------------------------*/
+
+static int is_processor_present(acpi_handle handle)
+{
+	acpi_status status;
+	unsigned long long sta =3D 0;
+
+
+	status =3D acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+
+	if (ACPI_SUCCESS(status) && (sta & ACPI_STA_DEVICE_PRESENT))
+		return 1;
+
+	/*
+	 * _STA is mandatory for a processor that supports hot plug
+	 */
+	if (status =3D=3D AE_NOT_FOUND)
+		pr_info(PREFIX "Processor does not support hot plug\n");
+	else
+		pr_info(PREFIX "Processor Device is not present");
+	return 0;
+}
+
+static int xen_apic_id(acpi_handle handle)
+{
+	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	struct acpi_madt_local_apic *lapic;
+	int apic_id;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
+		return -EINVAL;
+
+	if (!buffer.length || !buffer.pointer)
+		return -EINVAL;
+
+	obj =3D buffer.pointer;
+	if (obj->type !=3D ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(*lapic)) {
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	lapic =3D (struct acpi_madt_local_apic *)obj->buffer.pointer;
+
+	if (lapic->header.type !=3D ACPI_MADT_TYPE_LOCAL_APIC ||
+	    !(lapic->lapic_flags & ACPI_MADT_ENABLED)) {
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	apic_id =3D (uint32_t)lapic->id;
+	kfree(buffer.pointer);
+	buffer.length =3D ACPI_ALLOCATE_BUFFER;
+	buffer.pointer =3D NULL;
+
+	return apic_id;
+}
+
+static int xen_hotadd_cpu(struct acpi_processor *pr)
+{
+	int cpu_id, apic_id, pxm;
+	struct xen_platform_op op;
+
+	apic_id =3D xen_apic_id(pr->handle);
+	if (apic_id < 0) {
+		pr_err(PREFIX "Fail to get apic_id for acpi_id %d\n",
+				pr->acpi_id);
+		return -ENODEV;
+	}
+
+	pxm =3D xen_acpi_get_pxm(pr->handle);
+	if (pxm < 0) {
+		pr_err(PREFIX "Fail to get _PXM for acpi_id %d\n",
+				pr->acpi_id);
+		return pxm;
+	}
+
+	op.cmd =3D XENPF_cpu_hotadd;
+	op.u.cpu_add.apic_id =3D apic_id;
+	op.u.cpu_add.acpi_id =3D pr->acpi_id;
+	op.u.cpu_add.pxm =3D pxm;
+
+	cpu_id =3D HYPERVISOR_dom0_op(&op);
+	if (cpu_id < 0)
+		pr_err(PREFIX "Fail to hotadd CPU for acpi_id %d\n",
+				pr->acpi_id);
+
+	return cpu_id;
+}
+
+static acpi_status xen_acpi_cpu_hotadd(struct acpi_processor *pr)
+{
+	if (!is_processor_present(pr->handle))
+		return AE_ERROR;
+
+	pr->id =3D xen_hotadd_cpu(pr);
+	if ((int)pr->id < 0)
+		return AE_ERROR;
+
+	xen_pcpu_hotplug_sync();
+
+	return AE_OK;
+}
+
+static
+int acpi_processor_device_add(acpi_handle handle, struct acpi_device **dev=
ice)
+{
+	acpi_handle phandle;
+	struct acpi_device *pdev;
+
+	if (acpi_get_parent(handle, &phandle))
+		return -ENODEV;
+
+	if (acpi_bus_get_device(phandle, &pdev))
+		return -ENODEV;
+
+	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int acpi_processor_device_remove(struct acpi_device *device)
+{
+	pr_debug(PREFIX "Xen does not support CPU hotremove\n");
+
+	return -ENOSYS;
+}
+
+static void acpi_processor_hotplug_notify(acpi_handle handle,
+					  u32 event, void *data)
+{
+	struct acpi_processor *pr;
+	struct acpi_device *device =3D NULL;
+	u32 ost_code =3D ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
+	int result;
+
+	switch (event) {
+	case ACPI_NOTIFY_BUS_CHECK:
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"Processor driver received %s event\n",
+			(event =3D=3D ACPI_NOTIFY_BUS_CHECK) ?
+			"ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK"));
+
+		if (!is_processor_present(handle))
+			break;
+
+		if (!acpi_bus_get_device(handle, &device))
+			break;
+
+		result =3D acpi_processor_device_add(handle, &device);
+		if (result) {
+			pr_err(PREFIX "Unable to add the device\n");
+			break;
+		}
+
+		ost_code =3D ACPI_OST_SC_SUCCESS;
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
+
+		if (acpi_bus_get_device(handle, &device)) {
+			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
+			break;
+		}
+		pr =3D acpi_driver_data(device);
+		if (!pr) {
+			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
+			break;
+		}
+
+		/*
+		 * TBD: implement acpi_processor_device_remove if Xen support
+		 * CPU hotremove in the future.
+		 */
+		acpi_processor_device_remove(device);
+		break;
+
+	default:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Unsupported event [0x%x]\n", event));
+
+		/* non-hotplug event; possibly handled by other handler */
+		return;
+	}
+
+	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
+	return;
+}
+
+static acpi_status is_processor_device(acpi_handle handle)
+{
+	struct acpi_device_info *info;
+	char *hid;
+	acpi_status status;
+
+	status =3D acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (info->type =3D=3D ACPI_TYPE_PROCESSOR) {
+		kfree(info);
+		return AE_OK;	/* found a processor object */
+	}
+
+	if (!(info->valid & ACPI_VALID_HID)) {
+		kfree(info);
+		return AE_ERROR;
+	}
+
+	hid =3D info->hardware_id.string;
+	if ((hid =3D=3D NULL) || strcmp(hid, ACPI_PROCESSOR_DEVICE_HID)) {
+		kfree(info);
+		return AE_ERROR;
+	}
+
+	kfree(info);
+	return AE_OK;	/* found a processor device object */
+}
+
+static acpi_status
+processor_walk_namespace_cb(acpi_handle handle,
+			    u32 lvl, void *context, void **rv)
+{
+	acpi_status status;
+	int *action =3D context;
+
+	status =3D is_processor_device(handle);
+	if (ACPI_FAILURE(status))
+		return AE_OK;	/* not a processor; continue to walk */
+
+	switch (*action) {
+	case INSTALL_NOTIFY_HANDLER:
+		acpi_install_notify_handler(handle,
+					    ACPI_SYSTEM_NOTIFY,
+					    acpi_processor_hotplug_notify,
+					    NULL);
+		break;
+	case UNINSTALL_NOTIFY_HANDLER:
+		acpi_remove_notify_handler(handle,
+					   ACPI_SYSTEM_NOTIFY,
+					   acpi_processor_hotplug_notify);
+		break;
+	default:
+		break;
+	}
+
+	/* found a processor; skip walking underneath */
+	return AE_CTRL_DEPTH;
+}
+
+static
+void acpi_processor_install_hotplug_notify(void)
+{
+	int action =3D INSTALL_NOTIFY_HANDLER;
+	acpi_walk_namespace(ACPI_TYPE_ANY,
+			    ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX,
+			    processor_walk_namespace_cb, NULL, &action, NULL);
+}
+
+static
+void acpi_processor_uninstall_hotplug_notify(void)
+{
+	int action =3D UNINSTALL_NOTIFY_HANDLER;
+	acpi_walk_namespace(ACPI_TYPE_ANY,
+			    ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX,
+			    processor_walk_namespace_cb, NULL, &action, NULL);
+}
+
+static const struct acpi_device_id processor_device_ids[] =3D {
+	{ACPI_PROCESSOR_OBJECT_HID, 0},
+	{ACPI_PROCESSOR_DEVICE_HID, 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, processor_device_ids);
+
+static struct acpi_driver xen_acpi_processor_driver =3D {
+	.name =3D "processor",
+	.class =3D ACPI_PROCESSOR_CLASS,
+	.ids =3D processor_device_ids,
+	.ops =3D {
+		.add =3D xen_acpi_processor_add,
+		.remove =3D xen_acpi_processor_remove,
+		},
+};
+
+static int __init xen_acpi_processor_init(void)
+{
+	int result =3D 0;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* unregister the stub which only used to reserve driver space */
+	acpi_bus_unregister_driver(&xen_stub_processor_driver);
+
+	result =3D acpi_bus_register_driver(&xen_acpi_processor_driver);
+	if (result < 0) {
+		acpi_bus_register_driver(&xen_stub_processor_driver);
+		return result;
+	}
+
+	acpi_processor_install_hotplug_notify();
+	return 0;
+}
+
+static void __exit xen_acpi_processor_exit(void)
+{
+	if (!xen_initial_domain())
+		return;
+
+	acpi_processor_uninstall_hotplug_notify();
+
+	acpi_bus_unregister_driver(&xen_acpi_processor_driver);
+
+	/*
+	 * stub reserve space again to prevent any chance of native
+	 * driver loading.
+	 */
+	acpi_bus_register_driver(&xen_stub_processor_driver);
+	return;
+}
+
+module_init(xen_acpi_processor_init);
+module_exit(xen_acpi_processor_exit);
+ACPI_MODULE_NAME("xen-processor");
+MODULE_AUTHOR("Liu Jinsong <jinsong.liu@intel.com>");
+MODULE_DESCRIPTION("Xen Processor Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 5ac46d3..3de217e 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -45,6 +45,8 @@
 #define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
=20
 extern struct acpi_driver xen_stub_memory_device_driver;
+extern void xen_pcpu_hotplug_sync(void);
+extern int xen_pcpu_id(uint32_t acpi_id);
=20
 static inline int xen_acpi_get_pxm(acpi_handle h)
 {
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 2c4fb4b..c57d5f6 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,6 +324,13 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
+#define XENPF_cpu_hotadd	58
+struct xenpf_cpu_hotadd {
+	uint32_t apic_id;
+	uint32_t acpi_id;
+	uint32_t pxm;
+};
+
 #define XENPF_mem_hotadd	59
 struct xenpf_mem_hotadd {
 	uint64_t spfn;
@@ -361,6 +368,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_cpu_hotadd        cpu_add;
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		uint8_t                        pad[128];
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DE6SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-processor-driver.patch"
Content-Description: 0003-Xen-processor-driver.patch
Content-Disposition: attachment; filename="0003-Xen-processor-driver.patch";
	size=16317; creation-date="Tue, 15 Jan 2013 12:28:09 GMT";
	modification-date="Tue, 15 Jan 2013 20:17:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjMDE2NmZlZDZkN2VjOGI5MDI5MDAxNTdmMDJhZDFlYjE4OTc3N2Q1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBNb24sIDE0IEphbiAyMDEzIDE1OjIxOjI0ICswODAwClN1YmplY3Q6IFtQQVRDSCAzLzNd
IFhlbiBwcm9jZXNzb3IgZHJpdmVyCgpUaGlzIHBhdGNoIGltcGxlbWVudCByZWFsIFhlbiBwcm9j
ZXNzb3IgZHJpdmVyIGFzIG1vZHVsZS4KV2hlbiBsb2FkZWQsIGl0IHJlcGxhY2VzIFhlbiBwcm9j
ZXNzb3Igc3R1YiBkcml2ZXIuCgpGb3IgYm9vdGluZyBleGlzdGVkIHByb2Nlc3NvciBkZXZpY2Vz
LCBYZW4gcHJvY2Vzc29yIGRyaXZlcgplbnVtZXJhdGVzIHRoZW0uIEZvciBob3RhZGRlZCBwcm9j
ZXNzb3IgZGV2aWNlcywgd2hpY2ggYWRkZWQKYXQgcnVudGltZSBhbmQgbm90aWZ5IE9TIHZpYSBk
ZXZpY2Ugb3IgY29udGFpbmVyIGV2ZW50LCBYZW4KcHJvY2Vzc29yIGRyaXZlciBpcyBpbnZva2Vk
IHRvIGFkZCB0aGVtLCBwYXJzaW5nIHByb2Nlc3NvcnMKaW5mb3JtYXRpb24sIGh5cGVyY2FsbGlu
ZyB0byBYZW4gaHlwZXJ2aXNvciB0byBhZGQgcHJvY2Vzc29ycywKYW5kIGZpbmFsbHkgc2V0dGlu
ZyB1cCBuZXcgL3N5cyBpbnRlcmZhY2UgZm9yIHRoZW0uCgpTaWduZWQtb2ZmLWJ5OiBMaXUgSmlu
c29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMveGVuL0tjb25maWcgICAg
ICAgICAgICAgIHwgICAxMiArCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICB8ICAg
IDEgKwogZHJpdmVycy94ZW4vcGNwdS5jICAgICAgICAgICAgICAgfCAgIDMwICsrKwogZHJpdmVy
cy94ZW4veGVuLXByb2Nlc3Nvci5jICAgICAgfCAgNDY2ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrCiBpbmNsdWRlL3hlbi9hY3BpLmggICAgICAgICAgICAgICB8ICAgIDIg
KwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggfCAgICA4ICsKIDYgZmlsZXMgY2hh
bmdlZCwgNTE5IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2
NDQgZHJpdmVycy94ZW4veGVuLXByb2Nlc3Nvci5jCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4v
S2NvbmZpZyBiL2RyaXZlcnMveGVuL0tjb25maWcKaW5kZXggMmRjNzAyMi4uY2EyNTM1YSAxMDA2
NDQKLS0tIGEvZHJpdmVycy94ZW4vS2NvbmZpZworKysgYi9kcml2ZXJzL3hlbi9LY29uZmlnCkBA
IC0yMDIsNiArMjAyLDE4IEBAIGNvbmZpZyBYRU5fQUNQSV9IT1RQTFVHX01FTU9SWQogCSAgdG8g
aG90LWFkZCBtZW1vcnkgYXQgcnVudGltZSAodGhlIGhvdC1hZGRlZCBtZW1vcnkgY2Fubm90IGJl
CiAJICByZW1vdmVkIHVudGlsIG1hY2hpbmUgc3RvcCksIHNlbGVjdCBZL00gaGVyZSwgb3RoZXJ3
aXNlIHNlbGVjdCBOLgogCitjb25maWcgWEVOX1BST0NFU1NPUgorCXRyaXN0YXRlICJYZW4gcHJv
Y2Vzc29yIGRyaXZlciIKKwlkZXBlbmRzIG9uIFhFTl9TVFVCICYmIEFDUEkKKwlzZWxlY3QgQUNQ
SV9DT05UQUlORVIKKwlkZWZhdWx0IG4KKwloZWxwCisJICBYZW4gcHJvY2Vzc29yIGVudW1lcmF0
aW5nIGFuZCBob3RwbHVnZ2luZworCisJICBGb3IgaG90cGx1Z2dpbmcsIGN1cnJlbnRseSBYZW4g
b25seSBzdXBwb3J0IEFDUEkgY3B1IGhvdGFkZC4KKwkgIElmIHlvdSB3YW50IHRvIGhvdGFkZCBj
cHUgYXQgcnVudGltZSAodGhlIGhvdGFkZGVkIGNwdSBjYW5ub3QKKwkgIGJlIHJlbW92ZWQgdW50
aWwgbWFjaGluZSBzdG9wKSwgc2VsZWN0IFkvTSBoZXJlLCBvdGhlcndpc2UgTi4KKwogY29uZmln
IFhFTl9BQ1BJX1BST0NFU1NPUgogCXRyaXN0YXRlICJYZW4gQUNQSSBwcm9jZXNzb3IiCiAJZGVw
ZW5kcyBvbiBYRU4gJiYgWDg2ICYmIEFDUElfUFJPQ0VTU09SICYmIENQVV9GUkVRCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3hlbi9NYWtlZmlsZSBiL2RyaXZlcnMveGVuL01ha2VmaWxlCmluZGV4IDE2
MDVmNTkuLjgyMTYzZTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL01ha2VmaWxlCisrKyBiL2Ry
aXZlcnMveGVuL01ha2VmaWxlCkBAIC0zMiw2ICszMiw3IEBAIG9iai0kKENPTkZJR19YRU5fUENJ
REVWX0JBQ0tFTkQpCSs9IHhlbi1wY2liYWNrLwogb2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJ
Kz0geGVuLXByaXZjbWQubwogb2JqLSQoQ09ORklHX1hFTl9TVFVCKQkJCSs9IHhlbi1zdHViLm8K
IG9iai0kKENPTkZJR19YRU5fQUNQSV9IT1RQTFVHX01FTU9SWSkJKz0geGVuLWFjcGktbWVtaG90
cGx1Zy5vCitvYmotJChDT05GSUdfWEVOX1BST0NFU1NPUikJCSs9IHhlbi1wcm9jZXNzb3Iubwog
b2JqLSQoQ09ORklHX1hFTl9BQ1BJX1BST0NFU1NPUikJKz0geGVuLWFjcGktcHJvY2Vzc29yLm8K
IHhlbi1ldnRjaG4teQkJCQk6PSBldnRjaG4ubwogeGVuLWdudGRldi15CQkJCTo9IGdudGRldi5v
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wY3B1LmMgYi9kcml2ZXJzL3hlbi9wY3B1LmMKaW5k
ZXggMDY3ZmNmYS4uMmZkNWU3OCAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vcGNwdS5jCisrKyBi
L2RyaXZlcnMveGVuL3BjcHUuYwpAQCAtMzMzLDYgKzMzMywzNiBAQCBzdGF0aWMgaXJxcmV0dXJu
X3QgeGVuX3BjcHVfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkKIAlyZXR1cm4gSVJR
X0hBTkRMRUQ7CiB9CiAKK3ZvaWQgeGVuX3BjcHVfaG90cGx1Z19zeW5jKHZvaWQpCit7CisJc2No
ZWR1bGVfd29yaygmeGVuX3BjcHVfd29yayk7Cit9CitFWFBPUlRfU1lNQk9MX0dQTCh4ZW5fcGNw
dV9ob3RwbHVnX3N5bmMpOworCitpbnQgeGVuX3BjcHVfaWQodWludDMyX3QgYWNwaV9pZCkKK3sK
KwlpbnQgY3B1X2lkID0gMCwgbWF4X2lkID0gMDsKKwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9w
OworCisJb3AuY21kID0gWEVOUEZfZ2V0X2NwdWluZm87CisJd2hpbGUgKGNwdV9pZCA8PSBtYXhf
aWQpIHsKKwkJb3AudS5wY3B1X2luZm8ueGVuX2NwdWlkID0gY3B1X2lkOworCQlpZiAoSFlQRVJW
SVNPUl9kb20wX29wKCZvcCkpIHsKKwkJCWNwdV9pZCsrOworCQkJY29udGludWU7CisJCX0KKwor
CQlpZiAoYWNwaV9pZCA9PSBvcC51LnBjcHVfaW5mby5hY3BpX2lkKQorCQkJcmV0dXJuIGNwdV9p
ZDsKKwkJaWYgKG9wLnUucGNwdV9pbmZvLm1heF9wcmVzZW50ID4gbWF4X2lkKQorCQkJbWF4X2lk
ID0gb3AudS5wY3B1X2luZm8ubWF4X3ByZXNlbnQ7CisJCWNwdV9pZCsrOworCX0KKworCXJldHVy
biAtRU5PREVWOworfQorRVhQT1JUX1NZTUJPTF9HUEwoeGVuX3BjcHVfaWQpOworCiBzdGF0aWMg
aW50IF9faW5pdCB4ZW5fcGNwdV9pbml0KHZvaWQpCiB7CiAJaW50IGlycSwgcmV0OwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy94ZW4veGVuLXByb2Nlc3Nvci5jIGIvZHJpdmVycy94ZW4veGVuLXByb2Nl
c3Nvci5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmM1ZTM5YjYKLS0tIC9k
ZXYvbnVsbAorKysgYi9kcml2ZXJzL3hlbi94ZW4tcHJvY2Vzc29yLmMKQEAgLTAsMCArMSw0NjYg
QEAKKy8qCisgKiBDb3B5cmlnaHQgKEMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqICAgIEF1
dGhvcjogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqICAgIEF1dGhvcjog
SmlhbmcgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+CisgKgorICogVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkKKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRo
ZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQKKyAqIHlvdXIgb3B0aW9uKSBhbnkg
bGF0ZXIgdmVyc2lvbi4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhl
IGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0CisgKiBXSVRIT1VUIEFOWSBXQVJSQU5U
WTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiBNRVJDSEFOVEFCSUxJ
VFkgT1IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UsIEdPT0QgVElUTEUgb3IKKyAq
IE5PTiBJTkZSSU5HRU1FTlQuICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZv
ciBtb3JlCisgKiBkZXRhaWxzLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNp
bmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVk
ZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KKyNpbmNsdWRlIDxsaW51
eC9hY3BpLmg+CisjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGFjcGkvYWNw
aV9idXMuaD4KKyNpbmNsdWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgorI2luY2x1ZGUgPGFjcGkv
cHJvY2Vzc29yLmg+CisKKyNpbmNsdWRlIDx4ZW4vYWNwaS5oPgorI2luY2x1ZGUgPHhlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaD4KKyNpbmNsdWRlIDxhc20veGVuL2h5cGVyY2FsbC5oPgorCisjZGVm
aW5lIFBSRUZJWCAiQUNQSTp4ZW5fY3B1X2hvdHBsdWc6IgorCisjZGVmaW5lIElOU1RBTExfTk9U
SUZZX0hBTkRMRVIJCTAKKyNkZWZpbmUgVU5JTlNUQUxMX05PVElGWV9IQU5ETEVSCTEKKworc3Rh
dGljIGFjcGlfc3RhdHVzIHhlbl9hY3BpX2NwdV9ob3RhZGQoc3RydWN0IGFjcGlfcHJvY2Vzc29y
ICpwcik7CisKKy8qIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCisJCQkJRHJpdmVyIEludGVyZmFjZQorLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0gKi8KKworc3RhdGljIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfZW5hYmxl
KHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQoreworCWFjcGlfc3RhdHVzIHN0YXR1cyA9IDA7
CisJdW5zaWduZWQgbG9uZyBsb25nIHZhbHVlOworCXVuaW9uIGFjcGlfb2JqZWN0IG9iamVjdCA9
IHsgMCB9OworCXN0cnVjdCBhY3BpX2J1ZmZlciBidWZmZXIgPSB7IHNpemVvZih1bmlvbiBhY3Bp
X29iamVjdCksICZvYmplY3QgfTsKKwlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByOworCisJcHIg
PSBhY3BpX2RyaXZlcl9kYXRhKGRldmljZSk7CisJaWYgKCFwcikgeworCQlwcl9lcnIoUFJFRklY
ICJDYW5ub3QgZmluZCBkcml2ZXIgZGF0YVxuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKwor
CWlmICghc3RyY21wKGFjcGlfZGV2aWNlX2hpZChkZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9PQkpF
Q1RfSElEKSkgeworCQkvKiBEZWNsYXJlZCB3aXRoICJQcm9jZXNzb3IiIHN0YXRlbWVudDsgbWF0
Y2ggUHJvY2Vzc29ySUQgKi8KKwkJc3RhdHVzID0gYWNwaV9ldmFsdWF0ZV9vYmplY3QocHItPmhh
bmRsZSwgTlVMTCwgTlVMTCwgJmJ1ZmZlcik7CisJCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkg
eworCQkJcHJfZXJyKFBSRUZJWCAiRXZhbHVhdGluZyBwcm9jZXNzb3Igb2JqZWN0XG4iKTsKKwkJ
CXJldHVybiAtRU5PREVWOworCQl9CisKKwkJcHItPmFjcGlfaWQgPSBvYmplY3QucHJvY2Vzc29y
LnByb2NfaWQ7CisJfSBlbHNlIHsKKwkJLyogRGVjbGFyZWQgd2l0aCAiRGV2aWNlIiBzdGF0ZW1l
bnQ7IG1hdGNoIF9VSUQgKi8KKwkJc3RhdHVzID0gYWNwaV9ldmFsdWF0ZV9pbnRlZ2VyKHByLT5o
YW5kbGUsIE1FVEhPRF9OQU1FX19VSUQsCisJCQkJCQlOVUxMLCAmdmFsdWUpOworCQlpZiAoQUNQ
SV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJCXByX2VycihQUkVGSVggIkV2YWx1YXRpbmcgcHJvY2Vz
c29yIF9VSURcbiIpOworCQkJcmV0dXJuIC1FTk9ERVY7CisJCX0KKworCQlwci0+YWNwaV9pZCA9
IHZhbHVlOworCX0KKworCXByLT5pZCA9IHhlbl9wY3B1X2lkKHByLT5hY3BpX2lkKTsKKworCWlm
ICgoaW50KXByLT5pZCA8IDApCisJCWlmIChBQ1BJX0ZBSUxVUkUoeGVuX2FjcGlfY3B1X2hvdGFk
ZChwcikpKSB7CisJCQlwcl9lcnIoUFJFRklYICJIb3RhZGQgQ1BVIChhY3BpX2lkID0gJWQpIGZh
aWwuXG4iLAorCQkJCQlwci0+YWNwaV9pZCk7CisJCQlyZXR1cm4gLUVOT0RFVjsKKwkJfQorCisJ
cmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgX19jcHVpbml0IHhlbl9hY3BpX3Byb2Nlc3Nvcl9h
ZGQoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCit7CisJaW50IHJldDsKKwlzdHJ1Y3QgYWNw
aV9wcm9jZXNzb3IgKnByOworCisJaWYgKCFkZXZpY2UpCisJCXJldHVybiAtRUlOVkFMOworCisJ
cHIgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IpLCBHRlBfS0VSTkVMKTsK
KwlpZiAoIXByKQorCQlyZXR1cm4gLUVOT01FTTsKKworCXByLT5oYW5kbGUgPSBkZXZpY2UtPmhh
bmRsZTsKKwlzdHJjcHkoYWNwaV9kZXZpY2VfbmFtZShkZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9E
RVZJQ0VfTkFNRSk7CisJc3RyY3B5KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJP
Q0VTU09SX0NMQVNTKTsKKwlkZXZpY2UtPmRyaXZlcl9kYXRhID0gcHI7CisKKwlyZXQgPSB4ZW5f
YWNwaV9wcm9jZXNzb3JfZW5hYmxlKGRldmljZSk7CisJaWYgKHJldCkKKwkJcHJfZXJyKFBSRUZJ
WCAiRXJyb3Igd2hlbiBlbmFibGUgWGVuIHByb2Nlc3NvclxuIik7CisKKwlyZXR1cm4gcmV0Owor
fQorCitzdGF0aWMgaW50IHhlbl9hY3BpX3Byb2Nlc3Nvcl9yZW1vdmUoc3RydWN0IGFjcGlfZGV2
aWNlICpkZXZpY2UsIGludCB0eXBlKQoreworCXN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHI7CisK
KwlpZiAoIWRldmljZSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlwciA9IGFjcGlfZHJpdmVyX2Rh
dGEoZGV2aWNlKTsKKwlpZiAoIXByKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCWtmcmVlKHByKTsK
KwlyZXR1cm4gMDsKK30KKworLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQorCQlBY3BpIHByb2Nlc3NvciBob3RwbHVnIHN1cHBv
cnQKKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKi8KKworc3RhdGljIGludCBpc19wcm9jZXNzb3JfcHJlc2VudChhY3BpX2hhbmRs
ZSBoYW5kbGUpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCXVuc2lnbmVkIGxvbmcgbG9uZyBz
dGEgPSAwOworCisKKwlzdGF0dXMgPSBhY3BpX2V2YWx1YXRlX2ludGVnZXIoaGFuZGxlLCAiX1NU
QSIsIE5VTEwsICZzdGEpOworCisJaWYgKEFDUElfU1VDQ0VTUyhzdGF0dXMpICYmIChzdGEgJiBB
Q1BJX1NUQV9ERVZJQ0VfUFJFU0VOVCkpCisJCXJldHVybiAxOworCisJLyoKKwkgKiBfU1RBIGlz
IG1hbmRhdG9yeSBmb3IgYSBwcm9jZXNzb3IgdGhhdCBzdXBwb3J0cyBob3QgcGx1ZworCSAqLwor
CWlmIChzdGF0dXMgPT0gQUVfTk9UX0ZPVU5EKQorCQlwcl9pbmZvKFBSRUZJWCAiUHJvY2Vzc29y
IGRvZXMgbm90IHN1cHBvcnQgaG90IHBsdWdcbiIpOworCWVsc2UKKwkJcHJfaW5mbyhQUkVGSVgg
IlByb2Nlc3NvciBEZXZpY2UgaXMgbm90IHByZXNlbnQiKTsKKwlyZXR1cm4gMDsKK30KKworc3Rh
dGljIGludCB4ZW5fYXBpY19pZChhY3BpX2hhbmRsZSBoYW5kbGUpCit7CisJc3RydWN0IGFjcGlf
YnVmZmVyIGJ1ZmZlciA9IHsgQUNQSV9BTExPQ0FURV9CVUZGRVIsIE5VTEwgfTsKKwl1bmlvbiBh
Y3BpX29iamVjdCAqb2JqOworCXN0cnVjdCBhY3BpX21hZHRfbG9jYWxfYXBpYyAqbGFwaWM7CisJ
aW50IGFwaWNfaWQ7CisKKwlpZiAoQUNQSV9GQUlMVVJFKGFjcGlfZXZhbHVhdGVfb2JqZWN0KGhh
bmRsZSwgIl9NQVQiLCBOVUxMLCAmYnVmZmVyKSkpCisJCXJldHVybiAtRUlOVkFMOworCisJaWYg
KCFidWZmZXIubGVuZ3RoIHx8ICFidWZmZXIucG9pbnRlcikKKwkJcmV0dXJuIC1FSU5WQUw7CisK
KwlvYmogPSBidWZmZXIucG9pbnRlcjsKKwlpZiAob2JqLT50eXBlICE9IEFDUElfVFlQRV9CVUZG
RVIgfHwKKwkgICAgb2JqLT5idWZmZXIubGVuZ3RoIDwgc2l6ZW9mKCpsYXBpYykpIHsKKwkJa2Zy
ZWUoYnVmZmVyLnBvaW50ZXIpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwlsYXBpYyA9IChz
dHJ1Y3QgYWNwaV9tYWR0X2xvY2FsX2FwaWMgKilvYmotPmJ1ZmZlci5wb2ludGVyOworCisJaWYg
KGxhcGljLT5oZWFkZXIudHlwZSAhPSBBQ1BJX01BRFRfVFlQRV9MT0NBTF9BUElDIHx8CisJICAg
ICEobGFwaWMtPmxhcGljX2ZsYWdzICYgQUNQSV9NQURUX0VOQUJMRUQpKSB7CisJCWtmcmVlKGJ1
ZmZlci5wb2ludGVyKTsKKwkJcmV0dXJuIC1FSU5WQUw7CisJfQorCisJYXBpY19pZCA9ICh1aW50
MzJfdClsYXBpYy0+aWQ7CisJa2ZyZWUoYnVmZmVyLnBvaW50ZXIpOworCWJ1ZmZlci5sZW5ndGgg
PSBBQ1BJX0FMTE9DQVRFX0JVRkZFUjsKKwlidWZmZXIucG9pbnRlciA9IE5VTEw7CisKKwlyZXR1
cm4gYXBpY19pZDsKK30KKworc3RhdGljIGludCB4ZW5faG90YWRkX2NwdShzdHJ1Y3QgYWNwaV9w
cm9jZXNzb3IgKnByKQoreworCWludCBjcHVfaWQsIGFwaWNfaWQsIHB4bTsKKwlzdHJ1Y3QgeGVu
X3BsYXRmb3JtX29wIG9wOworCisJYXBpY19pZCA9IHhlbl9hcGljX2lkKHByLT5oYW5kbGUpOwor
CWlmIChhcGljX2lkIDwgMCkgeworCQlwcl9lcnIoUFJFRklYICJGYWlsIHRvIGdldCBhcGljX2lk
IGZvciBhY3BpX2lkICVkXG4iLAorCQkJCXByLT5hY3BpX2lkKTsKKwkJcmV0dXJuIC1FTk9ERVY7
CisJfQorCisJcHhtID0geGVuX2FjcGlfZ2V0X3B4bShwci0+aGFuZGxlKTsKKwlpZiAocHhtIDwg
MCkgeworCQlwcl9lcnIoUFJFRklYICJGYWlsIHRvIGdldCBfUFhNIGZvciBhY3BpX2lkICVkXG4i
LAorCQkJCXByLT5hY3BpX2lkKTsKKwkJcmV0dXJuIHB4bTsKKwl9CisKKwlvcC5jbWQgPSBYRU5Q
Rl9jcHVfaG90YWRkOworCW9wLnUuY3B1X2FkZC5hcGljX2lkID0gYXBpY19pZDsKKwlvcC51LmNw
dV9hZGQuYWNwaV9pZCA9IHByLT5hY3BpX2lkOworCW9wLnUuY3B1X2FkZC5weG0gPSBweG07CisK
KwljcHVfaWQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAoY3B1X2lkIDwgMCkKKwkJ
cHJfZXJyKFBSRUZJWCAiRmFpbCB0byBob3RhZGQgQ1BVIGZvciBhY3BpX2lkICVkXG4iLAorCQkJ
CXByLT5hY3BpX2lkKTsKKworCXJldHVybiBjcHVfaWQ7Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1
cyB4ZW5fYWNwaV9jcHVfaG90YWRkKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIpCit7CisJaWYg
KCFpc19wcm9jZXNzb3JfcHJlc2VudChwci0+aGFuZGxlKSkKKwkJcmV0dXJuIEFFX0VSUk9SOwor
CisJcHItPmlkID0geGVuX2hvdGFkZF9jcHUocHIpOworCWlmICgoaW50KXByLT5pZCA8IDApCisJ
CXJldHVybiBBRV9FUlJPUjsKKworCXhlbl9wY3B1X2hvdHBsdWdfc3luYygpOworCisJcmV0dXJu
IEFFX09LOworfQorCitzdGF0aWMKK2ludCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfYWRkKGFjcGlf
aGFuZGxlIGhhbmRsZSwgc3RydWN0IGFjcGlfZGV2aWNlICoqZGV2aWNlKQoreworCWFjcGlfaGFu
ZGxlIHBoYW5kbGU7CisJc3RydWN0IGFjcGlfZGV2aWNlICpwZGV2OworCisJaWYgKGFjcGlfZ2V0
X3BhcmVudChoYW5kbGUsICZwaGFuZGxlKSkKKwkJcmV0dXJuIC1FTk9ERVY7CisKKwlpZiAoYWNw
aV9idXNfZ2V0X2RldmljZShwaGFuZGxlLCAmcGRldikpCisJCXJldHVybiAtRU5PREVWOworCisJ
aWYgKGFjcGlfYnVzX2FkZChkZXZpY2UsIHBkZXYsIGhhbmRsZSwgQUNQSV9CVVNfVFlQRV9QUk9D
RVNTT1IpKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50
IGFjcGlfcHJvY2Vzc29yX2RldmljZV9yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2Up
Cit7CisJcHJfZGVidWcoUFJFRklYICJYZW4gZG9lcyBub3Qgc3VwcG9ydCBDUFUgaG90cmVtb3Zl
XG4iKTsKKworCXJldHVybiAtRU5PU1lTOworfQorCitzdGF0aWMgdm9pZCBhY3BpX3Byb2Nlc3Nv
cl9ob3RwbHVnX25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUsCisJCQkJCSAgdTMyIGV2ZW50LCB2
b2lkICpkYXRhKQoreworCXN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHI7CisJc3RydWN0IGFjcGlf
ZGV2aWNlICpkZXZpY2UgPSBOVUxMOworCXUzMiBvc3RfY29kZSA9IEFDUElfT1NUX1NDX05PTl9T
UEVDSUZJQ19GQUlMVVJFOyAvKiBkZWZhdWx0ICovCisJaW50IHJlc3VsdDsKKworCXN3aXRjaCAo
ZXZlbnQpIHsKKwljYXNlIEFDUElfTk9USUZZX0JVU19DSEVDSzoKKwljYXNlIEFDUElfTk9USUZZ
X0RFVklDRV9DSEVDSzoKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLAorCQkJIlBy
b2Nlc3NvciBkcml2ZXIgcmVjZWl2ZWQgJXMgZXZlbnRcbiIsCisJCQkoZXZlbnQgPT0gQUNQSV9O
T1RJRllfQlVTX0NIRUNLKSA/CisJCQkiQUNQSV9OT1RJRllfQlVTX0NIRUNLIiA6ICJBQ1BJX05P
VElGWV9ERVZJQ0VfQ0hFQ0siKSk7CisKKwkJaWYgKCFpc19wcm9jZXNzb3JfcHJlc2VudChoYW5k
bGUpKQorCQkJYnJlYWs7CisKKwkJaWYgKCFhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRl
dmljZSkpCisJCQlicmVhazsKKworCQlyZXN1bHQgPSBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfYWRk
KGhhbmRsZSwgJmRldmljZSk7CisJCWlmIChyZXN1bHQpIHsKKwkJCXByX2VycihQUkVGSVggIlVu
YWJsZSB0byBhZGQgdGhlIGRldmljZVxuIik7CisJCQlicmVhazsKKwkJfQorCisJCW9zdF9jb2Rl
ID0gQUNQSV9PU1RfU0NfU1VDQ0VTUzsKKwkJYnJlYWs7CisKKwljYXNlIEFDUElfTk9USUZZX0VK
RUNUX1JFUVVFU1Q6CisJCUFDUElfREVCVUdfUFJJTlQoKEFDUElfREJfSU5GTywKKwkJCQkgICJy
ZWNlaXZlZCBBQ1BJX05PVElGWV9FSkVDVF9SRVFVRVNUXG4iKSk7CisKKwkJaWYgKGFjcGlfYnVz
X2dldF9kZXZpY2UoaGFuZGxlLCAmZGV2aWNlKSkgeworCQkJcHJfZXJyKFBSRUZJWCAiRGV2aWNl
IGRvbid0IGV4aXN0LCBkcm9wcGluZyBFSkVDVFxuIik7CisJCQlicmVhazsKKwkJfQorCQlwciA9
IGFjcGlfZHJpdmVyX2RhdGEoZGV2aWNlKTsKKwkJaWYgKCFwcikgeworCQkJcHJfZXJyKFBSRUZJ
WCAiRHJpdmVyIGRhdGEgaXMgTlVMTCwgZHJvcHBpbmcgRUpFQ1RcbiIpOworCQkJYnJlYWs7CisJ
CX0KKworCQkvKgorCQkgKiBUQkQ6IGltcGxlbWVudCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfcmVt
b3ZlIGlmIFhlbiBzdXBwb3J0CisJCSAqIENQVSBob3RyZW1vdmUgaW4gdGhlIGZ1dHVyZS4KKwkJ
ICovCisJCWFjcGlfcHJvY2Vzc29yX2RldmljZV9yZW1vdmUoZGV2aWNlKTsKKwkJYnJlYWs7CisK
KwlkZWZhdWx0OgorCQlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQkJICAiVW5z
dXBwb3J0ZWQgZXZlbnQgWzB4JXhdXG4iLCBldmVudCkpOworCisJCS8qIG5vbi1ob3RwbHVnIGV2
ZW50OyBwb3NzaWJseSBoYW5kbGVkIGJ5IG90aGVyIGhhbmRsZXIgKi8KKwkJcmV0dXJuOworCX0K
KworCSh2b2lkKSBhY3BpX2V2YWx1YXRlX2hvdHBsdWdfb3N0KGhhbmRsZSwgZXZlbnQsIG9zdF9j
b2RlLCBOVUxMKTsKKwlyZXR1cm47Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1cyBpc19wcm9jZXNz
b3JfZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlzdHJ1Y3QgYWNwaV9kZXZpY2VfaW5m
byAqaW5mbzsKKwljaGFyICpoaWQ7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RhdHVzID0g
YWNwaV9nZXRfb2JqZWN0X2luZm8oaGFuZGxlLCAmaW5mbyk7CisJaWYgKEFDUElfRkFJTFVSRShz
dGF0dXMpKQorCQlyZXR1cm4gc3RhdHVzOworCisJaWYgKGluZm8tPnR5cGUgPT0gQUNQSV9UWVBF
X1BST0NFU1NPUikgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0dXJuIEFFX09LOwkvKiBmb3VuZCBh
IHByb2Nlc3NvciBvYmplY3QgKi8KKwl9CisKKwlpZiAoIShpbmZvLT52YWxpZCAmIEFDUElfVkFM
SURfSElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0dXJuIEFFX0VSUk9SOworCX0KKworCWhp
ZCA9IGluZm8tPmhhcmR3YXJlX2lkLnN0cmluZzsKKwlpZiAoKGhpZCA9PSBOVUxMKSB8fCBzdHJj
bXAoaGlkLCBBQ1BJX1BST0NFU1NPUl9ERVZJQ0VfSElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJ
cmV0dXJuIEFFX0VSUk9SOworCX0KKworCWtmcmVlKGluZm8pOworCXJldHVybiBBRV9PSzsJLyog
Zm91bmQgYSBwcm9jZXNzb3IgZGV2aWNlIG9iamVjdCAqLworfQorCitzdGF0aWMgYWNwaV9zdGF0
dXMKK3Byb2Nlc3Nvcl93YWxrX25hbWVzcGFjZV9jYihhY3BpX2hhbmRsZSBoYW5kbGUsCisJCQkg
ICAgdTMyIGx2bCwgdm9pZCAqY29udGV4dCwgdm9pZCAqKnJ2KQoreworCWFjcGlfc3RhdHVzIHN0
YXR1czsKKwlpbnQgKmFjdGlvbiA9IGNvbnRleHQ7CisKKwlzdGF0dXMgPSBpc19wcm9jZXNzb3Jf
ZGV2aWNlKGhhbmRsZSk7CisJaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKQorCQlyZXR1cm4gQUVf
T0s7CS8qIG5vdCBhIHByb2Nlc3NvcjsgY29udGludWUgdG8gd2FsayAqLworCisJc3dpdGNoICgq
YWN0aW9uKSB7CisJY2FzZSBJTlNUQUxMX05PVElGWV9IQU5ETEVSOgorCQlhY3BpX2luc3RhbGxf
bm90aWZ5X2hhbmRsZXIoaGFuZGxlLAorCQkJCQkgICAgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJ
CQkgICAgYWNwaV9wcm9jZXNzb3JfaG90cGx1Z19ub3RpZnksCisJCQkJCSAgICBOVUxMKTsKKwkJ
YnJlYWs7CisJY2FzZSBVTklOU1RBTExfTk9USUZZX0hBTkRMRVI6CisJCWFjcGlfcmVtb3ZlX25v
dGlmeV9oYW5kbGVyKGhhbmRsZSwKKwkJCQkJICAgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJCQkg
ICBhY3BpX3Byb2Nlc3Nvcl9ob3RwbHVnX25vdGlmeSk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJ
CWJyZWFrOworCX0KKworCS8qIGZvdW5kIGEgcHJvY2Vzc29yOyBza2lwIHdhbGtpbmcgdW5kZXJu
ZWF0aCAqLworCXJldHVybiBBRV9DVFJMX0RFUFRIOworfQorCitzdGF0aWMKK3ZvaWQgYWNwaV9w
cm9jZXNzb3JfaW5zdGFsbF9ob3RwbHVnX25vdGlmeSh2b2lkKQoreworCWludCBhY3Rpb24gPSBJ
TlNUQUxMX05PVElGWV9IQU5ETEVSOworCWFjcGlfd2Fsa19uYW1lc3BhY2UoQUNQSV9UWVBFX0FO
WSwKKwkJCSAgICBBQ1BJX1JPT1RfT0JKRUNULAorCQkJICAgIEFDUElfVUlOVDMyX01BWCwKKwkJ
CSAgICBwcm9jZXNzb3Jfd2Fsa19uYW1lc3BhY2VfY2IsIE5VTEwsICZhY3Rpb24sIE5VTEwpOwor
fQorCitzdGF0aWMKK3ZvaWQgYWNwaV9wcm9jZXNzb3JfdW5pbnN0YWxsX2hvdHBsdWdfbm90aWZ5
KHZvaWQpCit7CisJaW50IGFjdGlvbiA9IFVOSU5TVEFMTF9OT1RJRllfSEFORExFUjsKKwlhY3Bp
X3dhbGtfbmFtZXNwYWNlKEFDUElfVFlQRV9BTlksCisJCQkgICAgQUNQSV9ST09UX09CSkVDVCwK
KwkJCSAgICBBQ1BJX1VJTlQzMl9NQVgsCisJCQkgICAgcHJvY2Vzc29yX3dhbGtfbmFtZXNwYWNl
X2NiLCBOVUxMLCAmYWN0aW9uLCBOVUxMKTsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBhY3Bp
X2RldmljZV9pZCBwcm9jZXNzb3JfZGV2aWNlX2lkc1tdID0geworCXtBQ1BJX1BST0NFU1NPUl9P
QkpFQ1RfSElELCAwfSwKKwl7QUNQSV9QUk9DRVNTT1JfREVWSUNFX0hJRCwgMH0sCisJeyIiLCAw
fSwKK307CitNT0RVTEVfREVWSUNFX1RBQkxFKGFjcGksIHByb2Nlc3Nvcl9kZXZpY2VfaWRzKTsK
Kworc3RhdGljIHN0cnVjdCBhY3BpX2RyaXZlciB4ZW5fYWNwaV9wcm9jZXNzb3JfZHJpdmVyID0g
eworCS5uYW1lID0gInByb2Nlc3NvciIsCisJLmNsYXNzID0gQUNQSV9QUk9DRVNTT1JfQ0xBU1Ms
CisJLmlkcyA9IHByb2Nlc3Nvcl9kZXZpY2VfaWRzLAorCS5vcHMgPSB7CisJCS5hZGQgPSB4ZW5f
YWNwaV9wcm9jZXNzb3JfYWRkLAorCQkucmVtb3ZlID0geGVuX2FjcGlfcHJvY2Vzc29yX3JlbW92
ZSwKKwkJfSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9hY3BpX3Byb2Nlc3Nvcl9pbml0
KHZvaWQpCit7CisJaW50IHJlc3VsdCA9IDA7CisKKwlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigp
KQorCQlyZXR1cm4gLUVOT0RFVjsKKworCS8qIHVucmVnaXN0ZXIgdGhlIHN0dWIgd2hpY2ggb25s
eSB1c2VkIHRvIHJlc2VydmUgZHJpdmVyIHNwYWNlICovCisJYWNwaV9idXNfdW5yZWdpc3Rlcl9k
cml2ZXIoJnhlbl9zdHViX3Byb2Nlc3Nvcl9kcml2ZXIpOworCisJcmVzdWx0ID0gYWNwaV9idXNf
cmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fYWNwaV9wcm9jZXNzb3JfZHJpdmVyKTsKKwlpZiAocmVzdWx0
IDwgMCkgeworCQlhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9zdHViX3Byb2Nlc3Nvcl9k
cml2ZXIpOworCQlyZXR1cm4gcmVzdWx0OworCX0KKworCWFjcGlfcHJvY2Vzc29yX2luc3RhbGxf
aG90cGx1Z19ub3RpZnkoKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHZvaWQgX19leGl0IHhl
bl9hY3BpX3Byb2Nlc3Nvcl9leGl0KHZvaWQpCit7CisJaWYgKCF4ZW5faW5pdGlhbF9kb21haW4o
KSkKKwkJcmV0dXJuOworCisJYWNwaV9wcm9jZXNzb3JfdW5pbnN0YWxsX2hvdHBsdWdfbm90aWZ5
KCk7CisKKwlhY3BpX2J1c191bnJlZ2lzdGVyX2RyaXZlcigmeGVuX2FjcGlfcHJvY2Vzc29yX2Ry
aXZlcik7CisKKwkvKgorCSAqIHN0dWIgcmVzZXJ2ZSBzcGFjZSBhZ2FpbiB0byBwcmV2ZW50IGFu
eSBjaGFuY2Ugb2YgbmF0aXZlCisJICogZHJpdmVyIGxvYWRpbmcuCisJICovCisJYWNwaV9idXNf
cmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fc3R1Yl9wcm9jZXNzb3JfZHJpdmVyKTsKKwlyZXR1cm47Cit9
CisKK21vZHVsZV9pbml0KHhlbl9hY3BpX3Byb2Nlc3Nvcl9pbml0KTsKK21vZHVsZV9leGl0KHhl
bl9hY3BpX3Byb2Nlc3Nvcl9leGl0KTsKK0FDUElfTU9EVUxFX05BTUUoInhlbi1wcm9jZXNzb3Ii
KTsKK01PRFVMRV9BVVRIT1IoIkxpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Iik7
CitNT0RVTEVfREVTQ1JJUFRJT04oIlhlbiBQcm9jZXNzb3IgRHJpdmVyIik7CitNT0RVTEVfTElD
RU5TRSgiR1BMIik7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9hY3BpLmggYi9pbmNsdWRlL3hl
bi9hY3BpLmgKaW5kZXggNWFjNDZkMy4uM2RlMjE3ZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4v
YWNwaS5oCisrKyBiL2luY2x1ZGUveGVuL2FjcGkuaApAQCAtNDUsNiArNDUsOCBAQAogI2RlZmlu
ZSBBQ1BJX01FTU9SWV9ERVZJQ0VfTkFNRSAgICAgICAgICJIb3RwbHVnIE1lbSBEZXZpY2UiCiAK
IGV4dGVybiBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXI7
CitleHRlcm4gdm9pZCB4ZW5fcGNwdV9ob3RwbHVnX3N5bmModm9pZCk7CitleHRlcm4gaW50IHhl
bl9wY3B1X2lkKHVpbnQzMl90IGFjcGlfaWQpOwogCiBzdGF0aWMgaW5saW5lIGludCB4ZW5fYWNw
aV9nZXRfcHhtKGFjcGlfaGFuZGxlIGgpCiB7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCmluZGV4
IDJjNGZiNGIuLmM1N2Q1ZjYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0
Zm9ybS5oCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCkBAIC0zMjQsNiAr
MzI0LDEzIEBAIHN0cnVjdCB4ZW5wZl9jcHVfb2wgewogfTsKIERFRklORV9HVUVTVF9IQU5ETEVf
U1RSVUNUKHhlbnBmX2NwdV9vbCk7CiAKKyNkZWZpbmUgWEVOUEZfY3B1X2hvdGFkZAk1OAorc3Ry
dWN0IHhlbnBmX2NwdV9ob3RhZGQgeworCXVpbnQzMl90IGFwaWNfaWQ7CisJdWludDMyX3QgYWNw
aV9pZDsKKwl1aW50MzJfdCBweG07Cit9OworCiAjZGVmaW5lIFhFTlBGX21lbV9ob3RhZGQJNTkK
IHN0cnVjdCB4ZW5wZl9tZW1faG90YWRkIHsKIAl1aW50NjRfdCBzcGZuOwpAQCAtMzYxLDYgKzM2
OCw3IEBAIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfc2V0X3Byb2Nl
c3Nvcl9wbWluZm8gc2V0X3BtaW5mbzsKIAkJc3RydWN0IHhlbnBmX3BjcHVpbmZvICAgICAgICAg
IHBjcHVfaW5mbzsKIAkJc3RydWN0IHhlbnBmX2NwdV9vbCAgICAgICAgICAgIGNwdV9vbDsKKwkJ
c3RydWN0IHhlbnBmX2NwdV9ob3RhZGQgICAgICAgIGNwdV9hZGQ7CiAJCXN0cnVjdCB4ZW5wZl9t
ZW1faG90YWRkICAgICAgICBtZW1fYWRkOwogCQlzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nICAg
ICAgY29yZV9wYXJraW5nOwogCQl1aW50OF90ICAgICAgICAgICAgICAgICAgICAgICAgcGFkWzEy
OF07Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DE6SHSMSX101ccrcorpi_--
