Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaLVUSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:18:17 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:54895 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:18:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141222200804.18A7A803@viggo.jf.intel.com>
References: <20141222200803.D316DA2A@viggo.jf.intel.com> <20141222200804.18A7A803@viggo.jf.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 12:17:53 -0800
Message-ID: <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on
 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:08 PM, Dave Hansen <dave@sr71.net> wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> We had originally planned on submitting MPX support in one patch
> set.  We eventually broke it up in to two pieces for easier
> review.  One of the features that didn't make the first round
> was supporting 32-bit binaries on 64-bit kernels.
>
> Once we split the set up, we never added code to restrict 32-bit
> binaries from _using_ MPX on 64-bit kernels.
>
> The 32-bit bounds tables are a different format than the 64-bit
> ones.  Without this patch, the kernel will try to read a 32-bit
> binary's tables as if they were the 64-bit version.  They will
> likely be noticed as being invalid rather quickly and the app
> will get killed, but that's kinda mean.
>
> This patch adds an explicit check, and will make a 64-bit kernel
> essentially behave as if it has no MPX support when called from
> a 32-bit binary.
>
> I intend to remove this check once the mixed binary support is
> added.  Those patches are posted if anyone is interested:
>
>         https://lkml.org/lkml/2014/12/12/632
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>
>  b/arch/x86/mm/mpx.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff -puN arch/x86/mm/mpx.c~x86-mpx-explicitly-disable-32-bit-on-64-bit-for-3_19 arch/x86/mm/mpx.c
> --- a/arch/x86/mm/mpx.c~x86-mpx-explicitly-disable-32-bit-on-64-bit-for-3_19    2014-12-22 12:06:18.308911687 -0800
> +++ b/arch/x86/mm/mpx.c 2014-12-22 12:06:18.311911822 -0800
> @@ -349,6 +349,12 @@ static __user void *task_get_bounds_dir(
>                 return MPX_INVALID_BOUNDS_DIR;
>
>         /*
> +        * 32-bit binaries on 64-bit kernels are currently
> +        * unsupported.
> +        */
> +       if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
> +               return MPX_INVALID_BOUNDS_DIR;

Should this check mm->ia32_compat instead?

Otherwise,

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

> +       /*
>          * The bounds directory pointer is stored in a register
>          * only accessible if we first do an xsave.
>          */
> _



-- 
Andy Lutomirski
AMA Capital Management, LLC
