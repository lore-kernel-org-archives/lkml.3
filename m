Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaEBAtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:49:09 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:64815 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaEBAtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:49:07 -0400
MIME-Version: 1.0
In-Reply-To: <1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com>
Date: Thu, 1 May 2014 19:49:05 -0500
Message-ID: <CAL_Jsq+nh26NZXx-9Y5FTxWZdVrG7aLTOBhC4j9P8mPPvUu2ag@mail.gmail.com>
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

On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
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

[...]

> +       /*
> +        * if dma-ranges property doesn't exist - just return else
> +        * setup the dma offset
> +        */
> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> +       if ((ret == -ENODEV) || (ret < 0)) {

The 1st condition is redundant.

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
> @@ -214,9 +258,7 @@ static struct platform_device *of_platform_device_create_pdata(
>  #if defined(CONFIG_MICROBLAZE)
>         dev->archdata.dma_mask = 0xffffffffUL;
>  #endif

This is also dma related setup. Please move *all* dma setup into the function.

> -       dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> -       if (!dev->dev.dma_mask)
> -               dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> +       of_dma_configure(&dev->dev);
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
