Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbbA0AnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:43:15 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36648 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbA0AnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:43:11 -0500
Date: Mon, 26 Jan 2015 18:43:07 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <Will.Deacon@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
Message-ID: <20150127004307.GE11624@google.com>
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
 <1418069543-21969-3-git-send-email-marc.zyngier@arm.com>
 <20150127004005.GC11624@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127004005.GC11624@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:40:05PM -0600, Bjorn Helgaas wrote:
> On Mon, Dec 08, 2014 at 08:12:19PM +0000, Marc Zyngier wrote:
> > In order to be able to populate the device msi_domain field,
> > add the necesary hooks to propagate the PHB msi_domain across
> > secondary busses to devices.
> > 
> > So far, nobody populates the initial msi_domain.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  drivers/pci/probe.c | 24 ++++++++++++++++++++++++
> >  include/linux/pci.h |  1 +
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index c8ca98c..d1009a2 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -670,6 +670,20 @@ static void pci_set_bus_speed(struct pci_bus *bus)
> >  	}
> >  }
> >  
> > +void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
> 
> We haven't previously used the "phb" abbreviation in the PCI core, so I'd
> rather not start now.  I'm not really sure how relevant it is anyway --
> maybe the name doesn't need to include a reference to the host bridge at
> all?

Sorry, I meant to reply to the v2 patch, not the old one.  But I think the
comment still applies there.

> > +{
> > +}
> > +
> > +static void pci_set_bus_msi_domain(struct pci_bus *bus)
> > +{
> > +	struct pci_dev *bridge = bus->self;
> > +
> > +	if (!bridge)
> > +		pcibios_set_phb_msi_domain(bus);
> > +	else
> > +		dev_set_msi_domain(&bus->dev, dev_get_msi_domain(&bridge->dev));
> > +}
> > +
> >  static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> >  					   struct pci_dev *bridge, int busnr)
> >  {
> > @@ -723,6 +737,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> >  	bridge->subordinate = child;
> >  
> >  add_dev:
> > +	pci_set_bus_msi_domain(child);
> >  	ret = device_register(&child->dev);
> >  	WARN_ON(ret < 0);
> >  
> > @@ -1517,6 +1532,11 @@ static void pci_init_capabilities(struct pci_dev *dev)
> >  	pci_enable_acs(dev);
> >  }
> >  
> > +static void pci_set_msi_domain(struct pci_dev *dev)
> > +{
> > +	dev_set_msi_domain(&dev->dev, dev_get_msi_domain(&dev->bus->dev));
> > +}
> > +
> >  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> >  {
> >  	int ret;
> > @@ -1546,6 +1566,9 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> >  	/* Initialize various capabilities */
> >  	pci_init_capabilities(dev);
> >  
> > +	/* Setup MSI irq domain */
> 
> This is *really* a nitpick, but "setup" suggests that we're doing more than
> just setting a pointer, i.e., it suggests that we're doing something more
> involved to get it all ready for use.  But here, I think we really are just
> setting a pointer, so I think the comment is pointless since the function
> name already says that.
> 
> > +	pci_set_msi_domain(dev);
> > +
> >  	/*
> >  	 * Add the device to our list of discovered devices
> >  	 * and the bus list for fixup functions, etc.
> > @@ -1947,6 +1970,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >  	b->bridge = get_device(&bridge->dev);
> >  	device_enable_async_suspend(b->bridge);
> >  	pci_set_bus_of_node(b);
> > +	pci_set_bus_msi_domain(b);
> >  
> >  	if (!parent)
> >  		set_dev_node(b->bridge, pcibus_to_node(b));
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index a523cee..3266764 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -1637,6 +1637,7 @@ int pcibios_set_pcie_reset_state(struct pci_dev *dev,
> >  int pcibios_add_device(struct pci_dev *dev);
> >  void pcibios_release_device(struct pci_dev *dev);
> >  void pcibios_penalize_isa_irq(int irq, int active);
> > +void pcibios_set_phb_msi_domain(struct pci_bus *bus);
> >  
> >  #ifdef CONFIG_HIBERNATE_CALLBACKS
> >  extern struct dev_pm_ops pcibios_pm_ops;
> > -- 
> > 2.1.3
> > 
