Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3DYUj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:39:56 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49668 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3DYUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <1365806683-26717-28-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org> <1365806683-26717-28-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Apr 2013 14:39:33 -0600
Message-ID: <CAErSpo6W-GtTHe+84XQMfie1K39ChGKmHNYSuru0veXxqxqhAA@mail.gmail.com>
Subject: Re: [PATCH v4 27/29] PCI: Make piix4 quirk to use addon_res
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 4:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> After they are put in add-on resources, they will be safely claimed later.

It took me a while to understand what's going on here, but this is
actually a pretty cool idea.  It would be nice to explain a little
about what the patch is doing and how these "pseudo-BARs" work, though
:)

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/quirks.c | 95 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 79 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 2dac170..6706182 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -382,14 +382,14 @@ static void quirk_ali7101_acpi(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL,     PCI_DEVICE_ID_AL_M7101,         quirk_ali7101_acpi);
>
> -static void piix4_io_quirk(struct pci_dev *dev, const char *name, unsigned int port, unsigned int enable)
> +static int piix4_read_io(struct pci_dev *dev, struct resource *res, int port)

We're reading from "port," which is really the address of a dword in
config space, not a port, so I would have called it "pos" like
__pci_read_base() did.  If I understand correctly, we're reading a
BAR-like register that contains the base address of an I/O port
region.

"piix4_read_io_base(struct pci_dev *dev, struct resource *res, int
pos)" would make more sense to me.

>  {
>         u32 devres;
>         u32 mask, size, base;
> +       struct pci_bus_region bus_region;
>
>         pci_read_config_dword(dev, port, &devres);
> -       if ((devres & enable) != enable)
> -               return;
> +
>         mask = (devres >> 16) & 15;
>         base = devres & 0xffff;
>         size = 16;
> @@ -399,23 +399,54 @@ static void piix4_io_quirk(struct pci_dev *dev, const char *name, unsigned int p
>                         break;
>                 size = bit;
>         }
> -       /*
> -        * For now we only print it out. Eventually we'll want to
> -        * reserve it (at least if it's in the 0x1000+ range), but
> -        * let's get enough confirmation reports first.
> -        */
>         base &= -size;
> -       dev_info(&dev->dev, "%s PIO at %04x-%04x\n", name, base, base + size - 1);
> +
> +       bus_region.start = base;
> +       bus_region.end = base + size - 1;
> +       res->flags |= IORESOURCE_IO;
> +       pcibios_bus_to_resource(dev, res, &bus_region);
> +       dev_info(&dev->dev, "PIO at %pR\n", res);
> +
> +       return 0;
>  }
> +static int piix4_write_io(struct pci_dev *dev, struct resource *res, int port)
> +{
> +       u32 devres;
> +       struct pci_bus_region bus_region;
> +       unsigned size = to_pci_dev_addon_resource(res)->size;
>
> -static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int port, unsigned int enable)
> +       pcibios_resource_to_bus(dev, &bus_region, res);
> +
> +       pci_read_config_dword(dev, port, &devres);
> +       devres &= 0xffff0000 | (size - 1);
> +       devres |= bus_region.start & 0xffff & (~(size - 1));
> +       pci_write_config_dword(dev, port, devres);
> +
> +       return 0;
> +}
> +static struct resource_ops piix4_io_ops = {
> +       .read = piix4_read_io,
> +       .write = piix4_write_io,
> +};
> +static void piix4_io_quirk(struct pci_dev *dev, char *name, unsigned int port,
> +                               unsigned int enable)

I think these (piix4_io_quirk() and piix4_mem_quirk()) would read
better if they were something like:

    piix4_add_io_bar(struct pci_dev *dev, unsigned int pos, u32
enable, char *name);

>  {
>         u32 devres;
> -       u32 mask, size, base;
>
>         pci_read_config_dword(dev, port, &devres);
>         if ((devres & enable) != enable)
>                 return;
> +
> +       pci_add_dev_addon_resource(dev, port, 0, &piix4_io_ops, name);
> +}
> +
> +static int piix4_read_mem(struct pci_dev *dev, struct resource *res, int port)
> +{
> +       u32 devres;
> +       u32 mask, size, base;
> +       struct pci_bus_region bus_region;
> +
> +       pci_read_config_dword(dev, port, &devres);
>         base = devres & 0xffff0000;
>         mask = (devres & 0x3f) << 16;
>         size = 128 << 16;
> @@ -425,12 +456,44 @@ static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int
>                         break;
>                 size = bit;
>         }
> -       /*
> -        * For now we only print it out. Eventually we'll want to
> -        * reserve it, but let's get enough confirmation reports first.
> -        */
>         base &= -size;
> -       dev_info(&dev->dev, "%s MMIO at %04x-%04x\n", name, base, base + size - 1);
> +       bus_region.start = base;
> +       bus_region.end = base + size - 1;
> +       res->flags |= IORESOURCE_MEM;
> +       pcibios_bus_to_resource(dev, res, &bus_region);
> +       dev_info(&dev->dev, "MMIO at %pR\n", res);
> +
> +       return 0;
> +}
> +static int piix4_write_mem(struct pci_dev *dev, struct resource *res, int port)
> +{
> +       u32 devres;
> +       struct pci_bus_region bus_region;
> +       unsigned size = to_pci_dev_addon_resource(res)->size;
> +
> +       pcibios_resource_to_bus(dev, &bus_region, res);
> +
> +       pci_read_config_dword(dev, port, &devres);
> +       devres &= 0x0000ffff | ((size - 1) & 0xffff0000);
> +       devres |= bus_region.start & 0xffff0000 & (~(size - 1));
> +       pci_write_config_dword(dev, port, devres);
> +
> +       return 0;
> +}
> +static struct resource_ops piix4_mem_ops = {
> +       .read = piix4_read_mem,
> +       .write = piix4_write_mem,
> +};
> +static void piix4_mem_quirk(struct pci_dev *dev, char *name, unsigned int port,
> +                               unsigned int enable)
> +{
> +       u32 devres;
> +
> +       pci_read_config_dword(dev, port, &devres);
> +       if ((devres & enable) != enable)
> +               return;
> +
> +       pci_add_dev_addon_resource(dev, port, 0, &piix4_mem_ops, name);
>  }
>
>  /*
> --
> 1.8.1.4
>
