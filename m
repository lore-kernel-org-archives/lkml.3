Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3C1JB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:01:59 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:40143 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3C1JB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:01:57 -0400
Message-ID: <51540685.8090803@stericsson.com>
Date: Thu, 28 Mar 2013 09:59:49 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500: Update info->update_val only when
 successfully update register
References: <1364460015.10816.2.camel@phoenix>
In-Reply-To: <1364460015.10816.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 09:40 AM, Axel Lin wrote:
> This fixes 2 issues:
>
> 1. Don't update info->update_val if write to the register fails.
> 2. Don't update info->update_val if regulator is disabled, this avoid
>     inconsistent status between the register value and info->update_val.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks fine, thanks.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |   41 +++++++++++++++++++++++++----------------
>   1 file changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 12e2740..8b86604 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -182,8 +182,8 @@ static unsigned int ab8500_regulator_get_optimum_mode(
>   static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   				     unsigned int mode)
>   {
> -	int ret = 0;
> -
> +	int ret;
> +	u8 update_val;
>   	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
>   
>   	if (info == NULL) {
> @@ -191,32 +191,41 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   		return -EINVAL;
>   	}
>   
> +	/* ab8500 regulators share mode and enable in the same register bits.
> +	   off = 0b00
> +	   low power mode= 0b11
> +	   full powermode = 0b01
> +	   (HW control mode = 0b10)
> +	   Thus we don't change the mode settings when regulator is disabled.
> +	 */
> +	if (!info->is_enabled)
> +		return 0;
> +
>   	switch (mode) {
>   	case REGULATOR_MODE_NORMAL:
> -		info->update_val = info->update_val_normal;
> +		update_val = info->update_val_normal;
>   		break;
>   	case REGULATOR_MODE_IDLE:
> -		info->update_val = info->update_val_idle;
> +		update_val = info->update_val_idle;
>   		break;
>   	default:
>   		return -EINVAL;
>   	}
>   
> -	if (info->is_enabled) {
> -		ret = abx500_mask_and_set_register_interruptible(info->dev,
> +	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   			info->update_bank, info->update_reg,
> -			info->update_mask, info->update_val);
> -		if (ret < 0)
> -			dev_err(rdev_get_dev(rdev),
> -				"couldn't set regulator mode\n");
> -
> -		dev_vdbg(rdev_get_dev(rdev),
> -			"%s-set_mode (bank, reg, mask, value): "
> -			"0x%x, 0x%x, 0x%x, 0x%x\n",
> -			info->desc.name, info->update_bank, info->update_reg,
> -			info->update_mask, info->update_val);
> +			info->update_mask, update_val);
> +	if (ret < 0) {
> +		dev_err(rdev_get_dev(rdev), "couldn't set regulator mode\n");
> +		return ret;
>   	}
>   
> +	info->update_val = update_val;
> +
> +	dev_vdbg(rdev_get_dev(rdev), "%s-set_mode (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
> +		 info->desc.name, info->update_bank, info->update_reg,
> +		 info->update_mask, info->update_val);
> +
>   	return ret;
>   }
>   

