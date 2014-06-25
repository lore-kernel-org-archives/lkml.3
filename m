Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaFYWdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:33:15 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43064 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755213AbaFYWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:33:13 -0400
Date: Wed, 25 Jun 2014 23:33:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
Message-ID: <20140625223302.GL32514@n2100.arm.linux.org.uk>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403717444-23559-9-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:30:43PM +0100, Sudeep Holla wrote:
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 38ddd9f..2c5ff0e 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -29,6 +29,7 @@ obj-y		+= entry-v7m.o v7m.o
>  else
>  obj-y		+= entry-armv.o
>  endif
> +obj-$(CONFIG_CPU_HAS_CACHE) += cacheinfo.o
>  
>  obj-$(CONFIG_OC_ETM)		+= etm.o
>  obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
> diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
> new file mode 100644
> index 0000000..ab70993
> --- /dev/null
> +++ b/arch/arm/kernel/cacheinfo.c
> @@ -0,0 +1,229 @@
> +/*
> + *  ARM cacheinfo support
> + *
> + *  Copyright (C) 2014 ARM Ltd.
> + *  All Rights Reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/cacheinfo.h>
> +#include <linux/cpu.h>
> +#include <linux/compiler.h>
> +#include <linux/of.h>
> +
> +#include <asm/cputype.h>
> +#include <asm/processor.h>
> +
> +#if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */

__LINUX_ARM_ARCH__ defines the minimum architecture version we are building
for - we may support later versions than the architecture version denoted
by this symbol.  It does not define which CPUs we are building for.  Are
you sure that this is correct here?  What if we build a kernel supporting
both v6 + v7, as the OMAP guys do?

> +
> +#define MAX_CACHE_LEVEL		1	/* Only 1 level supported */
> +#define CTR_CTYPE_SHIFT		24
> +#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
> +
> +struct ctr_info {
> +	unsigned int cpuid_id;
> +	unsigned int ctr;
> +};
> +
> +static struct ctr_info cache_ctr_list[] = {
> +};

This list needs to be populated.  Early CPUs (such as StrongARM) do not
have the CTR register.

> +static int get_unimplemented_ctr(unsigned int *ctr)
> +{
> +	int i, cpuid_id = read_cpuid_id();
> +
> +	for (i = 0; i < ARRAY_SIZE(cache_ctr_list); i++)
> +		if (cache_ctr_list[i].cpuid_id == cpuid_id) {
> +			*ctr = cache_ctr_list[i].ctr;
> +			return 0;
> +		}
> +	return -ENOENT;
> +}
> +
> +static unsigned int get_ctr(void)
> +{
> +	unsigned int ctr;
> +
> +	if (get_unimplemented_ctr(&ctr))
> +		asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));

read_cpuid_cachetype() ?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
