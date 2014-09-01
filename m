Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaIALdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:33:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:13523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaIALdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:33:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="scan'208";a="584535919"
Message-ID: <1409571222.30155.55.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Date: Mon, 01 Sep 2014 14:33:42 +0300
In-Reply-To: <CAMuHMdWcWD2nMoRNooC=aMTMk07R9vmOfc1mzeNQJO8JATS8fA@mail.gmail.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140830225407.GF7996@ZenIV.linux.org.uk>
	 <1409560606.30155.41.camel@linux.intel.com>
	 <CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
	 <1409562596.30155.43.camel@linux.intel.com>
	 <CAMuHMdXUsK9Uwd8EVqiWW8rDsUe=h7U8bGntx=bfWYQ5j91x+A@mail.gmail.com>
	 <CAHp75VeNegxwTB617mRXBomERjLbATASMM0tReUgZWprQEnXng@mail.gmail.com>
	 <CAMuHMdWcWD2nMoRNooC=aMTMk07R9vmOfc1mzeNQJO8JATS8fA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 12:59 +0200, Geert Uytterhoeven wrote:
> Hi Andy,
> 
> On Mon, Sep 1, 2014 at 12:15 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >>>> I think it needs a call to seq_set_overflow() in case the buffer is too small,
> >>>> so the caller will retry with a bigger buffer.
> >>>
> >>> Yes, in two places it would be useful to do.
> >>
> >> Two places? I see only one, just before calling hex_dump_to_buffer.
> >
> > seq_putc doesn't set it as I can see.
> >
> >>> But what the condition for "buffer is too small", the same groupsize * 2
> >>> + 1 or you mean something else?
> >>
> >> "groupsize * 2 + 1" is not the amount of bytes hex_dump_to_buffer() wants
> >> to write. It's only the size for one word.
> >>
> >> You could check if there are at least "32 * 3 + 2 + 32 + 1" bytes (your
> >> old linebuf size) available.
> >
> > This is a good question why this number? What if we have to print only
> > one byte (as different groupsize)?
> 
> I don't think complaining about a too-small buffer prematurely hurts.
> 
> > I think the requirement for one groupsize is quite okay.
> 
> Then you will loose data if the buffer is too small.
> 
> >> However, to protect against overflows if hex_dump_to_buffer() ever changes,
> >> I think it would be better to let hex_dump_to_buffer() indicate if the
> >> passed buffer was to small (it already checks the passed linebuflen).
> >> Then you can just check for that.
> >
> > I thought about that. We may introduce either new call and make
> > current one the user of it or change all occurrences.
> > Nevertheless, currently it will print only one groupsize if there is
> > enough room for it but for two or more.
> > Thus, I prefer to keep the behaviour "print until we can".
> 
> The idea of seq_*() is that it will retry with a bigger bufsize if there's
> not enough space.

Fair enough.

So, summarize above, the check before hex_dump_to_buffer() should care
about maximum possible buffer needed for one line. But we have already
rowsize calculated (we actually can't rely on groupsize in this case).

Do you agree with formula rowsize * 3 + 2 + rowsize + 1?

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

