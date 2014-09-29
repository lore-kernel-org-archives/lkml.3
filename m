Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaI2PxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:53:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:52695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaI2PxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:53:15 -0400
Date: Mon, 29 Sep 2014 17:53:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abel <wuyun.wu@huawei.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: Re: [RFT v2 01/24] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
In-Reply-To: <54294F1C.30606@huawei.com>
Message-ID: <alpine.DEB.2.02.1409291707410.22082@ionos.tec.linutronix.de>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com> <1411740145-30626-2-git-send-email-jiang.liu@linux.intel.com> <54294F1C.30606@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Abel wrote:
> On 2014/9/26 22:02, Jiang Liu wrote:
> > +static void irq_domain_free_descs(unsigned int virq, unsigned int nr_irqs)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < nr_irqs; i++)
> > +		irq_free_desc(virq + i);
> > +}
> 
> I am not sure why this function is needed, since it works in the exact same
> way as irq_free_descs(virq, nr_irqs).

Indeed.
 
> I've been through your patches and noticed that the only domain
> which does not call irq_domain_alloc_irqs_parent() is
> x86_vector_domain. And this makes sense *if* we already knew which
> domain is the nearest one to the CPU.

Right, and in case of x86 the vector domain _IS_ the one which is
always the nearest one to the cpu.

> But I don't think a well implemented device driver should assume
> itself be in a particular position of the interrupt delivery path.

The device driver has no knowledge of this. The irq domain driver
definitely has to know to some extent.

> Actually it should be guaranteed by the core infrastructure that all
> the domains in the interrupt delivery path should allocate a
> hardware interrupt for the interrupt source.

Well, that's what we do. We allocate down the irq domain hierarchy. If
one level fails the whole operation fails.

> And besides the comments/questions I mentioned above, I am also curious about
> how the chained interrupts been processed.
> 
> Let's take a 3-level-chained-domains for example.
> Given 3 interrupt controllers A, B and C, and the interrupt delivery path is:
> 
> DEV -> A -> B -> C -> CPU
> 
> After the hierarchy irqdomains are established, the unique linux interrupt of
> DEV will be mapped with a hardware interrupt in each domain:
> 
> DomainA: HWIRQ_A => VIRQ_DEV
> DomainB: HWIRQ_B => VIRQ_DEV
> DomainC: HWIRQ_C => VIRQ_DEV
> 
> When the DEV triggered an interrupt signal, the CPU will acknowledge HWIRQ_C,

Not necessarily. The CPU will process HWIRQ_C. The acknowledge
mechanism depends on the implementation details of the hierarchy.

> and then irq_find_mapping(DomainC, HWIRQ_C) will be called to get the linux
> interrupt VIRQ_DEV, and after the handler of the VIRQ_DEV has been processed,
> the interrupt will end with the level (if have) uncleared on B, which will
> result in the interrupt of DEV cannot be processed again.
> 
> Or is there anything I misunderstand?

This heavily depends on the properties of the stacked domains.

It depends on the hardware requirements and the implementation of
domain A and B how this is handled.

It might be sufficient to have the following code in the irq_ack()
callback of domain A:

irq_ack_A(struct irq_data *d)
{
	ack_hw_A();
}

Another HW or stacking scenario requires

irq_ack_A(struct irq_data *d)
{
	ack_hw_A();
	ack_parent();
}

where ack_parent() does:

      if (d->parent_data)
      	 d->parent_data->chip->ack(d->parent_data);

and ack_hw_A() can be anything from a nop to some more or less complex
hw access.

So we cannot define upfront how deep an ack/mask/unmask/... has to be
propagated down the chain. This needs a careful consideration in terms
of functionality and we want to be able to do performance shortcuts as
well.

Thanks,

	tglx


