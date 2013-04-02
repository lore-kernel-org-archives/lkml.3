Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833Ab3DBLDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:03:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47281 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760024Ab3DBLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:03:51 -0400
Date: Tue, 2 Apr 2013 12:02:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v4 1/2] arm: introduce psci_smp_ops
Message-ID: <20130402110255.GA26949@mudshark.cambridge.arm.com>
References: <1364575371-8926-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364575371-8926-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Fri, Mar 29, 2013 at 04:42:49PM +0000, Stefano Stabellini wrote:
> Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
> Remove mach-virt/platsmp.c, now unused.
> Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.
> 
> Add a cpu_die smp_op based on psci_ops.cpu_off.
> 
> Initialize PSCI before setting smp_ops in setup_arch.
> Use psci_smp_ops if the platform doesn't provide its own smp_ops.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: arnd@arndb.de
> CC: marc.zyngier@arm.com
> CC: linux@arm.linux.org.uk
> CC: nico@linaro.org
> ---
>  arch/arm/include/asm/psci.h  |    9 +++++
>  arch/arm/kernel/Makefile     |    5 ++-
>  arch/arm/kernel/psci.c       |    3 +-
>  arch/arm/kernel/psci_smp.c   |   67 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c      |    7 ++++-
>  arch/arm/mach-virt/Makefile  |    1 -
>  arch/arm/mach-virt/platsmp.c |   58 ------------------------------------
>  arch/arm/mach-virt/virt.c    |    3 --
>  8 files changed, 87 insertions(+), 66 deletions(-)
>  create mode 100644 arch/arm/kernel/psci_smp.c
>  delete mode 100644 arch/arm/mach-virt/platsmp.c
> 
> diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
> index ce0dbe7..4134dda 100644
> --- a/arch/arm/include/asm/psci.h
> +++ b/arch/arm/include/asm/psci.h
> @@ -32,5 +32,14 @@ struct psci_operations {
>  };
>  
>  extern struct psci_operations psci_ops;
> +extern struct smp_operations psci_smp_ops;
>  
> +#ifdef CONFIG_ARM_PSCI
> +int psci_init(void);
> +bool psci_smp_available(void);
> +#else
> +static inline int psci_init(void) { return -ENODEV; }
> +static inline bool psci_smp_available(void) { return false; }

You can probably make psci_init return void now that it's no longer an
initcall (you're not checking it's return value anyway).

> diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
> new file mode 100644
> index 0000000..66b0f77
> --- /dev/null
> +++ b/arch/arm/kernel/psci_smp.c
> @@ -0,0 +1,67 @@
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
> + * Copyright (C) 2012 ARM Limited
> + *
> + * Author: Will Deacon <will.deacon@arm.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/irqchip/arm-gic.h>
> +#include <linux/smp.h>
> +#include <linux/of.h>
> +
> +#include <asm/psci.h>
> +#include <asm/smp_plat.h>
> +
> +extern void secondary_startup(void);
> +
> +static int __cpuinit psci_boot_secondary(unsigned int cpu,
> +					 struct task_struct *idle)
> +{
> +	if (psci_ops.cpu_on)
> +		return psci_ops.cpu_on(cpu_logical_map(cpu),
> +				       __pa(secondary_startup));
> +	return -ENODEV;
> +}

Since this code is now likely to be shared, it could be worth a comment
before each function to describe the expected semantics (e.g. mpidr is used
as the CPUID, additional power state information is zero).

Cheers,

Will
