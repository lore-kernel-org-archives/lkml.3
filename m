Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaIERQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:16:19 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:39877 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIERQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <1409926097-2101-3-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
	<1409926097-2101-3-git-send-email-bhe@redhat.com>
Date: Fri, 5 Sep 2014 10:16:15 -0700
X-Google-Sender-Auth: kaEcFdrrOWOpQMBluLjhbf9VCSQ
Message-ID: <CAGXu5jJXvR9c3OvkX-gBMjhJEwXh5-wBdT+jjMwBFXDs8_-40Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] kaslr: check if the random addr is available
From: Kees Cook <keescook@chromium.org>
To: Baoquan He <bhe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Chao <chaowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 7:08 AM, Baoquan He <bhe@redhat.com> wrote:
> Currently kaslr enabling can extend the kernel virtual address space
> to 1G, next is for modules. So if kernel is loaded to above 1G, system
> running will be exceptional, This happened when kexec/kdump load kernel.
>
> So add a check to see if the decompression output region is contained
> in 1G.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  arch/x86/boot/compressed/misc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 7780a5b..d2a0eaa 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -250,6 +250,11 @@ static void handle_relocations(void *output, unsigned long output_len)
>         }
>  #endif
>
> +       if (max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
> +                debug_putstr("Random addr is not allowed. No relocation needed... \n");
> +                return;
> +        }
> +

It's not clear to me what this is fixing. In aslr.c,
process_e820_entry() should already make it impossible to select
max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET. If you're trying to
detect a non-kaslr boot, I think this is better handled in 1/4 where I
suggest examining the "output" location before/after
choose_kernel_location.

-Kees

>         /*
>          * Calculate the delta between where vmlinux was linked to load
>          * and where it was actually loaded.
> --
> 1.8.5.3
>



-- 
Kees Cook
Chrome OS Security
