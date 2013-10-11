Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3JKANl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:13:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34993 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3JKANj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <20131001192203.GA29794@www.outflux.net>
References: <20131001192203.GA29794@www.outflux.net>
Date: Thu, 10 Oct 2013 17:13:38 -0700
X-Google-Sender-Auth: vHIfe-DpuXFTXtHlk-0MP8IawTo
Message-ID: <CAGXu5jJJGxad=cJ52Jzja55Aj+nrkHSAJqUt+He0Bs7GViz=Bg@mail.gmail.com>
Subject: Re: [PATCH] x86, relocs: add more per-cpu gold special cases
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Cong Ding <dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 12:22 PM, Kees Cook <keescook@chromium.org> wrote:
> The "gold" linker doesn't seem to put some additional per-cpu cases in
> the right place. Add these to the per-cpu check. Without this, the kASLR
> patch series fails to correctly apply relocations, and fails to boot.
>
> Found and fixed by Michael Davidson.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Ping on this patch. Can this get picked up for tip?

-Kees

> ---
>  arch/x86/tools/relocs.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
> index f7bab68..71a2533 100644
> --- a/arch/x86/tools/relocs.c
> +++ b/arch/x86/tools/relocs.c
> @@ -722,15 +722,23 @@ static void percpu_init(void)
>
>  /*
>   * Check to see if a symbol lies in the .data..percpu section.
> - * For some as yet not understood reason the "__init_begin"
> - * symbol which immediately preceeds the .data..percpu section
> - * also shows up as it it were part of it so we do an explict
> - * check for that symbol name and ignore it.
> + *
> + * The linker incorrectly associates some symbols with the
> + * .data..percpu section so we also need to check the symbol
> + * name to make sure that we classify the symbol correctly.
> + *
> + * The GNU linker incorrectly associates:
> + *     __init_begin
> + *
> + * The "gold" linker incorrectly associates:
> + *     init_per_cpu__irq_stack_union
> + *     init_per_cpu__gdt_page
>   */
>  static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
>  {
>         return (sym->st_shndx == per_cpu_shndx) &&
> -               strcmp(symname, "__init_begin");
> +               strcmp(symname, "__init_begin") &&
> +               strncmp(symname, "init_per_cpu_", 13);
>  }
>
>
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
