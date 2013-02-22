Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3BVMag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:30:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41408 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab3BVMae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:30:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 3][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Fri, 22 Feb 2013 13:37:13 +0100
Message-ID: <1935999.6xb63gvAzk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51273190.7030106@jp.fujitsu.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <11658900.TkhCHmg9LJ@vostro.rjw.lan> <51273190.7030106@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 05:51:28 PM Yasuaki Ishimatsu wrote:
> 2013/02/22 10:50, Rafael J. Wysocki wrote:
> > On Thursday, February 21, 2013 06:12:21 PM Toshi Kani wrote:
> >> On Fri, 2013-02-22 at 00:06 +0100, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>
> >>> Multiple drivers handling hotplug-capable ACPI device nodes install
> >>> notify handlers covering the same types of events in a very similar
> >>> way.  Moreover, those handlers are installed in separate namespace
> >>> walks, although that really should be done during namespace scans
> >>> carried out by acpi_bus_scan().  This leads to substantial code
> >>> duplication, unnecessary overhead and behavior that is hard to
> >>> follow.
> >>>
> >>> For this reason, introduce common code in drivers/acpi/scan.c for
> >>> handling hotplug-related notification and carrying out device
> >>> insertion and eject operations in a generic fashion, such that it
> >>> may be used by all of the relevant drivers in the future.  To cover
> >>> the existing differences between those drivers introduce struct
> >>> acpi_hotplug_profile for representing collections of hotplug
> >>> settings associated with different ACPI scan handlers that can be
> >>> used by the drivers to make the common code reflect their current
> >>> behavior.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> ---
> >>>
> >>> This update fixes an issue pointed out by Toshi Kani (that
> >>> ACPI_OST_EC_OSPM_* event source codes should not be used with _OST for events
> >>> that we received a notification for from the platform firmware).
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>> ---
> >>>   drivers/acpi/scan.c     |  270 ++++++++++++++++++++++++++++++++++++++----------
> >>>   include/acpi/acpi_bus.h |    7 +
> >>>   2 files changed, 224 insertions(+), 53 deletions(-)
> >>   :
> >>> +static void acpi_bus_device_eject(void *context)
> >>> +{
> >>> +	acpi_handle handle = context;
> >>> +	struct acpi_device *device = NULL;
> >>> +	struct acpi_scan_handler *handler;
> >>> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> >>> +
> >>> +	mutex_lock(&acpi_scan_lock);
> >>> +
> >>> +	acpi_bus_get_device(handle, &device);
> >>> +	if (!device)
> >>> +		goto err_out;
> >>> +
> >>> +	handler = device->handler;
> >>> +	if (!handler || !handler->hotplug.enabled) {
> >>> +		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> >>> +		goto err_out;
> >>> +	}
> >>> +	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
> >>> +				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> >>> +	if (handler->hotplug.autoeject) {
> >>> +		int error;
> >>> +
> >>> +		get_device(&device->dev);
> >>> +		error = acpi_scan_hot_remove(device);
> >>> +		if (error)
> >>> +			goto err_out;
> >>> +	} else {
> >>> +		device->flags.eject_pending = true;
> >>>   	}
> >>> +	if (handler->hotplug.uevents)
> >>> +		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> >>
> >> I confirmed that the _OST issue with hot-add is fixed.  Here is a new
> >> one.  When autoeject is enabled, it crashes in kobject_uevent() since
> >> the device is no longer valid.
> >
> > Well, this one is more difficult.
> >
> > I can change the ordering so that kobject_uevent() is called before
> > acpi_scan_hot_remove(), but then user space may not know that the device is
> > being removed at the moment (which still may fail).  Still, maybe this is
> > OK, because user space will get KOBJ_REMOVE when the device actually goes
> > away anyway.
> >
> > Or perhaps we can emit KOBJ_OFFLINE before acpi_scan_hot_remove() and if
> > it fails, emit KOBJ_ONLINE?
> 
> How about following patch? My system cannot send EJECT notification.
> So I have not tested this patch.

No, that's not correct, acpi_scan_hot_remove(device) will remove the device
from sysfs, if successful, among other things.

We can't emit uevents for a device that has been, even though the data
structure is still around.

The following are the choices we have, in my opinion:
- Emit KOBJ_OFFLINE before removal.
- Emit KOBJ_OFFLINE before removal and KOBJ_ONLINE afterwards if it fails.
- Do not emit KOBJ_OFFLINE at all with autoeject.

Each of them has some disadvantages, so I'm not sure.  The last one is the
easiest, so I'll probably send another update implementing it.

Thanks,
Rafael


> # Recently when I send a patch, tabs of the patch is changed to spaces often.
> # So I attached the patch.
> 
> ---
> 
> When hotplug.autoeject and uevents are enabled, it crashes in
> kobject_uevent() since the device is no longer valid.
> 
> This patch fixes the problem.
> 
> Reported-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>   drivers/acpi/scan.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c	2013-02-22 16:02:07.000000000 +0900
> +++ linux-pm/drivers/acpi/scan.c	2013-02-22 16:06:36.792816699 +0900
> @@ -139,9 +139,6 @@ static int acpi_scan_hot_remove(struct a
>   		"Hot-removing device %s...\n", dev_name(&device->dev)));
>   
>   	acpi_bus_trim(device);
> -	/* Device node has been unregistered. */
> -	put_device(&device->dev);
> -	device = NULL;
>   
>   	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &not_used))) {
>   		arg_list.count = 1;
> @@ -191,10 +188,10 @@ static void acpi_bus_device_eject(void *
>   	}
>   	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
>   				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> +	get_device(&device->dev);
>   	if (handler->hotplug.autoeject) {
>   		int error;
>   
> -		get_device(&device->dev);
>   		error = acpi_scan_hot_remove(device);
>   		if (error)
>   			goto err_out;
> @@ -204,6 +201,7 @@ static void acpi_bus_device_eject(void *
>   	if (handler->hotplug.uevents)
>   		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>   
> +	put_device(&device->dev);
>    out:
>   	mutex_unlock(&acpi_scan_lock);
>   	return;
> @@ -312,6 +310,7 @@ void acpi_bus_hot_remove_device(void *co
>   					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
>   					  NULL);
>   
> +	put_device(&acpi_device->dev);
>   	mutex_unlock(&acpi_scan_lock);
>   	kfree(context);
>   }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
