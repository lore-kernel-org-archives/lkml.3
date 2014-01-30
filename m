Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaA3SWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:22:17 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37684 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaA3SWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:22:16 -0500
MIME-Version: 1.0
In-Reply-To: <1391078953-1575-5-git-send-email-stefani@seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net> <1391078953-1575-5-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 10:21:55 -0800
Message-ID: <CALCETrXMPkA3ZfwGo8iQQDL=7HXBE3Mo8j6Zi+bTu=eoL-b43w@mail.gmail.com>
Subject: Re: [PATCH 4/4] Add 32 bit VDSO support for 64 kernel
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
> This patch add the support for the IA32 Emulation Layer to run 32 bit
> applications on a 64 bit kernel.
>
> Due the nature of the kernel headers and the LP64 compiler where the
> size of a long and a pointer differs against a 32 bit compiler, there
> is a lot of type hacking necessary.
>
> This kind of type hacking could be prevent in the future by doing a call to the
> 64 bit code by the following sequence:
>
> - Compile the arch/x86/vdso/vclock_gettime.c as 64 bit, but only generate
>   the assemble output.
> - Next compile a 32 bit object by including the 64 bit vclock_gettime.s
>   prefixed with .code64
> - At least we need a trampolin code which invokes the 64 bit code and do
>   the API conversation (64 bit longs to 32 bit longs), like the
>   followig snipped:
>
> ENTRY(call64)
>         push %ebp
>         movl %esp, %ebp
>         ljmp $__USER_CS, $1f
> .code64

I bet that this trampoline takes at least as long as a syscall /
sysenter instruction.  I'd be surprised if designers of modern cpus
care at all about ljmp latency.


>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/vdso/vclock_gettime.c        | 112 ++++++++++++++++++++++++++--------
>  arch/x86/vdso/vdso32/vclock_gettime.c |   7 +++
>  2 files changed, 95 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 19b2a49..a2417e2 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -31,12 +31,24 @@
>
>  #define gtod (&VVAR(vsyscall_gtod_data))
>
> +struct api_timeval {
> +       long    tv_sec;         /* seconds */
> +       long    tv_usec;        /* microseconds */
> +};
> +
> +struct api_timespec {
> +       long    tv_sec;         /* seconds */
> +       long    tv_nsec;        /* microseconds */
> +};
> +
> +typedef long api_time_t;
> +
>  static notrace cycle_t vread_hpet(void)
>  {
>         return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
>  }
>
> -notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> +notrace static long vdso_fallback_gettime(long clock, struct api_timespec *ts)
>  {
>         long ret;
>         asm("syscall" : "=a" (ret) :
> @@ -44,7 +56,8 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>         return ret;
>  }
>
> -notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
> +notrace static long vdso_fallback_gtod(struct api_timeval *tv,
> +               struct timezone *tz)
>  {
>         long ret;
>
> @@ -54,20 +67,68 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
>  }
>  #else
>
> +#ifdef CONFIG_IA32_EMULATION
> +typedef s64    arch_time_t;
> +
> +struct arch_timespec {
> +       s64     tv_sec;
> +       s64     tv_nsec;
> +};
> +
> +#define ALIGN8 __attribute__ ((aligned (8)))
> +
> +struct arch_vsyscall_gtod_data {
> +       seqcount_t      seq ALIGN8;
> +
> +       struct { /* extract of a clocksource struct */
> +               int vclock_mode ALIGN8;
> +               cycle_t cycle_last ALIGN8;
> +               cycle_t mask ALIGN8;
> +               u32     mult;
> +               u32     shift;
> +       } clock;
> +
> +       /* open coded 'struct timespec' */
> +       arch_time_t     wall_time_sec;
> +       u64             wall_time_snsec;
> +       u64             monotonic_time_snsec;
> +       arch_time_t     monotonic_time_sec;
> +
> +       struct timezone sys_tz;
> +       struct arch_timespec wall_time_coarse;
> +       struct arch_timespec monotonic_time_coarse;
> +};

Yuck!

Can you see how hard it would be to just make the real gtod data have
the same layout for 32-bit and 64-bit code?

--Andy
