Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbbAHQGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:06:37 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57951 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbAHQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:06:35 -0500
Date: Thu, 8 Jan 2015 16:06:26 +0000
From: Will Deacon <will.deacon@arm.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH v3 3/4] of/pci: add of_pci_dma_configure() update dma
 configuration
Message-ID: <20150108160626.GN11583@arm.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
 <1420656594-8908-4-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420656594-8908-4-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 06:49:53PM +0000, Murali Karicheri wrote:
> Add of_pci_dma_configure() to allow updating the dma configuration
> of the pci device using the configuration from DT of the parent of
> the root bridge device.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/of/of_pci.c    |   39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/of_pci.h |   12 ++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 88471d3..34878c9 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -2,6 +2,7 @@
>  #include <linux/export.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_device.h>
>  #include <linux/of_pci.h>
>  #include <linux/slab.h>
>  
> @@ -229,6 +230,44 @@ parse_failed:
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
> +
> +/**
> + * of_get_pci_root_bridge_parent - get the OF node of the root bridge's parent
> + * @dev: ptr to pci_dev struct of the pci device
> + *
> + * This function will traverse the bus up to the root bus starting with
> + * the child and return the OF node ptr to root bridge device's parent device.
> + */
> +struct device_node *of_get_pci_root_bridge_parent(struct pci_dev *dev)
> +{
> +	struct pci_bus *bus = dev->bus;
> +	struct device *bridge;
> +
> +	while (!pci_is_root_bus(bus))
> +		bus = bus->parent;
> +	bridge = bus->bridge;
> +
> +	return bridge->parent->of_node;
> +}
> +EXPORT_SYMBOL_GPL(of_get_pci_root_bridge_parent);
> +
> +/**
> + * of_pci_dma_configure - Setup DMA configuration
> + * @dev: ptr to pci_dev struct of the pci device
> + *
> + * Function to update PCI devices's DMA configuration using the same
> + * info from the OF node of root host bridge's parent.
> + */
> +void of_pci_dma_configure(struct pci_dev *pci_dev)
> +{
> +	struct device *dev = &pci_dev->dev;
> +	struct device_node *parent_np;
> +
> +	parent_np = of_get_pci_root_bridge_parent(pci_dev);
> +	of_dma_configure(dev, parent_np);
> +}
> +EXPORT_SYMBOL_GPL(of_pci_dma_configure);

Whilst I think this is the right overall structure, I think this function
should determine the set of DMA aliases for the device and pass that through
to the IOMMU (as mentioned in my reply to the cover letter). Then we just
need to work out what we're doing for groups.

Will
