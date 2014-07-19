Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbaGSHow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:44:52 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50020 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaGSHot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:44:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Thierry Reding <thierry.reding@gmail.com>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Sat, 19 Jul 2014 09:44:09 +0200
Message-ID: <5913515.3g98ODuH6W@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140718205953.GA21964@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com> <20140718205953.GA21964@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M04eV93gzVKSbmtGJ84H3CcuWq2AipTeI1nh876qP8g
 ZVJdbjLbX/dlPtQma6R7DOGiNLkGtozcmrVFzYzYBMVdeAYjpy
 QxRHBM6C0rCVKFREIcj5xNVQxjplNR2f7nJJkTIQjuRdtkhnSL
 PiA+o6b5MvLBfHnpJBNSo91F70Xpa5HDsILJAY9LpHqPWNx2F1
 cTcmGBM5+B0PG/Levhsd5t7bfgVEuc99hMZ+/msxSBQlZwo7vb
 Avftj5Y9K3/saMdaRUGaLICJdbZz8rYq8lxX7rQIQv7jKbJpJL
 trztyQAu1mtNdbZkRXmmjGq3ZZqpMOJkGJQq5wsTROzRgaAV1N
 0yLqhiT25BS0QCM0jwfg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 22:59:53 Sam Ravnborg wrote:
> On Wed, Jul 16, 2014 at 01:01:22PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > 
> > Currently driver writers need to use io{read,write}{8,16,32}_rep() when
> > accessing FIFO registers portably. This is bad for two reasons: it is
> > inconsistent with how other registers are accessed using the standard
> > {read,write}{b,w,l}() functions, which can lead to confusion. On some
> > architectures the io{read,write}*() functions also need to perform some
> > extra checks to determine whether an address is memory-mapped or refers
> > to I/O space. Drivers which can be expected to never use I/O can safely
> > use the {read,write}s{b,w,l,q}(), just like they use their non-string
> > variants and there's no need for these extra checks.
> > 
> > This patch implements generic versions of readsb(), readsw(), readsl(),
> > readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> > these string functions for I/O accesses (ins*() and outs*() as well as
> > ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> > new functions.
> > 
> > Going forward, {read,write}{,s}{b,w,l,q}() should be used consistently
> > by drivers for devices that will only ever be memory-mapped and hence
> > don't need to access I/O space, whereas io{read,write}{8,16,32}_rep()
> > should be used by drivers for devices that can be either memory-mapped
> > or I/O-mapped.
> > 
> > While at it, also make sure that any of the functions provided as
> > fallback for architectures that don't override them can't be overridden
> > subsequently.
> > 
> > This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> > tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> > OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> > find or build a cross-compiler that would run on my system. But by code
> > inspection they shouldn't break with this patch.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> 
> Hi Thierry.
> 
> While browsing the resulting asm-generic/io.h it is irritating
> that the functions are messed up like they are.
> 
> From the start of the file the IO accessors are defined in following order:
> __raw_readb
> __raw_readw
> __raw_readl
> 
> readb
> readw
> readl
> 
> __raw_writeb
> __raw_writew
> __raw_writel
> 
> writeb
> writew
> writel
> 
> __raw_readq
> 
> readq
> 
> __raw_writeq
> 
> writeq
> 
> 
> See how strange it looks?

It saves one #ifdef CONFIG_64BIT to do it like this, but I guess
you are right that reordering them slightly would be nice here.

> A semi related question.
> Why do we play all these macro tricks in io.h?
> 
> Example:
> 
>     #define writeb __raw_writeb
> 
> The consensus these days is to use static inline to have the
> correct prototype but this file is contains a lot of these
> macro conversions.
> 
> All these things are not introduced by your patch but now that
> you show some love and care for this file maybe we could take
> the next step and bring more order to the current semi chaos?

The macros are mainly there so we can test their presence with
#ifdef. The interface is complex enough that there is probably
an architecture for any combination of overrides: most should
override the __raw_*() functions with inline assembly, but a lot
don't do that and it works because of implementation details of
the compiler. Some may need to override either readl() or
readl_relaxed() but not the other one.

For this reason, we want architecture-level files that include
the asm-generic version to use macros (or macro + inline function)
rather than a plain inline.

I was arguing earlier that we don't need the extra macros in the
asm-generic version, but it also doesn't hurt and it can make
it slightly easier for new architectures to copy the bits from
asm-generic they want to override.

	Arnd
