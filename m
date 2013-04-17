Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966198Ab3DQIvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:51:42 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:35391 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965934Ab3DQIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:51:38 -0400
Message-ID: <516E628E.10805@stericsson.com>
Date: Wed, 17 Apr 2013 10:51:26 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] regulator: ab8500-ext: Don't update info->update_val
 if set_mode() fails
References: <1366126152.14735.2.camel@phoenix>
In-Reply-To: <1366126152.14735.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 05:29 PM, Axel Lin wrote:
> This ensures info->update_val status is still correct if set_mode() call fails.
> Otherwise, get_mode() may return wrong status if a set_mode() call fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks fine.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500-ext.c |   26 ++++++++++++++++++--------
>   1 file changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 20680f3..03faf9c 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -181,6 +181,7 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   {
>   	int ret = 0;
>   	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
> +	u8 regval;
>   
>   	if (info == NULL) {
>   		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
> @@ -189,23 +190,30 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   
>   	switch (mode) {
>   	case REGULATOR_MODE_NORMAL:
> -		info->update_val = info->update_val_hp;
> +		regval = info->update_val_hp;
>   		break;
>   	case REGULATOR_MODE_IDLE:
> -		info->update_val = info->update_val_lp;
> +		regval = info->update_val_lp;
>   		break;
>   
>   	default:
>   		return -EINVAL;
>   	}
>   
> -	if (ab8500_ext_regulator_is_enabled(rdev)) {
> -		u8 regval;
> -
> -		ret = enable(info, &regval);
> -		if (ret < 0)
> +	/* If regulator is enabled and info->cfg->hwreq is set, the regulator
> +	   must be on in high power, so we don't need to write the register with
> +	   the same value.
> +	 */
> +	if (ab8500_ext_regulator_is_enabled(rdev) &&
> +	    !(info->cfg && info->cfg->hwreq)) {
> +		ret = abx500_mask_and_set_register_interruptible(info->dev,
> +					info->update_bank, info->update_reg,
> +					info->update_mask, regval);
> +		if (ret < 0) {
>   			dev_err(rdev_get_dev(rdev),
>   				"Could not set regulator mode.\n");
> +			return ret;
> +		}
>   
>   		dev_dbg(rdev_get_dev(rdev),
>   			"%s-set_mode (bank, reg, mask, value): "
> @@ -214,7 +222,9 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   			info->update_mask, regval);
>   	}
>   
> -	return ret;
> +	info->update_val = regval;
> +
> +	return 0;
>   }
>   
>   static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)

