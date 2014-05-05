Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaEEWIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:08:48 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34908 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaEEWIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <536806F4.1090904@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
	<CAL_Jsq+nh26NZXx-9Y5FTxWZdVrG7aLTOBhC4j9P8mPPvUu2ag@mail.gmail.com>
	<536806F4.1090904@ti.com>
Date: Mon, 5 May 2014 17:08:45 -0500
Message-ID: <CAL_JsqL07fGB4Xp-aZZsj+K-UH91v-1WVmtSq+xFoA4xoJ+HwQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 4:47 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Thursday 01 May 2014 08:49 PM, Rob Herring wrote:
>> On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:

> Updated patch with above minor updates.
>
> From 80a9f06a09a90801d8ee337d9b2d155c43da8f23 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Thu, 24 Apr 2014 11:30:04 -0400
> Subject: [PATCH v3 4/7] of: configure the platform device dma parameters
>
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

Reviewed-by: Rob Herring <robh@kernel.org>

> ---
>  drivers/of/platform.c       |   55 ++++++++++++++++++++++++++++++++++++++-----
>  include/linux/dma-mapping.h |    7 ++++++
>  2 files changed, 56 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..b71e089 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -187,6 +187,54 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  EXPORT_SYMBOL(of_device_alloc);
>
>  /**
> + * of_dma_configure - Setup DMA configuration
> + * @dev:       Device to apply DMA configuration
> + *
> + * Try to get devices's DMA configuration from DT and update it
> + * accordingly.
> + *
> + * In case if platform code need to use own special DMA configuration,it
> + * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
> + * to fix up DMA configuration.
> + */
> +static void of_dma_configure(struct platform_device *pdev)
> +{
> +       u64 dma_addr, paddr, size;
> +       int ret;
> +       struct device *dev = &pdev->dev;
> +
> +#if defined(CONFIG_MICROBLAZE)
> +       pdev->archdata.dma_mask = 0xffffffffUL;
> +#endif
> +       dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +       if (!dev->dma_mask)
> +               dev->dma_mask = &dev->coherent_dma_mask;
> +
> +       /*
> +        * if dma-coherent property exist, call arch hook to setup
> +        * dma coherent operations.
> +        */
> +       if (of_dma_is_coherent(dev->of_node)) {
> +               set_arch_dma_coherent_ops(dev);
> +               dev_dbg(dev, "device is dma coherent\n");
> +       }
> +
> +       /*
> +        * if dma-ranges property doesn't exist - just return else
> +        * setup the dma offset
> +        */
> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> +       if (ret < 0) {
> +               dev_dbg(dev, "no dma range information to setup\n");
> +               return;
> +       }
> +
> +       /* DMA ranges found. Calculate and set dma_pfn_offset */
> +       dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> +       dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +}
> +
> +/**
>   * of_platform_device_create_pdata - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
>   * @bus_id: name to assign device
> @@ -211,12 +259,7 @@ static struct platform_device *of_platform_device_create_pdata(
>         if (!dev)
>                 return NULL;
>
> -#if defined(CONFIG_MICROBLAZE)
> -       dev->archdata.dma_mask = 0xffffffffUL;
> -#endif
> -       dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> -       if (!dev->dev.dma_mask)
> -               dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> +       of_dma_configure(dev);
>         dev->dev.bus = &platform_bus_type;
>         dev->dev.platform_data = platform_data;
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
> +       return 0;
> +}
> +#endif
> +
>  static inline unsigned int dma_get_max_seg_size(struct device *dev)
>  {
>         return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
> --
> 1.7.9.5
>
>
