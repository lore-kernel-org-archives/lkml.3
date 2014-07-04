Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbaGDLdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:33:12 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38281 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaGDLdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:33:10 -0400
Message-ID: <53B690E9.4000003@collabora.co.uk>
Date: Fri, 04 Jul 2014 13:32:57 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 08/23] mfd: max77686: Add Dynamic Voltage Scaling (DVS)
 support
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk> <1404467722-26687-9-git-send-email-javier.martinez@collabora.co.uk> <1404472510.14069.6.camel@AMDC1943>
In-Reply-To: <1404472510.14069.6.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Again, thanks a lot for taking the time to review the series.

On 07/04/2014 01:15 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
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
>> ---
>>  drivers/mfd/max77686.c       | 115 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max77686.h |  18 ++++---
>>  2 files changed, 125 insertions(+), 8 deletions(-)
> 
> One minor comment below, but overall looks good to me:
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> 
>> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
>> index 8650832..648d564 100644
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
>> @@ -101,9 +103,115 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
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
>> +
>> +/**
>> + * max77686_setup_gpios - init DVS-related GPIOs
>> + *
>> + * This function claims / initalizations GPIOs related to DVS if they are
>> + * defined. This may have the effect of switching voltages if the
>> + * pdata->buck_default_idx does not match the boot time state of pins.
>> + */
>> +int max77686_setup_gpios(struct device *dev)
>> +{
>> +	struct max77686_platform_data *pd = dev_get_platdata(dev);
>> +	int buck_default_idx = pd->buck_default_idx;
>> +	int ret;
>> +	int i;
>> +
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
>> + * max77686_read_gpios - read the current state of the dvs GPIOs
>> + *
>> + * We call this function at bootup to detect what slot the firmware was
>> + * using for the DVS GPIOs.  That way we can properly preserve the firmware's
>> + * voltage settings
>> + */
>> +int max77686_read_gpios(struct max77686_platform_data *pdata)
>> +{
> 
> Can you document that this function can sleep? It is quite obvious but
> the function is exported so maybe it is worth noting.
> 

Sure, I'll add that to the comment.

> Best regards,
> Krzysztof
> 

Best regards,
Javier

