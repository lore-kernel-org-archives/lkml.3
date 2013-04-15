Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3DOIDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:03:30 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:50191 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224Ab3DOID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:03:27 -0400
Message-ID: <516BB444.7010508@stericsson.com>
Date: Mon, 15 Apr 2013 10:03:16 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
References: <1365424274.21989.2.camel@phoenix>
In-Reply-To: <1365424274.21989.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 02:31 PM, Axel Lin wrote:
> The special handling code for getting shared mode status is wrong
> because it needs to check info->shared_mode->lp_mode_req for
> both regulators that shared the same mode register.
>
> In set_mode(), current code ensures we won't set mode to REGULATOR_MODE_IDLE
> if only one of the regulator requests to set idle.
>
> In get_mode(), we can just remove the special handling code for shared mode.
> Read the register value always returns correct status no matter the regulator
> has shared mode register or not.
I am not convinced about this patch. The purpose of the original code is 
that the regulator framework should be unaware that the mode register is 
shared with another regulator. If we apply this patch, get_mode may 
return different results depending on the other regulators mode settings.

Let me take an example: The other shared regulator is already set to LP 
mode and the current regulator is requested to low power mode. Then the 
framework first checks current mode and compares to requested mode. If 
equal, it returns. With this patch applied, it will see that the 
regulator is already set to LP mode and return without calling set_mode 
in the driver. However, the state information in the driver will be 
wrong so when the other regulator is requested to HP mode and back to LP 
mode it will not actually set LP mode again to HW.

Regards,

Bengt
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/ab8500.c |    8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 9ebd131..acdffc5 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -456,14 +456,6 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
>   		return -EINVAL;
>   	}
>   
> -	/* Need special handling for shared mode */
> -	if (info->shared_mode) {
> -		if (info->shared_mode->lp_mode_req)
> -			return REGULATOR_MODE_IDLE;
> -		else
> -			return REGULATOR_MODE_NORMAL;
> -	}
> -
>   	if (info->mode_mask) {
>   		/* Dedicated register for handling mode */
>   		ret = abx500_get_register_interruptible(info->dev,

