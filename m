Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3DRNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:13:50 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33502 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3DRNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:13:49 -0400
Message-ID: <516FF187.9000600@slimlogic.co.uk>
Date: Thu, 18 Apr 2013 14:13:43 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: palma: add ramp delay support through
 regulator constraints
References: <1366290168-3921-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1366290168-3921-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks good to me.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 18/04/13 14:02, Laxman Dewangan wrote:
> Currently Palma regulator driver support the ramp delay
> through rail specific platform data.
>
> As regulator framework support the configuration of ramp
> delay through regulator constraint, using the framework
> method and removing the platform specific data approach.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/palmas-regulator.c |   93 ++++++++++++++++++++++++++++------
>  include/linux/mfd/palmas.h           |   14 +-----
>  2 files changed, 79 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index d6efaf1..f5612c3 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -188,6 +188,8 @@ static const struct regs_info palmas_regs_info[] = {
>  	},
>  };
>  
> +static unsigned int palmas_smps_ramp_delay[4] = {0, 10000, 5000, 2500};
> +
>  #define SMPS_CTRL_MODE_OFF		0x00
>  #define SMPS_CTRL_MODE_ON		0x01
>  #define SMPS_CTRL_MODE_ECO		0x02
> @@ -398,6 +400,56 @@ static int palmas_map_voltage_smps(struct regulator_dev *rdev,
>  	return ret;
>  }
>  
> +static int palma_smps_set_voltage_smps_time_sel(struct regulator_dev *rdev,
> +	unsigned int old_selector, unsigned int new_selector)
> +{
> +	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	int old_uv, new_uv;
> +	unsigned int ramp_delay = pmic->ramp_delay[id];
> +
> +	if (!ramp_delay)
> +		return 0;
> +
> +	old_uv = palmas_list_voltage_smps(rdev, old_selector);
> +	if (old_uv < 0)
> +		return old_uv;
> +
> +	new_uv = palmas_list_voltage_smps(rdev, new_selector);
> +	if (new_uv < 0)
> +		return new_uv;
> +
> +	return DIV_ROUND_UP(abs(old_uv - new_uv), ramp_delay);
> +}
> +
> +static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
> +		 int ramp_delay)
> +{
> +	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	unsigned int reg = 0;
> +	unsigned int addr = palmas_regs_info[id].tstep_addr;
> +	int ret;
> +
> +	if (ramp_delay <= 0)
> +		reg = 0;
> +	else if (ramp_delay < 2500)
> +		reg = 3;
> +	else if (ramp_delay < 5000)
> +		reg = 2;
> +	else
> +		reg = 1;
> +
> +	ret = palmas_smps_write(pmic->palmas, addr, reg);
> +	if (ret < 0) {
> +		dev_err(pmic->palmas->dev, "TSTEP write failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	pmic->ramp_delay[id] = palmas_smps_ramp_delay[reg];
> +	return ret;
> +}
> +
>  static struct regulator_ops palmas_ops_smps = {
>  	.is_enabled		= palmas_is_enabled_smps,
>  	.enable			= palmas_enable_smps,
> @@ -408,6 +460,8 @@ static struct regulator_ops palmas_ops_smps = {
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.list_voltage		= palmas_list_voltage_smps,
>  	.map_voltage		= palmas_map_voltage_smps,
> +	.set_voltage_time_sel	= palma_smps_set_voltage_smps_time_sel,
> +	.set_ramp_delay		= palmas_smps_set_ramp_delay,
>  };
>  
>  static struct regulator_ops palmas_ops_smps10 = {
> @@ -496,16 +550,6 @@ static int palmas_smps_init(struct palmas *palmas, int id,
>  	if (ret)
>  		return ret;
>  
> -	if (palmas_regs_info[id].tstep_addr && reg_init->tstep) {
> -		addr = palmas_regs_info[id].tstep_addr;
> -
> -		reg = reg_init->tstep & PALMAS_SMPS12_TSTEP_TSTEP_MASK;
> -
> -		ret = palmas_smps_write(palmas, addr, reg);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	if (palmas_regs_info[id].vsel_addr && reg_init->vsel) {
>  		addr = palmas_regs_info[id].vsel_addr;
>  
> @@ -687,11 +731,6 @@ static void palmas_dt_to_pdata(struct device *dev,
>  		if (!ret)
>  			pdata->reg_init[idx]->mode_sleep = prop;
>  
> -		ret = of_property_read_u32(palmas_matches[idx].of_node,
> -				"ti,tstep", &prop);
> -		if (!ret)
> -			pdata->reg_init[idx]->tstep = prop;
> -
>  		ret = of_property_read_bool(palmas_matches[idx].of_node,
>  					    "ti,smps-range");
>  		if (ret)
> @@ -753,6 +792,7 @@ static int palmas_regulators_probe(struct platnetform_device *pdev)
>  	config.driver_data = pmic;
>  
>  	for (id = 0; id < PALMAS_REG_LDO1; id++) {
> +		bool ramp_delay_support = false;
>  
>  		/*
>  		 * Miss out regulators which are not available due
> @@ -763,19 +803,42 @@ static int palmas_regulators_probe(struct platform_device *pdev)
>  		case PALMAS_REG_SMPS3:
>  			if (pmic->smps123)
>  				continue;net
> +			if (id == PALMAS_REG_SMPS12)
> +				ramp_delay_support = true;
>  			break;
>  		case PALMAS_REG_SMPS123:
>  			if (!pmic->smps123)
>  				continue;
> +			ramp_delay_support = true;
>  			break;
>  		case PALMAS_REG_SMPS45:
>  		case PALMAS_REG_SMPS7:
>  			if (pmic->smps457)
>  				continue;
> +			if (id == PALMAS_REG_SMPS45)
> +				ramp_delay_support = true;
>  			break;
>  		case PALMAS_REG_SMPS457:
>  			if (!pmic->smps457)
>  				continue;
> +			ramp_delay_support = true;
> +			break;
> +		}
> +
> +		if ((id == PALMAS_REG_SMPS6) && (id == PALMAS_REG_SMPS8))
> +			ramp_delay_support = true;
> +
> +		if (ramp_delay_support) {
> +			addr = palmas_regs_info[id].tstep_addr;
> +			ret = palmas_smps_read(pmic->palmas, addr, &reg);
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"reading TSTEP reg failed: %d\n", ret);
> +				goto err_unregister_regulator;
> +			}
> +			pmic->desc[id].ramp_delay =
> +					palmas_smps_ramp_delay[reg & 0x3];
> +			pmic->ramp_delay[id] = pmic->desc[id].ramp_delay;
>  		}
>  
>  		/* Initialise sleep/init values from platform data */
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 12d8a62..91ef60c 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -119,19 +119,6 @@ struct palmas_reg_init {
>  	 */
>  	int mode_sleep;
>  
> -	/* tstep is the timestep loaded to the TSTEP register
> -	 *
> -	 * For SMPS
> -	 *
> -	 * 0: Jump (no slope control)
> -	 * 1: 10mV/us
> -	 * 2: 5mV/us
> -	 * 3: 2.5mV/us
> -	 *
> -	 * For LDO unused
> -	 */
> -	int tstep;
> -
>  	/* voltage_sel is the bitfield loaded onto the SMPSX_VOLTAGE
>  	 * register. Set this is the default voltage set in OTP needs
>  	 * to be overridden.
> @@ -350,6 +337,7 @@ struct palmas_pmic {
>  	int smps457;
>  
>  	int range[PALMAS_REG_SMPS10];
> +	unsigned int ramp_delay[PALMAS_REG_SMPS10];
>  };
>  
>  struct palmas_resource {

