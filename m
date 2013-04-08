Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab3DHHy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:54:58 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65373 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508Ab3DHHyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:54:55 -0400
Date: Mon, 8 Apr 2013 08:54:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: ab8500-ext: Get rid of is_enabled from
 struct ab8500_ext_regulator_info
Message-ID: <20130408075450.GE3084@gmail.com>
References: <1365347548.9931.1.camel@phoenix>
 <1365347619.9931.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365347619.9931.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Apr 2013, Axel Lin wrote:

> The intention of this patch is to simplify the code.
> 
> Maintain the is_enabled flag is not trivial, it not only needs to set/clear the
> flag in disable()/enable() but also needs to set the flag in is_enable() to get
> initial status. The only benefit of keeping is_enabled flag is just save a
> register read when set_mode(). Remove is_enabled flag makes the code simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Looks fine:

Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  drivers/regulator/ab8500-ext.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 57d43a1..5e604a2 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -29,7 +29,6 @@
>   * @desc: regulator description
>   * @rdev: regulator device
>   * @cfg: regulator configuration (extension of regulator FW configuration)
> - * @is_enabled: status of regulator (on/off)
>   * @update_bank: bank to control on/off
>   * @update_reg: register to control on/off
>   * @update_mask: mask to enable/disable and set mode of regulator
> @@ -46,7 +45,6 @@ struct ab8500_ext_regulator_info {
>  	struct regulator_desc desc;
>  	struct regulator_dev *rdev;
>  	struct ab8500_ext_regulator_cfg *cfg;
> -	bool is_enabled;
>  	u8 update_bank;
>  	u8 update_reg;
>  	u8 update_mask;
> @@ -78,8 +76,6 @@ static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
>  		return ret;
>  	}
>  
> -	info->is_enabled = true;
> -
>  	return ret;
>  }
>  
> @@ -125,8 +121,6 @@ static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
>  		return ret;
>  	}
>  
> -	info->is_enabled = false;
> -
>  	return ret;
>  }
>  
> @@ -177,11 +171,9 @@ static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
>  
>  	if (((regval & info->update_mask) == info->update_val_lp) ||
>  	    ((regval & info->update_mask) == info->update_val_hp))
> -		info->is_enabled = true;
> +		return 1;
>  	else
> -		info->is_enabled = false;
> -
> -	return info->is_enabled;
> +		return 0;
>  }
>  
>  static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
> @@ -207,7 +199,7 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>  		return -EINVAL;
>  	}
>  
> -	if (info->is_enabled) {
> +	if (ab8500_ext_regulator_is_enabled(rdev)) {
>  		u8 regval;
>  
>  		ret = enable(info, &regval);

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
