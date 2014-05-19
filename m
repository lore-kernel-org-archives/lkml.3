Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaESOEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:04:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:48183 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaESOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:04:48 -0400
Date: Mon, 19 May 2014 23:04:22 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC Patch Part1 V1 00/30] use irqdomain to dynamically allocate
 IRQ for IOAPIC pin
In-Reply-To: <53787F09.9000200@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1405192250170.22305@ionos.tec.linutronix.de>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405161601060.4039@ionos.tec.linutronix.de> <53787F09.9000200@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Sun, 18 May 2014, Jiang Liu wrote:
> On 2014/5/16 23:28, Thomas Gleixner wrote:
> >> Patch 1-17 are trivial code improvements, bugfixes and preparation.
> > 
> > Can you please move the bugfixes before the other changes, so we can
> > pick them up independently from the outcome?
> Sure, will reorder the patch set in next version.

Thanks.
 
> >  
> >> Patch 18-24 enable basic irqdomain support and IRQ number dynamic
> >> allocation.
> >>
> >> Patch 25-29 consoldate the way to program IOAPIC pins by using
> >> irqdomain map() interface.
> >>
> >> Patch 30 cleans up unused interfaces and functions in IOAPIC driver.
> >>
> >> Tests and comments are warmly welcomed!
> > 
> > I like the general approach, but we have now a mixture of legacy irq
> > handling and irq domains. We really want to cleanup the legacy PIC no
> > ioapic case as well. That will cleanup the code further.
> > 
> > The other thing we discussed here: https://lkml.org/lkml/2014/5/7/901
> > in several places of the thread is to move the vector allocation into
> > a irqdomain with a generic matrix allocator as well. We have other use
> > cases for this as well. It would be nice if you could look at that as
> > well.
> I have read through the thread, it's an interesting discussion.
> 
> After my first thought, I have gotten some ideas about how to reorganize
> x86 interrupt subsystem using irqdomain framework based on ideas from
> the thread. Because I'm newbie to interrupt subsystem, I will share my
> naive ideas first and RFC for whether it's the right direction.
> 
> We may build hierarchy irqdomains as below for x86,
> [IOAPIC]      [MSI/MSI-x]  [HPET]  [DMAR] [Legacy]
>     |            |           |       |       |
>     v            v           v       |       |
> [           Remapping           ]    |       |
>                  |                   |       |
>                  v                   v       v
> [                   Root/vector                ]
> 
> The remapping domain is optional and used to support IRQ remapping unit.
> We abstract remapping entry as hardware interrupt pin and will extend
> irqdomain interface to support automatic assignment of hardware
> interrupt pin.
> 
> The root/vector domain is used to manage per CPU vector numbers and
> CPU vector is abstracted as hardware interrupt pin. It will support
> automatic vector number assignment. To support root/vector domain,
> we need to extend irqdomain interface to pass down information
> or constraints about the IRQ allocation.
> 
> So how about following extension to current irqdomain interfaces?

I cc'ed Grant Likely. He might have some opinion on this as well.

> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index c983ed18c332..2fd7e50cde32 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -42,6 +42,13 @@ struct of_device_id;
>  /* Number of irqs reserved for a legacy isa controller */
>  #define NUM_ISA_INTERRUPTS     16
> 
> +#define        IRQDOMAIN_AUTO_ASSIGN_HWIRQ     ULONG_MAX
> +#ifdef arch_irq_alloc_info_t
> +typedef        arch_irq_alloc_info_t irq_alloc_info_t;
> +#else
> +typedef        void irq_alloc_info_t;
> +#endif
> 
>  /**
>   * struct irq_domain_ops - Methods for irq_domain objects
>   * @match: Match an interrupt controller device node to a host, returns
> @@ -59,7 +66,11 @@ struct of_device_id;
>   */
>  struct irq_domain_ops {
>         int (*match)(struct irq_domain *d, struct device_node *node);
> -       int (*map)(struct irq_domain *d, unsigned int virq,
> irq_hw_number_t hw);
> +       int (*alloc)(struct irq_domain *d, irq_hw_number_t hw,
> +                    irq_alloc_info_t *info);
> +       int (*free)(struct irq_domain *d, unsigned int virq);
> +       int (*map)(struct irq_domain *d, unsigned int virq,
> irq_hw_number_t hw,
> +                  irq_alloc_info_t *info);
>         void (*unmap)(struct irq_domain *d, unsigned int virq);
>         int (*xlate)(struct irq_domain *d, struct device_node *node,
>                      const u32 *intspec, unsigned int intsize,
> 
> alloc()/free() interfaces will be used allocate/free IRQ from parent
> domain. And irq_alloc_info_t structure is used to host parameters
> and constraints for IRQ allocation.
> 
> For x86, irq_alloc_info_t structure will be used to host CPU mask,
> device pointer, IOAPIC pin attributes, NUMA node info etc.

Do we really need to hand all of this down?

Thanks,

	tglx
