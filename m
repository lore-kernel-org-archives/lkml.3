Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJ0KJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:09:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57086 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaJ0KJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:09:01 -0400
Message-ID: <544E19A4.6040603@collabora.co.uk>
Date: Mon, 27 Oct 2014 11:08:36 +0100
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
Subject: Re: [PATCH v4 2/3] regulator: max77686: Implement suspend disable
 for some LDOs
References: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com> <1414403066-7872-3-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414403066-7872-3-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/27/2014 10:44 AM, Krzysztof Kozlowski wrote:
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
>  drivers/regulator/max77686.c | 75 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 66 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index 3d0922051488..4b35c19c9286 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -87,18 +87,31 @@ struct max77686_data {
>  	unsigned int opmode[MAX77686_REGULATORS];
>  };
>  
> -/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
> -static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
> +/* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
> +static int max77686_set_suspend_disable(struct regulator_dev *rdev)
>  {
>  	unsigned int val;
>  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
>  	int ret, id = rdev_get_id(rdev);
>  
> -	if (id == MAX77686_BUCK1)
> +	switch (id) {
> +	case MAX77686_BUCK1:
>  		val = MAX77686_BUCK_OFF_PWRREQ;
> -	else
> -		val = MAX77686_BUCK_OFF_PWRREQ
> -			<< MAX77686_OPMODE_BUCK234_SHIFT;
> +		break;
> +	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
> +		val = MAX77686_BUCK_OFF_PWRREQ << MAX77686_OPMODE_BUCK234_SHIFT;
> +		break;
> +	case MAX77686_LDO2:
> +	case MAX77686_LDO6 ... MAX77686_LDO8:
> +	case MAX77686_LDO10 ... MAX77686_LDO12:
> +	case MAX77686_LDO14 ... MAX77686_LDO16:
> +		val = MAX77686_LDO_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
> +		break;
> +	default:
> +		pr_warn("%s: regulator_suspend_disable not supported\n",
> +			rdev->desc->name);
> +		return -EINVAL;
> +	}
>  
>  	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  				 rdev->desc->enable_mask, val);
> @@ -176,13 +189,53 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
>  	return 0;
>  }
>  
> +/*
> + * For regulators supporting disabled in suspend it checks if opmode
> + * is 'off_pwrreq' mode (disabled in suspend) and changes it to 'enable'.
> + * For other regulators does nothing.
> + */
> +static void max77686_set_opmode_enable(struct max77686_data *max77686, int id)
> +{
> +	unsigned int opmode_shift;
> +
> +	/*
> +	 * Same enable function is used for LDO and bucks. Assuming
> +	 * the same values are used for enable registers.
> +	 */
> +	BUILD_BUG_ON(MAX77686_LDO_OFF_PWRREQ != MAX77686_BUCK_OFF_PWRREQ);
> +	BUILD_BUG_ON(MAX77686_LDO_NORMAL != MAX77686_BUCK_NORMAL);
> +
> +	switch (id) {
> +	case MAX77686_BUCK1:
> +		opmode_shift = 0;
> +		break;
> +	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
> +		opmode_shift = MAX77686_OPMODE_BUCK234_SHIFT;
> +		break;
> +	case MAX77686_LDO2:
> +	case MAX77686_LDO6 ... MAX77686_LDO8:
> +	case MAX77686_LDO10 ... MAX77686_LDO12:
> +	case MAX77686_LDO14 ... MAX77686_LDO16:
> +		opmode_shift = MAX77686_OPMODE_SHIFT;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (max77686->opmode[id] == (MAX77686_LDO_OFF_PWRREQ << opmode_shift))
> +		max77686->opmode[id] = MAX77686_LDO_NORMAL << opmode_shift;
> +}
> +
>  static int max77686_enable(struct regulator_dev *rdev)
>  {
>  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +
> +	max77686_set_opmode_enable(max77686, id);
>  
>  	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  				  rdev->desc->enable_mask,
> -				  max77686->opmode[rdev_get_id(rdev)]);
> +				  max77686->opmode[id]);
>  }

the max77802 driver handles this slightly differently. It stores in opmode[id]
just the value without the shift and there is a max77802_get_opmode_shift() to
obtain the shift that is used before updating the register, e.g:

int shift = max77802_get_opmode_shift(id);
return regmap_update_bits(..., max77802->opmode[id] << shift);

I think the max77802 driver approach is better since it avoids duplicating the
switch statement to get the shift for each regulator. Just look how the max77802
enable and disable functions are easier to read. Looking at the max77686 driver,
I see that there are assumptions that opmode[id] has the value shifted so your
changes are consistent with the rest of the driver but I would consider changing
this.

Best regards,
Javier


