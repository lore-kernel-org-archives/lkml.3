Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3DQKJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:09:54 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53494 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab3DQKJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:09:53 -0400
Message-ID: <516E6FEC.9030401@stericsson.com>
Date: Wed, 17 Apr 2013 11:48:28 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: ab8500: Don't update info->update_val
 if write to register fails
References: <1365509706.3801.1.camel@phoenix>
In-Reply-To: <1365509706.3801.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:15 PM, Axel Lin wrote:
> This patch ensures info->update_val is consistent with current register value.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good to me.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |   20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index acdffc5..1866dbf 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -392,9 +392,8 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   			val = info->mode_val_idle;
>   			break;
>   		default:
> -			if (info->shared_mode)
> -				mutex_unlock(&shared_mode_mutex);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto out_unlock;
>   		}
>   
>   		bank = info->mode_bank;
> @@ -405,17 +404,14 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   
>   		switch (mode) {
>   		case REGULATOR_MODE_NORMAL:
> -			info->update_val = info->update_val_normal;
>   			val = info->update_val_normal;
>   			break;
>   		case REGULATOR_MODE_IDLE:
> -			info->update_val = info->update_val_idle;
>   			val = info->update_val_idle;
>   			break;
>   		default:
> -			if (info->shared_mode)
> -				mutex_unlock(&shared_mode_mutex);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto out_unlock;
>   		}
>   
>   		bank = info->update_bank;
> @@ -426,9 +422,11 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   	if (dmr || ab8500_regulator_is_enabled(rdev)) {
>   		ret = abx500_mask_and_set_register_interruptible(info->dev,
>   			bank, reg, mask, val);
> -		if (ret < 0)
> +		if (ret < 0) {
>   			dev_err(rdev_get_dev(rdev),
>   				"couldn't set regulator mode\n");
> +			goto out_unlock;
> +		}
>   
>   		dev_vdbg(rdev_get_dev(rdev),
>   			"%s-set_mode (bank, reg, mask, value): "
> @@ -437,6 +435,10 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   			mask, val);
>   	}
>   
> +	if (!dmr)
> +		info->update_val = val;
> +
> +out_unlock:
>   	if (info->shared_mode)
>   		mutex_unlock(&shared_mode_mutex);
>   

