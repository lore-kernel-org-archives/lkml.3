Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3CZWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:32:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43757 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab3CZWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:32:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] ACPI: Add sysfs links from memory device to memblocks
Date: Tue, 26 Mar 2013 23:39:29 +0100
Message-ID: <3205964.WeZJN7sRdd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364312526.11659.134.camel@misato.fc.hp.com>
References: <1361826130-31062-1-git-send-email-toshi.kani@hp.com> <2207657.9htT4cP6Jv@vostro.rjw.lan> <1364312526.11659.134.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 26, 2013 09:42:06 AM Toshi Kani wrote:
> On Tue, 2013-03-26 at 14:04 +0100, Rafael J. Wysocki wrote:
> > On Monday, February 25, 2013 02:02:10 PM Toshi Kani wrote:
> > > In order to eject a memory device object represented as "PNP0C80:%d"
> > > in sysfs, its associated memblocks (system/memory/memory%d) need to
> > > be off-lined.  However, there is no user friendly way to correlate
> > > between a memory device object and its memblocks in sysfs.
> > > 
> > > This patch creates sysfs links to memblocks under a memory device
> > > object so that a user can easily checks and manipulates its memblocks
> > > in sysfs.
> > > 
> > > For example, when PNP0C80:05 is associated with memory8 and memory9,
> > > the following two links are created under PNP0C80:05.  This allows
> > > a user to access memory8/9 directly from PNP0C80:05.
> > > 
> > >   # ll /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C80:05
> > >   lrwxrwxrwx. memory8 -> ../../../system/memory/memory8
> > >   lrwxrwxrwx. memory9 -> ../../../system/memory/memory9
> > > 
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > Here I have some doubts.
> > 
> > This adds a very specific interface for user space that we're going to need to
> > maintain going forward if the user space starts to use it.  However, it kind of
> > duplicates the existing "physical_node" interface that we have for "regular"
> > devices.
> > 
> > So, if possible, I'd like the memory subsystem to utilize the existing
> > interface instead of creating an entirely new one.  Namely, why don't we create
> > a struct device-based object for each memory block and associated those new
> > "devices" with the PNP0C80 ACPI object through the functions in glue.c?
> > Then, we could add an "offline/online" interface to those "devices" too.
> 
> This patch simply adds symbolic links to system/memory/memoryN, which
> the memory subsystem already provides for the online/offline interface
> of memory blocks.  So, it does not introduce a new interface, but guides
> users (and user tools) to know which memory blocks need to be off-lined
> in order to hot-delete any particular memory device PNP0C80:X.  A cpu
> device LNXCPU:X also has a similar symbolic link "sysdev" that links to
> system/cpu/cpuN.  I could not use the same "sysdev" for PNP0C80:X since
> it typically associates with multiple memory blocks.
> 
> I thought about using glue.c to create symbolic links between memoryN
> and PNP0C80:X.  However, it has an ordering issue.  During boot-time,
> memoryN gets created before PNP0C80:X.  But during hot-add, PNP0C80:X
> gets created before memoryN.

Quite frankly, this sounds like a bug to me.  Namely, what is memoryN really
good for without PNP0C80:X?  If it is not good for anything in that case,
it should never be created befor PNP0C80:X.

> This patch calls
> acpi_setup_mem_blk_links() in a point that solves this ordering issue
> since this point guarantees that both memoryN and PNP0C80X are created
> for both boot-time and hot-add.

I would prefer the ordering of creation to be the same in both cases.
Otherwise it really looks like we need to work around a problem that we're
creating for ourselves.

How exactly are memoryN created during boot?

Rafael


> > > ---
> > > 
> > > This patch applies on top of the Rafael's patch below.
> > > https://patchwork.kernel.org/patch/2153261/
> > > 
> > > v2: Added a NULL return check for find_memory_block_hinted() as
> > > pointed by Yasuaki Ishimatsu.
> > > 
> > > ---
> > >  drivers/acpi/acpi_memhotplug.c |   56 ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 56 insertions(+)
> > > 
> > > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > > index 3b3abbc..98477a5 100644
> > > --- a/drivers/acpi/acpi_memhotplug.c
> > > +++ b/drivers/acpi/acpi_memhotplug.c
> > > @@ -28,6 +28,7 @@
> > >   */
> > >  
> > >  #include <linux/acpi.h>
> > > +#include <linux/memory.h>
> > >  #include <linux/memory_hotplug.h>
> > >  
> > >  #include "internal.h"
> > > @@ -168,6 +169,55 @@ static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
> > >  	return 0;
> > >  }
> > >  
> > > +static void acpi_setup_mem_blk_links(struct acpi_memory_device *mem_device,
> > > +		struct acpi_memory_info *info, bool add_links)
> > > +{
> > > +	struct memory_block *mem_blk = NULL;
> > > +	struct mem_section *mem_sect;
> > > +	unsigned long start_pfn, end_pfn, pfn;
> > > +	unsigned long section_nr;
> > > +	int ret;
> > > +
> > > +	start_pfn = PFN_DOWN(info->start_addr);
> > > +	end_pfn = PFN_UP(info->start_addr + info->length-1);
> > > +
> > > +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> > > +		section_nr = pfn_to_section_nr(pfn);
> > > +
> > > +		if (!present_section_nr(section_nr))
> > > +			continue;
> > > +
> > > +		mem_sect = __nr_to_section(section_nr);
> > > +
> > > +		/* skip if the same memblock */
> > > +		if (mem_blk)
> > > +			if ((section_nr >= mem_blk->start_section_nr) &&
> > > +			    (section_nr <= mem_blk->end_section_nr))
> > > +				continue;
> > > +
> > > +		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
> > > +		if (!mem_blk)
> > > +			continue;
> > > +
> > > +		if (add_links) {
> > > +			ret = sysfs_create_link_nowarn(
> > > +				&mem_device->device->dev.kobj,
> > > +				&mem_blk->dev.kobj,
> > > +				kobject_name(&mem_blk->dev.kobj));
> > > +			if (ret && ret != -EEXIST)
> > > +				dev_err(&mem_device->device->dev,
> > > +					"Failed to create sysfs link %s\n",
> > > +					kobject_name(&mem_blk->dev.kobj));
> > > +		} else {
> > > +			sysfs_remove_link(&mem_device->device->dev.kobj,
> > > +				kobject_name(&mem_blk->dev.kobj));
> > > +		}
> > > +	}
> > > +
> > > +	if (mem_blk)
> > > +		kobject_put(&mem_blk->dev.kobj);
> > > +}
> > > +
> > >  static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
> > >  {
> > >  	int result, num_enabled = 0;
> > > @@ -207,6 +257,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
> > >  			continue;
> > >  		}
> > >  
> > > +		/* Create sysfs links to its mem_blk devices */
> > > +		acpi_setup_mem_blk_links(mem_device, info, true);
> > > +
> > >  		if (!result)
> > >  			info->enabled = 1;
> > >  		/*
> > > @@ -241,6 +294,9 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
> > >  			/* The kernel does not use this memory block */
> > >  			continue;
> > >  
> > > +		/* Remove sysfs links to its mem_blk devices */
> > > +		acpi_setup_mem_blk_links(mem_device, info, false);
> > > +
> > >  		if (!info->enabled)
> > >  			/*
> > >  			 * The kernel uses this memory block, but it may be not
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
