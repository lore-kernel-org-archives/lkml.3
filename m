Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbaHGOfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:35:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52982 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbaHGOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <53E2E354.6020902@codeaurora.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
	<1407353564-21478-2-git-send-email-keescook@chromium.org>
	<53E2E354.6020902@codeaurora.org>
Date: Thu, 7 Aug 2014 07:35:30 -0700
X-Google-Sender-Auth: d5L1BNPI1Xy_XijknC4uQwLRFVw
Message-ID: <CAGXu5jL7L--apmCSO52ErUMPfXPBUBKCCg2NwYAc8FUNZaAGvg@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm: use generic fixmap.h
From: Kees Cook <keescook@chromium.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robh@kernel.org>, Liu hua <sdu.liu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Doug Anderson <dianders@google.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Mark Salter <msalter@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 7:24 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 8/6/2014 12:32 PM, Kees Cook wrote:
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
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/arm/include/asm/fixmap.h | 27 +++++++++------------------
>>  arch/arm/mm/init.c            |  2 +-
>>  2 files changed, 10 insertions(+), 19 deletions(-)
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
>>
>
> I'm working off of a 3.14 kernel and with this backported
> kmap_atomic does not actually map properly for me. This was
>
> my quick fix (not sure if we should be using __set_fixmap?). Or did
> I fail at backportery?
>
> -----8<-----
> From ea11b54704aa0a311ab3d05fd70072679bfe1a0b Mon Sep 17 00:00:00 2001
> From: Laura Abbott <lauraa@codeaurora.org>
> Date: Wed, 6 Aug 2014 19:20:46 -0700
> Subject: [PATCH] arm: Get proper pte for fixmaps
>
> The generic fixmap.h gets indexes from high to low instead
> of low to high so the fixmap idx does not correspond to
> the array entry in fixmap_page_table. Get the proper pte
> to update.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  arch/arm/mm/highmem.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
> index bedca3a..7f08e64 100644
> --- a/arch/arm/mm/highmem.c
> +++ b/arch/arm/mm/highmem.c
> @@ -22,14 +22,18 @@
>  static inline void set_fixmap_pte(int idx, pte_t pte)
>  {
>         unsigned long vaddr = __fix_to_virt(idx);
> -       set_pte_ext(fixmap_page_table + idx, pte, 0);
> +       pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
> +
> +       set_pte_ext(ppte, pte, 0);
>         local_flush_tlb_kernel_page(vaddr);
>  }
>
>  static inline pte_t get_fixmap_pte(unsigned long vaddr)
>  {
>         unsigned long idx = __virt_to_fix(vaddr);
> -       return *(fixmap_page_table + idx);
> +       pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
> +
> +       return *ppte;
>  }

IIUC, what you have is correct: it matches what I had to do for
__set_fixmap and flips the high/low indexing. Thanks! I'll merge this
with the "use generic fixmap" patch, since it's what flips around the
ordering.

-Kees

-- 
Kees Cook
Chrome OS Security
