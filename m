Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaKTD51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:57:27 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38128 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754023AbaKTD5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:57:25 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v7 1/4] irqchip: gic: Support hierarchy irq domain.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux- arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <87h9xvaz2p.fsf@approximate.cambridge.arm.com>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416406451-4578-2-git-send-email-yingjoe.chen@mediatek.com>
	 <87h9xvaz2p.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Nov 2014 11:57:20 +0800
Message-ID: <1416455840.12869.17.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marc,

On Wed, 2014-11-19 at 17:18 +0000, Marc Zyngier wrote:
> > +static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> > +				unsigned int nr_irqs, void *arg)
> > +{
> > +	int i, ret;
> > +	irq_hw_number_t hwirq;
> > +	unsigned int type = IRQ_TYPE_NONE;
> > +	struct of_phandle_args *irq_data = arg;
> > +
> > +	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
> > +				   irq_data->args_count, &hwirq, &type);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (i = 0; i < nr_irqs; i++)
> > +		gic_irq_domain_map(domain, virq+i, hwirq+i);
> 
> nit: spacing around '+'.

OK.

> > +
> > +	return 0;
> > +}
> > +
> > +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
> > +	.xlate = gic_irq_domain_xlate,
> > +	.alloc = gic_irq_domain_alloc,
> > +	.free = irq_domain_free_irqs_top,
> 
> I'm convinced that irq_domain_free_irqs_top is the wrong function to
> call here, because you're calling it from the bottom, not the top-level
> (it has no parent).

Base on the name, I though this is helper function for top level
irq_domain?

> I cannot verify this with your code as I don't a working platform with
> GICv2m, but if I enable something similar on GICv3, it dies a very
> painful way:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000018
> pgd = ffffffc03d059000
> [00000018] *pgd=0000000081356003, *pud=0000000081356003, *pmd=0000000000000000
> Internal error: Oops: 96000006 [#1] SMP
> Modules linked in:
> CPU: 4 PID: 1052 Comm: sh Not tainted 3.18.0-rc4+ #3311
> task: ffffffc03e320000 ti: ffffffc001390000 task.ti: ffffffc001390000
> PC is at irq_domain_free_irqs_recursive+0x1c/0x80
> LR is at irq_domain_free_irqs_common+0x88/0x9c
> pc : [<ffffffc0000ed790>] lr : [<ffffffc0000ede20>] pstate: 60000145
> [...]
> [<ffffffc0000ed790>] irq_domain_free_irqs_recursive+0x1c/0x80
> [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
> [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c  <-- gic_domain.free()
> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> [<ffffffc0000ee468>] irq_domain_free_irqs_parent+0x14/0x20
> [<ffffffc0003500b8>] its_irq_domain_free+0xc8/0x250
> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
> [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c
> [<ffffffc0000ef518>] msi_domain_free+0x70/0x88
> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> [<ffffffc0000ee3ac>] irq_domain_free_irqs+0x108/0x17c
> [<ffffffc0000efb68>] msi_domain_free_irqs+0x28/0x4c
> [<ffffffc000369cac>] free_msi_irqs+0xb4/0x1c0
> [<ffffffc00036adec>] pci_disable_msix+0x3c/0x4c
> [...]
> 
> and I cannot see how this could work on the standard GIC either.

I'm sorry, I just realize my testcase was too simple, irqs are populated
by device tree and never got freed. I'll add that and test it again.

> Thomas, Jiang: could you please confirm or infirm my suspicions? My
> understanding is that irq_domain_free_irqs_top can only be called from
> the top-level domain.
> 
> > +};
> > +
> >  static const struct irq_domain_ops gic_irq_domain_ops = {
> >  	.map = gic_irq_domain_map,
> >  	.unmap = gic_irq_domain_unmap,
> > @@ -948,18 +972,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
> >  		gic_cpu_map[i] = 0xff;
> >  
> >  	/*
> > -	 * For primary GICs, skip over SGIs.
> > -	 * For secondary GICs, skip over PPIs, too.
> > -	 */
> > -	if (gic_nr == 0 && (irq_start & 31) > 0) {
> > -		hwirq_base = 16;
> > -		if (irq_start != -1)
> > -			irq_start = (irq_start & ~31) + 16;
> > -	} else {
> > -		hwirq_base = 32;
> > -	}
> > -
> > -	/*
> >  	 * Find out how many interrupts are supported.
> >  	 * The GIC only supports up to 1020 interrupt sources.
> >  	 */
> > @@ -969,10 +981,32 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
> >  		gic_irqs = 1020;
> >  	gic->gic_irqs = gic_irqs;
> >  
> > -	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
> > +	if (node) {		/* DT case */
> > +		const struct irq_domain_ops *ops =
> > +					&gic_irq_domain_hierarchy_ops;
> 
> nit: please put this on the same line, even if it is longer than 80
> characters.

ok.

Joe.C


