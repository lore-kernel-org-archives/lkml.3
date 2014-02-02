Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaBBQkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:40:08 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62016 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaBBQkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:40:05 -0500
MIME-Version: 1.0
In-Reply-To: <1391340435-5130-4-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-4-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 08:39:44 -0800
Message-ID: <CALCETrVjVkuDaN3aD3Ekx7EHvVLHMcURhtb_tReF=senOG=Bsg@mail.gmail.com>
Subject: Re: [PATCH 3/8] revamp vclock_gettime.c
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

On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This intermediate patch revamps the vclock_gettime.c by moving some functions
> around. It is only for spliting purpose, to make whole the 32 bit vdso timer
> patch easier to review.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Andy Lutomirski <luto@amacapital.net>

> ---
>  arch/x86/vdso/vclock_gettime.c | 85 +++++++++++++++++++++---------------------
>  1 file changed, 42 insertions(+), 43 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index eb5d7a5..bbc8065 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -26,41 +26,26 @@
>
>  #define gtod (&VVAR(vsyscall_gtod_data))
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
> -
> -       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
> -
> -       if (likely(ret >= last))
> -               return ret;
> +       return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
> +}
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
> +notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> +{
> +       long ret;
> +       asm("syscall" : "=a" (ret) :
> +           "0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
> +       return ret;
>  }
>
> -static notrace cycle_t vread_hpet(void)
> +notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
>  {
> -       return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
> +       long ret;
> +
> +       asm("syscall" : "=a" (ret) :
> +           "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
> +       return ret;
>  }
>
>  #ifdef CONFIG_PARAVIRT_CLOCK
> @@ -133,23 +118,37 @@ static notrace cycle_t vread_pvclock(int *mode)
>  }
>  #endif
>
> -notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> +notrace static cycle_t vread_tsc(void)
>  {
> -       long ret;
> -       asm("syscall" : "=a" (ret) :
> -           "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
> -       return ret;
> -}
> +       cycle_t ret;
> +       u64 last;
>
> -notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
> -{
> -       long ret;
> +       /*
> +        * Empirically, a fence (of type that depends on the CPU)
> +        * before rdtsc is enough to ensure that rdtsc is ordered
> +        * with respect to loads.  The various CPU manuals are unclear
> +        * as to whether rdtsc can be reordered with later loads,
> +        * but no one has ever seen it happen.
> +        */
> +       rdtsc_barrier();
> +       ret = (cycle_t)vget_cycles();
>
> -       asm("syscall" : "=a" (ret) :
> -           "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
> -       return ret;
> -}
> +       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
>
> +       if (likely(ret >= last))
> +               return ret;
> +
> +       /*
> +        * GCC likes to generate cmov here, but this branch is extremely
> +        * predictable (it's just a funciton of time and the likely is
> +        * very likely) and there's a data dependence, so force GCC
> +        * to generate a branch instead.  I don't barrier() because
> +        * we don't actually need a barrier, and if this function
> +        * ever gets inlined it will generate worse code.
> +        */
> +       asm volatile ("");
> +       return last;
> +}
>
>  notrace static inline u64 vgetsns(int *mode)
>  {
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
