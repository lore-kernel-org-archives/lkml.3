Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3H3Kjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:39:41 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49831 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3H3Kjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <1464891.8oCRh2189n@amdc1032>
References: <1464891.8oCRh2189n@amdc1032>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 30 Aug 2013 11:39:19 +0100
X-Google-Sender-Auth: d9io4RWgZ9786RP407LPAC57tKU
Message-ID: <CACxGe6u_O4JxZo6rmzwHX1LibD5vbtjdj8QBzwF5Bjizo0bUiQ@mail.gmail.com>
Subject: Re: [PATCH] of/platform: add error reporting to of_amba_device_create()
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 11:11 AM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Add error reporting to of_amba_device_create() so the user knows
> when (and why) some device tree nodes fail to initialize.
>
> Also while at it fix the function to return an error value on error.
>
> [ The issue was spotted on Universal C210 board (using revision 0 of
>   ARM Exynos4210 SoC) on which initialization was silently failing
>   for PL330 MDMA1 device tree node (it was using the wrong addres
>   resulting in amba_device_add() returning -ENODEV). ]
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/of/platform.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b0d1ff8..cab4d0a 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -264,8 +264,11 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>                 return NULL;
>
>         dev = amba_device_alloc(NULL, 0, 0);
> -       if (!dev)
> -               return NULL;
> +       if (!dev) {
> +               pr_err("%s(): amba_device_alloc() failed for %s\n",
> +                      __func__, node->full_name);
> +               return ERR_PTR(-ENOMEM);

Don't change the return value here. This function does not use the
ERR_PTR() pattern. The message to the kernel log is sufficient.

> +       }
>
>         /* setup generic device info */
>         dev->dev.coherent_dma_mask = ~0;
> @@ -290,18 +293,24 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>                 dev->irq[i] = irq_of_parse_and_map(node, i);
>
>         ret = of_address_to_resource(node, 0, &dev->res);
> -       if (ret)
> +       if (ret) {
> +               pr_err("%s(): of_address_to_resource() failed (%d) for %s\n",
> +                      __func__, ret, node->full_name);
>                 goto err_free;
> +       }
>
>         ret = amba_device_add(dev, &iomem_resource);
> -       if (ret)
> +       if (ret) {
> +               pr_err("%s(): amba_device_add() failed (%d) for %s\n",
> +                      __func__, ret, node->full_name);
>                 goto err_free;
> +       }
>
>         return dev;
>
>  err_free:
>         amba_device_put(dev);
> -       return NULL;
> +       return ERR_PTR(ret);

Ditto here. Don't change the pattern. Otherwise this patch looks okay.
If you respin it then I can pick it up for v3.12

>  }
>  #else /* CONFIG_ARM_AMBA */
>  static struct amba_device *of_amba_device_create(struct device_node *node,
> @@ -374,7 +383,11 @@ static int of_platform_bus_create(struct device_node *bus,
>         }
>
>         if (of_device_is_compatible(bus, "arm,primecell")) {
> -               of_amba_device_create(bus, bus_id, platform_data, parent);
> +               /*
> +                * Don't return an error here to keep compatibility with older
> +                * device tree files.
> +                */
> +               (void)of_amba_device_create(bus, bus_id, platform_data, parent);

Adding he comment is fine, but why is this line being changed?

>                 return 0;
>         }
>
> --
> 1.8.2.3
>
>
