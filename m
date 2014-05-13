Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaEMSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:25:07 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63117 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaEMSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:24:59 -0400
MIME-Version: 1.0
In-Reply-To: <6202090.0OtAjefIFT@wuerfel>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de>
	<20140513174640.GA20961@infradead.org>
	<6202090.0OtAjefIFT@wuerfel>
Date: Tue, 13 May 2014 20:24:59 +0200
X-Google-Sender-Auth: oR2FAt3VxYfN9NE2fX10c2j4hKc
Message-ID: <CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 8:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 May 2014 10:46:40 Christoph Hellwig wrote:
>> On Tue, May 13, 2014 at 05:33:01PM +0200, Thomas Gleixner wrote:
>> > and it
>> > would be dumb as hell to have new archs use time_t 32bit when we are
>> > currently twisting our brain around how to solve the y2038
>> > problem. Simply because we can not do the BSD flag day approach and
>> > change it.
>>
>> I don't think it's a good idea to have minor new architectures
>> pointlessly different than the major ones.  Especially given that we'll
>> absolutely have to fir the y2038 problem for 32-bit arm and probably
>> x86 anyway.
>
> I've just spent two days looking at stuff that uses time_t inside
> of the kernel, to get a better idea of what we actually need to
> do to get provide new user interfaces for the existing architectures.
>
> My impression so far is that we're better off fixing it for the
> existing architectures first and then using the new interfaces
> exclusively on new ones, rather than changing over the ABI for
> all new architectures at this point, which would likely create
> yet another variant to maintain in the long run.

Makes sense.

> Using 64-bit time_t on x32 is fine, because it's fast to operate
> in user space with 64-bit registers, and the kernel is 64-bit
> anyway. Inside of the kernel, we may get into trouble using
> a 64-bit time_t on 32-bit architectures because of the overhead
> in 64-bit math, e.g. all the timekeeping code that is based on
> timespec or some code paths in file systems and network code where
> we actually require division of time_t values.

While going over time_t uses, have you found a pattern for use cases
involving division of time_t values in filesystem and networking code?

> We clearly have to change that code in some for to deal with y2038,
> but 64-bit time_t may not be the best option. A lot of the
> in-kernel code can probably use ktime_t, which we can change
> to a different representation (e.g. 34 bit seconds) if needed,
> and all the code that is only interested in relative time
> (e.g. nanosleep) doesn't have to change at all.

Yeah. 32-bit uptimes should be good enough for everyone (don't quote
me on that), so adding a 64-bit offset when there's a need for absolute
time should be OK.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
