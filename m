Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966125Ab3DQJtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:49:46 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:51448 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965780Ab3DQJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:49:45 -0400
Message-ID: <516E7025.8040508@stericsson.com>
Date: Wed, 17 Apr 2013 11:49:25 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: ab8500: Don't update lp_mode_req flag
 in set_mode() error paths
References: <1365509706.3801.1.camel@phoenix> <1365509835.3801.3.camel@phoenix>
In-Reply-To: <1365509835.3801.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:17 PM, Axel Lin wrote:
> Currently, set invalid mode setting for shared mode regulators may change
> sm->lp_mode_req flag. This patch ensures we don't set lp_mode_req flag to wrong
> status if set_mode() fails.
>
> This patch includes some clean up, and these changes makes this patch looks like
> code refactor. The clean up is mainly to avoid adding ugly code to handle
> failure paths.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks fine.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |   98 +++++++++++++++++++-------------------------
>   1 file changed, 43 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 1866dbf..88ab408 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -348,11 +348,8 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   				     unsigned int mode)
>   {
>   	int ret = 0;
> -	u8 bank;
> -	u8 reg;
> -	u8 mask;
> -	u8 val;
> -	bool dmr = false; /* Dedicated mode register */
> +	u8 bank, reg, mask, val;
> +	bool lp_mode_req = false;
>   	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
>   
>   	if (info == NULL) {
> @@ -360,66 +357,54 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   		return -EINVAL;
>   	}
>   
> -	if (info->shared_mode) {
> -		/*
> -		 * Special case where mode is shared between two regulators.
> -		 */
> -		struct ab8500_shared_mode *sm = info->shared_mode;
> -		mutex_lock(&shared_mode_mutex);
> -
> -		if (mode == REGULATOR_MODE_IDLE) {
> -			sm->lp_mode_req = true; /* Low power mode requested */
> -			if (!((sm->shared_regulator)->
> -			      shared_mode->lp_mode_req)) {
> -				mutex_unlock(&shared_mode_mutex);
> -				return 0; /* Other regulator prevent LP mode */
> -			}
> -		} else {
> -			sm->lp_mode_req = false;
> -		}
> -	}
> -
>   	if (info->mode_mask) {
> -		/* Dedicated register for handling mode */
> -
> -		dmr = true;
> -
> -		switch (mode) {
> -		case REGULATOR_MODE_NORMAL:
> -			val = info->mode_val_normal;
> -			break;
> -		case REGULATOR_MODE_IDLE:
> -			val = info->mode_val_idle;
> -			break;
> -		default:
> -			ret = -EINVAL;
> -			goto out_unlock;
> -		}
> -
>   		bank = info->mode_bank;
>   		reg = info->mode_reg;
>   		mask = info->mode_mask;
>   	} else {
> -		/* Mode register same as enable register */
> +		bank = info->update_bank;
> +		reg = info->update_reg;
> +		mask = info->update_mask;
> +	}
> +
> +	if (info->shared_mode)
> +		mutex_lock(&shared_mode_mutex);
>   
> -		switch (mode) {
> -		case REGULATOR_MODE_NORMAL:
> +	switch (mode) {
> +	case REGULATOR_MODE_NORMAL:
> +		if (info->shared_mode)
> +			lp_mode_req = false;
> +
> +		if (info->mode_mask)
> +			val = info->mode_val_normal;
> +		else
>   			val = info->update_val_normal;
> -			break;
> -		case REGULATOR_MODE_IDLE:
> -			val = info->update_val_idle;
> -			break;
> -		default:
> -			ret = -EINVAL;
> -			goto out_unlock;
> +		break;
> +	case REGULATOR_MODE_IDLE:
> +		if (info->shared_mode) {
> +			struct ab8500_regulator_info *shared_regulator;
> +
> +			shared_regulator = info->shared_mode->shared_regulator;
> +			if (!shared_regulator->shared_mode->lp_mode_req) {
> +				/* Other regulator prevent LP mode */
> +				info->shared_mode->lp_mode_req = true;
> +				goto out_unlock;
> +			}
> +
> +			lp_mode_req = true;
>   		}
>   
> -		bank = info->update_bank;
> -		reg = info->update_reg;
> -		mask = info->update_mask;
> +		if (info->mode_mask)
> +			val = info->mode_val_idle;
> +		else
> +			val = info->update_val_idle;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto out_unlock;
>   	}
>   
> -	if (dmr || ab8500_regulator_is_enabled(rdev)) {
> +	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
>   		ret = abx500_mask_and_set_register_interruptible(info->dev,
>   			bank, reg, mask, val);
>   		if (ret < 0) {
> @@ -435,9 +420,12 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
>   			mask, val);
>   	}
>   
> -	if (!dmr)
> +	if (!info->mode_mask)
>   		info->update_val = val;
>   
> +	if (info->shared_mode)
> +		info->shared_mode->lp_mode_req = lp_mode_req;
> +
>   out_unlock:
>   	if (info->shared_mode)
>   		mutex_unlock(&shared_mode_mutex);

