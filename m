Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaCKXv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:51:29 -0400
Received: from mail-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:4772
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755208AbaCKXv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:51:28 -0400
Message-ID: <1394581880.13761.69.camel@snotra.buserror.net>
Subject: Re: [PATCH 5/9] powerpc/85xx: disable irq by hardware when suspend
 for 64-bit
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 18:51:20 -0500
In-Reply-To: <1394168285-32275-5-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-5-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR07CA014.namprd07.prod.outlook.com (10.141.154.172)
 To DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0147E151B5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(51704005)(199002)(189002)(77982001)(97186001)(97336001)(59766001)(92566001)(79102001)(85852003)(94946001)(95416001)(56816005)(33646001)(93136001)(81342001)(63696002)(49866001)(47976001)(50226001)(50986001)(47736001)(77096001)(83322001)(23676002)(19580395003)(19580405001)(83072002)(77156001)(80976001)(47776003)(90146001)(95666003)(89996001)(81542001)(81686001)(93516002)(81816001)(93916002)(92726001)(86362001)(94316002)(62966002)(31966008)(54316002)(74662001)(76482001)(65816001)(42186004)(69226001)(51856001)(53806001)(80022001)(47446002)(88136002)(74502001)(46102001)(74876001)(87286001)(85306002)(56776001)(50466002)(76786001)(74366001)(76796001)(87976001)(87266001)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:5CDBC3D5.E73E9F1D.31F42BB2.88ACFE31.201F5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> In 64-bit mode, kernel just clears the irq soft-enable flag
> in struct paca_struct to disable external irqs. But, in
> the case of suspend, irqs should be disabled by hardware.
> Therefore, hook a function to ppc_md.suspend_disable_irqs
> to really disable irqs.
> 
> Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/platforms/85xx/corenet_generic.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
> index 3fdf9f3..983d81f 100644
> --- a/arch/powerpc/platforms/85xx/corenet_generic.c
> +++ b/arch/powerpc/platforms/85xx/corenet_generic.c
> @@ -32,6 +32,13 @@
>  #include <sysdev/fsl_pci.h>
>  #include "smp.h"
>  
> +#if defined(CONFIG_PPC64) && defined(CONFIG_SUSPEND)
> +static void fsl_suspend_disable_irqs(void)
> +{
> +	__hard_irq_disable();
> +}
> +#endif

Why the underscore version?  Don't you want PACA_IRQ_HARD_DIS to be set?

If hard disabling is appropriate here, shouldn't we do it in
generic_suspend_disable_irqs()?

Are there any existing platforms that supply a
ppc_md.suspend_disable_irqs()?  I don't see any when grepping.

-Scott


