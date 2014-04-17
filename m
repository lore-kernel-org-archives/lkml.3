Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaDQS14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:27:56 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58245 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDQS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:27:47 -0400
MIME-Version: 1.0
In-Reply-To: <21117957.8m9iUdR1VN@wuerfel>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
	<9368307.RXEGmQia1C@wuerfel>
	<CAL_JsqJh1R8wxReCvTfE7GecZa0vMaAqnGa0ZoRBMace9qtzvQ@mail.gmail.com>
	<21117957.8m9iUdR1VN@wuerfel>
Date: Thu, 17 Apr 2014 13:27:46 -0500
Message-ID: <CAL_JsqJwKQ_KuWWQNZHrMh8NwwiubB2jR+g-Y2n_dH4kJ5zVow@mail.gmail.com>
Subject: Re: [PATCH 4/8] tty/serial: add generic serial earlycon
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 10:42 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 24 March 2014 08:36:46 Rob Herring wrote:
>> On Mon, Mar 24, 2014 at 6:29 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 24 March 2014 11:22:03 Catalin Marinas wrote:
>> >> On Fri, Mar 21, 2014 at 09:08:44PM +0000, Rob Herring wrote:
>> >> > diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
>> >> > new file mode 100644
>> >> > index 0000000..241757a
>> >> > --- /dev/null
>> >> > +++ b/drivers/tty/serial/earlycon.c
>> >> [...]
>> >> > +static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
>> >> > +{
>> >> > +   void __iomem *base;
>> >> > +#ifdef CONFIG_FIX_EARLYCON_MEM
>> >> > +   set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
>> >> > +   base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
>> >> > +   base += paddr & ~PAGE_MASK;
>> >> > +#else
>> >> > +   base = ioremap_nocache(paddr, size);
>> >> > +#endif
>> >>
>> >> Just curious why not set_fixmap_io (and plain ioremap)?
>> >
>> > Good point. Note that ioremap_nocache() is the same as ioremap()
>> > on *all* architectures.

Did you mean "not the same"? Why are there 2 flavors if they are
always the same.


>> I investigated this before adding this to arm64. set_fixmap_io and
>> set_fixmap_nocache are not the same settings on x86. Whether the
>> mapping type really matters on x86 or not, I don't know. So I added
>> the nocache variant to arm64 to avoid a change to x86.
>
> My best guess is that it's an x86 bug. ioremap() always uses an uncached
> mapping on x86, so it's strange to see early_ioremap() and set_fixmap_io()
> use a cached mapping. It probably doesn't matter as long as the mtrr is
> set up to treat all MMIO registers as non-cacheable, but I think there
> should not be a difference.

At some point it was believed to be needed on the 8250 driver. Perhaps
Alan can comment since the commit message tells us nothing:

commit 6f441fe99814f64315b8c11890744230b990c460
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Thu May 1 04:34:59 2008 -0700

    8250: switch 8250 drivers to use _nocache ioremaps

    Signed-off-by: Alan Cox <alan@redhat.com>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Rob
