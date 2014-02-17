Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaBQKGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:06:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:39428 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBQKGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:06:17 -0500
Message-ID: <1392631642.32244.2.camel@wall-e.seibold.net>
Subject: Re: [tip:x86/vdso] x86, vdso: Instead of dummy functions, include <
 linux/spinlock_up.h>
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Date: Mon, 17 Feb 2014 11:07:22 +0100
In-Reply-To: <5301DB4B.2030103@zytor.com>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>
	 <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>
	 <53018ABA.20005@zytor.com> <1392622944.1036.13.camel@wall-e.seibold.net>
	 <5301D615.8090907@zytor.com> <1392630366.15660.6.camel@wall-e.seibold.net>
	 <5301DB4B.2030103@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.02.2014, 01:50 -0800 schrieb H. Peter Anvin:
> On 02/17/2014 01:46 AM, Stefani Seibold wrote:
> > Am Montag, den 17.02.2014, 01:27 -0800 schrieb H. Peter Anvin:
> >> On 02/16/2014 11:42 PM, Stefani Seibold wrote:
> >>> I think for the first time it will be okay to kick out the
> >>> _ASM_X86_SPINLOCK_H hack and accept the C=1 warnings.
> >>>
> >>> At next step it is necessary to make the whole BUILD_VDSO32 path in
> >>> vclock_gettime.c independent from the kernel headers, only uapi/ should
> >>> be included.
> >>>
> >>> The use of cycle_t must be replaced with u64.
> >>>
> >>> We need a own copy of __native_read_tsc(), __iter_div_u64_rem, smp_rmb()
> >>> and cpu_relax().
> >>
> >> All of which are quite trivial.
> >>
> >>> For the non BUILD_VDSO32 path we must only move the #includes inside
> >>> this #ifndef BUILD_VDSO32
> >>
> >> Sorry, didn't quite follow that.
> >>
> >
> > The solution is quite simple: In case of a 32 bit VDSO for a 64 bit
> > kernel fake a 32 bit kernel configuration. Than everything is fine and
> > all kernel headers will compile without warnings or errors, also make
> > C=1 will give no complains.
> >
> > The arch/x86/vdso/vdso32/vclock_gettime.c will now look like:
> >
> > #define BUILD_VDSO32
> >
> > #ifdef CONFIG_X86_64
> >
> > /*
> >   * in case of a 32 bit VDSO for a 64 bit kernel fake a 32 bit kernel
> >   * configuration
> >   */
> > #undef CONFIG_64BIT
> > #undef CONFIG_X86_64
> > #undef CONFIG_ILLEGAL_POINTER_VALUE
> >
> > #define CONFIG_X86_32 1
> > #define CONFIG_PAGE_OFFSET 0
> > #define CONFIG_ILLEGAL_POINTER_VALUE 0
> >
> > #define BUILD_VDSO32_64
> >
> > #endif
> >
> > #include "../vclock_gettime.c"
> >
> > and the following modifications for arch/x86/include/asm/vgtod.h:
> >
> > #ifdef BUILD_VDSO32_64
> > typedef u64 gtod_long_t;
> > #else
> > typedef unsigned long gtod_long_t;
> > #endif
> >
> > I tested it and i see no side effects. What do you think?
> >
> 
> Clever.  It is still a hack of course, and it would be better to getting 
> to the point where we don't include random kernel headers but only uapi 
> headers plus special headers sanitized specifically for the vdso, but 
> the above looks like a good intermediate hack.
> 

Yes, but i think this is nearly impossible, because there must be
modified a lot of headers and nobody can predict the side effects.

- Stefani


