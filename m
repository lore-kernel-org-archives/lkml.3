Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaDXHo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:44:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:61349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaDXHo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:44:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
Date: Thu, 24 Apr 2014 09:43:52 +0200
Message-ID: <23940551.x13XR6zuRa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <201404221559.37560.arnd@arndb.de> <CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:mtV9ccVPR53TO1heMKRpZJWrovOZfso+kAAQ64GouS5
 XsM3hKzuTwbGMTs8+0706RnxB7/YrOR1tTRy05wzqnCtlayEwZ
 rRSpQG6Y4IgcvZYN9837eeN64cs6Jtf+BrqL9nDu9aoW7qD/uA
 QW6JkY95X/NeW22xXAd/f7vYWaXEBh3EEeiwjvIj0N428KcrXC
 VKrwwVQe9Q0QLMy1+PWT2/zErFImLFQeuRj1vOsWAxoJ8Wid5f
 cVqP+3xEVV81dTBegY+TlEFVAyXV1QfJc43+h9jezlDGkMGJuh
 aS+CBf0EyAR67/lJwlCxs1VOqLzg1BorV9yk6KzIbUT0vmRwQR
 bJx3pfQN+zKsm26FA9Fs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2014 14:02:47 Ley Foon Tan wrote:
> On Tue, Apr 22, 2014 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 18 April 2014, Ley Foon Tan wrote:
> >
> >> +
> >> +#include <asm/pgtable-bits.h>
> >> +
> >> +#define IO_SPACE_LIMIT 0xffffffff
> >
> > Please use 0xffff here, this should work for almost any PCI bus.
> Ah, CONFIG_PCI is not enable in nios2. So, I think IO_SPACE_LIMIT
> should set to 0.

Yes, possibly with a comment added regarding PCI.

> >> +/*
> >> + *   make the short names macros so specific devices
> >> + *   can override them as required
> >> + */
> >> +#define inb(addr)            readb(addr)
> >> +#define inw(addr)            readw(addr)
> >> +#define inl(addr)            readl(addr)
> >> +#define outb(x, addr)                ((void) writeb(x, addr))
> >> +#define outw(x, addr)                ((void) writew(x, addr))
> >> +#define outl(x, addr)                ((void) writel(x, addr))
> >
> > This makes no sense: the legacy PC I/O accessors take a completely
> > different argument type: I would recommend to make both inline
> > functions so you can ensure that readl() gets passed an __iomem
> > pointer, while inl() gets an integer number.
> >
> > Please see the asm-generic version for an example. You should also
> > define a non-NULL PCI_IOBASE to which the PCI I/O space gets mapped.
> I think these macros can be removed if PCI is not enabled in Nios2.

We have a bunch of ISA device drivers that use these interfaces but
are not built conditionally through a Kconfig dependency. If you
want 'allyesconfig' to build successfully, you have to provide some
dummy implementation.

> >> +#define ioport_map(port, nr) ioremap(port, nr)
> >> +#define ioport_unmap(port)   iounmap(port)
> >
> > Use this one instead:
> >
> > #ifdef CONFIG_PCI
> > static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> > {
> >         return PCI_IOBASE + port;
> > }
> >
> > static inline void __iomem *ioport_unmap(void __iomem *)
> > {
> > }
> > #endif
> These also can be removed.

For this, there is a Kconfig symbol. If you don't provide ioport_map,
you should set CONFIG_NO_IOPORT_MAP. Uwe Kleine-König has recently
started some work in this area. Ideally we would also have a CONFIG_HAS_IOPORT
option that is only set by architectures that actually implement inb/outb.
Getting there still needs work, but any help is appreciated.

	Arnd
