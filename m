Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaBEWBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:01:33 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:64339 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaBEWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <1391588404-28147-10-git-send-email-stefani@seibold.net>
References: <1391588404-28147-1-git-send-email-stefani@seibold.net> <1391588404-28147-10-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 5 Feb 2014 14:01:02 -0800
Message-ID: <CALCETrUx7iSquojTuYzoVZ_Pbi8NW7Wvs-CXSh3GEjMd-diRKQ@mail.gmail.com>
Subject: Re: [PATCH v12 9/9] Add 32 bit VDSO time support for 64 bit kernel
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

On Wed, Feb 5, 2014 at 12:20 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the VDSO time support for the IA32 Emulation Layer.
>
> Due the nature of the kernel headers and the LP64 compiler where the
> size of a long and a pointer differs against a 32 bit compiler, there
> is some type hacking necessary.
>
> The vsyscall_gtod_data struture must be a little bit rearranged, to
> serve 32- and 64-bit code access:
>
> - The seqcount_t was replaced by an unsigned, this makes the
>   vsyscall_gtod_data intedepend of kernel configuration and internal functions.
> - The structure is now packed, so it can accessed from 32- und 64- bit
>   code at the same time.
> - The inner struct clock was removed, to make packing of the while
>   struct easier.
>
> The "unsigned seq" would be handled by functions derivated from seqcount_t.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/vgtod.h          |  20 +++---
>  arch/x86/kernel/vsyscall_gtod.c       |  26 +++++--
>  arch/x86/vdso/vclock_gettime.c        | 129 ++++++++++++++++++++++++----------
>  arch/x86/vdso/vdso32/vclock_gettime.c |  11 +++
>  include/uapi/linux/time.h             |   2 +-
>  5 files changed, 132 insertions(+), 56 deletions(-)
>
> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 46e24d3..2567b02 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -4,16 +4,18 @@
>  #include <asm/vsyscall.h>
>  #include <linux/clocksource.h>
>
> -struct vsyscall_gtod_data {
> -       seqcount_t      seq;
> +/*
> + * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
> + * so the structure must be packed
> + */
> +struct __attribute__((packed)) vsyscall_gtod_data {
> +       unsigned seq;

Is that actually true?  At least in the part you're changing,
everything looks like it's aligned correctly.

It's almost certainly having some kind of BUILD_BUG_ON that will catch
the case where this structure's size changes.  I suspect that some
kind of asm-offsets magic can be used for this.

>
> -       struct { /* extract of a clocksource struct */
> -               int vclock_mode;
> -               cycle_t cycle_last;
> -               cycle_t mask;
> -               u32     mult;
> -               u32     shift;
> -       } clock;
> +       int vclock_mode;
> +       cycle_t cycle_last;
> +       cycle_t mask;
> +       u32     mult;
> +       u32     shift;
>
>         /* open coded 'struct timespec' */
>         time_t          wall_time_sec;
> diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
> index 91862a4..ca48248 100644
> --- a/arch/x86/kernel/vsyscall_gtod.c
> +++ b/arch/x86/kernel/vsyscall_gtod.c
> @@ -16,6 +16,18 @@
>
>  DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
>
> +static inline void gtod_write_begin(unsigned *s)
> +{
> +       ++*s;
> +       smp_wmb();
> +}
> +
> +static inline void gtod_write_end(unsigned *s)
> +{
> +       smp_wmb();
> +       ++*s;
> +}
> +

Someone else should probably comment on the style for this.  Maybe
this should live in a header somewhere.  IMO if it's called
gtod_write_begin, it should take a pointer to gtod as a parameter.


> +struct api_timeval {
> +       long    tv_sec;         /* seconds */
> +       long    tv_usec;        /* microseconds */
> +};
> +
> +struct api_timespec {
> +       long    tv_sec;         /* seconds */
> +       long    tv_nsec;        /* nanoseconds */
> +};

Did you address my question about why there are two versions of this?
Shouldn't it just match the userspace headers regardless of what the
host kernel is?

Minor nit: this should be abi_time... instead of api.


You have *still* not responded to my objection to the unconditional fixmaps.

--Andy
