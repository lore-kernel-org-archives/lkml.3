Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3HLPqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:46:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757197Ab3HLPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:46:50 -0400
Date: Mon, 12 Aug 2013 12:46:47 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
Message-ID: <20130812154646.GA5460@localhost>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130810140237.GB3080@localhost>
 <20130810140927.GC3080@localhost>
 <1376149388.716003514@f150.i.mail.ru>
 <20130810155552.GB17936@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130810155552.GB17936@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 12:55:53PM -0300, Ezequiel Garcia wrote:
> On Sat, Aug 10, 2013 at 07:43:08PM +0400, Alexander Shiyan wrote:
> > > On Sat, Aug 10, 2013 at 11:02:38AM -0300, Ezequiel Garcia wrote:
> > > > On Sat, Aug 10, 2013 at 04:49:28PM +0400, Alexander Shiyan wrote:
> > > > > > Some SoC have MMIO regions that are shared across orthogonal
> > > > > > subsystems. This commit implements a possible solution for the
> > > > > > thread-safe access of such regions through a spinlock-protected API
> > > > > > with clear-set semantics.
> > > > > > 
> > > > > > Concurrent access is protected with a single spinlock for the
> > > > > > entire MMIO address space. While this protects shared-registers,
> > > > > > it also serializes access to unrelated/unshared registers.
> > [...]
> > > > > > +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> > > > > > +{
> > > > > > +	spin_lock(&__io_lock);
> > > > > > +	writel((readl(reg) & ~clear) | set, reg);
> > > > > > +	spin_unlock(&__io_lock);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL(atomic_io_clear_set);
> > > > > 
> > > > > So, one lock is used to all possible registers?
> > > > > Seems a regmap-mmio can be used for such access.
> > > > > 
> > > > 
> > > > Thanks for the hint! Quite frankly, I wasn't familiar with regmap-mmio.
> > > > 
> > > > However, after reading some code, I fail to see how that helps in this case.
> > > > 
> > > > Note that we need to access the *same* MMIO address from completely
> > > > different (and unrelated) drivers, such as watchdog and clocksource.
> > > > 
> > > > So I wonder who would "own" the regmap descriptor, and how does the other
> > > > one gets aware of that descriptor?
> > > > 
> > > > In addition given we can use orion_wdt (originally meant for mach-kirkwood)
> > > > to support mvebu SoC watchdog, we need to sort this out in a completely
> > > > multiplatform capable way.
> > > > 
> > > > Ideas?
> > > 
> > > Answering myself...
> > > 
> > > How about using drivers/mfd/syscon.c to create the regmap owner for the shared
> > > register (TIMER_CTRL in this case, but others might appear) ?
> > > 
> > > Or adding a new mfd implementation if syscon does not fit ?
> > > 
> > > Does this sound like an overkill ?
> > 
> > Yes, syscon is designed especially for such cases.
> > 
> 
> Indeed, syscon looks like a nice match for this use case.
> (although it still looks like an overkill to me).
> 
> I've been trying to implement a working solution based in syscon but I'm
> unable to overcome an issue.
> 
> The problem is that we need the register/regmap to initialize the clocksource
> driver for this machine (aka the timer). Of course, this happens at a
> *very* early point, way before the syscon driver is available... :-(
> 
> Maybe someone has an idea?

Sebastian, Russell: I can't find the previous mail where you proposed
this solution to address the shared register issue between Kirkwood's
watchdog and clocksource.

Is this what you had in mind?

Do you think trying to use a regmap could be better (given we can
sort out the problem explained above)?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
