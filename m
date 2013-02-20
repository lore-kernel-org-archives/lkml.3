Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3BTWXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:23:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40463 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3BTWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:23:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 7/7] ACPI / scan: Make memory hotplug driver use struct acpi_scan_handler
Date: Wed, 20 Feb 2013 23:29:58 +0100
Message-ID: <4809314.VZzvuVVOXZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361397012.9542.82.camel@misato.fc.hp.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <20130220104250.GA4409@dhcp-192-168-178-175.profitbricks.localdomain> <1361397012.9542.82.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 02:50:12 PM Toshi Kani wrote:
> On Wed, 2013-02-20 at 11:42 +0100, Vasilis Liaskovitis wrote:
> > Hi Yasuaki,
> > 
> > On Wed, Feb 20, 2013 at 12:35:48PM +0900, Yasuaki Ishimatsu wrote:
> > > Hi Vasilis,
> > > 
> > > 2013/02/20 3:11, Vasilis Liaskovitis wrote:
> > > >Hi,
> > > >
> > > >On Sun, Feb 17, 2013 at 04:27:18PM +0100, Rafael J. Wysocki wrote:
> > > >>From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > >>
> > > >>Make the ACPI memory hotplug driver use struct acpi_scan_handler
> > > >>for representing the object used to set up ACPI memory hotplug
> > > >>functionality and to remove hotplug memory ranges and data
> > > >>structures used by the driver before unregistering ACPI device
> > > >>nodes representing memory.  Register the new struct acpi_scan_handler
> > > >>object with the help of acpi_scan_add_handler_with_hotplug() to allow
> > > >>user space to manipulate the attributes of the memory hotplug
> > > >>profile.
> > > >
> > > >Let's consider an example where we want acpi memory device ejection to be safely
> > > >handled by userspace. We do the following:
> > > >
> > > >echo 0 > /sys/firmware/acpi/hotplug/memory/autoeject
> > > >echo 1 > /sys/firmware/acpi/hotplug/memory/uevents
> > > >
> > > >We succesfully hotplug acpi device:
> > > >/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00
> > > >and its corresponding memblocks /sys/devices/system/memory/memoryXX are
> > > >also successfully onlined.
> > > >
> > > >On an eject request, since uevents == 1, the kernel will emit KOBJ_OFFLINE for:
> > > >/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00
> > > >
> > > >Can userspace know which memblocks in /sys/devices/system/memory/memoryXX/
> > > >correspond to the acpi device /sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00 ?
> > > >This will be needed so that userspace tries to offline the memblocks (and only
> > > >if successful, issue the eject operation on the acpi device). As far as I see,
> > > >we don't create any sysfs links or files for this scenario - can userspace get
> > > >this info somehow?
> > > 
> > > >
> > > >/sys/devices/system/memory/memoryXX/phys_device needs to be properly implemented
> > > >for this to work I think, see Documentation/ABI/testing/sysfs-memory
> > > >
> > > >The following test patch works toward that direction. Let me know if it's of
> > > >interest or if there are better ideas /comments.
> > > 
> > > How about use ../PNP0C80:00/physical_node/resources file?
> > > In my system, the file shows following information.
> > > 
> > > $ cat /sys/bus/acpi/devices/PNP0C80\:00/physical_node/resources
> > > state = active
> > > mem 0x0-0x80000000
> > > mem 0x100000000-0x800000000
> > > 
> > > It means PNP0C80:00's memory ranges are "0x0-0x7fffffff" and
> > > "0x100000000-0x7ffffffff". In x86 architecture, memory section size is
> > > 128MiB. So, if these memory range is divided by 128MiB, you can
> > > calculate memory section number as follow:
> > > 
> > > 0x0-0x7fffffff => 0x0-0x10
> > > 0x100000000-0x7ffffffff => 0x20-0xff
> > > 
> > > But there is one problem. The problem is that resources file of added memory
> > > is not created. If the problem is fixed, I think you can use the way.
> > 
> > thanks for your suggestion. Is this resources file a property of the
> > physical_node or of each acpi devices? 
> > 
> > If it's a node specific file could there be a chance that adjacent memory
> > ranges get merged? We 'd like these to not get merged.
> > 
> > I will look more into this property. I don't see it currently in my system
> > (probably because initial memory is not backed by acpi devices in my
> >  seabios/virtual machine).
> 
> I have been thinking about this issue as well.  In case of CPUs, we have
> a sysdev link that links LNXCPU:%d to its system/cpu/cpu%d file.
> 
> /sys/bus/acpi/devices/LNXCPU:02 > ll sysdev
> lrwxrwxrwx. 1 root root 0 Feb  8 13:52 sysdev -> ../../system/cpu/cpu2
> 
> So, one possible approach is to create a sysdev directory under
> PNP0C080:%d, and then create links to associated system/cpu/memory%d
> files underneath.  What do you think?

I need to think about that a bit more, quite frankly.

I probably would prefer links to be created directly from under PNP0C080:%d
to system/cpu/memory%d (in analogy with PCI and other devices having ACPI
companions).

One of the problems here is that the whole /sys/bus/acpi/ stuff is kind of
confusing, because it makes people think that there's an "ACPI bus", while
there's no such thing.  For this reason, it should go away and the
/sys/devices/LNXSYSTM:00/ directory should be moved somewhere under
/sys/firmware/acpi/.  Of course, that's long-term, but this means I'd prefer
not to add more stuff under /sys/devices/LNXSYSTM:00/ that may potentially
cause that to be more difficult to do in the future.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
