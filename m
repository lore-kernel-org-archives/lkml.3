Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3K2Cht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:37:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38679 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3K2Chq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:37:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5297FDC7.6000007@jp.fujitsu.com>
Date: Fri, 29 Nov 2013 11:36:55 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 7/10] ACPI / hotplug: Move container-specific code out
 of the core
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <2547688.l8Q1XKb3Ol@vostro.rjw.lan>
In-Reply-To: <2547688.l8Q1XKb3Ol@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Replying to this mail may be wrong.

Do you remember following your patch?
http://lkml.org/lkml/2013/2/23/97

I want to add autoeject variable in acpi_hotplug_profile structure and
set autoecjet of container device "false".

Currently, I have a problem on ejecting container device. Since linux-3.12,
container device is removed by acpi_scan_hot_remove.

I think this has two problems.

   1. easily fail
      My container device has CPU device and Memory device, and maximum size of
      memory is 3Tbyte. In my environment, hot removing container device fails
      on offlining memory if memory is used by application.
      I think if offlininig memory, we must retly to offline memory several
      times.
   2. cannot work with userland's application
      Hot removing CPU and memory on container device, we need take care of
      userland application. Before linux-3.12, container device just notifies
      KOBJ_OFFLINE to udev. So by using udev, if application binds to removed
      CPU or node, applications can change them before hot removing container
      device.
      Currently, KOBJ_OFFLINE is notified to udev. But acpi_scan_hot_remove
      also runs simultaneously for hot removing container device. So when
      applications runs for corresponding to the deletion of the devices,
      the devices may have been deleted.

I don't know what devices are on hotpluggable conatainer device of other
vendors. At least, my container device cannot be hot removed correctly.
Then I want to add autoeject variable in acpi_hotplug_profile so that user
can change the parameter to "true" or "false".

Thanks,
Yasuaki Ishimatsu

(2013/11/18 1:36), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Move container-specific uevents from the core hotplug code to the
> container scan handler's .attach() and .detach() callbacks.
>
> This way the core will not have to special-case containers and
> the uevents will be guaranteed to happen every time a container
> is either scanned or trimmed as appropriate.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/container.c |   11 ++++++++---
>   drivers/acpi/scan.c      |    8 +-------
>   include/acpi/acpi_bus.h  |    7 -------
>   3 files changed, 9 insertions(+), 17 deletions(-)
>
> Index: linux-pm/drivers/acpi/container.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/container.c
> +++ linux-pm/drivers/acpi/container.c
> @@ -44,19 +44,24 @@ static const struct acpi_device_id conta
>   	{"", 0},
>   };
>
> -static int container_device_attach(struct acpi_device *device,
> +static int container_device_attach(struct acpi_device *adev,
>   				   const struct acpi_device_id *not_used)
>   {
> -	/* This is necessary for container hotplug to work. */
> +	kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
>   	return 1;
>   }
>
> +static void container_device_detach(struct acpi_device *adev)
> +{
> +	kobject_uevent(&adev->dev.kobj, KOBJ_OFFLINE);
> +}
> +
>   static struct acpi_scan_handler container_handler = {
>   	.ids = container_device_ids,
>   	.attach = container_device_attach,
> +	.detach = container_device_detach,
>   	.hotplug = {
>   		.enabled = true,
> -		.mode = AHM_CONTAINER,
>   	},
>   };
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -206,9 +206,6 @@ static int acpi_scan_hot_remove(struct a
>   	acpi_status status;
>   	unsigned long long sta;
>
> -	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
> -		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> -
>   	/*
>   	 * Carry out two passes here and ignore errors in the first pass,
>   	 * because if the devices in question are memory blocks and
> @@ -288,10 +285,7 @@ static int acpi_scan_device_check(struct
>   		dev_warn(&adev->dev, "Namespace scan failure\n");
>   		return error;
>   	}
> -	if (adev->handler) {
> -		if (adev->handler->hotplug.mode == AHM_CONTAINER)
> -			kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
> -	} else {
> +	if (!adev->handler) {
>   		dev_warn(&adev->dev, "Enumeration failure\n");
>   		return -ENODEV;
>   	}
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -91,16 +91,9 @@ struct acpi_device;
>    * -----------------
>    */
>
> -enum acpi_hotplug_mode {
> -	AHM_GENERIC = 0,
> -	AHM_CONTAINER,
> -	AHM_COUNT
> -};
> -
>   struct acpi_hotplug_profile {
>   	struct kobject kobj;
>   	bool enabled:1;
> -	enum acpi_hotplug_mode mode;
>   	int (*scan_dependent)(struct acpi_device *adev);
>   };
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


