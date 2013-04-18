Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3DRNOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:14:11 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33504 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab3DRNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:13:57 -0400
Message-ID: <516FF194.6050704@slimlogic.co.uk>
Date: Thu, 18 Apr 2013 14:13:56 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: palmas: preserve modes of rails during
 enable/disable
References: <1366290168-3921-1-git-send-email-ldewangan@nvidia.com> <1366290168-3921-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1366290168-3921-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks good to me.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 18/04/13 14:02, Laxman Dewangan wrote:
> The Palma device like TPS65913 have the mode mask which is also
> used for enable/disable the rails. The mode bits are defined as
> 	00: OFF
> 	01: AUTO
> 	10: ECO
> 	11: Forced PWM
>
> and modes are set accordingly as
> 	REGULATOR_MODE_NORMAL: AUTO
> 	REGULATOR_MODE_IDLE: ECO
> 	REGULATOR_MODE_FAST: PWM
>
> Two issue observed:
> 1. If client calls following sequence:
> 	regulator_enable(),
> 	regulator_set_mode(FAST),
> 	regulator_disable()
>
> 	and again the regulator_enable() then the mode is reset
> 	to NORMAL inplace of keeping the mode as FAST.
>
> 	Fixing this by storing the current mode configured by client
> 	and restoring modes when enable() is called after disable().
>
> 2. In following sequence, the regulator get enabled:
> 	regulator_disable()
> 	regulator_set_mode(FAST),
>
> 	Fixing this by updating new mode in register only if it is
> 	enabled.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/palmas-regulator.c |   30 +++++++++++++++++++++++-------
>  include/linux/mfd/palmas.h           |    1 +
>  2 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index f5612c3..2948d21 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -275,7 +275,10 @@ static int palmas_enable_smps(struct regulator_dev *dev)
>  	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
>  
>  	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> -	reg |= SMPS_CTRL_MODE_ON;
> +	if (pmic->current_reg_mode[id])
> +		reg |= pmic->current_reg_mode[id];
> +	else
> +		reg |= SMPS_CTRL_MODE_ON;
>  
>  	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
>  
> @@ -297,16 +300,19 @@ static int palmas_disable_smps(struct regulator_dev *dev)
>  	return 0;
>  }
>  
> -
>  static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>  {
>  	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
>  	int id = rdev_get_id(dev);
>  	unsigned int reg;
> +	bool rail_enable = true;
>  
>  	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
>  	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>  
> +	if (reg == SMPS_CTRL_MODE_OFF)
> +		rail_enable = false;
> +
>  	switch (mode) {
>  	case REGULATOR_MODE_NORMAL:
>  		reg |= SMPS_CTRL_MODE_ON;
> @@ -320,8 +326,11 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>  	default:
>  		return -EINVAL;
>  	}
> -	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
>  
> +	pmic->current_reg_mode[id] = reg & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> +	if (rail_enable)
> +		palmas_smps_write(pmic->palmas,
> +			palmas_regs_info[id].ctrl_addr, reg);
>  	return 0;
>  }
>  
> @@ -331,9 +340,7 @@ static unsigned int palmas_get_mode_smps(struct regulator_dev *dev)
>  	int id = rdev_get_id(dev);
>  	unsigned int reg;
>  
> -	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
> -	reg &= PALMAS_SMPS12_CTRL_STATUS_MASK;
> -	reg >>= PALMAS_SMPS12_CTRL_STATUS_SHIFT;
> +	reg = pmic->current_reg_mode[id] & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>  
>  	switch (reg) {
>  	casThis looks good to me.
>
>
>
> Acked-by: Graeme Gregory <gg@slimlogic.co.uk>e SMPS_CTRL_MODE_ON:
> @@ -872,7 +879,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>  			/*
>  			 * Read and store the RANGE bit for later use
>  			 * This must be done before regulator is probed,
> -			 * otherwise we error in probe with unsupportable ranges.
> +			 * otherwise we error in probe with unsupportable
> +			 * ranges. Read the current smps mode for later use.
>  			 */
>  			addr = palmas_regs_info[id].vsel_addr;
>  
> @@ -889,6 +897,14 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>  						palmas_regs_info[id].vsel_addr);
>  			pmic->desc[id].vsel_mask =
>  					PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
> +This looks good to me.
>
>
>
> Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
> +			/* Read the smps mode for later use. */
> +			addr = palmas_regs_info[id].ctrl_addr;
> +			ret = palmas_smps_read(pmic->palmas, addr, &reg);
> +			if (ret)
> +				goto err_unregister_regulator;
> +			pmic->current_reg_mode[id] = reg &
> +					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>  		}
>  
>  		pmic->desc[id].type = REGULATOR_VOLTAGE;
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 91ef60c..8f21daf 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -338,6 +338,7 @@ struct palmas_pmic {
>  
>  	int range[PALMAS_REG_SMPS10];
>  	unsigned int ramp_delay[PALMAS_REG_SMPS10];
> +	unsigned int current_reg_mode[PALMAS_REG_SMPS10];
>  };
>  
>  struct palmas_resource {

