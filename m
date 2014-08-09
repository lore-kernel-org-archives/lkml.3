Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaHIAL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:11:29 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39126 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHIAL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJZbbH=PwDzLKSwKiW1Y=N8MLgwEkp=xQaD_ST_uB-_Rw@mail.gmail.com>
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
	<1407423713-4160-4-git-send-email-keescook@chromium.org>
	<CAL_JsqJZbbH=PwDzLKSwKiW1Y=N8MLgwEkp=xQaD_ST_uB-_Rw@mail.gmail.com>
Date: Fri, 8 Aug 2014 17:11:27 -0700
X-Google-Sender-Auth: 2i6Yl6mM-jrjmWnlcSSZ_aySOIo
Message-ID: <CAGXu5jLeN_HtDw5KsdXemfgDOszHCM0y7ZaKc167jkjMkNcTfw@mail.gmail.com>
Subject: Re: [PATCH 3/8] arm: mm: reduce fixmap kmap from 32 to 16 CPUS
From: Kees Cook <keescook@chromium.org>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 3:18 PM, Rob Herring <robh@kernel.org> wrote:
> On Thu, Aug 7, 2014 at 10:01 AM, Kees Cook <keescook@chromium.org> wrote:
>> More room is needed in the fixmap range for non-kmap fixmap entries. This
>> reduces the kmap range from 32 to 16 CPUs.
>
> Do you want this merged or just doing this to get the rest of your
> series working? I'll post my patch for making the fixmap region 3MB
> (it adds back the first 1MB of the top pmd).

Excellent, thanks for sending this, I'll get it tested as part of the series.

>> Additionally, add PTE entry for
>> fixmap regardless of CONFIG_HIGHMEM.
>
> "Additionally" is a good flag for this patch should be split-up. It
> seems like we would want to apply this part to stable.

Does anyone have use-cases that broke in 3.16 due to this bug? If so,
it absolutely should be split out and CCed to -stable. I'll split it
out regardless, and if someone can speak up with a broken situation,
I'll add the CC.

Thanks!

-Kees

>
> Rob
>
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/arm/include/asm/fixmap.h | 12 ++++++++++--
>>  arch/arm/mm/highmem.c         |  2 --
>>  arch/arm/mm/mm.h              |  3 +++
>>  arch/arm/mm/mmu.c             |  5 ++++-
>>  4 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
>> index 8ee7cb4f62ca..3ed08232be55 100644
>> --- a/arch/arm/include/asm/fixmap.h
>> +++ b/arch/arm/include/asm/fixmap.h
>> @@ -1,16 +1,24 @@
>>  #ifndef _ASM_FIXMAP_H
>>  #define _ASM_FIXMAP_H
>>
>> +/*
>> + * The fixmap uses 2MB. The KMAP fixmap needs 64k per CPU, so make room for
>> + * 16 CPUs (taking 1MB) and leave the rest for additional fixmap areas.
>> + */
>>  #define FIXADDR_START          0xffc00000UL
>>  #define FIXADDR_END            0xffe00000UL
>>  #define FIXADDR_TOP            (FIXADDR_END - PAGE_SIZE)
>>  #define FIXADDR_SIZE           (FIXADDR_END - FIXADDR_START)
>>
>> -#define FIX_KMAP_NR_PTES       (FIXADDR_SIZE >> PAGE_SHIFT)
>> +/* 16 PTEs per CPU (64k of 4k pages). */
>> +#define FIX_KMAP_NR_PTES       16
>> +#define FIX_KMAP_NR_CPUS       16
>>
>>  enum fixed_addresses {
>> +       /* Support 16 CPUs for kmap as the first region of fixmap entries. */
>>         FIX_KMAP_BEGIN,
>> -       FIX_KMAP_END = FIX_KMAP_NR_PTES - 1,
>> +       FIX_KMAP_END = (FIX_KMAP_NR_PTES * FIX_KMAP_NR_CPUS) - 1,
>> +
>>         __end_of_fixed_addresses
>>  };
>>
>> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
>> index a1241ee8425e..adf264fb700b 100644
>> --- a/arch/arm/mm/highmem.c
>> +++ b/arch/arm/mm/highmem.c
>> @@ -18,8 +18,6 @@
>>  #include <asm/tlbflush.h>
>>  #include "mm.h"
>>
>> -pte_t *fixmap_page_table;
>> -
>>  static inline void set_fixmap_pte(int idx, pte_t pte)
>>  {
>>         unsigned long vaddr = __fix_to_virt(idx);
>> diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
>> index ce727d47275c..c8b5b2d05b55 100644
>> --- a/arch/arm/mm/mm.h
>> +++ b/arch/arm/mm/mm.h
>> @@ -7,6 +7,9 @@
>>  /* the upper-most page table pointer */
>>  extern pmd_t *top_pmd;
>>
>> +/* The fixmap PTE. */
>> +extern pte_t *fixmap_page_table;
>> +
>>  /*
>>   * 0xffff8000 to 0xffffffff is reserved for any ARM architecture
>>   * specific hacks for copying pages efficiently, while 0xffff4000
>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>> index e881ed817a8b..a7a756603775 100644
>> --- a/arch/arm/mm/mmu.c
>> +++ b/arch/arm/mm/mmu.c
>> @@ -53,6 +53,9 @@ EXPORT_SYMBOL(empty_zero_page);
>>   */
>>  pmd_t *top_pmd;
>>
>> +/* The fixmap PTE. */
>> +pte_t *fixmap_page_table;
>> +
>>  #define CPOLICY_UNCACHED       0
>>  #define CPOLICY_BUFFERED       1
>>  #define CPOLICY_WRITETHROUGH   2
>> @@ -1342,10 +1345,10 @@ static void __init kmap_init(void)
>>  #ifdef CONFIG_HIGHMEM
>>         pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
>>                 PKMAP_BASE, _PAGE_KERNEL_TABLE);
>> +#endif
>>
>>         fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
>>                 FIXADDR_START, _PAGE_KERNEL_TABLE);
>> -#endif
>>  }
>>
>>  static void __init map_lowmem(void)
>> --
>> 1.9.1
>>



-- 
Kees Cook
Chrome OS Security
