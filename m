Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaKWKgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 05:36:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:33988 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKWKgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 05:36:50 -0500
Date: Sun, 23 Nov 2014 11:36:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch irqdomain: Enhance irq_domain_free_irqs_common() to
 support parentless irqdomain
In-Reply-To: <alpine.DEB.2.11.1411231132160.6439@nanos>
Message-ID: <alpine.DEB.2.11.1411231135190.6439@nanos>
References: <1416540206-18103-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411231132160.6439@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014, Thomas Gleixner wrote:

> On Fri, 21 Nov 2014, Jiang Liu wrote:
> 
> > Originally irq_domain_free_irqs_common() is designed to be used by
> > irqdomains with parent. But there are desires to reuse for parentless
> > irqdomains for code reduction.
> > So check domain->parent before invoking irq_domain_free_irqs_parent().
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > ---
> > Hi Thomas,
> > 	This patch applies to tip/irq/irqdomain, it helps to reduce code
> > size on ARM. Seems we still have chance to merge it into tip/irq/irqdomain:)
> > Regards!
> > Gerry
> > ---
> >  kernel/irq/irqdomain.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 029acf11efed..0449d2869e17 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -975,7 +975,8 @@ void irq_domain_free_irqs_common(struct irq_domain *domain, unsigned int virq,
> >  		if (irq_data)
> >  			irq_domain_reset_irq_data(irq_data);
> >  	}
> > -	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> > +	if (domain->parent)
> > +		irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> 
> irq_domain_free_irqs_parent()
> {
> 	if (domain->parent && domain->parent->ops->free)
> 	   	...
> }
> 
> So the above is redundant and does not change anything.

Except that this function gets replaced later in the series and drops
the parent check.

Though we should not put the conditionals on the call sites. We want
the functions handle it.

/me goes fixing.

Thanks,

	tglx
