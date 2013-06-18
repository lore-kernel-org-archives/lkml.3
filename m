Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3FROIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:08:24 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49617 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab3FROIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130618125235.GA15122@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz> <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
 <20130618125235.GA15122@amd.pavel.ucw.cz>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 Jun 2013 15:08:02 +0100
X-Google-Sender-Auth: tfAdqjqwLW2kGDgaJMvMJT4-Gvg
Message-ID: <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
To: Pavel Machek <pavel@denx.de>
Cc: Detlev Zundel <dzu@denx.de>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial <trivial@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:52 PM, Pavel Machek <pavel@denx.de> wrote:
>
> If device is initialized from device tree, but has no interrupt
> assigned, uio will still try to request and interrupt old way, fails,
> and fails registration.
>
> This is wrong; don't try initializing irq using platform data if
> device tree is available.
>
> Simplified code based on suggestion by Grant Likely.
>
> Fixed memory leak in "irq can not be registered" error path.
>
> Signed-off-by: Pavel Machek <pavel@denx.de>
> Reported-by: Detlev Zundel <dzu@denx.de>
>
> ---
>
> Also redone against char-misc-next.
>
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index c122bca..a27fd50 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -103,24 +103,16 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>         int i;
>
>         if (pdev->dev.of_node) {
> -               int irq;
> -
>                 /* alloc uioinfo for one device */
>                 uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>                 if (!uioinfo) {
>                         ret = -ENOMEM;
>                         dev_err(&pdev->dev, "unable to kmalloc\n");
> -                       goto bad2;
> +                       return ret;
>                 }
>                 uioinfo->name = pdev->dev.of_node->name;
>                 uioinfo->version = "devicetree";
> -
>                 /* Multiple IRQs are not supported */
> -               irq = platform_get_irq(pdev, 0);
> -               if (irq == -ENXIO)
> -                       uioinfo->irq = UIO_IRQ_NONE;
> -               else
> -                       uioinfo->irq = irq;
>         }
>
>         if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> @@ -146,14 +138,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>         priv->flags = 0; /* interrupt is enabled to begin with */
>         priv->pdev = pdev;
>
> -       if (!uioinfo->irq) {
> -               ret = platform_get_irq(pdev, 0);
> -               if (ret < 0) {
> -                       dev_err(&pdev->dev, "failed to get IRQ\n");
> -                       goto bad0;
> -               }
> -               uioinfo->irq = ret;
> +       ret = platform_get_irq(pdev, 0);
> +       uioinfo->irq = ret;
> +       if (ret == -ENXIO && pdev->dev.of_node)
> +               uioinfo->irq = UIO_IRQ_NONE;

This short-circuits the platform data use case where uioinfo->irq is
already set. The if (!uioinfo->irq) test is still needed. The original
code looks like it already handles it correctly for both the
platform_data and DT use cases because in the DT case the uioinfo
structure is zeroed by kzalloc().

As an aside, switching to devm_kzalloc() would simplify the unwind path.

> +       else if (ret < 0) {
> +               dev_err(&pdev->dev, "failed to get IRQ\n");
> +               goto bad1;
>         }
> +
>         uiomem = &uioinfo->mem[0];
>
>         for (i = 0; i < pdev->num_resources; ++i) {
> @@ -206,19 +199,19 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>         ret = uio_register_device(&pdev->dev, priv->uioinfo);
>         if (ret) {
>                 dev_err(&pdev->dev, "unable to register uio device\n");
> -               goto bad1;
> +               goto bad2;
>         }
>
>         platform_set_drvdata(pdev, priv);
>         return 0;
> + bad2:
> +       pm_runtime_disable(&pdev->dev);
>   bad1:
>         kfree(priv);
> -       pm_runtime_disable(&pdev->dev);
>   bad0:
>         /* kfree uioinfo for OF */
>         if (pdev->dev.of_node)
>                 kfree(uioinfo);
> - bad2:
>         return ret;
>  }
>
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
