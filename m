Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3AWUAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:00:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AWUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:00:39 -0500
Date: Wed, 23 Jan 2013 15:00:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH V1 3/3] Xen processor driver
Message-ID: <20130123200023.GC18022@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C3DE6@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353C3DE6@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:33:58PM +0000, Liu, Jinsong wrote:
> >From c0166fed6d7ec8b902900157f02ad1eb189777d5 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Mon, 14 Jan 2013 15:21:24 +0800
> Subject: [PATCH 3/3] Xen processor driver
> 
> This patch implement real Xen processor driver as module.
> When loaded, it replaces Xen processor stub driver.
> 
> For booting existed processor devices, Xen processor driver
> enumerates them. For hotadded processor devices, which added
> at runtime and notify OS via device or container event, Xen
> processor driver is invoked to add them, parsing processors
> information, hypercalling to Xen hypervisor to add processors,
> and finally setting up new /sys interface for them.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/Kconfig              |   12 +
>  drivers/xen/Makefile             |    1 +
>  drivers/xen/pcpu.c               |   30 +++
>  drivers/xen/xen-processor.c      |  466 ++++++++++++++++++++++++++++++++++++++
>  include/xen/acpi.h               |    2 +
>  include/xen/interface/platform.h |    8 +
>  6 files changed, 519 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xen-processor.c
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 2dc7022..ca2535a 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -202,6 +202,18 @@ config XEN_ACPI_HOTPLUG_MEMORY
>  	  to hot-add memory at runtime (the hot-added memory cannot be
>  	  removed until machine stop), select Y/M here, otherwise select N.
>  
> +config XEN_PROCESSOR

I think the name should be XEN_ACPI_PROCESSOR but then the xen-acpi-processor
gets in the way.  Hm, perhaps this should be then called
xen-acpi-cpu-hotplug.c ?

Would that work?

Or xen-acpi-cpu.c?

So then it is called 'XEN_ACPI_CPU' ?


> +	tristate "Xen processor driver"
> +	depends on XEN_STUB && ACPI

Is there anytime a scenario where the user might compile a kernel
without DOM0 support, but with Xen_stub && ACPI?

> +	select ACPI_CONTAINER
> +	default n
> +	help
> +	  Xen processor enumerating and hotplugging
> +
> +	  For hotplugging, currently Xen only support ACPI cpu hotadd.
> +	  If you want to hotadd cpu at runtime (the hotadded cpu cannot
> +	  be removed until machine stop), select Y/M here, otherwise N.
> +
>  config XEN_ACPI_PROCESSOR
>  	tristate "Xen ACPI processor"
>  	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 1605f59..82163e6 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -32,6 +32,7 @@ obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_STUB)			+= xen-stub.o
>  obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+= xen-acpi-memhotplug.o
> +obj-$(CONFIG_XEN_PROCESSOR)		+= xen-processor.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
>  xen-evtchn-y				:= evtchn.o
>  xen-gntdev-y				:= gntdev.o
> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
> index 067fcfa..2fd5e78 100644
> --- a/drivers/xen/pcpu.c
> +++ b/drivers/xen/pcpu.c
> @@ -333,6 +333,36 @@ static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  

Please explain why this is neccessary. Preferable via a comment in the
code

> +void xen_pcpu_hotplug_sync(void)
> +{
> +	schedule_work(&xen_pcpu_work);
> +}
> +EXPORT_SYMBOL_GPL(xen_pcpu_hotplug_sync);
> +

Please give it a nice comment explaining what it does.

> +int xen_pcpu_id(uint32_t acpi_id)
> +{
> +	int cpu_id = 0, max_id = 0;
> +	struct xen_platform_op op;
> +
> +	op.cmd = XENPF_get_cpuinfo;
> +	while (cpu_id <= max_id) {
> +		op.u.pcpu_info.xen_cpuid = cpu_id;
> +		if (HYPERVISOR_dom0_op(&op)) {
> +			cpu_id++;
> +			continue;
> +		}
> +
> +		if (acpi_id == op.u.pcpu_info.acpi_id)
> +			return cpu_id;
> +		if (op.u.pcpu_info.max_present > max_id)
> +			max_id = op.u.pcpu_info.max_present;
> +		cpu_id++;
> +	}
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(xen_pcpu_id);
> +
>  static int __init xen_pcpu_init(void)
>  {
>  	int irq, ret;
> diff --git a/drivers/xen/xen-processor.c b/drivers/xen/xen-processor.c
> new file mode 100644
> index 0000000..c5e39b6
> --- /dev/null
> +++ b/drivers/xen/xen-processor.c
> @@ -0,0 +1,466 @@
> +/*
> + * Copyright (C) 2012 Intel Corporation
> + *    Author: Liu Jinsong <jinsong.liu@intel.com>
> + *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + * NON INFRINGEMENT.  See the GNU General Public License for more
> + * details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/cpu.h>
> +#include <linux/acpi.h>
> +#include <linux/uaccess.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +#include <acpi/processor.h>
> +
> +#include <xen/acpi.h>
> +#include <xen/interface/platform.h>
> +#include <asm/xen/hypercall.h>
> +
> +#define PREFIX "ACPI:xen_cpu_hotplug:"

So 'xen_cpu_hotplug' here but later on:
ACPI_MODULE_NAME("xen-processor");

I think the "xen-acpi-cpu-hotplug" or "xen-acpi-cpu" would sound much better.

> +
> +#define INSTALL_NOTIFY_HANDLER		0
> +#define UNINSTALL_NOTIFY_HANDLER	1
> +
> +static acpi_status xen_acpi_cpu_hotadd(struct acpi_processor *pr);
> +
> +/* --------------------------------------------------------------------------
> +				Driver Interface
> +-------------------------------------------------------------------------- */
> +
> +static int xen_acpi_processor_enable(struct acpi_device *device)
> +{
> +	acpi_status status = 0;
> +	unsigned long long value;
> +	union acpi_object object = { 0 };
> +	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
> +	struct acpi_processor *pr;
> +
> +	pr = acpi_driver_data(device);
> +	if (!pr) {
> +		pr_err(PREFIX "Cannot find driver data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_OBJECT_HID)) {
> +		/* Declared with "Processor" statement; match ProcessorID */
> +		status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
> +		if (ACPI_FAILURE(status)) {
> +			pr_err(PREFIX "Evaluating processor object\n");
> +			return -ENODEV;
> +		}
> +
> +		pr->acpi_id = object.processor.proc_id;
> +	} else {
> +		/* Declared with "Device" statement; match _UID */
> +		status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
> +						NULL, &value);
> +		if (ACPI_FAILURE(status)) {
> +			pr_err(PREFIX "Evaluating processor _UID\n");
> +			return -ENODEV;
> +		}
> +
> +		pr->acpi_id = value;
> +	}
> +
> +	pr->id = xen_pcpu_id(pr->acpi_id);
> +
> +	if ((int)pr->id < 0)
> +		if (ACPI_FAILURE(xen_acpi_cpu_hotadd(pr))) {
> +			pr_err(PREFIX "Hotadd CPU (acpi_id = %d) fail.\n",

failed
> +					pr->acpi_id);
> +			return -ENODEV;
> +		}
> +
> +	return 0;
> +}
> +
> +static int __cpuinit xen_acpi_processor_add(struct acpi_device *device)
> +{
> +	int ret;
> +	struct acpi_processor *pr;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
> +	if (!pr)
> +		return -ENOMEM;
> +
> +	pr->handle = device->handle;
> +	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
> +	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
> +	device->driver_data = pr;
> +
> +	ret = xen_acpi_processor_enable(device);
> +	if (ret)
> +		pr_err(PREFIX "Error when enable Xen processor\n");

Um. "Error when enabling Xen processor"
> +
> +	return ret;
> +}
> +
> +static int xen_acpi_processor_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_processor *pr;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	pr = acpi_driver_data(device);
> +	if (!pr)
> +		return -EINVAL;
> +
> +	kfree(pr);
> +	return 0;
> +}
> +
> +/*--------------------------------------------------------------
> +		Acpi processor hotplug support
> +--------------------------------------------------------------*/
> +
> +static int is_processor_present(acpi_handle handle)
> +{
> +	acpi_status status;
> +	unsigned long long sta = 0;
> +
> +
> +	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
> +
> +	if (ACPI_SUCCESS(status) && (sta & ACPI_STA_DEVICE_PRESENT))
> +		return 1;
> +
> +	/*
> +	 * _STA is mandatory for a processor that supports hot plug
> +	 */
> +	if (status == AE_NOT_FOUND)
> +		pr_info(PREFIX "Processor does not support hot plug\n");
> +	else
> +		pr_info(PREFIX "Processor Device is not present");
> +	return 0;
> +}
> +
> +static int xen_apic_id(acpi_handle handle)
> +{
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj;
> +	struct acpi_madt_local_apic *lapic;
> +	int apic_id;
> +
> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
> +		return -EINVAL;
> +
> +	if (!buffer.length || !buffer.pointer)
> +		return -EINVAL;
> +
> +	obj = buffer.pointer;
> +	if (obj->type != ACPI_TYPE_BUFFER ||
> +	    obj->buffer.length < sizeof(*lapic)) {
> +		kfree(buffer.pointer);
> +		return -EINVAL;
> +	}
> +
> +	lapic = (struct acpi_madt_local_apic *)obj->buffer.pointer;
> +
> +	if (lapic->header.type != ACPI_MADT_TYPE_LOCAL_APIC ||
> +	    !(lapic->lapic_flags & ACPI_MADT_ENABLED)) {
> +		kfree(buffer.pointer);
> +		return -EINVAL;
> +	}
> +
> +	apic_id = (uint32_t)lapic->id;
> +	kfree(buffer.pointer);
> +	buffer.length = ACPI_ALLOCATE_BUFFER;
> +	buffer.pointer = NULL;
> +
> +	return apic_id;
> +}
> +
> +static int xen_hotadd_cpu(struct acpi_processor *pr)
> +{
> +	int cpu_id, apic_id, pxm;
> +	struct xen_platform_op op;
> +
> +	apic_id = xen_apic_id(pr->handle);
> +	if (apic_id < 0) {
> +		pr_err(PREFIX "Fail to get apic_id for acpi_id %d\n",
> +				pr->acpi_id);

Failed
> +		return -ENODEV;
> +	}
> +
> +	pxm = xen_acpi_get_pxm(pr->handle);
> +	if (pxm < 0) {
> +		pr_err(PREFIX "Fail to get _PXM for acpi_id %d\n",
> +				pr->acpi_id);

Failed
> +		return pxm;
> +	}
> +
> +	op.cmd = XENPF_cpu_hotadd;
> +	op.u.cpu_add.apic_id = apic_id;
> +	op.u.cpu_add.acpi_id = pr->acpi_id;
> +	op.u.cpu_add.pxm = pxm;
> +
> +	cpu_id = HYPERVISOR_dom0_op(&op);
> +	if (cpu_id < 0)
> +		pr_err(PREFIX "Fail to hotadd CPU for acpi_id %d\n",

Failed ..
> +				pr->acpi_id);
> +
> +	return cpu_id;
> +}
> +
> +static acpi_status xen_acpi_cpu_hotadd(struct acpi_processor *pr)
> +{
> +	if (!is_processor_present(pr->handle))
> +		return AE_ERROR;
> +
> +	pr->id = xen_hotadd_cpu(pr);
> +	if ((int)pr->id < 0)
> +		return AE_ERROR;
> +
> +	xen_pcpu_hotplug_sync();
> +
> +	return AE_OK;
> +}
> +
> +static
> +int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
> +{
> +	acpi_handle phandle;
> +	struct acpi_device *pdev;
> +
> +	if (acpi_get_parent(handle, &phandle))
> +		return -ENODEV;
> +
> +	if (acpi_bus_get_device(phandle, &pdev))
> +		return -ENODEV;
> +
> +	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int acpi_processor_device_remove(struct acpi_device *device)
> +{
> +	pr_debug(PREFIX "Xen does not support CPU hotremove\n");
> +
> +	return -ENOSYS;
> +}
> +
> +static void acpi_processor_hotplug_notify(acpi_handle handle,
> +					  u32 event, void *data)
> +{
> +	struct acpi_processor *pr;
> +	struct acpi_device *device = NULL;
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> +	int result;
> +
> +	switch (event) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +			"Processor driver received %s event\n",
> +			(event == ACPI_NOTIFY_BUS_CHECK) ?
> +			"ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK"));
> +
> +		if (!is_processor_present(handle))
> +			break;
> +
> +		if (!acpi_bus_get_device(handle, &device))
> +			break;
> +
> +		result = acpi_processor_device_add(handle, &device);
> +		if (result) {
> +			pr_err(PREFIX "Unable to add the device\n");
> +			break;
> +		}
> +
> +		ost_code = ACPI_OST_SC_SUCCESS;
> +		break;
> +
> +	case ACPI_NOTIFY_EJECT_REQUEST:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
> +
> +		if (acpi_bus_get_device(handle, &device)) {
> +			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
> +			break;
> +		}
> +		pr = acpi_driver_data(device);
> +		if (!pr) {
> +			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
> +			break;
> +		}
> +
> +		/*
> +		 * TBD: implement acpi_processor_device_remove if Xen support
> +		 * CPU hotremove in the future.
> +		 */
> +		acpi_processor_device_remove(device);
> +		break;
> +
> +	default:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "Unsupported event [0x%x]\n", event));
> +
> +		/* non-hotplug event; possibly handled by other handler */
> +		return;
> +	}
> +
> +	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
> +	return;
> +}
> +
> +static acpi_status is_processor_device(acpi_handle handle)
> +{
> +	struct acpi_device_info *info;
> +	char *hid;
> +	acpi_status status;
> +
> +	status = acpi_get_object_info(handle, &info);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	if (info->type == ACPI_TYPE_PROCESSOR) {
> +		kfree(info);
> +		return AE_OK;	/* found a processor object */
> +	}
> +
> +	if (!(info->valid & ACPI_VALID_HID)) {
> +		kfree(info);
> +		return AE_ERROR;
> +	}
> +
> +	hid = info->hardware_id.string;
> +	if ((hid == NULL) || strcmp(hid, ACPI_PROCESSOR_DEVICE_HID)) {
> +		kfree(info);
> +		return AE_ERROR;
> +	}
> +
> +	kfree(info);
> +	return AE_OK;	/* found a processor device object */
> +}
> +
> +static acpi_status
> +processor_walk_namespace_cb(acpi_handle handle,
> +			    u32 lvl, void *context, void **rv)
> +{
> +	acpi_status status;
> +	int *action = context;
> +
> +	status = is_processor_device(handle);
> +	if (ACPI_FAILURE(status))
> +		return AE_OK;	/* not a processor; continue to walk */
> +
> +	switch (*action) {
> +	case INSTALL_NOTIFY_HANDLER:
> +		acpi_install_notify_handler(handle,
> +					    ACPI_SYSTEM_NOTIFY,
> +					    acpi_processor_hotplug_notify,
> +					    NULL);
> +		break;
> +	case UNINSTALL_NOTIFY_HANDLER:
> +		acpi_remove_notify_handler(handle,
> +					   ACPI_SYSTEM_NOTIFY,
> +					   acpi_processor_hotplug_notify);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* found a processor; skip walking underneath */
> +	return AE_CTRL_DEPTH;
> +}
> +
> +static
> +void acpi_processor_install_hotplug_notify(void)
> +{
> +	int action = INSTALL_NOTIFY_HANDLER;
> +	acpi_walk_namespace(ACPI_TYPE_ANY,
> +			    ACPI_ROOT_OBJECT,
> +			    ACPI_UINT32_MAX,
> +			    processor_walk_namespace_cb, NULL, &action, NULL);
> +}
> +
> +static
> +void acpi_processor_uninstall_hotplug_notify(void)
> +{
> +	int action = UNINSTALL_NOTIFY_HANDLER;
> +	acpi_walk_namespace(ACPI_TYPE_ANY,
> +			    ACPI_ROOT_OBJECT,
> +			    ACPI_UINT32_MAX,
> +			    processor_walk_namespace_cb, NULL, &action, NULL);
> +}
> +
> +static const struct acpi_device_id processor_device_ids[] = {
> +	{ACPI_PROCESSOR_OBJECT_HID, 0},
> +	{ACPI_PROCESSOR_DEVICE_HID, 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, processor_device_ids);
> +
> +static struct acpi_driver xen_acpi_processor_driver = {
> +	.name = "processor",
> +	.class = ACPI_PROCESSOR_CLASS,
> +	.ids = processor_device_ids,
> +	.ops = {
> +		.add = xen_acpi_processor_add,
> +		.remove = xen_acpi_processor_remove,
> +		},
> +};
> +
> +static int __init xen_acpi_processor_init(void)
> +{
> +	int result = 0;
> +
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	/* unregister the stub which only used to reserve driver space */
> +	acpi_bus_unregister_driver(&xen_stub_processor_driver);

So looking at my comments, perhaps you could make the

xen_stub_processor_unint(void) return the 'struct acpi_driver *'?

That way you can do:

	old = xen_stub_processor_deinit(void);
> +
> +	result = acpi_bus_register_driver(&xen_acpi_processor_driver);
> +	if (result < 0) {
> +		acpi_bus_register_driver(&xen_stub_processor_driver);

and here do:
		acpi_bus_register_driver(old);


> +		return result;
> +	}
> +
> +	acpi_processor_install_hotplug_notify();
> +	return 0;
> +}
> +
> +static void __exit xen_acpi_processor_exit(void)
> +{
> +	if (!xen_initial_domain())
> +		return;
> +
> +	acpi_processor_uninstall_hotplug_notify();
> +
> +	acpi_bus_unregister_driver(&xen_acpi_processor_driver);
> +
> +	/*
> +	 * stub reserve space again to prevent any chance of native
> +	 * driver loading.
> +	 */
> +	acpi_bus_register_driver(&xen_stub_processor_driver);
> +	return;
> +}
> +
> +module_init(xen_acpi_processor_init);
> +module_exit(xen_acpi_processor_exit);
> +ACPI_MODULE_NAME("xen-processor");
> +MODULE_AUTHOR("Liu Jinsong <jinsong.liu@intel.com>");
> +MODULE_DESCRIPTION("Xen Processor Driver");

Xen ACPI Processor Driver
> +MODULE_LICENSE("GPL");
> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
> index 5ac46d3..3de217e 100644
> --- a/include/xen/acpi.h
> +++ b/include/xen/acpi.h
> @@ -45,6 +45,8 @@
>  #define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
>  
>  extern struct acpi_driver xen_stub_memory_device_driver;
> +extern void xen_pcpu_hotplug_sync(void);
> +extern int xen_pcpu_id(uint32_t acpi_id);
>  
>  static inline int xen_acpi_get_pxm(acpi_handle h)
>  {
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 2c4fb4b..c57d5f6 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -324,6 +324,13 @@ struct xenpf_cpu_ol {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
>  
> +#define XENPF_cpu_hotadd	58
> +struct xenpf_cpu_hotadd {
> +	uint32_t apic_id;
> +	uint32_t acpi_id;
> +	uint32_t pxm;
> +};
> +
>  #define XENPF_mem_hotadd	59
>  struct xenpf_mem_hotadd {
>  	uint64_t spfn;
> @@ -361,6 +368,7 @@ struct xen_platform_op {
>  		struct xenpf_set_processor_pminfo set_pminfo;
>  		struct xenpf_pcpuinfo          pcpu_info;
>  		struct xenpf_cpu_ol            cpu_ol;
> +		struct xenpf_cpu_hotadd        cpu_add;
>  		struct xenpf_mem_hotadd        mem_add;
>  		struct xenpf_core_parking      core_parking;
>  		uint8_t                        pad[128];
> -- 
> 1.7.1


