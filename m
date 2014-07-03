Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaGCIsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:48:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52215 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964868AbaGCIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:46:54 -0400
Date: Thu, 3 Jul 2014 09:46:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Message-ID: <20140703084608.GB29837@leverpostej>
References: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140702163903.GA26903@leverpostej>
 <53B465B9.7000407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B465B9.7000407@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:04:09PM +0100, Suravee Suthikulanit wrote:
> Thanks again for the review. Please see my comments below.
> 
> On 7/2/2014 11:39 AM, Mark Rutland wrote:
> > On Wed, Jul 02, 2014 at 04:22:23PM +0100, suravee.suthikulpanit@amd.com wrote:
> >> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> >> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> >> index 5573c08..9e46f7f 100644
> >> --- a/Documentation/devicetree/bindings/arm/gic.txt
> >> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> >> @@ -12,11 +12,13 @@ Main node required properties:
> >>
> >>   - compatible : should be one of:
> >>          "arm,gic-400"
> >> +       "arm,gic-400-plus"
> >
> > I am not keen on this name.
> 
> Ok, I'll change it. Any suggestion on name?  I'm not sure what is the 
> "official" product name. I've seen this in some slides from ARM. What 
> about "gic-400-v2m"??.

I'll query this internally.

> >>          "arm,cortex-a15-gic"
> >>          "arm,cortex-a9-gic"
> >>          "arm,cortex-a7-gic"
> >>          "arm,arm11mp-gic"
> >>   - interrupt-controller : Identifies the node as an interrupt controller
> >> +
> >>   - #interrupt-cells : Specifies the number of cells needed to encode an
> >>     interrupt source.  The type shall be a <u32> and the value shall be 3.
> >
> > Random (inconsistent) whitespace change?
> It looks to me like there should have been a space here to keep the 
> consistent look, and make it easy to read

As far as I can see it's inconsistent because you didn't add a newline
before the "interrupt-controller" line immediately before.

I'm not against adding spacing between the properties, so long as it is
consistent.

> >> @@ -37,9 +39,16 @@ Main node required properties:
> >>          the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
> >>          the interrupt is wired to that CPU.  Only valid for PPI interrupts.
> >>
> >> -- reg : Specifies base physical address(s) and size of the GIC registers. The
> >> -  first region is the GIC distributor register base and size. The 2nd region is
> >> -  the GIC cpu interface register base and size.
> >> +- reg : Specifies base physical address(s) and size of the GIC register frames.
> >> +
> >> +  Region | Description
> >> +  Index  |
> >> +  -------------------------------------------------------------------
> >> +     0   | GIC distributor register base and size
> >> +     1   | GIC cpu interface register base and size
> >> +     2   | VGIC interface control register base and size (Optional)
> >> +     3   | VGIC CPU interface register base and size (Optional)
> >> +     4   | GICv2m MSI interface register base and size (Optional)
> >
> > As far as I am aware, the MSI interface is completely orthogonal to
> > having a GICH and GICV.
> 
> Agree. I'm not doing anything with it. I'm just listing them here since 
> they are also mentioned in the gic.txt
> 
> >
> > We should figure out how we expect to handle that (zero-sized reg
> > entries? reg-names?).
> 
> I'm not sure how VGIC stuff handles reg/size = 0.

Neither am I.

However, what I said was that we should figure out how we _expect_ to
handle that case. If we have to make changes to handle it, that's fine
given we already have to make changes to support GICv2m.

> >
> >>
> >>   Optional
> >>   - interrupts   : Interrupt source of the parent interrupt controller on
> >> @@ -55,6 +64,10 @@ Optional
> >>                    by a crossbar/multiplexer preceding the GIC. The GIC irq
> >>                    input line is assigned dynamically when the corresponding
> >>                    peripheral's crossbar line is mapped.
> >> +
> >> +- msi-controller : Identifies the node as an MSI controller.  This requires
> >> +  the register region index 4.
> >
> > That last clarifying comment is more confusing than helpful.
> 
> If you are referring to the table, I added that since it was easier to 
> see than scanning the text.

I was referring to "This requires the register region index 4".

How about:

- msi-controller : Identifies the node as an MSI controller. Requried
  for GICv2m.

> 
> > [...]
> >
> >> +#define GIC_V2M_MIN_SPI                        32
> >> +#define GIC_V2M_MAX_SPI                        1024
> >
> > GIC interrupt IDs 1020 and above are reserved, no?
> >
> > Surely the max ID an SPI can take is 1019?
> 
> Right, thanks for catching. But the spec says that the SPI ID value must 
> be in the range of 32 to 1020. I guess it was a bit unclear, but 
> definitely not 1024 :)

Which spec?

In the GICv2 spec I see:

* "Interrupt numbers ID32-ID1019 are used for SPIs." in 
  2.2.1 Interrupt IDs.

* "The GIC architecture reserves interrupt ID numbers 1020-1023 for
  special purposes." in 3.2.5 Special interrupt numbers.

> 
> >> +#define GIC_OF_MSIV2M_RANGE_INDEX      4
> >> +
> >> +/**
> >> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
> >> + * @data: Pointer to v2m_data
> >> + * @nvec: Number of interrupts to allocate
> >> + * @irq: Pointer to the allocated irq
> >> + *
> >> + * Allocates interrupts only if the contiguous range of MSIs
> >> + * with specified nvec are available. Otherwise return the number
> >> + * of available interrupts. If none are available, then returns -ENOENT.
> >> + */
> >
> > This function is overly complicated, and pointlessly so.
> >
> > It doesn't achieve anything useful as it returns the size of the _last_
> > contiguous block rather than the _largest_ contiguous block, and the
> > only caller (gicv2m_setup_msi_irq) doesn't even care.
> >
> > Simplify this to just return an error code if allocation is impossible.
> 
> Actually, I made another mistake in the gicv2m_setup_msi_irq when 
> returning from the alloc_msi_irq().

Ok.

> My understanding is the arch_setup_msi_irqs() is supposed to return the 
> number of available vectors if the requested amount could not be 
> allocated. I notice that the current "drivers/pci/msi.c: 
> arch_setup_msi_irqs()" does not do so, which is okay.
> 
> However, We are also working on adding support for multi-MSI support 
> since some of the devices we have are using it, which means we will need 
> to provide a different version of the "arch_setup_msi_irqs()" as the 
> current one does not allow (PCI_CAP_ID_MSI && nvec > 1).
> 
> Therefore, I implemented the "alloc_msi_irq" this way to account for 
> future changes.

Per my comments, I still think the function is broken given it returns
the size of the last contiguous block of available interrupts.

If we don't yet have support for multi-MSI, just return an error code
for now. The code isn't helpful and that path isn't tested.

We can fix up the driver when we add multi-MSI support.

Thanks,
Mark.
