Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaCENpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:45:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58181 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaCENpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:45:51 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-4e-53172a8c0e00
Message-id: <1394027146.24352.7.camel@AMDC1943>
Subject: Re: [PATCH] mfd: max8997: use regmap to access registers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Wed, 05 Mar 2014 14:45:46 +0100
In-reply-to: <1394024869-14136-1-git-send-email-r.baldyga@samsung.com>
References: <1394024869-14136-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xy7o9WuLBBi+XcVosuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDIWn1zAUnCrouL6zk1MDYxnE7oYOTkkBEwkTp74xQphi0lcuLeerYuRi0NIYCmjxMP9l1kg
	nM+MEvMvHWcHqeIV0JdYs/cQG4gtLOAosefgGbA4m4CxxOblS8DiIgJaEnc+zmcHaWYWOMws
	se9BB9gKFgFViS37HoLZnAJuEq93H2MEsYUEXCXeTTwLZjMLqEtMmreIGeIkJYnd7Z3sEHF5
	ic1r3jJDHCEo8WPyPZYJjAKzkLTMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5
	mxghcfl1B+PSY1aHGAU4GJV4eF9wiAULsSaWFVfmHmKU4GBWEuHtFxcPFuJNSaysSi3Kjy8q
	zUktPsTIxMEp1cDYz3vt2kZrR0OWQqbZx9SC+T9ftWr0XTDDau2xnaKrL59K8xOdeObf4v1y
	/5trHs25VqV7+KJC2OT8uCcroj/8XPz2m4Oq15c568PusNl0uDZqL1O5+aK5fo2I4WX3cg3L
	QI+l3k06phY+V1gdH5Y37BESudNcaPy9U7rRX8zmVOvR/Hbj0i4lluKMREMt5qLiRACwb08R
	qQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> This patch modifies max8997 driver and each associated function driver,
> to use regmap instead of operating directly on i2c bus. It will allow to
> simplify IRQ handling using regmap-irq.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

(...)

> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index be88a3b..bd14c7d 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -33,6 +33,7 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/max8997.h>
>  #include <linux/mfd/max8997-private.h>
> +#include <linux/regmap.h>
>  
>  #define I2C_ADDR_PMIC	(0xCC >> 1)
>  #define I2C_ADDR_MUIC	(0x4A >> 1)
> @@ -57,82 +58,82 @@ static struct of_device_id max8997_pmic_dt_match[] = {
>  };
>  #endif
>  
> -int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +int max8997_read_reg(struct regmap *map, u8 reg, u8 *dest)
>  {
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> +	unsigned int val;
>  	int ret;
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_byte_data(i2c, reg);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> +	ret = regmap_read(map, reg, &val);
> +	*dest = val;
>  
> -	ret &= 0xff;
> -	*dest = ret;
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(max8997_read_reg);
>  
> -int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
> +int max8997_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf)
>  {
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>  	int ret;
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> +	ret = regmap_bulk_read(map, reg, buf, count);
>  
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(max8997_bulk_read);
>  
> -int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
> +int max8997_write_reg(struct regmap *map, u8 reg, u8 value)
>  {
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>  	int ret;
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_write_byte_data(i2c, reg, value);
> -	mutex_unlock(&max8997->iolock);
> +	ret = regmap_write(map, reg, value);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(max8997_write_reg);
>  
> -int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
> +int max8997_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
>  {
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>  	int ret;
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> +	ret = regmap_bulk_write(map, reg, buf, count);
>  
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(max8997_bulk_write);
>  
> -int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
> +int max8997_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
>  {
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>  	int ret;
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_byte_data(i2c, reg);
> -	if (ret >= 0) {
> -		u8 old_val = ret & 0xff;
> -		u8 new_val = (val & mask) | (old_val & (~mask));
> -		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
> -	}
> -	mutex_unlock(&max8997->iolock);
> +	ret = regmap_update_bits(map, reg, mask, val);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(max8997_update_reg);
>  
> +static const struct regmap_config max8997_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_REG_PMIC_END,
> +};
> +
> +static const struct regmap_config max8997_regmap_rtc_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_RTC_REG_END,
> +};
> +
> +static const struct regmap_config max8997_regmap_haptic_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_HAPTIC_REG_END,
> +};
> +
> +static const struct regmap_config max8997_regmap_muic_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_MUIC_REG_END,
> +};
> +
>  /*
>   * Only the common platform data elements for max8997 are parsed here from the
>   * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
> @@ -184,6 +185,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  
>  	max8997 = devm_kzalloc(&i2c->dev, sizeof(struct max8997_dev),
>  				GFP_KERNEL);
> +
>  	if (max8997 == NULL)
>  		return -ENOMEM;
>  

This new line was added on purpose?

> @@ -202,6 +204,14 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  	if (!pdata)
>  		return ret;
>  
> +	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
> +	if (IS_ERR(max8997->regmap)) {
> +		ret = PTR_ERR(max8997->regmap);
> +		dev_err(max8997->dev, "failed to allocate register map: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
>  	max8997->pdata = pdata;
>  	max8997->ono = pdata->ono;
>  
> @@ -209,11 +219,22 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  
>  	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
>  	i2c_set_clientdata(max8997->rtc, max8997);
> +
>  	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
>  	i2c_set_clientdata(max8997->haptic, max8997);
> +
>  	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
>  	i2c_set_clientdata(max8997->muic, max8997);
>  
> +	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
> +					&max8997_regmap_rtc_config);
> +
> +	max8997->regmap_haptic = devm_regmap_init_i2c(max8997->haptic,
> +					&max8997_regmap_haptic_config);
> +
> +	max8997->regmap_muic = devm_regmap_init_i2c(max8997->muic,
> +					&max8997_regmap_muic_config);
> +
>  	pm_runtime_set_active(max8997->dev);
>  
>  	max8997_irq_init(max8997);

Return value of each devm_regmap_init_i2c() should be checked here.

> @@ -423,15 +444,15 @@ static int max8997_freeze(struct device *dev)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_pmic[i],
> +		max8997_read_reg(max8997->regmap, max8997_dumpaddr_pmic[i],
>  				&max8997->reg_dump[i]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_muic[i],
> +		max8997_read_reg(max8997->regmap, max8997_dumpaddr_muic[i],
>  				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
>  

Shouldn't regmap_muic be used here? You will be reading
MAX8997_MUIC_REG* registers.

>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_haptic[i],
> +		max8997_read_reg(max8997->regmap, max8997_dumpaddr_haptic[i],
>  				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
>  				MAX8997_MUIC_REG_END]);

Same, but regmap_haptic?

>  
> @@ -445,15 +466,15 @@ static int max8997_restore(struct device *dev)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_pmic[i],
> +		max8997_write_reg(max8997->regmap, max8997_dumpaddr_pmic[i],
>  				max8997->reg_dump[i]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_muic[i],
> +		max8997_write_reg(max8997->regmap, max8997_dumpaddr_muic[i],
>  				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);

Same, as above - regmap_muic.
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_haptic[i],
> +		max8997_write_reg(max8997->regmap, max8997_dumpaddr_haptic[i],
>  				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
>  				MAX8997_MUIC_REG_END]);

Same, as above - regmap_haptic.

>  
> diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
> index 4bdedfe..027e9bf 100644
> --- a/drivers/power/max8997_charger.c
> +++ b/drivers/power/max8997_charger.c
> @@ -46,14 +46,14 @@ static int max8997_battery_get_property(struct power_supply *psy,
>  {
>  	struct charger_data *charger = container_of(psy,
>  			struct charger_data, battery);
> -	struct i2c_client *i2c = charger->iodev->i2c;
>  	int ret;
>  	u8 reg;
>  
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_STATUS:
>  		val->intval = 0;
> -		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
> +		ret = max8997_read_reg(charger->iodev->regmap,
> +				MAX8997_REG_STATUS4, &reg);
>  		if (ret)
>  			return ret;
>  		if ((reg & (1 << 0)) == 0x1)
> @@ -62,7 +62,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
>  		break;
>  	case POWER_SUPPLY_PROP_PRESENT:
>  		val->intval = 0;
> -		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
> +		ret = max8997_read_reg(charger->iodev->regmap,
> +				MAX8997_REG_STATUS4, &reg);
>  		if (ret)
>  			return ret;
>  		if ((reg & (1 << 2)) == 0x0)
> @@ -71,7 +72,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
>  		break;
>  	case POWER_SUPPLY_PROP_ONLINE:
>  		val->intval = 0;
> -		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
> +		ret = max8997_read_reg(charger->iodev->regmap,
> +				MAX8997_REG_STATUS4, &reg);
>  		if (ret)
>  			return ret;
>  		/* DCINOK */
> @@ -103,7 +105,7 @@ static int max8997_battery_probe(struct platform_device *pdev)
>  		if (val > 0xf)
>  			val = 0xf;
>  
> -		ret = max8997_update_reg(iodev->i2c,
> +		ret = max8997_update_reg(iodev->regmap,
>  				MAX8997_REG_MBCCTRL5, val, 0xf);
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "Cannot use i2c bus.\n");
> @@ -113,20 +115,20 @@ static int max8997_battery_probe(struct platform_device *pdev)
>  
>  	switch (pdata->timeout) {
>  	case 5:
> -		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
> -				0x2 << 4, 0x7 << 4);
> +		ret = max8997_update_reg(iodev->regmap,
> +				MAX8997_REG_MBCCTRL1, 0x2 << 4, 0x7 << 4);
>  		break;
>  	case 6:
> -		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
> -				0x3 << 4, 0x7 << 4);
> +		ret = max8997_update_reg(iodev->regmap,
> +				MAX8997_REG_MBCCTRL1, 0x3 << 4, 0x7 << 4);
>  		break;
>  	case 7:
> -		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
> -				0x4 << 4, 0x7 << 4);
> +		ret = max8997_update_reg(iodev->regmap,
> +				MAX8997_REG_MBCCTRL1, 0x4 << 4, 0x7 << 4);
>  		break;
>  	case 0:
> -		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
> -				0x7 << 4, 0x7 << 4);
> +		ret = max8997_update_reg(iodev->regmap,
> +				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x7 << 4);
>  		break;
>  	default:
>  		dev_err(&pdev->dev, "incorrect timeout value (%d)\n",
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index 2d618fc..470435e 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -258,7 +258,6 @@ static int max8997_get_enable_register(struct regulator_dev *rdev,
>  static int max8997_reg_is_enabled(struct regulator_dev *rdev)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int ret, reg, mask, pattern;
>  	u8 val;
>  
> @@ -266,7 +265,7 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = max8997_read_reg(i2c, reg, &val);
> +	ret = max8997_read_reg(max8997->iodev->regmap, reg, &val);
>  	if (ret)
>  		return ret;
>  
> @@ -276,27 +275,25 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
>  static int max8997_reg_enable(struct regulator_dev *rdev)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int ret, reg, mask, pattern;
>  
>  	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
>  	if (ret)
>  		return ret;
>  
> -	return max8997_update_reg(i2c, reg, pattern, mask);
> +	return max8997_update_reg(max8997->iodev->regmap, reg, pattern, mask);
>  }
>  
>  static int max8997_reg_disable(struct regulator_dev *rdev)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int ret, reg, mask, pattern;
>  
>  	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
>  	if (ret)
>  		return ret;
>  
> -	return max8997_update_reg(i2c, reg, ~pattern, mask);
> +	return max8997_update_reg(max8997->iodev->regmap, reg, ~pattern, mask);
>  }
>  
>  static int max8997_get_voltage_register(struct regulator_dev *rdev,
> @@ -368,7 +365,6 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
>  static int max8997_get_voltage_sel(struct regulator_dev *rdev)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int reg, shift, mask, ret;
>  	u8 val;
>  
> @@ -376,7 +372,7 @@ static int max8997_get_voltage_sel(struct regulator_dev *rdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = max8997_read_reg(i2c, reg, &val);
> +	ret = max8997_read_reg(max8997->iodev->regmap, reg, &val);
>  	if (ret)
>  		return ret;
>  
> @@ -413,7 +409,6 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
>  		int min_uV, int max_uV, unsigned *selector)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int rid = rdev_get_id(rdev);
>  	int lb, ub;
>  	int reg, shift = 0, mask, ret = 0;
> @@ -455,7 +450,8 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
>  
>  	*selector = val;
>  
> -	ret = max8997_update_reg(i2c, reg, val << shift, mask);
> +	ret = max8997_update_reg(max8997->iodev->regmap,
> +				reg, val << shift, mask);
>  
>  	return ret;
>  }
> @@ -468,7 +464,6 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
>  		int min_uV, int max_uV, unsigned *selector)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	const struct voltage_map_desc *desc;
>  	int rid = rdev_get_id(rdev);
>  	int i, reg, shift, mask, ret;
> @@ -500,7 +495,8 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
>  	if (ret)
>  		return ret;
>  
> -	ret = max8997_update_reg(i2c, reg, i << shift, mask << shift);
> +	ret = max8997_update_reg(max8997->iodev->regmap,
> +				reg, i << shift, mask << shift);

It doesn't look consistent with previous changes - the mask is shifted
here but in previous calls it isn't. Which one is proper?

>  	*selector = i;
>  
>  	return ret;
> @@ -710,7 +706,6 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
>  					   unsigned selector)
>  {
>  	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> -	struct i2c_client *i2c = max8997->iodev->i2c;
>  	int rid = rdev_get_id(rdev);
>  	int reg, shift = 0, mask, ret;
>  
> @@ -721,13 +716,13 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
>  	if (ret)
>  		return ret;
>  
> -	return max8997_update_reg(i2c, reg, selector << shift, mask << shift);
> +	return max8997_update_reg(max8997->iodev->regmap,
> +				reg, selector << shift, mask << shift);

Same as before - not consistent mask shifting.


Best regards,
Krzysztof

