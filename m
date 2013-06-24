Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3FXBuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:50:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:47084 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab3FXBuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:50:19 -0400
Message-ID: <1372038589.3944.118.camel@pasglop>
Subject: Re: [PATCH v2] powerpc/pci: Improve device hotplug initialization
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Date: Mon, 24 Jun 2013 11:49:49 +1000
In-Reply-To: <20130621165453.GA5506@roeck-us.net>
References: <1370884688-7753-1-git-send-email-linux@roeck-us.net>
	 <20130621165453.GA5506@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 09:54 -0700, Guenter Roeck wrote:

> > v2: Ensure that PCI bus fixup code has been executed before calling
> >     device setup code.
> > 
> Hi Ben,
> 
> any comments/feedback on this approach ?
> 
> It is much less invasive than before and should address your concerns.

And also less nice cleanup :-) I'll have a look.

Cheers,
Ben.

> Thanks,
> Guenter
> 
> >  arch/powerpc/kernel/pci-common.c |   17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> > index 7f2273c..6909b13 100644
> > --- a/arch/powerpc/kernel/pci-common.c
> > +++ b/arch/powerpc/kernel/pci-common.c
> > @@ -992,7 +992,7 @@ void pcibios_setup_bus_self(struct pci_bus *bus)
> >  		ppc_md.pci_dma_bus_setup(bus);
> >  }
> >  
> > -void pcibios_setup_device(struct pci_dev *dev)
> > +static void pcibios_setup_device(struct pci_dev *dev)
> >  {
> >  	/* Fixup NUMA node as it may not be setup yet by the generic
> >  	 * code and is needed by the DMA init
> > @@ -1013,6 +1013,17 @@ void pcibios_setup_device(struct pci_dev *dev)
> >  		ppc_md.pci_irq_fixup(dev);
> >  }
> >  
> > +int pcibios_add_device(struct pci_dev *dev)
> > +{
> > +	/*
> > +	 * We can only call pcibios_setup_device() after bus setup is complete,
> > +	 * since some of the platform specific DMA setup code depends on it.
> > +	 */
> > +	if (dev->bus->is_added)
> > +		pcibios_setup_device(dev);
> > +	return 0;
> > +}
> > +
> >  void pcibios_setup_bus_devices(struct pci_bus *bus)
> >  {
> >  	struct pci_dev *dev;
> > @@ -1467,10 +1478,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
> >  		if (ppc_md.pcibios_enable_device_hook(dev))
> >  			return -EINVAL;
> >  
> > -	/* avoid pcie irq fix up impact on cardbus */
> > -	if (dev->hdr_type != PCI_HEADER_TYPE_CARDBUS)
> > -		pcibios_setup_device(dev);
> > -
> >  	return pci_enable_resources(dev, mask);
> >  }
> >  
> > -- 
> > 1.7.9.7
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


