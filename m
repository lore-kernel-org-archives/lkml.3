Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaBMKGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:06:42 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:58870 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754007AbaBMKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:06:38 -0500
X-Greylist: delayed 87527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 05:06:37 EST
MIME-Version: 1.0
In-Reply-To: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
References: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
Date: Thu, 13 Feb 2014 11:06:32 +0100
Message-ID: <CACh+v5NOkkEJxRFg3dTFJ1xMXt9XgXKuBJq9usAtakzzVuNi7Q@mail.gmail.com>
Subject: Re: [PATCH] dt: platform driver: Fill the resources before probe and
 defer if needed
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        "grant.likely" <grant.likely@linaro.org>,
        "robh+dt" <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 11047329887542073368
X-Ovh-Remote: 209.85.192.172 (mail-pd0-f172.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I forgot to add the link to the discussion that lead to this patch:
https://lkml.org/lkml/2014/2/12/306.

Jean-Jacques

2014-02-13 10:57 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> The goal of this patch is to allow drivers to be probed even if at the time of
> the DT parsing some of their ressources are not available yet.
>
> In the current situation, the resource of a platform device are filled from the
> DT at the time the device is created (of_device_alloc()). The drawbackof this
> is that a device sitting close to the top of the DT (ahb for example) but
> depending on ressources that are initialized later (IRQ domain dynamically
> created for example)  will fail to probe because the ressources don't exist
> at this time.
>
> This patch fills the resource structure only before the device is probed and
> will defer the probe if the resource are not available yet.
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/base/platform.c     |  6 ++++
>  drivers/of/platform.c       | 71 +++++++++++++++++++++++++++++----------------
>  include/linux/of_platform.h | 10 +++++++
>  3 files changed, 62 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index bc78848..8e37d8b 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -481,6 +481,12 @@ static int platform_drv_probe(struct device *_dev)
>         struct platform_device *dev = to_platform_device(_dev);
>         int ret;
>
> +       if (_dev->of_node) {
> +               ret = of_platform_device_populate_resources(dev);
> +               if (ret < 0)
> +                       return drv->prevent_deferred_probe ? ret : -EPROBE_DEFER;
> +       }
> +
>         if (ACPI_HANDLE(_dev))
>                 acpi_dev_pm_attach(_dev, true);
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..64a8eb8 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -141,36 +141,11 @@ struct platform_device *of_device_alloc(struct device_node *np,
>                                   struct device *parent)
>  {
>         struct platform_device *dev;
> -       int rc, i, num_reg = 0, num_irq;
> -       struct resource *res, temp_res;
>
>         dev = platform_device_alloc("", -1);
>         if (!dev)
>                 return NULL;
>
> -       /* count the io and irq resources */
> -       if (of_can_translate_address(np))
> -               while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> -                       num_reg++;
> -       num_irq = of_irq_count(np);
> -
> -       /* Populate the resource table */
> -       if (num_irq || num_reg) {
> -               res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
> -               if (!res) {
> -                       platform_device_put(dev);
> -                       return NULL;
> -               }
> -
> -               dev->num_resources = num_reg + num_irq;
> -               dev->resource = res;
> -               for (i = 0; i < num_reg; i++, res++) {
> -                       rc = of_address_to_resource(np, i, res);
> -                       WARN_ON(rc);
> -               }
> -               WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> -       }
> -
>         dev->dev.of_node = of_node_get(np);
>  #if defined(CONFIG_MICROBLAZE)
>         dev->dev.dma_mask = &dev->archdata.dma_mask;
> @@ -233,6 +208,52 @@ static struct platform_device *of_platform_device_create_pdata(
>         return dev;
>  }
>
> +int of_platform_device_populate_resources(struct platform_device *dev)
> +{
> +       struct device_node *np;
> +       int rc = 0, i, nreg = 0, nirq;
> +
> +       np = dev->dev.of_node;
> +
> +       /* count the io and irq resources */
> +       if (of_can_translate_address(np)) {
> +               struct resource temp_res;
> +               while (of_address_to_resource(np, nreg, &temp_res) == 0)
> +                       nreg++;
> +       }
> +       nirq = of_irq_count(np);
> +
> +       /* Populate the resource table */
> +       if (nirq || nreg) {
> +               struct resource *res;
> +
> +               res = krealloc(dev->resource, sizeof(*res) * (nirq + nreg),
> +                              GFP_KERNEL);
> +               if (!res) {
> +                       kfree(dev->resource);
> +                       dev->resource = NULL;
> +                       return -ENOMEM;
> +               }
> +               memset(res, 0, sizeof(*res) * (nirq + nreg));
> +               dev->resource = res;
> +               dev->num_resources = nreg + nirq;
> +
> +               for (i = 0; i < nreg; i++, res++) {
> +                       rc = of_address_to_resource(np, i, res);
> +                       WARN_ON(rc);
> +                       if (rc)
> +                               break;
> +               }
> +
> +               if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq) {
> +                       rc = -ENOENT;
> +                       WARN_ON(rc);
> +               }
> +       }
> +       return rc;
> +}
> +EXPORT_SYMBOL(of_platform_device_populate_resources);
> +
>  /**
>   * of_platform_device_create - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 05cb4a9..315e1e3 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -53,6 +53,16 @@ struct of_dev_auxdata {
>
>  extern const struct of_device_id of_default_bus_match_table[];
>
> +/* Populate the resource for a platform device */
> +#ifdef CONFIG_OF
> +int of_platform_device_populate_resources(struct platform_device *dev);
> +#else
> +static inline int of_platform_device_populate_resources(
> +       struct platform_device *)
> +{
> +       return -ENOSYS;
> +}
> +#endif
>  /* Platform drivers register/unregister */
>  extern struct platform_device *of_device_alloc(struct device_node *np,
>                                          const char *bus_id,
> --
> 1.8.5.3
>
