Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaGJKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:08:38 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44672 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaGJKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <1404467722-26687-16-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
	<1404467722-26687-16-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 10 Jul 2014 15:38:27 +0530
X-Google-Sender-Auth: i8314IBVO6goWETcshIF8lbzKbw
Message-ID: <CADGdYn4EURaHinWVksQSPzVr=CkZYcrqvWsO7mKDz_gY9XB__Q@mail.gmail.com>
Subject: Re: [PATCH v6 15/23] regulator: max77686: Setup DVS-related GPIOs on probe
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        LAK <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 3:25 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> MAX77686 PMIC support Dyamic Voltage Scaling (DVS) on a set
> of Buck regulators. A number of GPIO are connected to these
> lines and are requested by the mfd driver. Setup the GPIO
> pins from the regulator driver.
If possible merge this patch with patch 8. Both are adding DVS
support. Put regmap_copy dependency patch in very beginning.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/regulator/max77686.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index ef1af2d..ecce77a 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -435,6 +435,12 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
>  }
>  #endif /* CONFIG_OF */
>
> +static inline bool max77686_is_dvs_buck(int id)
> +{
> +       /* BUCK 2,3 and 4 support DVS */
> +       return (id >= MAX77686_BUCK2 && id <= MAX77686_BUCK4);
I am just wondering if along with above check, SELB gpios (if present)
can be used to confirm if BUCK's are DVS based or not.
> +}
> +
>  static int max77686_pmic_probe(struct platform_device *pdev)
>  {
>         struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> @@ -442,6 +448,9 @@ static int max77686_pmic_probe(struct platform_device *pdev)
>         struct max77686_data *max77686;
>         int i, ret = 0;
>         struct regulator_config config = { };
> +       unsigned int reg;
> +       int buck_default_idx;
> +       int buck_old_idx;
>
>         dev_dbg(&pdev->dev, "%s\n", __func__);
>
> @@ -472,13 +481,34 @@ static int max77686_pmic_probe(struct platform_device *pdev)
>         config.driver_data = max77686;
>         platform_set_drvdata(pdev, max77686);
>
> +       buck_default_idx = pdata->buck_default_idx;
> +       buck_old_idx = max77686_read_gpios(pdata);
> +
>         for (i = 0; i < MAX77686_REGULATORS; i++) {
>                 struct regulator_dev *rdev;
> +               int id = pdata->regulators[i].id;
>
>                 config.init_data = pdata->regulators[i].initdata;
>                 config.of_node = pdata->regulators[i].of_node;
>
>                 max77686->opmode[i] = regulators[i].enable_mask;
> +
> +               if (max77686_is_dvs_buck(id)) {
> +                       /* Try to copy over data so we keep firmware settings */
> +                       reg = regulators[i].vsel_reg;
> +
> +                       ret = regmap_reg_copy(iodev->regmap,
> +                                             reg + buck_default_idx,
> +                                             reg + buck_old_idx);
> +
> +                       if (ret)
> +                               dev_warn(&pdev->dev, "Copy err %d => %d (%d)\n",
> +                                        reg + buck_old_idx,
> +                                        reg + buck_default_idx, ret);
> +
> +                       regulators[i].vsel_reg += buck_default_idx;
> +               }
> +
>                 rdev = devm_regulator_register(&pdev->dev,
>                                                 &regulators[i], &config);
>                 if (IS_ERR(rdev)) {
> @@ -488,6 +518,10 @@ static int max77686_pmic_probe(struct platform_device *pdev)
>                 }
>         }
>
> +       ret = max77686_setup_gpios(iodev->dev);
> +       if (ret)
> +               return ret;
> +
>         return 0;
>  }
>
> --
> 2.0.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
