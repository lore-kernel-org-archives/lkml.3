Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaG3GFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:05:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64509 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaG3GFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:05:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18OYE+FHtEDpwXbnEh7jBjl
Date: Tue, 29 Jul 2014 23:04:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140730060420.GY29045@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-30-git-send-email-balbi@ti.com>
 <20140729121425.GR29045@atomide.com>
 <20140729141522.GB17808@saruman.home>
 <20140729152052.GV29045@atomide.com>
 <20140729154057.GE17808@saruman.home>
 <20140729163345.GF17808@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729163345.GF17808@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140729 09:36]:
> Hi,
> 
> On Tue, Jul 29, 2014 at 10:40:57AM -0500, Felipe Balbi wrote:
> > On Tue, Jul 29, 2014 at 08:20:52AM -0700, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [140729 07:18]:
> > > > Hi,
> > > > 
> > > > On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> > > > > * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > > > > > now that we don't need to support legacy board-files,
> > > > > > we can completely switch over to a linear irq domain
> > > > > > and make use of irq_alloc_domain_generic_chips() to
> > > > > > allocate all generic irq chips for us.
> > > > > 
> > > > > This patch seems to somehow break off-idle for omap3 
> > > > > where it no longer wakes up.
> > > > 
> > > > Sure your bisection is correct ? This patch just switches from legacy
> > > > irq domain to linear irq domain.
> > > 
> > > Yes, I tried it a few times. Just enabling
> > > retention idle hangs too with this patch.
> > > 
> > > Maybe it's omap3_prcm_irq_setup that relies on
> > > 11 + OMAP_INTC_START? There may be other such issues
> > 
> > lol.
> > 
> > OMAP4 has the same nonsense.
> 
> made me think why (if) OMAP4 works with that same setup. Does wake from
> OFF work with OMAP4 ?

Not without similar changes, omap4+ has the same issue.. There's a RFC
series from Nishant to fix some of this, and Tero is moving the PRCM
into a driver.
 
> Anyway, here's a quick little hack to check if that's the reason for the
> regression:

OK yeah that's along the same lines with Nishant's RFC series in thread
"[RFC PATCH 0/7] ARM: OMAP4+: PRM: minor cleanups and dt support of
interrupts"

FYI, it did not compile, needs to include linux/of_irq.h. But yes,
it fixes the regression for me, Also now the whole series works for
me :)

Regards,

Tony

 
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index ff953c9..c234b98 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -97,6 +97,7 @@
>  		prm: prm@48306000 {
>  			compatible = "ti,omap3-prm";
>  			reg = <0x48306000 0x4000>;
> +			interrupts = <11>;
>  
>  			prm_clocks: clocks {
>  				#address-cells = <1>;
> diff --git a/arch/arm/mach-omap2/prm_common.c b/arch/arm/mach-omap2/prm_common.c
> index 25e8b82..3d11377 100644
> --- a/arch/arm/mach-omap2/prm_common.c
> +++ b/arch/arm/mach-omap2/prm_common.c
> @@ -242,6 +242,11 @@ void omap_prcm_irq_complete(void)
>  	prcm_irq_setup->restore_irqen(prcm_irq_setup->saved_mask);
>  }
>  
> +static struct of_device_id tmp[] = {
> +	{ .compatible = "ti,omap3-prm" },
> +	{ }
> +};
> +
>  /**
>   * omap_prcm_register_chain_handler - initializes the prcm chained interrupt
>   * handler based on provided parameters
> @@ -254,17 +259,24 @@ void omap_prcm_irq_complete(void)
>   */
>  int omap_prcm_register_chain_handler(struct omap_prcm_irq_setup *irq_setup)
>  {
> +	struct device_node *node;
>  	int nr_regs;
>  	u32 mask[OMAP_PRCM_MAX_NR_PENDING_REG];
>  	int offset, i;
> +	int irq;
>  	struct irq_chip_generic *gc;
>  	struct irq_chip_type *ct;
>  
>  	if (!irq_setup)
>  		return -EINVAL;
>  
> +	irq = irq_setup->irq;
>  	nr_regs = irq_setup->nr_regs;
>  
> +	node = of_find_matching_node(NULL, tmp);
> +	if (node)
> +		irq = of_irq_get(node, 0);
> +
>  	if (prcm_irq_setup) {
>  		pr_err("PRCM: already initialized; won't reinitialize\n");
>  		return -EINVAL;
> @@ -298,7 +310,7 @@ int omap_prcm_register_chain_handler(struct omap_prcm_irq_setup *irq_setup)
>  				1 << (offset & 0x1f);
>  	}
>  
> -	irq_set_chained_handler(irq_setup->irq, omap_prcm_irq_handler);
> +	irq_set_chained_handler(irq, omap_prcm_irq_handler);
>  
>  	irq_setup->base_irq = irq_alloc_descs(-1, 0, irq_setup->nr_regs * 32,
>  		0);
> 
> -- 
> balbi


