Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaLZTds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:33:48 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61378 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaLZTdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:33:45 -0500
MIME-Version: 1.0
In-Reply-To: <1419459099-6667-2-git-send-email-m-karicheri2@ti.com>
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <1419459099-6667-2-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Dec 2014 13:33:23 -0600
Message-ID: <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma configuration
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 4:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Add of_pci_dma_configure() to allow updating the dma configuration
> of the pci device using the configuration from DT of the parent of
> the root bridge device.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/of/of_pci.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_pci.h |   12 ++++++++
>  2 files changed, 85 insertions(+)
>
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 88471d3..6d43f59 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -229,6 +229,79 @@ parse_failed:
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
> +
> +/**
> + * of_get_pci_root_bridge_parent - Helper function to get the OF node of
> + *             the root bridge's parent

I believe this has to be a one line description for DocBook.

> + * @dev: ptr to pci_dev struct of the pci device
> + *
> + * This function will traverse the bus up to the root bus starting with
> + * the child and return the of node ptr to bridge device's parent device.
> + */
> +struct device_node *of_get_pci_root_bridge_parent(struct pci_dev *dev)
> +{
> +       struct pci_bus *bus = dev->bus;
> +       struct device *bridge;
> +
> +       while (!pci_is_root_bus(bus))
> +               bus = bus->parent;
> +       bridge = bus->bridge;
> +
> +       return bridge->parent->of_node;
> +}
> +EXPORT_SYMBOL_GPL(of_get_pci_root_bridge_parent);
> +
> +/**
> + * of_pci_dma_configure - Setup DMA configuration
> + * @dev: ptr to pci_dev struct of the pci device
> + *
> + * Try to get PCI devices's DMA configuration from DT and update it
> + * accordingly. This is similar to of_dma_configure() in of/platform.c
> + */
> +void of_pci_dma_configure(struct pci_dev *pci_dev)
> +{
> +       struct device *dev = &pci_dev->dev;
> +       u64 dma_addr, paddr, size;
> +       struct device_node *parent_np;
> +       unsigned long offset;
> +       bool coherent;
> +       int ret;
> +
> +       parent_np = of_get_pci_root_bridge_parent(pci_dev);
> +
> +       if (parent_np) {

Save a level of indentation and do:

if (!parent_np)
  return;

> +               /*
> +                * Set default dma-mask to 32 bit. Drivers are expected to setup
> +                * the correct supported dma_mask.
> +                */
> +               dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +
> +               /*
> +                * Set it to coherent_dma_mask by default if the architecture
> +                * code has not set it.
> +                */
> +               if (!dev->dma_mask)
> +                       dev->dma_mask = &dev->coherent_dma_mask;
> +
> +               ret = of_dma_get_range(parent_np, &dma_addr, &paddr, &size);
> +               if (ret < 0) {
> +                       dma_addr = offset = 0;
> +                       size = dev->coherent_dma_mask + 1;
> +               } else {
> +                       offset = PFN_DOWN(paddr - dma_addr);
> +                       dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
> +               }
> +               dev->dma_pfn_offset = offset;
> +
> +               coherent = of_dma_is_coherent(parent_np);
> +               dev_dbg(dev, "device is%sdma coherent\n",
> +                       coherent ? " " : " not ");
> +
> +               arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);

This is the same code as of_dma_configure. The only difference I see
is which node ptr is passed to of_dma_get_range. You need to make that
a function param of of_dma_configure.

of_dma_configure also has iommu handling now. You will probably need
something similar for PCI in that you setup an iommu based on the root
bus DT properties.

Rob
