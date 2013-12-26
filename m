Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3LZDKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 22:10:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35763 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZDKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 22:10:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52BB9E0C.8020102@jp.fujitsu.com>
Date: Thu, 26 Dec 2013 12:10:04 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2][Untested] ACPI / hotplug: Add demand_offline hotplug
 profile flag
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <3111545.W6MaeKuZVj@vostro.rjw.lan> <2519855.bi7YQLIAPv@vostro.rjw.lan> <2003756.4bDvk8cJ93@vostro.rjw.lan>
In-Reply-To: <2003756.4bDvk8cJ93@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 23:00), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Add a new ACPI hotplug profile flag, demand_offline, such that if
> set for the given ACPI device object's scan handler, it will cause
> acpi_scan_hot_remove() to check if that device object's physical
> companions are offline upfront and fail the hot removal if that
> is not the case.
>
> That flag will be useful to overcome a problem with containers on
> some system where they can only be hot-removed after some cleanup
> operations carried out by user space, which needs to be notified
> of the container hot-removal before the kernel attempts to offline
> devices in the container.  In those cases the current implementation
> of acpi_scan_hot_remove() is not sufficient, because it first tries
> to offline the devices in the container and only if that is
> suffcessful it tries to offline the container itself.  As a result,
> the container hot-removal notification is not delivered to user space
> at the right time.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/scan.c     |   41 +++++++++++++++++++++++++++++++++++++----
>   include/acpi/acpi_bus.h |    3 ++-
>   2 files changed, 39 insertions(+), 5 deletions(-)
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -126,6 +126,24 @@ acpi_device_modalias_show(struct device
>   }
>   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>
> +static bool acpi_scan_is_offline(struct acpi_device *adev)
> +{
> +	struct acpi_device_physical_node *pn;
> +	bool offline = true;
> +
> +	mutex_lock(&adev->physical_node_lock);
> +
> +	list_for_each_entry(pn, &adev->physical_node_list, node)

> +		if (!pn->dev->offline) {

Please check pn->dev->bus and pn->dev->bus->offline too as follow:

		if (pn->dev->bus && pn->dev->bus->offline &&
		    !pn->dev->offline) {

My container has CPU and Memory and PCI root bridge. PCI root bridge
does not has offline function (pn->dev->bus->offline). So I cannot offline
the device and pn->dev->offline of the device is always 0. Therefore,
following operation always returns -EBUSY even if I offline CPUs and
all memory sections on a container device.

echo 0 > /sys/bus/container/devices/ACPI0004:01/online

Thanks,
Yasuaki Ishimatsu

> +			kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
> +			offline = false;
> +			break;
> +		}
> +
> +	mutex_unlock(&adev->physical_node_lock);
> +	return offline;
> +}
> +
>   static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
>   				    void **ret_p)
>   {
> @@ -196,12 +214,11 @@ static acpi_status acpi_bus_online(acpi_
>   	return AE_OK;
>   }
>
> -static int acpi_scan_hot_remove(struct acpi_device *device)
> +static int acpi_scan_try_to_offline(struct acpi_device *device)
>   {
>   	acpi_handle handle = device->handle;
> -	struct device *errdev;
> +	struct device *errdev = NULL;
>   	acpi_status status;
> -	unsigned long long sta;
>
>   	/*
>   	 * Carry out two passes here and ignore errors in the first pass,
> @@ -212,7 +229,6 @@ static int acpi_scan_hot_remove(struct a
>   	 *
>   	 * If the first pass is successful, the second one isn't needed, though.
>   	 */
> -	errdev = NULL;
>   	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
>   				     NULL, acpi_bus_offline, (void *)false,
>   				     (void **)&errdev);
> @@ -241,6 +257,23 @@ static int acpi_scan_hot_remove(struct a
>   			return -EBUSY;
>   		}
>   	}
> +	return 0;
> +}
> +
> +static int acpi_scan_hot_remove(struct acpi_device *device)
> +{
> +	acpi_handle handle = device->handle;
> +	unsigned long long sta;
> +	acpi_status status;
> +
> +	if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
> +		if (!acpi_scan_is_offline(device))
> +			return -EBUSY;
> +	} else {
> +		int error = acpi_scan_try_to_offline(device);
> +		if (error)
> +			return error;
> +	}
>
>   	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>   		"Hot-removing device %s...\n", dev_name(&device->dev)));
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -91,8 +91,9 @@ struct acpi_device;
>
>   struct acpi_hotplug_profile {
>   	struct kobject kobj;
> -	bool enabled:1;
>   	int (*scan_dependent)(struct acpi_device *adev);
> +	bool enabled:1;
> +	bool demand_offline:1;
>   };
>
>   static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
>


