Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3CWVXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 17:23:46 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44446 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3CWVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 17:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <1362759080-26098-1-git-send-email-paul.gortmaker@windriver.com>
References: <alpine.LFD.2.02.1303072330520.22263@ionos>
	<1362759080-26098-1-git-send-email-paul.gortmaker@windriver.com>
Date: Sat, 23 Mar 2013 22:23:44 +0100
X-Google-Sender-Auth: iH8fo3BWFI3rNSVHNUncI7TTPFA
Message-ID: <CAMuHMdVWoKqyX2Lnj7FbOyjY-PKtZ3WE+7dMyyTenrmjMSxbjQ@mail.gmail.com>
Subject: Re: [PATCH v3] early_printk: consolidate random copies of identical code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 5:11 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> The early console implementations are the same all over the place.  Move
> the print function to kernel/printk and get rid of the copies.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Richard Weinberger <richard@nod.at>
> Reviewed-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>
> [v3: drop sparc bits as suggested by tglx, redo build tests on sparc
>  sparc32, Randy's randconfig, ppc, mips, arm...]
>
> [v2: essentially unchanged since v1, so I've left the acked/reviewed
>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
>  and PRINTK=n, because the early_console struct and early_printk calls
>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
>  and still works for everyday sane configs too.]
>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2

> --- a/arch/sh/kernel/sh_bios.c
> +++ b/arch/sh/kernel/sh_bios.c
> @@ -144,8 +144,6 @@ static struct console bios_console = {
>         .index          = -1,
>  };
>
> -static struct console *early_console;

This one wasn't protected by #ifdef CONFIG_EARLY_PRINTK...

> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1724,6 +1717,29 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
>
>  #endif /* CONFIG_PRINTK */
>
> +#ifdef CONFIG_EARLY_PRINTK
> +struct console *early_console;

... but this one is, causing

arch/sh/kernel/built-in.o: In function `setup_early_printk':
sh_bios.c:(.init.text+0xc80): undefined reference to `early_console'

Cfr. e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/8433720/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
