Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3DBPJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:09:51 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58049 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848Ab3DBPJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:09:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,394,1363132800"; 
   d="scan'208";a="16935261"
Date: Tue, 2 Apr 2013 16:09:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v4 1/2] arm: introduce psci_smp_ops
In-Reply-To: <20130402110255.GA26949@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1304021535420.5078@kaball.uk.xensource.com>
References: <1364575371-8926-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130402110255.GA26949@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Will Deacon wrote:
> > diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
> > index ce0dbe7..4134dda 100644
> > --- a/arch/arm/include/asm/psci.h
> > +++ b/arch/arm/include/asm/psci.h
> > @@ -32,5 +32,14 @@ struct psci_operations {
> >  };
> >  
> >  extern struct psci_operations psci_ops;
> > +extern struct smp_operations psci_smp_ops;
> >  
> > +#ifdef CONFIG_ARM_PSCI
> > +int psci_init(void);
> > +bool psci_smp_available(void);
> > +#else
> > +static inline int psci_init(void) { return -ENODEV; }
> > +static inline bool psci_smp_available(void) { return false; }
> 
> You can probably make psci_init return void now that it's no longer an
> initcall (you're not checking it's return value anyway).

Sure.


> > diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
> > new file mode 100644
> > index 0000000..66b0f77
> > --- /dev/null
> > +++ b/arch/arm/kernel/psci_smp.c
> > @@ -0,0 +1,67 @@
> > +/*
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Copyright (C) 2012 ARM Limited
> > + *
> > + * Author: Will Deacon <will.deacon@arm.com>
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/irqchip/arm-gic.h>
> > +#include <linux/smp.h>
> > +#include <linux/of.h>
> > +
> > +#include <asm/psci.h>
> > +#include <asm/smp_plat.h>
> > +
> > +extern void secondary_startup(void);
> > +
> > +static int __cpuinit psci_boot_secondary(unsigned int cpu,
> > +					 struct task_struct *idle)
> > +{
> > +	if (psci_ops.cpu_on)
> > +		return psci_ops.cpu_on(cpu_logical_map(cpu),
> > +				       __pa(secondary_startup));
> > +	return -ENODEV;
> > +}
> 
> Since this code is now likely to be shared, it could be worth a comment
> before each function to describe the expected semantics (e.g. mpidr is used
> as the CPUID, additional power state information is zero).

OK. I'll document psci_operations in psci.h.
