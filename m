Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3BYUmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:42:13 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41759 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3BYUmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:42:11 -0500
Message-ID: <1361824276.12845.75.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add sysfs links from memory device to memblocks
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vasilis.liaskovitis@profitbricks.com
Date: Mon, 25 Feb 2013 13:31:16 -0700
In-Reply-To: <512AEDCE.6060509@jp.fujitsu.com>
References: <1361562147-30801-1-git-send-email-toshi.kani@hp.com>
	 <512AEDCE.6060509@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 13:51 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2013/02/23 4:42, Toshi Kani wrote:
> > In order to eject a memory device object represented as "PNP0C80:%d"
> > in sysfs, its associated memblocks (system/memory/memory%d) need to
> > be off-lined.  However, there is no user friendly way to correlate
> > between a memory device object and its memblocks in sysfs.
> > 
> > This patch creates sysfs links to memblocks under a memory device
> > object so that a user can easily checks and manipulates its memblocks
> > in sysfs.
> > 
> > For example, when PNP0C80:05 is associated with memory8 and memory9,
> > the following two links are created under PNP0C80:05.  This allows
> > a user to access memory8/9 directly from PNP0C80:05.
> > 
> >    # ll /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C80:05
> >    lrwxrwxrwx. memory8 -> ../../../system/memory/memory8
> >    lrwxrwxrwx. memory9 -> ../../../system/memory/memory9
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> > This patch applies on top of the Rafael's patch below.
> > https://patchwork.kernel.org/patch/2153261/
> > 
> > ---
> >   drivers/acpi/acpi_memhotplug.c |   54 ++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 54 insertions(+)
> > 
> > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > index 3b3abbc..d6226b3 100644
> > --- a/drivers/acpi/acpi_memhotplug.c
> > +++ b/drivers/acpi/acpi_memhotplug.c
> > @@ -28,6 +28,7 @@
> >    */
> >   
> >   #include <linux/acpi.h>
> > +#include <linux/memory.h>
> >   #include <linux/memory_hotplug.h>
> >   
> >   #include "internal.h"
> > @@ -168,6 +169,53 @@ static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
> >   	return 0;
> >   }
> >   
> > +static void acpi_setup_mem_blk_links(struct acpi_memory_device *mem_device,
> > +		struct acpi_memory_info *info, bool add_links)
> > +{
> > +	struct memory_block *mem_blk = NULL;
> > +	struct mem_section *mem_sect;
> > +	unsigned long start_pfn, end_pfn, pfn;
> > +	unsigned long section_nr;
> > +	int ret;
> > +
> > +	start_pfn = PFN_DOWN(info->start_addr);
> > +	end_pfn = PFN_UP(info->start_addr + info->length-1);
> > +
> > +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> > +		section_nr = pfn_to_section_nr(pfn);
> > +
> > +		if (!present_section_nr(section_nr))
> > +			continue;
> > +
> > +		mem_sect = __nr_to_section(section_nr);
> > +
> > +		/* skip if the same memblock */
> > +		if (mem_blk)
> > +			if ((section_nr >= mem_blk->start_section_nr) &&
> > +			    (section_nr <= mem_blk->end_section_nr))
> > +				continue;
> > +
> 
> > +		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
> 
> NULL pointer check is needed.	

Good point!  I will update the patch to check this condition.

Thanks!
-Toshi


