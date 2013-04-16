Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab3DPLMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:12:41 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:49789 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab3DPLMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:12:39 -0400
Message-ID: <516D321F.5090704@stericsson.com>
Date: Tue, 16 Apr 2013 13:12:31 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 2/2] regulator: ab8500: Optimize ab8540_aux3_regulator_get_voltage_sel
References: <1365576052.4283.2.camel@phoenix> <1365576380.4283.5.camel@phoenix>
In-Reply-To: <1365576380.4283.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 08:46 AM, Axel Lin wrote:
> We can save a register read operation in some case if read
> expand_register first.
> If info->expand_register.voltage_mask bit is set, no need to read
> voltage_reg.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |   42 ++++++++++++++++++------------------------
>   1 file changed, 18 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 222a63e..7a86fe6 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -521,7 +521,7 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
>   
>   static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
>   {
> -	int ret, val;
> +	int ret;
>   	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
>   	u8 regval, regval_expand;
>   
> @@ -531,18 +531,25 @@ static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
>   	}
>   
>   	ret = abx500_get_register_interruptible(info->dev,
> -			info->voltage_bank, info->voltage_reg, &regval);
> -
> +			info->expand_register.voltage_bank,
> +			info->expand_register.voltage_reg, &regval_expand);
>   	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
> -			"couldn't read voltage reg for regulator\n");
> +			"couldn't read voltage expand reg for regulator\n");
>   		return ret;
>   	}
>   
> -	ret = abx500_get_register_interruptible(info->dev,
> -			info->expand_register.voltage_bank,
> -			info->expand_register.voltage_reg, &regval_expand);
> +	dev_vdbg(rdev_get_dev(rdev),
> +		 "%s-get_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->expand_register.voltage_bank,
> +		 info->expand_register.voltage_reg,
> +		 info->expand_register.voltage_mask, regval_expand);
> +
> +	if (regval_expand & info->expand_register.voltage_mask)
> +		return info->expand_register.voltage_limit;
>   
> +	ret = abx500_get_register_interruptible(info->dev,
> +			info->voltage_bank, info->voltage_reg, &regval);
>   	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
>   			"couldn't read voltage reg for regulator\n");
> @@ -550,24 +557,11 @@ static int ab8540_aux3_regulator_get_voltage_sel(struct regulator_dev *rdev)
>   	}
>   
>   	dev_vdbg(rdev_get_dev(rdev),
> -		"%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
> -		" 0x%x\n",
> -		info->desc.name, info->voltage_bank, info->voltage_reg,
> -		info->voltage_mask, regval);
> -	dev_vdbg(rdev_get_dev(rdev),
> -		"%s-get_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
> -		" 0x%x\n",
> -		info->desc.name, info->expand_register.voltage_bank,
> -		info->expand_register.voltage_reg,
> -		info->expand_register.voltage_mask, regval_expand);
> -
> -	if (regval_expand&(info->expand_register.voltage_mask))
> -		/* Vaux3 has a different layout */
> -		val = info->expand_register.voltage_limit;
> -	else
> -		val = (regval & info->voltage_mask) >> info->voltage_shift;
> +		 "%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->voltage_bank, info->voltage_reg,
> +		 info->voltage_mask, regval);
>   
> -	return val;
> +	return (regval & info->voltage_mask) >> info->voltage_shift;
>   }
>   
>   static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,

