Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbaJ3Kkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:40:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:34008 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbaJ3Kkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:40:39 -0400
Date: Thu, 30 Oct 2014 11:39:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [Patch Part2 v3 15/24] x86, MSI: Use hierarchy irqdomain to
 manage MSI interrupts
In-Reply-To: <5451C379.1050508@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1410300947450.5308@nanos>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos> <5450A9D8.108@linux.intel.com> <alpine.DEB.2.11.1410291017180.5308@nanos>
 <5451C379.1050508@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Jiang Liu wrote:
> On 2014/10/29 17:19, Thomas Gleixner wrote:
> >> IOAPIC runs into the same situation, but I need some more time
> >> to find a solution:)
> > 
> > I'm sure you will!
> Hi Thomas,
> 	I have reviewed IOAPIC related change again, but the conclusion
> may not be what you expect:(
> 	Currently IOAPIC driver detects IRQ remapping for following
> tasks:
> 1) Issue different EOI command to IOAPIC chip for unammped and remapped
>    interrupts. It uses pin number instead of vector number for remapped
>    interrupts.
> 2) Print different format for IOAPIC entries for unmapped and remapped
>    interrupts.
> 3) ioapic_ack_level() uses different method for unmapped and remapped
>    interrupts
> 4) create different IOAPIC entry content for unmapped and remapped
>    interrupts
> 5) choose different flow handler for unmapped and remapped interrupts

So todays code does 

1/2/3 via irq_remap_modify_chip_defaults() and via
      x86_io_apic_ops.eoi_ioapic_pin with convoluted back and forth
      calls from remap to ioapic code.

4)    is solved via x86_io_apic_ops.setup_entry

5)    via setup_remapped_irq()

Now with the stacked irq domains we end up with the following two
scenarios:

	ioapic_domain -> vector_domain

	ioapic_domain -> remap_domain -> vector_domain

So if you look at the various issues you want to solve:

#1 Is simple to solve via:   	

static void ioapic_eoi(struct irq_data *data)
{
	if (data->parent->chip->irq_eoi)
		data->parent->chip->irq_eoi(data->parent);
	else
	    	plain_ioapic_eoi(data);
}

#2/3 Ditto

#4/5 Should be solvable via the irq_startup callback in a similar way

static int ioapic_startup(struct irq_data *data)
{
	if (data->parent->chip->irq_startup)
		return data->parent->chip->irq_startup(data->parent);
	else
	    	return plain_ioapic_startup(data);
}

I.e. you set the entry and the handler from the startup function of
ioapic or remap.

It's probably not that simple as the above, but I'm pretty confident,
that we can map it without adding a gazillion of new callbacks to
irqchip.

> For MSI, it only needs to solve task 4) above. For IOAPIC, it needs
> to solve all five tasks above, which may cause big changes to irq_chip.
> And it even may cause IRQ remapping driver call back into IOAPIC driver,
> which breaks another rules that only the driver touches corresponding
> interrupt controller.

If the remap driver calls ioapic functions which are provided for that
purpose then I think that's unavoidable and ok. But I really want to
avoid the intermingled mess in the other code pathes which call back
and forth.
 
> On the other hand, MSI is almost platform independent, so it's
> reasonable to change public struct irq_chip to support MSI.

Right, but I think we can get away without adding new functions to
irqchip for the ioapic/remap thing.

Thanks,

	tglx

