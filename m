Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaCLEAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:00:11 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30519
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaCLEAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:00:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 11:59:54 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: Re: [PATCH 3/9] powerpc/rcpm: add RCPM driver
Message-ID: <20140312035954.GB4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-3-git-send-email-chenhui.zhao@freescale.com>
 <1394581371.13761.62.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394581371.13761.62.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 06:42:51PM -0500, Scott Wood wrote:
> On Fri, 2014-03-07 at 12:57 +0800, Chenhui Zhao wrote:
> > diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
> > index b756f3d..3fdf9f3 100644
> > --- a/arch/powerpc/platforms/85xx/corenet_generic.c
> > +++ b/arch/powerpc/platforms/85xx/corenet_generic.c
> > @@ -56,6 +56,8 @@ void __init corenet_gen_setup_arch(void)
> >  
> >  	swiotlb_detect_4g();
> >  
> > +	fsl_rcpm_init();
> > +
> >  	pr_info("%s board from Freescale Semiconductor\n", ppc_md.name);
> 
> RCPM is not board-specific.  Why is this in board code?

Init the RCPM driver in the early stage before smp_init(). Because
the time base sync calls a callback function .freeze_time_base()
in the RCPM driver.

Will use early_initcall() instead.

> 
> > +static void rcpm_v1_cpu_enter_state(int cpu, int state)
> > +{
> > +	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
> > +	unsigned int mask = 1 << hw_cpu;
> > +
> > +	switch (state) {
> > +	case E500_PM_PH10:
> > +		setbits32(&rcpm_v1_regs->cdozcr, mask);
> > +		break;
> > +	case E500_PM_PH15:
> > +		setbits32(&rcpm_v1_regs->cnapcr, mask);
> > +		break;
> > +	default:
> > +		pr_err("Unknown cpu PM state\n");
> > +		break;
> > +	}
> > +}
> 
> Put __func__ in error messages -- and for "unknown value" type messages,
> print the value.

OK.

> 
> 
> > +static int rcpm_v1_plat_enter_state(int state)
> > +{
> > +	u32 *pmcsr_reg = &rcpm_v1_regs->powmgtcsr;
> > +	int ret = 0;
> > +	int result;
> > +
> > +	switch (state) {
> > +	case PLAT_PM_SLEEP:
> > +		setbits32(pmcsr_reg, RCPM_POWMGTCSR_SLP);
> > +
> > +		/* At this point, the device is in sleep mode. */
> > +
> > +		/* Upon resume, wait for RCPM_POWMGTCSR_SLP bit to be clear. */
> > +		result = spin_event_timeout(
> > +		  !(in_be32(pmcsr_reg) & RCPM_POWMGTCSR_SLP), 10000, 10);
> > +		if (!result) {
> > +			pr_err("%s: timeout waiting for SLP bit to be cleared\n",
> > +			  __func__);
> 
> Why are you indenting continuation lines with only two spaces (and yet
> still not aligning with anything)?

Will align with the previous parenthesis.

> 
> > +			ret = -ETIMEDOUT;
> > +		}
> > +		break;
> > +	default:
> > +		pr_err("Unsupported platform PM state\n");
> > +		ret = -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void rcpm_v1_freeze_time_base(int freeze)
> > +{
> > +	u32 *tben_reg = &rcpm_v1_regs->ctbenr;
> > +	static u32 mask;
> > +
> > +	if (freeze) {
> > +		mask = in_be32(tben_reg);
> > +		clrbits32(tben_reg, mask);
> > +	} else {
> > +		setbits32(tben_reg, mask);
> > +	}
> > +
> > +	/* read back to push the previous write */
> > +	in_be32(tben_reg);
> > +}
> > +
> > +static void rcpm_v2_freeze_time_base(int freeze)
> > +{
> > +	u32 *tben_reg = &rcpm_v2_regs->pctbenr;
> > +	static u32 mask;
> > +
> > +	if (freeze) {
> > +		mask = in_be32(tben_reg);
> > +		clrbits32(tben_reg, mask);
> > +	} else {
> > +		setbits32(tben_reg, mask);
> > +	}
> > +
> > +	/* read back to push the previous write */
> > +	in_be32(tben_reg);
> > +}
> 
> It looks like the only difference between these two functions is how you
> calculate tben_reg -- factor the rest out into a single function.

Yes. Will factor them out into a single function.

> 
> > +int fsl_rcpm_init(void)
> > +{
> > +	struct device_node *np;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
> > +	if (np) {
> > +		rcpm_v2_regs = of_iomap(np, 0);
> > +		of_node_put(np);
> > +		if (!rcpm_v2_regs)
> > +			return -ENOMEM;
> > +
> > +		qoriq_pm_ops = &qoriq_rcpm_v2_ops;
> > +
> > +	} else {
> > +		np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-1.0");
> > +		if (np) {
> > +			rcpm_v1_regs = of_iomap(np, 0);
> > +			of_node_put(np);
> > +			if (!rcpm_v1_regs)
> > +				return -ENOMEM;
> > +
> > +			qoriq_pm_ops = &qoriq_rcpm_v1_ops;
> > +
> > +		} else {
> > +			pr_err("%s: can't find the rcpm node.\n", __func__);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Why isn't this a proper platform driver?
> 
> -Scott

The RCPM is not a single function IP block, instead it is a collection
of device run control and power management. It would be called by other
drivers and functions. For example, the callback .freeze_time_base()
need to be called at early stage of kernel init. Therefore, it would be
better to init it at early stage.

-Chenhui

