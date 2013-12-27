Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3L0ARg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:17:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55302 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229Ab3L0ARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:17:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 7/10] ACPI / hotplug: Move container-specific code out of the core
Date: Fri, 27 Dec 2013 01:31:04 +0100
Message-ID: <5565848.5Mh101vWBj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52BB9A16.8070303@jp.fujitsu.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <3387576.nauxTXi2KU@vostro.rjw.lan> <52BB9A16.8070303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 26, 2013 11:53:10 AM Yasuaki Ishimatsu wrote:
> HI Rafael,
> 
> (2013/12/26 10:01), Rafael J. Wysocki wrote:
> > On Monday, December 23, 2013 02:58:38 PM Rafael J. Wysocki wrote:
> >> On Saturday, December 14, 2013 06:07:06 AM Rafael J. Wysocki wrote:
> >>> On Friday, December 13, 2013 02:17:32 PM Yasuaki Ishimatsu wrote:
> >>>> (2013/12/13 13:56), Rafael J. Wysocki wrote:
> >>>>> On Friday, December 13, 2013 11:56:32 AM Yasuaki Ishimatsu wrote:
> >>>>>> Hi Rafael,
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>>> Please share your more detailed idea. I started to implement the following
> >>>>>> idea. But the idea has one problem.
> >>>>>>
> >>>>>>>>> The eject work flow can be:
> >>>>>>>>>       (1) an eject event occurs,
> >>>>>>>>>       (2) the container "physical" device fails offline in acpi_scan_hot_remove()
> >>>>>>>>>           emmitting, say, KOBJ_CHANGE for the "physical" device,
> >>>>>>>>>       (3) user space notices the KOBJ_CHANGE and does the cleanup as needed,
> >>>>>>>>>       (4) user space changes the "physical" container device flag controlling
> >>>>>>>>>           offline to 0,
> >>>>>>>>>       (5) user space uses the sysfs "eject" attribute of the ACPI container object
> >>>>>>>>>           to finally eject the container,
> >>>>>>>>>       (6) the offline in acpi_scan_hot_remove() is now successful, because the
> >>>>>>>>>           flag controlling it has been set to 0 in step (4),
> >>>>>>>>>       (7) the "physical" container device goes away before executing _EJ0,
> >>>>>>>>>       (8) the container is ejected.
> >>>>>>
> >>>>>> I want to emit KOBJ_CHANGE before offlining devices on container device at (2).
> >>>>>> But acpi_scan_hot_remove() offlines devices on container device at first.
> >>>>>> So when offline container device, devices on container has been offlined.
> >>>>>>
> >>>>>> Thus the idea cannot fulfill my necessary feature.
> >>>>>
> >>>>> Well, in that case we need to treat containers in a special way at the ACPI
> >>>>> level.  Which is a bit unfortunate so to speak.
> >>>>>
> >>>>> To that end I'd try to add a new flag to struct acpi_hotplug_profile, say
> >>>>> .verify_offline, such that if set, it would cause acpi_scan_hot_remove() to
> >>>>> check if all of the "physical" companions of the top-level device are offline
> >>>>> to start with, and if not, it would just emit KOBJ_CHANGE for the companions
> >>>>> that are not offline and bail out.
> >>>>>
> >>>>> So the above algorithm would become:
> >>>>>
> >>>>> (1) an eject event occurs,
> >>>>> (2) acpi_scan_hot_remove() checks the verify_offline flag in the target device's
> >>>>>       scan_handler structure,
> >>>>> (3) if set (it would always be set for containers), acpi_scan_hot_remove()
> >>>>>       checks the status of the target device's "physical" companions; if at least
> >>>>>       one of them is offline, KOBJ_CHANGE is emitted for that "physical" device,
> >>>>>       and acpi_scan_hot_remove() returns, [I guess we can just emit KOBJ_CHANGE
> >>>>>       for the first companion that is not offline at this point.]
> >>>>> (4) user space notices the KOBJ_CHANGE and does the cleanup as needed; in the
> >>>>>       process it carries out the offline operation for the container's "physical"
> >>>>>       companion (there's only one such companion for each container), [That
> >>>>>       operation for the container itself is trivial, but to succeed it requires
> >>>>>       all devices below the container to be taken offline in advance.]
> >>>>> (5) user space uses the sysfs "eject" attribute of the ACPI container object
> >>>>>       to finally eject the container,
> >>>>> (6) acpi_scan_hot_remove() is now successful, because the container's "physical"
> >>>>>       companion is now offline,
> >>>>> (7) the "physical" container device goes away before executing _EJ0,
> >>>>> (8) the container is ejected.
> >>>>>
> >>>>> I think that should work for you.
> >>>>
> >>>> This idea seems to same as your previous work.
> >>>> http://lkml.org/lkml/2013/2/23/97
> >>>
> >>> No, it is not.  That one didn't involve physical device representations.
> >>>
> >>>> How about add autoremove flag into acpi_hotplug_profile and check it as follow:
> >>>
> >>> This is very similar to "enable" except that it generates the uevent and
> >>> "enable" doesn't.  You might as well modify "enable" to trigger a uevent if
> >>> eject is not enabled (note that with the latest patches in linux-next "enable"
> >>> only applies to eject).
> >>>
> >>> That said I don't think we should generate any uevents for struct acpi_device
> >>> objects, because they are not devices.
> >>>
> >>>> ---
> >>>>    drivers/acpi/scan.c | 5 +++++
> >>>>    1 file changed, 5 insertions(+)
> >>>>
> >>>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >>>> index 5383c81..c43d110 100644
> >>>> --- a/drivers/acpi/scan.c
> >>>> +++ b/drivers/acpi/scan.c
> >>>> @@ -409,6 +409,11 @@ static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
> >>>>    			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> >>>>    			goto err_out;
> >>>>    		}
> >>>> +		if (!handler->hotplug.autoremove) {
> >>>> +			kobject_uevent(&device->dev.kobj, KOBJ_CHANGE);
> >>>> +			ost_code = ACPI_OST_SC_EJECT_NON_SPECIFIC_FAILURE;
> >>>> +			goto err_out;
> >>>> +		}
> >>>>    		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
> >>>>    					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> >>>>    		break;
> >>>>
> >>>> Adding the check into "acpi_hotplug_notify_cb()", user need not change the
> >>>> flag for removing container device by "sysfs eject".
> >>>
> >>> Which is utterly confusing.  There is no reason whatsoever why the sysfs eject
> >>> attribute should work differently from the event-triggered eject.  Quite the
> >>> opposite is the case: it should work in the same way in my opinion so that it
> >>> is possible to test the eject code path using that attribute.
> >>>
> >>> I'm traveling now, but when I get back home (next week), I'll try to implement
> >>> the thing I was talking about above.
> >>
> >> It took some more time than I had expected, but I finally was able to get to that.
> >>
> >> The following two patches implement the idea.  This is the minimum (in my opinion)
> >> implementation and it may be extended in some ways.
> >>
> >> Patch [1/2] introduces a new demand_offline flag for struct acpi_hotplug_profile
> >> that makes acpi_scan_hot_remove() check the offline status of the device object's
> >> companion physical devices to start with and return -EBUSY if at least one of them
> >> is not offline.
> >>
> >> Patch [2/2] uses that flag to implement the container handling.  The details are
> >> in the changelog, but that's how it is supposed to work.
> >>
> >> During the initial namespace scan the container ACPI scan handler should create
> >> "physical" system container device under /sys/devices/system/container/ for
> >> each ACPI container object (the sysfs name of that device should be the same as
> >> the sysfs name of the corresponding container object and they should be linked
> >> to each other via the firmware_node and physical_node symbolic links, respectively).
> >> Those system container devices are initially online.
> >>
> >> When a container eject event happens, acpi_scan_hot_remove() will notice that
> >> hotplug.demand_offline is set in the device object's scan handler and will
> >> check the online status of its "physical" companion device, which is online
> >> (that is the system container device the above paragraph is about).  That will
> >> cause KOBJ_CHANGE to be emitted for the system container device and -EBUSY to
> >> be returned by acpi_scan_hot_remove().
> >>
> >> Now, user space needs to offline the system container device through its online
> >> sysfs attribute (that should be present, because the bus type for containers
> >> provides the online and offline callbacks).  However, the offline for system
> >> container devices will only succeed if the physical devices right below the
> >> container are all offline, so user space will have to offline those devices
> >> before attempting to offline the system container device itself.  When
> >> finished, user space can trigger the container removal with the help of the
> >> eject sysfs attribute of the ACPI container object pointed to by the system
> >> container device's firmware_node link (this time the check in
> >> acpi_scan_hot_remove() will succeed, because the system container device in
> >> question is now offline).
> >>
> >> The way it is implemented is a bit hackish (the driver_data pointer is slightly
> >> abused), but that's a special case and I wanted to avoid adding new fields to
> >> struct device just for handling it.
> >>
> >> The patches haven't been tested yet.  I'm going to do that later today, but
> >> first I need to take care of some other things, so that has to wait.
> >
> 
> Thank you for implementing your idea.

You're very welcome! :-)

> > The series of the two patches:
> >
> > [1/2] ACPI / hotplug: Add demand_offline hotplug profile flag
> > 	https://patchwork.kernel.org/patch/3396711/
> >
> > [2/2] ACPI / hotplug / driver core: Handle containers in a special way
> > 	https://patchwork.kernel.org/patch/3399081/
> >
> > has been tested now and seems to work as expected, at least for a container
> > that has no children (that's one I could simulate easily in a meaningful way).
> >
> > For this reason, if there are no objections, I'll resend them as an official
> > submission during the next couple of days.
> 
> I'm testing these patches now. If I have a comment, I send it to these
> threads.

Thanks a lot!

Rafael

