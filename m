Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3HNJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:16:59 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:44548 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3HNJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <1376471493-22215-22-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376471493-22215-22-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 14 Aug 2013 14:46:53 +0530
X-Google-Sender-Auth: qoGpA1Wl0OVAqOfqwCMPk2AWgRk
Message-ID: <CAOh2x=koA8UobcNTGPzrj5oBhWot6CFA=eg6YX0x_mzZ7+_Qxg@mail.gmail.com>
Subject: Re: [PATCH 21/29] pwm: simplify use of devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Thierry Reding <thierry.reding@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-pwm@vger.kernel.org,
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

>  drivers/pwm/pwm-spear.c       |    7 +------

For SPEAr:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>


> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index a54d214..8ad26b8 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -178,18 +178,13 @@ static int spear_pwm_probe(struct platform_device *pdev)
>         int ret;
>         u32 val;
>
> -       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!r) {
> -               dev_err(&pdev->dev, "no memory resources defined\n");
> -               return -ENODEV;
> -       }
> -
>         pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
>         if (!pc) {
>                 dev_err(&pdev->dev, "failed to allocate memory\n");
>                 return -ENOMEM;
>         }
>
> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
>         if (IS_ERR(pc->mmio_base))
>                 return PTR_ERR(pc->mmio_base);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
