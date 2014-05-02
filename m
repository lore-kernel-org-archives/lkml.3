Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEBQzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:55:06 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42528 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEBQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:55:03 -0400
Date: Fri, 2 May 2014 10:54:59 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Message-ID: <20140502165459.GA29511@google.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
 <1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:30:04AM -0400, Santosh Shilimkar wrote:
> Retrieve DMA configuration from DT and setup platform device's DMA
> parameters. The DMA configuration in DT has to be specified using
> "dma-ranges" and "dma-coherent" properties if supported.
> 
> We setup dma_pfn_offset using "dma-ranges" and dma_coherent_ops
> using "dma-coherent" device tree properties.
> 
> The set_arch_dma_coherent_ops macro has to be defined by arch if
> it supports coherent dma_ops. Otherwise, set_arch_dma_coherent_ops() is
> declared as nop.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/of/platform.c       |   48 ++++++++++++++++++++++++++++++++++++++++---
>  include/linux/dma-mapping.h |    7 +++++++
>  2 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 48de98f..270c0b9 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -187,6 +187,50 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  EXPORT_SYMBOL(of_device_alloc);
>  
>  /**
> + * of_dma_configure - Setup DMA configuration
> + * @dev:	Device to apply DMA configuration
> + *
> + * Try to get devices's DMA configuration from DT and update it
> + * accordingly.
> + *
> + * In case if platform code need to use own special DMA configuration,it
> + * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
> + * to fix up DMA configuration.
> + */
> +static void of_dma_configure(struct device *dev)
> +{
> +	u64 dma_addr, paddr, size;
> +	int ret;
> +
> +	dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +	if (!dev->dma_mask)
> +		dev->dma_mask = &dev->coherent_dma_mask;
> +
> +	/*
> +	 * if dma-coherent property exist, call arch hook to setup
> +	 * dma coherent operations.
> +	 */
> +	if (of_dma_is_coherent(dev->of_node)) {
> +		set_arch_dma_coherent_ops(dev);
> +		dev_dbg(dev, "device is dma coherent\n");
> +	}
> +
> +	/*
> +	 * if dma-ranges property doesn't exist - just return else
> +	 * setup the dma offset
> +	 */
> +	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> +	if ((ret == -ENODEV) || (ret < 0)) {
> +		dev_dbg(dev, "no dma range information to setup\n");
> +		return;
> +	}
> +
> +	/* DMA ranges found. Calculate and set dma_pfn_offset */
> +	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> +	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);

Is this effectively the same as an IOMMU that applies a constant offset
to the bus address?  Could or should this be done by adding a simple IOMMU
driver instead of adding dma_pfn_offset to struct device?

If we had both dma-ranges (and we set dma_pfn_offset as you do here) and an
IOMMU, how would the combination work?  If the IOMMU driver managed
dma_pfn_offset internally, it seems like we'd have two entities dealing
with it.  If the IOMMU driver doesn't use dma_pfn_offset, it seems like
it would be exposing a weird intermediate address space that's not usable
by either CPU or device.
