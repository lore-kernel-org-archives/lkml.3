Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaDUP3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:29:19 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:34385 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaDUP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <1397917972-6293-3-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
	<1397917972-6293-3-git-send-email-santosh.shilimkar@ti.com>
Date: Mon, 21 Apr 2014 10:29:11 -0500
Message-ID: <CAL_Jsq+9dZiAndnbC3fZDjZWU90K4BBR=ckuDxfy5_mBcRL=nA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] of: introduce of_dma_get_range() helper
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 9:32 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
>
> The of_dma_get_range() allows to find "dma-range" property for
> the specified device and parse it.
>  dma-ranges format:
>    DMA addr (dma_addr)          : naddr cells
>    CPU addr (phys_addr_t)       : pna cells
>    size                         : nsize cells
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
>  drivers/of/platform.c       |   85 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_platform.h |    8 ++++

This belongs in drivers/of/address.c and of_address.h.

>  2 files changed, 93 insertions(+)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..2265a55 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -485,4 +485,89 @@ int of_platform_populate(struct device_node *root,
>         return rc;
>  }
>  EXPORT_SYMBOL_GPL(of_platform_populate);
> +
> +/**
> + * of_dma_get_range - Get DMA range info
> + * @np:                device node to get DMA range info
> + * @dma_addr:  pointer to store initial DMA address of DMA range
> + * @paddr:     pointer to store initial CPU address of DMA range
> + * @size:      pointer to store size of DMA range
> + *
> + * Look in bottom up direction for the first "dma-range" property

dma-ranges

> + * and parse it.
> + *  dma-ranges format:
> + *     DMA addr (dma_addr)     : naddr cells
> + *     CPU addr (phys_addr_t)  : pna cells
> + *     size                    : nsize cells
> + *
> + * It returns -ENODEV if "dma-ranges" property was not found
> + * for this device in DT.
> + */
> +extern int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,

drop extern.

> +               phys_addr_t *paddr, phys_addr_t *size)
> +{
> +       struct device_node *node = np;
> +       const u32 *ranges = NULL;

__be32

> +       int len, naddr, nsize, pna;
> +       int ret = 0;
> +
> +       if (!node)
> +               return -EINVAL;
> +
> +       while (1) {
> +               naddr = of_n_addr_cells(node);
> +               nsize = of_n_size_cells(node);
> +               node = of_get_next_parent(node);
> +               if (!node)
> +                       break;
> +
> +               ranges = of_get_property(node, "dma-ranges", &len);
> +
> +               /* Ignore empty ranges, they imply no translation required */
> +               if (ranges && len > 0)
> +                       break;
> +
> +               /*
> +                * At least empty ranges has to be defined for parent node if
> +                * DMA is supported
> +                */
> +               if (!ranges)
> +                       break;

You need an of_node_put here if you are getting the next parent.

> +       }
> +
> +       if (!ranges) {
> +               pr_debug("%s: no dma-ranges found for node(%s)\n",
> +                        __func__, np->full_name);
> +               ret = -ENODEV;
> +               goto out;
> +       }
> +
> +       len /= sizeof(u32);
> +
> +       pna = of_n_addr_cells(node);
> +
> +       /* dma-ranges format:
> +        * DMA addr     : naddr cells
> +        * CPU addr     : pna cells
> +        * size         : nsize cells
> +        */
> +       *dma_addr = of_read_number(ranges, naddr);

You should set this after the following call succeeds.

> +       *paddr = of_translate_dma_address(np, ranges);

This is going to search for dma-ranges again, but you have already
done that. Is there a case that just reading the CPU addr will not
work? I suppose we could have more than one level of translation. It
also seems a bit abusive that the DMA address is the ranges property.
I don't really have a better suggestion though.

> +       if (*paddr == OF_BAD_ADDR) {

As I mentioned, this is potentially a size mismatch.

Rob
