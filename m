Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaJJRfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:35:05 -0400
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:63497
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751356AbaJJRfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:35:01 -0400
Message-ID: <1412962492.13320.587.camel@snotra.buserror.net>
Subject: Re: [PATCH 2/3] qe: run qe_init and qe_ic_init
From: Scott Wood <scottwood@freescale.com>
To: Zhao Qiang <B45475@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <B07421@freescale.com>, <R63061@freescale.com>
Date: Fri, 10 Oct 2014 12:34:52 -0500
In-Reply-To: <1412923725-9611-1-git-send-email-B45475@freescale.com>
References: <1412923725-9611-1-git-send-email-B45475@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9927:2233:7c17:ac17]
X-ClientProxiedBy: CY1PR12CA0022.namprd12.prod.outlook.com (25.160.137.32) To
 BN1PR0301MB0721.namprd03.prod.outlook.com (25.160.78.140)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(199003)(377424004)(76176999)(50226001)(80022003)(46102003)(120916001)(50466002)(40100002)(23676002)(122386002)(50986999)(95666004)(33646002)(105586002)(4396001)(62966002)(85852003)(101416001)(99396003)(97736003)(89996001)(102836001)(76482002)(21056001)(92566001)(106356001)(87976001)(110136001)(77156001)(20776003)(64706001)(575784001)(93916002)(86362001)(77096002)(42186005)(19580405001)(107046002)(104166001)(92726001)(19580395003)(31966008)(47776003)(87286001)(103116003)(85306004)(88136002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:[IPv6:2601:2:5800:3f7:9927:2233:7c17:ac17];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 14:48 +0800, Zhao Qiang wrote:
> qe and qe_ic need to be initialized before the
> qe app drivers, using subsys_initcall to run
> qe_init and qe_ic_init
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
>  drivers/soc/qe/qe.c    | 15 +++++++++++++++
>  drivers/soc/qe/qe_ic.c | 15 +++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/soc/qe/qe.c b/drivers/soc/qe/qe.c
> index 2aaa5b2..bfea0f8 100644
> --- a/drivers/soc/qe/qe.c
> +++ b/drivers/soc/qe/qe.c
> @@ -683,6 +683,21 @@ unsigned int qe_get_num_of_snums(void)
>  }
>  EXPORT_SYMBOL(qe_get_num_of_snums);
>  
> +static int __init qe_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,qe");
> +	if (!np) {
> +		pr_err("%s: Could not find Quicc Engine node\n", __func__);
> +		return -ENODEV;
> +	}
> +	qe_reset();
> +	of_node_put(np);
> +	return 0;
> +}
> +subsys_initcall(qe_init);

It is not an error to enable QE support on hardware that doesn't have
QE.  Please remove the pr_err().

> +
>  #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC_85xx)
>  static int qe_resume(struct platform_device *ofdev)
>  {
> diff --git a/drivers/soc/qe/qe_ic.c b/drivers/soc/qe/qe_ic.c
> index cc1b8d5..11fe98c 100644
> --- a/drivers/soc/qe/qe_ic.c
> +++ b/drivers/soc/qe/qe_ic.c
> @@ -34,6 +34,7 @@
>  #include <linux/fsl/qe_ic.h>
>  
>  #include "qe_ic.h"
> +#include "../../irqchip/irqchip.h"

What do you need from here, and can it be moved to include/linux/...?
 
The only thing I see defined in irqchip.h is IRQCHIP_DECLARE, and you
don't use that in this patch...

-Scott

>  static DEFINE_RAW_SPINLOCK(qe_ic_lock);
>  
> @@ -501,4 +502,18 @@ static int __init init_qe_ic_sysfs(void)
>  	return 0;
>  }
>  
> +static int __init qeic_of_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,qe-ic");
> +	if (np) {
> +		qe_ic_init(np, 0, qe_ic_cascade_low_mpic,
> +			   qe_ic_cascade_high_mpic);
> +		of_node_put(np);
> +	}
> +	return 0;
> +}
> +subsys_initcall(qeic_of_init);
> +
>  subsys_initcall(init_qe_ic_sysfs);


