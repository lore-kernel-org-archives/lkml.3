Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3IZIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:06:16 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40382 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3IZIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:06:12 -0400
MIME-Version: 1.0
X-Originating-IP: [111.240.64.25]
In-Reply-To: <003c01ceba8d$79872c60$6c958520$%han@samsung.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
	<003c01ceba8d$79872c60$6c958520$%han@samsung.com>
Date: Thu, 26 Sep 2013 16:06:11 +0800
Message-ID: <CAFRkauBTZQzSKgaNg781zsTU4u9V4rYATcWzC=BkJQy07sOBqA@mail.gmail.com>
Subject: Re: [PATCH V3 12/14] regulator: tps6524x: use devm_regulator_register()
From: Axel Lin <axel.lin@ingics.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/26 Jingoo Han <jg1.han@samsung.com>:
> Use devm_regulator_register() to make cleanup paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/tps6524x-regulator.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
> index 8b9ee39..8fe67fb 100644
> --- a/drivers/regulator/tps6524x-regulator.c
> +++ b/drivers/regulator/tps6524x-regulator.c
> @@ -584,10 +584,8 @@ static int pmic_remove(struct spi_device *spi)
>
>         if (!hw)
>                 return 0;
> -       for (i = 0; i < N_REGULATORS; i++) {
> -               regulator_unregister(hw->rdev[i]);
> +       for (i = 0; i < N_REGULATORS; i++)
>                 hw->rdev[i] = NULL;
> -       }
>         return 0;
>  }
>
> @@ -631,7 +629,8 @@ static int pmic_probe(struct spi_device *spi)
>                 config.init_data = init_data;
>                 config.driver_data = hw;
>
> -               hw->rdev[i] = regulator_register(&hw->desc[i], &config);
> +               hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
> +                                                     &config);
>                 if (IS_ERR(hw->rdev[i])) {
>                         ret = PTR_ERR(hw->rdev[i]);
>                         hw->rdev[i] = NULL;

I think you can simply return PTR_ERR(hw->rdev[i]) if devm_regulator_register()
fails.
You are using devm_regulator_register now, so don't need to call
pmic_remove() in probe() error path.
Then pmic_remove() and .remove = pmic_remove() can be removed as well.

Regards,
Axel
