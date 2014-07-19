Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaGSRVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:21:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50366 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932319AbaGSRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:21:13 -0400
Message-ID: <1405790470.2032.10.camel@jarvis.lan>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2014 10:21:10 -0700
In-Reply-To: <20140719091156.GA31772@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
	 <43703371.jktNRIezc3@wuerfel> <20140719084152.GA31564@ravnborg.org>
	 <4967546.K5Yf5hcJE1@wuerfel> <20140719091156.GA31772@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-19 at 11:11 +0200, Sam Ravnborg wrote:
> On Sat, Jul 19, 2014 at 11:05:33AM +0200, Arnd Bergmann wrote:
> > On Saturday 19 July 2014 10:41:52 Sam Ravnborg wrote:
> > > > > 
> > > > > This set:
> > > > > #define inb_p(addr)     inb(addr)
> > > > > #define inw_p(addr)     inw(addr)
> > > > > #define inl_p(addr)     inl(addr)
> > > > > #define outb_p(x, addr) outb((x), (addr))
> > > > > #define outw_p(x, addr) outw((x), (addr))
> > > > > #define outl_p(x, addr) outl((x), (addr))
> > > > > 
> > > > > Should have a comment that say they are deprecated.
> > > > > Especially the "b" variants still have many users.
> > > > 
> > > > Are they? I don't remember ever seeing a reason to deprecate
> > > > them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
> > > > there may also be some drivers that use the same code for ISA
> > > > and PCI, and it doesn't really hurt on PCI.
> > > 
> > > It is my understanding that inl and inl_p are the same these days.
> > > A quick grep indicate that only m68k define the
> > > _p variant different from the other.
> > > But I failed to find and description of the difference between the
> > > two which is why I assumed they were identical and thus no need for both.
> > 
> > I don't know why m68k needs it, it's really an x86-specific
> > thing, see slow_down_io() in arch/x86/include/asm/io.h.
> 
> I had missed the x86 versions when grepping.
> Hmm, and with the macro tricks they play in asm/io.h this
> file is not at all grep friendly.
> 
> So xxx_p is for pause (or something like that).
> This also matches that m68k do some tricks with delay() in the _p variants.
> Thanks for the explanation.

Yes, the original x86 problem is that the CPU has a direct IO output bus
which you can connect to.  The in/out instructions activate the I/O pin
of the CPU indicating the address should be decoded by the device space.
Some devices are two slow to latch at the CPU speed, so if you do a
succession of in's or out's, particularly to mailbox locations, the
device misses some of the I/O transactions.  Adding the delay slows the
sequence down to the point where the device can react to it.

I/O cycle addressing is also problematic for architectures which don't
have an in/out instruction or the concept of I/O access (parisc uses a
special bridge to translate memory access to I/O cycles).

In theory, modern devices should be memory mapped (so capable of
reacting at CPU bus speed) but the PCI spec keeps the concept of I/O
mapping (triggering an I/O cycle instead of a memory one).  Most modern
PCI devices offer both memory and I/O mapped access and we always choose
the memory mapped one in that case.  Any device supporting both would
never need the delay.  However, the PCI spec still preserves the concept
of a legacy device that only has I/O ports, which would possibly need
the delay  ... the PCI SIG keeps threatening to deprecate the I/O BAR,
but haven't yet done so yes (as of PCIe version 3.0).

James


