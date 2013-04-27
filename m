Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3D0HAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:00:21 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54776 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3D0HAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:00:20 -0400
Message-ID: <517B777B.5020303@gmail.com>
Date: Sat, 27 Apr 2013 15:00:11 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <517A0ED8.6000404@gmail.com> <20130426153502.GC3510@dhcp-26-164.brq.redhat.com>
In-Reply-To: <20130426153502.GC3510@dhcp-26-164.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 11:35 PM, Frantisek Hrbata wrote:
> On Fri, Apr 26, 2013 at 01:21:28PM +0800, Will Huck wrote:
>> Hi Peter,
>> On 04/02/2013 08:28 PM, Frantisek Hrbata wrote:
>>> When CR4.PAE is set, the 64b PTE's are used(ARCH_PHYS_ADDR_T_64BIT is set for
>>> X86_64 || X86_PAE). According to [1] Chapter 4 Paging, some higher bits in 64b
>>> PTE are reserved and have to be set to zero. For example, for IA-32e and 4KB
>>> page [1] 4.5 IA-32e Paging: Table 4-19, bits 51-M(MAXPHYADDR) are reserved. So
>>> for a CPU with e.g. 48bit phys addr width, bits 51-48 have to be zero. If one of
>>> the reserved bits is set, [1] 4.7 Page-Fault Exceptions, the #PF is generated
>>> with RSVD error code.
>>>
>>> <quote>
>>> RSVD flag (bit 3).
>>> This flag is 1 if there is no valid translation for the linear address because a
>>> reserved bit was set in one of the paging-structure entries used to translate
>>> that address. (Because reserved bits are not checked in a paging-structure entry
>>> whose P flag is 0, bit 3 of the error code can be set only if bit 0 is also
>>> set.)
>>> </quote>
>>>
>>> In mmap_mem() the first check is valid_mmap_phys_addr_range(), but it always
>>> returns 1 on x86. So it's possible to use any pgoff we want and to set the PTE's
>>> reserved bits in remap_pfn_range(). Meaning there is a possibility to use mmap
>> In this case, remap_pfn_range() setup the map and reserved bits for
>> mmio memory, so the mmio memory is already populated, why trigger
>> #PF?
> Hi,
>
> I think this is described in the quote above for the RSVD flag.
>
> remap_pfn_range() => page present => touch page => tlb miss =>
> walk through paging structures => reserved bit set => #pf with rsvd flag

Page present can also trigger #PF? why?

>
> I hope I didn't misunderstand your question.
>
> Thanks
>
>>> on /dev/mem and cause system panic. It's probably not that serious, because
>>> access to /dev/mem is limited and the system has to have panic_on_oops set, but
>>> still I think we should check this and return error.
>>>
>>> This patch adds check for x86 when ARCH_PHYS_ADDR_T_64BIT is set, the same way
>>> as it is already done in e.g. ioremap. With this fix mmap returns -EINVAL if the
>>> requested phys addr is bigger then the supported phys addr width.
>>>
>>> [1] Intel 64 and IA-32 Architectures Software Developer's Manual, Volume 3A
>>>
>>> Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
>>> ---
>>>   arch/x86/include/asm/io.h |  4 ++++
>>>   arch/x86/mm/mmap.c        | 13 +++++++++++++
>>>   2 files changed, 17 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>>> index d8e8eef..39607c6 100644
>>> --- a/arch/x86/include/asm/io.h
>>> +++ b/arch/x86/include/asm/io.h
>>> @@ -242,6 +242,10 @@ static inline void flush_write_buffers(void)
>>>   #endif
>>>   }
>>> +#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>>> +extern int valid_phys_addr_range(phys_addr_t addr, size_t count);
>>> +extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t count);
>>> +
>>>   #endif /* __KERNEL__ */
>>>   extern void native_io_delay(void);
>>> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
>>> index 845df68..92ec31c 100644
>>> --- a/arch/x86/mm/mmap.c
>>> +++ b/arch/x86/mm/mmap.c
>>> @@ -31,6 +31,8 @@
>>>   #include <linux/sched.h>
>>>   #include <asm/elf.h>
>>> +#include "physaddr.h"
>>> +
>>>   struct __read_mostly va_alignment va_align = {
>>>   	.flags = -1,
>>>   };
>>> @@ -122,3 +124,14 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>>>   		mm->unmap_area = arch_unmap_area_topdown;
>>>   	}
>>>   }
>>> +
>>> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
>>> +{
>>> +	return addr + count <= __pa(high_memory);
>>> +}
>>> +
>>> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
>>> +{
>>> +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
>>> +	return phys_addr_valid(addr);
>>> +}
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

