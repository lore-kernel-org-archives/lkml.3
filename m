Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3H1KYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:24:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41384 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752513Ab3H1KYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:24:23 -0400
Date: Wed, 28 Aug 2013 07:24:23 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-ID: <20130828102422.GA2348@localhost>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130827133709.64b4743950b911d6dfe7fab8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130827133709.64b4743950b911d6dfe7fab8@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:37:09PM -0700, Andrew Morton wrote:
> On Sat, 24 Aug 2013 12:35:29 -0300 Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> 
> > Some platforms have MMIO regions that are shared across orthogonal
> > subsystems. This commit implements a possible solution for the
> > thread-safe access of such regions through a spinlock-protected API.
> 
> Seem sensible.  Perhaps.
> 
> It only works if both subsystems agree to use atomic_io_modify().  And
> if they're both capable of doing that, they are both capable of
> implementing an agreed-upon internal locking scheme, so why bother?
> 

One of the scenarios where this could be helpful and an agreed-upon
lock seemed difficult to design is this: a watchdog driver that shares
some control register with *two* different clocksource drivers.

So, one first solution is to have a function in the two clocksource
drivers (with matching prototype) and have the watchdog access
the register through it.

However, because of multiplatform builds, both these clocksource drivers
could be built at the same time. Therefore we would have a symbol
collision, doubly-defined, in each driver.

How would that work? What other internal locking scheme could we
implement?

BTW, this is the current use case we are trying to fix.
This atomic function seemed like a simpler (perhaps cleaner?) approach.

[..]
> 
> I disagree with the presence of the ifndef.  If
> __HAVE_ARCH_ATOMIC_IO_MODIFY is undefined, the architecture must still
> implement the identical function signature.  The best way to ensure that
> is to use the same prototype in both cases.
> 

I agree, but how can this be done?

I'm looking at examples, such as include/asm-generic/atomic.h or
include/linux/string.h and they all do this sort of trick.

> >  #endif /* _LINUX_IO_H */
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 7baccfd..695d6e2 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
> >  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
> >  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> >  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> > -	 earlycpio.o percpu-refcount.o
> > +	 earlycpio.o percpu-refcount.o atomicio.o
> >  
> >  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >  lib-$(CONFIG_MMU) += ioremap.o
> > diff --git a/lib/atomicio.c b/lib/atomicio.c
> > new file mode 100644
> > index 0000000..1750f9d
> > --- /dev/null
> > +++ b/lib/atomicio.c
> > @@ -0,0 +1,27 @@
> > +#include <linux/io.h>
> > +#include <linux/spinlock.h>
> > +
> > +#ifndef __HAVE_ARCH_ATOMIC_IO_MODIFY
> > +/*
> > + * Generic atomic MMIO modify.
> > + *
> > + * Allows thread-safe access to registers shared by unrelated subsystems.
> > + * The access is protected by a single MMIO-wide lock.
> > + *
> > + * Optimized variants can be implemented on a per-architecture basis.
> > + */
> 
> Some kerneldoc would be nice.
> 

Ok.

> > +static DEFINE_RAW_SPINLOCK(__io_lock);
> 
> This could be local to atomic_io_modify().
> 

Ok.

> > +void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
> > +{
> > +	unsigned long flags;
> > +	u32 value;
> > +
> > +	raw_spin_lock_irqsave(&__io_lock, flags);
> > +	value = readl(reg) & ~mask;
> > +	value |= (set & mask);
> 
> Could just be "value |= set".  The code as you have it permits callers
> to set bits in "set" which aren't permitted in "mask", which would be
> pretty darn stupid of them.
> 

Right.

> > +	writel(value, reg);
> > +	raw_spin_unlock_irqrestore(&__io_lock, flags);
> > +
> > +}
> > +EXPORT_SYMBOL(atomic_io_modify);
> > +#endif
> 
> What about 8, 16 and 64-bit IO addresses?
> 

Right, forgot about these. I guess we can add those if we agree about the approach.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
