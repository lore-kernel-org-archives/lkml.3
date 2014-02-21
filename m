Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaBUVxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:53:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaBUVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:53:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 7/7] powerpc: Added PCI MSI support using the HSTA module
Date: Fri, 21 Feb 2014 22:53:00 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Alistair Popple <alistair@popple.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1574137.lzDhNaVqIe@wuerfel> <1393015286.6771.110.camel@pasglop>
In-Reply-To: <1393015286.6771.110.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402212253.01101.arnd@arndb.de>
X-Provags-ID: V02:K0:jev6XiRs5N8NhvJQwfZy8C0TCIcg3XIYxT4AaaNhD6s
 p5pm2X/1jZC9jQgm6vnU/oNIeTLyYfkcau63I39mC0tTJmr3c0
 Z5QXD/46udMplydJHlw0/XFuyF3DmQC7dN6c1dCgGNcNj48tTv
 Qg6C85zt+nAZeMNo0Zo07yvysXI5kx0fYmMqMhl50/KX5AAFIW
 h0YHmG06+4idS7KdFvi0wWEWJ20fYEW5VGxZobICPGc0Rsd+ke
 C9qWESca3G2Oh4mVnVeI5Rv55oX8phlJxUD3jV9blVcn/o+rDZ
 X8zXv+9J+BeSKDWwiMBEmEeU2iOJp4M0+l07UCU3ZC5+I63RPZ
 fi1BXirJ3kXwobiPT98Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014, Benjamin Herrenschmidt wrote:
> On Fri, 2014-02-21 at 15:33 +0100, Arnd Bergmann wrote:
> 
> > > @@ -242,8 +264,10 @@
> > >  			ranges = <0x02000000 0x00000000 0x80000000 0x00000110 0x80000000 0x0 0x80000000
> > >  			          0x01000000 0x0        0x0        0x00000140 0x0        0x0 0x00010000>;
> > >  
> > > -			/* Inbound starting at 0 to memsize filled in by zImage */
> > > -			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
> > > +			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
> > > +			 * PCI devices must be able to write to the HSTA module.
> > > +			 */
> > > +			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
> 
> Should we (provided it's possible in HW) create two ranges instead ? One
> covering RAM and one covering MSIs ? To avoid stray DMAs whacking random
> HW registers in the chip ...
> 
> > >  			/* This drives busses 0 to 0xf */
> > >  			bus-range = <0x0 0xf>;
> > 
> > Ah, I first only saw the line you are removing and was about
> > to suggest what you do anyway. Great!
> > 
> > > diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
> > > index 54ec1d5..7cc3acc 100644
> > > --- a/arch/powerpc/sysdev/ppc4xx_pci.c
> > > +++ b/arch/powerpc/sysdev/ppc4xx_pci.c
> > > @@ -176,8 +176,12 @@ static int __init ppc4xx_parse_dma_ranges(struct pci_controller *hose,
> > >  		return -ENXIO;
> > >  	}
> > >  
> > > -	/* Check that we are fully contained within 32 bits space */
> > > -	if (res->end > 0xffffffff) {
> > > +	/* Check that we are fully contained within 32 bits space if we are not
> > > +	 * running on a 460sx or 476fpe which have 64 bit bus addresses.
> > > +	 */
> > > +	if (res->end > 0xffffffff &&
> > > +	    !(of_device_is_compatible(hose->dn, "ibm,plb-pciex-460sx")
> > > +	      || of_device_is_compatible(hose->dn, "ibm,plb-pciex-476fpe"))) {
> > >  		printk(KERN_ERR "%s: dma-ranges outside of 32 bits space\n",
> > >  		       hose->dn->full_name);
> > >  		return -ENXIO;
> > 
> > A more general question for BenH: Apparently this PCI implementation is
> > getting reused on arm64 for APM X-Gene. Do you see any value in trying to
> > share host controller drivers like this one across powerpc and arm64?
> 
> I would start duplicating, and see how much common code remains... Then
> eventually merge.

Ok.

> > It's possible we are going to see the same situation with fsl_pci in the
> > future, if arm and powerpc qoriq chips use the same peripherals. My
> > plan for arm64 right now is to make PCI work without any code in arch/,
> > just using new helper functions in drivers/pci and sticking the host
> > drivers into drivers/pci/host as we started doing for arm32, but it
> > can require significant work to make those drivers compatible with
> > the powerpc pci-common.c.
> 
> powerpc pci-common.c is shrinking :-) At least the address remapping is
> all in the core now, we could move more over I suppose...

Ah, good. We're currently trying to work out a generic way to parse
the DT and ioremap the I/O windows. That could probably be shared
and while I hope what we need on arm64 is compatible with what you
need on powerpc, I may always miss something. I'll make sure to add
you to the discussions.

Some parts are easier because we assume that we always scan the
entire PCI bus ourselves and don't do PCI_PROBE_DEVTREE. 
Other parts are harder because for the generic case we actually
want to support loading and unloading host bridge drivers,
as well as supporting any combination of host bridges in the
same system without platform specific code.

	Arnd
