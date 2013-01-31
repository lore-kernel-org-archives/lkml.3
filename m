Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3AaAYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:24:42 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35136 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3AaAYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130118113742.GA9006@arm.com>
References: <20130118113742.GA9006@arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 Jan 2013 17:24:14 -0700
Message-ID: <CAErSpo7Oyx41Qy80YcZNpSe7CatzLZ4Lai0--YRGJ0NZ1zQTRA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] Implementation of pci_fixup_irqs for descendants
 of a specified bus
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 4:37 AM, Andrew Murray <Andrew.Murray@arm.com> wrote:
> Continuing from discussion with Thierry (lkml.org/lkml/2013/1/18/107) perhaps
> this will be useful to fold into your patchset.
> ---
> This patch provides pci_bus_fixup_irqs which performs the same
> function as pci_fixup_irqs but only to descendants of the specified
> bus.

I think pci_fixup_irqs() is a broken design to begin with because it
is only called once at boot-time and it iterates over all the devices
we've found so far.  Any hot-added devices never get the fixups.

Adding pci_bus_fixup_irqs() addresses part of that, by adding a way to
fixup a subset of devices, e.g., maybe it could be done for hot-added
things.

But I think it would be better to do a more extensive refactoring and
do the IRQ fixups directly somewhere in the pci_device_add() path.
That way we can do it a device at a time, for every device (present at
boot and hot-added later), and before any drivers claim the device.

> This can reduce unnecessary fixing up of device irqs when new buses
> are added.
>
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/pci/setup-irq.c |   15 +++++++++++++++
>  include/linux/pci.h     |    3 +++
>  2 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
> index eb219a1..ea91874 100644
> --- a/drivers/pci/setup-irq.c
> +++ b/drivers/pci/setup-irq.c
> @@ -62,3 +62,18 @@ pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
>         for_each_pci_dev(dev)
>                 pdev_fixup_irq(dev, swizzle, map_irq);
>  }
> +
> +void __init
> +pci_bus_fixup_irqs(struct pci_bus *bus,
> +               u8 (*swizzle)(struct pci_dev *, u8 *),
> +               int (*map_irq)(const struct pci_dev *, u8, u8))
> +{
> +       struct pci_dev *dev;
> +
> +       list_for_each_entry(dev, &bus->devices, bus_list) {
> +               pdev_fixup_irq(dev, swizzle, map_irq);
> +
> +               if (dev->subordinate)
> +                       pci_bus_fixup_irqs(dev->subordinate, swizzle, map_irq);
> +       }
> +}
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5faa831..1b3c2eb 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -953,6 +953,9 @@ void pdev_enable_device(struct pci_dev *);
>  int pci_enable_resources(struct pci_dev *, int mask);
>  void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
>                     int (*)(const struct pci_dev *, u8, u8));
> +void pci_bus_fixup_irqs(struct pci_bus *bus,
> +               u8 (*swizzle)(struct pci_dev *, u8 *),
> +               int (*map_irq)(const struct pci_dev *, u8, u8));
>  #define HAVE_PCI_REQ_REGIONS   2
>  int __must_check pci_request_regions(struct pci_dev *, const char *);
>  int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
> --
> 1.7.0.4
>
>
