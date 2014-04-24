Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaDXGCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:02:51 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36616 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaDXGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <201404221559.37560.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397845149-3141-1-git-send-email-lftan@altera.com>
	<1397845149-3141-3-git-send-email-lftan@altera.com>
	<201404221559.37560.arnd@arndb.de>
Date: Thu, 24 Apr 2014 14:02:47 +0800
X-Google-Sender-Auth: JkQpXomdDK2dwdKyHvhWqTe-F20
Message-ID: <CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 April 2014, Ley Foon Tan wrote:
>
>> +
>> +#include <asm/pgtable-bits.h>
>> +
>> +#define IO_SPACE_LIMIT 0xffffffff
>
> Please use 0xffff here, this should work for almost any PCI bus.
Ah, CONFIG_PCI is not enable in nios2. So, I think IO_SPACE_LIMIT
should set to 0.


>> +
>> +/* Use "Duff's Device" to unroll the loops. */
>> +#define __IO_OUT_LOOP(a, b, l)                               \
>> +     do {                                            \
>> +             if (l > 0) {                            \
>> +                     int _n = (l + 7) / 8;           \
>> +                     switch (l % 8) {                \
>> +                     case 0:                         \
>> +                             do {                    \
>> +                                     *a = *b++;      \
>
> I would recommend just doing all of this in out-of-line implementations
> rather than macros and inline functions.
Okay. Will move the macros to out-of-line function.


>
>> +
>> +/*
>> + *   make the short names macros so specific devices
>> + *   can override them as required
>> + */
>> +#define inb(addr)            readb(addr)
>> +#define inw(addr)            readw(addr)
>> +#define inl(addr)            readl(addr)
>> +#define outb(x, addr)                ((void) writeb(x, addr))
>> +#define outw(x, addr)                ((void) writew(x, addr))
>> +#define outl(x, addr)                ((void) writel(x, addr))
>
> This makes no sense: the legacy PC I/O accessors take a completely
> different argument type: I would recommend to make both inline
> functions so you can ensure that readl() gets passed an __iomem
> pointer, while inl() gets an integer number.
>
> Please see the asm-generic version for an example. You should also
> define a non-NULL PCI_IOBASE to which the PCI I/O space gets mapped.
I think these macros can be removed if PCI is not enabled in Nios2.

>
>> +#define virt_to_bus virt_to_phys
>> +#define bus_to_virt phys_to_virt
>
> Please drop these, and the CONFIG_VIRT_TO_BUS Kconfig option,
> and fix all drivers that rely on it.
Okay. Will remove these.

>
>> +#define ioport_map(port, nr) ioremap(port, nr)
>> +#define ioport_unmap(port)   iounmap(port)
>
> Use this one instead:
>
> #ifdef CONFIG_PCI
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
>         return PCI_IOBASE + port;
> }
>
> static inline void __iomem *ioport_unmap(void __iomem *)
> {
> }
> #endif
These also can be removed.

>
>> +/* Macros used for smc91x.c driver */
>> +#define readsb(p, d, l)              insb(p, d, l)
>> +#define readsw(p, d, l)              insw(p, d, l)
>> +#define readsl(p, d, l)              insl(p, d, l)
>> +#define writesb(p, d, l)     outsb(p, d, l)
>> +#define writesw(p, d, l)     outsw(p, d, l)
>> +#define writesl(p, d, l)     outsl(p, d, l)
>
> These should of course not fall back to the PCI I/O space functions.
> You can do it the other way round.
Okay, these will change to something like:
#define readsb(p, d, l)              io_insb(p, d, l)
#define readsw(p, d, l)              io_insw(p, d, l)
(etc)

Regards
Ley Foon
