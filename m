Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaKLR3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:29:34 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37468 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaKLR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:29:33 -0500
MIME-Version: 1.0
In-Reply-To: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Nov 2014 10:29:11 -0700
Message-ID: <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
To: Michael Jamet <michael.jamet@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        amir.jer.levy@intel.com, dan.alloun@intel.com,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, Andreas]

On Wed, Nov 12, 2014 at 7:52 PM, Michael Jamet <michael.jamet@intel.com> wrote:
> Every Thunderbolt-based devices or Thunderbolt-connected
> devices should not allocate PCI I/O resources
> per Thunderbolt specs.

Please include a pointer to those specs in the changelog.

> On a Thunderbolt PC, BIOS is responsible to allocate IO
> resources. Kernel shouldn't allocate the PCI I/O resources
> as it interferes with BIOS operation.
> Doing this may cause the devices in the Thunderbolt chain
> not being detected or added, or worse to stuck the
> Thunderbolt Host controller.

These new kernel/firmware coordination requirements need to be
documented.  If they're already part of a PCIe ECN or PCI firmware
spec, just provide a pointer.

> To prevent this, we detect a chain contains a Thunderbolt
> device by checking the Thunderbolt PCI device id.

I'm really not happy about checking a list of device IDs to identify
Thunderbolt devices.  Surely there's a better way, because a list like
this has to be updated regularly.

Bjorn

> The validation is carried out at the pci_enable_device_flags()
> function that checks the PCI device or bridge is Thunderbolt
> chained and avoid IO resources allocation.
>
> In addition, decode_bar() and pci_bridge_check_ranges()
> function has been internally checked for Thunderbolt
> as well to ensure no IO resources are allocated.
>
> Signed-off-by: Michael Jamet <michael.jamet@intel.com>
> ---
>  drivers/pci/pci.c       | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h       |  2 ++
>  drivers/pci/probe.c     |  3 ++-
>  drivers/pci/setup-bus.c |  4 ++--
>  include/linux/pci.h     |  2 ++
>  5 files changed, 72 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 625a4ac..41c2619 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -198,6 +198,62 @@ static int __pci_bus_find_cap_start(struct pci_bus *bus,
>  }
>
>  /**
> + * pci_is_thunderbolt_device - checks PCI device is Thunderbolt-based.
> + * The only existing way is to check the device id is allocated to Thunderbolt.
> + * @dev: the PCI device structure to check against
> + *
> + * Returns true if the PCI device is of the Thunderbolt type.
> + */
> +bool pci_is_thunderbolt_device(struct pci_dev *dev)
> +{
> +       if ((dev->vendor == PCI_VENDOR_ID_INTEL) &&
> +                       ((dev->device == 0xcaca)
> +                       || (dev->device == 0x1513)
> +                       || (dev->device == 0xcbca)
> +                       || (dev->device == 0x151A)
> +                       || (dev->device == 0x151B)
> +                       || (dev->device == 0x1549)
> +                       || (dev->device == 0x1547)
> +                       || (dev->device == 0x1548)
> +                       || (dev->device == 0x1566)
> +                       || (dev->device == 0x1567)
> +                       || (dev->device == 0x1569)
> +                       || (dev->device == 0x1568)
> +                       || (dev->device == 0x156A)
> +                       || (dev->device == 0x156B)
> +                       || (dev->device == 0x156C)
> +                       || (dev->device == 0x156D)
> +                       || (dev->device == 0x1579)
> +                       || (dev->device == 0x157A)
> +                       || (dev->device == 0x157D)
> +                       || (dev->device == 0x157E)))
> +               return true;
> +
> +       return false;
> +}
> +EXPORT_SYMBOL(pci_is_thunderbolt_device);
> +
> +/**
> + * pci_is_connected_to_thunderbolt - check if connected to a Thunderbolt chain.
> + * @dev: the PCI device structure to check against
> + *
> + * Returns true if the PCI device s connected is connected to a
> + * Thunderbolt-based in the chain.
> + */
> +bool pci_is_connected_to_thunderbolt(struct pci_dev *dev)
> +{
> +       struct pci_dev *bridge;
> +
> +       if (pci_is_thunderbolt_device(dev))
> +               return true;
> +       bridge =  pci_upstream_bridge(dev);
> +       if (bridge)
> +               return pci_is_connected_to_thunderbolt(bridge);
> +       return false;
> +}
> +EXPORT_SYMBOL(pci_is_connected_to_thunderbolt);
> +
> +/**
>   * pci_find_capability - query for devices' capabilities
>   * @dev: PCI device to query
>   * @cap: capability code
> @@ -1285,6 +1341,14 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
>         if (atomic_inc_return(&dev->enable_cnt) > 1)
>                 return 0;               /* already enabled */
>
> +       /*
> +        * if IO resource have been requested, but the device is connected
> +        * to Thunderbolt chain, don't allocate IO resource
> +        */
> +       if ((flags & IORESOURCE_IO)
> +                       && pci_is_connected_to_thunderbolt(dev))
> +               flags &= ~IORESOURCE_IO;
> +
>         bridge = pci_upstream_bridge(dev);
>         if (bridge)
>                 pci_enable_bridge(bridge);
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 0601890..fb9a3b1 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -4,6 +4,8 @@
>  #define PCI_CFG_SPACE_SIZE     256
>  #define PCI_CFG_SPACE_EXP_SIZE 4096
>
> +bool pci_is_thunderbolt_device(struct pci_dev *dev);
> +
>  extern const unsigned char pcie_link_speed[];
>
>  /* Functions internal to the PCI core code */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 5ed9930..d8171af 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -131,7 +131,8 @@ static inline unsigned long decode_bar(struct pci_dev *dev, u32 bar)
>
>         if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
>                 flags = bar & ~PCI_BASE_ADDRESS_IO_MASK;
> -               flags |= IORESOURCE_IO;
> +               if (!pci_is_connected_to_thunderbolt(dev))
> +                       flags |= IORESOURCE_IO;
>                 return flags;
>         }
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 0482235..79ac38f 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -663,12 +663,12 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
>         b_res[1].flags |= IORESOURCE_MEM;
>
>         pci_read_config_word(bridge, PCI_IO_BASE, &io);
> -       if (!io) {
> +       if (!io || pci_is_thunderbolt_device(bridge)) {
>                 pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
>                 pci_read_config_word(bridge, PCI_IO_BASE, &io);
>                 pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
>         }
> -       if (io)
> +       if (io && !pci_is_thunderbolt_device(bridge))
>                 b_res[0].flags |= IORESOURCE_IO;
>
>         /*  DECchip 21050 pass 2 errata: the bridge may miss an address
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2a8c405..09ddc2c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -931,6 +931,8 @@ int __must_check pci_enable_device_io(struct pci_dev *dev);
>  int __must_check pci_enable_device_mem(struct pci_dev *dev);
>  int __must_check pci_reenable_device(struct pci_dev *);
>  int __must_check pcim_enable_device(struct pci_dev *pdev);
> +
> +bool pci_is_connected_to_thunderbolt(struct pci_dev *dev);
>  void pcim_pin_device(struct pci_dev *pdev);
>
>  static inline int pci_is_enabled(struct pci_dev *pdev)
> --
> 1.9.1
>
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
