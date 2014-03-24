Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaCXBpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:45:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49797 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750881AbaCXBpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:45:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V4 07/11] ACPI: use platform bus as the default bus for _HID enumeration
Date: Mon, 24 Mar 2014 03:00:56 +0100
Message-ID: <28494711.6ccuzjUcKA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395042580-3344-8-git-send-email-rui.zhang@intel.com>
References: <1395042580-3344-1-git-send-email-rui.zhang@intel.com> <1395042580-3344-8-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 17, 2014 03:49:36 PM Zhang Rui wrote:
> Because of the growing demand for enumerating ACPI devices to platform bus,
> this patch changes the code to enumerate ACPI devices with _HID to
> platform bus by default, unless the device already has a scan handler attached.

I think we need to be more careful here still.

For example, we shouldn't create platform devices for ACPI device objects that
correspond to I2C devices (or any other "simple peripheral bus" devices for that
matter).

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
> index e41b5e6..c0456e7 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -2028,14 +2028,15 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
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
> +	if (device->pnp.type.platform_id && !device->handler)
> +		acpi_create_platform_device(device, NULL);
>  	return ret;
>  }
>  
> @@ -2191,7 +2192,6 @@ int __init acpi_scan_init(void)
>  	acpi_pci_root_init();
>  	acpi_pci_link_init();
>  	acpi_processor_init();
> -	acpi_platform_init();
>  	acpi_lpss_init();
>  	acpi_cmos_rtc_init();
>  	acpi_container_init();
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
