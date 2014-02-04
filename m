Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaBDS1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:27:51 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59341 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:27:49 -0500
MIME-Version: 1.0
In-Reply-To: <1391508908-32239-10-git-send-email-stefani@seibold.net>
References: <1391508908-32239-1-git-send-email-stefani@seibold.net> <1391508908-32239-10-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 10:27:28 -0800
Message-ID: <CALCETrV56r5OYNmv+Rn5QX=fk=L8YhfL3nsUEtyBbNsXf0JwxQ@mail.gmail.com>
Subject: Re: [PATCH v11 9/9] Add 32 bit VDSO time support for 64 bit kernel
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

On Tue, Feb 4, 2014 at 2:15 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the VDSO time support for the IA32 Emulation Layer.
>
> Due the nature of the kernel headers and the LP64 compiler where the
> size of a long and a pointer differs against a 32 bit compiler, there
> is a lot of type hacking necessary.
>
> The vsyscall_gtod_data struture must be a little bit rearranged, to
> serve for 32- and 64-bit code access.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/vgtod.h          | 23 +++++----
>  arch/x86/kernel/vsyscall_gtod.c       | 10 ++--
>  arch/x86/vdso/vclock_gettime.c        | 93 +++++++++++++++++++++++------------
>  arch/x86/vdso/vdso32/vclock_gettime.c | 11 +++++
>  include/uapi/linux/time.h             |  2 +-
>  5 files changed, 92 insertions(+), 47 deletions(-)
>
> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 46e24d3..3032eb8 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -4,16 +4,16 @@
>  #include <asm/vsyscall.h>
>  #include <linux/clocksource.h>
>
> -struct vsyscall_gtod_data {
> -       seqcount_t      seq;
> -
> -       struct { /* extract of a clocksource struct */
> -               int vclock_mode;
> -               cycle_t cycle_last;
> -               cycle_t mask;
> -               u32     mult;
> -               u32     shift;
> -       } clock;
> +/*
> + * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
> + * so the structure must be packed
> + */
> +struct __attribute__((packed)) vsyscall_gtod_data {
> +       int vclock_mode;
> +       cycle_t cycle_last;
> +       cycle_t mask;
> +       u32     mult;
> +       u32     shift;
>
>         /* open coded 'struct timespec' */
>         time_t          wall_time_sec;
> @@ -24,6 +24,9 @@ struct vsyscall_gtod_data {
>         struct timezone sys_tz;
>         struct timespec wall_time_coarse;
>         struct timespec monotonic_time_coarse;
> +
> +       /* must be at the end, because the size depends on the kernel config */
> +       seqcount_t      seq;

Please don't move this.  You are probably increasing the number of
cachelines needed to do vclock_gettime if lockdep is off.
(vclock_gettime with CLOCK_REALTIME or CLOCK_MONOTONIC is probably the
most important case.)  I'd much rather this be just 'unsigned seq' or
'u32 seq' and stay at the beginning.

> @@ -57,6 +70,18 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
>  u8 hpet_page
>         __attribute__((visibility("hidden")));
>
> +struct api_timeval {
> +       s32     tv_sec;         /* seconds */
> +       s32     tv_usec;        /* microseconds */
> +};
> +
> +struct api_timespec {
> +       s32     tv_sec;         /* seconds */
> +       s32     tv_nsec;        /* microseconds */
> +};

These ought to be unifiable between 32-bit and 64-bit.  Isn't 'long
tv_sec; long tv_nsec;' correct in all cases?


--Andy
