Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3KZUOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:14:50 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49305 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3KZUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Wxabxb6mnYbgKw__TeXeC+PJfgE66siFMuvGkbPGczg@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<1385429290-25397-8-git-send-email-yinghai@kernel.org>
	<CAErSpo6Wxabxb6mnYbgKw__TeXeC+PJfgE66siFMuvGkbPGczg@mail.gmail.com>
Date: Tue, 26 Nov 2013 12:14:47 -0800
X-Google-Sender-Auth: iHOjA9y1o0-PH8F6tdMnofu8tYg
Message-ID: <CAE9FiQUSQCB73jnZuDJTQUGv8nrgJgjBgvE-ZDC1kpiR-HYodA@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 8:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Will fall back to below 4g if it can not find any above 4g.
>
> Does this fix a bug?  If so, please include a bugzilla or mailing list URL.
>
>> x86 32bit without X86_PAE support will have bottom set to 0, because
>> resource_size_t is 32bit.
>>
>> Also for 32bit with resource_size_t 64bit kernel on machine with pae support
>> we are safe because iomem_resource is limited to 32bit according to
>> x86_phys_bits.
>>
>> -v2: update bottom assigning to make it clear for non-pae support machine.
>> -v3: Bjorn's change:
>>         use MAX_RESOURCE instead of -1
>>         use start/end instead of bottom/max
>>         for all arch instead of just x86_64
>> -v4: updated after PCI_MAX_RESOURCE_32 change.
>> -v5: restore io handling to use PCI_MAX_RESOURCE_32 as limit.
>> -v6: checking pcibios_resource_to_bus return for every bus res, to decide it
>>         if we need to try high at first.
>>      It supports all arches instead of just x86_64.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/include/asm/pci.h |  1 -
>>  drivers/pci/bus.c          | 42 ++++++++++++++++++++++++++++++++++--------
>>  drivers/pci/pci.h          |  2 ++
>>  include/linux/pci.h        |  4 ----
>>  4 files changed, 36 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
>> index 947b5c4..122c299 100644
>> --- a/arch/x86/include/asm/pci.h
>> +++ b/arch/x86/include/asm/pci.h
>> @@ -125,7 +125,6 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
>>
>>  /* generic pci stuff */
>>  #include <asm-generic/pci.h>
>> -#define PCIBIOS_MAX_MEM_32 0xffffffff
>>
>>  #ifdef CONFIG_NUMA
>>  /* Returns the node based on pci bus */
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 1ffd95b..f801f6a 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -125,15 +125,13 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>>  {
>>         int i, ret = -ENOMEM;
>>         struct resource *r;
>> -       resource_size_t max = -1;
>>
>>         type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
>>
>> -       /* don't allocate too high if the pref mem doesn't support 64bit*/
>> -       if (!(res->flags & IORESOURCE_MEM_64))
>> -               max = PCIBIOS_MAX_MEM_32;
>> -
>>         pci_bus_for_each_resource(bus, r, i) {
>> +               resource_size_t start, end, middle;
>> +               struct pci_bus_region region;
>> +
>
> I think you're doing two things at once in this patch:
>
> 1) Fixing the problem that the IORESOURCE_MEM_64 constraint was being
> applied to CPU addresses, not bus addresses, and
>
> 2) Trying to allocate above 4G first.
>
> Please separate these into two patches.  The first thing is an obvious
> problem and should have little risk of breaking anything.  The second
> probably makes sense, but the allocation change could certainly break
> something and have to be reverted.  It would be good if we could save
> the first fix if that happened.

sure.

>
>>                 if (!r)
>>                         continue;
>>
>> @@ -147,14 +145,42 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>>                     !(res->flags & IORESOURCE_PREFETCH))
>>                         continue;
>>
>> +               start = 0;
>> +               end = MAX_RESOURCE;
>> +               /*
>> +                * don't allocate too high if the pref mem doesn't
>> +                * support 64bit, also if this is a 64-bit mem
>> +                * resource, try above 4GB first
>> +                */
>> +               __pcibios_resource_to_bus(bus, &region, r);
>> +               if (region.start <= PCI_MAX_ADDR_32 &&
>> +                   region.end > PCI_MAX_ADDR_32) {
>> +                       middle = pcibios_bus_addr_to_res(bus, res->flags,
>> +                                                     PCI_MAX_ADDR_32);
>> +                       if (res->flags & IORESOURCE_MEM_64)
>> +                               start = middle + 1;
>> +                       else
>> +                               end = middle;
>> +               } else if (region.start > PCI_MAX_ADDR_32 &&
>> +                          !(res->flags & IORESOURCE_MEM_64))
>> +                               continue;
>
> This is sort of ugly.  Can you make some sort of "pci_clip_resource()"
>  so this loop remains readable?  E.g., something like:
>
>   static pci_bus_region pci_mem_32 = { 0, 0xffffffff };
>   static pci_bus_region pci_mem_64 = { 0x100000000, 0xffffffffffffffff };
>
>   struct resource avail = *r;
>
>   if (res->flags & IORESOURCE_MEM_64)
>     pci_clip_resource(&avail, &pci_mem_64);
>   else
>     pci_clip_resource(&avail, &pci_mem_32);
>   if (!resource_size(&avail))
>     continue;
>

ok.

Thanks

Yinghai
