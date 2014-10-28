Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaJ1TiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:38:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:51905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaJ1TiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:38:03 -0400
Date: Tue, 28 Oct 2014 20:37:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [Patch Part2 v3 01/24] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
In-Reply-To: <1414489711.32399.53.camel@mtksdaap41>
Message-ID: <alpine.DEB.2.11.1410282010340.5308@nanos>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>  <1414484803-10311-2-git-send-email-jiang.liu@linux.intel.com> <1414489711.32399.53.camel@mtksdaap41>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Yingjoe Chen wrote:
> On Tue, 2014-10-28 at 16:26 +0800, Jiang Liu wrote:
> <deleted...>
> > @@ -471,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
> >  	struct irq_domain *domain;
> >  	irq_hw_number_t hwirq;
> >  	unsigned int type = IRQ_TYPE_NONE;
> > -	unsigned int virq;
> > +	int virq;
> >  
> >  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
> >  	if (!domain) {
> > @@ -480,6 +478,11 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
> >  		return 0;
> >  	}
> >  
> > +	if (irq_domain_is_hierarchy(domain)) {
> > +		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
> > +		return virq <= 0 ? 0 : virq;
> > +	}
> > +
> >  	/* If domain has no translation, then we assume interrupt line */
> >  	if (domain->ops->xlate == NULL)
> >  		hwirq = irq_data->args[0];
> > @@ -540,8 +543,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
> >  		return 0;
> >  
> >  	if (hwirq < domain->revmap_direct_max_irq) {
> > -		data = irq_get_irq_data(hwirq);
> > -		if (data && (data->domain == domain) && (data->hwirq == hwirq))
> > +		data = irq_domain_get_irq_data(domain, hwirq);
> > +		if (data && data->hwirq == hwirq)
> >  			return hwirq;
> >  	}
> 
> Why do you want to move irq_domain_alloc_irqs up there?

That's the wrong question. The proper question is whether we can move
it after the xlate part. I don't see a reason why we cannot do that.

Jiang was right not to incorporate your patch to do that simply
because we want to keep the history of the evolution of this
code. Your patch is an enhancement and it needs to be discussed and
applied seperately.

So while we are at it:

> +	if (irq_domain_is_hierarchy(domain)) {
> +		if (domain->ops->xlate) {
> +			/*
> +			 * If we've already configured this interrupt,
> +			 * don't do it again, or hell will break loose.
> +			 */
> +			virq = irq_find_mapping(domain, hwirq);
> +			if (virq)
> +				return virq;

I can understand that it is an issue if the mapping exists already,
but I have to ask WHY is it correct behaviour to call into that code
for an existing mapping.

And why would this check only apply if domain->ops->xlate is set?
irq_create_mapping() does it unconditionally.

> Joe.C
> >  
> > @@ -709,3 +712,341 @@ const struct irq_domain_ops irq_domain_simple_ops = {

Please remove the rest of the mail to which you are not answering next time.

Thanks,

	tglx
