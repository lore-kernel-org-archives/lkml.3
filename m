Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaDEAHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:07:54 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48909 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaDEAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140404195818.GA21028@debian>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
	<1396577719-14786-3-git-send-email-keescook@chromium.org>
	<20140404195818.GA21028@debian>
Date: Fri, 4 Apr 2014 17:07:52 -0700
X-Google-Sender-Auth: c9wQTOc25qUIfBcS-tpLA7fMbg8
Message-ID: <CAGXu5jKPX2igsb2rQzdCZQZ8X3h4YZihCV9D+cDW3F+qii8H2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: make text and rodata read-only
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 12:58 PM, Rabin Vincent <rabin@rab.in> wrote:
> On Thu, Apr 03, 2014 at 07:15:19PM -0700, Kees Cook wrote:
>> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
>> index 34e56647dcee..4ae343c1e2a3 100644
>> --- a/arch/arm/kernel/ftrace.c
>> +++ b/arch/arm/kernel/ftrace.c
>> @@ -14,6 +14,7 @@
>>
>>  #include <linux/ftrace.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/stop_machine.h>
>>
>>  #include <asm/cacheflush.h>
>>  #include <asm/opcodes.h>
>> @@ -34,6 +35,22 @@
>>
>>  #define      OLD_NOP         0xe1a00000      /* mov r0, r0 */
>>
>> +static int __ftrace_modify_code(void *data)
>
> This is in the CONFIG_OLD_MCOUNT ifdef, but should be in the outer ifdef
> (CONFIG_DYNAMIC_FTRACE) instead, otherwise it will not get enabled for
> for example Thumb-2 kernels.  This was wrong in my example patch too.

Ah! Yes, good point. I've moved this now.

>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 8539eb2a01ad..3baac4ad165f 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -681,30 +716,52 @@ static inline bool arch_has_strict_perms(void)
>>       return true;
>>  }
>>
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
>>  static inline void fix_kernmem_perms(void)
>>  {
>> -     unsigned long addr;
>> -     unsigned int i;
>> +     set_section_perms(nx_perms, prot);
>> +}
>>
>> -     if (!arch_has_strict_perms())
>> -             return;
>> +#ifdef CONFIG_DEBUG_RODATA
>> +void mark_rodata_ro(void)
>> +{
>> +     set_section_perms(ro_perms, prot);
>> +}
>>
>> -     for (i = 0; i < ARRAY_SIZE(section_perms); i++) {
>> -             if (!IS_ALIGNED(section_perms[i].start, SECTION_SIZE) ||
>> -                 !IS_ALIGNED(section_perms[i].end, SECTION_SIZE)) {
>> -                     pr_err("BUG: section %lx-%lx not aligned to %lx\n",
>> -                             section_perms[i].start, section_perms[i].end,
>> -                             SECTION_SIZE);
>> -                     continue;
>> -             }
>> +void set_kernel_text_rw(void)
>> +{
>> +     set_section_perms(ro_perms, clear);
>> +}
>
> You need a TLB flush.  I had a flush_tlb_all() in my example patch,
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/244335.html,
> but the following is probably nicer (on top of this patch):
>
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 9bea524..a92c45a 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -741,6 +741,8 @@ static inline bool arch_has_strict_perms(void)
>                      addr += SECTION_SIZE)                              \
>                         section_update(addr, perms[i].mask,             \
>                                        perms[i].field);                 \
> +                                                                       \
> +               flush_tlb_kernel_range(perms[i].start, perms[i].end);   \
>         }                                                               \
>  }
>

When I do this, I hang the system, and get a WARN due to the tlb call
attempting to flush on all CPUs, I think:

[   34.246034] WARNING: at
/mnt/host/source/src/third_party/kernel-next/kernel/smp.c:466
smp_call_function_many+0xac/0x26c()
...
[   34.246617] Backtrace:
[   34.246697] [<c010d3b8>] (unwind_backtrace+0x0/0x118) from
[<c060b9d8>] (dump_stack+0x28/0x30)
[   34.246765] [<c060b9d8>] (dump_stack+0x28/0x30) from [<c0123044>]
(warn_slowpath_null+0x44/0x5c)
[   34.246824] [<c0123044>] (warn_slowpath_null+0x44/0x5c) from
[<c017426c>] (smp_call_function_many+0xac/0x26c)
[   34.246881] [<c017426c>] (smp_call_function_many+0xac/0x26c) from
[<c0174468>] (smp_call_function+0x3c/0x48)
[   34.246937] [<c0174468>] (smp_call_function+0x3c/0x48) from
[<c010c0fc>] (broadcast_tlb_a15_erratum+0x40/0x4c)
[   34.246994] [<c010c0fc>] (broadcast_tlb_a15_erratum+0x40/0x4c) from
[<c010c590>] (flush_tlb_kernel_range+0x74/0xa0)
[   34.247046] [<c010c590>] (flush_tlb_kernel_range+0x74/0xa0) from
[<c011403c>] (set_kernel_text_rw+0xd8/0xec)
[   34.247099] [<c011403c>] (set_kernel_text_rw+0xd8/0xec) from
[<c010c878>] (__ftrace_modify_code+0x14/0x28)
[   34.247156] [<c010c878>] (__ftrace_modify_code+0x14/0x28) from
[<c0184318>] (stop_machine_cpu_stop+0xc0/0x114)
[   34.247212] [<c0184318>] (stop_machine_cpu_stop+0xc0/0x114) from
[<c01841cc>] (cpu_stopper_thread+0xd8/0x164)
[   34.247266] [<c01841cc>] (cpu_stopper_thread+0xd8/0x164) from
[<c0145c14>] (kthread+0xc8/0xd8)
[   34.247323] [<c0145c14>] (kthread+0xc8/0xd8) from [<c0106118>]
(ret_from_fork+0x14/0x20)

Using local_flush_tlb_kernel_range() fixed it though. Thank you for
your help on this! :)

-Kees

-- 
Kees Cook
Chrome OS Security
