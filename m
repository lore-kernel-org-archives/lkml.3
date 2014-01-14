Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaANXjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:39:14 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45568 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaANXjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:39:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131216221229.3393.6171.stgit@bling.home>
References: <20131216221229.3393.6171.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 14 Jan 2014 16:38:50 -0700
Message-ID: <CAErSpo5zmU6qQgrBpbXbJjbQDgAOtJ=KMurDK-P_EcdSFJcLuQ@mail.gmail.com>
Subject: Re: [PATCH] pci: Add "try" reset interfaces
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 3:14 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> When doing a function/slot/bus reset PCI grabs the device_lock for
> each device to block things like suspend and driver probes, which is
> all well and good, but call paths exist where this lock may already be
> held.  This creates an opportunity for deadlock.  For instance, vfio
> allows userspace to issue resets so long as it owns the device(s).
> If a driver unbind .remove callback races with userspace issuing a
> reset, we have a deadlock as userspace gets stuck waiting on
> device_lock while another thread has device_lock and waits for .remove
> to complete.  To resolve this, we can make a version of the reset
> interfaces which use trylock.  With this, we can safely attempt a
> reset and return error to userspace if there is contention.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied to pci/reset for v3.14, thanks!

> ---
>  drivers/pci/pci.c   |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    3 +
>  2 files changed, 158 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 33120d1..de6416f 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3445,6 +3445,18 @@ static void pci_dev_lock(struct pci_dev *dev)
>         device_lock(&dev->dev);
>  }
>
> +/* Return 1 on successful lock, 0 on contention */
> +static int pci_dev_trylock(struct pci_dev *dev)
> +{
> +       if (pci_cfg_access_trylock(dev)) {
> +               if (device_trylock(&dev->dev))
> +                       return 1;
> +               pci_cfg_access_unlock(dev);
> +       }
> +
> +       return 0;
> +}
> +
>  static void pci_dev_unlock(struct pci_dev *dev)
>  {
>         device_unlock(&dev->dev);
> @@ -3588,6 +3600,34 @@ int pci_reset_function(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_reset_function);
>
> +/**
> + * pci_try_reset_function - quiesce and reset a PCI device function
> + * @dev: PCI device to reset
> + *
> + * Same as above, except return -EAGAIN if unable to lock device.
> + */
> +int pci_try_reset_function(struct pci_dev *dev)
> +{
> +       int rc;
> +
> +       rc = pci_dev_reset(dev, 1);
> +       if (rc)
> +               return rc;
> +
> +       pci_dev_save_and_disable(dev);
> +
> +       if (pci_dev_trylock(dev)) {
> +               rc = __pci_dev_reset(dev, 0);
> +               pci_dev_unlock(dev);
> +       } else
> +               rc = -EAGAIN;
> +
> +       pci_dev_restore(dev);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(pci_try_reset_function);
> +
>  /* Lock devices from the top of the tree down */
>  static void pci_bus_lock(struct pci_bus *bus)
>  {
> @@ -3612,6 +3652,32 @@ static void pci_bus_unlock(struct pci_bus *bus)
>         }
>  }
>
> +/* Return 1 on successful lock, 0 on contention */
> +static int pci_bus_trylock(struct pci_bus *bus)
> +{
> +       struct pci_dev *dev;
> +
> +       list_for_each_entry(dev, &bus->devices, bus_list) {
> +               if (!pci_dev_trylock(dev))
> +                       goto unlock;
> +               if (dev->subordinate) {
> +                       if (!pci_bus_trylock(dev->subordinate)) {
> +                               pci_dev_unlock(dev);
> +                               goto unlock;
> +                       }
> +               }
> +       }
> +       return 1;
> +
> +unlock:
> +       list_for_each_entry_continue_reverse(dev, &bus->devices, bus_list) {
> +               if (dev->subordinate)
> +                       pci_bus_unlock(dev->subordinate);
> +               pci_dev_unlock(dev);
> +       }
> +       return 0;
> +}
> +
>  /* Lock devices from the top of the tree down */
>  static void pci_slot_lock(struct pci_slot *slot)
>  {
> @@ -3640,6 +3706,37 @@ static void pci_slot_unlock(struct pci_slot *slot)
>         }
>  }
>
> +/* Return 1 on successful lock, 0 on contention */
> +static int pci_slot_trylock(struct pci_slot *slot)
> +{
> +       struct pci_dev *dev;
> +
> +       list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> +               if (!dev->slot || dev->slot != slot)
> +                       continue;
> +               if (!pci_dev_trylock(dev))
> +                       goto unlock;
> +               if (dev->subordinate) {
> +                       if (!pci_bus_trylock(dev->subordinate)) {
> +                               pci_dev_unlock(dev);
> +                               goto unlock;
> +                       }
> +               }
> +       }
> +       return 1;
> +
> +unlock:
> +       list_for_each_entry_continue_reverse(dev,
> +                                            &slot->bus->devices, bus_list) {
> +               if (!dev->slot || dev->slot != slot)
> +                       continue;
> +               if (dev->subordinate)
> +                       pci_bus_unlock(dev->subordinate);
> +               pci_dev_unlock(dev);
> +       }
> +       return 0;
> +}
> +
>  /* Save and disable devices from the top of the tree down */
>  static void pci_bus_save_and_disable(struct pci_bus *bus)
>  {
> @@ -3763,6 +3860,35 @@ int pci_reset_slot(struct pci_slot *slot)
>  }
>  EXPORT_SYMBOL_GPL(pci_reset_slot);
>
> +/**
> + * pci_try_reset_slot - Try to reset a PCI slot
> + * @slot: PCI slot to reset
> + *
> + * Same as above except return -EAGAIN if the slot cannot be locked
> + */
> +int pci_try_reset_slot(struct pci_slot *slot)
> +{
> +       int rc;
> +
> +       rc = pci_slot_reset(slot, 1);
> +       if (rc)
> +               return rc;
> +
> +       pci_slot_save_and_disable(slot);
> +
> +       if (pci_slot_trylock(slot)) {
> +               might_sleep();
> +               rc = pci_reset_hotplug_slot(slot->hotplug, 0);
> +               pci_slot_unlock(slot);
> +       } else
> +               rc = -EAGAIN;
> +
> +       pci_slot_restore(slot);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(pci_try_reset_slot);
> +
>  static int pci_bus_reset(struct pci_bus *bus, int probe)
>  {
>         if (!bus->self)
> @@ -3822,6 +3948,35 @@ int pci_reset_bus(struct pci_bus *bus)
>  EXPORT_SYMBOL_GPL(pci_reset_bus);
>
>  /**
> + * pci_try_reset_bus - Try to reset a PCI bus
> + * @bus: top level PCI bus to reset
> + *
> + * Same as above except return -EAGAIN if the bus cannot be locked
> + */
> +int pci_try_reset_bus(struct pci_bus *bus)
> +{
> +       int rc;
> +
> +       rc = pci_bus_reset(bus, 1);
> +       if (rc)
> +               return rc;
> +
> +       pci_bus_save_and_disable(bus);
> +
> +       if (pci_bus_trylock(bus)) {
> +               might_sleep();
> +               pci_reset_bridge_secondary_bus(bus->self);
> +               pci_bus_unlock(bus);
> +       } else
> +               rc = -EAGAIN;
> +
> +       pci_bus_restore(bus);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(pci_try_reset_bus);
> +
> +/**
>   * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
>   * @dev: PCI device to query
>   *
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1084a15..34629df 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -951,10 +951,13 @@ int pcie_get_minimum_link(struct pci_dev *dev, enum pci_bus_speed *speed,
>  int __pci_reset_function(struct pci_dev *dev);
>  int __pci_reset_function_locked(struct pci_dev *dev);
>  int pci_reset_function(struct pci_dev *dev);
> +int pci_try_reset_function(struct pci_dev *dev);
>  int pci_probe_reset_slot(struct pci_slot *slot);
>  int pci_reset_slot(struct pci_slot *slot);
> +int pci_try_reset_slot(struct pci_slot *slot);
>  int pci_probe_reset_bus(struct pci_bus *bus);
>  int pci_reset_bus(struct pci_bus *bus);
> +int pci_try_reset_bus(struct pci_bus *bus);
>  void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
>  void pci_update_resource(struct pci_dev *dev, int resno);
>  int __must_check pci_assign_resource(struct pci_dev *dev, int i);
>
