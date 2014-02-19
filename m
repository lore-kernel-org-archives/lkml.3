Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaBSCmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:42:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:45281 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBSCmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:42:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="477418583"
Message-ID: <53041A0C.4040306@intel.com>
Date: Wed, 19 Feb 2014 10:42:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI companions
 of SATA devices
References: <3011875.q18rCmXyYX@vostro.rjw.lan> <1707532.0BItEHDuFB@vostro.rjw.lan>
In-Reply-To: <1707532.0BItEHDuFB@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:30 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify the SATA subsystem to add hotplug contexts to ACPI companions
> of SATA devices and ports instead of registering special ACPI dock
> operations using register_hotplug_dock_device().
> 
> That change will allow the entire code handling those special ACPI
> dock operations to be dropped in the next commit.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/ata/libata-acpi.c |   76 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 49 insertions(+), 27 deletions(-)
> 
> Index: linux-pm/drivers/ata/libata-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/ata/libata-acpi.c
> +++ linux-pm/drivers/ata/libata-acpi.c
> @@ -38,6 +38,16 @@ static void ata_acpi_clear_gtf(struct at
>  	dev->gtf_cache = NULL;
>  }
>  
> +struct ata_acpi_hotplug_context {
> +	struct acpi_hotplug_context hp;
> +	union {
> +		struct ata_port *ap;
> +		struct ata_device *dev;
> +	} data;
> +};
> +
> +#define ata_hotplug_data(context) (container_of((context), struct ata_acpi_hotplug_context, hp)->data)
> +
>  /**
>   * ata_dev_acpi_handle - provide the acpi_handle for an ata_device
>   * @dev: the acpi_handle returned will correspond to this device
> @@ -121,18 +131,17 @@ static void ata_acpi_handle_hotplug(stru
>  		ata_port_wait_eh(ap);
>  }
>  
> -static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
> +static int ata_acpi_dev_notify_dock(struct acpi_device *adev, u32 event)
>  {
> -	struct ata_device *dev = data;
> -
> +	struct ata_device *dev = ata_hotplug_data(adev->hp).dev;
>  	ata_acpi_handle_hotplug(dev->link->ap, dev, event);
> +	return 0;
>  }
>  
> -static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
> +static int ata_acpi_ap_notify_dock(struct acpi_device *adev, u32 event)
>  {
> -	struct ata_port *ap = data;
> -
> -	ata_acpi_handle_hotplug(ap, NULL, event);
> +	ata_acpi_handle_hotplug(ata_hotplug_data(adev->hp).ap, NULL, event);
> +	return 0;
>  }
>  
>  static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
> @@ -154,31 +163,23 @@ static void ata_acpi_uevent(struct ata_p
>  	}
>  }
>  
> -static void ata_acpi_ap_uevent(acpi_handle handle, u32 event, void *data)
> +static void ata_acpi_ap_uevent(struct acpi_device *adev, u32 event)
>  {
> -	ata_acpi_uevent(data, NULL, event);
> +	ata_acpi_uevent(ata_hotplug_data(adev->hp).ap, NULL, event);
>  }
>  
> -static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
> +static void ata_acpi_dev_uevent(struct acpi_device *adev, u32 event)
>  {
> -	struct ata_device *dev = data;
> +	struct ata_device *dev = ata_hotplug_data(adev->hp).dev;
>  	ata_acpi_uevent(dev->link->ap, dev, event);
>  }
>  
> -static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
> -	.handler = ata_acpi_dev_notify_dock,
> -	.uevent = ata_acpi_dev_uevent,
> -};
> -
> -static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
> -	.handler = ata_acpi_ap_notify_dock,
> -	.uevent = ata_acpi_ap_uevent,
> -};
> -
>  /* bind acpi handle to pata port */
>  void ata_acpi_bind_port(struct ata_port *ap)
>  {
>  	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
> +	struct acpi_device *adev;
> +	struct ata_acpi_hotplug_context *context;
>  
>  	if (libata_noacpi || ap->flags & ATA_FLAG_ACPI_SATA || !host_companion)
>  		return;
> @@ -188,9 +189,19 @@ void ata_acpi_bind_port(struct ata_port
>  	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
>  		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
>  
> -	/* we might be on a docking station */
> -	register_hotplug_dock_device(ACPI_HANDLE(&ap->tdev),
> -				     &ata_acpi_ap_dock_ops, ap, NULL, NULL);
> +	adev = ACPI_COMPANION(&ap->tdev);
> +	if (!adev)
> +		return;
> +
> +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context)
> +		return;

The context isn't freed on ATA driver detach, which doesn't normally
happen though.

Thanks,
Aaron
