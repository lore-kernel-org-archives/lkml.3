Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3H1Iyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:54:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59768 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754Ab3H1Iym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:54:42 -0400
Date: Wed, 28 Aug 2013 09:53:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <Will.Deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 2/4] ARM: Add atomic_io_modify optimized routines
Message-ID: <20130828085340.GB58219@MacBook-Pro.local>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1377358532-23802-3-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377358532-23802-3-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 04:35:30PM +0100, Ezequiel Garcia wrote:
> Implement arch-specific atomic_io_modify and atomic_io_modify_relaxed,
> which are based on writel/readl_relaxed and writel_relaxed/readl_relaxed,
> respectively.
> In both cases, by relaxing the readl, perfomance can be improved.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  arch/arm/include/asm/io.h |  4 ++++
>  arch/arm/kernel/io.c      | 29 +++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index d070741..53637b6 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -397,5 +397,9 @@ extern int devmem_is_allowed(unsigned long pfn);
>  extern void register_isa_ports(unsigned int mmio, unsigned int io,
>  			       unsigned int io_shift);
>  
> +#define __HAVE_ARCH_ATOMIC_IO_MODIFY
> +extern void atomic_io_modify(void __iomem *reg, u32 mask, u32 set);
> +extern void atomic_io_modify_relaxed(void __iomem *reg, u32 mask, u32 set);
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* __ASM_ARM_IO_H */
> diff --git a/arch/arm/kernel/io.c b/arch/arm/kernel/io.c
> index dcd5b4d..a8c9c9b 100644
> --- a/arch/arm/kernel/io.c
> +++ b/arch/arm/kernel/io.c
> @@ -1,6 +1,35 @@
>  #include <linux/export.h>
>  #include <linux/types.h>
>  #include <linux/io.h>
> +#include <linux/spinlock.h>
> +
> +static DEFINE_RAW_SPINLOCK(__io_lock);
> +
> +void atomic_io_modify_relaxed(void __iomem *reg, u32 mask, u32 set)
> +{
> +	unsigned long flags;
> +	u32 value;
> +
> +	raw_spin_lock_irqsave(&__io_lock, flags);
> +	value = readl_relaxed(reg) & ~mask;
> +	value |= (set & mask);
> +	writel_relaxed(value, reg);
> +	raw_spin_unlock_irqrestore(&__io_lock, flags);
> +}
> +EXPORT_SYMBOL(atomic_io_modify_relaxed);
> +
> +void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
> +{
> +	unsigned long flags;
> +	u32 value;
> +
> +	raw_spin_lock_irqsave(&__io_lock, flags);
> +	value = readl_relaxed(reg) & ~mask;
> +	value |= (set & mask);
> +	writel(value, reg);
> +	raw_spin_unlock_irqrestore(&__io_lock, flags);
> +}
> +EXPORT_SYMBOL(atomic_io_modify);

Is this any different from the generic one introduced in patch 1/4? I
would rather just use the generic definition. Similarly, a generic
atomic_io_modify_relaxed() but guarded with something like
__HAVE_ARCH_RELAXED_IO.

-- 
Catalin
