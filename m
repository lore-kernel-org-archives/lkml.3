Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3H1Khf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:37:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41454 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752458Ab3H1Khe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:37:34 -0400
Date: Wed, 28 Aug 2013 07:37:33 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-ID: <20130828103732.GB2348@localhost>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Andrew suggested you might have opinions on this, so I'm cc'ing you.
Since you'll probably want some better context, here it is:

http://lwn.net/Articles/564709/

On Sat, Aug 24, 2013 at 12:35:29PM -0300, Ezequiel Garcia wrote:
> Some platforms have MMIO regions that are shared across orthogonal
> subsystems. This commit implements a possible solution for the
> thread-safe access of such regions through a spinlock-protected API.
> 
> Concurrent access is protected with a single spinlock for the
> entire MMIO address space. While this protects shared-registers,
> it also serializes access to unrelated/unshared registers.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  include/linux/io.h |  5 +++++
>  lib/Makefile       |  2 +-
>  lib/atomicio.c     | 27 +++++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
>  create mode 100644 lib/atomicio.c
> 
> diff --git a/include/linux/io.h b/include/linux/io.h
> index f4f42fa..c331dcb 100644
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
> +
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
> +static DEFINE_RAW_SPINLOCK(__io_lock);
> +void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
> +{
> +	unsigned long flags;
> +	u32 value;
> +
> +	raw_spin_lock_irqsave(&__io_lock, flags);
> +	value = readl(reg) & ~mask;
> +	value |= (set & mask);
> +	writel(value, reg);
> +	raw_spin_unlock_irqrestore(&__io_lock, flags);
> +
> +}
> +EXPORT_SYMBOL(atomic_io_modify);
> +#endif
> -- 
> 1.8.1.5
> 

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
