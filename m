Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EHTar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3EHTaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:30:46 -0400
Message-ID: <1368041414.7331.46.camel@ul30vt.home>
Subject: Re: [PATCH v2 1/8] pci: Create pci_reset_bridge_secondary_bus()
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 08 May 2013 13:30:14 -0600
In-Reply-To: <518AA420.5020900@redhat.com>
References: <20130508025339.30771.61937.stgit@bling.home>
	 <20130508025740.30771.50033.stgit@bling.home> <518AA420.5020900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 15:14 -0400, Don Dutile wrote:
> On 05/07/2013 10:57 PM, Alex Williamson wrote:
> > Move the secondary bus reset code from pci_parent_bus_reset() into its own
> > function.  Export it as we'll later be calling it from hotplug controllers.
> >
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >   drivers/pci/pci.c   |   32 +++++++++++++++++++++++---------
> >   include/linux/pci.h |    1 +
> >   2 files changed, 24 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index b099e00..d0f313f 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -3210,9 +3210,30 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
> >   	return 0;
> >   }
> >
> > -static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
> > +/**
> > + * pci_reset_bridge_secondary_bus - Reset the secondary bus on a PCI bridge.
> > + * @dev: Bridge device
> > + *
> > + * Use the bridge control register to assert reset on the secondary bus.
> > + * Devices on the secondary bus are left in power-on state.
> > + */
> > +void pci_reset_bridge_secondary_bus(struct pci_dev *dev)
> see recommended api change below...
> 
> >   {
> >   	u16 ctrl;
> > +
> > +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&ctrl);
> > +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> > +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
> > +	msleep(100);
> > +
> > +	ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
> > +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
> > +	msleep(100);
> > +}
> > +EXPORT_SYMBOL_GPL(pci_reset_bridge_secondary_bus);
> > +
> > +static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
> > +{
> >   	struct pci_dev *pdev;
> >
> >   	if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
> > @@ -3225,14 +3246,7 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
> >   	if (probe)
> >   		return 0;
> >
> > -	pci_read_config_word(dev->bus->self, PCI_BRIDGE_CONTROL,&ctrl);
> > -	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> > -	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
> > -	msleep(100);
> > -
> > -	ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
> > -	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
> > -	msleep(100);
> > +	pci_reset_bridge_secondary_bus(dev->bus->self);
> >
> It makes more sense to pass the pci-bus struct of the bus you want to reset,
> instead of the pdev of the bridge that bus is sourced by.
> i.e, dev->bus,  and above, extract the pdev from the bus-struct.
> That way, devices asking for bus-reset, don't have to know the bus-struct details
> to make the call right... just their own pdev->bus reference.
> (more object-like/clean).

Have you read patch 7/8 or does this comment take that patch into
account?  For the bus reset and slot reset interfaces the API I'm
proposing does require passing a pci_bus and pci_slot respectively.
Here we have a bridge (pci_dev) and we want to reset the secondary bus
on that bridge and I think the function name indicates that.  Thanks,

Alex

> >   	return 0;
> >   }
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 710067f..695620c 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -905,6 +905,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
> >   int __pci_reset_function(struct pci_dev *dev);
> >   int __pci_reset_function_locked(struct pci_dev *dev);
> >   int pci_reset_function(struct pci_dev *dev);
> > +void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
> and final tweak.
> 
> >   void pci_update_resource(struct pci_dev *dev, int resno);
> >   int __must_check pci_assign_resource(struct pci_dev *dev, int i);
> >   int __must_check pci_reassign_resource(struct pci_dev *dev, int i, resource_size_t add_size, resource_size_t align);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



