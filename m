Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3EHN7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:59:38 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:34912 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3EHN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-40-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-40-git-send-email-lee.jones@linaro.org>
Date: Wed, 8 May 2013 15:59:35 +0200
Message-ID: <CAPDyKFqiLt=xC8NNXxKZpKh49+ewHuLt=0r+HogZ-aFrKh99NQ@mail.gmail.com>
Subject: Re: [PATCH 39/63] crypto: ux500/cryp - Prepare clock before enabling it
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2013 16:32, Lee Jones <lee.jones@linaro.org> wrote:
> If we fail to prepare the ux500-cryp clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
> index 22c9063..bf78d60 100644
> --- a/drivers/crypto/ux500/cryp/cryp_core.c
> +++ b/drivers/crypto/ux500/cryp/cryp_core.c
> @@ -1459,11 +1459,17 @@ static int ux500_cryp_probe(struct platform_device *pdev)
>                 goto out_regulator;
>         }
>
> +       ret = clk_prepare(device_data->clk);
> +       if (ret) {
> +               dev_err(dev, "[%s]: clk_prepare() failed!", __func__);
> +               goto out_clk;
> +       }
> +
>         /* Enable device power (and clock) */
>         ret = cryp_enable_power(device_data->dev, device_data, false);
>         if (ret) {
>                 dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
> -               goto out_clk;
> +               goto out_clk_unprepare;
>         }
>
>         cryp_error = cryp_check(device_data);
> @@ -1524,6 +1530,9 @@ static int ux500_cryp_probe(struct platform_device *pdev)
>  out_power:
>         cryp_disable_power(device_data->dev, device_data, false);
>
> +out_clk_unprepare:
> +       clk_unprepare(device_data->clk);
> +
>  out_clk:
>         clk_put(device_data->clk);
>
> @@ -1594,6 +1603,7 @@ static int ux500_cryp_remove(struct platform_device *pdev)
>                 dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
>                         __func__);
>
> +       clk_unprepare(device_data->clk);
>         clk_put(device_data->clk);
>         regulator_put(device_data->pwr_regulator);
>
> --
> 1.7.10.4
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
