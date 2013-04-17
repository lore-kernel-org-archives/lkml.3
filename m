Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966453Ab3DQNyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:54:35 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:54369 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966322Ab3DQNyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:54:33 -0400
Message-ID: <516EA998.3050008@slimlogic.co.uk>
Date: Wed, 17 Apr 2013 14:54:32 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: palmas: add support for LDO8 tracking
 mode
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com> <1366191793-13934-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1366191793-13934-3-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, I don't actually know the use case for this feature!

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 17/04/13 10:43, Laxman Dewangan wrote:
> LDO8 of Palma device like tps65913 support the tracking mode
> on which LDO8 track the SMPS45 voltage when SMPS45 is ON
> and use the LDO8.VOLTAGE_SEL register when SMPS45 is OFF.
>
> On track mode, the steps of voltage change for LDO8 is 25mV
> where in non-tracking mode it is 50mV. Set the steps accordingly.
> Number of voltage count is still same for both the cases.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/palmas-regulator.c |   53 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/palmas.h           |    3 ++
>  2 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 28080a7..d6efaf1 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -572,6 +572,46 @@ static int palmas_extreg_init(struct palmas *palmas, int id,
>  	return 0;
>  }
>  
> +static void palmas_enable_ldo8_track(struct palmas *palmas)
> +{
> +	unsigned int reg;
> +	unsigned int addr;
> +	int ret;
> +
> +	addr = palmas_regs_info[PALMAS_REG_LDO8].ctrl_addr;
> +
> +	ret = palmas_ldo_read(palmas, addr, &reg);
> +	if (ret) {
> +		dev_err(palmas->dev, "Error in reading ldo8 control reg\n");
> +		return;
> +	}
> +
> +	reg |= PALMAS_LDO8_CTRL_LDO_TRACKING_EN;
> +	ret = palmas_ldo_write(palmas, addr, reg);
> +	if (ret < 0) {
> +		dev_err(palmas->dev, "Error in enabling tracking mode\n");
> +		return;
> +	}
> +	/*
> +	 * When SMPS45 is set to off and LDO8 tracking is enabled, the LDO8
> +	 * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
> +	 * and can be set from 0.45 to 1.65 V.
> +	 */
> +	addr = palmas_regs_info[PALMAS_REG_LDO8].vsel_addr;
> +	ret = palmas_ldo_read(palmas, addr, &reg);
> +	if (ret) {
> +		dev_err(palmas->dev, "Error in reading ldo8 voltage reg\n");
> +		return;
> +	}
> +
> +	reg = (reg << 1) & PALMAS_LDO8_VOLTAGE_VSEL_MASK;
> +	ret = palmas_ldo_write(palmas, addr, reg);
> +	if (ret < 0)
> +		dev_err(palmas->dev, "Error in setting ldo8 voltage reg\n");
> +
> +	return;
> +}
> +
>  static struct of_regulator_match palmas_matches[] = {
>  	{ .name = "smps12", },
>  	{ .name = "smps123", },
> @@ -657,6 +697,11 @@ static void palmas_dt_to_pdata(struct device *dev,
>  		if (ret)
>  			pdata->reg_init[idx]->vsel =
>  				PALMAS_SMPS12_VOLTAGE_RANGE;
> +
> +		if (idx == PALMAS_REG_LDO8)
> +			pdata->enable_ldo8_tracking = of_property_read_bool(
> +						palmas_matches[idx].of_node,
> +						"ti,enable-ldo8-tracking");
>  	}
>  
>  	pdata->ldo6_vibrator = of_property_read_bool(node, "ti,ldo6-vibrator");
> @@ -836,6 +881,13 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>  						palmas_regs_info[id].ctrl_addr);
>  			pmic->desc[id].enable_mask =
>  					PALMAS_LDO1_CTRL_MODE_ACTIVE;
> +
> +			/* Check if LDO8 is in tracking mode or not */
> +			if (pdata && (id == PALMAS_REG_LDO8) &&
> +					pdata->enable_ldo8_tracking) {
> +				palmas_enable_ldo8_track(palmas);
> +				pmic->desc[id].uV_step = 25000;
> +			}
>  		} else {
>  			pmic->desc[id].n_voltages = 1;
>  			pmic->desc[id].ops = &palmas_ops_extreg;
> @@ -884,6 +936,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +
>  	return 0;
>  
>  err_unregister_regulator:
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index fb04d07..12d8a62 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -187,6 +187,9 @@ struct palmas_pmic_platform_data {
>  
>  	/* use LDO6 for vibrator control */
>  	int ldo6_vibrator;
> +
> +	/* Enable tracking mode of LDO8 */
> +	bool enable_ldo8_tracking;
>  };
>  
>  struct palmas_usb_platform_data {

