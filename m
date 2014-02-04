Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaBDSRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:17:08 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:46027 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBDSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <1391508908-32239-8-git-send-email-stefani@seibold.net>
References: <1391508908-32239-1-git-send-email-stefani@seibold.net> <1391508908-32239-8-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 10:16:43 -0800
Message-ID: <CALCETrXoT0iZy2LqUqnhaZKiojpw432U2AGBdcnDQe+JE72PiA@mail.gmail.com>
Subject: Re: [PATCH v11 7/9] introduce VVAR marco for vdso32
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
> This patch revamp the vvar.h for introduce the VVAR macro for vdso32.

I like this approach better.  Thanks.

>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/vvar.h | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index 7cd69af..bf13dc5 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -16,15 +16,6 @@
>   * you mess up, the linker will catch it.)
>   */
>
> -/* Base address of vvars.  This is not ABI. */
> -#ifdef CONFIG_X86_64
> -#define VVAR_ADDRESS (-10*1024*1024 - 4096)
> -#else
> -extern char __vvar_page;
> -
> -#define VVAR_ADDRESS (&__vvar_page)
> -#endif
> -
>  #if defined(__VVAR_KERNEL_LDS)
>
>  /* The kernel linker script defines its own magic to put vvars in the
> @@ -35,16 +26,35 @@ extern char __vvar_page;
>
>  #else
>
> +#ifdef BUILD_VDSO32
> +
> +#define DECLARE_VVAR(offset, type, name)                               \
> +       extern type vvar_ ## name __attribute__((visibility("hidden")));
> +
> +#define VVAR(name) (vvar_ ## name)
> +
> +#else
> +
> +/* Base address of vvars.  This is not ABI. */
> +#ifdef CONFIG_X86_64
> +#define VVAR_ADDRESS (-10*1024*1024 - 4096)
> +#else
> +extern char __vvar_page;
> +
> +#define VVAR_ADDRESS (&__vvar_page)
> +#endif
> +
>  #define DECLARE_VVAR(offset, type, name)                               \
>         static type const * const vvaraddr_ ## name =                   \
>                 (void *)(VVAR_ADDRESS + (offset));
>
> +#define VVAR(name) (*vvaraddr_ ## name)
> +#endif
> +
>  #define DEFINE_VVAR(type, name)                                                \
>         type name                                                       \
>         __attribute__((section(".vvar_" #name), aligned(16))) __visible
>
> -#define VVAR(name) (*vvaraddr_ ## name)
> -
>  #endif
>
>  /* DECLARE_VVAR(offset, type, name) */
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
