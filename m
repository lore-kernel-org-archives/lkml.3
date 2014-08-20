Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaHTMhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:37:19 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53432 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaHTMhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140819123342.GJ23128@arm.com>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
	<1407949593-16121-8-git-send-email-keescook@chromium.org>
	<20140819123342.GJ23128@arm.com>
Date: Wed, 20 Aug 2014 07:37:14 -0500
X-Google-Sender-Auth: eBlVHmOnYxKb-dAK8eRmlrx5twE
Message-ID: <CAGXu5jLnXeavr4E4YF9jtB03iA-y4vLZjf83a8ABzUC-hdkz9w@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] ARM: mm: allow non-text sections to be non-executable
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 7:33 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Aug 13, 2014 at 06:06:32PM +0100, Kees Cook wrote:
>> Adds CONFIG_ARM_KERNMEM_PERMS to separate the kernel memory regions
>> into section-sized areas that can have different permisions. Performs
>> the NX permission changes during free_initmem, so that init memory can be
>> reclaimed.
>>
>> This uses section size instead of PMD size to reduce memory lost to
>> padding on non-LPAE systems.
>>
>> Based on work by Brad Spengler, Larry Bassel, and Laura Abbott.
>
> [...]
>
>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index 6f57cb94367f..a3d07ca2bbb4 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -8,6 +8,9 @@
>>  #include <asm/thread_info.h>
>>  #include <asm/memory.h>
>>  #include <asm/page.h>
>> +#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#include <asm/pgtable.h>
>> +#endif
>>
>>  #define PROC_INFO                                                    \
>>       . = ALIGN(4);                                                   \
>> @@ -90,6 +93,11 @@ SECTIONS
>>               _text = .;
>>               HEAD_TEXT
>>       }
>> +
>> +#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +     . = ALIGN(1<<SECTION_SHIFT);
>> +#endif
>> +
>>       .text : {                       /* Real text segment            */
>>               _stext = .;             /* Text and read-only data      */
>>                       __exception_text_start = .;
>> @@ -145,7 +153,11 @@ SECTIONS
>>       _etext = .;                     /* End of text and rodata section */
>>
>>  #ifndef CONFIG_XIP_KERNEL
>> +# ifdef CONFIG_ARM_KERNMEM_PERMS
>> +     . = ALIGN(1<<SECTION_SHIFT);
>> +# else
>>       . = ALIGN(PAGE_SIZE);
>> +# endif
>
> This might be cleaner if we had a single macro (ALIGN_MIN?) that expanded to
> ALIGN(1 << SECTION_SHIFT) #ifdef  CONFIG_ARM_KERNMEM_PERMS.

I didn't see a cleaner way to do this, since some times it's optional
(no alignment instead of different alignment), and sometimes it's not
controlled by _KERNMEM_PERMS (i.e. sometimes it's _DEBUG_RODATA).

>
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index ad82c05bfc3a..ccf392ef40d4 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -32,6 +32,11 @@
>>  #include <asm/tlb.h>
>>  #include <asm/fixmap.h>
>>
>> +#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#include <asm/system_info.h>
>> +#include <asm/cp15.h>
>> +#endif
>
> We already #include cp15.h in this file. If you need system_info.h, I don't
> think you should bother making the include conditional.

Ah, yes. I will fix this.

>
>> +/*
>> + * Updates section permissions only for the current mm (sections are
>> + * copied into each mm). During startup, this is the init_mm.
>> + */
>> +static inline void section_update(unsigned long addr, pmdval_t mask,
>> +                               pmdval_t prot)
>> +{
>> +     struct mm_struct *mm;
>> +     pmd_t *pmd;
>> +
>> +     mm = current->active_mm;
>> +     pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
>> +
>> +#ifdef CONFIG_ARM_LPAE
>> +     pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
>> +#else
>> +     if (addr & SECTION_SIZE)
>> +             pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
>> +     else
>> +             pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
>> +#endif
>> +     flush_pmd_entry(pmd);
>> +     local_flush_tlb_kernel_range(addr, addr + SECTION_SIZE);
>
> Why only a local flush? You're changing global mappings here, right?

Yes, but with the a15 errata, it cannot use a global flush. As a
result, section_update can only be used by a single CPU which is how
the usage is managed. Perhaps I should add some comments to that
effect? (There was a thread a few months ago on this problem and this
shook out as a solution.)

>
>> +}
>> +
>> +/* Make sure extended page tables are in use. */
>> +static inline bool arch_has_strict_perms(void)
>> +{
>> +     unsigned int cr;
>> +
>> +     if (cpu_architecture() < CPU_ARCH_ARMv6)
>> +             return false;
>> +
>> +     cr = get_cr();
>> +     if (!(cr & CR_XP))
>> +             return false;
>> +
>> +     return true;
>
> return !!(get_cr() & CR_XP)?

Sure, I can reduce this.

>
>> +}
>> +
>> +#define set_section_perms(perms, field)      {                               \
>> +     size_t i;                                                       \
>> +     unsigned long addr;                                             \
>> +                                                                     \
>> +     if (!arch_has_strict_perms())                                   \
>> +             return;                                                 \
>> +                                                                     \
>> +     for (i = 0; i < ARRAY_SIZE(perms); i++) {                       \
>> +             if (!IS_ALIGNED(perms[i].start, SECTION_SIZE) ||        \
>> +                 !IS_ALIGNED(perms[i].end, SECTION_SIZE)) {          \
>> +                     pr_err("BUG: section %lx-%lx not aligned to %lx\n", \
>> +                             perms[i].start, perms[i].end,           \
>> +                             SECTION_SIZE);                          \
>> +                     continue;                                       \
>> +             }                                                       \
>> +                                                                     \
>> +             for (addr = perms[i].start;                             \
>> +                  addr < perms[i].end;                               \
>> +                  addr += SECTION_SIZE)                              \
>> +                     section_update(addr, perms[i].mask,             \
>> +                                    perms[i].field);                 \
>> +     }                                                               \
>> +}
>> +
>> +static inline void fix_kernmem_perms(void)
>> +{
>> +     set_section_perms(nx_perms, prot);
>> +}
>> +#else
>> +static inline void fix_kernmem_perms(void) { }
>> +#endif /* CONFIG_ARM_KERNMEM_PERMS */
>> +
>>  void free_initmem(void)
>>  {
>>  #ifdef CONFIG_HAVE_TCM
>>       extern char __tcm_start, __tcm_end;
>> +#endif
>> +
>> +     fix_kernmem_perms();
>>
>> +#ifdef CONFIG_HAVE_TCM
>
> You could avoid the double #ifdef by moving the tcm stuff into another
> function (free_tcmmem?)

Sure, I can do that.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
