Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaIAJKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:10:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:38858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaIAJKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="584483916"
Message-ID: <1409562596.30155.43.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Date: Mon, 01 Sep 2014 12:09:56 +0300
In-Reply-To: <CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140830225407.GF7996@ZenIV.linux.org.uk>
	 <1409560606.30155.41.camel@linux.intel.com>
	 <CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 10:58 +0200, Geert Uytterhoeven wrote:
> Hi Andy,
> 
> On Mon, Sep 1, 2014 at 10:36 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >> ... and extra copying for no good reason.  Why not check that we have
> >> enough space in buffer and generate directly into it?  See what e.g.
> >> seq_escape() is doing...
> >
> > What about this variant?
> 
> I think it needs a call to seq_set_overflow() in case the buffer is too small,
> so the caller will retry with a bigger buffer.

Yes, in two places it would be useful to do.

But what the condition for "buffer is too small", the same groupsize * 2
+ 1 or you mean something else?

> 
> >
> > @@ -794,6 +795,47 @@ void seq_pad(struct seq_file *m, char c)
> >  }
> >  EXPORT_SYMBOL(seq_pad);
> >
> > +/* Analogue of print_hex_dump() */
> > +void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
> > +                 int rowsize, int groupsize, const void *buf, size_t len,
> > +                 bool ascii)
> > +{
> > +       const u8 *ptr = buf;
> > +       int i, linelen, remaining = len;
> > +       int ret;
> > +
> > +       if (rowsize != 16 && rowsize != 32)
> > +               rowsize = 16;
> > +
> > +       for (i = 0; i < len; i += rowsize) {
> > +               linelen = min(remaining, rowsize);
> > +               remaining -= rowsize;
> > +
> > +               ret = seq_printf(m, "%s", prefix_str);
> > +               if (ret < 0)
> > +                       break;
> > +
> > +               if (prefix_type == DUMP_PREFIX_ADDRESS)
> > +                       ret = seq_printf(m, "%p: ", ptr + i);
> > +               else if (prefix_type == DUMP_PREFIX_OFFSET)
> > +                       ret = seq_printf(m, "%.8x: ", i);
> > +               if (ret < 0)
> > +                       break;
> > +
> > +               if (m->size < m->count + groupsize * 2 + 1)
> > +                       break;
> > +
> > +               hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> > +                                  m->buf + m->count, m->size - m->count,
> > +                                  ascii);
> > +
> > +               ret = seq_putc(m, '\n');
> > +               if (ret < 0)
> > +                       break;
> > +       }
> > +}
> > +EXPORT_SYMBOL(seq_hex_dump);
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

