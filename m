Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaAQPZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:25:22 -0500
Received: from smtp.citrix.com ([66.165.176.89]:57705 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaAQPZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:25:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,674,1384300800"; 
   d="scan'208";a="93893090"
Date: Fri, 17 Jan 2014 15:24:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <marc.zyngier@arm.com>, <will.deacon@arm.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <cov@codeaurora.org>
Subject: Re: [PATCH v9 3/5] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
In-Reply-To: <1389292336-9292-3-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1401171522170.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com> <1389292336-9292-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, Stefano Stabellini wrote:
> Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.
> 
> The only paravirt interface supported is pv_time_ops.steal_clock, so no
> runtime pvops patching needed.
> 
> This allows us to make use of steal_account_process_tick for stolen
> ticks accounting.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Christopher Covington <cov@codeaurora.org>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com
> CC: nico@linaro.org
> CC: marc.zyngier@arm.com
> CC: cov@codeaurora.org
> CC: arnd@arndb.de
> CC: olof@lixom.net

Russell? Do you have an opinion on this?


> Changes in v7:
> - ifdef CONFIG_PARAVIRT the content of paravirt.h.
> 
> Changes in v3:
> - improve commit description and Kconfig help text;
> - no need to initialize pv_time_ops;
> - add PARAVIRT_TIME_ACCOUNTING.
> ---
>  arch/arm/Kconfig                |   20 ++++++++++++++++++++
>  arch/arm/include/asm/paravirt.h |   20 ++++++++++++++++++++
>  arch/arm/kernel/Makefile        |    2 ++
>  arch/arm/kernel/paravirt.c      |   25 +++++++++++++++++++++++++
>  4 files changed, 67 insertions(+)
>  create mode 100644 arch/arm/include/asm/paravirt.h
>  create mode 100644 arch/arm/kernel/paravirt.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c1f1a7e..d6c3ba1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1874,6 +1874,25 @@ config SWIOTLB
>  config IOMMU_HELPER
>  	def_bool SWIOTLB
>  
> +config PARAVIRT
> +	bool "Enable paravirtualization code"
> +	---help---
> +	  This changes the kernel so it can modify itself when it is run
> +	  under a hypervisor, potentially improving performance significantly
> +	  over full virtualization.
> +
> +config PARAVIRT_TIME_ACCOUNTING
> +	bool "Paravirtual steal time accounting"
> +	select PARAVIRT
> +	default n
> +	---help---
> +	  Select this option to enable fine granularity task steal time
> +	  accounting. Time spent executing other tasks in parallel with
> +	  the current vCPU is discounted from the vCPU power. To account for
> +	  that, there can be a small performance impact.
> +
> +	  If in doubt, say N here.
> +
>  config XEN_DOM0
>  	def_bool y
>  	depends on XEN
> @@ -1885,6 +1904,7 @@ config XEN
>  	depends on !GENERIC_ATOMIC64
>  	select ARM_PSCI
>  	select SWIOTLB_XEN
> +	select PARAVIRT
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>  
> diff --git a/arch/arm/include/asm/paravirt.h b/arch/arm/include/asm/paravirt.h
> new file mode 100644
> index 0000000..8435ff59
> --- /dev/null
> +++ b/arch/arm/include/asm/paravirt.h
> @@ -0,0 +1,20 @@
> +#ifndef _ASM_ARM_PARAVIRT_H
> +#define _ASM_ARM_PARAVIRT_H
> +
> +#ifdef CONFIG_PARAVIRT
> +struct static_key;
> +extern struct static_key paravirt_steal_enabled;
> +extern struct static_key paravirt_steal_rq_enabled;
> +
> +struct pv_time_ops {
> +	unsigned long long (*steal_clock)(int cpu);
> +};
> +extern struct pv_time_ops pv_time_ops;
> +
> +static inline u64 paravirt_steal_clock(int cpu)
> +{
> +	return pv_time_ops.steal_clock(cpu);
> +}
> +#endif
> +
> +#endif
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index a30fc9b..34cf9a6 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -87,6 +87,7 @@ obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
>  ifneq ($(CONFIG_ARCH_EBSA110),y)
>    obj-y		+= io.o
>  endif
> +obj-$(CONFIG_PARAVIRT)	+= paravirt.o
>  
>  head-y			:= head$(MMUEXT).o
>  obj-$(CONFIG_DEBUG_LL)	+= debug.o
> diff --git a/arch/arm/kernel/paravirt.c b/arch/arm/kernel/paravirt.c
> new file mode 100644
> index 0000000..53f371e
> --- /dev/null
> +++ b/arch/arm/kernel/paravirt.c
> @@ -0,0 +1,25 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Copyright (C) 2013 Citrix Systems
> + *
> + * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> + */
> +
> +#include <linux/export.h>
> +#include <linux/jump_label.h>
> +#include <linux/types.h>
> +#include <asm/paravirt.h>
> +
> +struct static_key paravirt_steal_enabled;
> +struct static_key paravirt_steal_rq_enabled;
> +
> +struct pv_time_ops pv_time_ops;
> +EXPORT_SYMBOL_GPL(pv_time_ops);
> -- 
> 1.7.10.4
> 
