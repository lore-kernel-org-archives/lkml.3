Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaGISkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:40:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41691 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbaGISku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:40:50 -0400
Message-ID: <53BD8CA9.80902@collabora.co.uk>
Date: Wed, 09 Jul 2014 20:40:41 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/24] mfd: max77686: Add Dynamic Voltage Scaling (DVS)
 support
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk> <1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk> <20140709151336.GI2635@lee--X1>
In-Reply-To: <20140709151336.GI2635@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

Thanks a lot for your feedback.

On 07/09/2014 05:13 PM, Lee Jones wrote:
> I'd really like Linus Walleij to look over this if possible.
> 

Ok, I'll cc Linus when posting the next version of the series.

> On Fri, 04 Jul 2014, Javier Martinez Canillas wrote:
>> Some regulators on the MAX77686 PMIC have Dynamic Voltage Scaling
>> (DVS) support that allows output voltage to change dynamically.
>> 
>> For MAX77686, these regulators are Buck regulators 2, 3 and 4.
>> 
>> Each Buck output voltage is selected using a set of external
>> inputs: DVS1-3 and SELB2-4.
>> 
>> DVS registers can be used to configure the output voltages for each
>> Buck regulator and which one is active is controled by DVSx lines.
>> 
>> SELBx lines are used to control if individual Buck lines are ON or OFF.
>> 
>> This patch adds support to configure the DVSx and SELBx lines
>> from DT and to setup and read the GPIO lines connected to them.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>> 
>> Changes since v6:
>>  - Add a comment that max77686_read_gpios() function can sleep.
>>    Sugggested by Krzysztof Kozlowski
>> ---
>>  drivers/mfd/max77686.c       | 119 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max77686.h |  18 ++++---
>>  2 files changed, 129 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
>> index 8650832..d193873 100644
>> --- a/drivers/mfd/max77686.c
>> +++ b/drivers/mfd/max77686.c
>> @@ -32,8 +32,10 @@
>>  #include <linux/mfd/core.h>
>>  #include <linux/mfd/max77686.h>
>>  #include <linux/mfd/max77686-private.h>
>> +#include <linux/gpio/consumer.h>
>>  #include <linux/err.h>
>>  #include <linux/of.h>
>> +#include <linux/export.h>
>>  
>>  #define I2C_ADDR_RTC	(0x0C >> 1)
>>  
>> @@ -101,9 +103,119 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
>>  	{},
>>  };
>>  
>> +static void max77686_dt_parse_dvs_gpio(struct device *dev)
>> +{
>> +	struct max77686_platform_data *pd = dev_get_platdata(dev);
>> +	int i;
>> +
>> +	/*
>> +	 * NOTE: we don't consider GPIO errors fatal; board may have some lines
>> +	 * directly pulled high or low and thus doesn't specify them.
>> +	 */
>> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
>> +		pd->buck_gpio_dvs[i] =
>> +			devm_gpiod_get_index(dev, "max77686,pmic-buck-dvs", i);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
>> +		pd->buck_gpio_selb[i] =
>> +			devm_gpiod_get_index(dev, "max77686,pmic-buck-selb", i);
>> +}
> 
> Not sure why you've pulled this out for parse_dt_pdata()?
> 

Ok, I'll remove that function and put the code in max77686_i2c_parse_dt_pdata().

>> +/**
>> + * max77686_setup_gpios() - init DVS-related GPIOs
>> + * @dev: device whose platform data contains the dvs GPIOs information
>> + *
>> + * This function claims / initalizations GPIOs related to DVS if they are
> 
> s/initialzations/initialises
> 

Right, will fix the typo.

>> + * defined. This may have the effect of switching voltages if the
> 
> s/if the/if
> 

Ditto.

>> + * pdata->buck_default_idx does not match the boot time state of pins.
>> + */
>> +int max77686_setup_gpios(struct device *dev)
>> +{
>> +	struct max77686_platform_data *pd = dev_get_platdata(dev);
>> +	int buck_default_idx = pd->buck_default_idx;
> 
> You're saving 4 characters once here.  Just use the variable in pd.
> 

Ok

>> +	int ret;
>> +	int i;
> 
> Don't you want some locking around this?
> 

This function is only called in the max77686 and max77802 regulator drivers
probe functions and we expect to have either one of those in a system but never
both so this function can't really be executed concurrently.

And even in the case that a system has both max77686 and max77802 PMICs, all the
data accessed is local to the driver's struct device so I think there is no need
to add any locking here.

>> +	/* Set all SELB high to avoid glitching while DVS is changing */
>> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
>> +		struct gpio_desc *gpio = pd->buck_gpio_selb[i];
>> +
>> +		/* OK if some GPIOs aren't defined */
>> +		if (IS_ERR(gpio))
>> +			continue;
>> +
>> +		ret = gpiod_direction_output_raw(gpio, 1);
>> +		if (ret) {
>> +			dev_err(dev, "can't set gpio[%d] dir: %d\n", i, ret);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* Set our initial setting */
>> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++) {
>> +		struct gpio_desc *gpio = pd->buck_gpio_dvs[i];
>> +
>> +		/* OK if some GPIOs aren't defined */
>> +		if (IS_ERR(gpio))
>> +			continue;
>> +
>> +		/* If a GPIO is valid, set it */
>> +		gpiod_direction_output(gpio, (buck_default_idx >> i) & 1);
>> +		if (ret) {
>> +			dev_err(dev, "can't set gpio[%d]: dir %d\n", i, ret);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* Now set SELB low to take effect */
>> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
>> +		struct gpio_desc *gpio = pd->buck_gpio_selb[i];
>> +
>> +		if (!IS_ERR(gpio))
>> +			gpiod_set_value(gpio, 0);
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(max77686_setup_gpios);
>> +
>> +/**
>> + * max77686_read_gpios() - read the current state of the dvs GPIOs
>> + * @pdata: platform data that contains the dvs GPIOs information
>> + *
>> + * We call this function at bootup to detect what slot the firmware was
>> + * using for the DVS GPIOs.  That way we can properly preserve the firmware's
>> + * voltage settings
>> + *
>> + * This function can sleep so must not be called from atomic context.
>> + */
>> +int max77686_read_gpios(struct max77686_platform_data *pdata)
>> +{
>> +	int buck_default_idx = pdata->buck_default_idx;
> 
> Remove this, it adds very little.
> 

Ok.

>> +	int result = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(pdata->buck_gpio_dvs); i++) {
>> +		struct gpio_desc *gpio = pdata->buck_gpio_dvs[i];
>> +
>> +		/* OK if some GPIOs aren't defined; we'll use default */
>> +		if (IS_ERR(gpio)) {
>> +			result |= buck_default_idx & (1 << i);
> 
> s/(1 << i)/BIT(i)/
> 

Ok.

>> +			continue;
>> +		}
>> +
>> +		if (gpiod_get_value_cansleep(gpio))
>> +			result |= 1 << i;
> 
> Same here.
> 

Ok.

>> +	}
>> +
>> +	return result;
>> +}
>> +EXPORT_SYMBOL_GPL(max77686_read_gpios);
>> +
>>  static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>>  								  *dev)
>>  {
>> +	struct device_node *np = dev->of_node;
>>  	struct max77686_platform_data *pd;
>>  
>>  	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> @@ -111,6 +223,13 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>>  		return NULL;
>>  
>>  	dev->platform_data = pd;
>> +
>> +	/* Read default index and ignore errors, since default is 0 */
>> +	of_property_read_u32(np, "max77686,pmic-buck-default-dvs-idx",
> 
> If it doesn't already have one, this needs a DT Ack and associated
> documentation.
> 

Yes, these DT binding properties are documented in Patch 17/24 "mfd: max77686:
Add documentation for DVS bindings" and I've cc'ed devicetree@vger.kernel.org so
hopefully I can get some feedback/ack from DT maintainers.

>> +			     &pd->buck_default_idx);
>> +
>> +	max77686_dt_parse_dvs_gpio(dev);
> 
> Bring code back into here and remove the call.
> 

Sure, will do.

>>  	return pd;
>>  }
>>  
>> diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
>> index 4cbcc13..46a736b 100644
>> --- a/include/linux/mfd/max77686.h
>> +++ b/include/linux/mfd/max77686.h
>> @@ -99,15 +99,17 @@ struct max77686_platform_data {
>>  	struct max77686_opmode_data *opmode_data;
>>  
>>  	/*
>> -	 * GPIO-DVS feature is not enabled with the current version of
>> -	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
>> -	 * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
>> +	 * GPIO-DVS feature is not fully enabled with the current version of
>> +	 * MAX77686 driver, but the driver does support using a DVS index other
>> +	 * than the default of 0.
>>  	 */
>> -	int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
>> -	int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
>> -	unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
>> -	unsigned int buck3_voltage[8];
>> -	unsigned int buck4_voltage[8];
>> +	struct gpio_desc *buck_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
>> +	int buck_default_idx; /* Default value of DVS1, 2, 3 */
>> +
>> +	struct gpio_desc *buck_gpio_selb[3]; /* Buck regulators 2, 3, 4 */
>>  };
>>  
>> +extern int max77686_setup_gpios(struct device *dev);
>> +extern int max77686_read_gpios(struct max77686_platform_data *pdata);
>> +
>>  #endif /* __LINUX_MFD_MAX77686_H */
> 

Best regards,
Javier
