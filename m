Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab3BTKnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:43:00 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45302 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3BTKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:42:55 -0500
Date: Wed, 20 Feb 2013 11:42:50 +0100
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 7/7] ACPI / scan: Make memory hotplug driver use struct
 acpi_scan_handler
Message-ID: <20130220104250.GA4409@dhcp-192-168-178-175.profitbricks.localdomain>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
 <2200731.3okUfey51A@vostro.rjw.lan>
 <20130219181157.GA4366@dhcp-192-168-178-175.profitbricks.localdomain>
 <51244494.4000603@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51244494.4000603@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yasuaki,

On Wed, Feb 20, 2013 at 12:35:48PM +0900, Yasuaki Ishimatsu wrote:
> Hi Vasilis,
> 
> 2013/02/20 3:11, Vasilis Liaskovitis wrote:
> >Hi,
> >
> >On Sun, Feb 17, 2013 at 04:27:18PM +0100, Rafael J. Wysocki wrote:
> >>From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >>Make the ACPI memory hotplug driver use struct acpi_scan_handler
> >>for representing the object used to set up ACPI memory hotplug
> >>functionality and to remove hotplug memory ranges and data
> >>structures used by the driver before unregistering ACPI device
> >>nodes representing memory.  Register the new struct acpi_scan_handler
> >>object with the help of acpi_scan_add_handler_with_hotplug() to allow
> >>user space to manipulate the attributes of the memory hotplug
> >>profile.
> >
> >Let's consider an example where we want acpi memory device ejection to be safely
> >handled by userspace. We do the following:
> >
> >echo 0 > /sys/firmware/acpi/hotplug/memory/autoeject
> >echo 1 > /sys/firmware/acpi/hotplug/memory/uevents
> >
> >We succesfully hotplug acpi device:
> >/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00
> >and its corresponding memblocks /sys/devices/system/memory/memoryXX are
> >also successfully onlined.
> >
> >On an eject request, since uevents == 1, the kernel will emit KOBJ_OFFLINE for:
> >/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00
> >
> >Can userspace know which memblocks in /sys/devices/system/memory/memoryXX/
> >correspond to the acpi device /sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00 ?
> >This will be needed so that userspace tries to offline the memblocks (and only
> >if successful, issue the eject operation on the acpi device). As far as I see,
> >we don't create any sysfs links or files for this scenario - can userspace get
> >this info somehow?
> 
> >
> >/sys/devices/system/memory/memoryXX/phys_device needs to be properly implemented
> >for this to work I think, see Documentation/ABI/testing/sysfs-memory
> >
> >The following test patch works toward that direction. Let me know if it's of
> >interest or if there are better ideas /comments.
> 
> How about use ../PNP0C80:00/physical_node/resources file?
> In my system, the file shows following information.
> 
> $ cat /sys/bus/acpi/devices/PNP0C80\:00/physical_node/resources
> state = active
> mem 0x0-0x80000000
> mem 0x100000000-0x800000000
> 
> It means PNP0C80:00's memory ranges are "0x0-0x7fffffff" and
> "0x100000000-0x7ffffffff". In x86 architecture, memory section size is
> 128MiB. So, if these memory range is divided by 128MiB, you can
> calculate memory section number as follow:
> 
> 0x0-0x7fffffff => 0x0-0x10
> 0x100000000-0x7ffffffff => 0x20-0xff
> 
> But there is one problem. The problem is that resources file of added memory
> is not created. If the problem is fixed, I think you can use the way.

thanks for your suggestion. Is this resources file a property of the
physical_node or of each acpi devices? 

If it's a node specific file could there be a chance that adjacent memory
ranges get merged? We 'd like these to not get merged.

I will look more into this property. I don't see it currently in my system
(probably because initial memory is not backed by acpi devices in my
 seabios/virtual machine).

> 
[...] 
> >+int acpi_memory_phys_device(unsigned long start_pfn)
> >+{
> >+	struct acpi_memory_device *mem_dev;
> >+	struct acpi_memory_info *info;
> >+	unsigned long start_addr = start_pfn << PAGE_SHIFT;
> >+	int id = 0;
> >+
> >+	list_for_each_entry(mem_dev, &acpi_mem_device_list, mem_device_list) {
> >+		list_for_each_entry(info, &mem_dev->res_list, list) {
> >+			if ((info->start_addr <= start_addr) &&
> >+				(info->start_addr + info->length > start_addr))
> >+				return id;
> >+		}
> >+		id++;
> >+	}
> 
> I don't think this solve your problem.
> 
> When hot adding memory device in my system, consecutive index number is
> applied to PNP0C80 as follows:
> 
> $ ls /sys/bus/acpi/devices/ |grep PNP0C80
> PNP0C80:00
> PNP0C80:01  => hot added memory device
> PNP0C80:02  => hot added memory device
> 
> In this case, we can know PNP0C80:YY by memoryXX/phys_device file.
> But if hot removing and adding the same device, index number is changed
> as follows:
> 
> $ ls /sys/bus/acpi/devices/
> PNP0C80:00
> PNP0C80:03  => hot added memory device
> PNP0C80:04  => hot added memory device
> 
> In this case, we cannot know PNP0C80:YY by memoryXX/phys_device file.
>

thanks, yes you are right. I forgot each new hotplug event will create a new
PNP0C80:XX device where XX always increases. So the hot-add/hot-remove/hot-add
scenario would have a problem.
Then it would be enough to be able to return this monotonically increasing
counter from phys_device instead of the current list iterator. Is this counter
available somehwere in drivers/acpi/scan.c or bus.c? I 'll take a look.

thanks,

- Vasilis
