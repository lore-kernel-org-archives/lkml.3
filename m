Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaLWUxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:53:55 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61234 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaLWUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:53:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141223210644.18555fd1pl418u38@webmail.upv.es>
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es> <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es> <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
 <20141222183615.4193722q3opf4uj3@webmail.upv.es> <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
 <20141223002347.18271w0cdr8gba4j@webmail.upv.es> <CALCETrU+NPQexUMDCxdram-gSFtGzrQOoyekfCaXwdwebcnxSg@mail.gmail.com>
 <CAH4rwTKeN0P84FJnocoKV4t9rc2Ox_EYc+LEibD+Y83n7C8aVA@mail.gmail.com>
 <CALCETrUZdvzasLgMUwHW1N+Gu+dqS+xsZeP=eKuXRDj8v5C+ag@mail.gmail.com> <20141223210644.18555fd1pl418u38@webmail.upv.es>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Dec 2014 12:53:31 -0800
Message-ID: <CALCETrVLEKRUexWgybhtEVLpnc1NygP9PeZEhig34JyaP27cTg@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
To: Hector Marco Gisbert <hecmargi@upv.es>
Cc: Reno Robert <renorobert@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:06 PM, Hector Marco Gisbert <hecmargi@upv.es> wrote:
> [PATCH] ASLRv3: inter-mmap ASLR (IM-ASLR).
>
>
> The following is a patch that implements the inter-mmap (IM-ASLR)
> which randomizes all mmaps. All the discussion about the current
> implementation (offset2lib and vdso) shall be solved by fixing
> the current implementation (randomize_va_space =2).

General comments:

You have a bunch of copies of roughly this:

+       unsigned long brk;
+       unsigned long min_addr = PAGE_ALIGN(mmap_min_addr);
+       unsigned long max_addr = PAGE_ALIGN(current->mm->mmap_b
ase);
+
+       if ( (randomize_va_space > 2) && !is_compat_task() ){
+               brk = (get_random_long() << PAGE_SHIFT) % (max_addr - min_addr);
+               brk += min_addr;
+               return brk;
+       }

I would write one helper that does that.  I would also make a few changes:

 - Use get_random_bytes instead of get_random_long.

 - is_compat_task is wrong.  It returns true when called in the
context of a compat syscall, which isn't what you want in most cases.

 - For architectures with large enough max_addr - min_addr, you are
needlessly biasing your result.  How about:

(random_long % ((max - min) >> PAGE_SHIFT)) << PAGE_SHIFT

I also think that you should restrict the fully randomized range to
one quarter or one half of the total address space.  Things like the
Chromium sandbox need enormous amounts of contiguous virtual address
space to play in.  Also, you should make sure that a randomized mmap
never gets in the way of the stack or brk (maybe you're already doing
this).  Otherwise you'll have intermittent crashes.

--Andy

>
> While we were working in the offset2lib we realized that
> a complete solution would to randomize each mmap independently.
> (as reno has suggested). Here is patch to achieve that and I
> discussion about it.
>
> First of all, I think that IM-ASLR is not mandatory, considering
> current attacks and technology. Note that it very risky to make any
> sound claim about what is secure and what is not. So, take the first
> claim with caution.
>
> IM-ASLR requires a large virtual memory space to avoid fragmentation
> problems (see below), therefore, I think that it is only practical on
> 64 bit systems.
>
> IM-ASLR will be the most advanced ASLR implementation overpassing
> PaX ASLR. The present patch will prevent future threats (or current
> threats, but unknown to me). It would be nice have it in Linux, but
> a trade-off between security and performance shall be done before
> adopting it as a default option.
>
> Since the implementation is very simple and straight forward, I
> suggest to include it as randomize_va_space=3. This way, it may
> be enabled on a per process basis (personality).
>
> Another aspect to think about is: Does this code adds or opens a new
> backdoor or weakness? I don't think so. The code and the operation is
> really simple, and it does not have side effects as far as I see.
>
> Current implementations are based on the basic idea of "zones" of
> similar or comparable criticality. Now we are discussing about where
> the VDSO shall be placed, and if it shall be close to the stack zone
> or on the mmap zone. Well, IM-ASLR solves this problem at once: all
> objects are located on its own isolated "zone". In this sense, the
> IM-ASLR removes most of the philosophical or subjective
> arguments... which are always hard to justify.
>
> Eventually, if the IM-ASLR is effective, we will set it by default for
> all apps.
>
>
>
> Regarding fragmentation:
>
> 2^46 is a huge virtual space, it is so large that fragmentation will
> not be a problem. Just doing some numbers, you can understand the
> extremely low probability of having problems due to fragmentation.
>
> Let's suppose that the largest mmaped request is 1Gb. The worst case
> scenario to fail a request is when the memory is fragmented in such a
> way that all the free areas are of size (1Gb-4kb).
>
> free     busy free    busy free     busy .....free
> [1Gb-4kb][4kb][1G-4kb][4kb][1Gb-4kb][4kb].....[1Gb-4kb]..
>
> This is a perfectly doomsday case.
>
> Well, in this case the number of allocated (busy) mmaped areas of 4kb
> needed to fragment the memory is:
>
> 2^46/2^30= 2^16.
>
> That is, an application shall request > 64000 mmaps of one page
> (4kb). And then, if it is extremely unlucky, the next mmap of 1Gb will
> fail.
>
> Obviously, we assume that all the 64000 request are "perfectly" placed
> at 1Gb distance of each other. The probability that such a perfectly
> space allocs occur is less than one out of (2^46)^(2^16). This is a
> fairly "impossible" event.
>
> Conclusion: Fragmentation is not a issue. We shall be more worried
> about hitting a comet our city than running out of memory because of
> fragmentation.
>
> Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
> Signed-off-by: Ismael Ripoll <iripoll@upv.es>
>
> diff --git a/Documentation/sysctl/kernel.txt
> b/Documentation/sysctl/kernel.txt
> index 75511ef..dde92ee 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -704,6 +704,18 @@ that support this feature.
>      with CONFIG_COMPAT_BRK enabled, which excludes the heap from process
>      address space randomization.
>
> +3 - Inter-mmap randomization and extended entropy. Randomizes all
> +    mmap requests when the addr is NULL.
> +
> +    This is an improvement of the previous ASLR option which:
> +    a) extend the number of random bits on the addresses and
> +    b) add randomness to the offset between mmapped objects.
> +
> +    This feature is only available on architectures which implement
> +    large virtual memory space (i.e. 64bit systems). In 32bits, the
> +    fragmentation can be a problem for applications which use large
> +    memory areas.
> +
>  ==============================================================
>
>  reboot-cmd: (Sparc only)
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b1f9a20..380873f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1,6 +1,7 @@
>  config ARM64
>         def_bool y
>         select ARCH_BINFMT_ELF_RANDOMIZE_PIE
> +       select RANDOMIZE_ALL_MMAPS
>         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>         select ARCH_HAS_GCOV_PROFILE_ALL
>         select ARCH_HAS_SG_CHAIN
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index fde9923..2b54bbe 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -43,6 +43,9 @@
>  #include <linux/hw_breakpoint.h>
>  #include <linux/personality.h>
>  #include <linux/notifier.h>
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +#include <linux/security.h>
> +#endif
>
>  #include <asm/compat.h>
>  #include <asm/cacheflush.h>
> @@ -376,5 +379,16 @@ static unsigned long randomize_base(unsigned long base)
>
>  unsigned long arch_randomize_brk(struct mm_struct *mm)
>  {
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +        unsigned long brk;
> +        unsigned long min_addr = PAGE_ALIGN(mmap_min_addr);
> +        unsigned long max_addr = PAGE_ALIGN(current->mm->mmap_base);
> +
> +        if ( (randomize_va_space > 2) && !is_compat_task() ){
> +                brk = (get_random_long() << PAGE_SHIFT) % (max_addr -
> min_addr);
> +                brk += min_addr;
> +                return brk;
> +        }
> +#endif
>         return randomize_base(mm->brk);
>  }
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ba397bd..2607ce9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -86,6 +86,7 @@ config X86
>         select HAVE_ARCH_KMEMCHECK
>         select HAVE_USER_RETURN_NOTIFIER
>         select ARCH_BINFMT_ELF_RANDOMIZE_PIE
> +       select RANDOMIZE_ALL_MMAPS if X86_64
>         select HAVE_ARCH_JUMP_LABEL
>         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>         select SPARSE_IRQ
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e127dda..7b7745d 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -19,6 +19,9 @@
>  #include <linux/cpuidle.h>
>  #include <trace/events/power.h>
>  #include <linux/hw_breakpoint.h>
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +#include <linux/security.h>
> +#endif
>  #include <asm/cpu.h>
>  #include <asm/apic.h>
>  #include <asm/syscalls.h>
> @@ -465,7 +468,18 @@ unsigned long arch_align_stack(unsigned long sp)
>
>  unsigned long arch_randomize_brk(struct mm_struct *mm)
>  {
> -       unsigned long range_end = mm->brk + 0x02000000;
> -       return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +       unsigned long brk;
> +       unsigned long min_addr = PAGE_ALIGN(mmap_min_addr);
> +       unsigned long max_addr = PAGE_ALIGN(current->mm->mmap_base);
> +
> +       if ( (randomize_va_space > 2) && !is_compat_task() ){
> +               brk = (get_random_long() << PAGE_SHIFT) % (max_addr -
> min_addr);
> +               brk += min_addr;
> +               return brk;
> +       }
> +#endif
> +
> +       return randomize_range(mm->brk, mm->brk + 0x02000000, 0) ? :
> mm->brk;
>  }
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 009495b..205f1a3 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -19,6 +19,9 @@
>  #include <asm/page.h>
>  #include <asm/hpet.h>
>  #include <asm/desc.h>
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +#include <asm/compat.h>
> +#endif
>
>  #if defined(CONFIG_X86_64)
>  unsigned int __read_mostly vdso64_enabled = 1;
> @@ -54,6 +57,11 @@ static unsigned long vdso_addr(unsigned long start,
> unsigned len)
>  #else
>         unsigned long addr, end;
>         unsigned offset;
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +       if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 2)
> +           && !is_compat_task())
> +               return 0;
> +#endif
>         end = (start + PMD_SIZE - 1) & PMD_MASK;
>         if (end >= TASK_SIZE_MAX)
>                 end = TASK_SIZE_MAX;
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 04645c0..f6a231f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1740,6 +1740,13 @@ unsigned int get_random_int(void)
>  }
>  EXPORT_SYMBOL(get_random_int);
>
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +unsigned long get_random_long(void)
> +{
> +       return get_random_int() + (sizeof(long) > 4 ? (unsigned
> long)get_random_int() << 32 : 0);
> +}
> +EXPORT_SYMBOL(get_random_long);
> +#endif
>  /*
>   * randomize_range() returns a start address such that
>   *
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index c055d56..2839124 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -30,6 +30,9 @@ config COMPAT_BINFMT_ELF
>  config ARCH_BINFMT_ELF_RANDOMIZE_PIE
>         bool
>
> +config RANDOMIZE_ALL_MMAPS
> +       bool
> +
>  config ARCH_BINFMT_ELF_STATE
>         bool
>
> diff --git a/include/linux/random.h b/include/linux/random.h
> index b05856e..8ea61e1 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -23,6 +23,9 @@ extern const struct file_operations random_fops,
> urandom_fops;
>  #endif
>
>  unsigned int get_random_int(void);
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +unsigned long get_random_long(void);
> +#endif
>  unsigned long randomize_range(unsigned long start, unsigned long end,
> unsigned long len);
>
>  u32 prandom_u32(void);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7b36aa7..8c9c3c7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -41,6 +41,10 @@
>  #include <linux/notifier.h>
>  #include <linux/memory.h>
>  #include <linux/printk.h>
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +#include <linux/random.h>
> +#include <asm/compat.h>
> +#endif
>
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> @@ -2005,7 +2009,19 @@ get_unmapped_area(struct file *file, unsigned long
> addr, unsigned long len,
>         unsigned long (*get_area)(struct file *, unsigned long,
>                                   unsigned long, unsigned long, unsigned
> long);
>
> -       unsigned long error = arch_mmap_check(addr, len, flags);
> +       unsigned long error;
> +#ifdef CONFIG_RANDOMIZE_ALL_MMAPS
> +       unsigned long min_addr = PAGE_ALIGN(mmap_min_addr);
> +       unsigned long max_addr = PAGE_ALIGN(current->mm->mmap_base);
> +
> +       /* ASRLv3: If addr is NULL then randomize the mmap */
> +       if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 2)
> +           && !is_compat_task() && !addr ){
> +               addr = (get_random_long() << PAGE_SHIFT) % (max_addr -
> min_addr);
> +               addr += min_addr;
> +       }
> +#endif
> +       error = arch_mmap_check(addr, len, flags);
>         if (error)
>                 return error;
>
>
>
> Hector Marco.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
