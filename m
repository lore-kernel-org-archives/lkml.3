Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3H0UhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:37:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3H0UhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:37:12 -0400
Date: Tue, 27 Aug 2013 13:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-Id: <20130827133709.64b4743950b911d6dfe7fab8@linux-foundation.org>
In-Reply-To: <1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Aug 2013 12:35:29 -0300 Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> Some platforms have MMIO regions that are shared across orthogonal
> subsystems. This commit implements a possible solution for the
> thread-safe access of such regions through a spinlock-protected API.

Seem sensible.  Perhaps.

It only works if both subsystems agree to use atomic_io_modify().  And
if they're both capable of doing that, they are both capable of
implementing an agreed-upon internal locking scheme, so why bother?

And the advantage of having the two subsystems agree on a locking
scheme is that they then will not share a lock with all other
subsystems which use atomic IO.  That lock you use in lib/atomicio.c
could become heavily contended.  Although such contention problems
could be easily fixed up by using an array of locks within
atomic_io_modify(), keyed by a hash of the io address.

> Concurrent access is protected with a single spinlock for the
> entire MMIO address space. While this protects shared-registers,
> it also serializes access to unrelated/unshared registers.

I'd suggest cc'ing Linus on this material - he might have opinons.

> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -101,4 +101,9 @@ static inline void arch_phys_wc_del(int handle)
>  #define arch_phys_wc_add arch_phys_wc_add
>  #endif
>  
> +#ifndef __HAVE_ARCH_ATOMIC_IO_MODIFY
> +/* Atomic MMIO-wide IO modify */
> +extern void atomic_io_modify(void __iomem *reg, u32 mask, u32 set);
> +#endif

I disagree with the presence of the ifndef.  If
__HAVE_ARCH_ATOMIC_IO_MODIFY is undefined, the architecture must still
implement the identical function signature.  The best way to ensure that
is to use the same prototype in both cases.

>  #endif /* _LINUX_IO_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 7baccfd..695d6e2 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> -	 earlycpio.o percpu-refcount.o
> +	 earlycpio.o percpu-refcount.o atomicio.o
>  
>  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
> diff --git a/lib/atomicio.c b/lib/atomicio.c
> new file mode 100644
> index 0000000..1750f9d
> --- /dev/null
> +++ b/lib/atomicio.c
> @@ -0,0 +1,27 @@
> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +
> +#ifndef __HAVE_ARCH_ATOMIC_IO_MODIFY
> +/*
> + * Generic atomic MMIO modify.
> + *
> + * Allows thread-safe access to registers shared by unrelated subsystems.
> + * The access is protected by a single MMIO-wide lock.
> + *
> + * Optimized variants can be implemented on a per-architecture basis.
> + */

Some kerneldoc would be nice.

> +static DEFINE_RAW_SPINLOCK(__io_lock);

This could be local to atomic_io_modify().

> +void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
> +{
> +	unsigned long flags;
> +	u32 value;
> +
> +	raw_spin_lock_irqsave(&__io_lock, flags);
> +	value = readl(reg) & ~mask;
> +	value |= (set & mask);

Could just be "value |= set".  The code as you have it permits callers
to set bits in "set" which aren't permitted in "mask", which would be
pretty darn stupid of them.

> +	writel(value, reg);
> +	raw_spin_unlock_irqrestore(&__io_lock, flags);
> +
> +}
> +EXPORT_SYMBOL(atomic_io_modify);
> +#endif

What about 8, 16 and 64-bit IO addresses?

