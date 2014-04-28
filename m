Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaD1WSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:18:39 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:41205 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaD1WSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1398512276-4105-3-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
	<1398512276-4105-3-git-send-email-ch.naveen@samsung.com>
Date: Mon, 28 Apr 2014 15:18:36 -0700
X-Google-Sender-Auth: RYvcHqsg1Tj8RVoSc_5QkolQFpw
Message-ID: <CAD=FV=USUfOHfKR6MibwWpM5mBpYEOFkbYRA8ZMqd-s1v=3MTA@mail.gmail.com>
Subject: Re: [PATCH 2/5 v2] iio: exynos_adc: rearrange clk and regulator
 enable/disable calls
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Sat, Apr 26, 2014 at 4:37 AM, Naveen Krishna Chatradhi
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
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> ---
> Changes since v1:
> corrected the register/unregister and enabling/disbaling sequences
>
>  drivers/iio/adc/exynos_adc.c |   63 +++++++++++++++++++++++-------------------
>  1 file changed, 34 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index affa93f..0df8916 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -290,32 +290,30 @@ static int exynos_adc_probe(struct platform_device *pdev)
>
>         init_completion(&info->completion);
>
> -       ret = request_irq(info->irq, exynos_adc_isr,
> -                                       0, dev_name(&pdev->dev), info);
> -       if (ret < 0) {
> -               dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
> -                                                       info->irq);
> -               return ret;
> -       }
> -
> -       writel(1, info->enable_reg);
> -
>         info->clk = devm_clk_get(&pdev->dev, "adc");
>         if (IS_ERR(info->clk)) {
>                 dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>                                                         PTR_ERR(info->clk));
> -               ret = PTR_ERR(info->clk);
> -               goto err_irq;
> +               return PTR_ERR(info->clk);
>         }
>
>         info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>         if (IS_ERR(info->vdd)) {
>                 dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
>                                                         PTR_ERR(info->vdd));
> -               ret = PTR_ERR(info->vdd);
> -               goto err_irq;
> +               return PTR_ERR(info->vdd);
>         }
>
> +       ret = regulator_enable(info->vdd);
> +       if (ret)
> +               return ret;
> +
> +       ret = clk_prepare_enable(info->clk);
> +       if (ret)
> +               goto err_disable_reg;
> +
> +       writel(1, info->enable_reg);
> +
>         info->version = exynos_adc_get_version(pdev);
>
>         platform_set_drvdata(pdev, indio_dev);
> @@ -332,16 +330,18 @@ static int exynos_adc_probe(struct platform_device *pdev)
>         else
>                 indio_dev->num_channels = MAX_ADC_V2_CHANNELS;
>
> +       ret = request_irq(info->irq, exynos_adc_isr,
> +                                       0, dev_name(&pdev->dev), info);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
> +                                                       info->irq);
> +               goto err_disable_clk;
> +       }
> +
>         ret = iio_device_register(indio_dev);
>         if (ret)
>                 goto err_irq;
>
> -       ret = regulator_enable(info->vdd);
> -       if (ret)
> -               goto err_iio_dev;
> -
> -       clk_prepare_enable(info->clk);
> -
>         exynos_adc_hw_init(info);
>
>         ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
> @@ -355,12 +355,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  err_of_populate:
>         device_for_each_child(&indio_dev->dev, NULL,
>                                 exynos_adc_remove_devices);
> -       regulator_disable(info->vdd);
> -       clk_disable_unprepare(info->clk);
> -err_iio_dev:
>         iio_device_unregister(indio_dev);
>  err_irq:
>         free_irq(info->irq, info);
> +err_disable_clk:
> +       writel(0, info->enable_reg);
> +       clk_disable_unprepare(info->clk);
> +err_disable_reg:
> +       regulator_disable(info->vdd);
>         return ret;
>  }
>
> @@ -371,11 +373,12 @@ static int exynos_adc_remove(struct platform_device *pdev)
>
>         device_for_each_child(&indio_dev->dev, NULL,
>                                 exynos_adc_remove_devices);
> -       regulator_disable(info->vdd);
> -       clk_disable_unprepare(info->clk);
> -       writel(0, info->enable_reg);
>         iio_device_unregister(indio_dev);
>         free_irq(info->irq, info);
> +       writel(0, info->enable_reg);
> +       clk_disable_unprepare(info->clk);
> +       regulator_disable(info->vdd);
> +

nit: one too many blank lines here

>         return 0;
>  }
> @@ -397,8 +400,8 @@ static int exynos_adc_suspend(struct device *dev)
>                 writel(con, ADC_V1_CON(info->regs));
>         }
>
> -       clk_disable_unprepare(info->clk);
>         writel(0, info->enable_reg);
> +       clk_disable_unprepare(info->clk);
>         regulator_disable(info->vdd);
>
>         return 0;
> @@ -414,9 +417,11 @@ static int exynos_adc_resume(struct device *dev)
>         if (ret)
>                 return ret;
>
> -       writel(1, info->enable_reg);
> -       clk_prepare_enable(info->clk);
> +       ret = clk_prepare_enable(info->clk);
> +       if (ret)
> +               return ret;
>
> +       writel(1, info->enable_reg);
>         exynos_adc_hw_init(info);
>
>         return 0;
> --
> 1.7.9.5
>

Other than nit, looks good to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
