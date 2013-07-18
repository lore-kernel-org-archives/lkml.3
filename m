Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3GRKIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:08:36 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38479 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3GRKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <b57caaaed2bd127fe656e6c145970ed6a05c0125.1372515621.git.yann.morin.1998@free.fr>
References: <cover.1372515621.git.yann.morin.1998@free.fr>
	<b57caaaed2bd127fe656e6c145970ed6a05c0125.1372515621.git.yann.morin.1998@free.fr>
Date: Thu, 18 Jul 2013 12:08:33 +0200
X-Google-Sender-Auth: 1Bq8KOadfcmuJvPwcaTS_M8EfRE
Message-ID: <CAMuHMdUNQOiaia=j-+Cf7fW33ZfGi-kYAO0Y4qpCa5HBkKN8mQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] kconfig: allow "hex" and "range" to support longs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 4:21 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> From: Kees Cook <keescook@chromium.org>
>
> The parsing routines for Kconfig files use strtol(), but store and
> render values as int. Switch types and formating to long to support a
> wider range of values. For example, 0x80000000 wasn't representable.

0x80000000 does fit in an int. If it's printed as hex, it's treated as unsigned.
Is there a "0" missing, or am I missing something?

> Signed-off-by: Kees Cook <keescook@chromium.org>
> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> ---
>  scripts/kconfig/symbol.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index 387d554..d550300 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -136,7 +136,7 @@ static struct property *sym_get_range_prop(struct symbol *sym)
>         return NULL;
>  }
>
> -static int sym_get_range_val(struct symbol *sym, int base)
> +static long sym_get_range_val(struct symbol *sym, int base)
>  {
>         sym_calc_value(sym);
>         switch (sym->type) {

Changing all these "int" to "long" only matters on 64-bit platforms.
As kconfig is built on the host, this will cause different behavior when
cross-compiling 64-bit (I assume that's where you need it most) kernels
on a 32-bit or a 64-bit host.

Probably you wanted to use "long long" instead of "long", and switch
to "strtoll()", to make them always 64-bit?

Still, beware using 64-bit config symbols with arithmetic shell operations from
a Makefile, cfr. https://lkml.org/lkml/2013/6/13/200.

Sorry for only noticing now, after it went into 3.11-rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
