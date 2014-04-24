Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaDXP6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:58:52 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:46680 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaDXP6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <23940551.x13XR6zuRa@wuerfel>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<201404221559.37560.arnd@arndb.de>
	<CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
	<23940551.x13XR6zuRa@wuerfel>
Date: Thu, 24 Apr 2014 23:51:26 +0800
X-Google-Sender-Auth: CY8Fjn4np8Erd1671xlTsaPmJBA
Message-ID: <CAFiDJ59ZsPtoMT-P5_h24SCF8SYJhU8kti+M-Y1mfV4o0DP7ow@mail.gmail.com>
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 3:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 24 April 2014 14:02:47 Ley Foon Tan wrote:

>> >> +#define IO_SPACE_LIMIT 0xffffffff
>> >
>> > Please use 0xffff here, this should work for almost any PCI bus.
>> Ah, CONFIG_PCI is not enable in nios2. So, I think IO_SPACE_LIMIT
>> should set to 0.
>
> Yes, possibly with a comment added regarding PCI.
Sure.

>
>> >> +/*
>> >> + *   make the short names macros so specific devices
>> >> + *   can override them as required
>> >> + */
>> >> +#define inb(addr)            readb(addr)
>> >> +#define inw(addr)            readw(addr)
>> >> +#define inl(addr)            readl(addr)
>> >> +#define outb(x, addr)                ((void) writeb(x, addr))
>> >> +#define outw(x, addr)                ((void) writew(x, addr))
>> >> +#define outl(x, addr)                ((void) writel(x, addr))
>> >
>> > This makes no sense: the legacy PC I/O accessors take a completely
>> > different argument type: I would recommend to make both inline
>> > functions so you can ensure that readl() gets passed an __iomem
>> > pointer, while inl() gets an integer number.
>> >
>> > Please see the asm-generic version for an example. You should also
>> > define a non-NULL PCI_IOBASE to which the PCI I/O space gets mapped.
>> I think these macros can be removed if PCI is not enabled in Nios2.
>
> We have a bunch of ISA device drivers that use these interfaces but
> are not built conditionally through a Kconfig dependency. If you
> want 'allyesconfig' to build successfully, you have to provide some
> dummy implementation.
Okay, will provide empty write and read with return 0 dummy implementation here.

>
>> >> +#define ioport_map(port, nr) ioremap(port, nr)
>> >> +#define ioport_unmap(port)   iounmap(port)
>> >
>> > Use this one instead:
>> >
>> > #ifdef CONFIG_PCI
>> > static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
>> > {
>> >         return PCI_IOBASE + port;
>> > }
>> >
>> > static inline void __iomem *ioport_unmap(void __iomem *)
>> > {
>> > }
>> > #endif
>> These also can be removed.
>
> For this, there is a Kconfig symbol. If you don't provide ioport_map,
> you should set CONFIG_NO_IOPORT_MAP. Uwe Kleine-König has recently
> started some work in this area. Ideally we would also have a CONFIG_HAS_IOPORT
> option that is only set by architectures that actually implement inb/outb.
> Getting there still needs work, but any help is appreciated.
Will set CONFIG_NO_IOPORT_MAP. I noticed that there is
CONFIG_HAS_IOPORT_MAP, is it same as CONFIG_HAS_IOPORT you refer to?
But, seem only arch/sh is using it.
