Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3CVA4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:56:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34182 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3CVA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <514B2D0E.808@gmail.com>
References: <1363524578-3765-1-git-send-email-chenhc@lemote.com>
	<514A42F2.4080501@gmail.com>
	<514B2D0E.808@gmail.com>
Date: Fri, 22 Mar 2013 08:56:27 +0800
X-Google-Sender-Auth: nWpSjPnZbHjZ-HUm4C56n_F91d0
Message-ID: <CAAhV-H79SGN-R5paROAzJQ+yuFsF7znOSpzEe+=bKJ9UMtajRw@mail.gmail.com>
Subject: Re: [PATCH V2 01/02] MIPS: Build uasm-generated code only once to
 avoid CPU Hotplug problem
From: Huacai Chen <chenhc@lemote.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongbing Hu <huhb@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:53 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 03/20/2013 04:14 PM, David Daney wrote:
>>
>> On 03/17/2013 05:49 AM, Huacai Chen wrote:
>>>
>>> This and the next patch resolve memory corruption problems while CPU
>>> hotplug. Without these patches, memory corruption can triggered easily
>>> as below:
>>>
> [...]
>
>>
>> We were seeing the same crashes, this patch set seems to fix the problem.
>>
>> Acked-by: David Daney <david.daney@cavium.com>
>
>
> On second thought...
>
>
>
>>
>>> ---
>>>   arch/mips/include/asm/cpu-features.h               |    3 +++
>>>   .../asm/mach-loongson/cpu-feature-overrides.h      |    1 +
>>>   arch/mips/mm/page.c                                |   10 ++++++++++
>>>   arch/mips/mm/tlbex.c                               |   10 ++++++++--
>>>   4 files changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/mips/include/asm/cpu-features.h
>>> b/arch/mips/include/asm/cpu-features.h
>>> index 1a57e8b..e5ec8fc 100644
>>> --- a/arch/mips/include/asm/cpu-features.h
>>> +++ b/arch/mips/include/asm/cpu-features.h
>>> @@ -113,6 +113,9 @@
>>>   #ifndef cpu_has_pindexed_dcache
>>>   #define cpu_has_pindexed_dcache (cpu_data[0].dcache.flags &
>>> MIPS_CACHE_PINDEX)
>>>   #endif
>>> +#ifndef cpu_has_local_ebase
>>> +#define cpu_has_local_ebase    1
>
>
>
> This really should default to 0 and only be set for (??who knows what??).
The original code before this patch assume all MIPS has a local ebase.
To minimize the modification, we default it to 1 (but I don't know
which CPU has local ebase).

>
> David Daney
>
>
>
>>> +#endif
>>>
>>>   /*
>>>    * I-Cache snoops remote store.     This only matters on SMP.  Some
>>> multiprocessors
>>> diff --git
>>> a/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
>>> b/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
>>> index 75fd8c0..c0f3ef4 100644
>>> --- a/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
>>> +++ b/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
>>> @@ -57,5 +57,6 @@
>>>   #define cpu_has_vint        0
>>>   #define cpu_has_vtag_icache    0
>>>   #define cpu_has_watch        1
>>> +#define cpu_has_local_ebase    0
>>>
>>>   #endif /* __ASM_MACH_LOONGSON_CPU_FEATURE_OVERRIDES_H */
>>> diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
>>> index a29fba5..4eb8dcf 100644
>>> --- a/arch/mips/mm/page.c
>>> +++ b/arch/mips/mm/page.c
>>> @@ -247,6 +247,11 @@ void __cpuinit build_clear_page(void)
>>>       struct uasm_label *l = labels;
>>>       struct uasm_reloc *r = relocs;
>>>       int i;
>>> +    static atomic_t run_once = ATOMIC_INIT(0);
>>> +
>>> +    if (atomic_xchg(&run_once, 1)) {
>>> +        return;
>>> +    }
>>>
>>>       memset(labels, 0, sizeof(labels));
>>>       memset(relocs, 0, sizeof(relocs));
>>> @@ -389,6 +394,11 @@ void __cpuinit build_copy_page(void)
>>>       struct uasm_label *l = labels;
>>>       struct uasm_reloc *r = relocs;
>>>       int i;
>>> +    static atomic_t run_once = ATOMIC_INIT(0);
>>> +
>>> +    if (atomic_xchg(&run_once, 1)) {
>>> +        return;
>>> +    }
>>>
>>>       memset(labels, 0, sizeof(labels));
>>>       memset(relocs, 0, sizeof(relocs));
>>> diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
>>> index 820e661..6bc28b4 100644
>>> --- a/arch/mips/mm/tlbex.c
>>> +++ b/arch/mips/mm/tlbex.c
>>> @@ -2162,8 +2162,11 @@ void __cpuinit build_tlb_refill_handler(void)
>>>       case CPU_TX3922:
>>>       case CPU_TX3927:
>>>   #ifndef CONFIG_MIPS_PGD_C0_CONTEXT
>>> -        build_r3000_tlb_refill_handler();
>>> +        if (cpu_has_local_ebase)
>>> +            build_r3000_tlb_refill_handler();
>>>           if (!run_once) {
>>> +            if (!cpu_has_local_ebase)
>>> +                build_r3000_tlb_refill_handler();
>>>               build_r3000_tlb_load_handler();
>>>               build_r3000_tlb_store_handler();
>>>               build_r3000_tlb_modify_handler();
>>> @@ -2192,9 +2195,12 @@ void __cpuinit build_tlb_refill_handler(void)
>>>               build_r4000_tlb_load_handler();
>>>               build_r4000_tlb_store_handler();
>>>               build_r4000_tlb_modify_handler();
>>> +            if (!cpu_has_local_ebase)
>>> +                build_r4000_tlb_refill_handler();
>>>               run_once++;
>>>           }
>>> -        build_r4000_tlb_refill_handler();
>>> +        if (cpu_has_local_ebase)
>>> +            build_r4000_tlb_refill_handler();
>>>       }
>>>   }
>>>
>>>
>>
>
>
