Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaGKBpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:45:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42583 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGKBpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:45:51 -0400
Message-ID: <53BF41C8.4080304@collabora.co.uk>
Date: Fri, 11 Jul 2014 03:45:44 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Tushar Behera <trblinux@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Andreas Farber <afaerber@suse.de>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 08/24] mfd: max77686: Add Dynamic Voltage Scaling (DVS)
 support
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>	<1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk> <CADGdYn6tyTBZOjZH8JBUVMJ1kh-tht=tkU4tA+oM=PbfTYkqGw@mail.gmail.com>
In-Reply-To: <CADGdYn6tyTBZOjZH8JBUVMJ1kh-tht=tkU4tA+oM=PbfTYkqGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,

On 07/10/2014 11:59 AM, amit daniel kachhap wrote:
> On Sat, Jul 5, 2014 at 1:54 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
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
> 
> The entire series looks nice. Few minor comments from my side. I guess
> still one more version in needed as per other ppls comment.
> You may add,
> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>

Thanks.

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
>>  #define I2C_ADDR_RTC   (0x0C >> 1)
>>
>> @@ -101,9 +103,119 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
>>         {},
>>  };
>>
>> +static void max77686_dt_parse_dvs_gpio(struct device *dev)
>> +{
>> +       struct max77686_platform_data *pd = dev_get_platdata(dev);
>> +       int i;
>> +
>> +       /*
>> +        * NOTE: we don't consider GPIO errors fatal; board may have some lines
>> +        * directly pulled high or low and thus doesn't specify them.
>> +        */
>> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
>> +               pd->buck_gpio_dvs[i] =
>> +                       devm_gpiod_get_index(dev, "max77686,pmic-buck-dvs", i);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
>> +               pd->buck_gpio_selb[i] =
>> +                       devm_gpiod_get_index(dev, "max77686,pmic-buck-selb", i);
>> +}
>> +
>> +/**
>> + * max77686_setup_gpios() - init DVS-related GPIOs
>> + * @dev: device whose platform data contains the dvs GPIOs information
>> + *
>> + * This function claims / initalizations GPIOs related to DVS if they are
>> + * defined. This may have the effect of switching voltages if the
>> + * pdata->buck_default_idx does not match the boot time state of pins.
>> + */
>> +int max77686_setup_gpios(struct device *dev)
>> +{
>> +       struct max77686_platform_data *pd = dev_get_platdata(dev);
>> +       int buck_default_idx = pd->buck_default_idx;
>> +       int ret;
>> +       int i;
>> +
>> +       /* Set all SELB high to avoid glitching while DVS is changing */
>> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
>> +               struct gpio_desc *gpio = pd->buck_gpio_selb[i];
>> +
>> +               /* OK if some GPIOs aren't defined */
>> +               if (IS_ERR(gpio))
>> +                       continue;
>> +
>> +               ret = gpiod_direction_output_raw(gpio, 1);
>> +               if (ret) {
>> +                       dev_err(dev, "can't set gpio[%d] dir: %d\n", i, ret);
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       /* Set our initial setting */
>> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++) {
>> +               struct gpio_desc *gpio = pd->buck_gpio_dvs[i];
>> +
>> +               /* OK if some GPIOs aren't defined */
>> +               if (IS_ERR(gpio))
>> +                       continue;
>> +
>> +               /* If a GPIO is valid, set it */
>> +               gpiod_direction_output(gpio, (buck_default_idx >> i) & 1);
>> +               if (ret) {
>> +                       dev_err(dev, "can't set gpio[%d]: dir %d\n", i, ret);
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       /* Now set SELB low to take effect */
>> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
>> +               struct gpio_desc *gpio = pd->buck_gpio_selb[i];
>> +
>> +               if (!IS_ERR(gpio))
>> +                       gpiod_set_value(gpio, 0);
>> +       }
>> +
>> +       return 0;
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
>> +       int buck_default_idx = pdata->buck_default_idx;
>> +       int result = 0;
>> +       int i;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(pdata->buck_gpio_dvs); i++) {
>> +               struct gpio_desc *gpio = pdata->buck_gpio_dvs[i];
>> +
>> +               /* OK if some GPIOs aren't defined; we'll use default */
>> +               if (IS_ERR(gpio)) {
>> +                       result |= buck_default_idx & (1 << i);
>> +                       continue;
>> +               }
>> +
>> +               if (gpiod_get_value_cansleep(gpio))
>> +                       result |= 1 << i;
>> +       }
>> +
>> +       return result;
>> +}
>> +EXPORT_SYMBOL_GPL(max77686_read_gpios);
>> +
>>  static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>>                                                                   *dev)
>>  {
>> +       struct device_node *np = dev->of_node;
>>         struct max77686_platform_data *pd;
>>
>>         pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> @@ -111,6 +223,13 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>>                 return NULL;
>>
>>         dev->platform_data = pd;
>> +
>> +       /* Read default index and ignore errors, since default is 0 */
>> +       of_property_read_u32(np, "max77686,pmic-buck-default-dvs-idx",
>> +                            &pd->buck_default_idx);
> Any error checking code here. Say if pmic-buck-default-dvs-idx exceed 8?

I'm not a DT expert but AFAIK the kernel should expect the data in a FDT to be
correct and should not validate it on runtime. There is work-in-progress to add
a proper schema checking for DTS to the dtc so on build time it can be validated
that a DTS is valid.

AFAIU the only thing that the kernel should check is if a required property does
not exist.

>> +
>> +       max77686_dt_parse_dvs_gpio(dev);
>> +
>>         return pd;
>>  }
>>
>> diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
>> index 4cbcc13..46a736b 100644
>> --- a/include/linux/mfd/max77686.h
>> +++ b/include/linux/mfd/max77686.h
>> @@ -99,15 +99,17 @@ struct max77686_platform_data {
>>         struct max77686_opmode_data *opmode_data;
>>
>>         /*
>> -        * GPIO-DVS feature is not enabled with the current version of
>> -        * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
>> -        * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
>> +        * GPIO-DVS feature is not fully enabled with the current version of
>> +        * MAX77686 driver, but the driver does support using a DVS index other
>> +        * than the default of 0.
>>          */
>> -       int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
>> -       int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
>> -       unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
>> -       unsigned int buck3_voltage[8];
>> -       unsigned int buck4_voltage[8];
> I think when DVS gpio is used all the 8 voltage levels are fetched
> from DT during booting and the registers are programmed accordingly.
> Any further set/get_voltage just changes the GPIO lines.
> Any reason why this method is not used?

What are you describing is how the DT binding works for other Maxim PMICs that
also have DVS support right? (e.g: max8997).

The DVS binding in max77686/802 is actually a subset of the one in max8997 so it
let's you only choose which single DVS index is going to be used. The GPIOs in
"max77686,pmic-buck-dvs-gpios" should match "pmic-buck-default-dvs-idx".

To be honest I just took the DT binding that was used in the max77xxx driver
from the Chrome OS 3.8 kernel and didn't compare it with other Maxim PMICs DT
bingings.

I wonder if I should just take the DVS patches out from this initial version to
avoid blocking the max77802 support and then we can discuss this in more detail.

>> +       struct gpio_desc *buck_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
>> +       int buck_default_idx; /* Default value of DVS1, 2, 3 */
>> +
>> +       struct gpio_desc *buck_gpio_selb[3]; /* Buck regulators 2, 3, 4 */
>>  };
>>
>> +extern int max77686_setup_gpios(struct device *dev);
>> +extern int max77686_read_gpios(struct max77686_platform_data *pdata);
>> +
>>  #endif /* __LINUX_MFD_MAX77686_H */
>> --
>> 2.0.0.rc2
>>

Best regards,
Javier

