Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaBAX7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:59:44 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48916 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaBAX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:59:43 -0500
MIME-Version: 1.0
In-Reply-To: <1391268756-10766-4-git-send-email-stefani@seibold.net>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net> <1391268756-10766-4-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Feb 2014 15:59:20 -0800
Message-ID: <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
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

On Sat, Feb 1, 2014 at 7:32 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
>
> For 32 bit programs running on a 32 bit kernel, the same mechanism is
> used as for 64 bit programs running on a 64 bit kernel.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

I have multiple issues with this patch.

 - It's very hard to review the vclock_gettime.c changes.  You're
doing at least three things in there: reworking the return types of
all the helpers, moving code, and adding 32-bit code.  Can you split
the patch so that the resulting diff is readable?  (e.g. one patch
that purely reorders things, one patch that reworks the return types,
and a third patch with the meat?  if splitting into just two results
in a comprehensible diff, that's fine, too.)

 - There are multiple vvar mappings.  I still don't understand why.
You've stuck the vvar page into the fixmap *and* into a special
mapping.  The former works on native 32 bit only, but you don't seem
to *use* the mapping, which confuses me.  The latter may or may not
confuse things (criu?) that try to parse /proc/self/maps.

  If it is, indeed, okay to use non-fixed maps on 32-bit, it might
also be okay on 64-bit.  If so, it could be useful to implement that,
which would remove a bit of a wart and allow PR_SET_TSC to work
usefully for 64-bit userspace.  (This would remove the need for the
VVAR macro and would allow shorter rip-relative address modes.)

 (Note that those fixmaps are a security problem on native 32-bit if
NX is not available.  We may not care.)

 - The VVAR macro is all screwed up now.  Please either continue to
use it (and fix the definition) or stop using it everywhere and figure
out a different way.  The current approach is just going to fester if
anyone ports the rest of the vdso to work in 32-bit environments.

 - You've hardcoded the address of the counter in the HPET page into
the linker script.  Please don't.  If you really need to have the HPET
mapping in the linker script, please just reference the base address
and add the offset in C code using the appropriate macro.

> ---
>  arch/x86/include/asm/elf.h            |   2 +-
>  arch/x86/include/asm/vdso.h           |   3 +
>  arch/x86/include/asm/vdso32.h         |  10 +++
>  arch/x86/vdso/Makefile                |   7 ++
>  arch/x86/vdso/vclock_gettime.c        | 165 ++++++++++++++++++++++------------
>  arch/x86/vdso/vdso-layout.lds.S       |  25 ++++++
>  arch/x86/vdso/vdso32-setup.c          |  47 ++++++++--
>  arch/x86/vdso/vdso32/vclock_gettime.c |  16 ++++
>  arch/x86/vdso/vdso32/vdso32.lds.S     |  11 ++-
>  9 files changed, 218 insertions(+), 68 deletions(-)
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

This is odd.  Can you explain it?


--Andy
