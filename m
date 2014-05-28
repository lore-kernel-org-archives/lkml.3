Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaE1VJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:09:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:40404 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaE1VJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:09:02 -0400
Date: Wed, 28 May 2014 23:08:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch V3 19/37] x86, irq: introduce mechanisms to support
 dynamically allocate IRQ for IOAPIC
In-Reply-To: <53856D8E.3010401@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1405282301310.3952@nanos>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-20-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de> <53856D8E.3010401@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Jiang Liu wrote:
> On 2014/5/28 3:58, Thomas Gleixner wrote:
> > So you have these cases covered here:
> > 
> > 1) The ACPI case of secondary ioapics. You only have the strict 1:1
> >    mapping for the first ioapic
> > 
> > 2) The gsi < NR_IRQS_LEGACY case where you have two options:
> > 
> >     a) Let the core create a random virq number if ioapic_identity_map
> >        is 0
> > 
> >        ioapic_identity_map is only set by SFI and devicetree
> > 
> >        So in all other cases we fall into that code path for all
> >        legacy interrupts. So how is that supposed to work lets say for
> >        i8042 which has hardcoded irq 1 and 12?
> > 
> >        irq_create_mapping(1)
> >        
> > 	    hint = 1 % nr_irqs; --> 1
> > 	    virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
> > 
> > 	    This returns something >= 16, because the irq descriptors
> > 	    for 0-15 (LEGACY) are allocated already.
> > 
> >        The pin association works, but how is the i8042 driver supposed
> >        to figure out that it should request the virq >=16 which was
> >        created instead of the hardcoded 1 ?
> This is used to work around special non-ISA interrupts with GSI below
> NR_IRQS_LEGACY. The original code for the special case is:
> /*
>  * Provide an identity mapping of gsi == irq except on truly
>  * weird platforms that have non isa irqs in the first 16 gsis.
>  */
> return gsi >= NR_IRQS_LEGACY ? gsi : gsi_top + gsi;

That looks really, really wrong. What's wrong with assigning that irq
irq number on those platforms?

The weird stuff is SFI and devicetree, if I understand your code
correctly.

So if those platforms do not have actual legacy irqs, what's wrong
with giving out the legacy numbers?

> We have one path to handle ISA IRQs before calling
> alloc_irq_from_domain() as below:
>         if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci))
>                 return mp_irqs[idx].srcbusirq;

Ok.
 
> >         /* We can't set this earlier, because we need to calibrate the timer */
> >         legacy_pic = &null_legacy_pic;
> I haven't figured out the story behind the comment yet:(

Sebastian gave some insight.
 
> > Why do we need strict mappings in the non ACPI case for all ioapic
> > pins? What's so different about ACPI? Or is this just to avoid
> > breaking the existing SFI/devicetree stuff. If that's the reason I'm
> > fine with it, but ...
> It's to avoid breaking SFI/intel_mid stuff. intel_mid assumes IRQ
> number equals to pin number and use pci_dev->irq to save both IRQ
> number and pin number.

Fair enough.

Thanks,

	tglx

 
