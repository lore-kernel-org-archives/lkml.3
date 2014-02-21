Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaBUUmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:42:02 -0500
Received: from gate.crashing.org ([63.228.1.57]:36262 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbaBUUl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:41:59 -0500
Message-ID: <1393015286.6771.110.camel@pasglop>
Subject: Re: [PATCH 7/7] powerpc: Added PCI MSI support using the HSTA module
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alistair Popple <alistair@popple.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Sat, 22 Feb 2014 07:41:26 +1100
In-Reply-To: <1574137.lzDhNaVqIe@wuerfel>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
	 <1392964293-13687-8-git-send-email-alistair@popple.id.au>
	 <1574137.lzDhNaVqIe@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 15:33 +0100, Arnd Bergmann wrote:

> > @@ -242,8 +264,10 @@
> >  			ranges = <0x02000000 0x00000000 0x80000000 0x00000110 0x80000000 0x0 0x80000000
> >  			          0x01000000 0x0        0x0        0x00000140 0x0        0x0 0x00010000>;
> >  
> > -			/* Inbound starting at 0 to memsize filled in by zImage */
> > -			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
> > +			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
> > +			 * PCI devices must be able to write to the HSTA module.
> > +			 */
> > +			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;

Should we (provided it's possible in HW) create two ranges instead ? One
covering RAM and one covering MSIs ? To avoid stray DMAs whacking random
HW registers in the chip ...

> >  			/* This drives busses 0 to 0xf */
> >  			bus-range = <0x0 0xf>;
> 
> Ah, I first only saw the line you are removing and was about
> to suggest what you do anyway. Great!
> 
> > diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
> > index 54ec1d5..7cc3acc 100644
> > --- a/arch/powerpc/sysdev/ppc4xx_pci.c
> > +++ b/arch/powerpc/sysdev/ppc4xx_pci.c
> > @@ -176,8 +176,12 @@ static int __init ppc4xx_parse_dma_ranges(struct pci_controller *hose,
> >  		return -ENXIO;
> >  	}
> >  
> > -	/* Check that we are fully contained within 32 bits space */
> > -	if (res->end > 0xffffffff) {
> > +	/* Check that we are fully contained within 32 bits space if we are not
> > +	 * running on a 460sx or 476fpe which have 64 bit bus addresses.
> > +	 */
> > +	if (res->end > 0xffffffff &&
> > +	    !(of_device_is_compatible(hose->dn, "ibm,plb-pciex-460sx")
> > +	      || of_device_is_compatible(hose->dn, "ibm,plb-pciex-476fpe"))) {
> >  		printk(KERN_ERR "%s: dma-ranges outside of 32 bits space\n",
> >  		       hose->dn->full_name);
> >  		return -ENXIO;
> 
> A more general question for BenH: Apparently this PCI implementation is
> getting reused on arm64 for APM X-Gene. Do you see any value in trying to
> share host controller drivers like this one across powerpc and arm64?

I would start duplicating, and see how much common code remains... Then
eventually merge.

> It's possible we are going to see the same situation with fsl_pci in the
> future, if arm and powerpc qoriq chips use the same peripherals. My
> plan for arm64 right now is to make PCI work without any code in arch/,
> just using new helper functions in drivers/pci and sticking the host
> drivers into drivers/pci/host as we started doing for arm32, but it
> can require significant work to make those drivers compatible with
> the powerpc pci-common.c.

powerpc pci-common.c is shrinking :-) At least the address remapping is
all in the core now, we could move more over I suppose...

Cheers,
Ben.

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


