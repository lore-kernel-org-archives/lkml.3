Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab3FXEsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:48:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64625 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3FXEsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:48:20 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 23 Jun 2013 21:48:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH v2] powerpc/pci: Improve device hotplug initialization
Message-ID: <20130624044821.GA12432@roeck-us.net>
References: <1370884688-7753-1-git-send-email-linux@roeck-us.net>
 <20130621165453.GA5506@roeck-us.net>
 <1372038589.3944.118.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372038589.3944.118.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:49:49AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-06-21 at 09:54 -0700, Guenter Roeck wrote:
> 
> > > v2: Ensure that PCI bus fixup code has been executed before calling
> > >     device setup code.
> > > 
> > Hi Ben,
> > 
> > any comments/feedback on this approach ?
> > 
> > It is much less invasive than before and should address your concerns.
> 
> And also less nice cleanup :-) I'll have a look.
> 
I know :(.

Reminds me of that old story of being stuck between a rock and a hard place ...

Guenter

> Cheers,
> Ben.
> 
> > Thanks,
> > Guenter
> > 
> > >  arch/powerpc/kernel/pci-common.c |   17 ++++++++++++-----
> > >  1 file changed, 12 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> > > index 7f2273c..6909b13 100644
> > > --- a/arch/powerpc/kernel/pci-common.c
> > > +++ b/arch/powerpc/kernel/pci-common.c
> > > @@ -992,7 +992,7 @@ void pcibios_setup_bus_self(struct pci_bus *bus)
> > >  		ppc_md.pci_dma_bus_setup(bus);
> > >  }
> > >  
> > > -void pcibios_setup_device(struct pci_dev *dev)
> > > +static void pcibios_setup_device(struct pci_dev *dev)
> > >  {
> > >  	/* Fixup NUMA node as it may not be setup yet by the generic
> > >  	 * code and is needed by the DMA init
> > > @@ -1013,6 +1013,17 @@ void pcibios_setup_device(struct pci_dev *dev)
> > >  		ppc_md.pci_irq_fixup(dev);
> > >  }
> > >  
> > > +int pcibios_add_device(struct pci_dev *dev)
> > > +{
> > > +	/*
> > > +	 * We can only call pcibios_setup_device() after bus setup is complete,
> > > +	 * since some of the platform specific DMA setup code depends on it.
> > > +	 */
> > > +	if (dev->bus->is_added)
> > > +		pcibios_setup_device(dev);
> > > +	return 0;
> > > +}
> > > +
> > >  void pcibios_setup_bus_devices(struct pci_bus *bus)
> > >  {
> > >  	struct pci_dev *dev;
> > > @@ -1467,10 +1478,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
> > >  		if (ppc_md.pcibios_enable_device_hook(dev))
> > >  			return -EINVAL;
> > >  
> > > -	/* avoid pcie irq fix up impact on cardbus */
> > > -	if (dev->hdr_type != PCI_HEADER_TYPE_CARDBUS)
> > > -		pcibios_setup_device(dev);
> > > -
> > >  	return pci_enable_resources(dev, mask);
> > >  }
> > >  
> > > -- 
> > > 1.7.9.7
> > > 
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
