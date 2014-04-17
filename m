Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaDQP34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:29:56 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43538 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaDQP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <1397729403-32045-9-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
	<1397729403-32045-9-git-send-email-sangjung.woo@samsung.com>
Date: Fri, 18 Apr 2014 00:29:45 +0900
Message-ID: <CAGTfZH0m0YT0Dj7ZavrFrTe-h5J49DausNWnEtcRxxEmqtr3KQ@mail.gmail.com>
Subject: Re: [PATCHv2 8/8] extcon: arizona: Use devm_extcon_dev_register()
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangjung,

Seung-Woo reviewed this patch previously but, He didn't send
reviewed-by message as reply.
After received reviewed-by message, I think that we should add it on
patch description.

Thanks,
Chanwoo Choi

On Thu, Apr 17, 2014 at 7:10 PM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
> Use the resource-managed extcon device register function (i.e.
> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
> is attached with this function, that extcon device is automatically unregistered
> on driver detach. That reduces tiresome managing code.
>
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> Reviewed-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---
>  drivers/extcon/extcon-arizona.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 98a14f6..40e6c0b 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>         info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>         if (!info) {
>                 dev_err(&pdev->dev, "Failed to allocate memory\n");
> -               ret = -ENOMEM;
> -               goto err;
> +               return -ENOMEM;
>         }
>
>         info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
>         if (IS_ERR(info->micvdd)) {
> -               ret = PTR_ERR(info->micvdd);
>                 dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
> -               goto err;
> +               return PTR_ERR(info->micvdd);
>         }
>
>         mutex_init(&info->lock);
> @@ -1155,11 +1153,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>         info->edev.dev.parent = arizona->dev;
>         info->edev.supported_cable = arizona_cable;
>
> -       ret = extcon_dev_register(&info->edev);
> +       ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
>         if (ret < 0) {
>                 dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
>                         ret);
> -               goto err;
> +               return ret;
>         }
>
>         info->input = devm_input_allocate_device(&pdev->dev);
> @@ -1410,8 +1408,6 @@ err_rise:
>  err_input:
>  err_register:
>         pm_runtime_disable(&pdev->dev);
> -       extcon_dev_unregister(&info->edev);
> -err:
>         return ret;
>  }
>
> @@ -1445,7 +1441,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
>         regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
>                            ARIZONA_JD1_ENA, 0);
>         arizona_clk32k_disable(arizona);
> -       extcon_dev_unregister(&info->edev);
>
>         return 0;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
