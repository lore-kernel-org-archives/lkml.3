Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab3HJOCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 10:02:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933806Ab3HJOCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 10:02:42 -0400
Date: Sat, 10 Aug 2013 11:02:38 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
Message-ID: <20130810140237.GB3080@localhost>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138968.556911297@f376.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376138968.556911297@f376.i.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 04:49:28PM +0400, Alexander Shiyan wrote:
> > Some SoC have MMIO regions that are shared across orthogonal
> > subsystems. This commit implements a possible solution for the
> > thread-safe access of such regions through a spinlock-protected API
> > with clear-set semantics.
> > 
> > Concurrent access is protected with a single spinlock for the
> > entire MMIO address space. While this protects shared-registers,
> > it also serializes access to unrelated/unshared registers.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > ---
> >  arch/arm/include/asm/io.h |  5 +++++
> >  arch/arm/kernel/io.c      | 24 ++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> > index d070741..c84658d 100644
> > --- a/arch/arm/include/asm/io.h
> > +++ b/arch/arm/include/asm/io.h
> > @@ -36,6 +36,11 @@
> >  #define isa_bus_to_virt phys_to_virt
> >  
> >  /*
> > + * Atomic MMIO-wide IO clear/set
> > + */
> > +extern void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set);
> > +
> > +/*
> >   * Generic IO read/write.  These perform native-endian accesses.  Note
> >   * that some architectures will want to re-define __raw_{read,write}w.
> >   */
> > diff --git a/arch/arm/kernel/io.c b/arch/arm/kernel/io.c
> > index dcd5b4d..3ab8201 100644
> > --- a/arch/arm/kernel/io.c
> > +++ b/arch/arm/kernel/io.c
> > @@ -1,6 +1,30 @@
> >  #include <linux/export.h>
> >  #include <linux/types.h>
> >  #include <linux/io.h>
> > +#include <linux/spinlock.h>
> > +
> > +static DEFINE_SPINLOCK(__io_lock);
> > +
> > +/*
> > + * Some platforms have MMIO regions that are shared across orthogonal
> > + * subsystems. This API implements thread-safe access to such regions
> > + * through a spinlock-protected API with clear-set semantics.
> > + *
> > + * Concurrent access is protected with a single spinlock for the entire MMIO
> > + * address space. While this protects shared-registers, it also serializes
> > + * access to unrelated/unshared registers.
> > + *
> > + * Using this API on frequently accessed registers in performance-critical
> > + * paths is not recommended, as the spinlock used by this API would become
> > + * highly contended.
> > + */
> > +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> > +{
> > +	spin_lock(&__io_lock);
> > +	writel((readl(reg) & ~clear) | set, reg);
> > +	spin_unlock(&__io_lock);
> > +}
> > +EXPORT_SYMBOL(atomic_io_clear_set);
> 
> So, one lock is used to all possible registers?
> Seems a regmap-mmio can be used for such access.
> 

Thanks for the hint! Quite frankly, I wasn't familiar with regmap-mmio.

However, after reading some code, I fail to see how that helps in this case.

Note that we need to access the *same* MMIO address from completely
different (and unrelated) drivers, such as watchdog and clocksource.

So I wonder who would "own" the regmap descriptor, and how does the other
one gets aware of that descriptor?

In addition given we can use orion_wdt (originally meant for mach-kirkwood)
to support mvebu SoC watchdog, we need to sort this out in a completely
multiplatform capable way.

Ideas?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
