Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaDYQG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:06:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65480 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaDYQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <1398420888-5506-3-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
	<1398420888-5506-3-git-send-email-ch.naveen@samsung.com>
Date: Fri, 25 Apr 2014 09:06:51 -0700
X-Google-Sender-Auth: PKDJ_JcttbMvW5VsZ7fM3zLR0yc
Message-ID: <CAD=FV=UOBcC92xxvtuQuzD-1zxT-hgGWJWajOUjeagHVBHYENw@mail.gmail.com>
Subject: Re: [PATCH 2/5] iio: exynos_adc: rearrange clock and regulator
 enable/disable calls
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Fri, Apr 25, 2014 at 3:14 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch maintains the following order in
> probe(), remove(), resume() and suspend() calls
>
> regulator enable, clk prepare enable
> ...
> clk disable unprepare, regulator disable
>
> While at it,
> 1. enable the regulator before the iio_device_register()
> 2. handle the return values for enable/disable calls
>
> Change-Id: I764d9d60f72caa7ea6b0609db49a74115574f081
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> ---
> This change fixes the comments given by Jonathan regarding the
> order of clock and regulator enable/disable calls.
> https://lkml.org/lkml/2014/4/23/644
>
>  drivers/iio/adc/exynos_adc.c |   34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index affa93f..a2b8b1a 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -316,6 +316,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
>                 goto err_irq;
>         }
>
> +       ret = regulator_enable(info->vdd);
> +       if (ret)
> +               goto err_irq;
> +
> +       ret = clk_prepare_enable(info->clk);
> +       if (ret)
> +               goto err_disable_reg;
> +
>         info->version = exynos_adc_get_version(pdev);
>
>         platform_set_drvdata(pdev, indio_dev);
> @@ -334,13 +342,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>
>         ret = iio_device_register(indio_dev);
>         if (ret)
> -               goto err_irq;
> -
> -       ret = regulator_enable(info->vdd);
> -       if (ret)
> -               goto err_iio_dev;
> -
> -       clk_prepare_enable(info->clk);
> +               goto err_disable_clk;
>
>         exynos_adc_hw_init(info);
>
> @@ -355,10 +357,11 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  err_of_populate:
>         device_for_each_child(&indio_dev->dev, NULL,
>                                 exynos_adc_remove_devices);
> -       regulator_disable(info->vdd);
> -       clk_disable_unprepare(info->clk);
> -err_iio_dev:
>         iio_device_unregister(indio_dev);
> +err_disable_clk:
> +       clk_disable_unprepare(info->clk);
> +err_disable_reg:
> +       regulator_disable(info->vdd);
>  err_irq:
>         free_irq(info->irq, info);
>         return ret;
> @@ -371,9 +374,10 @@ static int exynos_adc_remove(struct platform_device *pdev)
>
>         device_for_each_child(&indio_dev->dev, NULL,
>                                 exynos_adc_remove_devices);
> -       regulator_disable(info->vdd);
>         clk_disable_unprepare(info->clk);
> +       regulator_disable(info->vdd);
>         writel(0, info->enable_reg);
> +

This function still looks wrong.  The order of things should generally
match the error case of probe, which is the reverse of how things are
initted.

Specifically you shouldn't be doing "iio_device_unregister(indio_dev);" last.

Technically it's also a very good idea to free the irq much earlier.
...and in probe you should request it later.

The request_irq should probably be right before the register function
in probe and the free_irq should be right after unregister in remove.


>         iio_device_unregister(indio_dev);
>         free_irq(info->irq, info);
>
> @@ -398,8 +402,8 @@ static int exynos_adc_suspend(struct device *dev)
>         }
>
>         clk_disable_unprepare(info->clk);
> -       writel(0, info->enable_reg);
>         regulator_disable(info->vdd);
> +       writel(0, info->enable_reg);

This change looks wrong to me.  I'd believe that the rule should
always be that the regulator is enabled early and disabled late.


>         return 0;
>  }
> @@ -410,12 +414,14 @@ static int exynos_adc_resume(struct device *dev)
>         struct exynos_adc *info = iio_priv(indio_dev);
>         int ret;
>
> +       writel(1, info->enable_reg);
>         ret = regulator_enable(info->vdd);
>         if (ret)
>                 return ret;

Same here.  Should enable the regulator first, I think.
