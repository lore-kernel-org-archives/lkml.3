Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbaKUPgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:36:20 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34417 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758656AbaKUPgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:36:17 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v7 2/4] ARM: mediatek: Add sysirq interrupt polarity
 support
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20141119180448.GD12851@leverpostej>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416406451-4578-3-git-send-email-yingjoe.chen@mediatek.com>
	 <20141119180448.GD12851@leverpostej>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Nov 2014 23:36:07 +0800
Message-ID: <1416584167.24971.9.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


On Wed, 2014-11-19 at 18:04 +0000, Mark Rutland wrote:
> On Wed, Nov 19, 2014 at 02:14:09PM +0000, Yingjoe Chen wrote:
> > +	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING) {
> > +		if (type == IRQ_TYPE_LEVEL_LOW)
> > +			type = IRQ_TYPE_LEVEL_HIGH;
> > +		else
> > +			type = IRQ_TYPE_EDGE_RISING;
> > +		value |= (1 << offset);
> > +	} else
> > +		value &= ~(1 << offset);
> 
> Nit: if one branch of an if statements is bracketed, both branches
> should be. Please bracket the else case.

OK, will change in next version.

> > +	writel(value, chip_data->intpol_base + reg_index * 4);
> > +
> > +	data = data->parent_data;
> > +	ret = data->chip->irq_set_type(data, type);
> > +	spin_unlock_irqrestore(&chip_data->lock, flags);
> > +	return ret;
> > +}
> > +
> > +static struct irq_chip mtk_sysirq_chip = {
> > +	.name			= "MT_SYSIRQ",
> > +	.irq_mask		= irq_chip_mask_parent,
> > +	.irq_unmask		= irq_chip_unmask_parent,
> > +	.irq_eoi		= irq_chip_eoi_parent,
> > +	.irq_set_type		= mtk_sysirq_set_type,
> > +	.irq_retrigger		= irq_chip_retrigger_hierarchy,
> > +	.irq_set_affinity	= irq_chip_set_affinity_parent,
> > +};
> > +
> > +static int mtk_sysirq_domain_xlate(struct irq_domain *d,
> > +				   struct device_node *controller,
> > +				   const u32 *intspec, unsigned int intsize,
> > +				   unsigned long *out_hwirq,
> > +				   unsigned int *out_type)
> > +{
> > +	if (intsize < 3)
> > +		return -EINVAL;
> > +
> > +	/* sysirq doesn't support PPI */
> > +	if (intspec[0])
> > +		return -EINVAL;
> > +
> > +	*out_hwirq = intspec[1];
> > +	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
> 
> All of this is very strongly tied to the GIC, but the binding made it
> sound like this was more generic (it didn't specify the number of cells
> or their meaning). It doesn't look like we validate that this is
> attached to a GIC.
> 
> Do we expect this to only ever be attached to a GICv2?
> 
> It would be nice to either make this generic or to describe the format
> in the binding.

This expect the parent to use the same interrupt cells format as GIC.
I'll fix the binding to make this more clear.

> Also, surely you expect intsize == 3 if you expect a GICv2? Likewise in
> mtk_sysirq_domain_alloc.

OK, will change that in next version.

Joe.C


