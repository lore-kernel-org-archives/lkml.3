Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaK0LrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:47:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:43436 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbaK0LrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:47:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="614949575"
Date: Thu, 27 Nov 2014 13:46:37 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ken Xue <Ken.Xue@amd.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Jeff" <Jeff.Wu@amd.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86
 system.
Message-ID: <20141127114637.GA1304@lahna.fi.intel.com>
References: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com>
 <20864469.6Ozf1NSibZ@vostro.rjw.lan>
 <4AC89B18A26BAB43B540DB1C94E2802C05A48D06@scybexdag03.amd.com>
 <2267517.glgofXUn7B@vostro.rjw.lan>
 <1416997898.17328.5.camel@kxue-X58A-UD3R>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416997898.17328.5.camel@kxue-X58A-UD3R>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 06:31:38PM +0800, Ken Xue wrote:
> On 一, 2014-11-24 at 02:47 +0100, Rafael J. Wysocki wrote:
> > On Monday, November 24, 2014 01:02:30 AM Xue, Ken wrote:
> > > 
> > > On Tuesday, November 18, 2014 01:58:11 PM Ken Xue wrote:
> > > > This new feature is to interpret AMD specific ACPI device to platform 
> > > > device such as I2C, UART found on AMD CZ and later chipsets. It is 
> > > > based on example INTEL LPSS. Now, it can support AMD I2C & UART.
> > > > 
> > > > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> > > > Signed-off-by: Jeff Wu <Jeff.Wu@amd.com>
> > > 
> > > Generally speaking, this seems to duplicate much code from acpi_lpss which should be re-used instead.  What about moving the code that will be common between acpi_lpss and the new driver into a new file (say acpi_soc.c)?
> > > 
> > > Also, you need to avoid automatic creation of platform devices when !X86_AMD_PLATFORM_DEVICE in analogy with what acpi_lpss does, or bad things will happen.
> > > 
> > > [ken] sounds fair enough.  Let me take action to merge drivers to acpi_soc.c ? or you have other plan?
> > 
> > I'd prefer the common code to reside in one file (or one .c file and one header
> > file), and the driver-specific code to stay in separate per-driver files.
> > 
> [Ken] I wrote a proto type for acpi_soc.c. please help to confirm if it
> can match your ideal. if yes, i will submit a new patch after do more
> test and refine codes. I think it will impact lpss driver greatly, even
> i have taken it into account. below codes is for acpi_soc.c.

In general looks good. I have few comments though.

> 
> >From fc323fb7b3b4cbb79bda05ce3b1d6d8dfe5e883b Mon Sep 17 00:00:00 2001
> From: Ken Xue <Ken.Xue@amd.com>
> Date: Wed, 26 Nov 2014 17:15:30 +0800
> Subject: [PATCH] This is proto type for acpi_soc.
> 
> Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> ---
>  arch/x86/Kconfig        |  11 +++
>  drivers/acpi/Makefile   |   2 +-
>  drivers/acpi/acpi_apd.c | 123 ++++++++++++++++++++++++++++
>  drivers/acpi/acpi_soc.c | 213
> ++++++++++++++++++++++++++++++++++++++++++++++++

This is line-wrapped, please make sure when you submit the actual patch
that it is formatted properly. Also you need proper changelog etc.

>  drivers/acpi/acpi_soc.h |  91 +++++++++++++++++++++
>  drivers/acpi/internal.h |   6 ++
>  drivers/acpi/scan.c     |   1 +
>  7 files changed, 446 insertions(+), 1 deletion(-)
>  create mode 100755 drivers/acpi/acpi_apd.c
>  create mode 100755 drivers/acpi/acpi_soc.c
>  create mode 100755 drivers/acpi/acpi_soc.h
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ded8a67..6402c79f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -495,6 +495,17 @@ config X86_INTEL_LPSS
>  	  things like clock tree (common clock framework) and pincontrol
>  	  which are needed by the LPSS peripheral drivers.
>  
> +config X86_AMD_PLATFORM_DEVICE
> +	bool "AMD ACPI2Platform devices support"
> +	depends on ACPI
> +	select COMMON_CLK
> +	select PINCTRL
> +	---help---
> +	  Select to interpret AMD specific ACPI device to platform device
> +	  such as I2C, UART found on AMD CARRIZO and later chipset. Selecting
> +	  this option enables things like clock tree (common clock framework)
> +	  and pinctrl.
> +
>  config IOSF_MBI
>  	tristate "Intel SoC IOSF Sideband support for SoC platforms"
>  	depends on PCI
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index c3b2fcb..b07003a 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -40,7 +40,7 @@ acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) +=
> processor_pdc.o
>  acpi-y				+= ec.o
>  acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
>  acpi-y				+= pci_root.o pci_link.o pci_irq.o
> -acpi-y				+= acpi_lpss.o
> +acpi-y				+= acpi_soc.o acpi_lpss.o acpi_apd.o
>  acpi-y				+= acpi_platform.o
>  acpi-y				+= acpi_pnp.o
>  acpi-y				+= int340x_thermal.o
> diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
> new file mode 100755
> index 0000000..c7e916b
> --- /dev/null
> +++ b/drivers/acpi/acpi_apd.c
> @@ -0,0 +1,123 @@
> +/*
> + * AMD ACPI support for  ACPI2platform device.
> + *
> + * Copyright (c) 2014, AMD Corporation.
> + * Authors: Ken Xue <Ken.Xue@amd.com>
> + *	Wu, Jeff <Jeff.Wu@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "internal.h"
> +#include "acpi_soc.h"
> +
> +struct acpi_soc asoc;

static?

Also Is "asoc" good name? That might get confused with Alsa SoC (ASoC).

> +
> +#ifdef X86_AMD_PLATFORM_DEVICE
> +static int acpi_apd_setup(struct acpi_soc_dev_private_data *pdata)
> +{
> +	struct acpi_soc_dev_desc *dev_desc = pdata->dev_desc;
> +	struct clk *clk = ERR_PTR(-ENODEV);
> +
> +	if (dev_desc->clk)
> +		return 0;
> +	
> +	if (dev_desc->fixed_clk_rate) {
> +		clk = clk_register_fixed_rate(&pdata->adev->dev, 
> +					dev_name(&pdata->adev->dev),
> +					NULL, CLK_IS_ROOT, dev_desc->rate);
> +		dev_desc->clk = clk;
> +		clk_register_clkdev(clk, NULL, dev_name(&pdata->adev->dev));
> +	}
> +
> +	return 0;
> +}
> +
> +static struct acpi_soc_dev_desc cz_i2c_desc = {
> +	.setup = acpi_apd_setup;
> +	.fixed_clk_rate = 133000000,

Oh, good so now we can get rid the hack we did for
i2c-designware-platdrv.c with this commit:

a445900c906092f i2c: designware: Add support for AMD I2C controller

Since now you have means to pass clock to the driver.

Are you going to handle that driver as well?

> +};
> +
> +static struct acpi_soc_dev_desc cz_uart_desc = {
> +	.setup = acpi_apd_setup;
> +	.fixed_clk_rate = 48000000,
> +};
> +
> +#else
> +
> +#define APD_ADDR(desc) (0UL)
> +
> +#endif /* CONFIG_X86_INTEL_LPSS */
> +
> +static struct acpi_device_id acpi_apd_device_ids[] = {

const?

> +	/* Generic apd devices */
> +	{ "AMD0010", APD_ADDR(cz_i2c_desc) },
> +	{ "AMD0020", APD_ADDR(cz_uart_desc) },
> +	{ }
> +};
> +
> +#ifdef X86_AMD_PLATFORM_DEVICE
> +
> +static ssize_t apd_device_desc_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	struct acpi_device *adev;
> +	struct acpi_soc_dev_private_data *pdata;
> +	struct acpi_soc_dev_desc *dev_desc;
> +
> +	ret = acpi_bus_get_device(ACPI_HANDLE(dev), &adev);
> +	if (WARN_ON(ret))
> +		return ret;
> +
> +	pdata = acpi_driver_data(adev);
> +	if (WARN_ON(!pdata || !pdata->dev_desc))
> +		return -ENODEV;
> +	
> +	dev_desc = pdata->dev_desc;
> +	if (dev_desc->fixed_clk_rate)
> +		return sprintf(buf, "Required fix rate clk %s: %ld\n",
> +			dev_desc->clk->name,
> +			dev_desc->fixed_clk_rate);
> +	else
> +		return sprintf(buf, "No need clk\n");
> +}
> +
> +static DEVICE_ATTR(device_desc, S_IRUSR, apd_device_desc_show, NULL);
> +
> +static struct attribute *apd_attrs[] = {
> +	&dev_attr_device_desc.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group apd_attr_group = {
> +	.attrs = apd_attrs,
> +	.name = "apd",
> +};

This requires updating sysfs ABI but then again, do you really need the
above? And does it belong to sysfs in the first place?

> +
> +void __init acpi_apd_init(void)
> +{
> +	asoc.ids = acpi_apd_device_ids;
> +	asoc.attr_group = &apd_attr_group;
> +	register_acpi_soc(&asoc, true);
> +}
> +
> +#else
> +
> +void __init acpi_apd_init(void)
> +{
> +	asoc.ids = acpi_apd_device_ids;
> +	register_acpi_soc(&asoc, false);
> +}
> +#endif
> diff --git a/drivers/acpi/acpi_soc.c b/drivers/acpi/acpi_soc.c
> new file mode 100755
> index 0000000..99df1ab
> --- /dev/null
> +++ b/drivers/acpi/acpi_soc.c
> @@ -0,0 +1,213 @@
> +/*
> + * ACPI SOC support for Intel Lynxpoint LPSS and AMD APD.
> + *
> + * Copyright (C) 2015, Intel Corporation & AMD Corporation
> + * Authors: Ken Xue <Ken.Xue@amd.com>
> + *		Mika Westerberg <mika.westerberg@linux.intel.com>
> + *		Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/delay.h>
> +#include <linux/pm_domain.h>
> +
> +#include "internal.h"
> +#include "acpi_soc.h"
> +
> +

Delete the extra blank line

> +ACPI_MODULE_NAME("acpi_soc");
> +
> +/*A list for all acpi soc device*/
> +static LIST_HEAD(asoc_list);
> +
> +static int is_memory(struct acpi_resource *res, void *not_used)
> +{
> +	struct resource r;
> +	return !acpi_dev_resource_memory(res, &r);
> +}
> +
> +static int acpi_soc_create_device(struct acpi_device *adev,
> +				   const struct acpi_device_id *id)
> +{
> +	struct acpi_soc_dev_desc *dev_desc;
> +	struct acpi_soc_dev_private_data *pdata;
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
> +	pdata->dev_desc = dev_desc;
> +
> +	/*setup device by a hook routine*/

The comment should look like this

	/* Setup device by hook routine */

but I think it does not provide any new information so you can just drop
it.

> +	if (dev_desc->setup)
> +		dev_desc->setup(pdata);
> +
> +	/*
> +	 * This works around a known issue in ACPI tables where acpi soc
> devices
> +	 * have _PS0 and _PS3 without _PSC (and no power resources), so
> +	 * acpi_bus_init_power() will assume that the BIOS has put them into
> D0.
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
> +	struct acpi_device *adev;
> +	struct acpi_soc *asoc_entry;
> +	const struct acpi_device_id *id = NULL;
> +
> +	list_for_each_entry(asoc_entry, &asoc_list, list) {
> +		id = acpi_match_device(asoc_entry->ids, &pdev->dev);
> +		if (!id)
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
> +	case BUS_NOTIFY_BOUND_DRIVER:
> +		if ((pdata->dev_desc->flags & ACPI_SOC_PM)){
> +			if (asoc_entry->pm_domain)
> +				pdev->dev.pm_domain = asoc_entry->pm_domain;
> +			else if (pdata->dev_desc->flags & ACPI_SOC_PM_ON)
> +					dev_pm_domain_attach(&pdev->dev, true);
> +			else
> +					dev_pm_domain_attach(&pdev->dev, false);
> +		}	
> +		break;
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +		if ((pdata->dev_desc->flags & ACPI_SOC_PM)){
> +			if (asoc_entry->pm_domain)
> +				pdev->dev.pm_domain = asoc_entry->pm_domain;
> +			else if (pdata->dev_desc->flags & ACPI_SOC_PM_ON)
> +					dev_pm_domain_detach(&pdev->dev, true);
> +			else
> +					dev_pm_domain_detach(&pdev->dev, false);
> +		}	
> +		break;
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		if ((pdata->dev_desc->flags & ACPI_SOC_SYSFS) &&
> asoc_entry->pm_domain)
> +			return sysfs_create_group(&pdev->dev.kobj,
> +						  asoc_entry->attr_group);
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		if ((pdata->dev_desc->flags & ACPI_SOC_SYSFS) &&
> asoc_entry->pm_domain)
> +			sysfs_remove_group(&pdev->dev.kobj, asoc_entry->attr_group);
> +	default:
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
> +	pdata->dev_desc->bind(pdata);
> +	return;
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
> +	pdata->dev_desc->unbind(pdata);
> +	return;
> +}
> +
> +void register_acpi_soc(struct acpi_soc *asoc, bool
> disable_scan_handler)
> +{
> +	struct acpi_scan_handler *acpi_soc_handler;
> +	
> +	INIT_LIST_HEAD(&asoc->list);
> +	list_add(&asoc->list, &asoc_list);
> +
> +	acpi_soc_handler = kzalloc(sizeof(struct acpi_scan_handler),
> GFP_KERNEL);
> +	acpi_soc_handler->ids = asoc->ids;
> +	if (!disable_scan_handler) {
> +		acpi_soc_handler->attach = acpi_soc_create_device;
> +		acpi_soc_handler->bind = acpi_soc_bind;
> +		acpi_soc_handler->unbind = acpi_soc_unbind;
> +	}	
> +	acpi_scan_add_handler(acpi_soc_handler);
> +	bus_register_notifier(&platform_bus_type, &acpi_soc_nb);
> +}
> +EXPORT_SYMBOL_GPL(register_acpi_soc);

I don't think we want to export these to modules.

> diff --git a/drivers/acpi/acpi_soc.h b/drivers/acpi/acpi_soc.h
> new file mode 100755
> index 0000000..96db30e
> --- /dev/null
> +++ b/drivers/acpi/acpi_soc.h

And all this belongs to drivers/acpi/internal.h.

> @@ -0,0 +1,91 @@
> +/*
> + * ACPI SOC support for Intel Lynxpoint LPSS and AMD APD.
> + *
> + * Copyright (C) 2015, Intel Corporation & AMD Corporation
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
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/pm.h>
> +
> +/* Flags */
> +#define ACPI_SOC_SYSFS	BIT(0)
> +#define ACPI_SOC_PM		BIT(1)
> +#define ACPI_SOC_PM_ON	BIT(2)
> +
> +struct acpi_soc_dev_private_data;
> +
> +/**
> + * struct acpi_soc - acpi soc 
> + * @list: list head
> + * @ids: all acpi device ids for acpi soc 
> + * @pm_domain: power domain for all acpi device;can be NULL
> + * @attr_group: attribute group for sysfs support of acpi soc;can be
> NULL
> + */
> +struct acpi_soc {
> +	struct list_head list;
> +	struct acpi_device_id	*ids;
> +	struct dev_pm_domain	*pm_domain;
> +	struct attribute_group 	*attr_group;
> +};
> +
> +/**
> + * struct acpi_soc_dev_desc - a descriptor for acpi device 
> + * @flags: some device feature flags
> + * @clk: clock device
> + * @fixed_clk_rate: fixed rate input clock source for acpi device;
> + *				0 means no fixed rate input clock source
> + * @mem_size_override: a workaround for override device memsize;
> + *				0 means no needs for this WA
> + * @setup: a hook routine to set device resource during create platform
> device
> + * @bind: a hook of acpi_scan_handler.bind
> + * @unbind: a hook of acpi_scan_handler.unbind
> + *
> + *device description defined as acpi_device_id.driver_data
> + */
> +struct acpi_soc_dev_desc {
> +	unsigned int flags;
> +	struct clk *clk;
> +	unsigned int fixed_clk_rate;
> +	size_t mem_size_override;
> +	int (*setup)(struct acpi_soc_dev_private_data *pdata);
> +	void (*bind)(struct acpi_soc_dev_private_data *pdata);
> +	void (*unbind)(struct acpi_soc_dev_private_data *pdata);
> +};
> +
> +/**
> + * struct acpi_soc_dev_private_data - acpi device private data
> + * @mmio_base: virtual memory base addr of the device
> + * @mmio_size: device memory size
> + * @dev_desc: device description
> + * @adev: apci device
> + *

Delete the above line.

> + */
> +struct acpi_soc_dev_private_data {
> +	void __iomem *mmio_base;
> +	resource_size_t mmio_size;
> +	
> +	const struct acpi_soc_dev_desc *dev_desc;
> +	struct acpi_device *adev;
> +};
> +
> +/**
> + * register_acpi_soc - register a new acpi soc
> + * @asoc: acpi soc
> + * @disable_scan_handler: true means remove deafult scan handle
> + *					false means use deafult scan handle
> + * 
> + * register a new acpi soc into asoc_list and install deafult scan
> handle.
> + */
> +void register_acpi_soc(struct acpi_soc *asoc, bool
> disable_scan_handler);
> +
> +#endif
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 447f6d6..c8a0e8e 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -68,6 +68,12 @@ static inline void acpi_debugfs_init(void)
> { return; }
>  #endif
>  void acpi_lpss_init(void);
>  
> +#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
> +void acpi_apd_init(void);
> +#else
> +static inline void acpi_apd_init(void) {}
> +#endif
> +
>  acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
>  bool acpi_queue_hotplug_work(struct work_struct *work);
>  void acpi_device_hotplug(struct acpi_device *adev, u32 src);
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 0476e90..24fef2b 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -2349,6 +2349,7 @@ int __init acpi_scan_init(void)
>  	acpi_pci_link_init();
>  	acpi_processor_init();
>  	acpi_lpss_init();
> +	acpi_apd_init();
>  	acpi_cmos_rtc_init();
>  	acpi_container_init();
>  	acpi_memory_hotplug_init();
> -- 
> 1.9.1
> 
