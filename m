Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3HNJYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:24:00 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:48960 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3HNJX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <1376471493-22215-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376471493-22215-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 14 Aug 2013 14:53:57 +0530
X-Google-Sender-Auth: zHRVOIXzjayB60kzGe8kPtY7tbE
Message-ID: <CAOh2x=mnyjCC6uqoqOqD=8S0gDQNDytbDd=Eo-sKj8hTq8j_+w@mail.gmail.com>
Subject: Re: [PATCH 3/29] drivers/gpio: simplify use of devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Linus Walleij <linus.walleij@linaro.org>, kernel-janitors@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 2:41 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---

>  drivers/gpio/gpio-spear-spics.c |    7 +------
>  2 files changed, 2 insertions(+), 12 deletions(-)

For SPEAr:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

> diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
> index 7a4bf7c..e9a0415 100644
> --- a/drivers/gpio/gpio-spear-spics.c
> +++ b/drivers/gpio/gpio-spear-spics.c
> @@ -128,18 +128,13 @@ static int spics_gpio_probe(struct platform_device *pdev)
>         struct resource *res;
>         int ret;
>
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(&pdev->dev, "invalid IORESOURCE_MEM\n");
> -               return -EBUSY;
> -       }
> -
>         spics = devm_kzalloc(&pdev->dev, sizeof(*spics), GFP_KERNEL);
>         if (!spics) {
>                 dev_err(&pdev->dev, "memory allocation fail\n");
>                 return -ENOMEM;
>         }
>
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         spics->base = devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(spics->base))
>                 return PTR_ERR(spics->base);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
