Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3HNJQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:16:16 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:51665 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3HNJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <1376471493-22215-18-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376471493-22215-18-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 14 Aug 2013 14:46:11 +0530
X-Google-Sender-Auth: -Ql2TS_TWaPWb56jZcWc3q-pk9A
Message-ID: <CAOh2x=kv4AdNZnu=6OhoyHBP6Ab2M=PK7+0nEmh4JY2ZCeVRMQ@mail.gmail.com>
Subject: Re: [PATCH 17/29] drivers/rtc: simplify use of devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Alessandro Zummo <a.zummo@towertech.it>, kernel-janitors@vger.kernel.org,
        rtc-linux@googlegroups.com,
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

>  drivers/rtc/rtc-spear.c  |    7 +------
>  3 files changed, 3 insertions(+), 12 deletions(-)

For SPEAr:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>


> diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
> index c492cf0..6470641 100644
> --- a/drivers/rtc/rtc-spear.c
> +++ b/drivers/rtc/rtc-spear.c
> @@ -358,12 +358,6 @@ static int spear_rtc_probe(struct platform_device *pdev)
>         int status = 0;
>         int irq;
>
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(&pdev->dev, "no resource defined\n");
> -               return -EBUSY;
> -       }
> -
>         config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
>         if (!config) {
>                 dev_err(&pdev->dev, "out of memory\n");
> @@ -385,6 +379,7 @@ static int spear_rtc_probe(struct platform_device *pdev)
>                 return status;
>         }
>
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         config->ioaddr = devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(config->ioaddr))
>                 return PTR_ERR(config->ioaddr);
