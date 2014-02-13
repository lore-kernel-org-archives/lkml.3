Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBMMVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:21:40 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:65413 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaBMMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:21:37 -0500
MIME-Version: 1.0
In-Reply-To: <1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
	<1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
Date: Thu, 13 Feb 2014 17:51:36 +0530
Message-ID: <CAKew6eUtuQEHJJ9G+g54LRoH8sXzqixDBUEjCjFyRDJTRP00Nw@mail.gmail.com>
Subject: Re: [PATCH v2 07/14] regulator: s2mps11: Copy supported regulators
 from initconst
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 13, 2014 at 2:44 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Add __initconst to 'regulator_desc' array with supported regulators.
> During probe choose how many and which regulators will be supported
> according to device ID. Then copy the 'regulator_desc' array to
> allocated memory so the regulator core can use it.
>
> Additionally allocate array of of_regulator_match() dynamically (based
> on number of regulators) instead of allocation on the stack.
>
> This is needed for supporting different devices in s2mps11
> driver and actually prepares the regulator driver for supporting the
> S2MPS14 device.
>
> Code for supporting the S2MPS14 device will add its own array of
> 'regulator_desc' (also marked as __initconst). This way memory footprint
> of the driver will be reduced (approximately 'regulators_desc' array for
> S2MPS11 occupies 5 kB on 32-bit ARM, for S2MPS14 will occupy 3 kB).
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>
> ---

Just observed one trivial thing that in this patch, spacing is not
provided before and after multiplication binary operator ( _ * _ ),
which is recommended by linux spacing convention.

Other than that it looks fine to me, pls feel free to add

Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>


Regards,
Yadwinder

>  drivers/regulator/s2mps11.c |   74 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 64 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index d44bd5b3fe8e..246b25d58c2b 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -25,10 +25,9 @@
>  #include <linux/mfd/samsung/core.h>
>  #include <linux/mfd/samsung/s2mps11.h>
>
> -#define S2MPS11_REGULATOR_CNT ARRAY_SIZE(regulators)
> -
>  struct s2mps11_info {
> -       struct regulator_dev *rdev[S2MPS11_REGULATOR_MAX];
> +       struct regulator_dev **rdev;
> +       unsigned int rdev_num;
>
>         int ramp_delay2;
>         int ramp_delay34;
> @@ -345,7 +344,7 @@ static struct regulator_ops s2mps11_buck_ops = {
>         .enable_mask    = S2MPS11_ENABLE_MASK                   \
>  }
>
> -static const struct regulator_desc regulators[] = {
> +static const struct regulator_desc s2mps11_regulators[] __initconst = {
>         regulator_desc_ldo2(1),
>         regulator_desc_ldo1(2),
>         regulator_desc_ldo1(3),
> @@ -396,21 +395,62 @@ static const struct regulator_desc regulators[] = {
>         regulator_desc_buck10,
>  };
>
> +/*
> + * Allocates memory under 'regulators' pointer and copies there array
> + * of regulator_desc for given device.
> + *
> + * Returns number of regulators or negative ERRNO on error.
> + */
> +static int __init
> +s2mps11_pmic_init_regulators_desc(struct platform_device *pdev,
> +               struct regulator_desc **regulators)
> +{
> +       const struct regulator_desc *regulators_init;
> +       enum sec_device_type dev_type;
> +       int rdev_num;
> +
> +       dev_type = platform_get_device_id(pdev)->driver_data;
> +       switch (dev_type) {
> +       case S2MPS11X:
> +               rdev_num = ARRAY_SIZE(s2mps11_regulators);
> +               regulators_init = s2mps11_regulators;
> +               break;
> +       default:
> +               dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
> +               return -EINVAL;
> +       };
> +
> +       *regulators = devm_kzalloc(&pdev->dev, sizeof(**regulators)*rdev_num,
> +                       GFP_KERNEL);
> +       if (!*regulators)
> +               return -ENOMEM;
> +
> +       memcpy(*regulators, regulators_init, sizeof(**regulators)*rdev_num);
> +
> +       return rdev_num;
> +}
> +
>  static int s2mps11_pmic_probe(struct platform_device *pdev)
>  {
>         struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> -       struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
> -       struct of_regulator_match rdata[S2MPS11_REGULATOR_MAX];
> +       struct sec_platform_data *pdata = iodev->pdata;
> +       struct of_regulator_match *rdata = NULL;
>         struct device_node *reg_np = NULL;
>         struct regulator_config config = { };
>         struct s2mps11_info *s2mps11;
>         int i, ret;
> +       struct regulator_desc *regulators = NULL;
> +       unsigned int rdev_num;
>
>         s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
>                                 GFP_KERNEL);
>         if (!s2mps11)
>                 return -ENOMEM;
>
> +       rdev_num = s2mps11_pmic_init_regulators_desc(pdev, &regulators);
> +       if (rdev_num < 0)
> +               return rdev_num;
> +
>         if (!iodev->dev->of_node) {
>                 if (pdata) {
>                         goto common_reg;
> @@ -421,7 +461,16 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
>                 }
>         }
>
> -       for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
> +       s2mps11->rdev = devm_kzalloc(&pdev->dev,
> +                       sizeof(*s2mps11->rdev)*rdev_num, GFP_KERNEL);
> +       if (!s2mps11->rdev)
> +               return -ENOMEM;
> +
> +       rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata)*rdev_num, GFP_KERNEL);
> +       if (!rdata)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < rdev_num; i++)
>                 rdata[i].name = regulators[i].name;
>
>         reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
> @@ -430,15 +479,16 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
> +       of_regulator_match(&pdev->dev, reg_np, rdata, rdev_num);
>
>  common_reg:
>         platform_set_drvdata(pdev, s2mps11);
> +       s2mps11->rdev_num = rdev_num;
>
>         config.dev = &pdev->dev;
>         config.regmap = iodev->regmap_pmic;
>         config.driver_data = s2mps11;
> -       for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
> +       for (i = 0; i < rdev_num; i++) {
>                 if (!reg_np) {
>                         config.init_data = pdata->regulators[i].initdata;
>                         config.of_node = pdata->regulators[i].reg_node;
> @@ -457,11 +507,15 @@ common_reg:
>                 }
>         }
>
> +       /* rdata was needed only for of_regulator_match() during probe */
> +       if (rdata)
> +               devm_kfree(&pdev->dev, rdata);
> +
>         return 0;
>  }
>
>  static const struct platform_device_id s2mps11_pmic_id[] = {
> -       { "s2mps11-pmic", 0},
> +       { "s2mps11-pmic", S2MPS11X},
>         { },
>  };
>  MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
> --
> 1.7.9.5
>
