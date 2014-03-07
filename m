Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCGDN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:13:29 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:36497 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaCGDN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <1394097598-17622-4-git-send-email-santosh.shilimkar@ti.com>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
	<1394097598-17622-4-git-send-email-santosh.shilimkar@ti.com>
Date: Thu, 6 Mar 2014 21:13:26 -0600
Message-ID: <CAL_JsqJnG1c0=+UgOmNOGs7a5jv2f3O074-TsXibiHsXapXhcQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] of: introduce of_dma_is_coherent() helper
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
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 3:19 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> The of_dma_is_coherent() helper parses the given DT device
> node to see if the "dma-coherent" property is supported and
> returns true or false accordingly.
>
> For the architectures which are fully dma coherent and don't need per device
> property, it can enable CONFIG_ARCH_IS_DMA_COHERENT config option which
> enables DMA coherent for all devices by default.

This worries me. I killed off arch_is_coherent() for arm. Now we're
adding something back. Also, we already have HAVE_GENERIC_DMA_COHERENT
which is different, but the names will be confusing. MIPS also has
DMA_NONCOHERENT.

>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/of/platform.c       |   31 +++++++++++++++++++++++++++++++
>  include/linux/of_platform.h |    6 ++++++
>  2 files changed, 37 insertions(+)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 2265a55..bd080db 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -570,4 +570,35 @@ out:
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(of_dma_get_range);
> +
> +/**
> + * of_dma_is_coherent - Check if device is coherent
> + * @np:        device node
> + *
> + * It returns true if "dma-coherent" property was found
> + * for this device in DT.
> + */
> +#ifndef CONFIG_ARCH_IS_DMA_COHERENT
> +bool of_dma_is_coherent(struct device_node *np)
> +{
> +       struct device_node *node = np;
> +
> +       while (node) {

This screams for a for_each_parent_of_node helper.

> +               if (of_property_read_bool(node, "dma-coherent")) {
> +                       of_node_put(node);
> +                       return true;
> +               }
> +               node = of_get_next_parent(node);
> +       }
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(of_dma_is_coherent);
> +#else
> +inline bool of_dma_is_coherent(struct device_node *np)

This is in the header and should not be here.

> +{
> +       /* ARCH is fully dma coherent and don't need per device control */
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(of_dma_is_coherent);
> +#endif
>  #endif /* CONFIG_OF_ADDRESS */
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index ba7d3dc..48e0748 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -74,6 +74,7 @@ extern int of_platform_populate(struct device_node *root,
>                                 struct device *parent);
>  extern int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,
>                                 phys_addr_t *paddr, phys_addr_t *size);
> +extern bool of_dma_is_coherent(struct device_node *np);
>  #else
>  static inline int of_platform_populate(struct device_node *root,
>                                         const struct of_device_id *matches,
> @@ -88,6 +89,11 @@ static inline int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,
>  {
>         return -ENODEV;
>  }
> +
> +static inline bool of_dma_is_coherent(struct device_node *np)
> +{
> +       return false;
> +}
>  #endif

I don't think you have the ifdefs right here.

Rob
