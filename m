Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965794Ab3DQGmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:42:00 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:53130 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab3DQGl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:41:59 -0400
Message-ID: <516E4421.3020401@stericsson.com>
Date: Wed, 17 Apr 2013 08:41:37 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] regulator: ab8500: Fix set voltage for AB8540_LDO_AUX3
References: <1366123590.14735.1.camel@phoenix>
In-Reply-To: <1366123590.14735.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 04:46 PM, Axel Lin wrote:
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
Looks fine.Thanks!

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |   69 ++++++++++++++++++++++++++++++++------------
>   1 file changed, 51 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 0a62ef9..84e064b 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -612,32 +612,65 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
>   		return -EINVAL;
>   	}
>   
> +	/* Set the expand register bit for 3.05V.
> +	   Once expand register bit is set, VAUX3 output voltage is set to 3.05V
> +	   regardless of Vaux3Sel settings in register VldoCVaux3Sel.
> +	 */
>   	if (selector >= info->expand_register.voltage_limit) {
> -		/* Vaux3 bit4 has different layout */
> -		regval = (u8)selector << info->expand_register.voltage_shift;
> -		ret = abx500_mask_and_set_register_interruptible(info->dev,
> -					info->expand_register.voltage_bank,
> -					info->expand_register.voltage_reg,
> -					info->expand_register.voltage_mask,
> -					regval);
> -	} else {
> -		/* set the registers for the request */
> -		regval = (u8)selector << info->voltage_shift;
>   		ret = abx500_mask_and_set_register_interruptible(info->dev,
> -				info->voltage_bank, info->voltage_reg,
> -				info->voltage_mask, regval);
> +				info->expand_register.voltage_bank,
> +				info->expand_register.voltage_reg,
> +				info->expand_register.voltage_mask,
> +				info->expand_register.voltage_mask);
> +		if (ret < 0) {
> +			dev_err(rdev_get_dev(rdev),
> +				"couldn't set expand voltage reg for regulator\n");
> +			return ret;
> +		}
> +
> +		dev_vdbg(rdev_get_dev(rdev),
> +			 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +			 info->desc.name, info->expand_register.voltage_bank,
> +			 info->expand_register.voltage_reg,
> +			 info->expand_register.voltage_mask,
> +			 info->expand_register.voltage_mask);
> +
> +		return 0;
>   	}
> -	if (ret < 0)
> +
> +	/* Set target voltage before clearing the expand register bit */
> +	regval = (u8)selector << info->voltage_shift;
> +	ret = abx500_mask_and_set_register_interruptible(info->dev,
> +			info->voltage_bank, info->voltage_reg,
> +			info->voltage_mask, regval);
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
>   			"couldn't set voltage reg for regulator\n");
> +		return ret;
> +	}
>   
>   	dev_vdbg(rdev_get_dev(rdev),
> -			"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
> -			" 0x%x\n",
> -			info->desc.name, info->voltage_bank, info->voltage_reg,
> -			info->voltage_mask, regval);
> +		 "%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->voltage_bank, info->voltage_reg,
> +		 info->voltage_mask, regval);
>   
> -	return ret;
> +	ret = abx500_mask_and_set_register_interruptible(info->dev,
> +			info->expand_register.voltage_bank,
> +			info->expand_register.voltage_reg,
> +			info->expand_register.voltage_mask, 0);
> +	if (ret < 0) {
> +		dev_err(rdev_get_dev(rdev),
> +			"couldn't clear expand voltage reg for regulator\n");
> +		return ret;
> +	}
> +
> +	dev_vdbg(rdev_get_dev(rdev),
> +		 "%s-set_voltage expand (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->expand_register.voltage_bank,
> +		 info->expand_register.voltage_reg,
> +		 info->expand_register.voltage_mask, 0);
> +
> +	return 0;
>   }
>   
>   static struct regulator_ops ab8500_regulator_volt_mode_ops = {

