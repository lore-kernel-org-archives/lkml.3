Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaKSRSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:18:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33815 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaKSRSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:18:51 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen\@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream\@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen\@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung\@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen\@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang\@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux- arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 1/4] irqchip: gic: Support hierarchy irq domain.
In-Reply-To: <1416406451-4578-2-git-send-email-yingjoe.chen@mediatek.com>
	(Yingjoe Chen's message of "Wed, 19 Nov 2014 14:14:08 +0000")
Organization: ARM Ltd
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	<1416406451-4578-2-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Wed, 19 Nov 2014 17:18:38 +0000
Message-ID: <87h9xvaz2p.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yingjoe,

On Wed, Nov 19 2014 at  2:14:08 pm GMT, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> Add support to use gic as a parent for stacked irq domain.
>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  drivers/irqchip/Kconfig   |  1 +
>  drivers/irqchip/irq-gic.c | 78 ++++++++++++++++++++++++++++++++---------------
>  2 files changed, 55 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..7f34138 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -5,6 +5,7 @@ config IRQCHIP
>  config ARM_GIC
>  	bool
>  	select IRQ_DOMAIN
> +	select IRQ_DOMAIN_HIERARCHY
>  	select MULTI_IRQ_HANDLER
>  
>  config GIC_NON_BANKED
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 38493ff..464dd53 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -788,17 +788,16 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  {
>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_percpu_devid_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_percpu_devid_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	} else {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_fasteoi_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_fasteoi_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  
>  		gic_routable_irq_domain_ops->map(d, irq, hw);
>  	}
> -	irq_set_chip_data(irq, d->host_data);
>  	return 0;
>  }
>  
> @@ -858,6 +857,31 @@ static struct notifier_block gic_cpu_notifier = {
>  };
>  #endif
>  
> +static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs, void *arg)
> +{
> +	int i, ret;
> +	irq_hw_number_t hwirq;
> +	unsigned int type = IRQ_TYPE_NONE;
> +	struct of_phandle_args *irq_data = arg;
> +
> +	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
> +				   irq_data->args_count, &hwirq, &type);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		gic_irq_domain_map(domain, virq+i, hwirq+i);

nit: spacing around '+'.

> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
> +	.xlate = gic_irq_domain_xlate,
> +	.alloc = gic_irq_domain_alloc,
> +	.free = irq_domain_free_irqs_top,

I'm convinced that irq_domain_free_irqs_top is the wrong function to
call here, because you're calling it from the bottom, not the top-level
(it has no parent).

I cannot verify this with your code as I don't a working platform with
GICv2m, but if I enable something similar on GICv3, it dies a very
painful way:

Unable to handle kernel NULL pointer dereference at virtual address 00000018
pgd = ffffffc03d059000
[00000018] *pgd=0000000081356003, *pud=0000000081356003, *pmd=0000000000000000
Internal error: Oops: 96000006 [#1] SMP
Modules linked in:
CPU: 4 PID: 1052 Comm: sh Not tainted 3.18.0-rc4+ #3311
task: ffffffc03e320000 ti: ffffffc001390000 task.ti: ffffffc001390000
PC is at irq_domain_free_irqs_recursive+0x1c/0x80
LR is at irq_domain_free_irqs_common+0x88/0x9c
pc : [<ffffffc0000ed790>] lr : [<ffffffc0000ede20>] pstate: 60000145
[...]
[<ffffffc0000ed790>] irq_domain_free_irqs_recursive+0x1c/0x80
[<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
[<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c  <-- gic_domain.free()
[<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
[<ffffffc0000ee468>] irq_domain_free_irqs_parent+0x14/0x20
[<ffffffc0003500b8>] its_irq_domain_free+0xc8/0x250
[<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
[<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
[<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c
[<ffffffc0000ef518>] msi_domain_free+0x70/0x88
[<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
[<ffffffc0000ee3ac>] irq_domain_free_irqs+0x108/0x17c
[<ffffffc0000efb68>] msi_domain_free_irqs+0x28/0x4c
[<ffffffc000369cac>] free_msi_irqs+0xb4/0x1c0
[<ffffffc00036adec>] pci_disable_msix+0x3c/0x4c
[...]

and I cannot see how this could work on the standard GIC either.

Thomas, Jiang: could you please confirm or infirm my suspicions? My
understanding is that irq_domain_free_irqs_top can only be called from
the top-level domain.

> +};
> +
>  static const struct irq_domain_ops gic_irq_domain_ops = {
>  	.map = gic_irq_domain_map,
>  	.unmap = gic_irq_domain_unmap,
> @@ -948,18 +972,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  		gic_cpu_map[i] = 0xff;
>  
>  	/*
> -	 * For primary GICs, skip over SGIs.
> -	 * For secondary GICs, skip over PPIs, too.
> -	 */
> -	if (gic_nr == 0 && (irq_start & 31) > 0) {
> -		hwirq_base = 16;
> -		if (irq_start != -1)
> -			irq_start = (irq_start & ~31) + 16;
> -	} else {
> -		hwirq_base = 32;
> -	}
> -
> -	/*
>  	 * Find out how many interrupts are supported.
>  	 * The GIC only supports up to 1020 interrupt sources.
>  	 */
> @@ -969,10 +981,32 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  		gic_irqs = 1020;
>  	gic->gic_irqs = gic_irqs;
>  
> -	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
> +	if (node) {		/* DT case */
> +		const struct irq_domain_ops *ops =
> +					&gic_irq_domain_hierarchy_ops;

nit: please put this on the same line, even if it is longer than 80
characters.

> +
> +		if (!of_property_read_u32(node, "arm,routable-irqs",
> +					  &nr_routable_irqs)) {
> +			ops = &gic_irq_domain_ops;
> +			gic_irqs = nr_routable_irqs;
> +		}
> +
> +		gic->domain = irq_domain_add_linear(node, gic_irqs, ops, gic);
> +	} else {		/* Non-DT case */
> +		/*
> +		 * For primary GICs, skip over SGIs.
> +		 * For secondary GICs, skip over PPIs, too.
> +		 */
> +		if (gic_nr == 0 && (irq_start & 31) > 0) {
> +			hwirq_base = 16;
> +			if (irq_start != -1)
> +				irq_start = (irq_start & ~31) + 16;
> +		} else {
> +			hwirq_base = 32;
> +		}
> +
> +		gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
>  
> -	if (of_property_read_u32(node, "arm,routable-irqs",
> -				 &nr_routable_irqs)) {
>  		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
>  					   numa_node_id());
>  		if (IS_ERR_VALUE(irq_base)) {
> @@ -983,10 +1017,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  
>  		gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
>  					hwirq_base, &gic_irq_domain_ops, gic);
> -	} else {
> -		gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
> -						    &gic_irq_domain_ops,
> -						    gic);
>  	}
>  
>  	if (WARN_ON(!gic->domain))

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
