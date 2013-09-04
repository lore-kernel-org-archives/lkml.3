Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788Ab3IDOcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:32:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45358 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762720Ab3IDOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:32:16 -0400
X-Auth-Info: f659IZDRuaNr2zp/dc+CowPtW3AXewlHX+sTws5QYEA=
From: Marek Vasut <marex@denx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 5/7] regulator: palmas: Use devm_regulator_register
Date: Wed, 4 Sep 2013 16:32:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, Nancy.Chen@freescale.com
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1378276263-10735-5-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201309041632.13150.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sachin Kamat,

> devm_* simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/regulator/palmas-regulator.c |   38
> ++++++++++------------------------ 1 file changed, 11 insertions(+), 27
> deletions(-)
> 
> diff --git a/drivers/regulator/palmas-regulator.c
> b/drivers/regulator/palmas-regulator.c index d0c8785..37b1068 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -852,7 +852,7 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) if (ret < 0) {
>  				dev_err(&pdev->dev,
>  					"reading TSTEP reg failed: %d\n", ret);
> -				goto err_unregister_regulator;
> +				return ret;
>  			}
>  			pmic->desc[id].ramp_delay =
>  					palmas_smps_ramp_delay[reg & 0x3];
> @@ -864,7 +864,7 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) reg_init = pdata->reg_init[id];
>  			ret = palmas_smps_init(palmas, id, reg_init);
>  			if (ret)
> -				goto err_unregister_regulator;
> +				return ret;
>  		}
> 
>  		/* Register the regulators */
> @@ -897,7 +897,7 @@ static int palmas_regulators_probe(struct
> platform_device *pdev)
> 
>  			ret = palmas_smps_read(pmic->palmas, addr, &reg);
>  			if (ret)
> -				goto err_unregister_regulator;
> +				return ret;
>  			if (reg & PALMAS_SMPS12_VOLTAGE_RANGE)
>  				pmic->range[id] = 1;
> 
> @@ -913,7 +913,7 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) addr = palmas_regs_info[id].ctrl_addr;
>  			ret = palmas_smps_read(pmic->palmas, addr, &reg);
>  			if (ret)
> -				goto err_unregister_regulator;
> +				return ret;
>  			pmic->current_reg_mode[id] = reg &
>  					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>  		}
> @@ -929,13 +929,13 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) pmic->desc[id].supply_name =
> palmas_regs_info[id].sname;
>  		config.of_node = palmas_matches[id].of_node;
> 
> -		rdev = regulator_register(&pmic->desc[id], &config);
> +		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
> +					       &config);
>  		if (IS_ERR(rdev)) {
>  			dev_err(&pdev->dev,
>  				"failed to register %s regulator\n",
>  				pdev->name);
> -			ret = PTR_ERR(rdev);
> -			goto err_unregister_regulator;
> +			return PTR_ERR(rdev);
>  		}
> 
>  		/* Save regulator for cleanup */
> @@ -997,13 +997,13 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) pmic->desc[id].supply_name =
> palmas_regs_info[id].sname;
>  		config.of_node = palmas_matches[id].of_node;
> 
> -		rdev = regulator_register(&pmic->desc[id], &config);
> +		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
> +					       &config);
>  		if (IS_ERR(rdev)) {
>  			dev_err(&pdev->dev,
>  				"failed to register %s regulator\n",
>  				pdev->name);
> -			ret = PTR_ERR(rdev);
> -			goto err_unregister_regulator;
> +			return PTR_ERR(rdev);
>  		}
> 
>  		/* Save regulator for cleanup */
> @@ -1021,7 +1021,7 @@ static int palmas_regulators_probe(struct
> platform_device *pdev) id, reg_init);
>  				if (ret) {
>  					regulator_unregister(pmic->rdev[id]);
> -					goto err_unregister_regulator;
> +					return ret;
>  				}

what about this regulator_unregister() above here?

[...]
Best regards,
Marek Vasut
