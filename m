Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3AWTzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:55:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3AWTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:55:07 -0500
Date: Wed, 23 Jan 2013 14:54:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH V3 1/2] Xen stub driver for memory hotplug
Message-ID: <20130123195455.GA18022@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C24AD@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353C24AD@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 06:09:07AM +0000, Liu, Jinsong wrote:
> >From 008ab02becba5ca94fddd6ce9be27b9877a6c55e Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Tue, 8 Jan 2013 11:15:14 +0800
> Subject: [PATCH 1/2] Xen stub driver for memory hotplug
> 
> This patch create a file (xen-stub.c) for Xen stub drivers.
> Xen stub drivers are used to reserve space for Xen drivers, i.e.
> memory hotplug and cpu hotplug, and to block native drivers loaded,
> so that real Xen drivers can be modular and loaded on demand.
> 
> This patch is specific for Xen memory hotplug (other Xen logic
> can add stub drivers on their own). The xen stub driver will
> occupied earlier via subsys_initcall (than native memory hotplug
> driver via module_init and so blocking native). Later real Xen
> memory hotplug logic will unregister the stub driver and register
> itself to take effect on demand.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/Kconfig    |   11 ++++++++
>  drivers/xen/Makefile   |    1 +
>  drivers/xen/xen-stub.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/acpi.h     |    6 ++++
>  4 files changed, 78 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xen-stub.c
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index cabfa97..1dcb5fc 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -180,6 +180,17 @@ config XEN_PRIVCMD
>  	depends on XEN
>  	default m
>  
> +config XEN_STUB
> +	bool "Xen stub drivers"
> +	depends on XEN_DOM0 && X86_64
> +	default n
> +	help
> +	  Allow kernel to install stub drivers, to reserve space for Xen drivers,
> +	  i.e. memory hotplug and cpu hotplug, and to block native drivers loaded,
> +	  so that real Xen drivers can be modular.
> +
> +	  To enable Xen features like cpu and memory hotplug, select Y here.
> +
>  config XEN_ACPI_PROCESSOR
>  	tristate "Xen ACPI processor"
>  	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index fb213cf..b63edd8 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
>  obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
> +obj-$(CONFIG_XEN_STUB)			+= xen-stub.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
>  xen-evtchn-y				:= evtchn.o
>  xen-gntdev-y				:= gntdev.o
> diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
> new file mode 100644
> index 0000000..01a49e3
> --- /dev/null
> +++ b/drivers/xen/xen-stub.c
> @@ -0,0 +1,60 @@
> +/*
> + * xen-stub.c - stub drivers to reserve space for Xen
> + *
> + * Copyright (C) 2012 Intel Corporation
> + *    Author: Liu Jinsong <jinsong.liu@intel.com>
> + *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
> + *
> + * Copyright (C) 2012 Oracle Inc
> + *    Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
> +#include <linux/init.h>
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/acpi.h>
> +#include <acpi/acpi_drivers.h>
> +#include <xen/acpi.h>
> +
> +/*--------------------------------------------
> +	stub driver for Xen memory hotplug
> +--------------------------------------------*/
> +
> +#ifdef CONFIG_ACPI
> +
> +static const struct acpi_device_id memory_device_ids[] = {
> +	{ACPI_MEMORY_DEVICE_HID, 0},
> +	{"", 0},
> +};
> +
> +struct acpi_driver xen_stub_memory_device_driver = {
> +	/* same name as native memory driver to block native loaded */
> +	.name = "acpi_memhotplug",
> +	.class = ACPI_MEMORY_DEVICE_CLASS,
> +	.ids = memory_device_ids,
> +};
> +EXPORT_SYMBOL_GPL(xen_stub_memory_device_driver);

Instead of having this, could you have a function that would unregister
this if required.

xen_stub_memory_device_uninit(void)

which would unregister the above mentioned structure?

> +
> +static int __init xen_stub_memory_device_init(void)
> +{
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	/* just reserve space for Xen, block native driver loaded */
> +	return acpi_bus_register_driver(&xen_stub_memory_device_driver);
> +}
> +subsys_initcall(xen_stub_memory_device_init);
> +
> +#endif
> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
> index 48a9c01..7366e58 100644
> --- a/include/xen/acpi.h
> +++ b/include/xen/acpi.h
> @@ -40,6 +40,12 @@
>  #include <xen/xen.h>
>  #include <linux/acpi.h>
>  
> +#define ACPI_MEMORY_DEVICE_CLASS        "memory"
> +#define ACPI_MEMORY_DEVICE_HID          "PNP0C80"
> +#define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
> +
> +extern struct acpi_driver xen_stub_memory_device_driver;
> +
>  int xen_acpi_notify_hypervisor_state(u8 sleep_state,
>  				     u32 pm1a_cnt, u32 pm1b_cnd);
>  
> -- 
> 1.7.1


