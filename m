Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965947Ab3DQHQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:16:16 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:52800 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965736Ab3DQHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:16:15 -0400
Message-ID: <516E4C35.9090500@stericsson.com>
Date: Wed, 17 Apr 2013 09:16:05 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] regulator: ab8500: Fix set voltage for AB8540_LDO_AUX3
References: <1366131020.7842.1.camel@phoenix>
In-Reply-To: <1366131020.7842.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 06:50 PM, Axel Lin wrote:
> When setting voltage for AB8540_LDO_AUX3, current code only updates one of
> info->voltage_reg and info->expand_register registers which is wrong.
> To ensure we set to correct voltage, it always needs to clear or set
> expand_register.voltage_mask bit of expand_register.
>
> The function of the expand register bit is the following (from the user manual):
> 0: VAUX3 output voltage is determined by Vaux3Sel bit settings in register
>     VldoCVaux3Sel
> 1: VAUX3 output voltage is set to 3.05V regardless of Vaux3Sel settings in
>     register VldoCVaux3Sel (VldoCVaux3Sel is the register at 0x0421)
>
> So when going to 3.05V, set the expand register bit.
> When leaving 3.05V for another voltage, set the target voltage before clearing
> the expand register bit.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> v3: Just coding style change (compare to v2), to make the code smaller.
Even better.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>
> Axel
>   drivers/regulator/ab8500.c |   53 +++++++++++++++++++++++++++-----------------
>   1 file changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 0a62ef9..979c8ea 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -605,39 +605,52 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
>   {
>   	int ret;
>   	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
> -	u8 regval;
> +	u8 regval, regval_expand;
>   
>   	if (info == NULL) {
>   		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
>   		return -EINVAL;
>   	}
>   
> -	if (selector >= info->expand_register.voltage_limit) {
> -		/* Vaux3 bit4 has different layout */
> -		regval = (u8)selector << info->expand_register.voltage_shift;
> -		ret = abx500_mask_and_set_register_interruptible(info->dev,
> -					info->expand_register.voltage_bank,
> -					info->expand_register.voltage_reg,
> -					info->expand_register.voltage_mask,
> -					regval);
> -	} else {
> -		/* set the registers for the request */
> +	if (selector < info->expand_register.voltage_limit) {
>   		regval = (u8)selector << info->voltage_shift;
>   		ret = abx500_mask_and_set_register_interruptible(info->dev,
> -				info->voltage_bank, info->voltage_reg,
> -				info->voltage_mask, regval);
> +					info->voltage_bank, info->voltage_reg,
> +					info->voltage_mask, regval);
> +		if (ret < 0) {
> +			dev_err(rdev_get_dev(rdev),
> +				"couldn't set voltage reg for regulator\n");
> +			return ret;
> +		}
> +
> +		dev_vdbg(rdev_get_dev(rdev),
> +			 "%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +			 info->desc.name, info->voltage_bank, info->voltage_reg,
> +			 info->voltage_mask, regval);
> +
> +		regval_expand = 0;
> +	} else {
> +		regval_expand = info->expand_register.voltage_mask;
>   	}
> -	if (ret < 0)
> +
> +	ret = abx500_mask_and_set_register_interruptible(info->dev,
> +				info->expand_register.voltage_bank,
> +				info->expand_register.voltage_reg,
> +				info->expand_register.voltage_mask,
> +				regval_expand);
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
> -			"couldn't set voltage reg for regulator\n");
> +			"couldn't set expand voltage reg for regulator\n");
> +		return ret;
> +	}
>   
>   	dev_vdbg(rdev_get_dev(rdev),
> -			"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
> -			" 0x%x\n",
> -			info->desc.name, info->voltage_bank, info->voltage_reg,
> -			info->voltage_mask, regval);
> +		 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->expand_register.voltage_bank,
> +		 info->expand_register.voltage_reg,
> +		 info->expand_register.voltage_mask, regval_expand);
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static struct regulator_ops ab8500_regulator_volt_mode_ops = {

