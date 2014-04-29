Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaD2Oly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:41:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44273 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaD2Olw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:41:52 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
In-Reply-To: <1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
Date: Tue, 29 Apr 2014 15:41:46 +0100
Message-Id: <20140429144147.004EEC40992@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 11:30:04 -0400, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
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

I've got two concerns here. of_dma_get_range() retrieves only the first
tuple from the dma-ranges property, but it is perfectly valid for
dma-ranges to contain multiple tuples. How should we handle it if a
device has multiple ranges it can DMA from?

Second, while the pfn offset is being determined, I don't see anything
making use of either the base address or size. How is the device
constrained to only getting DMA buffers from within that range? Is the
driver expected to manage that directly?

g.

> +}
> +
> +/**
>   * of_platform_device_create_pdata - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
>   * @bus_id: name to assign device
> @@ -214,9 +258,7 @@ static struct platform_device *of_platform_device_create_pdata(
>  #if defined(CONFIG_MICROBLAZE)
>  	dev->archdata.dma_mask = 0xffffffffUL;
>  #endif
> -	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> -	if (!dev->dev.dma_mask)
> -		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> +	of_dma_configure(&dev->dev);
>  	dev->dev.bus = &platform_bus_type;
>  	dev->dev.platform_data = platform_data;
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index fd4aee2..c7d9b1b 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -123,6 +123,13 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
>  
>  extern u64 dma_get_required_mask(struct device *dev);
>  
> +#ifndef set_arch_dma_coherent_ops
> +static inline int set_arch_dma_coherent_ops(struct device *dev)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static inline unsigned int dma_get_max_seg_size(struct device *dev)
>  {
>  	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
> -- 
> 1.7.9.5
> 

