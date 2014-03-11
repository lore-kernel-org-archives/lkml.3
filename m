Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaCKXsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:48:21 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:46895
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753083AbaCKXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:48:20 -0400
Message-ID: <1394581693.13761.66.camel@snotra.buserror.net>
Subject: Re: [PATCH 4/9] powerpc/85xx: support CPU hotplug for e500mc and
 e5500
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 18:48:13 -0500
In-Reply-To: <1394168285-32275-4-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-4-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR04CA017.namprd04.prod.outlook.com (10.141.154.145)
 To DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 0147E151B5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(189002)(377424004)(50226001)(49866001)(62966002)(50986001)(65816001)(89996001)(50466002)(80976001)(74662001)(53806001)(94316002)(47736001)(23676002)(74502001)(47446002)(47976001)(54316002)(56776001)(81816001)(4396001)(76482001)(80022001)(76796001)(94946001)(76786001)(86362001)(93916002)(92726001)(90146001)(56816005)(81686001)(74876001)(77982001)(46102001)(83072002)(87976001)(63696002)(77096001)(85852003)(79102001)(74366001)(47776003)(20776003)(51856001)(92566001)(88136002)(69226001)(59766001)(95416001)(31966008)(77156001)(42186004)(87286001)(85306002)(97336001)(95666003)(93516002)(83322001)(87266001)(97186001)(93136001)(33646001)(81342001)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:D8D97C76.CF25D2AC.79F656B4.80E4D260.20237;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index ac2621a..f3f4401 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -405,8 +405,12 @@ void generic_cpu_die(unsigned int cpu)
>  
>  	for (i = 0; i < 100; i++) {
>  		smp_rmb();
> -		if (per_cpu(cpu_state, cpu) == CPU_DEAD)
> +		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
> +#ifdef CONFIG_PPC64
> +			paca[cpu].cpu_start = 0;
> +#endif

Why wasn't this needed by previous ppc64 machines?

> diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> index 2e5911e..0047883 100644
> --- a/arch/powerpc/platforms/85xx/smp.c
> +++ b/arch/powerpc/platforms/85xx/smp.c
> @@ -19,6 +19,7 @@
>  #include <linux/kexec.h>
>  #include <linux/highmem.h>
>  #include <linux/cpu.h>
> +#include <linux/smp.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/pgtable.h>
> @@ -46,6 +47,17 @@ static u64 timebase;
>  static int tb_req;
>  static int tb_valid;
>  
> +#ifdef CONFIG_PPC_E500MC
> +/* specify the cpu PM state when cpu dies, PH15/NAP is the default */
> +int qoriq_cpu_die_state = E500_PM_PH15;
> +#endif

static?  Is there any way to modify this other than modifying source
code?

BTW, QorIQ doesn't imply an e500mc derivative.

> @@ -125,6 +138,34 @@ static void mpc85xx_take_timebase(void)
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +#ifdef CONFIG_PPC_E500MC
> +static void qoriq_cpu_die(void)
> +{
> +	unsigned int cpu = smp_processor_id();
> +
> +	local_irq_disable();
> +#ifdef CONFIG_PPC64
> +	__hard_irq_disable();
> +#endif

Why this instead of one call to hard_irq_disable() (no leading
underscores)?

-Scott


