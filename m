Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaDGUSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:18:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDGUSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:18:44 -0400
Date: Mon, 7 Apr 2014 22:18:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v6 2/5] ARM: Add Krait L2 register accessor functions
Message-ID: <20140407201838.GC20822@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396641450-12854-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:57:27PM -0700, Stephen Boyd wrote:
> Krait CPUs have a handful of L2 cache controller registers that
> live behind a cp15 based indirection register. First you program
> the indirection register (l2cpselr) to point the L2 'window'
> register (l2cpdr) at what you want to read/write.  Then you
> read/write the 'window' register to do what you want. The
> l2cpselr register is not banked per-cpu so we must lock around
> accesses to it to prevent other CPUs from re-pointing l2cpdr
> underneath us.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/common/Kconfig                   |  3 ++
>  arch/arm/common/Makefile                  |  1 +
>  arch/arm/common/krait-l2-accessors.c      | 58 +++++++++++++++++++++++++++++++
>  arch/arm/include/asm/krait-l2-accessors.h | 20 +++++++++++
>  4 files changed, 82 insertions(+)
>  create mode 100644 arch/arm/common/krait-l2-accessors.c
>  create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
> 
> diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
> index c3a4e9ceba34..9da52dc6260b 100644
> --- a/arch/arm/common/Kconfig
> +++ b/arch/arm/common/Kconfig
> @@ -9,6 +9,9 @@ config DMABOUNCE
>  	bool
>  	select ZONE_DMA
>  
> +config KRAIT_L2_ACCESSORS
> +	bool
> +
>  config SHARP_LOCOMO
>  	bool
>  
> diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
> index 70b1eff477b3..6b2cddf6e8d0 100644
> --- a/arch/arm/common/Makefile
> +++ b/arch/arm/common/Makefile
> @@ -7,6 +7,7 @@ obj-y				+= firmware.o
>  obj-$(CONFIG_ICST)		+= icst.o
>  obj-$(CONFIG_SA1111)		+= sa1111.o
>  obj-$(CONFIG_DMABOUNCE)		+= dmabounce.o
> +obj-$(CONFIG_KRAIT_L2_ACCESSORS) += krait-l2-accessors.o
>  obj-$(CONFIG_SHARP_LOCOMO)	+= locomo.o
>  obj-$(CONFIG_SHARP_PARAM)	+= sharpsl_param.o
>  obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
> diff --git a/arch/arm/common/krait-l2-accessors.c b/arch/arm/common/krait-l2-accessors.c
> new file mode 100644
> index 000000000000..5d514bbc88a6
> --- /dev/null
> +++ b/arch/arm/common/krait-l2-accessors.c
> @@ -0,0 +1,58 @@
> +/*
> + * Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.

Can we refer to COPYING here instead of adding that boilerplate to every
file?

> + */
> +
> +#include <linux/spinlock.h>
> +#include <linux/export.h>
> +
> +#include <asm/barrier.h>
> +#include <asm/krait-l2-accessors.h>
> +
> +static DEFINE_RAW_SPINLOCK(krait_l2_lock);
> +
> +void krait_set_l2_indirect_reg(u32 addr, u32 val)
> +{
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&krait_l2_lock, flags);
> +	/*
> +	 * Select the L2 window by poking l2cpselr, then write to the window
> +	 * via l2cpdr.
> +	 */
> +	asm volatile ("mcr p15, 3, %0, c15, c0, 6 @ l2cpselr" : : "r" (addr));
> +	isb();
> +	asm volatile ("mcr p15, 3, %0, c15, c0, 7 @ l2cpdr" : : "r" (val));
> +	isb();
> +
> +	raw_spin_unlock_irqrestore(&krait_l2_lock, flags);
> +}
> +EXPORT_SYMBOL(krait_set_l2_indirect_reg);
> +
> +u32 krait_get_l2_indirect_reg(u32 addr)
> +{
> +	u32 val;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&krait_l2_lock, flags);
> +	/*
> +	 * Select the L2 window by poking l2cpselr, then read from the window
> +	 * via l2cpdr.
> +	 */
> +	asm volatile ("mcr p15, 3, %0, c15, c0, 6 @ l2cpselr" : : "r" (addr));
> +	isb();
> +	asm volatile ("mrc p15, 3, %0, c15, c0, 7 @ l2cpdr" : "=r" (val));
> +
> +	raw_spin_unlock_irqrestore(&krait_l2_lock, flags);
> +
> +	return val;
> +}
> +EXPORT_SYMBOL(krait_get_l2_indirect_reg);
> diff --git a/arch/arm/include/asm/krait-l2-accessors.h b/arch/arm/include/asm/krait-l2-accessors.h
> new file mode 100644
> index 000000000000..48fe5527bc01
> --- /dev/null
> +++ b/arch/arm/include/asm/krait-l2-accessors.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.

Ditto.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
