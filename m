Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbbATOtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:49:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60892 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751501AbbATOtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:49:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ken Xue <Ken.Xue@amd.com>, mika.westerberg@linux.intel.com
Cc: andy.shevchenko@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V3] acpi:soc: merge common codes for creating platform device
Date: Tue, 20 Jan 2015 16:12:16 +0100
Message-ID: <1566252.Xx6LHhsTBM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418892285.17614.6.camel@kxue-X58A-UD3R>
References: <1418892285.17614.6.camel@kxue-X58A-UD3R>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 04:44:45 PM Ken Xue wrote:
> 
> This patch is supposed to deliver some common codes for AMD APD and
> intel LPSS. It can help to convert some specific acpi devices to be
> platform devices.
> 
> Signed-off-by: Ken Xue <Ken.Xue@amd.com>

Mika, is the v3 fine with you?

> ---
>  drivers/acpi/Makefile   |   2 +-
>  drivers/acpi/acpi_soc.c | 228 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/acpi_soc.h | 104 ++++++++++++++++++++++
>  3 files changed, 333 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/acpi/acpi_soc.c
>  create mode 100644 drivers/acpi/acpi_soc.h
> 
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index f74317c..66c7457 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -40,7 +40,7 @@ acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
>  acpi-y				+= ec.o
>  acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
>  acpi-y				+= pci_root.o pci_link.o pci_irq.o
> -acpi-y				+= acpi_lpss.o
> +acpi-y				+= acpi_soc.o acpi_lpss.o
>  acpi-y				+= acpi_platform.o
>  acpi-y				+= acpi_pnp.o
>  acpi-y				+= int340x_thermal.o
> diff --git a/drivers/acpi/acpi_soc.c b/drivers/acpi/acpi_soc.c
> new file mode 100644
> index 0000000..2abbac9
> --- /dev/null
> +++ b/drivers/acpi/acpi_soc.c
> @@ -0,0 +1,228 @@
> +/*
> + * ACPI SOC support for Intel Lynxpoint LPSS and AMD APD.
> + *
> + * Copyright (C) 2013, 2014, Intel Corporation
> + * Copyright (C) 2014, AMD Corporation
> + * Authors: Ken Xue <Ken.Xue@amd.com>
> + *		Mika Westerberg <mika.westerberg@linux.intel.com>
> + *		Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/pm_domain.h>
> +#include <linux/platform_device.h>
> +
> +#include "acpi_soc.h"
> +#include "internal.h"
> +
> +ACPI_MODULE_NAME("acpi_soc");
> +
> +/* A list for all ACPI SOC device */
> +static LIST_HEAD(a_soc_list);
> +
> +static int is_memory(struct acpi_resource *res, void *not_used)
> +{
> +	struct resource r;
> +
> +	return !acpi_dev_resource_memory(res, &r);
> +}
> +
> +static int acpi_soc_create_device(struct acpi_device *adev,
> +				   const struct acpi_device_id *id)
> +{
> +	struct acpi_soc_dev_private_data *pdata;
> +	struct acpi_soc_dev_desc *dev_desc;
> +	struct resource_list_entry *rentry;
> +	struct list_head resource_list;
> +	struct platform_device *pdev;
> +	int ret;
> +
> +	dev_desc = (struct acpi_soc_dev_desc *)id->driver_data;
> +	if (!dev_desc) {
> +		pdev = acpi_create_platform_device(adev);
> +		return IS_ERR_OR_NULL(pdev) ? PTR_ERR(pdev) : 1;
> +	}
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
> +	if (ret < 0)
> +		goto err_out;
> +
> +	list_for_each_entry(rentry, &resource_list, node)
> +		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> +			if (dev_desc->mem_size_override)
> +				pdata->mmio_size = dev_desc->mem_size_override;
> +			else
> +				pdata->mmio_size = resource_size(&rentry->res);
> +			pdata->mmio_base = ioremap(rentry->res.start,
> +						   pdata->mmio_size);
> +			break;
> +		}
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	pdata->adev = adev;
> +	pdata->dev_desc = dev_desc;
> +
> +	if (dev_desc->setup) {
> +		ret = dev_desc->setup(pdata);
> +		if (ret)
> +			goto err_out;
> +	}
> +
> +	/*
> +	 * This works around a known issue in ACPI tables where ACPI SOC devices
> +	 * have _PS0 and _PS3 without _PSC (and no power resources), so
> +	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
> +	 */
> +	ret = acpi_device_fix_up_power(adev);
> +	if (ret) {
> +		/* Skip the device, but continue the namespace scan. */
> +		ret = 0;
> +		goto err_out;
> +	}
> +
> +	adev->driver_data = pdata;
> +	pdev = acpi_create_platform_device(adev);
> +	if (!IS_ERR_OR_NULL(pdev)) {
> +		pdata->pdev = pdev;
> +		if (dev_desc->post_setup) {
> +			ret = dev_desc->post_setup(pdata);
> +			if (ret)
> +				goto err_out;
> +		}
> +		return 1;
> +	}
> +
> +	ret = PTR_ERR(pdev);
> +	adev->driver_data = NULL;
> +
> + err_out:
> +	kfree(pdata);
> +	return ret;
> +}
> +
> +static int acpi_soc_platform_notify(struct notifier_block *nb,
> +				     unsigned long action, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(data);
> +	struct acpi_soc_dev_private_data *pdata;
> +	const struct acpi_device_id *id = NULL;
> +	struct acpi_soc *a_soc_entry;
> +	struct acpi_device *adev;
> +
> +	list_for_each_entry(a_soc_entry, &a_soc_list, list) {
> +		id = acpi_match_device(a_soc_entry->ids, &pdev->dev);
> +		if (id)
> +			break;
> +	}
> +
> +	if (!id || !id->driver_data)
> +		return 0;
> +
> +	if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
> +		return 0;
> +
> +	pdata = acpi_driver_data(adev);
> +	if (!pdata || !pdata->mmio_base)
> +		return 0;
> +
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		if (pdata->dev_desc->flags & ACPI_SOC_PM) {
> +			if (a_soc_entry->pm_domain)
> +				pdev->dev.pm_domain = a_soc_entry->pm_domain;
> +			else if (pdata->dev_desc->flags & ACPI_SOC_PM_ON)
> +				dev_pm_domain_attach(&pdev->dev, true);
> +			else
> +				dev_pm_domain_attach(&pdev->dev, false);
> +		}
> +		if ((pdata->dev_desc->flags & ACPI_SOC_SYSFS)
> +			&& a_soc_entry->attr_group)
> +			sysfs_create_group(&pdev->dev.kobj,
> +					  a_soc_entry->attr_group);
> +		break;
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		if ((pdata->dev_desc->flags & ACPI_SOC_SYSFS)
> +			&& a_soc_entry->attr_group)
> +			sysfs_remove_group(&pdev->dev.kobj,
> +					a_soc_entry->attr_group);
> +		if (pdata->dev_desc->flags & ACPI_SOC_PM) {
> +			if (a_soc_entry->pm_domain)
> +				pdev->dev.pm_domain = a_soc_entry->pm_domain;
> +			else if (pdata->dev_desc->flags & ACPI_SOC_PM_ON)
> +				dev_pm_domain_detach(&pdev->dev, true);
> +			else
> +				dev_pm_domain_detach(&pdev->dev, false);
> +		}
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct notifier_block acpi_soc_nb = {
> +	.notifier_call = acpi_soc_platform_notify,
> +};
> +
> +static void acpi_soc_bind(struct device *dev)
> +{
> +	struct acpi_soc_dev_private_data *pdata;
> +
> +	pdata = acpi_driver_data(ACPI_COMPANION(dev));
> +
> +	if (!pdata || !pdata->dev_desc || !pdata->dev_desc->bind)
> +		return;
> +
> +	pdata->dev_desc->bind(pdata, dev);
> +}
> +
> +static void acpi_soc_unbind(struct device *dev)
> +{
> +	struct acpi_soc_dev_private_data *pdata;
> +
> +	pdata = acpi_driver_data(ACPI_COMPANION(dev));
> +
> +	if (!pdata || !pdata->dev_desc || !pdata->dev_desc->unbind)
> +		return;
> +
> +	pdata->dev_desc->unbind(pdata, dev);
> +}
> +
> +/**
> + * register_acpi_soc - register a new ACPI SOC
> + * @a_soc: ACPI SOC
> + * @disable_scan_handler: true means remove default scan handle
> + *                      false means use default scan handle
> + *
> + * register a new ACPI SOC into asoc_list and install default scan handle.
> + */
> +void register_acpi_soc(struct acpi_soc *a_soc, bool disable_scan_handler)
> +{
> +	struct acpi_scan_handler *acpi_soc_handler;
> +	static int init;
> +
> +	INIT_LIST_HEAD(&a_soc->list);
> +	list_add(&a_soc->list, &a_soc_list);
> +
> +	acpi_soc_handler = kzalloc(sizeof(*acpi_soc_handler), GFP_KERNEL);
> +	acpi_soc_handler->ids = a_soc->ids;
> +	if (!disable_scan_handler) {
> +		acpi_soc_handler->attach = acpi_soc_create_device;
> +		acpi_soc_handler->bind = acpi_soc_bind;
> +		acpi_soc_handler->unbind = acpi_soc_unbind;
> +		if (init == 0) {
> +			init++;
> +			bus_register_notifier(&platform_bus_type, &acpi_soc_nb);
> +		}
> +	}
> +	acpi_scan_add_handler(acpi_soc_handler);
> +}
> diff --git a/drivers/acpi/acpi_soc.h b/drivers/acpi/acpi_soc.h
> new file mode 100644
> index 0000000..39a7f0a
> --- /dev/null
> +++ b/drivers/acpi/acpi_soc.h
> @@ -0,0 +1,104 @@
> +/*
> + * ACPI SOC support for Intel Lynxpoint LPSS and AMD APD.
> + *
> + * Copyright (C) 2013,2014 Intel Corporation
> + * Copyright (C) 2014 AMD Corporation
> + * Authors: Ken Xue <Ken.Xue@amd.com>
> + *		Mika Westerberg <mika.westerberg@linux.intel.com>
> + *		Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _ACPI_SOC_H
> +#define _ACPI_SOC_H
> +
> +#include <linux/platform_device.h>
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/pm.h>
> +
> +struct acpi_soc_dev_private_data;
> +
> +/**
> + * struct acpi_soc - acpi soc
> + * @list: list head
> + * @ids: all acpi device ids for acpi soc
> + * @pm_domain: power domain for all acpi device;can be NULL
> + * @attr_group: attribute group for sysfs support of acpi soc;can be NULL
> + */
> +struct acpi_soc {
> +	struct list_head	list;
> +	struct acpi_device_id	*ids;
> +	struct dev_pm_domain	*pm_domain;
> +	struct attribute_group	*attr_group;
> +};
> +
> +
> +/**
> + * device flags of acpi_soc_dev_desc.
> + * bit 16 to 31 reserved for acpi soc.
> + * bit 0 ~15 reserved for private flags.
> + * ACPI_SOC_SYSFS : add device attributes in sysfs
> + * ACPI_SOC_PM : attach power domain to device
> + * ACPI_SOC_PM_ON : power on device when attach power domain
> + */
> +#define ACPI_SOC_SYSFS	BIT(16)
> +#define ACPI_SOC_PM	BIT(17)
> +#define ACPI_SOC_PM_ON	BIT(18)
> +
> +/**
> + * struct acpi_soc_dev_desc - a descriptor for acpi device
> + * @flags: device flags like ACPI_SOC_SYSFS ACPI_SOC_PM ACPI_SOC_PM_ON
> + * @clk: clock device
> + * @fixed_clk_rate: fixed rate input clock source for acpi device;
> + *			0 means no fixed rate input clock source
> + * @mem_size_override: a workaround for override device memsize;
> + *			0 means no needs for this WA
> + * @prv_offset: reg offest of lpss features
> + * @setup: a hook routine to set device resource during create platform device
> + * @post_setup: a hook routine after platform device is created
> + * @bind: a hook of acpi_scan_handler.bind
> + * @unbind: a hook of acpi_scan_handler.unbind
> + *
> + * device description defined as acpi_device_id.driver_data
> + */
> +struct acpi_soc_dev_desc {
> +	unsigned int flags;
> +	struct clk *clk;
> +	unsigned int fixed_clk_rate;
> +	size_t mem_size_override;
> +	unsigned int prv_offset;
> +	int (*setup)(struct acpi_soc_dev_private_data *pdata);
> +	int (*post_setup)(struct acpi_soc_dev_private_data *pdata);
> +	void (*bind)(struct acpi_soc_dev_private_data *pdata,
> +				struct device *dev);
> +	void (*unbind)(struct acpi_soc_dev_private_data *pdata,
> +				struct device *dev);
> +};
> +
> +#define ACPI_SOC_REG_CONTEXT_MAX		10
> +
> +/**
> + * struct acpi_soc_dev_private_data - acpi device private data
> + * @mmio_base: virtual memory base addr of the device
> + * @mmio_size: device memory size
> + * @dev_desc: device description
> + * @pdev: platform device
> + * @adev: acpi device
> + * @prv_reg_ctx: reg context for power management
> + */
> +struct acpi_soc_dev_private_data {
> +	void __iomem *mmio_base;
> +	resource_size_t mmio_size;
> +
> +	struct acpi_soc_dev_desc *dev_desc;
> +	struct platform_device *pdev;
> +	struct acpi_device *adev;
> +	u32 prv_reg_ctx[ACPI_SOC_REG_CONTEXT_MAX];
> +};
> +
> +void register_acpi_soc(struct acpi_soc *a_soc, bool disable_scan_handler);
> +
> +#endif
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
