Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab3HNWAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081Ab3HNWAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:00:23 -0400
Message-ID: <1376517604.13642.42.camel@ul30vt.home>
Subject: Re: [PATCH v5 6/9] pci: Add slot and bus reset interfaces
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        Don Dutile <ddutile@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Aug 2013 16:00:04 -0600
In-Reply-To: <CAErSpo5DrPB4L8FrK=amZe2nt6=oSntGG_AxugrQ4msa+fziOg@mail.gmail.com>
References: <20130808200444.2932.17381.stgit@bling.home>
	 <20130808200955.2932.30491.stgit@bling.home>
	 <CAErSpo5DrPB4L8FrK=amZe2nt6=oSntGG_AxugrQ4msa+fziOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 15:24 -0600, Bjorn Helgaas wrote:
> On Thu, Aug 8, 2013 at 2:09 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Sometimes pci_reset_function is not sufficient.  We have cases where
> > devices do not support any kind of reset, but there might be multiple
> > functions on the bus preventing pci_reset_function from doing a
> > secondary bus reset.  We also have cases where a device will advertise
> > that it supports a PM reset, but really does nothing on D3hot->D0
> > (graphics cards are notorious for this).  These devices often also
> > have more than one function, so even blacklisting PM reset for them
> > wouldn't allow a secondary bus reset through pci_reset_function.
> >
> > If a driver supports multiple devices it should have the ability to
> > induce a bus reset when it needs to.  This patch provides that ability
> > through pci_reset_slot and pci_reset_bus.  It's the caller's
> > responsibility when using these interfaces to understand that all of
> > the devices in or below the slot (or on or below the bus) will be
> > reset and therefore should be under control of the caller.
> 
> How does the caller check or ensure this?  If there's a bridge
> involved, I'm not sure the caller *can* ensure this, because the
> caller can't hold pci_bus_sem or whatever we use to protect hotplug
> changes.

I'm not sure how effectively we can combat every hotplug race given our
current infrastructure.  However, in the case of vfio, ownership is
based on iommu groups.  If all of the devices in the group are bound to
vfio drivers and the user can open the group and setup iommu protection,
then they have ownership of all those devices.  It's then a matter of
figuring out what iommu groups are affected by a bus/slot reset and
making the user prove that they own all the necessary vfio groups to
cover the full set of affected devices.  The vfio-pci patch cc'd to the
list does this.  A hotplug while we're walking bus->devices_list would
be bad, but I do try to build in protection against the list changing
between ioctls and where we can between each step in the ioctl.  Thanks,

Alex

> > PCI state
> > of all the affected devices is saved and restored around these resets,
> > but internal state of all of the affected devices is reset (which
> > should be the intention).
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/pci.c   |  209 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/pci.h |    2
> >  2 files changed, 211 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 4a0275c..1dba7dd 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -3460,6 +3460,215 @@ int pci_reset_function(struct pci_dev *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_reset_function);
> >
> > +/* Lock devices from the top of the tree down */
> > +static void pci_bus_lock(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               pci_dev_lock(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_lock(dev->subordinate);
> > +       }
> > +}
> > +
> > +/* Unlock devices from the bottom of the tree up */
> > +static void pci_bus_unlock(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               if (dev->subordinate)
> > +                       pci_bus_unlock(dev->subordinate);
> > +               pci_dev_unlock(dev);
> > +       }
> > +}
> > +
> > +/* Lock devices from the top of the tree down */
> > +static void pci_slot_lock(struct pci_slot *slot)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               pci_dev_lock(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_lock(dev->subordinate);
> > +       }
> > +}
> > +
> > +/* Unlock devices from the bottom of the tree up */
> > +static void pci_slot_unlock(struct pci_slot *slot)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               if (dev->subordinate)
> > +                       pci_bus_unlock(dev->subordinate);
> > +               pci_dev_unlock(dev);
> > +       }
> > +}
> > +
> > +/* Save and disable devices from the top of the tree down */
> > +static void pci_bus_save_and_disable(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               pci_dev_save_and_disable(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_save_and_disable(dev->subordinate);
> > +       }
> > +}
> > +
> > +/*
> > + * Restore devices from top of the tree down - parent bridges need to be
> > + * restored before we can get to subordinate devices.
> > + */
> > +static void pci_bus_restore(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               pci_dev_restore(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_restore(dev->subordinate);
> > +       }
> > +}
> > +
> > +/* Save and disable devices from the top of the tree down */
> > +static void pci_slot_save_and_disable(struct pci_slot *slot)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               pci_dev_save_and_disable(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_save_and_disable(dev->subordinate);
> > +       }
> > +}
> > +
> > +/*
> > + * Restore devices from top of the tree down - parent bridges need to be
> > + * restored before we can get to subordinate devices.
> > + */
> > +static void pci_slot_restore(struct pci_slot *slot)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               pci_dev_restore(dev);
> > +               if (dev->subordinate)
> > +                       pci_bus_restore(dev->subordinate);
> > +       }
> > +}
> > +
> > +static int pci_slot_reset(struct pci_slot *slot, int probe)
> > +{
> > +       int rc;
> > +
> > +       if (!slot)
> > +               return -ENOTTY;
> > +
> > +       if (!probe)
> > +               pci_slot_lock(slot);
> > +
> > +       might_sleep();
> > +
> > +       rc = pci_reset_hotplug_slot(slot->hotplug, probe);
> > +
> > +       if (!probe)
> > +               pci_slot_unlock(slot);
> > +
> > +       return rc;
> > +}
> > +
> > +/**
> > + * pci_reset_slot - reset a PCI slot
> > + * @slot: PCI slot to reset
> > + *
> > + * A PCI bus may host multiple slots, each slot may support a reset mechanism
> > + * independent of other slots.  For instance, some slots may support slot power
> > + * control.  In the case of a 1:1 bus to slot architecture, this function may
> > + * wrap the bus reset to avoid spurious slot related events such as hotplug.
> > + * Generally a slot reset should be attempted before a bus reset.  All of the
> > + * function of the slot and any subordinate buses behind the slot are reset
> > + * through this function.  PCI config space of all devices in the slot and
> > + * behind the slot is saved before and restored after reset.
> > + *
> > + * Return 0 on success, non-zero on error.
> > + */
> > +int pci_reset_slot(struct pci_slot *slot)
> > +{
> > +       int rc;
> > +
> > +       rc = pci_slot_reset(slot, 1);
> > +       if (rc)
> > +               return rc;
> > +
> > +       pci_slot_save_and_disable(slot);
> > +
> > +       rc = pci_slot_reset(slot, 0);
> > +
> > +       pci_slot_restore(slot);
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_reset_slot);
> > +
> > +static int pci_bus_reset(struct pci_bus *bus, int probe)
> > +{
> > +       if (!bus->self)
> > +               return -ENOTTY;
> > +
> > +       if (probe)
> > +               return 0;
> > +
> > +       pci_bus_lock(bus);
> > +
> > +       might_sleep();
> > +
> > +       pci_reset_bridge_secondary_bus(bus->self);
> > +
> > +       pci_bus_unlock(bus);
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * pci_reset_bus - reset a PCI bus
> > + * @bus: top level PCI bus to reset
> > + *
> > + * Do a bus reset on the given bus and any subordinate buses, saving
> > + * and restoring state of all devices.
> > + *
> > + * Return 0 on success, non-zero on error.
> > + */
> > +int pci_reset_bus(struct pci_bus *bus)
> > +{
> > +       int rc;
> > +
> > +       rc = pci_bus_reset(bus, 1);
> > +       if (rc)
> > +               return rc;
> > +
> > +       pci_bus_save_and_disable(bus);
> > +
> > +       rc = pci_bus_reset(bus, 0);
> > +
> > +       pci_bus_restore(bus);
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_reset_bus);
> > +
> >  /**
> >   * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
> >   * @dev: PCI device to query
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 35c1bc4..1a8fd34 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -924,6 +924,8 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
> >  int __pci_reset_function(struct pci_dev *dev);
> >  int __pci_reset_function_locked(struct pci_dev *dev);
> >  int pci_reset_function(struct pci_dev *dev);
> > +int pci_reset_slot(struct pci_slot *slot);
> > +int pci_reset_bus(struct pci_bus *bus);
> >  void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
> >  void pci_update_resource(struct pci_dev *dev, int resno);
> >  int __must_check pci_assign_resource(struct pci_dev *dev, int i);
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



