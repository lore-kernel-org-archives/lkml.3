Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaIPRoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:44:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:43436 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIPRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:44:45 -0400
Date: Tue, 16 Sep 2014 10:43:50 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 01/21] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
In-Reply-To: <1410444228-3134-2-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409160859080.4247@nanos>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Thu, 11 Sep 2014, Jiang Liu wrote:
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>  	/* Create mapping */
> -	virq = irq_create_mapping(domain, hwirq);
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	if (domain->ops->alloc)
> +		virq = irq_domain_alloc_irqs(domain, -1, 1, NUMA_NO_NODE,
> +					     irq_data);
> +	else
> +#endif
> +		virq = irq_create_mapping(domain, hwirq);

I'd prefer to get rid of the #ifdef CONFIG...s in the code. So this
can be written:

        if (irq_domain_has_hierarchy(domain))
		virq = irq_domain_alloc_irqs(domain, -1, 1, NUMA_NO_NODE,
					     irq_data);
	else
		virq = irq_create_mapping(domain, hwirq);
	   
	   

>  	if (!virq)
>  		return virq;
>  
> @@ -540,7 +542,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  		return 0;
>  
>  	if (hwirq < domain->revmap_direct_max_irq) {
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +		data = irq_domain_get_irq_data(domain, hwirq);
> +#else
>  		data = irq_get_irq_data(hwirq);
> +#endif

Similar here. Make irq_domain_get_irq_data() map to irq_get_irq_data() for
the non hierarchy mode so you end up with a single line:

-  		data = irq_get_irq_data(hwirq);
+		data = irq_domain_get_irq_data(domain, hwirq);


> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +/**
> + * irq_domain_alloc_irqs - Allocate IRQs from domain
> + * @domain: domain to allocate from
> + * @irq_base: allocate specified IRQ nubmer if irq_base >= 0
> + * @nr_irqs: number of IRQs to allocate
> + * @node: NUMA node id for memory allocation
> + * @arg: domain specific argument
> + * @realloc: IRQ descriptors have already been allocated if true
> + *
> + * Allocate IRQ numbers and initialized all data structures to support
> + * hiearchy IRQ domains.
> + * Parameter @realloc is mainly to support legacy IRQs.

What's the issue with the legacy irqs? So this has the interrupt
descriptors allocated already. Are they already wired up for serving
interrupts and what's the state of those lines?

> + * Returns error code or allocated IRQ number

Can you please add some documentation how the hierarchical allocation
is supposed to work and how the domains are connected. That should
probably go to Documentation/IRQ-domains.txt.

Other than that this looks pretty good! Nice work!

Thanks,

	tglx
