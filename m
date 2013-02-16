Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3BPD0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:26:21 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64301 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3BPD0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:26:20 -0500
MIME-Version: 1.0
In-Reply-To: <1360952512-971558-3-git-send-email-arnd@arndb.de>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
	<1360952512-971558-3-git-send-email-arnd@arndb.de>
Date: Sat, 16 Feb 2013 08:56:19 +0530
Message-ID: <CAKohpo=u_b9u1=78+tm-rhVR14P0=2XbLrZEDJrQBY5W8LXiCw@mail.gmail.com>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2013 23:51, Arnd Bergmann <arnd@arndb.de> wrote:
> diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
> +- #dma-cells: must be <3>

> +DMA clients connected to the Designware DMA controller must use the format
> +described in the dma.txt file, using a five-cell specifier for each channel.

s/five/four ?

> +The four cells in order are:
> +
> +1. A phandle pointing to the DMA controller
> +2. The DMA request line number
> +3. Source master for transfers on allocated channel
> +4. Destination master for transfers on allocated channel

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

> +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
>  {

> +       dws->cfg_hi     = 0xffffffff;
> +       dws->cfg_lo     = 0xffffffff;

s/0xffffffff/-1 ?

> +       dws->src_master = fargs->src;
> +       dws->dst_master = fargs->dst;
> +       dwc->req        = fargs->req;
>
> -                       return true;
> -               }
> -       }
> +       chan->private = dws;
> +
> +       return true;
> +}
> +
> +static struct dma_chan *dw_dma_xlate(struct of_phandle_args *dma_spec,
> +                                        struct of_dma *ofdma)
> +{
> +       struct dw_dma *dw = ofdma->of_dma_data;
> +       struct dw_dma_filter_args fargs = {
> +               .dw = dw,
> +       };
> +       dma_cap_mask_t cap;
> +
> +       if (dma_spec->args_count != 3)
> +               return NULL;
> +
> +       fargs.req = be32_to_cpup(dma_spec->args+0);
> +       fargs.src = be32_to_cpup(dma_spec->args+1);
> +       fargs.dst = be32_to_cpup(dma_spec->args+2);
> +
> +       if (WARN_ON(fargs.req >= 16 || fargs.src >= 2 || fargs.dst >= 2))
> +               return NULL;
>
> -       last_dw = dw;
> -       last_bus_id = param;
> -       return false;
> +       dma_cap_zero(cap);
> +       dma_cap_set(DMA_SLAVE, cap);
> +
> +       /* TODO: there should be a simpler way to do this */
> +       return dma_request_channel(cap, dw_dma_generic_filter, &dma_spec->args[0]);
>  }
> -EXPORT_SYMBOL(dw_dma_generic_filter);
>
>  /* --------------------- Cyclic DMA API extensions -------------------- */
>
> @@ -1510,9 +1529,8 @@ static void dw_dma_off(struct dw_dma *dw)
>  static struct dw_dma_platform_data *
>  dw_dma_parse_dt(struct platform_device *pdev)
>  {
> -       struct device_node *sn, *cn, *np = pdev->dev.of_node;
> +       struct device_node *np = pdev->dev.of_node;
>         struct dw_dma_platform_data *pdata;
> -       struct dw_dma_slave *sd;
>         u32 tmp, arr[4];
>
>         if (!np) {
> @@ -1524,7 +1542,7 @@ dw_dma_parse_dt(struct platform_device *pdev)
>         if (!pdata)
>                 return NULL;
>
> -       if (of_property_read_u32(np, "nr_channels", &pdata->nr_channels))
> +       if (of_property_read_u32(np, "dma-channels", &pdata->nr_channels))
>                 return NULL;
