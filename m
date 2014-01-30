Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaA3SSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:18:05 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33852 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaA3SSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <1391078953-1575-4-git-send-email-stefani@seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net> <1391078953-1575-4-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 10:17:42 -0800
Message-ID: <CALCETrWCgLYS0_+EjpxuFFgQ_wpRAihQM_fX0uHAezmp82upTw@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO support for 32 kernel
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 2:49 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the support for 32 bit VDSO to a 32 bit kernel.
>
> For 32 bit programs running on a 32 bit kernel, the same mechanism is
> used as for 64 bit programs running on a 64 bit kernel.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/elf.h            |   2 +-
>  arch/x86/include/asm/vdso.h           |   3 +
>  arch/x86/include/asm/vdso32.h         |  10 +++
>  arch/x86/vdso/Makefile                |   7 ++
>  arch/x86/vdso/vclock_gettime.c        | 165 ++++++++++++++++++++++------------
>  arch/x86/vdso/vdso-layout.lds.S       |  25 ++++++
>  arch/x86/vdso/vdso32-setup.c          |  45 ++++++++--
>  arch/x86/vdso/vdso32/vclock_gettime.c |  16 ++++
>  arch/x86/vdso/vdso32/vdso32.lds.S     |  14 ++-
>  9 files changed, 219 insertions(+), 68 deletions(-)
>  create mode 100644 arch/x86/include/asm/vdso32.h
>  create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c
>
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index 9c999c1..21bae90 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -289,7 +289,7 @@ do {                                                                        \
>
>  #else /* CONFIG_X86_32 */
>
> -#define VDSO_HIGH_BASE         0xffffe000U /* CONFIG_COMPAT_VDSO address */
> +#define VDSO_HIGH_BASE         0xffffc000U /* CONFIG_COMPAT_VDSO address */
>
>  /* 1GB for 64bit, 8MB for 32bit */
>  #define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
> diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
> index fddb53d..fe3cef9 100644
> --- a/arch/x86/include/asm/vdso.h
> +++ b/arch/x86/include/asm/vdso.h
> @@ -2,6 +2,9 @@
>  #define _ASM_X86_VDSO_H
>
>  #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
> +
> +#include <asm/vdso32.h>
> +
>  extern const char VDSO32_PRELINK[];
>
>  /*
> diff --git a/arch/x86/include/asm/vdso32.h b/arch/x86/include/asm/vdso32.h
> new file mode 100644
> index 0000000..7dd2eb8
> --- /dev/null
> +++ b/arch/x86/include/asm/vdso32.h
> @@ -0,0 +1,10 @@
> +#ifndef _ASM_X86_VDSO32_H
> +#define _ASM_X86_VDSO32_H
> +
> +#define VDSO_BASE_PAGE 0
> +#define VDSO_VVAR_PAGE 1
> +#define VDSO_HPET_PAGE 2
> +#define        VDSO_PAGES      3
> +#define        VDSO_OFFSET(x)  ((x) * PAGE_SIZE)
> +
> +#endif
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index fd14be1..1ff5b0a 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -145,8 +145,15 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
>  $(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
>  $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
>
> +KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
> +KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
> +KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
> +KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3 -freg-struct-return -fpic
> +$(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
> +
>  $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
>                                  $(obj)/vdso32/vdso32.lds \
> +                                $(obj)/vdso32/vclock_gettime.o \
>                                  $(obj)/vdso32/note.o \
>                                  $(obj)/vdso32/%.o
>         $(call if_changed,vdso)
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index eb5d7a5..19b2a49 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -4,6 +4,9 @@
>   *
>   * Fast user context implementation of clock_gettime, gettimeofday, and time.
>   *
> + * 32 Bit compat layer by Stefani Seibold <stefani@seibold.net>
> + *  sponsored by Rohde & Schwarz GmbH & Co. KG Munich/Germany
> + *
>   * The code should have no internal unresolved relocations.
>   * Check with readelf after changing.
>   */
> @@ -24,45 +27,78 @@
>  #include <asm/io.h>
>  #include <asm/pvclock.h>
>
> +#ifndef BUILD_VDSO32
> +
>  #define gtod (&VVAR(vsyscall_gtod_data))

Is it possible

>
> -notrace static cycle_t vread_tsc(void)
> +static notrace cycle_t vread_hpet(void)
>  {
> -       cycle_t ret;
> -       u64 last;
> -
> -       /*
> -        * Empirically, a fence (of type that depends on the CPU)
> -        * before rdtsc is enough to ensure that rdtsc is ordered
> -        * with respect to loads.  The various CPU manuals are unclear
> -        * as to whether rdtsc can be reordered with later loads,
> -        * but no one has ever seen it happen.
> -        */
> -       rdtsc_barrier();
> -       ret = (cycle_t)vget_cycles();
> +       return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
> +}
>
> -       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
> +notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> +{
> +       long ret;
> +       asm("syscall" : "=a" (ret) :
> +           "0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
> +       return ret;
> +}
>
> -       if (likely(ret >= last))
> -               return ret;
> +notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
> +{
> +       long ret;
>
> -       /*
> -        * GCC likes to generate cmov here, but this branch is extremely
> -        * predictable (it's just a funciton of time and the likely is
> -        * very likely) and there's a data dependence, so force GCC
> -        * to generate a branch instead.  I don't barrier() because
> -        * we don't actually need a barrier, and if this function
> -        * ever gets inlined it will generate worse code.
> -        */
> -       asm volatile ("");
> -       return last;
> +       asm("syscall" : "=a" (ret) :
> +           "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
> +       return ret;
>  }
> +#else
> +
> +struct vsyscall_gtod_data vvar_vsyscall_gtod_data
> +       __attribute__((visibility("hidden")));
> +
> +u32 hpet_counter
> +       __attribute__((visibility("hidden")));
> +
> +#define gtod (&vvar_vsyscall_gtod_data)

Is it possible to keep the VVAR macro working for this?  It'll keep
this code more unified and make it easier for anyone who tries to add
vgetcpu support.

>         if (compat_uses_vma || !compat) {
> -               /*
> -                * MAYWRITE to allow gdb to COW and set breakpoints
> -                */
> -               ret = install_special_mapping(mm, addr, PAGE_SIZE,
> -                                             VM_READ|VM_EXEC|
> -                                             VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
> -                                             vdso32_pages);
> +
> +               vma = _install_special_mapping(mm,
> +                       addr,
> +                       VDSO_OFFSET(VDSO_PAGES),
> +                       VM_READ|VM_EXEC,
> +                       vdso32_pages);
> +
> +               if (IS_ERR(vma)) {
> +                       ret = PTR_ERR(vma);
> +                       goto up_fail;
> +               }
> +
> +               ret = remap_pfn_range(vma,
> +                       vma->vm_start + VDSO_OFFSET(VDSO_VVAR_PAGE),
> +                       __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
> +                       PAGE_SIZE,
> +                       PAGE_READONLY);
>
>                 if (ret)
>                         goto up_fail;
> +
> +#ifdef CONFIG_HPET_TIMER
> +               if (hpet_address) {
> +                       ret = io_remap_pfn_range(vma,
> +                               vma->vm_start + VDSO_OFFSET(VDSO_HPET_PAGE),
> +                               hpet_address >> PAGE_SHIFT,
> +                               PAGE_SIZE,
> +                               pgprot_noncached(PAGE_READONLY));
> +
> +                       if (ret)
> +                               goto up_fail;
> +               }
> +#endif
>         }

Now I'm confused.  What's the fixmap stuff for?  Isn't this sufficient?

Also, presumably remap_pfn_range is already smart enough to prevent
mprotect and ptrace from doing evil things.

>
> @@ -19,11 +22,17 @@ ENTRY(__kernel_vsyscall);
>   */
>  VERSION
>  {
> -       LINUX_2.5 {
> +       LINUX_2.6 {
>         global:
>                 __kernel_vsyscall;
>                 __kernel_sigreturn;
>                 __kernel_rt_sigreturn;
> +               clock_gettime;
> +               __vdso_clock_gettime;
> +               gettimeofday;
> +               __vdso_gettimeofday;
> +               time;
> +               __vdso_time;
>         local: *;

Please remove the functions that don't start with __vdso -- I don't
think they serve any purpose.  They can be confusing, since they're
not interchangeable with the glibc functions of the same name.  (The
64-bit vdso needs them for historical reasons.)

--Andy
