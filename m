Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab3BNXrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:47:53 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48154 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3BNXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:47:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130214183640.16220.33060.stgit@bling.home>
References: <20130214183640.16220.33060.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 14 Feb 2013 16:47:30 -0700
Message-ID: <CAErSpo4uopqKwXY-6HrSZ9mk08tgY9L-iUG2ykmKcMK077tDrQ@mail.gmail.com>
Subject: Re: [PATCH] pci: Disable slot presence detection around bus reset
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sheng Yang <sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:37 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> A bus reset can trigger a presence detection change and result in a
> suprise hotplug.  This is generally not what we want to happen when
> trying to reset a device.  Disable the presence detection control on
> on bridges around bus reset.

This is a really interesting situation, and I'm not quite ready to
sign up to the idea that this is really a problem and that if it is,
this is the way we want to fix it.

What would happen if we *did* handle this as a hotplug event, with a
removal followed by an add?

The scheme where pci_reset_function() does "pci_save_state(dev);
pci_dev_reset(dev); pci_restore_state(dev);" makes me nervous.

We're saving and restoring some of PCI config space around the reset,
but there's no guarantee that we're preserving *all* the important
state in config space because I think devices can have non-architected
device-specific things in config space that we don't know how to
save/restore.

Devices also have internal state not exposed via config space.  That
state is lost during the reset but can't be restored by
pci_restore_state().  So it seems like pci_reset_function() is
pretending to do something it can't really do reliably.

If we make it so a reset is always handled as a remove+add, then we'll
use a more generic path, and we'll get all the stuff you expect when
initializing a new device -- resource assignment, IRQ setup, quirks,
etc.  Quirks in particular seem like something we want, but don't
currently get with pci_reset_function().

Oh, and the "disable presence detect" approach below only works for
things below a PCIe bridge with native hotplug, right?  I wonder what
happens if we reset devices below a bridge using SHPC or acpiphp.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/pci.c |   29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 5cb5820..c1f7d77 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3229,8 +3229,8 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
>
>  static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
>  {
> -       u16 ctrl;
> -       struct pci_dev *pdev;
> +       u16 ctrl, flags, sltctl = 0;
> +       struct pci_dev *pdev, *bridge;
>
>         if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
>                 return -ENOTTY;
> @@ -3242,15 +3242,34 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
>         if (probe)
>                 return 0;
>
> -       pci_read_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, &ctrl);
> +       bridge = dev->bus->self;
> +
> +       /*
> +        * If the parent device supports a slot with presence detection
> +        * change enabled, holding the bus in reset can trigger that and
> +        * cause an unwanted surprise removal.  Disable presence detection
> +        * around the bus reset.
> +        */
> +       pcie_capability_read_word(bridge, PCI_EXP_FLAGS, &flags);
> +       if (flags & PCI_EXP_FLAGS_SLOT) {
> +               pcie_capability_read_word(bridge, PCI_EXP_SLTCTL, &sltctl);
> +               if (sltctl & PCI_EXP_SLTCTL_PDCE)
> +                       pcie_capability_write_word(bridge, PCI_EXP_SLTCTL,
> +                                               sltctl & ~PCI_EXP_SLTCTL_PDCE);
> +       }
> +
> +       pci_read_config_word(bridge, PCI_BRIDGE_CONTROL, &ctrl);
>         ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> -       pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
> +       pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
>         msleep(100);
>
>         ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> -       pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
> +       pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
>         msleep(100);
>
> +       if (sltctl & PCI_EXP_SLTCTL_PDCE)
> +               pcie_capability_write_word(bridge, PCI_EXP_SLTCTL, sltctl);
> +
>         return 0;
>  }
>
>
