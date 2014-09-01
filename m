Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaIAKQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:16:03 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:36505 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIAKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXUsK9Uwd8EVqiWW8rDsUe=h7U8bGntx=bfWYQ5j91x+A@mail.gmail.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140830225407.GF7996@ZenIV.linux.org.uk>
	<1409560606.30155.41.camel@linux.intel.com>
	<CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
	<1409562596.30155.43.camel@linux.intel.com>
	<CAMuHMdXUsK9Uwd8EVqiWW8rDsUe=h7U8bGntx=bfWYQ5j91x+A@mail.gmail.com>
Date: Mon, 1 Sep 2014 13:15:59 +0300
Message-ID: <CAHp75VeNegxwTB617mRXBomERjLbATASMM0tReUgZWprQEnXng@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
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

On Mon, Sep 1, 2014 at 12:25 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Andy,
>
> On Mon, Sep 1, 2014 at 11:09 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Mon, 2014-09-01 at 10:58 +0200, Geert Uytterhoeven wrote:
>>> On Mon, Sep 1, 2014 at 10:36 AM, Andy Shevchenko
>>> <andriy.shevchenko@linux.intel.com> wrote:
>>> >> ... and extra copying for no good reason.  Why not check that we have
>>> >> enough space in buffer and generate directly into it?  See what e.g.
>>> >> seq_escape() is doing...
>>> >
>>> > What about this variant?
>>>
>>> I think it needs a call to seq_set_overflow() in case the buffer is too small,
>>> so the caller will retry with a bigger buffer.
>>
>> Yes, in two places it would be useful to do.
>
> Two places? I see only one, just before calling hex_dump_to_buffer.

seq_putc doesn't set it as I can see.

>> But what the condition for "buffer is too small", the same groupsize * 2
>> + 1 or you mean something else?
>
> "groupsize * 2 + 1" is not the amount of bytes hex_dump_to_buffer() wants
> to write. It's only the size for one word.
>
> You could check if there are at least "32 * 3 + 2 + 32 + 1" bytes (your
> old linebuf size) available.

This is a good question why this number? What if we have to print only
one byte (as different groupsize)?
I think the requirement for one groupsize is quite okay.

> However, to protect against overflows if hex_dump_to_buffer() ever changes,
> I think it would be better to let hex_dump_to_buffer() indicate if the
> passed buffer was to small (it already checks the passed linebuflen).
> Then you can just check for that.

I thought about that. We may introduce either new call and make
current one the user of it or change all occurrences.
Nevertheless, currently it will print only one groupsize if there is
enough room for it but for two or more.
Thus, I prefer to keep the behaviour "print until we can".

-- 
With Best Regards,
Andy Shevchenko
