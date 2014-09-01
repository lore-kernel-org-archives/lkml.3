Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaIAI64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:58:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63308 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIAI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <1409560606.30155.41.camel@linux.intel.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140830225407.GF7996@ZenIV.linux.org.uk>
	<1409560606.30155.41.camel@linux.intel.com>
Date: Mon, 1 Sep 2014 10:58:52 +0200
X-Google-Sender-Auth: DBEYOZn6cK_wZnvNrFOayxzS9dQ
Message-ID: <CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, Sep 1, 2014 at 10:36 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>> ... and extra copying for no good reason.  Why not check that we have
>> enough space in buffer and generate directly into it?  See what e.g.
>> seq_escape() is doing...
>
> What about this variant?

I think it needs a call to seq_set_overflow() in case the buffer is too small,
so the caller will retry with a bigger buffer.

>
> @@ -794,6 +795,47 @@ void seq_pad(struct seq_file *m, char c)
>  }
>  EXPORT_SYMBOL(seq_pad);
>
> +/* Analogue of print_hex_dump() */
> +void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
> +                 int rowsize, int groupsize, const void *buf, size_t len,
> +                 bool ascii)
> +{
> +       const u8 *ptr = buf;
> +       int i, linelen, remaining = len;
> +       int ret;
> +
> +       if (rowsize != 16 && rowsize != 32)
> +               rowsize = 16;
> +
> +       for (i = 0; i < len; i += rowsize) {
> +               linelen = min(remaining, rowsize);
> +               remaining -= rowsize;
> +
> +               ret = seq_printf(m, "%s", prefix_str);
> +               if (ret < 0)
> +                       break;
> +
> +               if (prefix_type == DUMP_PREFIX_ADDRESS)
> +                       ret = seq_printf(m, "%p: ", ptr + i);
> +               else if (prefix_type == DUMP_PREFIX_OFFSET)
> +                       ret = seq_printf(m, "%.8x: ", i);
> +               if (ret < 0)
> +                       break;
> +
> +               if (m->size < m->count + groupsize * 2 + 1)
> +                       break;
> +
> +               hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> +                                  m->buf + m->count, m->size - m->count,
> +                                  ascii);
> +
> +               ret = seq_putc(m, '\n');
> +               if (ret < 0)
> +                       break;
> +       }
> +}
> +EXPORT_SYMBOL(seq_hex_dump);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
