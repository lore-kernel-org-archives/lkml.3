Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3BASCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:02:05 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:39730 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3BASCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:02:02 -0500
X-Greylist: delayed 1680 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 13:02:02 EST
Message-ID: <510BFC84.2030902@gmail.com>
Date: Fri, 01 Feb 2013 09:33:56 -0800
From: Subash Patel <subashrp@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Hui Wang <jason77.wang@gmail.com>, Cyril Chemparathy <cyril@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, sboyd@codeaurora.org, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v4 02/13] ARM: LPAE: use phys_addr_t in alloc_init_pud()
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <1359669512-31276-3-git-send-email-cyril@ti.com> <510B327E.3050502@gmail.com> <alpine.LFD.2.02.1301312218270.6300@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1301312218270.6300@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Thursday 31 January 2013 07:35 PM, Nicolas Pitre wrote:
> On Fri, 1 Feb 2013, Hui Wang wrote:
>
>> Cyril Chemparathy wrote:
>>> From: Vitaly Andrianov <vitalya@ti.com>
>>>
>>> This patch fixes the alloc_init_pud() function to use phys_addr_t instead of
>>> unsigned long when passing in the phys argument.
>>>
>>> This is an extension to commit 97092e0c56830457af0639f6bd904537a150ea4a
>>> (ARM:
>>> pgtable: use phys_addr_t for physical addresses), which applied similar
>>> changes
>>> elsewhere in the ARM memory management code.
>>>
>>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>>> Acked-by: Nicolas Pitre <nico@linaro.org>
>>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>>> ---
>>>   arch/arm/mm/mmu.c |    3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>>> index 9f06102..ef43689 100644
>>> --- a/arch/arm/mm/mmu.c
>>> +++ b/arch/arm/mm/mmu.c
>>> @@ -612,7 +612,8 @@ static void __init alloc_init_section(pud_t *pud,
>>> unsigned long addr,
>>>   }
>>>    static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
>>> -	unsigned long end, unsigned long phys, const struct mem_type *type)
>>> +				  unsigned long end, phys_addr_t phys,
>>> +				  const struct mem_type *type)
>>>
>> The change is correct but seems useless so far. This function only be called
>> from map_lowmem and devicemaps_init, from i know neither lowmem nor device io
>> registers of existing platforms exceed 32bit address.
>
> It is not because you are not aware of any existing platforms with RAM
> or device IO above the 4GB mark that they don't exist.
>
> For example, some LPAE systems have all their RAM located above the 4G
> physical address mark. A simple (potentially non DMA capable) alias
> exists in the low 32-bit address space to allow the system to boot and
> switch to the real physical RAM addresses once the MMU is turned on.
> Some of that RAM is still qualified as "low mem" i.e. the portion of RAM
> that the kernel keeps permanently mapped in the 32-bit virtual space
> even if all of it is above the 4G mark in physical space.

I think he is right. You cannot have low_mem and devices in 36-bit 
areas. Atleast this is what I saw in one of the platforms on which I 
tested these patches. I am not sure what you mean by hardware address 
aliasing(as I have real RAM), but we need 32-bit areas to boot the CPU 
and I have mapped them for the LOW_MEM. But, I have used 36-bit areas 
for the HIGH_MEM. Since you said about aliasing DDR area in 32-bits, and 
then switching to 36-bit RAM, does the dma of the devices still use 
32-bit aliased addresses?

I haven't tested a configuration where LOW_MEM can have both 32-bit and 
36-bit DDR PA though. I think its not possible too.

Regards,
Subash


>
>
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
