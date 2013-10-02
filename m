Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3JBKPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:15:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JBKPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:15:08 -0400
Date: Wed, 2 Oct 2013 12:15:00 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 3/4] regulator: da9052: Use apply_[reg|bit] with regmap
 based voltage_sel operations
Message-ID: <20131002101500.GD25376@pengutronix.de>
References: <1355794210.5681.1.camel@phoenix>
 <1355794372.5681.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355794372.5681.5.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:01:19 up 38 days, 19:32, 49 users,  load average: 0,07, 0,13,
 0,36
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel, Mark,

we should not play to much with generous functions for this pmics. With this
patch we loose the fix_io code path from da9052_reg_update.

include/linux/mfd/da9052.h
...
        if (da9052->fix_io) {
                ret = da9052->fix_io(da9052, reg);
                if (ret < 0)
                        return ret;
...

This fix_io used in drivers/mfd/da9052-i2c.c

/*
 * There is an issue with DA9052 and DA9053_AA/BA/BB PMIC where the PMIC
 * gets lockup up or fails to respond following a system reset.
 * This fix is to follow any read or write with a dummy read to a safe
 * register.
 */
static int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
{
        int val;

        switch (da9052->chip_id) {
        case DA9052:
        case DA9053_AA:
        case DA9053_BA:
        case DA9053_BB:
                /* A dummy read to a safe register address. */
        if (!i2c_safe_reg(reg))
                        return regmap_read(da9052->regmap,
                                           DA9052_PARK_REGISTER,
                                           &val);
                break;
        default:
                /*
                 * For other chips parking of I2C register
                 * to a safe place is not required.
                 */
                break;
        }

        return 0;
}

I suggest that Mark queue the revert of this patch.

Thanks,
Michael

On Tue, Dec 18, 2012 at 09:32:52AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/da9052-regulator.c |   41 +++++-----------------------------
>  1 file changed, 6 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
> index d096309..c6d8651 100644
> --- a/drivers/regulator/da9052-regulator.c
> +++ b/drivers/regulator/da9052-regulator.c
> @@ -70,7 +70,6 @@ struct da9052_regulator_info {
>  	int step_uV;
>  	int min_uV;
>  	int max_uV;
> -	unsigned char activate_bit;
>  };
>  
>  struct da9052_regulator {
> @@ -210,36 +209,6 @@ static int da9052_map_voltage(struct regulator_dev *rdev,
>  	return sel;
>  }
>  
> -static int da9052_regulator_set_voltage_sel(struct regulator_dev *rdev,
> -					    unsigned int selector)
> -{
> -	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
> -	struct da9052_regulator_info *info = regulator->info;
> -	int id = rdev_get_id(rdev);
> -	int ret;
> -
> -	ret = da9052_reg_update(regulator->da9052, rdev->desc->vsel_reg,
> -				rdev->desc->vsel_mask, selector);
> -	if (ret < 0)
> -		return ret;
> -
> -	/* Some LDOs and DCDCs are DVC controlled which requires enabling of
> -	 * the activate bit to implment the changes on the output.
> -	 */
> -	switch (id) {
> -	case DA9052_ID_BUCK1:
> -	case DA9052_ID_BUCK2:
> -	case DA9052_ID_BUCK3:
> -	case DA9052_ID_LDO2:
> -	case DA9052_ID_LDO3:
> -		ret = da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
> -					info->activate_bit, info->activate_bit);
> -		break;
> -	}
> -
> -	return ret;
> -}
> -
>  static struct regulator_ops da9052_dcdc_ops = {
>  	.get_current_limit = da9052_dcdc_get_current_limit,
>  	.set_current_limit = da9052_dcdc_set_current_limit,
> @@ -247,7 +216,7 @@ static struct regulator_ops da9052_dcdc_ops = {
>  	.list_voltage = da9052_list_voltage,
>  	.map_voltage = da9052_map_voltage,
>  	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> -	.set_voltage_sel = da9052_regulator_set_voltage_sel,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
>  	.is_enabled = regulator_is_enabled_regmap,
>  	.enable = regulator_enable_regmap,
>  	.disable = regulator_disable_regmap,
> @@ -257,7 +226,7 @@ static struct regulator_ops da9052_ldo_ops = {
>  	.list_voltage = da9052_list_voltage,
>  	.map_voltage = da9052_map_voltage,
>  	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> -	.set_voltage_sel = da9052_regulator_set_voltage_sel,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
>  	.is_enabled = regulator_is_enabled_regmap,
>  	.enable = regulator_enable_regmap,
>  	.disable = regulator_disable_regmap,
> @@ -274,13 +243,14 @@ static struct regulator_ops da9052_ldo_ops = {
>  		.owner = THIS_MODULE,\
>  		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
>  		.vsel_mask = (1 << (sbits)) - 1,\
> +		.apply_reg = DA9052_SUPPLY_REG, \
> +		.apply_bit = (abits), \
>  		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
>  		.enable_mask = 1 << (ebits),\
>  	},\
>  	.min_uV = (min) * 1000,\
>  	.max_uV = (max) * 1000,\
>  	.step_uV = (step) * 1000,\
> -	.activate_bit = (abits),\
>  }
>  
>  #define DA9052_DCDC(_id, step, min, max, sbits, ebits, abits) \
> @@ -294,13 +264,14 @@ static struct regulator_ops da9052_ldo_ops = {
>  		.owner = THIS_MODULE,\
>  		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
>  		.vsel_mask = (1 << (sbits)) - 1,\
> +		.apply_reg = DA9052_SUPPLY_REG, \
> +		.apply_bit = (abits), \
>  		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
>  		.enable_mask = 1 << (ebits),\
>  	},\
>  	.min_uV = (min) * 1000,\
>  	.max_uV = (max) * 1000,\
>  	.step_uV = (step) * 1000,\
> -	.activate_bit = (abits),\
>  }
>  
>  static struct da9052_regulator_info da9052_regulator_info[] = {
> -- 
> 1.7.9.5




-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
