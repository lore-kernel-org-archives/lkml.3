Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaLJNhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:37:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:22430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaLJNhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:37:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,552,1413270000"; 
   d="scan'208";a="621579018"
Message-ID: <54884C75.6050406@linux.intel.com>
Date: Wed, 10 Dec 2014 21:36:53 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function resource_to_addr()
 in arch/x86/pci/acpi.c
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>	<tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org> <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
In-Reply-To: <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
	I have one comment about the attached patch related to
following piece of code. I'm not sure whether we should check
"addr.maximum - addr.minimum + 1 != addr.address_length"
instead of "!addr.address_length". Otherwise:

Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
Regards!
Gerry

Index: linux-2.6/drivers/acpi/resource.c
===================================================================
--- linux-2.6.orig/drivers/acpi/resource.c
+++ linux-2.6/drivers/acpi/resource.c
@@ -199,7 +199,7 @@ bool acpi_dev_resource_address_space(str
 	}

 	status = acpi_resource_to_address64(ares, &addr);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status) || !addr.address_length)
 		return false;

 	res->start = addr.minimum;	

On 2014/12/10 12:08, Yinghai Lu wrote:
> On Mon, Nov 3, 2014 at 2:57 AM, tip-bot for Jiang Liu <tipbot@zytor.com> wrote:
>> Commit-ID:  e22ce93870deae0e9a54e1539f0088538f187780
>> Gitweb:     http://git.kernel.org/tip/e22ce93870deae0e9a54e1539f0088538f187780
>> Author:     Jiang Liu <jiang.liu@linux.intel.com>
>> AuthorDate: Mon, 27 Oct 2014 13:21:34 +0800
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Mon, 3 Nov 2014 11:56:07 +0100
>>
>> x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c
>>
>> Private function resource_to_addr() is used to parse ACPI resources
>> for PCI host bridge. There are public interfaces available for that
>> purpose, so replace resource_to_addr() with public interfaces.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Link: http://lkml.kernel.org/r/1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  arch/x86/pci/acpi.c | 144 +++++++++++++++++++---------------------------------
>>  1 file changed, 53 insertions(+), 91 deletions(-)
>>
>> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
>> index cfd1b13..3f72d93 100644
>> --- a/arch/x86/pci/acpi.c
>> +++ b/arch/x86/pci/acpi.c
>> @@ -218,114 +218,76 @@ static void teardown_mcfg_map(struct pci_root_info *info)
>>  }
>>  #endif
>>
>> -static acpi_status resource_to_addr(struct acpi_resource *resource,
>> -                                   struct acpi_resource_address64 *addr)
>> -{
>> -       acpi_status status;
>> -       struct acpi_resource_memory24 *memory24;
>> -       struct acpi_resource_memory32 *memory32;
>> -       struct acpi_resource_fixed_memory32 *fixed_memory32;
>> -
>> -       memset(addr, 0, sizeof(*addr));
>> -       switch (resource->type) {
>> -       case ACPI_RESOURCE_TYPE_MEMORY24:
>> -               memory24 = &resource->data.memory24;
>> -               addr->resource_type = ACPI_MEMORY_RANGE;
>> -               addr->minimum = memory24->minimum;
>> -               addr->address_length = memory24->address_length;
>> -               addr->maximum = addr->minimum + addr->address_length - 1;
>> -               return AE_OK;
>> -       case ACPI_RESOURCE_TYPE_MEMORY32:
>> -               memory32 = &resource->data.memory32;
>> -               addr->resource_type = ACPI_MEMORY_RANGE;
>> -               addr->minimum = memory32->minimum;
>> -               addr->address_length = memory32->address_length;
>> -               addr->maximum = addr->minimum + addr->address_length - 1;
>> -               return AE_OK;
>> -       case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
>> -               fixed_memory32 = &resource->data.fixed_memory32;
>> -               addr->resource_type = ACPI_MEMORY_RANGE;
>> -               addr->minimum = fixed_memory32->address;
>> -               addr->address_length = fixed_memory32->address_length;
>> -               addr->maximum = addr->minimum + addr->address_length - 1;
>> -               return AE_OK;
>> -       case ACPI_RESOURCE_TYPE_ADDRESS16:
>> -       case ACPI_RESOURCE_TYPE_ADDRESS32:
>> -       case ACPI_RESOURCE_TYPE_ADDRESS64:
>> -               status = acpi_resource_to_address64(resource, addr);
>> -               if (ACPI_SUCCESS(status) &&
>> -                   (addr->resource_type == ACPI_MEMORY_RANGE ||
>> -                   addr->resource_type == ACPI_IO_RANGE) &&
>> -                   addr->address_length > 0) {
>> -                       return AE_OK;
>> -               }
>> -               break;
>> -       }
>> -       return AE_ERROR;
>> -}
>> -
>>  static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
>>  {
>>         struct pci_root_info *info = data;
>> -       struct acpi_resource_address64 addr;
>> -       acpi_status status;
>> +       struct resource r = {
>> +               .flags = 0
>> +       };
>>
>> -       status = resource_to_addr(acpi_res, &addr);
>> -       if (ACPI_SUCCESS(status))
>> +       if (!acpi_dev_resource_memory(acpi_res, &r) &&
>> +           !acpi_dev_resource_address_space(acpi_res, &r))
>> +               return AE_OK;
>> +
>> +       if ((r.flags & (IORESOURCE_IO | IORESOURCE_MEM)) && resource_size(&r))
>>                 info->res_num++;
>> +
>>         return AE_OK;
>>  }
>>
>>  static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
>>  {
>>         struct pci_root_info *info = data;
>> -       struct resource *res;
>> -       struct acpi_resource_address64 addr;
>> -       acpi_status status;
>> -       unsigned long flags;
>> -       u64 start, orig_end, end;
>> +       u64 translation_offset = 0;
>> +       struct resource r = {
>> +               .flags = 0
>> +       };
>> +
>> +       if (acpi_dev_resource_memory(acpi_res, &r)) {
>> +               r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
>> +       } else if (acpi_dev_resource_address_space(acpi_res, &r)) {
>> +               u64 orig_end;
>> +               struct acpi_resource_address64 addr;
>> +
>> +               r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
>> +               if (r.flags == 0)
>> +                       return AE_OK;
>>
>> -       status = resource_to_addr(acpi_res, &addr);
>> -       if (!ACPI_SUCCESS(status))
>> -               return AE_OK;
>> +               if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
>> +                       return AE_OK;
>>
>> -       if (addr.resource_type == ACPI_MEMORY_RANGE) {
>> -               flags = IORESOURCE_MEM;
>> -               if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>> -                       flags |= IORESOURCE_PREFETCH;
>> -       } else if (addr.resource_type == ACPI_IO_RANGE) {
>> -               flags = IORESOURCE_IO;
>> -       } else
>> -               return AE_OK;
>> +               if (addr.resource_type == ACPI_MEMORY_RANGE &&
>> +                   addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>> +                       r.flags |= IORESOURCE_PREFETCH;
>>
>> -       start = addr.minimum + addr.translation_offset;
>> -       orig_end = end = addr.maximum + addr.translation_offset;
>> +               translation_offset = addr.translation_offset;
>> +               orig_end = r.end;
>> +               r.start += translation_offset;
>> +               r.end += translation_offset;
>>
>> -       /* Exclude non-addressable range or non-addressable portion of range */
>> -       end = min(end, (u64)iomem_resource.end);
>> -       if (end <= start) {
>> -               dev_info(&info->bridge->dev,
>> -                       "host bridge window [%#llx-%#llx] "
>> -                       "(ignored, not CPU addressable)\n", start, orig_end);
>> -               return AE_OK;
>> -       } else if (orig_end != end) {
>> -               dev_info(&info->bridge->dev,
>> -                       "host bridge window [%#llx-%#llx] "
>> -                       "([%#llx-%#llx] ignored, not CPU addressable)\n",
>> -                       start, orig_end, end + 1, orig_end);
>> +               /* Exclude non-addressable range or non-addressable portion of range */
>> +               r.end = min(r.end, iomem_resource.end);
>> +               if (r.end <= r.start) {
>> +                       dev_info(&info->bridge->dev,
>> +                               "host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
>> +                                r.start, orig_end);
>> +                       return AE_OK;
>> +               } else if (orig_end != r.end) {
>> +                       dev_info(&info->bridge->dev,
>> +                               "host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
>> +                               r.start, orig_end, r.end + 1, orig_end);
>> +               }
>>         }
>>
>> -       res = &info->res[info->res_num];
>> -       res->name = info->name;
>> -       res->flags = flags;
>> -       res->start = start;
>> -       res->end = end;
>> -       info->res_offset[info->res_num] = addr.translation_offset;
>> -       info->res_num++;
>> -
>> -       if (!pci_use_crs)
>> -               dev_printk(KERN_DEBUG, &info->bridge->dev,
>> -                          "host bridge window %pR (ignored)\n", res);
>> +       if (r.flags && resource_size(&r)) {
>> +               r.name = info->name;
>> +               info->res[info->res_num] = r;
>> +               info->res_offset[info->res_num] = translation_offset;
>> +               info->res_num++;
>> +               if (!pci_use_crs)
>> +                       dev_printk(KERN_DEBUG, &info->bridge->dev,
>> +                                  "host bridge window %pR (ignored)\n", &r);
>> +       }
>>
>>         return AE_OK;
>>  }
> 
> This one cause one system with Nehalem and one with Westmere failing.
> 
> [   32.353347] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x000a0000-0x000bffff] ignored
> [   32.362897] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x000d0000-0x000dffff] ignored
> [   32.382862] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
> [   32.402889] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [??? 0x00000000-0xffffffff flags 0x0] ignored
> [   32.423000] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
> [   32.602921] PCI host bridge to bus 0000:00
> [   32.603158] pci_bus 0000:00: root bus resource [bus 00-3f]
> [   32.622782] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
> [   32.642569] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> [   32.642893] pci_bus 0000:00: root bus resource [mem
> 0xfc000000000-0xfc07fffffff pref]
> 
> Looks like the commit have several problems.
> 
> Attached patch should address them.
> 
> Please fix it before it get into linus tree.
> 
> Thanks
> 
> Yinghai
> 
