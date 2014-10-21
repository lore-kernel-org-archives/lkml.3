Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaJUMA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:00:28 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41216 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:00:26 -0400
Message-ID: <54464ACF.7000805@collabora.co.uk>
Date: Tue, 21 Oct 2014 14:00:15 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 2/4] regulator: max77686: Implement suspend disable
 for some LDOs
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com> <1413890597-31037-3-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1413890597-31037-3-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/21/2014 01:23 PM, Krzysztof Kozlowski wrote:
> Some LDOs of Maxim 77686 PMIC support disabling during system suspend
> (LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
> of set_suspend_mode function. In that case the mode was one of:
>  - disable,
>  - normal mode,
>  - low power mode.
> However there are no bindings for setting the mode during suspend.
> 
> Add suspend disable for LDO regulators supporting this to the existing
> max77686_buck_set_suspend_disable() function. This helps reducing
> energy consumption during system sleep.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/max77686.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index cffe0c69d57d..05df72d584bf 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -79,17 +79,33 @@ struct max77686_data {
>  };
>  
>  /* Some BUCKS supports Normal[ON/OFF] mode during suspend */
> -static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
> +static int max77686_set_suspend_disable(struct regulator_dev *rdev)
>  {
>  	unsigned int val;
>  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
>  	int ret, id = rdev_get_id(rdev);
>  
> -	if (id == MAX77686_BUCK1)
> +	switch (id) {
> +	case MAX77686_BUCK1:
>  		val = MAX77686_OPMODE_OFF_PWRREQ;
> -	else
> +		break;
> +	case MAX77686_BUCK2:
> +	case MAX77686_BUCK3:
> +	case MAX77686_BUCK4:
>  		val = MAX77686_OPMODE_OFF_PWRREQ
>  			<< MAX77686_OPMODE_BUCK234_SHIFT;
> +		break;
> +	case MAX77686_LDO2:
> +	case MAX77686_LDO6 ... MAX77686_LDO8:
> +	case MAX77686_LDO10 ... MAX77686_LDO12:
> +	case MAX77686_LDO14 ... MAX77686_LDO16:
> +		val = MAX77686_OPMODE_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
> +		break;
> +	default:
> +		pr_warn("%s: regulator_suspend_disable not supported\n",
> +			rdev->desc->name);
> +		return -EINVAL;
> +	}
>  
>  	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  				 rdev->desc->enable_mask, val);
> @@ -171,6 +187,9 @@ static int max77686_enable(struct regulator_dev *rdev)
>  {
>  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
>  
> +	if (max77686->opmode[rdev_get_id(rdev)] == MAX77686_OPMODE_OFF_PWRREQ)
> +		max77686->opmode[rdev_get_id(rdev)] = MAX77686_OPMODE_NORMAL;
> +
>  	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  				  rdev->desc->enable_mask,
>  				  max77686->opmode[rdev_get_id(rdev)]);
> @@ -223,6 +242,8 @@ static struct regulator_ops max77686_ldo_ops = {
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
>  	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
> +	.set_suspend_disable	= max77686_set_suspend_disable,
> +	.set_suspend_enable	= max77686_enable,
>  };
>  
>  static struct regulator_ops max77686_buck1_ops = {
> @@ -234,7 +255,8 @@ static struct regulator_ops max77686_buck1_ops = {
>  	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
> -	.set_suspend_disable	= max77686_buck_set_suspend_disable,
> +	.set_suspend_disable	= max77686_set_suspend_disable,
> +	.set_suspend_enable	= max77686_enable,
>  };
>  
>  static struct regulator_ops max77686_buck_dvs_ops = {
> @@ -247,7 +269,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
>  	.set_ramp_delay		= max77686_set_ramp_delay,
> -	.set_suspend_disable	= max77686_buck_set_suspend_disable,
> +	.set_suspend_disable	= max77686_set_suspend_disable,
> +	.set_suspend_enable	= max77686_enable,
>  };
>  
>  #define regulator_desc_ldo(num)		{				\
> 

Looks good to me.

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
