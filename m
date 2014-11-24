Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaKXNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:13:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:38466 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaKXNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:13:35 -0500
Date: Mon, 24 Nov 2014 14:13:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
In-Reply-To: <547325A9.3000109@huawei.com>
Message-ID: <alpine.DEB.2.11.1411241405560.6439@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <547325A9.3000109@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Yun Wu (Abel) wrote:
> Hi Thomas, Jiang,
> On 2014/11/12 21:42, Thomas Gleixner wrote:
> 
> > From: Jiang Liu <jiang.liu@linux.intel.com>
> > 
> [...]
> >  /* Number of irqs reserved for a legacy isa controller */
> >  #define NUM_ISA_INTERRUPTS	16
> > @@ -64,6 +66,16 @@ struct irq_domain_ops {
> >  	int (*xlate)(struct irq_domain *d, struct device_node *node,
> >  		     const u32 *intspec, unsigned int intsize,
> >  		     unsigned long *out_hwirq, unsigned int *out_type);
> > +
> > +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> > +	/* extended V2 interfaces to support hierarchy irq_domains */
> > +	int (*alloc)(struct irq_domain *d, unsigned int virq,
> > +		     unsigned int nr_irqs, void *arg);
> > +	void (*free)(struct irq_domain *d, unsigned int virq,
> > +		     unsigned int nr_irqs);
> > +	void (*activate)(struct irq_domain *d, struct irq_data *irq_data);
> > +	void (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
> 
> What's the usage of the parameter domain reference in activate/deactivate?
> I think the purpose of the two callbacks is to activate/deactivate the
> irq_data->hwirq in irq_data->domain. If so, the first parameter @domain is
> required to be equal to irq_data->domain (which makes @domain useless).
> Besides, the main responsibility of interrupt domains is to manage mappings
> between hardware and linux interrupt numbers, so would it be better if move
> the two callbacks into struct irq_chip?

No. It's not a function of the irq_chip to activate/deactivate a
hierarchy. As I explained you before:

The existing irqdomain code maps between hardware and virtual
interrupts and thereby activates the interrupt in hardware.

In the hierarchical case we do not touch the hardware in the
allocation step, so we need to activate the allocated interrupt in the
hardware before we can use it. And that's clearly a domain interface
not a irq chip issue.

Thanks,

	tglx

