Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3BZDE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:04:26 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44580 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3BZDEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:04:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Tue, 26 Feb 2013 04:11:07 +0100
Message-ID: <1776709.RhhH5Yin4x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <512C17D0.8080102@jp.fujitsu.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <1361840942.12845.84.camel@misato.fc.hp.com> <512C17D0.8080102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 26, 2013 11:02:56 AM Yasuaki Ishimatsu wrote:
> 2013/02/26 10:09, Toshi Kani wrote:
> > On Tue, 2013-02-26 at 09:40 +0900, Yasuaki Ishimatsu wrote:
> >> 2013/02/26 8:39, Rafael J. Wysocki wrote:
> >>> On Monday, February 25, 2013 11:07:52 AM Toshi Kani wrote:
> >>>> On Sat, 2013-02-23 at 22:38 +0000, Rafael J. Wysocki wrote:
> >>>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>>>
> >>>>> Multiple drivers handling hotplug-capable ACPI device nodes install
> >>>>> notify handlers covering the same types of events in a very similar
> >>>>> way.  Moreover, those handlers are installed in separate namespace
> >>>>> walks, although that really should be done during namespace scans
> >>>>> carried out by acpi_bus_scan().  This leads to substantial code
> >>>>> duplication, unnecessary overhead and behavior that is hard to
> >>>>> follow.
> >>>>>
> >>>>> For this reason, introduce common code in drivers/acpi/scan.c for
> >>>>> handling hotplug-related notification and carrying out device
> >>>>> insertion and eject operations in a generic fashion, such that it
> >>>>> may be used by all of the relevant drivers in the future.  To cover
> >>>>> the existing differences between those drivers introduce struct
> >>>>> acpi_hotplug_profile for representing collections of hotplug
> >>>>> settings associated with different ACPI scan handlers that can be
> >>>>> used by the drivers to make the common code reflect their current
> >>>>> behavior.
> >>>>>
> >>>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>>> ---
> >>>>>
> >>>>> This update causes acpi_bus_device_eject() to only emit KOBJ_OFFLINE uevent if
> >>>>> autoexec is unset for the given scan handler.
> >>>>>
> >>>>> This will require the doc in patch [5/7] to be updated which I'm going to do if
> >>>>> everyone is OK with the $subject patch.
> >>>>>
> >>>>> Thanks,
> >>>>> Rafael
> >>>>    :
> >>>>> +
> >>>>> +static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
> >>>>> +{
> >>>>> +	struct acpi_device *device = NULL;
> >>>>> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> >>>>> +	int error;
> >>>>> +
> >>>>> +	mutex_lock(&acpi_scan_lock);
> >>>>> +
> >>>>> +	acpi_bus_get_device(handle, &device);
> >>>>> +	if (device) {
> >>>>> +		dev_warn(&device->dev, "Attempt to re-insert\n");
> >>>>> +		goto out;
> >>>>> +	}
> >>>>> +	acpi_evaluate_hotplug_ost(handle, ost_source,
> >>>>> +				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
> >>>>> +	error = acpi_bus_scan(handle);
> >>>>> +	if (error) {
> >>>>> +		acpi_handle_warn(handle, "Namespace scan failure\n");
> >>>>> +		goto out;
> >>>>> +	}
> >>>>> +	error = acpi_bus_get_device(handle, &device);
> >>>>> +	if (error) {
> >>>>> +		acpi_handle_warn(handle, "Missing device node object\n");
> >>>>> +		goto out;
> >>>>> +	}
> >>>>> +	ost_code = ACPI_OST_SC_SUCCESS;
> >>>>> +	if (device->handler && device->handler->hotplug.uevents)
> >>>>> +		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
> >>>>
> >>
> >>>> I confirmed that the uevent crash issue was solved.  Thinking further, I
> >>>> wonder if we need to emit KOBJ_ONLINE here.  This behavior is asymmetric
> >>>> since we do not emit KOBJ_OFFLINE when autoeject is set.
> >>>
> >>> Well, I put that in there only to be able to make the container driver behave
> >>> in a backwards compatible way (which is to emit KOBJ_ONLINE at this point).
> >>>
> >>> If the container driver doesn't need to emit KOBJ_ONLINE at all, I agree with
> >>> your suggestion.
> >>>
> >>>> The definition of ONLINE/OFFLINE event to an ACPI device object seems also
> >>>> bogus since there is no online/offline operation to the ACPI device object
> >>>> itself.
> >>>> Online/offline operation is only possible to actual device, such as
> >>>> system/cpu/cpu% and system/memory/memory%.
> >>>
> >>> That's correct, but I don't know what the user space expectations are
> >>> currently.
> >>
> >> My system expects this event to be notified when hot adding container device.
> >> My container device has cpu and memory. As Toshi said, these devices are
> >> offline when hot adding container device. So in my system, when notifying
> >> container device's KOBJ_ONLINE event, my application runs for onlining these
> >> devices. If this event is not notified to user land, we cannot online these
> >> devices  automatically.
> >
> 
> > Thanks for the info.  Can your application listen KOBJ_ADD to a
> > container device, instead of KOBJ_ONLINE?  IOW, does it distinguish
> > between ADD and ONLINE events to a container device?
> 
> My application does not distinguish between ADD and ONLINE events
> currently. But if the event is changed from ONLINE to ADD, I will
> change my application.

KOBJ_ADD is emitted for every struct acpi_device being registered, including
container devices, by acpi_device_add_finalize().  Can your application listen
to those events?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
