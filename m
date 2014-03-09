Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaCIPuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 11:50:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:27501 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaCIPuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 11:50:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,618,1389772800"; 
   d="scan'208";a="495033230"
Message-ID: <1394380237.9269.31.camel@rzhang1-mobl4>
Subject: Re: [RFC PATCH 6/8] ACPI: use platform bus as the default bus for
 _HID enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Date: Sun, 09 Mar 2014 23:50:37 +0800
In-Reply-To: <1393405874-3266-7-git-send-email-rui.zhang@intel.com>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
	 <1393405874-3266-7-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 17:11 +0800, Zhang Rui wrote:
> Because of the growing demand for enumerating ACPI devices to platform bus,
> this patch changes the code to enumerate ACPI devices with _HID/_CID to
> platform bus by default, unless the device already has a scan handler attached.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/acpi_platform.c |   28 ----------------------------
>  drivers/acpi/scan.c          |   12 ++++++------
>  2 files changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index dbfe49e..33376a9 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -22,24 +22,6 @@
>  
>  ACPI_MODULE_NAME("platform");
>  
> -/*
> - * The following ACPI IDs are known to be suitable for representing as
> - * platform devices.
> - */
> -static const struct acpi_device_id acpi_platform_device_ids[] = {
> -
> -	{ "PNP0D40" },
> -	{ "ACPI0003" },
> -	{ "VPC2004" },
> -	{ "BCM4752" },
> -
> -	/* Intel Smart Sound Technology */
> -	{ "INT33C8" },
> -	{ "80860F28" },
> -
> -	{ }
> -};
> -
>  /**
>   * acpi_create_platform_device - Create platform device for ACPI device node
>   * @adev: ACPI device node to create a platform device for.
> @@ -125,13 +107,3 @@ int acpi_create_platform_device(struct acpi_device *adev,
>  	kfree(resources);
>  	return 1;
>  }
> -
> -static struct acpi_scan_handler platform_handler = {
> -	.ids = acpi_platform_device_ids,
> -	.attach = acpi_create_platform_device,
> -};
> -
> -void __init acpi_platform_init(void)
> -{
> -	acpi_scan_add_handler(&platform_handler);
> -}
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 5967338..61af32e 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -2022,14 +2022,15 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
>  		handler = acpi_scan_match_handler(hwid->id, &devid);
>  		if (handler) {
>  			ret = handler->attach(device, devid);
> -			if (ret > 0) {
> +			if (ret > 0)
>  				device->handler = handler;
> -				break;
> -			} else if (ret < 0) {
> -				break;
> -			}
> +			if (ret)
> +				goto end;
>  		}
>  	}
> +end:
> +	if (!list_empty(&device->pnp.ids) && !device->handler)
> +		acpi_create_platform_device(device, NULL);

I just found a big problem in this proposal, which affects all the
optional scan handlers.
The problem is that, if we disable a scan handler, platform device nodes
would be created instead by the code above, because there is no scan
handler attached for those ACPI nodes.

If we still want to use this proposal, in order to fix the problem, I
think we can
1. add an ACPI device object flag, as Rafael proposed, but with a
different name, say need_enumerate.
2. set the flag for the ACPI device objects with _HID/_CID, and other
specified devices like thermal, video, etc.
3. clear the need_enumerate flag for devices that HAVE MATCHED SCAN
HANDLER, no matter the return value of the .attach() callback.
4. introduce dummy scan handlers instead of stub functions for those
optional scan handlers, say, if CONFIG_X86_INTEL_LPSS is cleared, a
dummy lpss_handler is registered in acpi_lpss_init().
5. invoke acpi_create_platform_device() for the ACPI device objects with
need_enumerate flag set.

thanks,
rui

>  	return ret;
>  }
>  
> @@ -2185,7 +2186,6 @@ int __init acpi_scan_init(void)
>  	acpi_pci_root_init();
>  	acpi_pci_link_init();
>  	acpi_processor_init();
> -	acpi_platform_init();
>  	acpi_lpss_init();
>  	acpi_cmos_rtc_init();
>  	acpi_container_init();


