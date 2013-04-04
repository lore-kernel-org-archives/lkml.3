Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957Ab3DDVgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:36:09 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54962 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764937Ab3DDVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <1363217302-14383-27-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org> <1363217302-14383-27-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 15:35:44 -0600
Message-ID: <CAErSpo7DhyVwNng=uBR=YMC3ZMFUtV-MDuukjMMGFxMmgHZR=w@mail.gmail.com>
Subject: Re: [PATCH v3 26/27] PCI: Make quirk_io_region to use addon_res
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> After they are put in add-on resources, they will be safely claimed later.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/quirks.c |  155 +++++++++++++++++++++++---------------------------
>  1 file changed, 70 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7e5392c..6d379d6 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -324,29 +324,61 @@ static void quirk_cs5536_vsa(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, quirk_cs5536_vsa);
>
> -static void quirk_io_region(struct pci_dev *dev, unsigned region,
> -       unsigned size, int nr, const char *name)
> +static int quirk_read_io(struct pci_dev *dev, struct resource *res, int port)
>  {
> -       region &= ~(size-1);
> -       if (region) {
> -               struct pci_bus_region bus_region;
> -               struct resource *res = dev->resource + nr;
> +       struct pci_bus_region bus_region;
> +       u16 region;
> +       unsigned size = to_pci_dev_addon_resource(res)->size;
>
> -               res->name = pci_name(dev);
> -               res->start = region;
> -               res->end = region + size - 1;
> -               res->flags = IORESOURCE_IO;
> +       pci_read_config_word(dev, port, &region);
> +       region &= ~(size - 1);
>
> -               /* Convert from PCI bus to resource space.  */
> -               bus_region.start = res->start;
> -               bus_region.end = res->end;
> -               pcibios_bus_to_resource(dev, res, &bus_region);
> +       /* Convert from PCI bus to resource space.  */
> +       bus_region.start = region;
> +       bus_region.end = region + size - 1;
>
> -               if (pci_claim_resource(dev, nr) == 0)
> -                       dev_info(&dev->dev, "quirk: %pR claimed by %s\n",
> -                                res, name);
> -       }
> -}
> +       pcibios_bus_to_resource(dev, res, &bus_region);
> +
> +       res->flags |= IORESOURCE_IO;
> +       dev_info(&dev->dev, "PIO at %pR\n", res);
> +
> +       return 0;
> +}
> +static int quirk_write_io(struct pci_dev *dev, struct resource *res, int port)
> +{
> +       struct pci_bus_region bus_region;
> +       u16 region;
> +       unsigned size = to_pci_dev_addon_resource(res)->size;
> +
> +       pci_read_config_word(dev, port, &region);
> +       region &= size - 1;
> +
> +       /* Convert to PCI bus space.  */
> +       pcibios_resource_to_bus(dev, &bus_region, res);
> +       region |= bus_region.start & (~(size - 1));
> +
> +       pci_write_config_word(dev, port, region);
> +
> +       return 0;
> +}
> +static struct resource_ops quirk_io_ops = {
> +       .read = quirk_read_io,
> +       .write = quirk_write_io,
> +};
> +
> +static void quirk_io_region(struct pci_dev *dev, int port,
> +                                       unsigned size, char *name)
> +{
> +       u16 region;
> +
> +       pci_read_config_word(dev, port, &region);
> +       region &= size - 1;
> +
> +       if (!region)
> +               return;
> +
> +       pci_add_dev_addon_resource(dev, port, size, &quirk_io_ops, name);
> +}
>
>  /*
>   *     ATI Northbridge setups MCE the processor if you even
> @@ -374,12 +406,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS100,   quirk_ati_
>   */
>  static void quirk_ali7101_acpi(struct pci_dev *dev)
>  {
> -       u16 region;
> -
> -       pci_read_config_word(dev, 0xE0, &region);
> -       quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES, "ali7101 ACPI");
> -       pci_read_config_word(dev, 0xE2, &region);
> -       quirk_io_region(dev, region, 32, PCI_BRIDGE_RESOURCES+1, "ali7101 SMB");
> +       quirk_io_region(dev, 0xE0, 64, "ali7101 ACPI");
> +       quirk_io_region(dev, 0xE2, 32, "ali7101 SMB");

This patch has two changes that need to be separated:

  1) Refactoring quirk_io_region() so the pci_read_config_word() is
done by quirk_io_region() rather than the caller.
  2) Whatever pci_dev resource changes we end up making.

I think part 1 can be done at any time and is probably not controversial.

Bjorn
