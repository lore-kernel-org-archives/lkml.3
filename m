Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3HJRXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:23:40 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:51673 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3HJRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1308101849350.32627@pobox.suse.cz>
References: <201308091951.r79JppCI030998@farm-0021.internal.tilera.com>
	<alpine.LNX.2.00.1308101849350.32627@pobox.suse.cz>
Date: Sat, 10 Aug 2013 19:23:38 +0200
Message-ID: <CAFLxGvz-2-9OX1BC0-UbLEeHVZSi9JoKbcLVrYR8ZjBdRiRQwg@mail.gmail.com>
Subject: Re: [PATCH] tile: support ASLR fully
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tony Lu <zlu@tilera.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 6:55 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 9 Aug 2013, Tony Lu wrote:
>
>> With this change, tile Linux now supports address-space layout
>> randomization for shared objects, stack, heap and vdso.
>>
>> Signed-off-by: Tony Lu <zlu@tilera.com>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>>  arch/tile/include/asm/elf.h |  4 ++++
>>  arch/tile/mm/mmap.c         | 20 ++++++++++++++++++--
>>  2 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
>> index 31d854f..e1da88e 100644
>> --- a/arch/tile/include/asm/elf.h
>> +++ b/arch/tile/include/asm/elf.h
>> @@ -137,6 +137,10 @@ do { \
>>       NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE); \
>>  } while (0)
>>
>> +struct mm_struct;
>> +extern unsigned long arch_randomize_brk(struct mm_struct *mm);
>> +#define arch_randomize_brk arch_randomize_brk
>> +
>>  #ifdef CONFIG_COMPAT
>>
>>  #define COMPAT_ELF_PLATFORM "tilegx-m32"
>> diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
>> index d67d91e..b3686ce 100644
>> --- a/arch/tile/mm/mmap.c
>> +++ b/arch/tile/mm/mmap.c
>> @@ -58,16 +58,32 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>>  #else
>>       int is_32bit = 0;
>>  #endif
>> +     unsigned long random_factor = 0UL;
>> +
>> +     if (current->flags & PF_RANDOMIZE) {
>> +             random_factor = get_random_int();
>> +             random_factor = random_factor << PAGE_SHIFT;
>> +             if (is_32bit)
>> +                     random_factor &= 0xfffffful;
>> +             else
>> +                     random_factor &= 0xffffffful;
>> +     }
>
> Hi Tony,
>
> to me, the used math seems not to be immediatley understandable on a first
> sight. Instead of using full range of get_random_int() and then clamping
> it by anding with 0xffffffUL or fffffffUL, how about just using
> appropriate division reminder to the result of get_random_int()? (for
> inspiration and for understanding of what I mean, please see what
> mmap_rnd() is doing on x86).

Looks like copy&paste from some other arch's implementation.
IMHO it's time to consolidate all the different but still mostly identical
arch_pick_mmap_layout() implementations.

>>
>>       /*
>>        * Use standard layout if the expected stack growth is unlimited
>>        * or we are running native 64 bits.
>>        */
>> -     if (!is_32bit || rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
>> -             mm->mmap_base = TASK_UNMAPPED_BASE;
>> +     if (rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
>> +             mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
>>               mm->get_unmapped_area = arch_get_unmapped_area;
>>       } else {
>>               mm->mmap_base = mmap_base(mm);
>>               mm->get_unmapped_area = arch_get_unmapped_area_topdown;
>>       }
>>  }
>> +
>> +unsigned long arch_randomize_brk(struct mm_struct *mm)
>> +{
>> +     unsigned long range_end = mm->brk + 0x02000000;
>> +     return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
>> +}
>
> Otherwise the patch looks good to me, so once you either add some
> explanatory comment to the get_random_int() math, or convert it to use
> division reminder, I'll be happy to Ack it.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
