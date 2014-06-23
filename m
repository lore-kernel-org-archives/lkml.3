Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaFWPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:48:56 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54245 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaFWPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:48:53 -0400
MIME-Version: 1.0
In-Reply-To: <1403045462-24204-1-git-send-email-linux@roeck-us.net>
References: <1403045462-24204-1-git-send-email-linux@roeck-us.net>
From: Rob Herring <robh@kernel.org>
Date: Mon, 23 Jun 2014 10:48:33 -0500
X-Google-Sender-Auth: aqZa-pzpM_K4bsKNnRzznbrSce4
Message-ID: <CAL_Jsq+Xi4UnFHouTqJQGyNVHpCcbNBRNgbQ3OY-+EsCDKFHLw@mail.gmail.com>
Subject: Re: [PATCH v2] platform_get_irq: Revert to platform_get_resource if
 of_irq_get fails
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 5:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
> and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
> change the semantics of platform_get_irq and platform_get_irq_byname
> to always rely on devicetree information if devicetree is enabled
> and if a devicetree node is attached to the device. The functions
> now return an error if the devicetree data does not include interrupt
> information, even if the information is available as platform resource
> data.
>
> This causes mfd client drivers to fail if the interrupt number is
> passed via platform resources. Therefore, if of_irq_get fails, try
> platform_get_resource as method of last resort. This restores the
> original functionality for drivers depending on platform resources
> to get irq information.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Rob Herring <robh@kernel.org>

Greg should take this for 3.16.

Rob

> ---
> v2: Include change for platform_get_irq_byname
>     Handle EPROBE_DEFER
>
> It looks like v1 got lost in space, so you may not have seen it.
> I am sending this patch as v2 anyway to avoid confusion, just in case
> v1 shows up somewhere.
>
> At least 9ec36ca has been applied to -stable, so if this patch is
> accepted it may make sense to apply it to the same -stable releases.
>
>  drivers/base/platform.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9e9227e..eee48c4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -89,8 +89,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>         return dev->archdata.irqs[num];
>  #else
>         struct resource *r;
> -       if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> -               return of_irq_get(dev->dev.of_node, num);
> +       if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
> +               int ret;
> +
> +               ret = of_irq_get(dev->dev.of_node, num);
> +               if (ret >= 0 || ret == -EPROBE_DEFER)
> +                       return ret;
> +       }
>
>         r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>
> @@ -133,8 +138,13 @@ int platform_get_irq_byname(struct platform_device *dev, const char *name)
>  {
>         struct resource *r;
>
> -       if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> -               return of_irq_get_byname(dev->dev.of_node, name);
> +       if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
> +               int ret;
> +
> +               ret = of_irq_get_byname(dev->dev.of_node, name);
> +               if (ret >= 0 || ret == -EPROBE_DEFER)
> +                       return ret;
> +       }
>
>         r = platform_get_resource_byname(dev, IORESOURCE_IRQ, name);
>         return r ? r->start : -ENXIO;
> --
> 1.9.1
>
