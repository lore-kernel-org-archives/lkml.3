Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaCBXgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:36:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64579 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511AbaCBXgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:36:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [RFC PATCH 6/8] ACPI: use platform bus as the default bus for _HID enumeration
Date: Mon, 03 Mar 2014 00:51:15 +0100
Message-ID: <22144944.rXupLb1rjo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393405874-3266-7-git-send-email-rui.zhang@intel.com>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com> <1393405874-3266-7-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 05:11:12 PM Zhang Rui wrote:
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

I'm a bit concerned that this check will create platform devices for too many
ACPI device objects.  Shouldn't we require that _HID or at least _CID is
present for that?

> +		acpi_create_platform_device(device, NULL);
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
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
