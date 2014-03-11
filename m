Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaCKXnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:43:21 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:43475
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755628AbaCKXnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:43:19 -0400
Message-ID: <1394581371.13761.62.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/9] powerpc/rcpm: add RCPM driver
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 18:42:51 -0500
In-Reply-To: <1394168285-32275-3-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-3-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR03CA009.namprd03.prod.outlook.com (10.141.52.157) To
 DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 0147E151B5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(51704005)(24454002)(199002)(189002)(74366001)(47776003)(85852003)(79102001)(19580395003)(31966008)(92566001)(88136002)(69226001)(20776003)(51856001)(95416001)(59766001)(77096001)(56816005)(81686001)(90146001)(63696002)(83072002)(87976001)(74876001)(77982001)(46102001)(83322001)(93516002)(85306002)(95666003)(97336001)(33646001)(81342001)(81542001)(93136001)(87266001)(97186001)(87286001)(77156001)(42186004)(74662001)(53806001)(89996001)(50466002)(80976001)(23676002)(47736001)(74502001)(47446002)(94316002)(50226001)(49866001)(62966002)(65816001)(50986001)(80022001)(76482001)(86362001)(93916002)(92726001)(94946001)(76796001)(76786001)(56776001)(54316002)(47976001)(81816001)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:F3EB72B5.2E1B971E.71DBB975.4656CB70.20383;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:57 +0800, Chenhui Zhao wrote:
> diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
> index b756f3d..3fdf9f3 100644
> --- a/arch/powerpc/platforms/85xx/corenet_generic.c
> +++ b/arch/powerpc/platforms/85xx/corenet_generic.c
> @@ -56,6 +56,8 @@ void __init corenet_gen_setup_arch(void)
>  
>  	swiotlb_detect_4g();
>  
> +	fsl_rcpm_init();
> +
>  	pr_info("%s board from Freescale Semiconductor\n", ppc_md.name);

RCPM is not board-specific.  Why is this in board code?

> +static void rcpm_v1_cpu_enter_state(int cpu, int state)
> +{
> +	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
> +	unsigned int mask = 1 << hw_cpu;
> +
> +	switch (state) {
> +	case E500_PM_PH10:
> +		setbits32(&rcpm_v1_regs->cdozcr, mask);
> +		break;
> +	case E500_PM_PH15:
> +		setbits32(&rcpm_v1_regs->cnapcr, mask);
> +		break;
> +	default:
> +		pr_err("Unknown cpu PM state\n");
> +		break;
> +	}
> +}

Put __func__ in error messages -- and for "unknown value" type messages,
print the value.


> +static int rcpm_v1_plat_enter_state(int state)
> +{
> +	u32 *pmcsr_reg = &rcpm_v1_regs->powmgtcsr;
> +	int ret = 0;
> +	int result;
> +
> +	switch (state) {
> +	case PLAT_PM_SLEEP:
> +		setbits32(pmcsr_reg, RCPM_POWMGTCSR_SLP);
> +
> +		/* At this point, the device is in sleep mode. */
> +
> +		/* Upon resume, wait for RCPM_POWMGTCSR_SLP bit to be clear. */
> +		result = spin_event_timeout(
> +		  !(in_be32(pmcsr_reg) & RCPM_POWMGTCSR_SLP), 10000, 10);
> +		if (!result) {
> +			pr_err("%s: timeout waiting for SLP bit to be cleared\n",
> +			  __func__);

Why are you indenting continuation lines with only two spaces (and yet
still not aligning with anything)?

> +			ret = -ETIMEDOUT;
> +		}
> +		break;
> +	default:
> +		pr_err("Unsupported platform PM state\n");
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static void rcpm_v1_freeze_time_base(int freeze)
> +{
> +	u32 *tben_reg = &rcpm_v1_regs->ctbenr;
> +	static u32 mask;
> +
> +	if (freeze) {
> +		mask = in_be32(tben_reg);
> +		clrbits32(tben_reg, mask);
> +	} else {
> +		setbits32(tben_reg, mask);
> +	}
> +
> +	/* read back to push the previous write */
> +	in_be32(tben_reg);
> +}
> +
> +static void rcpm_v2_freeze_time_base(int freeze)
> +{
> +	u32 *tben_reg = &rcpm_v2_regs->pctbenr;
> +	static u32 mask;
> +
> +	if (freeze) {
> +		mask = in_be32(tben_reg);
> +		clrbits32(tben_reg, mask);
> +	} else {
> +		setbits32(tben_reg, mask);
> +	}
> +
> +	/* read back to push the previous write */
> +	in_be32(tben_reg);
> +}

It looks like the only difference between these two functions is how you
calculate tben_reg -- factor the rest out into a single function.

> +int fsl_rcpm_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
> +	if (np) {
> +		rcpm_v2_regs = of_iomap(np, 0);
> +		of_node_put(np);
> +		if (!rcpm_v2_regs)
> +			return -ENOMEM;
> +
> +		qoriq_pm_ops = &qoriq_rcpm_v2_ops;
> +
> +	} else {
> +		np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-1.0");
> +		if (np) {
> +			rcpm_v1_regs = of_iomap(np, 0);
> +			of_node_put(np);
> +			if (!rcpm_v1_regs)
> +				return -ENOMEM;
> +
> +			qoriq_pm_ops = &qoriq_rcpm_v1_ops;
> +
> +		} else {
> +			pr_err("%s: can't find the rcpm node.\n", __func__);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}

Why isn't this a proper platform driver?

-Scott


