Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaAGXHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:07:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbaAGXHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:07:30 -0500
Date: Wed, 8 Jan 2014 00:07:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/6] ARM: Add Krait L2 accessor functions
Message-ID: <20140107230725.GG4164@pd.tnic>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388434457-4194-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 12:14:14PM -0800, Stephen Boyd wrote:
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
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/common/Kconfig                   |  3 ++
>  arch/arm/common/Makefile                  |  1 +
>  arch/arm/common/krait-l2-accessors.c      | 58 +++++++++++++++++++++++++++++++
>  arch/arm/include/asm/krait-l2-accessors.h | 20 +++++++++++

I'm no ARM guy but out of curiosity, why is this code not part of the
krait edac driver? IOW, is there a compelling reason for it to be in
arch/arm/common/?

>  4 files changed, 82 insertions(+)
>  create mode 100644 arch/arm/common/krait-l2-accessors.c
>  create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
> 
> diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
> index c3a4e9c..9da52dc 100644
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
> index 4bdc4162..2836f99 100644
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
> index 0000000..f17c361
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
> +void set_l2_indirect_reg(u32 addr, u32 val)
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
> +EXPORT_SYMBOL(set_l2_indirect_reg);
> +
> +u32 get_l2_indirect_reg(u32 addr)
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
> +EXPORT_SYMBOL(get_l2_indirect_reg);
> diff --git a/arch/arm/include/asm/krait-l2-accessors.h b/arch/arm/include/asm/krait-l2-accessors.h
> new file mode 100644
> index 0000000..d5305c4
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
> + */
> +
> +#ifndef __ASMARM_KRAIT_L2_ACCESSORS_H
> +#define __ASMARM_KRAIT_L2_ACCESSORS_H
> +
> +extern void set_l2_indirect_reg(u32 addr, u32 val);
> +extern u32 get_l2_indirect_reg(u32 addr);

No need for the "extern"s here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
