Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaKFIDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:03:05 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59368 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKFIDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:03:01 -0500
MIME-Version: 1.0
In-Reply-To: <1415245982.3398.53.camel@decadent.org.uk>
References: <1415245982.3398.53.camel@decadent.org.uk>
Date: Thu, 6 Nov 2014 09:02:59 +0100
X-Google-Sender-Auth: gc9m5CqoZizdcFikDiTeYNNXSok
Message-ID: <CAMuHMdVn7ERrXZBbzLZxWFnUhZdXectLMDoVKucte5Zr-U3Mow@mail.gmail.com>
Subject: Re: [RFC][PATCH] x86: Make x32 syscall support conditional on a
 kernel parameter
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 4:53 AM, Ben Hutchings <ben@decadent.org.uk> wrote:

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2455,6 +2455,14 @@ config X86_X32
>           elf32_x86_64 support enabled to compile a kernel with this
>           option set.
>
> +config X86_X32_DISABLED
> +       bool "x32 ABI disabled by default"
> +       depends on X86_X32
> +       default n
> +       help
> +         Disable the x32 ABI unless explicitly enabled using the
> +         kernel paramter "syscall.x32=y".

parameter


> diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
> index 4ac730b..7a6e66f 100644
> --- a/arch/x86/kernel/syscall_64.c
> +++ b/arch/x86/kernel/syscall_64.c

> +static int __init x32_enable(void)
> +{
> +       BUG_ON(system_call_fast_compare_end - system_call_fast_compare != 10);
> +       BUG_ON(system_call_trace_compare_end - system_call_trace_compare != 10);
> +       BUG_ON(system_call_mask_compare_end - system_call_mask_compare != 10);

BUILD_BUG_ON

> +
> +       if (x32_enabled) {
> +               text_poke_early(system_call_fast_compare,
> +                               system_call_mask_compare, 10);
> +               text_poke_early(system_call_trace_compare,
> +                               system_call_mask_compare, 10);
> +#ifdef CONFIG_X86_X32_DISABLED
> +               pr_info("Enabled x32 syscalls\n");
> +#endif

I don't think it hurts to print this unconditionally.

> +       }
> +#ifndef CONFIG_X86_X32_DISABLED
> +       else
> +               pr_info("Disabled x32 syscalls\n");
> +#endif
> +
> +       return 0;
> +}
> +late_initcall(x32_enable);
> +
> +#endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
