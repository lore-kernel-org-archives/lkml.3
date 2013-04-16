Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3DPMZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:25:34 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:47941 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab3DPMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:25:33 -0400
Message-ID: <516D432C.1030904@stericsson.com>
Date: Tue, 16 Apr 2013 14:25:16 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH 2/3] regulator: ab8500-ext: Don't update info->update_val
 if set_mode() fails
References: <1365598464.24689.1.camel@phoenix> <1365598520.24689.2.camel@phoenix>
In-Reply-To: <1365598520.24689.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:55 PM, Axel Lin wrote:
> This ensures info->update_val status is still correct if set_mode() call fails.
> Otherwise, get_mode() may return wrong status if a set_mode() call fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/ab8500-ext.c |   19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index f0a1bbf..1efe702 100644
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
> @@ -189,14 +190,14 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   
>   	switch (mode) {
>   	case REGULATOR_MODE_NORMAL:
> -		info->update_val = info->update_val_hp;
> +		regval = info->update_val_hp;
>   		break;
>   	case REGULATOR_MODE_IDLE:
>   		/* Always on with high power mode if info->cfg->hwreq is set */
>   		if (info->cfg && info->cfg->hwreq)
>   			return -EINVAL;
>   
> -		info->update_val = info->update_val_lp;
> +		regval = info->update_val_lp;
>   		break;
>   
>   	default:
> @@ -204,12 +205,14 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   	}
>   
>   	if (ab8500_ext_regulator_is_enabled(rdev)) {
> -		u8 regval;
> -
> -		ret = enable(info, &regval);
> -		if (ret < 0)
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
> @@ -218,7 +221,9 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
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
This patch is needed to fix the error path but it partly depends on the 
previous patch so I would like to get that one sorted out before ack-ing 
this patch.

Regards,

Bengt
