Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab3GMUjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 16:39:12 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33073 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3GMUjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 16:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <tip-c0b3450f101523a49823fa93d155f1d258e5ac6f@git.kernel.org>
References: <20130712225017.GA5366@www.outflux.net>
	<tip-c0b3450f101523a49823fa93d155f1d258e5ac6f@git.kernel.org>
Date: Sat, 13 Jul 2013 13:39:10 -0700
X-Google-Sender-Auth: TemgCfokArboUURFT4VNsttUavQ
Message-ID: <CAE9FiQX=5Oe_F5Q3WQBGfghgOcgHjcOufPhtUy2X6J_s6GY36Q@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, pageexec@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 8:21 PM, tip-bot for Kees Cook <tipbot@zytor.com> wrote:
> Commit-ID:  c0b3450f101523a49823fa93d155f1d258e5ac6f
> Gitweb:     http://git.kernel.org/tip/c0b3450f101523a49823fa93d155f1d258e5ac6f
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Fri, 12 Jul 2013 15:50:17 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 12 Jul 2013 16:14:08 -0700
>
> x86: Make sure IDT is page aligned
>
> Since the IDT is referenced from a fixmap, make sure it is page aligned.
> Merge with 32-bit one, since it was already aligned to deal with F00F bug.
> This avoids the risk of it ever being moved in the bss and having the
> mapping be offset, resulting in calling incorrect handlers.
>
> [ hpa: It isn't clear that this is a manifest bug in any way, but
>   tagging for -stable because it shouldn't hurt and might avoid some
>   very hard-to-debug breakages due to unrelated changes. ]
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: http://lkml.kernel.org/r/20130712225017.GA5366@www.outflux.net
> Reported-by: PaX Team <pageexec@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/head_64.S | 4 ----
>  arch/x86/kernel/traps.c   | 7 ++-----
>  2 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 5e4d8a8..317b8cc 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -514,10 +514,6 @@ ENTRY(phys_base)
>
>         .section .bss, "aw", @nobits
>         .align L1_CACHE_BYTES
> -ENTRY(idt_table)
> -       .skip IDT_ENTRIES * 16
> -
> -       .align L1_CACHE_BYTES
>  ENTRY(debug_idt_table)
>         .skip IDT_ENTRIES * 16
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index b0865e8..0952614 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -68,13 +68,10 @@
>  #include <asm/setup.h>
>
>  asmlinkage int system_call(void);
> +#endif
>
> -/*
> - * The IDT has to be page-aligned to simplify the Pentium
> - * F0 0F bug workaround.
> - */
> +/* The IDT has to be page-aligned to keep it aligned with its fixmap. */
>  gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
> -#endif
>
>  DECLARE_BITMAP(used_vectors, NR_VECTORS);
>  EXPORT_SYMBOL_GPL(used_vectors);

arch/x86/kernel/traps.c:74:1: warning: braces around scalar
initializer [enabled by default]
arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]
arch/x86/kernel/traps.c:74:1: warning: braces around scalar
initializer [enabled by default]
arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]
arch/x86/kernel/traps.c:74:1: warning: excess elements in scalar
initializer [enabled by default]
arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]
