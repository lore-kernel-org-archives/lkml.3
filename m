Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaEBA4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:56:49 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34695 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaEBA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <1398353407-2345-4-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-4-git-send-email-santosh.shilimkar@ti.com>
Date: Thu, 1 May 2014 19:56:46 -0500
Message-ID: <CAL_JsqKmf-OCf_-J06ztHWS0iRaMHAVxV0bOFGnY4Ci3fPgLow@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper
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
> The of_dma_is_coherent() helper parses the given DT device
> node to see if the "dma-coherent" property is supported and
> returns true or false accordingly.
>
> If the arch is always coherent or always noncoherent, then the default
> DMA ops has to be specified accordingly.
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
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/of/platform.c       |   23 +++++++++++++++++++++++
>  include/linux/of_platform.h |    6 ++++++

I thought I said this already, but this does not belong in these files
as the function does not deal with platform devices. Probably
address.c/of_address.h would be the best place.

Rob

>  2 files changed, 29 insertions(+)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..48de98f 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -485,4 +485,27 @@ int of_platform_populate(struct device_node *root,
>         return rc;
>  }
>  EXPORT_SYMBOL_GPL(of_platform_populate);
> +
> +/**
> + * of_dma_is_coherent - Check if device is coherent
> + * @np:        device node
> + *
> + * It returns true if "dma-coherent" property was found
> + * for this device in DT.
> + */
> +bool of_dma_is_coherent(struct device_node *np)
> +{
> +       struct device_node *node = of_node_get(np);
> +
> +       while (node) {
> +               if (of_property_read_bool(node, "dma-coherent")) {
> +                       of_node_put(node);
> +                       return true;
> +               }
> +               node = of_get_next_parent(node);
> +       }
> +       of_node_put(node);
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(of_dma_is_coherent);
>  #endif /* CONFIG_OF_ADDRESS */
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 05cb4a9..b9a3cb2 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -72,6 +72,7 @@ extern int of_platform_populate(struct device_node *root,
>                                 const struct of_device_id *matches,
>                                 const struct of_dev_auxdata *lookup,
>                                 struct device *parent);
> +extern bool of_dma_is_coherent(struct device_node *np);
>  #else
>  static inline int of_platform_populate(struct device_node *root,
>                                         const struct of_device_id *matches,
> @@ -80,6 +81,11 @@ static inline int of_platform_populate(struct device_node *root,
>  {
>         return -ENODEV;
>  }
> +
> +static inline bool of_dma_is_coherent(struct device_node *np)
> +{
> +       return false;
> +}
>  #endif
>
>  #endif /* _LINUX_OF_PLATFORM_H */
> --
> 1.7.9.5
>
