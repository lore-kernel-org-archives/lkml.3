Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaCGDtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:49:43 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:59418 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaCGDtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:49:41 -0500
MIME-Version: 1.0
In-Reply-To: <1394097598-17622-5-git-send-email-santosh.shilimkar@ti.com>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
	<1394097598-17622-5-git-send-email-santosh.shilimkar@ti.com>
Date: Thu, 6 Mar 2014 21:49:40 -0600
Message-ID: <CAL_Jsq+Y8w0sLLdh5vcWMnW3ohEafAFRWubtCK66P1axsf1wRA@mail.gmail.com>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 3:19 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
>
> Retrieve DMA configuration from DT and setup platform device's DMA
> parameters.
>
> The DMA configuration in DT has to be specified using "dma-ranges"
> property if supported. The DMA configuration applied
> by dt_dma_configure() as following:
>  - call of_get_dma_range() and get supported DMA range info
>    (dma_addr, cpu_addr, dma_size);
>  - if "not found" then fill dma_mask as DMA_BIT_MASK(32)
>    (this is default behaviour);
>  - if "failed" then clean up dma_mask (DMA not supported)
>  - if ok then update devices DMA configuration:
>       set dma_mask to (dma_addr + dma_size - 1)
>       set dma_pfn_offset to PFN_DOWN(cpu_addr - dma_addr)
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
>  drivers/of/platform.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 72 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index bd080db..53bb12f 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -187,6 +187,77 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  EXPORT_SYMBOL(of_device_alloc);
>
>  /**
> + * dt_dma_configure - apply default DMA configuration from dt

s/dt_/of_/

> + * @dev:       Device to apply DMA configuration
> + *
> + * Try to get devices's DMA configuration from DT and apply it.
> + * The DMA configuration is represented in DT by "dma-ranges" property.
> + * It configures:
> + *     dma_pfn_offset, dma_mask and coherent_dma_mask.
> + *
> + * In case if DMA configuration can't be acquired from DT the default one is
> + * applied:
> + *     dma_pfn_offset = 0,
> + *     dma_mask = DMA_BIT_MASK(32)

This is really set to &coherent_dma_mask.

> + *     coherent_dma_mask = DMA_BIT_MASK(32).
> +
> + * In case if platform code need to use own DMA configuration - it can use
> + * Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event to fix up
> + * DMA configuration.
> + */
> +static void dt_dma_configure(struct device *dev)

s/dt_/of_/

> +{
> +       dma_addr_t dma_addr;
> +       phys_addr_t paddr, size;
> +       dma_addr_t dma_mask;
> +       int ret;
> +
> +       /*
> +        * if dma-ranges property doesn't exist - use 32 bits DMA mask
> +        * by default and don't set skip archdata.dma_pfn_offset
> +        */
> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> +       if (ret == -ENODEV) {
> +               dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +               if (!dev->dma_mask)
> +                       dev->dma_mask = &dev->coherent_dma_mask;
> +               return;
> +       }
> +
> +       /* if failed - disable DMA for device */
> +       if (ret < 0) {
> +               dev_err(dev, "failed to configure DMA\n");
> +               return;
> +       }
> +
> +       /* DMA ranges found. Calculate and set dma_pfn_offset */
> +       dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> +
> +       /* Configure DMA mask */
> +       dev->dma_mask = &dev->coherent_dma_mask;
> +       if (!dev->dma_mask)

This condition is impossible.

> +               return;
> +
> +       dma_mask = dma_addr + size - 1;
> +
> +       ret = dma_set_mask(dev, dma_mask);
> +       if (ret < 0) {
> +               dev_err(dev, "failed to set DMA mask %pad\n", &dma_mask);
> +               dev->dma_mask = NULL;
> +               return;
> +       }
> +
> +       dev_dbg(dev, "dma_pfn_offset(%#08lx) dma_mask(%pad)\n",
> +               dev->dma_pfn_offset, dev->dma_mask);
> +
> +       ret = dma_set_coherent_mask(dev, dma_mask);

I think these 2 calls belong in the drivers, not here.

> +       if (ret < 0) {
> +               dev_err(dev, "failed to set coherent DMA mask %pad\n",
> +                       &dma_mask);
> +       }
> +}
> +
> +/**
>   * of_platform_device_create_pdata - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
>   * @bus_id: name to assign device
> @@ -214,9 +285,7 @@ static struct platform_device *of_platform_device_create_pdata(
>  #if defined(CONFIG_MICROBLAZE)
>         dev->archdata.dma_mask = 0xffffffffUL;
>  #endif
> -       dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> -       if (!dev->dev.dma_mask)
> -               dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> +       dt_dma_configure(&dev->dev);
>         dev->dev.bus = &platform_bus_type;
>         dev->dev.platform_data = platform_data;
>
> --
> 1.7.9.5
>
