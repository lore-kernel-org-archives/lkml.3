Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3AWTz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:55:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3AWTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:55:52 -0500
Date: Wed, 23 Jan 2013 14:55:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH V1 1/3] Xen stub driver for CPU hotplug
Message-ID: <20130123195530.GB18022@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C3DB4@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353C3DB4@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:30:19PM +0000, Liu, Jinsong wrote:
> >From 110b4ef3b8ebefeaf68832dd8ef8aa916a782e89 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Mon, 14 Jan 2013 15:19:30 +0800
> Subject: [PATCH 1/3] Xen stub driver for CPU hotplug
> 
> Add Xen stub driver for CPU hotplug, early occupy to block native,
> will be replaced later by real Xen processor driver module.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/xen-stub.c |   34 ++++++++++++++++++++++++++++++++--
>  include/xen/acpi.h     |    6 ++++++
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
> index 01a49e3..681e9cc 100644
> --- a/drivers/xen/xen-stub.c
> +++ b/drivers/xen/xen-stub.c
> @@ -28,12 +28,13 @@
>  #include <acpi/acpi_drivers.h>
>  #include <xen/acpi.h>
>  
> +
> +#ifdef CONFIG_ACPI
> +
>  /*--------------------------------------------
>  	stub driver for Xen memory hotplug
>  --------------------------------------------*/
>  
> -#ifdef CONFIG_ACPI
> -
>  static const struct acpi_device_id memory_device_ids[] = {
>  	{ACPI_MEMORY_DEVICE_HID, 0},
>  	{"", 0},
> @@ -57,4 +58,33 @@ static int __init xen_stub_memory_device_init(void)
>  }
>  subsys_initcall(xen_stub_memory_device_init);
>  
> +
> +/*--------------------------------------------
> +	stub driver for Xen cpu hotplug
> +--------------------------------------------*/
> +
> +static const struct acpi_device_id processor_device_ids[] = {
> +	{ACPI_PROCESSOR_OBJECT_HID, 0},
> +	{ACPI_PROCESSOR_DEVICE_HID, 0},
> +	{"", 0},
> +};
> +
> +struct acpi_driver xen_stub_processor_driver = {
> +	/* same name as native processor driver to block native loaded */
> +	.name = "processor",
> +	.class = ACPI_PROCESSOR_CLASS,
> +	.ids = processor_device_ids,
> +};
> +EXPORT_SYMBOL_GPL(xen_stub_processor_driver);

Could you make this be

xen_stub_processor_deinit() instead?

> +
> +static int __init xen_stub_processor_init(void)
> +{
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	/* just reserve space for Xen, block native driver loaded */
> +	return acpi_bus_register_driver(&xen_stub_processor_driver);
> +}
> +subsys_initcall(xen_stub_processor_init);
> +
>  #endif
> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
> index 7366e58..1c99eb5 100644
> --- a/include/xen/acpi.h
> +++ b/include/xen/acpi.h
> @@ -46,6 +46,12 @@
>  
>  extern struct acpi_driver xen_stub_memory_device_driver;
>  
> +#define ACPI_PROCESSOR_CLASS            "processor"
> +#define ACPI_PROCESSOR_DEVICE_HID       "ACPI0007"
> +#define ACPI_PROCESSOR_DEVICE_NAME      "Processor"
> +
> +extern struct acpi_driver xen_stub_processor_driver;
> +
>  int xen_acpi_notify_hypervisor_state(u8 sleep_state,
>  				     u32 pm1a_cnt, u32 pm1b_cnd);
>  
> -- 
> 1.7.1


