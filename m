Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3LCNCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:02:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60945 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752830Ab3LCNCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:02:50 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 7/10] ACPI / hotplug: Move container-specific code out of the core
Date: Tue, 03 Dec 2013 14:15:47 +0100
Message-ID: <81535269.SKoBMiGyoU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <529D4600.6040601@jp.fujitsu.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <1554480.uCR6qUxJk9@vostro.rjw.lan> <529D4600.6040601@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 11:46:24 AM Yasuaki Ishimatsu wrote:
> (2013/11/29 22:08), Rafael J. Wysocki wrote:
> > On Friday, November 29, 2013 11:36:55 AM Yasuaki Ishimatsu wrote:
> >> Hi Rafael,
> >
> > Hi,
> >
> >> Replying to this mail may be wrong.
> >
> > OK, so this particular patch doesn't break things any more?
> 
> Yes.
> 
> >
> >> Do you remember following your patch?
> >> http://lkml.org/lkml/2013/2/23/97
> >>
> >> I want to add autoeject variable in acpi_hotplug_profile structure and
> >> set autoecjet of container device "false".
> >
> > Then after the series the $subject patch belongs to it will work almost the
> > same way as /sys/firmware/acpi/container/enabled (hot add will still work after
> > patch [4/10] if "enabled" is 0), but only for containers.
> >
> >> Currently, I have a problem on ejecting container device. Since linux-3.12,
> >> container device is removed by acpi_scan_hot_remove.
> >>
> >> I think this has two problems.
> >>
> >>     1. easily fail
> >>        My container device has CPU device and Memory device, and maximum size of
> >>        memory is 3Tbyte. In my environment, hot removing container device fails
> >>        on offlining memory if memory is used by application.
> >>        I think if offlininig memory, we must retly to offline memory several
> >>        times.
> >
> > Yes, that's correct.  But then you can try to offline the memory upfront
> > and only remove the container after that has been successful.
> >
> >>     2. cannot work with userland's application
> >>        Hot removing CPU and memory on container device, we need take care of
> >>        userland application. Before linux-3.12, container device just notifies
> >>        KOBJ_OFFLINE to udev. So by using udev, if application binds to removed
> >>        CPU or node, applications can change them before hot removing container
> >>        device.
> >>        Currently, KOBJ_OFFLINE is notified to udev. But acpi_scan_hot_remove
> >>        also runs simultaneously for hot removing container device. So when
> >>        applications runs for corresponding to the deletion of the devices,
> >>        the devices may have been deleted.
> >
> 
> > So the expectation is that the container will refuse to offline, but instead
> > it will emit KOBJ_OFFLINE so that user space can do some cleanup and offline
> > it through the "eject" attribute, right?
> 
> Yes, that's right.
> 
> >
> >> I don't know what devices are on hotpluggable conatainer device of other
> >> vendors. At least, my container device cannot be hot removed correctly.
> >> Then I want to add autoeject variable in acpi_hotplug_profile so that user
> >> can change the parameter to "true" or "false".
> >
> > I have a different idea.
> >
> > Why don't we create a bus type for containers in analogy with CPUs and memory
> > and make it support offline.  Then, the container scan handler will create a
> > "physical" container device under that bus type and the new bus type code will
> > implement the logic you need (that is, it will have a sysfs flag that will
> > cause the offline to fail emitting a uevent of some sort if set and will allow
> > the offline to happen when unset).  That "physical" container device will go
> > away (again, via the container scan handler) during container removal.
> >
> 
> > The eject work flow can be:
> >    (1) an eject event occurs,
> >    (2) the container "physical" device fails offline in acpi_scan_hot_remove()
> >        emmitting, say, KOBJ_CHANGE for the "physical" device,
> >    (3) user space notices the KOBJ_CHANGE and does the cleanup as needed,
> >    (4) user space changes the "physical" container device flag controlling
> >        offline to 0,
> >    (5) user space uses the sysfs "eject" attribute of the ACPI container object
> >        to finally eject the container,
> >    (6) the offline in acpi_scan_hot_remove() is now successful, because the
> >        flag controlling it has been set to 0 in step (4),
> >    (7) the "physical" container device goes away before executing _EJ0,
> >    (8) the container is ejected.
> >
> > Of course, if the flag controlling container offline is 0 to start with, step
> > (6) will now occur directly after (1), so whoever wants containers to be
> > hot-removed automatically may just clear that flag for all of them on boot.
> >
> > How does that sound?
> 
> 
> The above ideas are almost O.K. I want kernel to notify user space of KOBJ_OFFLINE.
> Even if user space catches "KOBJ_CHANGE", user doesn't know whether the notification
> is offline or not.

It is easy to figure out, though.  Since the KOBJ_CHANGE will be emitted for
container devices only in that situation, user space can see that (1) it is
from a container and (2) it is KOBJ_CHANGE, so it must mean "container offline
has been attempted".

My concern with using KOBJ_OFFLINE for that is that device_offline() emits it
too on success and it may be easily confused with the one emitted on failure
for containers.

Thanks,
Rafael

