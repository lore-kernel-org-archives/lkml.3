Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaCKOcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:32:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24402 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCKOcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:32:21 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-2e-531f1e72d7af
Message-id: <1394548336.24263.7.camel@AMDC1943>
Subject: Re: [PATCH 1/3] mfd: max8997: use regmap to access registers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Tue, 11 Mar 2014 15:32:16 +0100
In-reply-to: <1394546304-15191-2-git-send-email-r.baldyga@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
 <1394546304-15191-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xa7pFcvLBBrtvSVosuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDLu3p/FVLA7q+LQIe0GxvmhXYycHBICJhJzlz5kh7DFJC7cW8/WxcjFISSwlFFi3az97BDO
	Z0aJB0dfMYNU8QroS8w+Op8NxBYWcJWYtKmbFcRmEzCW2Lx8CVhcREBL4s7H+WDNzAKHmSX2
	PegAK2IRUJU4tv0mC4jNKeAm8WX7fmaIDY2MEs1NF8CKmAXUJSbNW8QMcZOSxO72TnaIuLzE
	5jVvoa4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2M
	kLj8soNx8TGrQ4wCHIxKPLwr/OWChVgTy4orcw8xSnAwK4nwJovLBwvxpiRWVqUW5ccXleak
	Fh9iZOLglGpgtFi/ZsGtEsGpGyZMYD3hM036+J2wReWyZvYmUzi89rNeUPsguqFOr6nljey5
	VWZRt55tnODSvlxo9XJBRiOrxTV/Ek7bv7d90Or7nXXpFQ2/0m6fKUw/27dWdXK3L6tvn/Tm
	5u9nM2z8uD7KrpIy77NvWLj8m1+54usbHx//Cs8LsfC2W+9dosRSnJFoqMVcVJwIAI92cEKp	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 14:58 +0100, Robert Baldyga wrote:
> This patch modifies max8997 driver and each associated function driver,
> to use regmap instead of operating directly on i2c bus. It will allow to
> simplify IRQ handling using regmap-irq.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   31 ++++----
>  drivers/input/misc/max8997_haptic.c |   34 +++++----
>  drivers/leds/leds-max8997.c         |   13 ++--
>  drivers/mfd/max8997-irq.c           |   64 ++++++----------
>  drivers/mfd/max8997.c               |  143 ++++++++++++++++-------------------
>  drivers/power/max8997_charger.c     |   33 ++++----
>  drivers/regulator/max8997.c         |   87 ++++++++++-----------
>  drivers/rtc/rtc-max8997.c           |   56 ++++++++------
>  include/linux/mfd/max8997-private.h |   17 ++---
>  9 files changed, 229 insertions(+), 249 deletions(-)

I think you should also add "select REGMAP_I2C" to the main driver
config secion (drivers/mfd/Kconfig).


(...)

> diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
> index 43fa614..656d03b 100644
> --- a/drivers/mfd/max8997-irq.c
> +++ b/drivers/mfd/max8997-irq.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/mfd/max8997.h>
>  #include <linux/mfd/max8997-private.h>
> +#include <linux/regmap.h>
>  
>  static const u8 max8997_mask_reg[] = {
>  	[PMIC_INT1] = MAX8997_REG_INT1MSK,
> @@ -41,25 +42,6 @@ static const u8 max8997_mask_reg[] = {
>  	[FLASH_STATUS] = MAX8997_REG_INVALID,
>  };
>  
> -static struct i2c_client *get_i2c(struct max8997_dev *max8997,
> -				enum max8997_irq_source src)
> -{
> -	switch (src) {
> -	case PMIC_INT1 ... PMIC_INT4:
> -		return max8997->i2c;
> -	case FUEL_GAUGE:
> -		return NULL;
> -	case MUIC_INT1 ... MUIC_INT3:
> -		return max8997->muic;
> -	case GPIO_LOW ... GPIO_HI:
> -		return max8997->i2c;
> -	case FLASH_STATUS:
> -		return max8997->i2c;
> -	default:
> -		return ERR_PTR(-EINVAL);
> -	}
> -}
> -
>  struct max8997_irq_data {
>  	int mask;
>  	enum max8997_irq_source group;
> @@ -124,15 +106,20 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
>  	int i;
>  
>  	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
> +		struct regmap *map;
>  		u8 mask_reg = max8997_mask_reg[i];
> -		struct i2c_client *i2c = get_i2c(max8997, i);
> +
> +		if (i >= MUIC_INT1 && i <= MUIC_INT3)
> +			map = max8997->regmap_muic;
> +		else
> +			map = max8997->regmap;
>  
>  		if (mask_reg == MAX8997_REG_INVALID ||
> -				IS_ERR_OR_NULL(i2c))
> +				IS_ERR_OR_NULL(map))
>  			continue;
>  		max8997->irq_masks_cache[i] = max8997->irq_masks_cur[i];
>  
> -		max8997_write_reg(i2c, max8997_mask_reg[i],
> +		regmap_write(map, max8997_mask_reg[i],
>  				max8997->irq_masks_cur[i]);
>  	}
>  
> @@ -180,12 +167,12 @@ static struct irq_chip max8997_irq_chip = {
>  static irqreturn_t max8997_irq_thread(int irq, void *data)
>  {
>  	struct max8997_dev *max8997 = data;
> -	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
> -	u8 irq_src;
> +	unsigned int irq_reg[MAX8997_IRQ_GROUP_NR] = {};
> +	unsigned int irq_src;
>  	int ret;
>  	int i, cur_irq;
>  
> -	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
> +	ret = regmap_read(max8997->regmap, MAX8997_REG_INTSRC, &irq_src);
>  	if (ret < 0) {
>  		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
>  				ret);
> @@ -194,8 +181,9 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  
>  	if (irq_src & MAX8997_IRQSRC_PMIC) {
>  		/* PMIC INT1 ~ INT4 */
> -		max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4,
> -				&irq_reg[PMIC_INT1]);
> +		for (i = 0; i < 4; ++i)
> +			regmap_read(max8997->regmap,
> +				MAX8997_REG_INT1+i, &irq_reg[PMIC_INT1+i]);

Can't you use here one bulk read instead of 4xregmap_read()?


>  	}
>  	if (irq_src & MAX8997_IRQSRC_FUELGAUGE) {
>  		/*
> @@ -215,8 +203,9 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  	}
>  	if (irq_src & MAX8997_IRQSRC_MUIC) {
>  		/* MUIC INT1 ~ INT3 */
> -		max8997_bulk_read(max8997->muic, MAX8997_MUIC_REG_INT1, 3,
> -				&irq_reg[MUIC_INT1]);
> +		for (i = 0; i < 3; ++i)
> +			regmap_read(max8997->regmap_muic,
> +				MAX8997_MUIC_REG_INT1+i, &irq_reg[MUIC_INT1+i]);

Same as above - bulk.

>  	}
>  	if (irq_src & MAX8997_IRQSRC_GPIO) {
>  		/* GPIO Interrupt */
> @@ -225,8 +214,8 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  		irq_reg[GPIO_LOW] = 0;
>  		irq_reg[GPIO_HI] = 0;
>  
> -		max8997_bulk_read(max8997->i2c, MAX8997_REG_GPIOCNTL1,
> -				MAX8997_NUM_GPIO, gpio_info);
> +		regmap_bulk_read(max8997->regmap, MAX8997_REG_GPIOCNTL1,
> +				gpio_info, MAX8997_NUM_GPIO);
>  		for (i = 0; i < MAX8997_NUM_GPIO; i++) {
>  			bool interrupt = false;
>  
> @@ -260,7 +249,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  	}
>  	if (irq_src & MAX8997_IRQSRC_FLASH) {
>  		/* Flash Status Interrupt */
> -		ret = max8997_read_reg(max8997->i2c, MAX8997_REG_FLASHSTATUS,
> +		ret = regmap_read(max8997->regmap, MAX8997_REG_FLASHSTATUS,
>  				&irq_reg[FLASH_STATUS]);
>  	}
>  
> @@ -312,7 +301,7 @@ int max8997_irq_init(struct max8997_dev *max8997)
>  	struct irq_domain *domain;
>  	int i;
>  	int ret;
> -	u8 val;
> +	unsigned int val;
>  
>  	if (!max8997->irq) {
>  		dev_warn(max8997->dev, "No interrupt specified.\n");
> @@ -323,22 +312,19 @@ int max8997_irq_init(struct max8997_dev *max8997)
>  
>  	/* Mask individual interrupt sources */
>  	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
> -		struct i2c_client *i2c;
> -
>  		max8997->irq_masks_cur[i] = 0xff;
>  		max8997->irq_masks_cache[i] = 0xff;
> -		i2c = get_i2c(max8997, i);
>  
> -		if (IS_ERR_OR_NULL(i2c))
> +		if (IS_ERR_OR_NULL(max8997->regmap))
>  			continue;
>  		if (max8997_mask_reg[i] == MAX8997_REG_INVALID)
>  			continue;
>  
> -		max8997_write_reg(i2c, max8997_mask_reg[i], 0xff);
> +		regmap_write(max8997->regmap, max8997_mask_reg[i], 0xff);
>  	}
>  
>  	for (i = 0; i < MAX8997_NUM_GPIO; i++) {
> -		max8997->gpio_status[i] = (max8997_read_reg(max8997->i2c,
> +		max8997->gpio_status[i] = (regmap_read(max8997->regmap,
>  						MAX8997_REG_GPIOCNTL1 + i,
>  						&val)
>  					& MAX8997_GPIO_DATA_MASK) ?
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 5adede0..ca6f310 100644
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
> @@ -57,81 +58,29 @@ static struct of_device_id max8997_pmic_dt_match[] = {
>  };
>  #endif
>  
> -int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> -{
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> -	int ret;
> -
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_byte_data(i2c, reg);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret &= 0xff;
> -	*dest = ret;
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(max8997_read_reg);
> -
> -int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
> -{
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> -	int ret;
> -
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(max8997_bulk_read);
> -
> -int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
> -{
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> -	int ret;
> -
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_write_byte_data(i2c, reg, value);
> -	mutex_unlock(&max8997->iolock);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(max8997_write_reg);
> -
> -int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
> -{
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> -	int ret;
> +static const struct regmap_config max8997_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_REG_PMIC_END,
> +};
>  
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
> -	mutex_unlock(&max8997->iolock);
> -	if (ret < 0)
> -		return ret;
> +static const struct regmap_config max8997_regmap_rtc_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_RTC_REG_END,
> +};
>  
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(max8997_bulk_write);
> +static const struct regmap_config max8997_regmap_haptic_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_HAPTIC_REG_END,
> +};
>  
> -int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
> -{
> -	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
> -	int ret;
> -
> -	mutex_lock(&max8997->iolock);
> -	ret = i2c_smbus_read_byte_data(i2c, reg);
> -	if (ret >= 0) {
> -		u8 old_val = ret & 0xff;
> -		u8 new_val = (val & mask) | (old_val & (~mask));
> -		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
> -	}
> -	mutex_unlock(&max8997->iolock);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(max8997_update_reg);
> +static const struct regmap_config max8997_regmap_muic_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_MUIC_REG_END,
> +};
>  
>  /*
>   * Only the common platform data elements for max8997 are parsed here from the
> @@ -209,11 +158,48 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
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
> +	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
> +	if (IS_ERR(max8997->regmap)) {
> +		ret = PTR_ERR(max8997->regmap);
> +		dev_err(max8997->dev,
> +				"failed to allocate register map: %d\n", ret);
> +		return ret;
> +	}
> +
> +	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
> +					&max8997_regmap_rtc_config);
> +	if (IS_ERR(max8997->regmap_rtc)) {
> +		ret = PTR_ERR(max8997->regmap_rtc);
> +		dev_err(max8997->dev,
> +				"failed to allocate register map: %d\n", ret);
> +		goto err_regmap;
> +	}
> +
> +	max8997->regmap_haptic = devm_regmap_init_i2c(max8997->haptic,
> +					&max8997_regmap_haptic_config);
> +	if (IS_ERR(max8997->regmap_haptic)) {
> +		ret = PTR_ERR(max8997->regmap_haptic);
> +		dev_err(max8997->dev,
> +				"failed to allocate register map: %d\n", ret);
> +		goto err_regmap;
> +	}
> +
> +	max8997->regmap_muic = devm_regmap_init_i2c(max8997->muic,
> +					&max8997_regmap_muic_config);
> +	if (IS_ERR(max8997->regmap_muic)) {
> +		ret = PTR_ERR(max8997->regmap_muic);
> +		dev_err(max8997->dev,
> +				"failed to allocate register map: %d\n", ret);
> +		goto err_regmap;
> +	}
> +
>  	pm_runtime_set_active(max8997->dev);
>  
>  	max8997_irq_init(max8997);
> @@ -238,6 +224,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  
>  err_mfd:
>  	mfd_remove_devices(max8997->dev);
> +err_regmap:
>  	i2c_unregister_device(max8997->muic);
>  	i2c_unregister_device(max8997->haptic);
>  	i2c_unregister_device(max8997->rtc);
> @@ -423,15 +410,15 @@ static int max8997_freeze(struct device *dev)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_pmic[i],
> +		regmap_read(max8997->regmap, max8997_dumpaddr_pmic[i],
>  				&max8997->reg_dump[i]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_muic[i],
> +		regmap_read(max8997->regmap_muic, max8997_dumpaddr_muic[i],
>  				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> -		max8997_read_reg(i2c, max8997_dumpaddr_haptic[i],
> +		regmap_read(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
>  				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
>  				MAX8997_MUIC_REG_END]);

Code looks good. Idea for another patch: could bulk read be used here?
At least some of registers have continuous addresses so maybe its worth
to read them at once?

>  
> @@ -445,15 +432,15 @@ static int max8997_restore(struct device *dev)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_pmic[i],
> +		regmap_write(max8997->regmap, max8997_dumpaddr_pmic[i],
>  				max8997->reg_dump[i]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_muic[i],
> +		regmap_write(max8997->regmap_muic, max8997_dumpaddr_muic[i],
>  				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
>  
>  	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> -		max8997_write_reg(i2c, max8997_dumpaddr_haptic[i],
> +		regmap_write(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
>  				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
>  				MAX8997_MUIC_REG_END]);

As above - bulk write (if you still would like to improve things in this
driver)?

Best regards,
Krzysztof


