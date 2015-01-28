Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbbA1Ctt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:49:49 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33731 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbbA1Ctr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <1422392405-32196-6-git-send-email-m-karicheri2@ti.com>
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com> <1422392405-32196-6-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 27 Jan 2015 20:49:25 -0600
Message-ID: <CAL_JsqL_SBezH92nJ_xHg5o1ZfH8uC_wne72CQr6yCP+ByuiXQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] of/pci: add of_pci_dma_configure() update dma configuration
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 3:00 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Add of_pci_dma_configure() to allow updating the dma configuration
> of the pci device using the configuration from DT of the parent of
> the root bridge device. Use the newly added APIs
> pci_get/put_host_bridge_device() for implementing this.
>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Acked-by: Rob Herring <robh@kernel.org>

> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/of/of_pci.c    |   19 +++++++++++++++++++
>  include/linux/of_pci.h |    5 +++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 88471d3..0f1dd0b 100644
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
> @@ -229,6 +230,24 @@ parse_failed:
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
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
> +       struct device *dev = &pci_dev->dev;
> +       struct device *bridge = pci_get_host_bridge_device(pci_dev);
> +
> +       of_dma_configure(dev, bridge->parent->of_node);
> +       pci_put_host_bridge_device(bridge);
> +}
> +EXPORT_SYMBOL_GPL(of_pci_dma_configure);
> +
>  #endif /* CONFIG_OF_ADDRESS */
>
>  #ifdef CONFIG_PCI_MSI
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index ce0e5ab..8f1741f 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -16,6 +16,7 @@ int of_pci_get_devfn(struct device_node *np);
>  int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
>  int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
>  int of_get_pci_domain_nr(struct device_node *node);
> +void of_pci_dma_configure(struct pci_dev *pci_dev);
>  #else
>  static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
>  {
> @@ -50,6 +51,10 @@ of_get_pci_domain_nr(struct device_node *node)
>  {
>         return -1;
>  }
> +
> +static inline void of_pci_dma_configure(struct pci_dev *pci_dev)
> +{
> +}
>  #endif
>
>  #if defined(CONFIG_OF_ADDRESS)
> --
> 1.7.9.5
>
