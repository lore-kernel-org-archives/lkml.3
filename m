Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3HVVec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:34:32 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33701 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab3HVVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130819195917.9062.43580.stgit@bling.home>
References: <20130819195917.9062.43580.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 Aug 2013 15:34:09 -0600
Message-ID: <CAErSpo5gUwm1nqME30DiUPOwhGfOttzjcvbtj-4aqSz4sLAcAg@mail.gmail.com>
Subject: Re: [PATCH] pci: Add pci_walk_slot() interface
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 2:04 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> We have a pci_walk_bus() interface, but it's exceptionally cumbersome
> for the callback function to figure out if the device is relevant if
> the caller is trying to walk all the devices in or below a slot.  Add
> a variant to walk only slot devices.

Is it really exceptionally cumbersome?  You can supply the top-level
slot in the userdata.  Can you then use something like this in the
callback?

    bool dev_below_slot(struct pci_dev *dev, struct pci_slot *slot)
    {
        if (!dev)
            return false;
        if (dev->slot == slot)
            return true;
        return dev_below_slot(dev->bus->self, slot);
    }

Bjorn

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> This allows me to use pci_walk_bus() and pci_walk_slot() instead of
> rolling my own for iterating devices for bus/slot reset.  Please
> consider for 3.12 to go with the rest of the bus/slot infrastructure.
>
>  drivers/pci/bus.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    2 ++
>  2 files changed, 58 insertions(+)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index b1ff02a..316579a 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -283,6 +283,62 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>  }
>  EXPORT_SYMBOL_GPL(pci_walk_bus);
>
> +/** pci_walk_slot - walk devices in/under slot, calling callback.
> + *  @slot     slot whose devices should be walked
> + *  @cb       callback to be called for each device found
> + *  @userdata arbitrary pointer to be passed to callback.
> + *
> + *  Walk the given slot, including any bridged devices
> + *  on buses under this slot.  Call the provided callback
> + *  on each device found.
> + *
> + *  We check the return of @cb each time. If it returns anything
> + *  other than 0, we break out.
> + *
> + */
> +void pci_walk_slot(struct pci_slot *slot, int (*cb)(struct pci_dev *, void *),
> +                  void *userdata)
> +{
> +       struct pci_dev *dev;
> +       struct pci_bus *bus;
> +       struct list_head *next;
> +       int retval;
> +
> +       bus = slot->bus;
> +       down_read(&pci_bus_sem);
> +       next = slot->bus->devices.next;
> +       for (;;) {
> +               if (next == &bus->devices) {
> +                       /* end of this bus, go up or finish */
> +                       if (bus == slot->bus)
> +                               break;
> +                       next = bus->self->bus_list.next;
> +                       bus = bus->self->bus;
> +                       continue;
> +               }
> +               dev = list_entry(next, struct pci_dev, bus_list);
> +
> +               /* skip anything on the top level bus not in our slot */
> +               if (dev->bus == slot->bus && dev->slot != slot) {
> +                       next = dev->bus_list.next;
> +                       continue;
> +               }
> +
> +               if (dev->subordinate) {
> +                       /* this is a pci-pci bridge, do its devices next */
> +                       next = dev->subordinate->devices.next;
> +                       bus = dev->subordinate;
> +               } else
> +                       next = dev->bus_list.next;
> +
> +               retval = cb(dev, userdata);
> +               if (retval)
> +                       break;
> +       }
> +       up_read(&pci_bus_sem);
> +}
> +EXPORT_SYMBOL_GPL(pci_walk_slot);
> +
>  struct pci_bus *pci_bus_get(struct pci_bus *bus)
>  {
>         if (bus)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index daf40cd..cbb291b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1087,6 +1087,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
>
>  void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>                   void *userdata);
> +void pci_walk_slot(struct pci_slot *slot, int (*cb)(struct pci_dev *, void *),
> +                 void *userdata);
>  int pci_cfg_space_size_ext(struct pci_dev *dev);
>  int pci_cfg_space_size(struct pci_dev *dev);
>  unsigned char pci_bus_max_busnr(struct pci_bus *bus);
>
