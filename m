Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaHGRrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:47:32 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42938 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHGRra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140807173832.GN4179@bivouac.eciton.net>
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
	<1407423713-4160-2-git-send-email-keescook@chromium.org>
	<20140807173832.GN4179@bivouac.eciton.net>
Date: Thu, 7 Aug 2014 10:47:30 -0700
X-Google-Sender-Auth: rNiRnLvR3FUGMnPhIc58qPT0Fxk
Message-ID: <CAGXu5jL8TzxcSf_o49sTtxoEEqLRqb-Nwm2utzsftPiqtJ6d1Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] arm: use generic fixmap.h
From: Kees Cook <keescook@chromium.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Salter <msalter@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>, Liu hua <sdu.liu@huawei.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 10:38 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Thu, Aug 07, 2014 at 08:01:46AM -0700, Kees Cook wrote:
>> From: Mark Salter <msalter@redhat.com>
>>
>> ARM is different from other architectures in that fixmap pages are indexed
>> with a positive offset from FIXADDR_START.  Other architectures index with
>> a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
>> definitions, this patch redefines FIXADDR_TOP to be inclusive of the
>> useable range.  That is, FIXADDR_TOP is the virtual address of the topmost
>> fixed page.  The newly defined FIXADDR_END is the first virtual address
>> past the fixed mappings.
>>
>> Signed-off-by: Mark Salter <msalter@redhat.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> [update for "ARM: 8031/2: change fixmap mapping region to support 32 CPUs"]
>> [flipped highmem order, thanks to Laura Abbott]
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Laura Abbott <lauraa@codeaurora.org>
>> ---
>>  arch/arm/include/asm/fixmap.h | 27 +++++++++------------------
>>  arch/arm/mm/highmem.c         |  8 ++++++--
>>  arch/arm/mm/init.c            |  2 +-
>>  3 files changed, 16 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
>> index 74124b0d0d79..190142d174ee 100644
>> --- a/arch/arm/include/asm/fixmap.h
>> +++ b/arch/arm/include/asm/fixmap.h
>> @@ -2,27 +2,18 @@
>>  #define _ASM_FIXMAP_H
>>
>>  #define FIXADDR_START                0xffc00000UL
>> -#define FIXADDR_TOP          0xffe00000UL
>> -#define FIXADDR_SIZE         (FIXADDR_TOP - FIXADDR_START)
>> +#define FIXADDR_END          0xffe00000UL
>> +#define FIXADDR_TOP          (FIXADDR_END - PAGE_SIZE)
>> +#define FIXADDR_SIZE         (FIXADDR_END - FIXADDR_START)
>>
>>  #define FIX_KMAP_NR_PTES     (FIXADDR_SIZE >> PAGE_SHIFT)
>>
>> -#define __fix_to_virt(x)     (FIXADDR_START + ((x) << PAGE_SHIFT))
>> -#define __virt_to_fix(x)     (((x) - FIXADDR_START) >> PAGE_SHIFT)
>> +enum fixed_addresses {
>> +     FIX_KMAP_BEGIN,
>> +     FIX_KMAP_END = FIX_KMAP_NR_PTES - 1,
>> +     __end_of_fixed_addresses
>> +};
>>
>> -extern void __this_fixmap_does_not_exist(void);
>> -
>> -static inline unsigned long fix_to_virt(const unsigned int idx)
>> -{
>> -     if (idx >= FIX_KMAP_NR_PTES)
>> -             __this_fixmap_does_not_exist();
>> -     return __fix_to_virt(idx);
>> -}
>> -
>> -static inline unsigned int virt_to_fix(const unsigned long vaddr)
>> -{
>> -     BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
>> -     return __virt_to_fix(vaddr);
>> -}
>> +#include <asm-generic/fixmap.h>
>>
>>  #endif
>> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
>> index 45aeaaca9052..a1241ee8425e 100644
>> --- a/arch/arm/mm/highmem.c
>> +++ b/arch/arm/mm/highmem.c
>> @@ -23,14 +23,18 @@ pte_t *fixmap_page_table;
>>  static inline void set_fixmap_pte(int idx, pte_t pte)
>>  {
>>       unsigned long vaddr = __fix_to_virt(idx);
>> -     set_pte_ext(fixmap_page_table + idx, pte, 0);
>> +     pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
>> +
>> +     set_pte_ext(ppte, pte, 0);
>>       local_flush_tlb_kernel_page(vaddr);
>>  }
>>
>>  static inline pte_t get_fixmap_pte(unsigned long vaddr)
>>  {
>>       unsigned long idx = __virt_to_fix(vaddr);
>
> idx is now "unused variable".

Ah! Yes, thanks. I'll add HIGHMEM to my build cycles.

>
>> -     return *(fixmap_page_table + idx);
>> +     pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
>> +
>> +     return *ppte;
>>  }
>>
>>  void *kmap(struct page *page)
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 659c75d808dc..ad82c05bfc3a 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -570,7 +570,7 @@ void __init mem_init(void)
>>                       MLK(DTCM_OFFSET, (unsigned long) dtcm_end),
>>                       MLK(ITCM_OFFSET, (unsigned long) itcm_end),
>>  #endif
>> -                     MLK(FIXADDR_START, FIXADDR_TOP),
>> +                     MLK(FIXADDR_START, FIXADDR_END),
>>                       MLM(VMALLOC_START, VMALLOC_END),
>>                       MLM(PAGE_OFFSET, (unsigned long)high_memory),
>>  #ifdef CONFIG_HIGHMEM
>> --
>> 1.9.1
>
> Apart from that, verified with early_ioremap/UEFI patches on TC2.
>
> Tested-by: Leif Lindholm <leif.lindholm@linaro.org>

Thanks! I've added this and fixed idx above for the future v3 of this series.

-Kees

-- 
Kees Cook
Chrome OS Security
