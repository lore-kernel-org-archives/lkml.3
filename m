Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaCLAAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:00:35 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:19524
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755794AbaCLAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:00:34 -0400
Message-ID: <1394582427.13761.74.camel@snotra.buserror.net>
Subject: Re: [PATCH 6/9] powerpc/85xx: support sleep feature on QorIQ SoCs
 with RCPM
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 19:00:27 -0500
In-Reply-To: <1394168285-32275-6-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-6-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR02CA010.namprd02.prod.outlook.com (10.141.66.20) To
 DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 01480965DA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6029001)(6009001)(428001)(377424004)(51704005)(24454002)(199002)(189002)(74366001)(47776003)(85852003)(79102001)(19580395003)(31966008)(88136002)(92566001)(69226001)(20776003)(51856001)(95416001)(59766001)(56816005)(81686001)(90146001)(63696002)(77096001)(74876001)(83072002)(87976001)(77982001)(46102001)(83322001)(93516002)(19580405001)(85306002)(95666003)(97336001)(33646001)(81342001)(81542001)(93136001)(87266001)(97186001)(87286001)(77156001)(42186004)(74662001)(53806001)(89996001)(50466002)(80976001)(23676002)(47736001)(74502001)(47446002)(94316002)(50226001)(49866001)(62966002)(65816001)(50986001)(80022001)(76482001)(93916002)(92726001)(94946001)(76796001)(86362001)(76786001)(56776001)(54316002)(47976001)(81816001)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:F79FF4D2.2F9199ED.40CF6275.4316DE41.2044E;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> In sleep mode, the clocks of e500 cores and unused IP blocks is
> turned off. The IP blocks which are allowed to wake up the processor
> are still running.
> 
> The sleep mode is equal to the Standby state in Linux. Use the
> command to enter sleep mode:
>   echo standby > /sys/power/state
> 
> Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/Kconfig                   |    4 +-
>  arch/powerpc/platforms/85xx/Makefile   |    3 +
>  arch/powerpc/platforms/85xx/qoriq_pm.c |   78 ++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/platforms/85xx/qoriq_pm.c
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 05f6323..e1d6510 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -222,7 +222,7 @@ config ARCH_HIBERNATION_POSSIBLE
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
>  	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
> -		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
> +		   FSL_SOC_BOOKE || PPC_86xx || PPC_PSERIES \
>  		   || 44x || 40x
>  
>  config PPC_DCR_NATIVE
> @@ -709,7 +709,7 @@ config FSL_PCI
>  config FSL_PMC
>  	bool
>  	default y
> -	depends on SUSPEND && (PPC_85xx || PPC_86xx)
> +	depends on SUSPEND && (PPC_85xx && !PPC_E500MC || PPC_86xx)

Don't mix && and || without parentheses.

Maybe convert this into being selected (similar to FSL_RCPM), rather
than default y?

> diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
> index 25cebe7..7fae817 100644
> --- a/arch/powerpc/platforms/85xx/Makefile
> +++ b/arch/powerpc/platforms/85xx/Makefile
> @@ -2,6 +2,9 @@
>  # Makefile for the PowerPC 85xx linux kernel.
>  #
>  obj-$(CONFIG_SMP) += smp.o
> +ifeq ($(CONFIG_FSL_CORENET_RCPM), y)
> +obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o
> +endif

There should probably be a kconfig symbol for this.

> diff --git a/arch/powerpc/platforms/85xx/qoriq_pm.c b/arch/powerpc/platforms/85xx/qoriq_pm.c
> new file mode 100644
> index 0000000..915b13b
> --- /dev/null
> +++ b/arch/powerpc/platforms/85xx/qoriq_pm.c
> @@ -0,0 +1,78 @@
> +/*
> + * Support Power Management feature
> + *
> + * Copyright 2014 Freescale Semiconductor Inc.
> + *
> + * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
> + *
> + * This program is free software; you can redistribute	it and/or modify it
> + * under  the terms of	the GNU General	 Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/suspend.h>
> +#include <linux/of_platform.h>
> +
> +#include <sysdev/fsl_soc.h>
> +
> +#define FSL_SLEEP		0x1
> +#define FSL_DEEP_SLEEP		0x2

FSL_DEEP_SLEEP is unused.

> +
> +/* specify the sleep state of the present platform */
> +int sleep_pm_state;
> +/* supported sleep modes by the present platform */
> +static unsigned int sleep_modes;

Why is one signed and the other unsigned?

> +
> +static int qoriq_suspend_enter(suspend_state_t state)
> +{
> +	int ret = 0;
> +
> +	switch (state) {
> +	case PM_SUSPEND_STANDBY:
> +
> +		if (cur_cpu_spec->cpu_flush_caches)
> +			cur_cpu_spec->cpu_flush_caches();
> +
> +		ret = qoriq_pm_ops->plat_enter_state(sleep_pm_state);
> +
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +
> +	}
> +
> +	return ret;
> +}
> +
> +static int qoriq_suspend_valid(suspend_state_t state)
> +{
> +	if (state == PM_SUSPEND_STANDBY && (sleep_modes & FSL_SLEEP))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static const struct platform_suspend_ops qoriq_suspend_ops = {
> +	.valid = qoriq_suspend_valid,
> +	.enter = qoriq_suspend_enter,
> +};
> +
> +static int __init qoriq_suspend_init(void)
> +{
> +	struct device_node *np;
> +
> +	sleep_modes = FSL_SLEEP;
> +	sleep_pm_state = PLAT_PM_SLEEP;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
> +	if (np)
> +		sleep_pm_state = PLAT_PM_LPM20;
> +
> +	suspend_set_ops(&qoriq_suspend_ops);
> +
> +	return 0;
> +}
> +arch_initcall(qoriq_suspend_init);

Why is this not a platform driver?  If fsl_pmc can do it...

-Scott


