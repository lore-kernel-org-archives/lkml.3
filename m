Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaCNWqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:46:25 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:42179
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755456AbaCNWqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:46:23 -0400
Message-ID: <1394837160.12479.129.camel@snotra.buserror.net>
Subject: Re: [PATCH 6/9] powerpc/85xx: support sleep feature on QorIQ SoCs
 with RCPM
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Fri, 14 Mar 2014 17:46:00 -0500
In-Reply-To: <20140312080814.GE4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-6-git-send-email-chenhui.zhao@freescale.com>
	 <1394582427.13761.74.camel@snotra.buserror.net>
	 <20140312080814.GE4706@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR02CA005.namprd02.prod.outlook.com (10.141.66.15) To
 BLUPR03MB389.namprd03.prod.outlook.com (10.141.78.11)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6029001)(428001)(377424004)(24454002)(51704005)(189002)(199002)(51856001)(20776003)(93516002)(81816001)(63696002)(47776003)(69226001)(46102001)(74662001)(88136002)(81686001)(47446002)(74502001)(79102001)(95666003)(59766001)(31966008)(23676002)(94316002)(94946001)(54316002)(56776001)(76482001)(80022001)(65816001)(53806001)(86362001)(33646001)(93916002)(95416001)(42186004)(74366001)(87976001)(97186001)(77096001)(77156001)(74876001)(50466002)(74706001)(87266001)(76786001)(76796001)(56816005)(47736001)(49866001)(89996001)(50226001)(85852003)(83072002)(50986001)(47976001)(85306002)(83322001)(19580405001)(19580395003)(80976001)(62966002)(81342001)(81542001)(92566001)(90146001)(92726001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:EF9FF4D2.AF9295ED.4CCE62A5.4626DE81.20495;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 16:08 +0800, Chenhui Zhao wrote:
> On Tue, Mar 11, 2014 at 07:00:27PM -0500, Scott Wood wrote:
> > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > In sleep mode, the clocks of e500 cores and unused IP blocks is
> > > turned off. The IP blocks which are allowed to wake up the processor
> > > are still running.
> > > 
> > > The sleep mode is equal to the Standby state in Linux. Use the
> > > command to enter sleep mode:
> > >   echo standby > /sys/power/state
> > > 
> > > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > > ---
> > >  arch/powerpc/Kconfig                   |    4 +-
> > >  arch/powerpc/platforms/85xx/Makefile   |    3 +
> > >  arch/powerpc/platforms/85xx/qoriq_pm.c |   78 ++++++++++++++++++++++++++++++++
> > >  3 files changed, 83 insertions(+), 2 deletions(-)
> > >  create mode 100644 arch/powerpc/platforms/85xx/qoriq_pm.c
> > > 
> > > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > > index 05f6323..e1d6510 100644
> > > --- a/arch/powerpc/Kconfig
> > > +++ b/arch/powerpc/Kconfig
> > > @@ -222,7 +222,7 @@ config ARCH_HIBERNATION_POSSIBLE
> > >  config ARCH_SUSPEND_POSSIBLE
> > >  	def_bool y
> > >  	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
> > > -		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
> > > +		   FSL_SOC_BOOKE || PPC_86xx || PPC_PSERIES \
> > >  		   || 44x || 40x
> > >  
> > >  config PPC_DCR_NATIVE
> > > @@ -709,7 +709,7 @@ config FSL_PCI
> > >  config FSL_PMC
> > >  	bool
> > >  	default y
> > > -	depends on SUSPEND && (PPC_85xx || PPC_86xx)
> > > +	depends on SUSPEND && (PPC_85xx && !PPC_E500MC || PPC_86xx)
> > 
> > Don't mix && and || without parentheses.
> > 
> > Maybe convert this into being selected (similar to FSL_RCPM), rather
> > than default y?
> 
> Yes, will do.
> 
> > 
> > > diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
> > > index 25cebe7..7fae817 100644
> > > --- a/arch/powerpc/platforms/85xx/Makefile
> > > +++ b/arch/powerpc/platforms/85xx/Makefile
> > > @@ -2,6 +2,9 @@
> > >  # Makefile for the PowerPC 85xx linux kernel.
> > >  #
> > >  obj-$(CONFIG_SMP) += smp.o
> > > +ifeq ($(CONFIG_FSL_CORENET_RCPM), y)
> > > +obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o
> > > +endif
> > 
> > There should probably be a kconfig symbol for this.
> 
> OK.
> 
> > 
> > > diff --git a/arch/powerpc/platforms/85xx/qoriq_pm.c b/arch/powerpc/platforms/85xx/qoriq_pm.c
> > > new file mode 100644
> > > index 0000000..915b13b
> > > --- /dev/null
> > > +++ b/arch/powerpc/platforms/85xx/qoriq_pm.c
> > > @@ -0,0 +1,78 @@
> > > +/*
> > > + * Support Power Management feature
> > > + *
> > > + * Copyright 2014 Freescale Semiconductor Inc.
> > > + *
> > > + * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
> > > + *
> > > + * This program is free software; you can redistribute	it and/or modify it
> > > + * under  the terms of	the GNU General	 Public License as published by the
> > > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > > + * option) any later version.
> > > + */
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/suspend.h>
> > > +#include <linux/of_platform.h>
> > > +
> > > +#include <sysdev/fsl_soc.h>
> > > +
> > > +#define FSL_SLEEP		0x1
> > > +#define FSL_DEEP_SLEEP		0x2
> > 
> > FSL_DEEP_SLEEP is unused.
> 
> Will be used in the last patch.
> [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040

Ideally the #define would have been introduced in that patch.

> > > +	sleep_modes = FSL_SLEEP;
> > > +	sleep_pm_state = PLAT_PM_SLEEP;
> > > +
> > > +	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
> > > +	if (np)
> > > +		sleep_pm_state = PLAT_PM_LPM20;
> > > +
> > > +	suspend_set_ops(&qoriq_suspend_ops);
> > > +
> > > +	return 0;
> > > +}
> > > +arch_initcall(qoriq_suspend_init);
> > 
> > Why is this not a platform driver?  If fsl_pmc can do it...
> > 
> > -Scott
> 
> It can be, but what advantage of being a platform driver.

If nothing else, compliance with the standard way of doing things.  Why
not make it a platform driver?  You'd be able to use dev_err, have a
place in sysfs if attributes are needed in the future, etc.

A better answer might be that there are multiple not-very-related files
driving different portions of RCPM.

-Scott


