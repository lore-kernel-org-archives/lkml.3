Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3AYI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:59:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:15818 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3AYI7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208,223";a="248278876"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V2 3/3] Xen ACPI cpu hotplug
Thread-Topic: [PATCH V2 3/3] Xen ACPI cpu hotplug
Thread-Index: Ac362kllpIQXQU79R1KG/jdZ/OnBJg==
Date: Fri, 25 Jan 2013 08:59:30 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD727@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353DD727SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353DD727SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 82f36ae635f404ae8518c4813bafeb2dbbefdfa8 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Fri, 25 Jan 2013 15:43:34 +0800
Subject: [PATCH 3/3] Xen ACPI cpu hotplug

This patch implement real Xen ACPI cpu hotplug driver as module.
When loaded, it replaces Xen stub driver.

For booting existed cpus, the driver enumerates them.
For hotadded cpus, which added at runtime and notify OS via
device or container event, the driver is invoked to add them,
parsing cpu information, hypercalling to Xen hypervisor to add
them, and finally setting up new /sys interface for them.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig               |   12 +
 drivers/xen/Makefile              |    1 +
 drivers/xen/pcpu.c                |   35 +++
 drivers/xen/xen-acpi-cpuhotplug.c |  471 +++++++++++++++++++++++++++++++++=
++++
 include/xen/acpi.h                |    3 +
 include/xen/interface/platform.h  |    8 +
 6 files changed, 530 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-acpi-cpuhotplug.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index dcffad1..5a32232 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -202,6 +202,18 @@ config XEN_ACPI_HOTPLUG_MEMORY
 	  to hot-add memory at runtime (the hot-added memory cannot be
 	  removed until machine stop), select Y/M here, otherwise select N.
=20
+config XEN_ACPI_HOTPLUG_CPU
+	tristate "Xen ACPI cpu hotplug"
+	depends on XEN_DOM0 && XEN_STUB && ACPI
+	select ACPI_CONTAINER
+	default n
+	help
+	  Xen ACPI cpu enumerating and hotplugging
+
+	  For hotplugging, currently Xen only support ACPI cpu hotadd.
+	  If you want to hotadd cpu at runtime (the hotadded cpu cannot
+	  be removed until machine stop), select Y/M here.
+
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 1605f59..eabd0ee 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_STUB)			+=3D xen-stub.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+=3D xen-acpi-memhotplug.o
+obj-$(CONFIG_XEN_ACPI_HOTPLUG_CPU)	+=3D xen-acpi-cpuhotplug.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 067fcfa..0836a18 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -333,6 +333,41 @@ static irqreturn_t xen_pcpu_interrupt(int irq, void *d=
ev_id)
 	return IRQ_HANDLED;
 }
=20
+/* Sync with Xen hypervisor after cpu hotadded */
+void xen_pcpu_hotplug_sync(void)
+{
+	schedule_work(&xen_pcpu_work);
+}
+EXPORT_SYMBOL_GPL(xen_pcpu_hotplug_sync);
+
+/*
+ * For hypervisor presented cpu, return logic cpu id;
+ * For hypervisor non-presented cpu, return -ENODEV.
+ */
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
diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuho=
tplug.c
new file mode 100644
index 0000000..9eefbb0
--- /dev/null
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -0,0 +1,471 @@
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
+		/* This cpu is not presented at hypervisor, try to hotadd it */
+		if (ACPI_FAILURE(xen_acpi_cpu_hotadd(pr))) {
+			pr_err(PREFIX "Hotadd CPU (acpi_id =3D %d) failed.\n",
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
+		pr_err(PREFIX "Error when enabling Xen processor\n");
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
+		pr_err(PREFIX "Failed to get apic_id for acpi_id %d\n",
+				pr->acpi_id);
+		return -ENODEV;
+	}
+
+	pxm =3D xen_acpi_get_pxm(pr->handle);
+	if (pxm < 0) {
+		pr_err(PREFIX "Failed to get _PXM for acpi_id %d\n",
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
+		pr_err(PREFIX "Failed to hotadd CPU for acpi_id %d\n",
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
+	/*
+	 * Sync with Xen hypervisor, providing new /sys/.../xen_cpuX
+	 * interface after cpu hotadded.
+	 */
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
+	xen_stub_processor_exit();
+
+	result =3D acpi_bus_register_driver(&xen_acpi_processor_driver);
+	if (result < 0) {
+		xen_stub_processor_init();
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
+	xen_stub_processor_init();
+	return;
+}
+
+module_init(xen_acpi_processor_init);
+module_exit(xen_acpi_processor_exit);
+ACPI_MODULE_NAME("xen-acpi-cpuhotplug");
+MODULE_AUTHOR("Liu Jinsong <jinsong.liu@intel.com>");
+MODULE_DESCRIPTION("Xen Hotplug CPU Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index dc69c91..c962d5f 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -54,6 +54,9 @@ void xen_stub_memory_device_exit(void);
 int xen_stub_processor_init(void);
 void xen_stub_processor_exit(void);
=20
+void xen_pcpu_hotplug_sync(void);
+int xen_pcpu_id(uint32_t acpi_id);
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
=20
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

--_002_DE8DF0795D48FD4CA783C40EC82923353DD727SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-ACPI-cpu-hotplug.patch"
Content-Description: 0003-Xen-ACPI-cpu-hotplug.patch
Content-Disposition: attachment; filename="0003-Xen-ACPI-cpu-hotplug.patch";
	size=16601; creation-date="Fri, 25 Jan 2013 08:52:32 GMT";
	modification-date="Fri, 25 Jan 2013 16:45:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4MmYzNmFlNjM1ZjQwNGFlODUxOGM0ODEzYmFmZWIyZGJiZWZkZmE4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBGcmksIDI1IEphbiAyMDEzIDE1OjQzOjM0ICswODAwClN1YmplY3Q6IFtQQVRDSCAzLzNd
IFhlbiBBQ1BJIGNwdSBob3RwbHVnCgpUaGlzIHBhdGNoIGltcGxlbWVudCByZWFsIFhlbiBBQ1BJ
IGNwdSBob3RwbHVnIGRyaXZlciBhcyBtb2R1bGUuCldoZW4gbG9hZGVkLCBpdCByZXBsYWNlcyBY
ZW4gc3R1YiBkcml2ZXIuCgpGb3IgYm9vdGluZyBleGlzdGVkIGNwdXMsIHRoZSBkcml2ZXIgZW51
bWVyYXRlcyB0aGVtLgpGb3IgaG90YWRkZWQgY3B1cywgd2hpY2ggYWRkZWQgYXQgcnVudGltZSBh
bmQgbm90aWZ5IE9TIHZpYQpkZXZpY2Ugb3IgY29udGFpbmVyIGV2ZW50LCB0aGUgZHJpdmVyIGlz
IGludm9rZWQgdG8gYWRkIHRoZW0sCnBhcnNpbmcgY3B1IGluZm9ybWF0aW9uLCBoeXBlcmNhbGxp
bmcgdG8gWGVuIGh5cGVydmlzb3IgdG8gYWRkCnRoZW0sIGFuZCBmaW5hbGx5IHNldHRpbmcgdXAg
bmV3IC9zeXMgaW50ZXJmYWNlIGZvciB0aGVtLgoKU2lnbmVkLW9mZi1ieTogTGl1IEppbnNvbmcg
PGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi9LY29uZmlnICAgICAgICAg
ICAgICAgfCAgIDEyICsKIGRyaXZlcnMveGVuL01ha2VmaWxlICAgICAgICAgICAgICB8ICAgIDEg
KwogZHJpdmVycy94ZW4vcGNwdS5jICAgICAgICAgICAgICAgIHwgICAzNSArKysKIGRyaXZlcnMv
eGVuL3hlbi1hY3BpLWNwdWhvdHBsdWcuYyB8ICA0NzEgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwogaW5jbHVkZS94ZW4vYWNwaS5oICAgICAgICAgICAgICAgIHwgICAgMyAr
CiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaCAgfCAgICA4ICsKIDYgZmlsZXMgY2hh
bmdlZCwgNTMwIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2
NDQgZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1Zy5jCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy94ZW4vS2NvbmZpZyBiL2RyaXZlcnMveGVuL0tjb25maWcKaW5kZXggZGNmZmFkMS4uNWEzMjIz
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vS2NvbmZpZworKysgYi9kcml2ZXJzL3hlbi9LY29u
ZmlnCkBAIC0yMDIsNiArMjAyLDE4IEBAIGNvbmZpZyBYRU5fQUNQSV9IT1RQTFVHX01FTU9SWQog
CSAgdG8gaG90LWFkZCBtZW1vcnkgYXQgcnVudGltZSAodGhlIGhvdC1hZGRlZCBtZW1vcnkgY2Fu
bm90IGJlCiAJICByZW1vdmVkIHVudGlsIG1hY2hpbmUgc3RvcCksIHNlbGVjdCBZL00gaGVyZSwg
b3RoZXJ3aXNlIHNlbGVjdCBOLgogCitjb25maWcgWEVOX0FDUElfSE9UUExVR19DUFUKKwl0cmlz
dGF0ZSAiWGVuIEFDUEkgY3B1IGhvdHBsdWciCisJZGVwZW5kcyBvbiBYRU5fRE9NMCAmJiBYRU5f
U1RVQiAmJiBBQ1BJCisJc2VsZWN0IEFDUElfQ09OVEFJTkVSCisJZGVmYXVsdCBuCisJaGVscAor
CSAgWGVuIEFDUEkgY3B1IGVudW1lcmF0aW5nIGFuZCBob3RwbHVnZ2luZworCisJICBGb3IgaG90
cGx1Z2dpbmcsIGN1cnJlbnRseSBYZW4gb25seSBzdXBwb3J0IEFDUEkgY3B1IGhvdGFkZC4KKwkg
IElmIHlvdSB3YW50IHRvIGhvdGFkZCBjcHUgYXQgcnVudGltZSAodGhlIGhvdGFkZGVkIGNwdSBj
YW5ub3QKKwkgIGJlIHJlbW92ZWQgdW50aWwgbWFjaGluZSBzdG9wKSwgc2VsZWN0IFkvTSBoZXJl
LgorCiBjb25maWcgWEVOX0FDUElfUFJPQ0VTU09SCiAJdHJpc3RhdGUgIlhlbiBBQ1BJIHByb2Nl
c3NvciIKIAlkZXBlbmRzIG9uIFhFTiAmJiBYODYgJiYgQUNQSV9QUk9DRVNTT1IgJiYgQ1BVX0ZS
RVEKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZp
bGUKaW5kZXggMTYwNWY1OS4uZWFiZDBlZSAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZp
bGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTMyLDYgKzMyLDcgQEAgb2JqLSQoQ09O
RklHX1hFTl9QQ0lERVZfQkFDS0VORCkJKz0geGVuLXBjaWJhY2svCiBvYmotJChDT05GSUdfWEVO
X1BSSVZDTUQpCQkrPSB4ZW4tcHJpdmNtZC5vCiBvYmotJChDT05GSUdfWEVOX1NUVUIpCQkJKz0g
eGVuLXN0dWIubwogb2JqLSQoQ09ORklHX1hFTl9BQ1BJX0hPVFBMVUdfTUVNT1JZKQkrPSB4ZW4t
YWNwaS1tZW1ob3RwbHVnLm8KK29iai0kKENPTkZJR19YRU5fQUNQSV9IT1RQTFVHX0NQVSkJKz0g
eGVuLWFjcGktY3B1aG90cGx1Zy5vCiBvYmotJChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkr
PSB4ZW4tYWNwaS1wcm9jZXNzb3IubwogeGVuLWV2dGNobi15CQkJCTo9IGV2dGNobi5vCiB4ZW4t
Z250ZGV2LXkJCQkJOj0gZ250ZGV2Lm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL3BjcHUuYyBi
L2RyaXZlcnMveGVuL3BjcHUuYwppbmRleCAwNjdmY2ZhLi4wODM2YTE4IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3hlbi9wY3B1LmMKKysrIGIvZHJpdmVycy94ZW4vcGNwdS5jCkBAIC0zMzMsNiArMzMz
LDQxIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB4ZW5fcGNwdV9pbnRlcnJ1cHQoaW50IGlycSwgdm9p
ZCAqZGV2X2lkKQogCXJldHVybiBJUlFfSEFORExFRDsKIH0KIAorLyogU3luYyB3aXRoIFhlbiBo
eXBlcnZpc29yIGFmdGVyIGNwdSBob3RhZGRlZCAqLwordm9pZCB4ZW5fcGNwdV9ob3RwbHVnX3N5
bmModm9pZCkKK3sKKwlzY2hlZHVsZV93b3JrKCZ4ZW5fcGNwdV93b3JrKTsKK30KK0VYUE9SVF9T
WU1CT0xfR1BMKHhlbl9wY3B1X2hvdHBsdWdfc3luYyk7CisKKy8qCisgKiBGb3IgaHlwZXJ2aXNv
ciBwcmVzZW50ZWQgY3B1LCByZXR1cm4gbG9naWMgY3B1IGlkOworICogRm9yIGh5cGVydmlzb3Ig
bm9uLXByZXNlbnRlZCBjcHUsIHJldHVybiAtRU5PREVWLgorICovCitpbnQgeGVuX3BjcHVfaWQo
dWludDMyX3QgYWNwaV9pZCkKK3sKKwlpbnQgY3B1X2lkID0gMCwgbWF4X2lkID0gMDsKKwlzdHJ1
Y3QgeGVuX3BsYXRmb3JtX29wIG9wOworCisJb3AuY21kID0gWEVOUEZfZ2V0X2NwdWluZm87CisJ
d2hpbGUgKGNwdV9pZCA8PSBtYXhfaWQpIHsKKwkJb3AudS5wY3B1X2luZm8ueGVuX2NwdWlkID0g
Y3B1X2lkOworCQlpZiAoSFlQRVJWSVNPUl9kb20wX29wKCZvcCkpIHsKKwkJCWNwdV9pZCsrOwor
CQkJY29udGludWU7CisJCX0KKworCQlpZiAoYWNwaV9pZCA9PSBvcC51LnBjcHVfaW5mby5hY3Bp
X2lkKQorCQkJcmV0dXJuIGNwdV9pZDsKKwkJaWYgKG9wLnUucGNwdV9pbmZvLm1heF9wcmVzZW50
ID4gbWF4X2lkKQorCQkJbWF4X2lkID0gb3AudS5wY3B1X2luZm8ubWF4X3ByZXNlbnQ7CisJCWNw
dV9pZCsrOworCX0KKworCXJldHVybiAtRU5PREVWOworfQorRVhQT1JUX1NZTUJPTF9HUEwoeGVu
X3BjcHVfaWQpOworCiBzdGF0aWMgaW50IF9faW5pdCB4ZW5fcGNwdV9pbml0KHZvaWQpCiB7CiAJ
aW50IGlycSwgcmV0OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1
Zy5jIGIvZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1Zy5jCm5ldyBmaWxlIG1vZGUgMTAw
NjQ0CmluZGV4IDAwMDAwMDAuLjllZWZiYjAKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3hl
bi94ZW4tYWNwaS1jcHVob3RwbHVnLmMKQEAgLTAsMCArMSw0NzEgQEAKKy8qCisgKiBDb3B5cmln
aHQgKEMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqICAgIEF1dGhvcjogTGl1IEppbnNvbmcg
PGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqICAgIEF1dGhvcjogSmlhbmcgWXVuaG9uZyA8eXVu
aG9uZy5qaWFuZ0BpbnRlbC5jb20+CisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdh
cmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqIGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5
CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRo
ZSBMaWNlbnNlLCBvciAoYXQKKyAqIHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKyAq
CisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxs
IGJlIHVzZWZ1bCwgYnV0CisgKiBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRo
ZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiBNRVJDSEFOVEFCSUxJVFkgT1IgRklUTkVTUyBGT1Ig
QSBQQVJUSUNVTEFSIFBVUlBPU0UsIEdPT0QgVElUTEUgb3IKKyAqIE5PTiBJTkZSSU5HRU1FTlQu
ICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlCisgKiBkZXRhaWxz
LgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4K
KyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KKyNpbmNsdWRlIDxsaW51eC9hY3BpLmg+CisjaW5jbHVk
ZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGFjcGkvYWNwaV9idXMuaD4KKyNpbmNsdWRl
IDxhY3BpL2FjcGlfZHJpdmVycy5oPgorI2luY2x1ZGUgPGFjcGkvcHJvY2Vzc29yLmg+CisKKyNp
bmNsdWRlIDx4ZW4vYWNwaS5oPgorI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaD4K
KyNpbmNsdWRlIDxhc20veGVuL2h5cGVyY2FsbC5oPgorCisjZGVmaW5lIFBSRUZJWCAiQUNQSTp4
ZW5fY3B1X2hvdHBsdWc6IgorCisjZGVmaW5lIElOU1RBTExfTk9USUZZX0hBTkRMRVIJCTAKKyNk
ZWZpbmUgVU5JTlNUQUxMX05PVElGWV9IQU5ETEVSCTEKKworc3RhdGljIGFjcGlfc3RhdHVzIHhl
bl9hY3BpX2NwdV9ob3RhZGQoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwcik7CisKKy8qIC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCisJCQkJRHJpdmVyIEludGVyZmFjZQorLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8K
Kworc3RhdGljIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfZW5hYmxlKHN0cnVjdCBhY3BpX2Rldmlj
ZSAqZGV2aWNlKQoreworCWFjcGlfc3RhdHVzIHN0YXR1cyA9IDA7CisJdW5zaWduZWQgbG9uZyBs
b25nIHZhbHVlOworCXVuaW9uIGFjcGlfb2JqZWN0IG9iamVjdCA9IHsgMCB9OworCXN0cnVjdCBh
Y3BpX2J1ZmZlciBidWZmZXIgPSB7IHNpemVvZih1bmlvbiBhY3BpX29iamVjdCksICZvYmplY3Qg
fTsKKwlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByOworCisJcHIgPSBhY3BpX2RyaXZlcl9kYXRh
KGRldmljZSk7CisJaWYgKCFwcikgeworCQlwcl9lcnIoUFJFRklYICJDYW5ub3QgZmluZCBkcml2
ZXIgZGF0YVxuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKworCWlmICghc3RyY21wKGFjcGlf
ZGV2aWNlX2hpZChkZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9PQkpFQ1RfSElEKSkgeworCQkvKiBE
ZWNsYXJlZCB3aXRoICJQcm9jZXNzb3IiIHN0YXRlbWVudDsgbWF0Y2ggUHJvY2Vzc29ySUQgKi8K
KwkJc3RhdHVzID0gYWNwaV9ldmFsdWF0ZV9vYmplY3QocHItPmhhbmRsZSwgTlVMTCwgTlVMTCwg
JmJ1ZmZlcik7CisJCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkgeworCQkJcHJfZXJyKFBSRUZJ
WCAiRXZhbHVhdGluZyBwcm9jZXNzb3Igb2JqZWN0XG4iKTsKKwkJCXJldHVybiAtRU5PREVWOwor
CQl9CisKKwkJcHItPmFjcGlfaWQgPSBvYmplY3QucHJvY2Vzc29yLnByb2NfaWQ7CisJfSBlbHNl
IHsKKwkJLyogRGVjbGFyZWQgd2l0aCAiRGV2aWNlIiBzdGF0ZW1lbnQ7IG1hdGNoIF9VSUQgKi8K
KwkJc3RhdHVzID0gYWNwaV9ldmFsdWF0ZV9pbnRlZ2VyKHByLT5oYW5kbGUsIE1FVEhPRF9OQU1F
X19VSUQsCisJCQkJCQlOVUxMLCAmdmFsdWUpOworCQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykp
IHsKKwkJCXByX2VycihQUkVGSVggIkV2YWx1YXRpbmcgcHJvY2Vzc29yIF9VSURcbiIpOworCQkJ
cmV0dXJuIC1FTk9ERVY7CisJCX0KKworCQlwci0+YWNwaV9pZCA9IHZhbHVlOworCX0KKworCXBy
LT5pZCA9IHhlbl9wY3B1X2lkKHByLT5hY3BpX2lkKTsKKworCWlmICgoaW50KXByLT5pZCA8IDAp
CisJCS8qIFRoaXMgY3B1IGlzIG5vdCBwcmVzZW50ZWQgYXQgaHlwZXJ2aXNvciwgdHJ5IHRvIGhv
dGFkZCBpdCAqLworCQlpZiAoQUNQSV9GQUlMVVJFKHhlbl9hY3BpX2NwdV9ob3RhZGQocHIpKSkg
eworCQkJcHJfZXJyKFBSRUZJWCAiSG90YWRkIENQVSAoYWNwaV9pZCA9ICVkKSBmYWlsZWQuXG4i
LAorCQkJCQlwci0+YWNwaV9pZCk7CisJCQlyZXR1cm4gLUVOT0RFVjsKKwkJfQorCisJcmV0dXJu
IDA7Cit9CisKK3N0YXRpYyBpbnQgX19jcHVpbml0IHhlbl9hY3BpX3Byb2Nlc3Nvcl9hZGQoc3Ry
dWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCit7CisJaW50IHJldDsKKwlzdHJ1Y3QgYWNwaV9wcm9j
ZXNzb3IgKnByOworCisJaWYgKCFkZXZpY2UpCisJCXJldHVybiAtRUlOVkFMOworCisJcHIgPSBr
emFsbG9jKHNpemVvZihzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IpLCBHRlBfS0VSTkVMKTsKKwlpZiAo
IXByKQorCQlyZXR1cm4gLUVOT01FTTsKKworCXByLT5oYW5kbGUgPSBkZXZpY2UtPmhhbmRsZTsK
KwlzdHJjcHkoYWNwaV9kZXZpY2VfbmFtZShkZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9ERVZJQ0Vf
TkFNRSk7CisJc3RyY3B5KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJPQ0VTU09S
X0NMQVNTKTsKKwlkZXZpY2UtPmRyaXZlcl9kYXRhID0gcHI7CisKKwlyZXQgPSB4ZW5fYWNwaV9w
cm9jZXNzb3JfZW5hYmxlKGRldmljZSk7CisJaWYgKHJldCkKKwkJcHJfZXJyKFBSRUZJWCAiRXJy
b3Igd2hlbiBlbmFibGluZyBYZW4gcHJvY2Vzc29yXG4iKTsKKworCXJldHVybiByZXQ7Cit9CisK
K3N0YXRpYyBpbnQgeGVuX2FjcGlfcHJvY2Vzc29yX3JlbW92ZShzdHJ1Y3QgYWNwaV9kZXZpY2Ug
KmRldmljZSwgaW50IHR5cGUpCit7CisJc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwcjsKKworCWlm
ICghZGV2aWNlKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXByID0gYWNwaV9kcml2ZXJfZGF0YShk
ZXZpY2UpOworCWlmICghcHIpCisJCXJldHVybiAtRUlOVkFMOworCisJa2ZyZWUocHIpOworCXJl
dHVybiAwOworfQorCisvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCisJCUFjcGkgcHJvY2Vzc29yIGhvdHBsdWcgc3VwcG9ydAor
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0qLworCitzdGF0aWMgaW50IGlzX3Byb2Nlc3Nvcl9wcmVzZW50KGFjcGlfaGFuZGxlIGhh
bmRsZSkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJdW5zaWduZWQgbG9uZyBsb25nIHN0YSA9
IDA7CisKKworCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdlcihoYW5kbGUsICJfU1RBIiwg
TlVMTCwgJnN0YSk7CisKKwlpZiAoQUNQSV9TVUNDRVNTKHN0YXR1cykgJiYgKHN0YSAmIEFDUElf
U1RBX0RFVklDRV9QUkVTRU5UKSkKKwkJcmV0dXJuIDE7CisKKwkvKgorCSAqIF9TVEEgaXMgbWFu
ZGF0b3J5IGZvciBhIHByb2Nlc3NvciB0aGF0IHN1cHBvcnRzIGhvdCBwbHVnCisJICovCisJaWYg
KHN0YXR1cyA9PSBBRV9OT1RfRk9VTkQpCisJCXByX2luZm8oUFJFRklYICJQcm9jZXNzb3IgZG9l
cyBub3Qgc3VwcG9ydCBob3QgcGx1Z1xuIik7CisJZWxzZQorCQlwcl9pbmZvKFBSRUZJWCAiUHJv
Y2Vzc29yIERldmljZSBpcyBub3QgcHJlc2VudCIpOworCXJldHVybiAwOworfQorCitzdGF0aWMg
aW50IHhlbl9hcGljX2lkKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlzdHJ1Y3QgYWNwaV9idWZm
ZXIgYnVmZmVyID0geyBBQ1BJX0FMTE9DQVRFX0JVRkZFUiwgTlVMTCB9OworCXVuaW9uIGFjcGlf
b2JqZWN0ICpvYmo7CisJc3RydWN0IGFjcGlfbWFkdF9sb2NhbF9hcGljICpsYXBpYzsKKwlpbnQg
YXBpY19pZDsKKworCWlmIChBQ1BJX0ZBSUxVUkUoYWNwaV9ldmFsdWF0ZV9vYmplY3QoaGFuZGxl
LCAiX01BVCIsIE5VTEwsICZidWZmZXIpKSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlpZiAoIWJ1
ZmZlci5sZW5ndGggfHwgIWJ1ZmZlci5wb2ludGVyKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCW9i
aiA9IGJ1ZmZlci5wb2ludGVyOworCWlmIChvYmotPnR5cGUgIT0gQUNQSV9UWVBFX0JVRkZFUiB8
fAorCSAgICBvYmotPmJ1ZmZlci5sZW5ndGggPCBzaXplb2YoKmxhcGljKSkgeworCQlrZnJlZShi
dWZmZXIucG9pbnRlcik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKworCWxhcGljID0gKHN0cnVj
dCBhY3BpX21hZHRfbG9jYWxfYXBpYyAqKW9iai0+YnVmZmVyLnBvaW50ZXI7CisKKwlpZiAobGFw
aWMtPmhlYWRlci50eXBlICE9IEFDUElfTUFEVF9UWVBFX0xPQ0FMX0FQSUMgfHwKKwkgICAgIShs
YXBpYy0+bGFwaWNfZmxhZ3MgJiBBQ1BJX01BRFRfRU5BQkxFRCkpIHsKKwkJa2ZyZWUoYnVmZmVy
LnBvaW50ZXIpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwlhcGljX2lkID0gKHVpbnQzMl90
KWxhcGljLT5pZDsKKwlrZnJlZShidWZmZXIucG9pbnRlcik7CisJYnVmZmVyLmxlbmd0aCA9IEFD
UElfQUxMT0NBVEVfQlVGRkVSOworCWJ1ZmZlci5wb2ludGVyID0gTlVMTDsKKworCXJldHVybiBh
cGljX2lkOworfQorCitzdGF0aWMgaW50IHhlbl9ob3RhZGRfY3B1KHN0cnVjdCBhY3BpX3Byb2Nl
c3NvciAqcHIpCit7CisJaW50IGNwdV9pZCwgYXBpY19pZCwgcHhtOworCXN0cnVjdCB4ZW5fcGxh
dGZvcm1fb3Agb3A7CisKKwlhcGljX2lkID0geGVuX2FwaWNfaWQocHItPmhhbmRsZSk7CisJaWYg
KGFwaWNfaWQgPCAwKSB7CisJCXByX2VycihQUkVGSVggIkZhaWxlZCB0byBnZXQgYXBpY19pZCBm
b3IgYWNwaV9pZCAlZFxuIiwKKwkJCQlwci0+YWNwaV9pZCk7CisJCXJldHVybiAtRU5PREVWOwor
CX0KKworCXB4bSA9IHhlbl9hY3BpX2dldF9weG0ocHItPmhhbmRsZSk7CisJaWYgKHB4bSA8IDAp
IHsKKwkJcHJfZXJyKFBSRUZJWCAiRmFpbGVkIHRvIGdldCBfUFhNIGZvciBhY3BpX2lkICVkXG4i
LAorCQkJCXByLT5hY3BpX2lkKTsKKwkJcmV0dXJuIHB4bTsKKwl9CisKKwlvcC5jbWQgPSBYRU5Q
Rl9jcHVfaG90YWRkOworCW9wLnUuY3B1X2FkZC5hcGljX2lkID0gYXBpY19pZDsKKwlvcC51LmNw
dV9hZGQuYWNwaV9pZCA9IHByLT5hY3BpX2lkOworCW9wLnUuY3B1X2FkZC5weG0gPSBweG07CisK
KwljcHVfaWQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAoY3B1X2lkIDwgMCkKKwkJ
cHJfZXJyKFBSRUZJWCAiRmFpbGVkIHRvIGhvdGFkZCBDUFUgZm9yIGFjcGlfaWQgJWRcbiIsCisJ
CQkJcHItPmFjcGlfaWQpOworCisJcmV0dXJuIGNwdV9pZDsKK30KKworc3RhdGljIGFjcGlfc3Rh
dHVzIHhlbl9hY3BpX2NwdV9ob3RhZGQoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwcikKK3sKKwlp
ZiAoIWlzX3Byb2Nlc3Nvcl9wcmVzZW50KHByLT5oYW5kbGUpKQorCQlyZXR1cm4gQUVfRVJST1I7
CisKKwlwci0+aWQgPSB4ZW5faG90YWRkX2NwdShwcik7CisJaWYgKChpbnQpcHItPmlkIDwgMCkK
KwkJcmV0dXJuIEFFX0VSUk9SOworCisJLyoKKwkgKiBTeW5jIHdpdGggWGVuIGh5cGVydmlzb3Is
IHByb3ZpZGluZyBuZXcgL3N5cy8uLi4veGVuX2NwdVgKKwkgKiBpbnRlcmZhY2UgYWZ0ZXIgY3B1
IGhvdGFkZGVkLgorCSAqLworCXhlbl9wY3B1X2hvdHBsdWdfc3luYygpOworCisJcmV0dXJuIEFF
X09LOworfQorCitzdGF0aWMKK2ludCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfYWRkKGFjcGlfaGFu
ZGxlIGhhbmRsZSwgc3RydWN0IGFjcGlfZGV2aWNlICoqZGV2aWNlKQoreworCWFjcGlfaGFuZGxl
IHBoYW5kbGU7CisJc3RydWN0IGFjcGlfZGV2aWNlICpwZGV2OworCisJaWYgKGFjcGlfZ2V0X3Bh
cmVudChoYW5kbGUsICZwaGFuZGxlKSkKKwkJcmV0dXJuIC1FTk9ERVY7CisKKwlpZiAoYWNwaV9i
dXNfZ2V0X2RldmljZShwaGFuZGxlLCAmcGRldikpCisJCXJldHVybiAtRU5PREVWOworCisJaWYg
KGFjcGlfYnVzX2FkZChkZXZpY2UsIHBkZXYsIGhhbmRsZSwgQUNQSV9CVVNfVFlQRV9QUk9DRVNT
T1IpKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGFj
cGlfcHJvY2Vzc29yX2RldmljZV9yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCit7
CisJcHJfZGVidWcoUFJFRklYICJYZW4gZG9lcyBub3Qgc3VwcG9ydCBDUFUgaG90cmVtb3ZlXG4i
KTsKKworCXJldHVybiAtRU5PU1lTOworfQorCitzdGF0aWMgdm9pZCBhY3BpX3Byb2Nlc3Nvcl9o
b3RwbHVnX25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUsCisJCQkJCSAgdTMyIGV2ZW50LCB2b2lk
ICpkYXRhKQoreworCXN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHI7CisJc3RydWN0IGFjcGlfZGV2
aWNlICpkZXZpY2UgPSBOVUxMOworCXUzMiBvc3RfY29kZSA9IEFDUElfT1NUX1NDX05PTl9TUEVD
SUZJQ19GQUlMVVJFOyAvKiBkZWZhdWx0ICovCisJaW50IHJlc3VsdDsKKworCXN3aXRjaCAoZXZl
bnQpIHsKKwljYXNlIEFDUElfTk9USUZZX0JVU19DSEVDSzoKKwljYXNlIEFDUElfTk9USUZZX0RF
VklDRV9DSEVDSzoKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLAorCQkJIlByb2Nl
c3NvciBkcml2ZXIgcmVjZWl2ZWQgJXMgZXZlbnRcbiIsCisJCQkoZXZlbnQgPT0gQUNQSV9OT1RJ
RllfQlVTX0NIRUNLKSA/CisJCQkiQUNQSV9OT1RJRllfQlVTX0NIRUNLIiA6ICJBQ1BJX05PVElG
WV9ERVZJQ0VfQ0hFQ0siKSk7CisKKwkJaWYgKCFpc19wcm9jZXNzb3JfcHJlc2VudChoYW5kbGUp
KQorCQkJYnJlYWs7CisKKwkJaWYgKCFhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRldmlj
ZSkpCisJCQlicmVhazsKKworCQlyZXN1bHQgPSBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfYWRkKGhh
bmRsZSwgJmRldmljZSk7CisJCWlmIChyZXN1bHQpIHsKKwkJCXByX2VycihQUkVGSVggIlVuYWJs
ZSB0byBhZGQgdGhlIGRldmljZVxuIik7CisJCQlicmVhazsKKwkJfQorCisJCW9zdF9jb2RlID0g
QUNQSV9PU1RfU0NfU1VDQ0VTUzsKKwkJYnJlYWs7CisKKwljYXNlIEFDUElfTk9USUZZX0VKRUNU
X1JFUVVFU1Q6CisJCUFDUElfREVCVUdfUFJJTlQoKEFDUElfREJfSU5GTywKKwkJCQkgICJyZWNl
aXZlZCBBQ1BJX05PVElGWV9FSkVDVF9SRVFVRVNUXG4iKSk7CisKKwkJaWYgKGFjcGlfYnVzX2dl
dF9kZXZpY2UoaGFuZGxlLCAmZGV2aWNlKSkgeworCQkJcHJfZXJyKFBSRUZJWCAiRGV2aWNlIGRv
bid0IGV4aXN0LCBkcm9wcGluZyBFSkVDVFxuIik7CisJCQlicmVhazsKKwkJfQorCQlwciA9IGFj
cGlfZHJpdmVyX2RhdGEoZGV2aWNlKTsKKwkJaWYgKCFwcikgeworCQkJcHJfZXJyKFBSRUZJWCAi
RHJpdmVyIGRhdGEgaXMgTlVMTCwgZHJvcHBpbmcgRUpFQ1RcbiIpOworCQkJYnJlYWs7CisJCX0K
KworCQkvKgorCQkgKiBUQkQ6IGltcGxlbWVudCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfcmVtb3Zl
IGlmIFhlbiBzdXBwb3J0CisJCSAqIENQVSBob3RyZW1vdmUgaW4gdGhlIGZ1dHVyZS4KKwkJICov
CisJCWFjcGlfcHJvY2Vzc29yX2RldmljZV9yZW1vdmUoZGV2aWNlKTsKKwkJYnJlYWs7CisKKwlk
ZWZhdWx0OgorCQlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQkJICAiVW5zdXBw
b3J0ZWQgZXZlbnQgWzB4JXhdXG4iLCBldmVudCkpOworCisJCS8qIG5vbi1ob3RwbHVnIGV2ZW50
OyBwb3NzaWJseSBoYW5kbGVkIGJ5IG90aGVyIGhhbmRsZXIgKi8KKwkJcmV0dXJuOworCX0KKwor
CSh2b2lkKSBhY3BpX2V2YWx1YXRlX2hvdHBsdWdfb3N0KGhhbmRsZSwgZXZlbnQsIG9zdF9jb2Rl
LCBOVUxMKTsKKwlyZXR1cm47Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1cyBpc19wcm9jZXNzb3Jf
ZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlzdHJ1Y3QgYWNwaV9kZXZpY2VfaW5mbyAq
aW5mbzsKKwljaGFyICpoaWQ7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RhdHVzID0gYWNw
aV9nZXRfb2JqZWN0X2luZm8oaGFuZGxlLCAmaW5mbyk7CisJaWYgKEFDUElfRkFJTFVSRShzdGF0
dXMpKQorCQlyZXR1cm4gc3RhdHVzOworCisJaWYgKGluZm8tPnR5cGUgPT0gQUNQSV9UWVBFX1BS
T0NFU1NPUikgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0dXJuIEFFX09LOwkvKiBmb3VuZCBhIHBy
b2Nlc3NvciBvYmplY3QgKi8KKwl9CisKKwlpZiAoIShpbmZvLT52YWxpZCAmIEFDUElfVkFMSURf
SElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0dXJuIEFFX0VSUk9SOworCX0KKworCWhpZCA9
IGluZm8tPmhhcmR3YXJlX2lkLnN0cmluZzsKKwlpZiAoKGhpZCA9PSBOVUxMKSB8fCBzdHJjbXAo
aGlkLCBBQ1BJX1BST0NFU1NPUl9ERVZJQ0VfSElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0
dXJuIEFFX0VSUk9SOworCX0KKworCWtmcmVlKGluZm8pOworCXJldHVybiBBRV9PSzsJLyogZm91
bmQgYSBwcm9jZXNzb3IgZGV2aWNlIG9iamVjdCAqLworfQorCitzdGF0aWMgYWNwaV9zdGF0dXMK
K3Byb2Nlc3Nvcl93YWxrX25hbWVzcGFjZV9jYihhY3BpX2hhbmRsZSBoYW5kbGUsCisJCQkgICAg
dTMyIGx2bCwgdm9pZCAqY29udGV4dCwgdm9pZCAqKnJ2KQoreworCWFjcGlfc3RhdHVzIHN0YXR1
czsKKwlpbnQgKmFjdGlvbiA9IGNvbnRleHQ7CisKKwlzdGF0dXMgPSBpc19wcm9jZXNzb3JfZGV2
aWNlKGhhbmRsZSk7CisJaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKQorCQlyZXR1cm4gQUVfT0s7
CS8qIG5vdCBhIHByb2Nlc3NvcjsgY29udGludWUgdG8gd2FsayAqLworCisJc3dpdGNoICgqYWN0
aW9uKSB7CisJY2FzZSBJTlNUQUxMX05PVElGWV9IQU5ETEVSOgorCQlhY3BpX2luc3RhbGxfbm90
aWZ5X2hhbmRsZXIoaGFuZGxlLAorCQkJCQkgICAgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJCQkg
ICAgYWNwaV9wcm9jZXNzb3JfaG90cGx1Z19ub3RpZnksCisJCQkJCSAgICBOVUxMKTsKKwkJYnJl
YWs7CisJY2FzZSBVTklOU1RBTExfTk9USUZZX0hBTkRMRVI6CisJCWFjcGlfcmVtb3ZlX25vdGlm
eV9oYW5kbGVyKGhhbmRsZSwKKwkJCQkJICAgQUNQSV9TWVNURU1fTk9USUZZLAorCQkJCQkgICBh
Y3BpX3Byb2Nlc3Nvcl9ob3RwbHVnX25vdGlmeSk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCWJy
ZWFrOworCX0KKworCS8qIGZvdW5kIGEgcHJvY2Vzc29yOyBza2lwIHdhbGtpbmcgdW5kZXJuZWF0
aCAqLworCXJldHVybiBBRV9DVFJMX0RFUFRIOworfQorCitzdGF0aWMKK3ZvaWQgYWNwaV9wcm9j
ZXNzb3JfaW5zdGFsbF9ob3RwbHVnX25vdGlmeSh2b2lkKQoreworCWludCBhY3Rpb24gPSBJTlNU
QUxMX05PVElGWV9IQU5ETEVSOworCWFjcGlfd2Fsa19uYW1lc3BhY2UoQUNQSV9UWVBFX0FOWSwK
KwkJCSAgICBBQ1BJX1JPT1RfT0JKRUNULAorCQkJICAgIEFDUElfVUlOVDMyX01BWCwKKwkJCSAg
ICBwcm9jZXNzb3Jfd2Fsa19uYW1lc3BhY2VfY2IsIE5VTEwsICZhY3Rpb24sIE5VTEwpOworfQor
CitzdGF0aWMKK3ZvaWQgYWNwaV9wcm9jZXNzb3JfdW5pbnN0YWxsX2hvdHBsdWdfbm90aWZ5KHZv
aWQpCit7CisJaW50IGFjdGlvbiA9IFVOSU5TVEFMTF9OT1RJRllfSEFORExFUjsKKwlhY3BpX3dh
bGtfbmFtZXNwYWNlKEFDUElfVFlQRV9BTlksCisJCQkgICAgQUNQSV9ST09UX09CSkVDVCwKKwkJ
CSAgICBBQ1BJX1VJTlQzMl9NQVgsCisJCQkgICAgcHJvY2Vzc29yX3dhbGtfbmFtZXNwYWNlX2Ni
LCBOVUxMLCAmYWN0aW9uLCBOVUxMKTsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBhY3BpX2Rl
dmljZV9pZCBwcm9jZXNzb3JfZGV2aWNlX2lkc1tdID0geworCXtBQ1BJX1BST0NFU1NPUl9PQkpF
Q1RfSElELCAwfSwKKwl7QUNQSV9QUk9DRVNTT1JfREVWSUNFX0hJRCwgMH0sCisJeyIiLCAwfSwK
K307CitNT0RVTEVfREVWSUNFX1RBQkxFKGFjcGksIHByb2Nlc3Nvcl9kZXZpY2VfaWRzKTsKKwor
c3RhdGljIHN0cnVjdCBhY3BpX2RyaXZlciB4ZW5fYWNwaV9wcm9jZXNzb3JfZHJpdmVyID0gewor
CS5uYW1lID0gInByb2Nlc3NvciIsCisJLmNsYXNzID0gQUNQSV9QUk9DRVNTT1JfQ0xBU1MsCisJ
LmlkcyA9IHByb2Nlc3Nvcl9kZXZpY2VfaWRzLAorCS5vcHMgPSB7CisJCS5hZGQgPSB4ZW5fYWNw
aV9wcm9jZXNzb3JfYWRkLAorCQkucmVtb3ZlID0geGVuX2FjcGlfcHJvY2Vzc29yX3JlbW92ZSwK
KwkJfSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9hY3BpX3Byb2Nlc3Nvcl9pbml0KHZv
aWQpCit7CisJaW50IHJlc3VsdCA9IDA7CisKKwlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQor
CQlyZXR1cm4gLUVOT0RFVjsKKworCS8qIHVucmVnaXN0ZXIgdGhlIHN0dWIgd2hpY2ggb25seSB1
c2VkIHRvIHJlc2VydmUgZHJpdmVyIHNwYWNlICovCisJeGVuX3N0dWJfcHJvY2Vzc29yX2V4aXQo
KTsKKworCXJlc3VsdCA9IGFjcGlfYnVzX3JlZ2lzdGVyX2RyaXZlcigmeGVuX2FjcGlfcHJvY2Vz
c29yX2RyaXZlcik7CisJaWYgKHJlc3VsdCA8IDApIHsKKwkJeGVuX3N0dWJfcHJvY2Vzc29yX2lu
aXQoKTsKKwkJcmV0dXJuIHJlc3VsdDsKKwl9CisKKwlhY3BpX3Byb2Nlc3Nvcl9pbnN0YWxsX2hv
dHBsdWdfbm90aWZ5KCk7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyB2b2lkIF9fZXhpdCB4ZW5f
YWNwaV9wcm9jZXNzb3JfZXhpdCh2b2lkKQoreworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkp
CisJCXJldHVybjsKKworCWFjcGlfcHJvY2Vzc29yX3VuaW5zdGFsbF9ob3RwbHVnX25vdGlmeSgp
OworCisJYWNwaV9idXNfdW5yZWdpc3Rlcl9kcml2ZXIoJnhlbl9hY3BpX3Byb2Nlc3Nvcl9kcml2
ZXIpOworCisJLyoKKwkgKiBzdHViIHJlc2VydmUgc3BhY2UgYWdhaW4gdG8gcHJldmVudCBhbnkg
Y2hhbmNlIG9mIG5hdGl2ZQorCSAqIGRyaXZlciBsb2FkaW5nLgorCSAqLworCXhlbl9zdHViX3By
b2Nlc3Nvcl9pbml0KCk7CisJcmV0dXJuOworfQorCittb2R1bGVfaW5pdCh4ZW5fYWNwaV9wcm9j
ZXNzb3JfaW5pdCk7Cittb2R1bGVfZXhpdCh4ZW5fYWNwaV9wcm9jZXNzb3JfZXhpdCk7CitBQ1BJ
X01PRFVMRV9OQU1FKCJ4ZW4tYWNwaS1jcHVob3RwbHVnIik7CitNT0RVTEVfQVVUSE9SKCJMaXUg
Smluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPiIpOworTU9EVUxFX0RFU0NSSVBUSU9OKCJY
ZW4gSG90cGx1ZyBDUFUgRHJpdmVyIik7CitNT0RVTEVfTElDRU5TRSgiR1BMIik7CmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3hlbi9hY3BpLmggYi9pbmNsdWRlL3hlbi9hY3BpLmgKaW5kZXggZGM2OWM5
MS4uYzk2MmQ1ZiAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vYWNwaS5oCisrKyBiL2luY2x1ZGUv
eGVuL2FjcGkuaApAQCAtNTQsNiArNTQsOSBAQCB2b2lkIHhlbl9zdHViX21lbW9yeV9kZXZpY2Vf
ZXhpdCh2b2lkKTsKIGludCB4ZW5fc3R1Yl9wcm9jZXNzb3JfaW5pdCh2b2lkKTsKIHZvaWQgeGVu
X3N0dWJfcHJvY2Vzc29yX2V4aXQodm9pZCk7CiAKK3ZvaWQgeGVuX3BjcHVfaG90cGx1Z19zeW5j
KHZvaWQpOworaW50IHhlbl9wY3B1X2lkKHVpbnQzMl90IGFjcGlfaWQpOworCiBpbnQgeGVuX2Fj
cGlfbm90aWZ5X2h5cGVydmlzb3Jfc3RhdGUodTggc2xlZXBfc3RhdGUsCiAJCQkJICAgICB1MzIg
cG0xYV9jbnQsIHUzMiBwbTFiX2NuZCk7CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVy
ZmFjZS9wbGF0Zm9ybS5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXgg
MmM0ZmI0Yi4uYzU3ZDVmNiAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmgKKysrIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMyNCw2ICsz
MjQsMTMgQEAgc3RydWN0IHhlbnBmX2NwdV9vbCB7CiB9OwogREVGSU5FX0dVRVNUX0hBTkRMRV9T
VFJVQ1QoeGVucGZfY3B1X29sKTsKIAorI2RlZmluZSBYRU5QRl9jcHVfaG90YWRkCTU4CitzdHJ1
Y3QgeGVucGZfY3B1X2hvdGFkZCB7CisJdWludDMyX3QgYXBpY19pZDsKKwl1aW50MzJfdCBhY3Bp
X2lkOworCXVpbnQzMl90IHB4bTsKK307CisKICNkZWZpbmUgWEVOUEZfbWVtX2hvdGFkZAk1OQog
c3RydWN0IHhlbnBmX21lbV9ob3RhZGQgewogCXVpbnQ2NF90IHNwZm47CkBAIC0zNjEsNiArMzY4
LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vz
c29yX3BtaW5mbyBzZXRfcG1pbmZvOwogCQlzdHJ1Y3QgeGVucGZfcGNwdWluZm8gICAgICAgICAg
cGNwdV9pbmZvOwogCQlzdHJ1Y3QgeGVucGZfY3B1X29sICAgICAgICAgICAgY3B1X29sOworCQlz
dHJ1Y3QgeGVucGZfY3B1X2hvdGFkZCAgICAgICAgY3B1X2FkZDsKIAkJc3RydWN0IHhlbnBmX21l
bV9ob3RhZGQgICAgICAgIG1lbV9hZGQ7CiAJCXN0cnVjdCB4ZW5wZl9jb3JlX3BhcmtpbmcgICAg
ICBjb3JlX3Bhcmtpbmc7CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4
XTsKLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923353DD727SHSMSX101ccrcorpi_--
