Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3HXXVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 19:21:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50346 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3HXXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 19:21:11 -0400
Date: Sun, 25 Aug 2013 00:15:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-ID: <20130824231526.GS6617@n2100.arm.linux.org.uk>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com> <1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com> <CAFLxGvxLyGH1Xgq6=Y5Z9x=DtBmjWnE+x9X-65RKY1=8dhL_OA@mail.gmail.com> <20130824195858.GA5957@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824195858.GA5957@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 04:58:59PM -0300, Ezequiel Garcia wrote:
> On Sat, Aug 24, 2013 at 08:27:10PM +0200, richard -rw- weinberger wrote:
> > On Sat, Aug 24, 2013 at 5:35 PM, Ezequiel Garcia
> > <ezequiel.garcia@free-electrons.com> wrote:
> > > Some platforms have MMIO regions that are shared across orthogonal
> > > subsystems. This commit implements a possible solution for the
> > > thread-safe access of such regions through a spinlock-protected API.
> > >
> > > Concurrent access is protected with a single spinlock for the
> > > entire MMIO address space. While this protects shared-registers,
> > > it also serializes access to unrelated/unshared registers.
> > >
> > > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > > ---
> > >  include/linux/io.h |  5 +++++
> > >  lib/Makefile       |  2 +-
> > >  lib/atomicio.c     | 27 +++++++++++++++++++++++++++
> > >  3 files changed, 33 insertions(+), 1 deletion(-)
> > >  create mode 100644 lib/atomicio.c
> > >
> > > diff --git a/include/linux/io.h b/include/linux/io.h
> > > index f4f42fa..c331dcb 100644
> > > --- a/include/linux/io.h
> > > +++ b/include/linux/io.h
> > > @@ -101,4 +101,9 @@ static inline void arch_phys_wc_del(int handle)
> > >  #define arch_phys_wc_add arch_phys_wc_add
> > >  #endif
> > >
> > > +#ifndef __HAVE_ARCH_ATOMIC_IO_MODIFY
> > > +/* Atomic MMIO-wide IO modify */
> > > +extern void atomic_io_modify(void __iomem *reg, u32 mask, u32 set);
> > > +#endif
> > > +
> > >  #endif /* _LINUX_IO_H */
> > > diff --git a/lib/Makefile b/lib/Makefile
> > > index 7baccfd..695d6e2 100644
> > > --- a/lib/Makefile
> > > +++ b/lib/Makefile
> > > @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
> > >          sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
> > >          proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> > >          is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> > > -        earlycpio.o percpu-refcount.o
> > > +        earlycpio.o percpu-refcount.o atomicio.o
> > >
> > >  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> > >  lib-$(CONFIG_MMU) += ioremap.o
> > > diff --git a/lib/atomicio.c b/lib/atomicio.c
> > > new file mode 100644
> > > index 0000000..1750f9d
> > > --- /dev/null
> > > +++ b/lib/atomicio.c
> > > @@ -0,0 +1,27 @@
> > > +#include <linux/io.h>
> > > +#include <linux/spinlock.h>
> > > +
> > > +#ifndef __HAVE_ARCH_ATOMIC_IO_MODIFY
> > > +/*
> > > + * Generic atomic MMIO modify.
> > > + *
> > > + * Allows thread-safe access to registers shared by unrelated subsystems.
> > > + * The access is protected by a single MMIO-wide lock.
> > > + *
> > > + * Optimized variants can be implemented on a per-architecture basis.
> > > + */
> > > +static DEFINE_RAW_SPINLOCK(__io_lock);
> > > +void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
> > > +{
> > > +       unsigned long flags;
> > > +       u32 value;
> > > +
> > > +       raw_spin_lock_irqsave(&__io_lock, flags);
> > > +       value = readl(reg) & ~mask;
> > > +       value |= (set & mask);
> > > +       writel(value, reg);
> > > +       raw_spin_unlock_irqrestore(&__io_lock, flags);
> > > +
> > > +}
> > > +EXPORT_SYMBOL(atomic_io_modify);
> > 
> > Why not the default case EXPORT_SYMBOL_GPL()?
> > 
> 
> Because I copy-pasted the export from some other lib/.. :-)
> 
> Mind explaining me the difference, why you say _GPL it's the default,
> and why EXPORT_SYMBOL is more frequently used in lib/ ?

This is actually a decision solely for the author of the code which is
being created: it's a statement about the _use_ of the symbol.

Do you wish to permit your code to be used by modules with non-GPL
compatible licenses - such as closed source modules?  If so, then use
EXPORT_SYMBOL().

If you wish your code to only be used by GPL compatible modules, then
use EXPORT_SYMBOL_GPL().

Things get a little murkey if you call code which has been exported with
EXPORT_SYMBOL_GPL() and you wish to mark your new function with
EXPORT_SYMBOL(), because you're effectively bypassing acess restrictions
to taht code put in place by the original code author (you're not in this
case, but I'm including this statement for completeness.)
