Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3EaWae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:30:34 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57499 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3EaWa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:30:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: Do not reuse existing mappings
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20130531125910.GA1454@dhcp-26-207.brq.redhat.com>
References: <20130531125910.GA1454@dhcp-26-207.brq.redhat.com>
Date: Fri, 31 May 2013 23:30:24 +0100
Message-Id: <20130531223024.AB12F3E08FE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 14:59:11 +0200, Alexander Gordeev <agordeev@redhat.com> wrote:
> If a freshly acquired hardware interrupt number already mapped to
> a Linux IRQ number it indicates a problem exists elsewhere, i.e.
> a device driver did not dispose the mapping. Nevertheless, the
> current code reuses such mappings and thus calls for more trouble.
> 
> This fix forces irq_create_mapping() to complain loudly and bail
> out if an unexpected mapping detected.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

That assumes that irq_create_mapping() will only ever get called once
for a given IRQ, but that isn't true. It is quite possible for
irq_create_of_mapping(), which calls irq_create_mapping() to get called
several times; say once during early boot and then later when actaully
attaching a device driver. It will also happen in the case where
of_platform_device_create() will populate the irqs in the resource
table, but some drivers still call irq_of_parse_and_map() in the probe
hook.

Blocking multiple calls to irq_create_mapping() cannot be allowed. It is
true that irqdomain is buggy in that the unmap path doesn't do any
reference counting of any kind, and that needs to be fixed.

What exactly is the problem that you're trying to solve with this patch?
It's not clear from the description.

g.

> ---
>  Documentation/IRQ-domain.txt            |    7 +++----
>  arch/powerpc/platforms/44x/currituck.c  |    1 +
>  arch/powerpc/platforms/maple/pci.c      |    2 ++
>  arch/powerpc/platforms/pasemi/dma_lib.c |    1 +
>  arch/powerpc/platforms/pasemi/setup.c   |    1 +
>  arch/powerpc/platforms/powermac/pci.c   |    1 +
>  arch/powerpc/platforms/powermac/pic.c   |    5 ++++-
>  arch/powerpc/platforms/powermac/smp.c   |    6 +++++-
>  kernel/irq/irqdomain.c                  |    4 ++--
>  9 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> index 9bc9594..0ecef75 100644
> --- a/Documentation/IRQ-domain.txt
> +++ b/Documentation/IRQ-domain.txt
> @@ -47,10 +47,9 @@ the .map callback populated as a minimum.
>  In most cases, the irq_domain will begin empty without any mappings
>  between hwirq and IRQ numbers.  Mappings are added to the irq_domain
>  by calling irq_create_mapping() which accepts the irq_domain and a
> -hwirq number as arguments.  If a mapping for the hwirq doesn't already
> -exist then it will allocate a new Linux irq_desc, associate it with
> -the hwirq, and call the .map() callback so the driver can perform any
> -required hardware setup.
> +hwirq number as arguments. It will allocate a new Linux irq_desc,
> +associate it with the hwirq, and call the .map() callback so the
> +driver can perform any required hardware setup.
>  
>  When an interrupt is received, irq_find_mapping() function should
>  be used to find the Linux IRQ number from the hwirq number.
> diff --git a/arch/powerpc/platforms/44x/currituck.c b/arch/powerpc/platforms/44x/currituck.c
> index ecd3890..5a8682d 100644
> --- a/arch/powerpc/platforms/44x/currituck.c
> +++ b/arch/powerpc/platforms/44x/currituck.c
> @@ -182,6 +182,7 @@ static void ppc47x_pci_irq_fixup(struct pci_dev *dev)
>  	if (dev->vendor == 0x1033 && (dev->device == 0x0035 ||
>  	                              dev->device == 0x00e0)) {
>  		dev->irq = irq_create_mapping(NULL, 47);
> +		BUG_ON(dev->irq == NO_IRQ);
>  		pr_info("%s: Mapping irq 47 %d\n", __func__, dev->irq);
>  	}
>  }
> diff --git a/arch/powerpc/platforms/maple/pci.c b/arch/powerpc/platforms/maple/pci.c
> index f7136aa..482b69d 100644
> --- a/arch/powerpc/platforms/maple/pci.c
> +++ b/arch/powerpc/platforms/maple/pci.c
> @@ -554,6 +554,8 @@ void maple_pci_irq_fixup(struct pci_dev *dev)
>  		dev->irq = irq_create_mapping(NULL, 1);
>  		if (dev->irq != NO_IRQ)
>  			irq_set_irq_type(dev->irq, IRQ_TYPE_LEVEL_LOW);
> +		else
> +			WARN_ON(1);
>  	}
>  
>  	/* Hide AMD8111 IDE interrupt when in legacy mode so
> diff --git a/arch/powerpc/platforms/pasemi/dma_lib.c b/arch/powerpc/platforms/pasemi/dma_lib.c
> index f3defd8..f05e66a0 100644
> --- a/arch/powerpc/platforms/pasemi/dma_lib.c
> +++ b/arch/powerpc/platforms/pasemi/dma_lib.c
> @@ -212,6 +212,7 @@ void *pasemi_dma_alloc_chan(enum pasemi_dmachan_type type,
>  		break;
>  	}
>  
> +	BUG_ON(chan->irq == NO_IRQ);
>  	chan->chan_type = type;
>  
>  	return chan;
> diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
> index 8c54de6d..54fa2d9 100644
> --- a/arch/powerpc/platforms/pasemi/setup.c
> +++ b/arch/powerpc/platforms/pasemi/setup.c
> @@ -239,6 +239,7 @@ static __init void pas_init_IRQ(void)
>  	/* The NMI/MCK source needs to be prio 15 */
>  	if (nmiprop) {
>  		nmi_virq = irq_create_mapping(NULL, *nmiprop);
> +		BUG_ON(nmi_virq == NO_IRQ);
>  		mpic_irq_set_priority(nmi_virq, 15);
>  		irq_set_irq_type(nmi_virq, IRQ_TYPE_EDGE_RISING);
>  		mpic_unmask_irq(irq_get_irq_data(nmi_virq));
> diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
> index cf7009b..07c3f2b 100644
> --- a/arch/powerpc/platforms/powermac/pci.c
> +++ b/arch/powerpc/platforms/powermac/pci.c
> @@ -1002,6 +1002,7 @@ void pmac_pci_irq_fixup(struct pci_dev *dev)
>  	    dev->vendor == PCI_VENDOR_ID_DEC &&
>  	    dev->device == PCI_DEVICE_ID_DEC_TULIP_PLUS) {
>  		dev->irq = irq_create_mapping(NULL, 60);
> +		BUG_ON(dev->irq == NO_IRQ);
>  		irq_set_irq_type(dev->irq, IRQ_TYPE_LEVEL_LOW);
>  	}
>  #endif /* CONFIG_PPC32 */
> diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
> index 31036b5..f49706a 100644
> --- a/arch/powerpc/platforms/powermac/pic.c
> +++ b/arch/powerpc/platforms/powermac/pic.c
> @@ -301,6 +301,7 @@ static void __init pmac_pic_probe_oldstyle(void)
>  	struct device_node *slave = NULL;
>  	u8 __iomem *addr;
>  	struct resource r;
> +	unsigned int virq;
>  
>  	/* Set our get_irq function */
>  	ppc_md.get_irq = pmac_pic_get_irq;
> @@ -389,7 +390,9 @@ static void __init pmac_pic_probe_oldstyle(void)
>  
>  	printk(KERN_INFO "irq: System has %d possible interrupts\n", max_irqs);
>  #ifdef CONFIG_XMON
> -	setup_irq(irq_create_mapping(NULL, 20), &xmon_action);
> +	virq = irq_create_mapping(NULL, 20);
> +	BUG_ON(virq == NO_IRQ);
> +	setup_irq(virq, &xmon_action);
>  #endif
>  }
>  
> diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
> index bdb738a..1c466f4 100644
> --- a/arch/powerpc/platforms/powermac/smp.c
> +++ b/arch/powerpc/platforms/powermac/smp.c
> @@ -413,13 +413,17 @@ static struct irqaction psurge_irqaction = {
>  
>  static void __init smp_psurge_setup_cpu(int cpu_nr)
>  {
> +	unsigned int virq;
> +
>  	if (cpu_nr != 0 || !psurge_start)
>  		return;
>  
>  	/* reset the entry point so if we get another intr we won't
>  	 * try to startup again */
>  	out_be32(psurge_start, 0x100);
> -	if (setup_irq(irq_create_mapping(NULL, 30), &psurge_irqaction))
> +	virq = irq_create_mapping(NULL, 30);
> +	BUG_ON(virq == NO_IRQ);
> +	if (setup_irq(virq, &psurge_irqaction))
>  		printk(KERN_ERR "Couldn't get primary IPI interrupt");
>  }
>  
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 5a83dde..ca662a2 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -580,8 +580,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	/* Check if mapping already exists */
>  	virq = irq_find_mapping(domain, hwirq);
>  	if (virq) {
> -		pr_debug("-> existing mapping on virq %d\n", virq);
> -		return virq;
> +		pr_warning("-> existing mapping on virq %d\n", virq);
> +		return 0;
>  	}
>  
>  	/* Get a virtual interrupt number */
> -- 
> 1.7.7.6
> 
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
