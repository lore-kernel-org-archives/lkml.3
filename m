Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaA3SF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:05:26 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39113 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaA3SFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <1391078953-1575-2-git-send-email-stefani@seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net> <1391078953-1575-2-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 10:05:04 -0800
Message-ID: <CALCETrXqnrDu=rceAm++bGLicj44FfYsxm9-KvqU=B1zkei9TA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Make vsyscall_gtod_data handling x86 generic
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
> This patch move the vsyscall_gtod_data handling out of vsyscall_64.c
> into an additonal file vsyscall_gtod.c to make the functionality
> available for x86 32 bit kernel.
>
> It also adds a new vsyscall_32.c which setup the VVAR page.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/Kconfig                   |  5 +--
>  arch/x86/include/asm/clocksource.h |  4 --
>  arch/x86/include/asm/compat.h      |  5 +++
>  arch/x86/include/asm/fixmap.h      |  2 +
>  arch/x86/include/asm/vvar.h        |  4 ++
>  arch/x86/kernel/Makefile           |  3 +-
>  arch/x86/kernel/hpet.c             |  4 --
>  arch/x86/kernel/setup.c            |  2 -
>  arch/x86/kernel/tsc.c              |  2 -
>  arch/x86/kernel/vmlinux.lds.S      |  3 --
>  arch/x86/kernel/vsyscall_32.c      | 53 ++++++++++++++++++++++++
>  arch/x86/kernel/vsyscall_64.c      | 43 --------------------
>  arch/x86/kernel/vsyscall_gtod.c    | 82 ++++++++++++++++++++++++++++++++++++++
>  13 files changed, 150 insertions(+), 62 deletions(-)
>  create mode 100644 arch/x86/kernel/vsyscall_32.c
>  create mode 100644 arch/x86/kernel/vsyscall_gtod.c
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3e97a3d..cdb01aa 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -106,9 +106,9 @@ config X86
>         select HAVE_ARCH_SOFT_DIRTY
>         select CLOCKSOURCE_WATCHDOG
>         select GENERIC_CLOCKEVENTS
> -       select ARCH_CLOCKSOURCE_DATA if X86_64
> +       select ARCH_CLOCKSOURCE_DATA
>         select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
> -       select GENERIC_TIME_VSYSCALL if X86_64
> +       select GENERIC_TIME_VSYSCALL
>         select KTIME_SCALAR if X86_32
>         select GENERIC_STRNCPY_FROM_USER
>         select GENERIC_STRNLEN_USER
> @@ -1335,7 +1335,6 @@ config ARCH_SPARSEMEM_ENABLE
>
>  config ARCH_SPARSEMEM_DEFAULT
>         def_bool y
> -       depends on X86_64
>
>  config ARCH_SELECT_MEMORY_MODEL
>         def_bool y
> diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
> index 16a57f4..eda81dc 100644
> --- a/arch/x86/include/asm/clocksource.h
> +++ b/arch/x86/include/asm/clocksource.h
> @@ -3,8 +3,6 @@
>  #ifndef _ASM_X86_CLOCKSOURCE_H
>  #define _ASM_X86_CLOCKSOURCE_H
>
> -#ifdef CONFIG_X86_64
> -
>  #define VCLOCK_NONE 0  /* No vDSO clock available.     */
>  #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.   */
>  #define VCLOCK_HPET 2  /* vDSO should use vread_hpet.  */
> @@ -14,6 +12,4 @@ struct arch_clocksource_data {
>         int vclock_mode;
>  };
>
> -#endif /* CONFIG_X86_64 */
> -
>  #endif /* _ASM_X86_CLOCKSOURCE_H */
> diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
> index 59c6c40..45ba688 100644
> --- a/arch/x86/include/asm/compat.h
> +++ b/arch/x86/include/asm/compat.h
> @@ -295,6 +295,10 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
>
>  static inline void __user *arch_compat_alloc_user_space(long len)
>  {
> +#ifdef CONFIG_X86_32
> +       struct pt_regs *regs = task_pt_regs(current);
> +       return (void __user *)regs->sp - len;

Is there some reason this doesn't need to be aligned?

> +#else
>         compat_uptr_t sp;
>
>         if (test_thread_flag(TIF_IA32)) {
> @@ -305,6 +309,7 @@ static inline void __user *arch_compat_alloc_user_space(long len)
>         }
>
>         return (void __user *)round_down(sp - len, 16);
> +#endif
>  }
>
>  static inline bool is_x32_task(void)
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 7252cd3..504c04a 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -74,6 +74,8 @@ extern unsigned long __FIXADDR_TOP;
>  enum fixed_addresses {
>  #ifdef CONFIG_X86_32
>         FIX_HOLE,
> +       VSYSCALL_HPET,
> +       VVAR_PAGE,
>         FIX_VDSO,
>  #else
>         VSYSCALL_LAST_PAGE,
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index d76ac40..c442782 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -17,7 +17,11 @@
>   */
>
>  /* Base address of vvars.  This is not ABI. */
> +#ifdef CONFIG_X86_64
>  #define VVAR_ADDRESS (-10*1024*1024 - 4096)
> +#else
> +#define VVAR_ADDRESS 0xffffd000
> +#endif
>
>  #if defined(__VVAR_KERNEL_LDS)
>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index cb648c8..3282eda 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -26,7 +26,8 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
>  obj-y                  += probe_roms.o
>  obj-$(CONFIG_X86_32)   += i386_ksyms_32.o
>  obj-$(CONFIG_X86_64)   += sys_x86_64.o x8664_ksyms_64.o
> -obj-y                  += syscall_$(BITS).o
> +obj-y                  += syscall_$(BITS).o vsyscall_gtod.o
> +obj-$(CONFIG_X86_32)   += vsyscall_32.o
>  obj-$(CONFIG_X86_64)   += vsyscall_64.o
>  obj-$(CONFIG_X86_64)   += vsyscall_emu_64.o
>  obj-$(CONFIG_SYSFS)    += ksysfs.o
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index da85a8e..54263f0 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -74,9 +74,7 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
>  static inline void hpet_set_mapping(void)
>  {
>         hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
> -#ifdef CONFIG_X86_64
>         __set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
> -#endif
>  }

Please check xen (or, even better, fix xen for real to get rid of the
awful special cases in the fixmap code).

>
>  static inline void hpet_clear_mapping(void)
> @@ -752,9 +750,7 @@ static struct clocksource clocksource_hpet = {
>         .mask           = HPET_MASK,
>         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
>         .resume         = hpet_resume_counter,
> -#ifdef CONFIG_X86_64
>         .archdata       = { .vclock_mode = VCLOCK_HPET },
> -#endif
>  };
>
>  static int hpet_clocksource_register(void)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c967559..36df76f 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1182,9 +1182,7 @@ void __init setup_arch(char **cmdline_p)
>
>         tboot_probe();
>
> -#ifdef CONFIG_X86_64
>         map_vsyscall();
> -#endifu
>
>         generic_apic_probe();
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a3acbac..fd5c419 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -988,9 +988,7 @@ static struct clocksource clocksource_tsc = {
>         .mask                   = CLOCKSOURCE_MASK(64),
>         .flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
>                                   CLOCK_SOURCE_MUST_VERIFY,
> -#ifdef CONFIG_X86_64
>         .archdata               = { .vclock_mode = VCLOCK_TSC },
> -#endif
>  };
>
>  void mark_tsc_unstable(char *reason)
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index da6b35a..1d4897b 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -147,7 +147,6 @@ SECTIONS
>                 _edata = .;
>         } :data
>
> -#ifdef CONFIG_X86_64
>
>         . = ALIGN(PAGE_SIZE);
>         __vvar_page = .;
> @@ -169,8 +168,6 @@ SECTIONS
>
>         . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
>
> -#endif /* CONFIG_X86_64 */
> -
>         /* Init code and data - will be freed after init */
>         . = ALIGN(PAGE_SIZE);
>         .init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
> diff --git a/arch/x86/kernel/vsyscall_32.c b/arch/x86/kernel/vsyscall_32.c
> new file mode 100644
> index 0000000..1fafb1f
> --- /dev/null
> +++ b/arch/x86/kernel/vsyscall_32.c
> @@ -0,0 +1,53 @@
> +/*
> + *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
> + *  Copyright 2003 Andi Kleen, SuSE Labs.
> + *
> + *  Modified for x86 32 bit arch by Stefani Seibold <stefani@seibold.net>
> + *
> + *  Thanks to hpa@transmeta.com for some useful hint.
> + *  Special thanks to Ingo Molnar for his early experience with
> + *  a different vsyscall implementation for Linux/IA32 and for the name.
> + *
> + */
> +
> +#include <linux/time.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/timer.h>
> +#include <linux/seqlock.h>
> +#include <linux/jiffies.h>
> +#include <linux/sysctl.h>
> +#include <linux/topology.h>
> +#include <linux/timekeeper_internal.h>
> +#include <linux/getcpu.h>
> +#include <linux/cpu.h>
> +#include <linux/smp.h>
> +#include <linux/notifier.h>
> +#include <linux/syscalls.h>
> +#include <linux/ratelimit.h>
> +
> +#include <asm/vsyscall.h>
> +#include <asm/pgtable.h>
> +#include <asm/compat.h>
> +#include <asm/page.h>
> +#include <asm/unistd.h>
> +#include <asm/fixmap.h>
> +#include <asm/errno.h>
> +#include <asm/io.h>
> +#include <asm/segment.h>
> +#include <asm/desc.h>
> +#include <asm/topology.h>
> +#include <asm/vgtod.h>
> +#include <asm/traps.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include "vsyscall_trace.h"
> +
> +void __init map_vsyscall(void)
> +{
> +       extern char __vvar_page;
> +       unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
> +
> +       __set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);

Given that the compat version of this can't (I assume) use a fixmap,
is there any good reason to not just use the same vma-based code for
compat and real 32-bit kernels?

> +}
> +
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 1f96f93..5a91c5b 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -54,7 +54,6 @@
>  #include "vsyscall_trace.h"
>
>  DEFINE_VVAR(int, vgetcpu_mode);
> -DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
>
>  static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
>
> @@ -77,48 +76,6 @@ static int __init vsyscall_setup(char *str)
>  }
>  early_param("vsyscall", vsyscall_setup);
>
> -void update_vsyscall_tz(void)
> -{
> -       vsyscall_gtod_data.sys_tz = sys_tz;
> -}
> -
> -void update_vsyscall(struct timekeeper *tk)
> -{
> -       struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
> -
> -       write_seqcount_begin(&vdata->seq);
> -
> -       /* copy vsyscall data */
> -       vdata->clock.vclock_mode        = tk->clock->archdata.vclock_mode;
> -       vdata->clock.cycle_last         = tk->clock->cycle_last;
> -       vdata->clock.mask               = tk->clock->mask;
> -       vdata->clock.mult               = tk->mult;
> -       vdata->clock.shift              = tk->shift;
> -
> -       vdata->wall_time_sec            = tk->xtime_sec;
> -       vdata->wall_time_snsec          = tk->xtime_nsec;
> -
> -       vdata->monotonic_time_sec       = tk->xtime_sec
> -                                       + tk->wall_to_monotonic.tv_sec;
> -       vdata->monotonic_time_snsec     = tk->xtime_nsec
> -                                       + (tk->wall_to_monotonic.tv_nsec
> -                                               << tk->shift);
> -       while (vdata->monotonic_time_snsec >=
> -                                       (((u64)NSEC_PER_SEC) << tk->shift)) {
> -               vdata->monotonic_time_snsec -=
> -                                       ((u64)NSEC_PER_SEC) << tk->shift;
> -               vdata->monotonic_time_sec++;
> -       }
> -
> -       vdata->wall_time_coarse.tv_sec  = tk->xtime_sec;
> -       vdata->wall_time_coarse.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> -
> -       vdata->monotonic_time_coarse    = timespec_add(vdata->wall_time_coarse,
> -                                                       tk->wall_to_monotonic);
> -
> -       write_seqcount_end(&vdata->seq);
> -}
> -
>  static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
>                               const char *message)
>  {
> diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
> new file mode 100644
> index 0000000..d1499ab
> --- /dev/null
> +++ b/arch/x86/kernel/vsyscall_gtod.c
> @@ -0,0 +1,82 @@
> +/*
> + *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
> + *  Copyright 2003 Andi Kleen, SuSE Labs.
> + *
> + *  Modified for x86 32 bit architecture by
> + *  Stefani Seibold <stefani@seibold.net>
> + *
> + *  Thanks to hpa@transmeta.com for some useful hint.
> + *  Special thanks to Ingo Molnar for his early experience with
> + *  a different vsyscall implementation for Linux/IA32 and for the name.
> + *
> + */
> +
> +#include <linux/time.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/timer.h>
> +#include <linux/seqlock.h>
> +#include <linux/jiffies.h>
> +#include <linux/sysctl.h>
> +#include <linux/topology.h>
> +#include <linux/timekeeper_internal.h>
> +#include <linux/ratelimit.h>
> +
> +#include <asm/vsyscall.h>
> +#include <asm/pgtable.h>
> +#include <asm/page.h>
> +#include <asm/unistd.h>
> +#include <asm/fixmap.h>
> +#include <asm/errno.h>
> +#include <asm/io.h>
> +#include <asm/segment.h>
> +#include <asm/desc.h>
> +#include <asm/topology.h>
> +#include <asm/vgtod.h>
> +#include <asm/traps.h>
> +
> +DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
> +
> +void update_vsyscall_tz(void)
> +{
> +       vsyscall_gtod_data.sys_tz = sys_tz;
> +}
> +
> +void update_vsyscall(struct timekeeper *tk)
> +{
> +       struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
> +
> +       write_seqcount_begin(&vdata->seq);
> +
> +       /* copy vsyscall data */
> +       vdata->clock.vclock_mode        = tk->clock->archdata.vclock_mode;
> +       vdata->clock.cycle_last         = tk->clock->cycle_last;
> +       vdata->clock.mask               = tk->clock->mask;
> +       vdata->clock.mult               = tk->mult;
> +       vdata->clock.shift              = tk->shift;
> +
> +       vdata->wall_time_sec            = tk->xtime_sec;
> +       vdata->wall_time_snsec          = tk->xtime_nsec;
> +
> +       vdata->monotonic_time_sec       = tk->xtime_sec
> +                                       + tk->wall_to_monotonic.tv_sec;
> +       vdata->monotonic_time_snsec     = tk->xtime_nsec
> +                                       + (tk->wall_to_monotonic.tv_nsec
> +                                               << tk->shift);
> +       while (vdata->monotonic_time_snsec >=
> +                                       (((u64)NSEC_PER_SEC) << tk->shift)) {
> +               vdata->monotonic_time_snsec -=
> +                                       ((u64)NSEC_PER_SEC) << tk->shift;
> +               vdata->monotonic_time_sec++;
> +       }
> +
> +       vdata->wall_time_coarse.tv_sec  = tk->xtime_sec;
> +       vdata->wall_time_coarse.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> +
> +       vdata->monotonic_time_coarse    = timespec_add(vdata->wall_time_coarse,
> +                                                       tk->wall_to_monotonic);
> +
> +       write_seqcount_end(&vdata->seq);
> +}
> +
> +
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
