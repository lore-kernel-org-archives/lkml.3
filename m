Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaKDKGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:06:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:58370 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:06:15 -0500
Date: Tue, 4 Nov 2014 11:06:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        jason@lakedaemon.net, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        liviu.dudau@arm.com, Harish.Kasiviswanathan@amd.com,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
In-Reply-To: <54584681.2010103@amd.com>
Message-ID: <alpine.DEB.2.11.1411040903340.5308@nanos>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <alpine.DEB.2.11.1411032300160.5308@nanos> <54584681.2010103@amd.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Suravee Suthikulanit wrote:
> On 11/3/2014 4:51 PM, Thomas Gleixner wrote:
> > On Mon, 3 Nov 2014, suravee.suthikulpanit@amd.com wrote:
> > > +	irq_domain_set_hwirq_and_chip(v2m->domain, virq, hwirq,
> > > +				&v2m_chip, v2m);
> > > +
> > > +	irq_set_msi_desc(hwirq, desc);
> > > +	irq_set_irq_type(hwirq, IRQ_TYPE_EDGE_RISING);
> > 
> > Sure both calls work perfectly fine as long as virq == hwirq, right?
> 
> I was running into an issue when calling the irq_domain_alloc_irq_parent(), it
> requires of_phandle_args pointer to be passed in. However, this does not work
> for GICv2m since it does not have interrupt information in the device tree.
> So, I decided at first to use direct (virq == hwirq) mapping, which simplifies
> the code a bit, but might not be ideal solution, as you pointed out.

It's not only far from ideal. It's not a solution at all. Simply
because there is no guarantee for virq == hwirq.
 
> An alternative would be to create a temporary struct of_phandle_args, and
> populate it with the interrupt information for the requested MSI. Then pass it
> to:
>   --> irq_domain_alloc_irq_parent
>    |--> gic_irq_domain_alloc
>      |--> gic_irq_domain_xlate
>      |--> gic_irq_domain_map
> 
> However, this would still not be ideal if we want to support ACPI. Another

Neither device tree nor ACPI has anything to do with MSI interrupts at
runtime.

All they do is to tell that there is a MSI controller and where the
registers are and in the worst case fixups for a borked MSI_TYPER
register.

So either the TYPER reg or DT/ACPI gives you a fixed hwirq range which
is reserved for MSI. And that's all you need, right?

The MSI interrupt itself has no DT/ACPI information to use at
allocation time simply because you CANNOT decribe a MSI device
interrupt in DT/ACPI by any means.

And you do not need any DT/ACPI information at that point. All you
need is to pick one hwirq out of the existing fixed range and
associate it to a newly allocated virq. That's the only information
the underlying gic domain has to know about, because it needs to
translate from the hwirq to the virq in the low level entry handler
gic_handle_irq().

> alternative would be coming up with a dedicate structure to be used here. I
> noticed on X86, it uses struct irq_alloc_info. May be that's what we also need
> here.

It's a x86 concept to transport X86 specific information in order to
avoid duplicated code all over the place. And x86 MSI support is a
completely different beast than the thing you are dealing with. x86
has no concept of a fixed hwirq range for MSI.

So no, just picking random stuff from random MSI implementations does
not help at all.

> > [...]
> > I do not care at all how YOU waste your time. But I care very much
> > about the fact that YOU are wasting MY precious time by exposing me to
> > your patch trainwrecks.
> 
> I don't intend to waste yours or anybody's precious time. Sorry if it takes a
> couple iterations to work out the issues. Also, I will try to put more comment
> in my code to make it more clear. Let me know what works best for you to work
> out the issues.

By not sending obviously broken and half thought out patches in the
first place.

Thanks,

	tglx
