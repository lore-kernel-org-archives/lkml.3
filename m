Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966211Ab3DQIwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:52:17 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41755 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965934Ab3DQIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:52:15 -0400
Message-ID: <516E62B6.7050009@stericsson.com>
Date: Wed, 17 Apr 2013 10:52:06 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] regulator: ab8500-ext: Remove enable() and disable()
 functions
References: <1366126152.14735.2.camel@phoenix> <1366126380.14735.4.camel@phoenix>
In-Reply-To: <1366126380.14735.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 05:33 PM, Axel Lin wrote:
> Both enable() and disable() functions have only one caller, thus remove them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks fine.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500-ext.c |   64 +++++++++++++++-------------------------
>   1 file changed, 23 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 03faf9c..b4d4547 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -54,32 +54,44 @@ struct ab8500_ext_regulator_info {
>   	u8 update_val_hw;
>   };
>   
> -static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
> +static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
>   {
>   	int ret;
> +	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
> +	u8 regval;
>   
> -	*regval = info->update_val;
> +	if (info == NULL) {
> +		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
> +		return -EINVAL;
> +	}
>   
>   	/*
>   	 * To satisfy both HW high power request and SW request, the regulator
>   	 * must be on in high power.
>   	 */
>   	if (info->cfg && info->cfg->hwreq)
> -		*regval = info->update_val_hp;
> +		regval = info->update_val_hp;
> +	else
> +		regval = info->update_val;
>   
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
> -		info->update_mask, *regval);
> +		info->update_mask, regval);
>   	if (ret < 0) {
>   		dev_err(rdev_get_dev(info->rdev),
>   			"couldn't set enable bits for regulator\n");
>   		return ret;
>   	}
>   
> -	return ret;
> +	dev_dbg(rdev_get_dev(rdev),
> +		"%s-enable (bank, reg, mask, value): 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
> +		info->desc.name, info->update_bank, info->update_reg,
> +		info->update_mask, regval);
> +
> +	return 0;
>   }
>   
> -static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
> +static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
>   {
>   	int ret;
>   	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
> @@ -90,59 +102,29 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
>   		return -EINVAL;
>   	}
>   
> -	ret = enable(info, &regval);
> -
> -	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
> -		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
> -		info->desc.name, info->update_bank, info->update_reg,
> -		info->update_mask, regval);
> -
> -	return ret;
> -}
> -
> -static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
> -{
> -	int ret;
> -
> -	*regval = 0x0;
> -
>   	/*
>   	 * Set the regulator in HW request mode if configured
>   	 */
>   	if (info->cfg && info->cfg->hwreq)
> -		*regval = info->update_val_hw;
> +		regval = info->update_val_hw;
> +	else
> +		regval = 0;
>   
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
> -		info->update_mask, *regval);
> +		info->update_mask, regval);
>   	if (ret < 0) {
>   		dev_err(rdev_get_dev(info->rdev),
>   			"couldn't set disable bits for regulator\n");
>   		return ret;
>   	}
>   
> -	return ret;
> -}
> -
> -static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
> -{
> -	int ret;
> -	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
> -	u8 regval;
> -
> -	if (info == NULL) {
> -		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
> -		return -EINVAL;
> -	}
> -
> -	ret = disable(info, &regval);
> -
>   	dev_dbg(rdev_get_dev(rdev), "%s-disable (bank, reg, mask, value):"
>   		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
>   		info->desc.name, info->update_bank, info->update_reg,
>   		info->update_mask, regval);
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)

