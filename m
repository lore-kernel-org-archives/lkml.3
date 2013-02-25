Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3BYSY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:24:58 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12645 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3BYSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:24:51 -0500
Message-ID: <1361816039.12845.73.camel@misato.fc.hp.com>
Subject: Re: [PATCH 5/7] ACPI / hotplug: Introduce user space interface for
 hotplug profiles
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Mon, 25 Feb 2013 11:13:59 -0700
In-Reply-To: <5060623.RI4NTzcn19@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <5060623.RI4NTzcn19@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 16:24 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@inel.com>
> 
> Introduce user space interface for manipulating hotplug profiles
> associated with ACPI scan handlers.
> 
> The interface consists of sysfs directories under
> /sys/firmware/acpi/hotplug/, one for each hotplug profile, containing
> attributes allowing user space to manipulate the enabled, uevents,
> and autoeject fields of the corresponding profile.  In particular,
> switching the enabled attribute from 'unset' to 'set' will cause
> the common hotplug notify handler to be installed for all ACPI
> namespace objects representing devices matching the scan handler
> associated with the given hotplug profile (and analogously for the
> converse switch).
> 
> Drivers willing to use the new user space interface should add their
> ACPI scan handlers with the help of new funtion
> acpi_scan_add_handler_with_hotplug().
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@inel.com>
> ---
>  Documentation/ABI/testing/sysfs-firmware-acpi |   42 +++++++++
>  drivers/acpi/internal.h                       |    9 +
>  drivers/acpi/scan.c                           |   73 +++++++++++++++
>  drivers/acpi/sysfs.c                          |  120 ++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h                       |    7 +
>  5 files changed, 251 insertions(+)
 :
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -63,6 +63,19 @@ int acpi_scan_add_handler(struct acpi_sc
>  	return 0;
>  }
>  
> +int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
> +				       const char *hotplug_profile_name)
> +{
> +	int error;
> +
> +	error = acpi_scan_add_handler(handler);
> +	if (error)
> +		return error;
> +
> +	acpi_sysfs_add_hotplug_profile(&handler->hotplug, hotplug_profile_name);
> +	return 0;
> +}
> +
>  /*
>   * Creates hid/cid(s) string needed for modalias and uevent
>   * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
> @@ -1675,6 +1688,66 @@ static bool acpi_scan_handler_matching(s
>  	return false;
>  }
>  
> +static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
> +					    u32 lvl_not_used, void *data,
> +					    void **ret_not_used)
> +{
> +	struct acpi_scan_handler *handler = data;
> +	struct acpi_device_info *info;
> +	bool match = false;
> +
> +	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
> +		return AE_OK;
> +
> +	if (info->valid & ACPI_VALID_HID) {
> +		char *idstr = info->hardware_id.string;
> +		match = acpi_scan_handler_matching(handler, idstr, NULL);
> +	}
> +	kfree(info);
> +	if (!match)
> +		return AE_OK;
> +
> +	if (handler->hotplug.enabled)
> +		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					   acpi_hotplug_notify_cb);
> +	else
> +		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					    acpi_hotplug_notify_cb, NULL);

I found that the action for "enabled" attribute is incorrect.  When
enabled, it should install the notify handler, and remove otherwise.

Thanks,
-Toshi




