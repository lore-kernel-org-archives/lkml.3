Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbbAVWeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:34:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62934 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753114AbbAVWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:34:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ken Xue <Ken.Xue@amd.com>
Cc: andy.shevchenko@gmail.com, mika.westerberg@linux.intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V3] acpi:soc: merge common codes for creating platform device
Date: Thu, 22 Jan 2015 23:57:25 +0100
Message-ID: <6052429.AmgHyeF3V4@vostro.rjw.lan>
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

This triggers a build warning, because the return value of sysfs_create_group()
is not checked.  You can simply return it as the original code does (it will
be discarded anyway) or add a dev_dbg() message that will be printed if it is not
zero.

Also it turns out that we have a bug in the original code modified by your patches.

The currently considered fix is this one:

	https://patchwork.kernel.org/patch/5677461/

but it may not be final.

This bug has to be fixed before your patches are applied, because we need the
fix to be there in 3.19 (or at least in 3.19.y), so I'll ask you to rebase your
patches on top of the final fix once we've got one.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
