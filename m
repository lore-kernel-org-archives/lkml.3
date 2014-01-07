Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaAGXp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:45:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbaAGXpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:45:21 -0500
Message-ID: <1389138319.3209.142.camel@bling.home>
Subject: Re: [PATCH] pci: Add "try" reset interfaces
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 07 Jan 2014 16:45:19 -0700
In-Reply-To: <CAErSpo7ZYsES6kZXjcwr-gwKaXm7DzHBvUGz+cpZBBH7stAAAQ@mail.gmail.com>
References: <20131216221229.3393.6171.stgit@bling.home>
	 <CAErSpo7ZYsES6kZXjcwr-gwKaXm7DzHBvUGz+cpZBBH7stAAAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 16:15 -0700, Bjorn Helgaas wrote:
> Hi Alex,
> 
> Sorry for the delay in looking at this.
> 
> On Mon, Dec 16, 2013 at 3:14 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > When doing a function/slot/bus reset PCI grabs the device_lock for
> > each device to block things like suspend and driver probes, which is
> > all well and good, but call paths exist where this lock may already be
> > held.  This creates an opportunity for deadlock.  For instance, vfio
> > allows userspace to issue resets so long as it owns the device(s).
> > If a driver unbind .remove callback races with userspace issuing a
> > reset, we have a deadlock as userspace gets stuck waiting on
> > device_lock while another thread has device_lock and waits for .remove
> > to complete.
> 
> Are you talking about vfio_pci_remove() (the vfio_pci_driver .remove()
> method) racing with vfio_pci_ioctl()?

Yes, for instance if the admin does something like attempt to unbind the
device from vfio-pci while it's in use.  This can also happen indirectly
if the device is going away, such as a PF driver attempting to remove
its VFs.

> Or maybe it's vfio_pci_release (the vfio_pci_ops .release() method),
> since it looks like you want to use pci_try_reset_function() there and
> in vfio_pci_ioctl()?

That one too.  If any reset races with pci_driver.remove, whether it be
from ioctl or my own release callback, we'll hit a deadlock.

> Either way, aren't there at least potentially more locking issues than
> just the reset problem?  Seems like any ioctl that might take the
> device_lock could have the same problem.

I don't know of any others, but our QE folks hit this one pretty
regularly.  It can all be explained away as user error, but a user
should not be able to cause a kernel deadlock, which is why the user
exposed interfaces are converted to use this try-lock interface.

>   How do you make sure there's
> no userspace owner of the device before you release the device or
> remove the driver?

Userspace has a file descriptor for the device, so we know through
reference counting when the device becomes unused.  When our
pci_driver.remove() callback happens we block until the user releases
the device, so perhaps it more accurate to describe it as a nested lock
problem than a race, but the paths are asynchronous so even if we tested
the lock in advance there's a potential race.

If you have better ideas how to solve this, let me know.  Thanks,

Alex

> > To resolve this, we can make a version of the reset
> > interfaces which use trylock.  With this, we can safely attempt a
> > reset and return error to userspace if there is contention.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/pci.c   |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/pci.h |    3 +
> >  2 files changed, 158 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 33120d1..de6416f 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -3445,6 +3445,18 @@ static void pci_dev_lock(struct pci_dev *dev)
> >         device_lock(&dev->dev);
> >  }
> >
> > +/* Return 1 on successful lock, 0 on contention */
> > +static int pci_dev_trylock(struct pci_dev *dev)
> > +{
> > +       if (pci_cfg_access_trylock(dev)) {
> > +               if (device_trylock(&dev->dev))
> > +                       return 1;
> > +               pci_cfg_access_unlock(dev);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  static void pci_dev_unlock(struct pci_dev *dev)
> >  {
> >         device_unlock(&dev->dev);
> > @@ -3588,6 +3600,34 @@ int pci_reset_function(struct pci_dev *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_reset_function);
> >
> > +/**
> > + * pci_try_reset_function - quiesce and reset a PCI device function
> > + * @dev: PCI device to reset
> > + *
> > + * Same as above, except return -EAGAIN if unable to lock device.
> > + */
> > +int pci_try_reset_function(struct pci_dev *dev)
> > +{
> > +       int rc;
> > +
> > +       rc = pci_dev_reset(dev, 1);
> > +       if (rc)
> > +               return rc;
> > +
> > +       pci_dev_save_and_disable(dev);
> > +
> > +       if (pci_dev_trylock(dev)) {
> > +               rc = __pci_dev_reset(dev, 0);
> > +               pci_dev_unlock(dev);
> > +       } else
> > +               rc = -EAGAIN;
> > +
> > +       pci_dev_restore(dev);
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_try_reset_function);
> > +
> >  /* Lock devices from the top of the tree down */
> >  static void pci_bus_lock(struct pci_bus *bus)
> >  {
> > @@ -3612,6 +3652,32 @@ static void pci_bus_unlock(struct pci_bus *bus)
> >         }
> >  }
> >
> > +/* Return 1 on successful lock, 0 on contention */
> > +static int pci_bus_trylock(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               if (!pci_dev_trylock(dev))
> > +                       goto unlock;
> > +               if (dev->subordinate) {
> > +                       if (!pci_bus_trylock(dev->subordinate)) {
> > +                               pci_dev_unlock(dev);
> > +                               goto unlock;
> > +                       }
> > +               }
> > +       }
> > +       return 1;
> > +
> > +unlock:
> > +       list_for_each_entry_continue_reverse(dev, &bus->devices, bus_list) {
> > +               if (dev->subordinate)
> > +                       pci_bus_unlock(dev->subordinate);
> > +               pci_dev_unlock(dev);
> > +       }
> > +       return 0;
> > +}
> > +
> >  /* Lock devices from the top of the tree down */
> >  static void pci_slot_lock(struct pci_slot *slot)
> >  {
> > @@ -3640,6 +3706,37 @@ static void pci_slot_unlock(struct pci_slot *slot)
> >         }
> >  }
> >
> > +/* Return 1 on successful lock, 0 on contention */
> > +static int pci_slot_trylock(struct pci_slot *slot)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               if (!pci_dev_trylock(dev))
> > +                       goto unlock;
> > +               if (dev->subordinate) {
> > +                       if (!pci_bus_trylock(dev->subordinate)) {
> > +                               pci_dev_unlock(dev);
> > +                               goto unlock;
> > +                       }
> > +               }
> > +       }
> > +       return 1;
> > +
> > +unlock:
> > +       list_for_each_entry_continue_reverse(dev,
> > +                                            &slot->bus->devices, bus_list) {
> > +               if (!dev->slot || dev->slot != slot)
> > +                       continue;
> > +               if (dev->subordinate)
> > +                       pci_bus_unlock(dev->subordinate);
> > +               pci_dev_unlock(dev);
> > +       }
> > +       return 0;
> > +}
> > +
> >  /* Save and disable devices from the top of the tree down */
> >  static void pci_bus_save_and_disable(struct pci_bus *bus)
> >  {
> > @@ -3763,6 +3860,35 @@ int pci_reset_slot(struct pci_slot *slot)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_reset_slot);
> >
> > +/**
> > + * pci_try_reset_slot - Try to reset a PCI slot
> > + * @slot: PCI slot to reset
> > + *
> > + * Same as above except return -EAGAIN if the slot cannot be locked
> > + */
> > +int pci_try_reset_slot(struct pci_slot *slot)
> > +{
> > +       int rc;
> > +
> > +       rc = pci_slot_reset(slot, 1);
> > +       if (rc)
> > +               return rc;
> > +
> > +       pci_slot_save_and_disable(slot);
> > +
> > +       if (pci_slot_trylock(slot)) {
> > +               might_sleep();
> > +               rc = pci_reset_hotplug_slot(slot->hotplug, 0);
> > +               pci_slot_unlock(slot);
> > +       } else
> > +               rc = -EAGAIN;
> > +
> > +       pci_slot_restore(slot);
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_try_reset_slot);
> > +
> >  static int pci_bus_reset(struct pci_bus *bus, int probe)
> >  {
> >         if (!bus->self)
> > @@ -3822,6 +3948,35 @@ int pci_reset_bus(struct pci_bus *bus)
> >  EXPORT_SYMBOL_GPL(pci_reset_bus);
> >
> >  /**
> > + * pci_try_reset_bus - Try to reset a PCI bus
> > + * @bus: top level PCI bus to reset
> > + *
> > + * Same as above except return -EAGAIN if the bus cannot be locked
> > + */
> > +int pci_try_reset_bus(struct pci_bus *bus)
> > +{
> > +       int rc;
> > +
> > +       rc = pci_bus_reset(bus, 1);
> > +       if (rc)
> > +               return rc;
> > +
> > +       pci_bus_save_and_disable(bus);
> > +
> > +       if (pci_bus_trylock(bus)) {
> > +               might_sleep();
> > +               pci_reset_bridge_secondary_bus(bus->self);
> > +               pci_bus_unlock(bus);
> > +       } else
> > +               rc = -EAGAIN;
> > +
> > +       pci_bus_restore(bus);
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_try_reset_bus);
> > +
> > +/**
> >   * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
> >   * @dev: PCI device to query
> >   *
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 1084a15..34629df 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -951,10 +951,13 @@ int pcie_get_minimum_link(struct pci_dev *dev, enum pci_bus_speed *speed,
> >  int __pci_reset_function(struct pci_dev *dev);
> >  int __pci_reset_function_locked(struct pci_dev *dev);
> >  int pci_reset_function(struct pci_dev *dev);
> > +int pci_try_reset_function(struct pci_dev *dev);
> >  int pci_probe_reset_slot(struct pci_slot *slot);
> >  int pci_reset_slot(struct pci_slot *slot);
> > +int pci_try_reset_slot(struct pci_slot *slot);
> >  int pci_probe_reset_bus(struct pci_bus *bus);
> >  int pci_reset_bus(struct pci_bus *bus);
> > +int pci_try_reset_bus(struct pci_bus *bus);
> >  void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
> >  void pci_update_resource(struct pci_dev *dev, int resno);
> >  int __must_check pci_assign_resource(struct pci_dev *dev, int i);
> >



