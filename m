Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3CLXcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:32:39 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:52797 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3CLXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:32:36 -0400
Message-ID: <513FBB10.8060404@slimlogic.co.uk>
Date: Tue, 12 Mar 2013 23:32:32 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, ldewangan@nvidia.com,
        j-keerthy@ti.com, gg@slimlogic.co.uk, rpurdie@rpsys.net,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 1/2] leds: Add support for Palmas LEDs
References: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk> <CAK5ve-+-=R-f1KpEWD=4J3ia+QXmgnGvhDMV9tNf2_3WZupZaA@mail.gmail.com>
In-Reply-To: <CAK5ve-+-=R-f1KpEWD=4J3ia+QXmgnGvhDMV9tNf2_3WZupZaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/13 18:57, Bryan Wu wrote:
> On Thu, Feb 28, 2013 at 7:21 AM, Ian Lartey <ian@slimlogic.co.uk> wrote:
>> The Palmas familly of chips has LED support. This is not always muxed
>> to output pins so depending on the setting of the mux this driver
>> will create the appropriate LED class devices.
>>
>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
>> ---
>>   drivers/leds/leds-palmas.c |  560 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/mfd/palmas.h |   60 +++++
>>   2 files changed, 620 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/leds/leds-palmas.c
>>
>> diff --git a/drivers/leds/leds-palmas.c b/drivers/leds/leds-palmas.c
>> new file mode 100644
>> index 0000000..73adb32
>> --- /dev/null
>> +++ b/drivers/leds/leds-palmas.c
>> @@ -0,0 +1,560 @@
>> +/*
>> + * Driver for LED part of Palmas PMIC Chips
>> + *
>> + * Copyright 2011 Texas Instruments Inc.
>> + *
>
> Please update this date, like 2011 - 2013.

Hello Bryan,

This patchset has been superseded by "v8 Palmas Update"
and for the LED driver in particular by
"[PATCH v8 09/12] leds: Add support for Palmas LEDs"

I will however incorporate the necessary changes you have
suggested here into the v9 patchset (minus the spinlock change)

I'll also make sure I cc you on the v9 patchset.

Regards,

Ian
>
>> + * Author: Graeme Gregory <gg@slimlogic.co.uk>
>> + * Author: Ian Lartey <ian@slimlogic.co.uk>
>> + *
>> + *  This program is free software; you can redistribute it and/or modify it
>> + *  under  the terms of the GNU General  Public License as published by the
>> + *  Free Software Foundation;  either version 2 of the License, or (at your
>> + *  option) any later version.
>> + *
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/leds.h>
>> +#include <linux/mfd/palmas.h>
>> +#include <linux/module.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +
>> +struct palmas_leds_data;
>> +
>> +struct palmas_led {
>> +       struct led_classdev cdev;
>> +       struct palmas_leds_data *leds_data;
>> +       int led_no;
>> +       struct work_struct work;
>> +       struct mutex mutex;
>> +
>> +       spinlock_t value_lock;
>> +
>
> I think you don't need this spinlock to protect the value, the mutex is enough.
>
>> +       int blink;
>> +       int on_time;
>> +       int period;
>> +       enum led_brightness brightness;
>> +};
>> +
>> +struct palmas_leds_data {
>> +       struct device *dev;
>> +       struct led_classdev cdev;
>> +       struct palmas *palmas;
>> +
>> +       struct palmas_led *palmas_led;
>> +       int no_leds;
>> +};
>> +
>> +#define to_palmas_led(led_cdev) \
>> +       container_of(led_cdev, struct palmas_led, cdev)
>> +
>> +#define LED_ON_62_5MS          0x00
>> +#define LED_ON_125MS           0x01
>> +#define LED_ON_250MS           0x02
>> +#define LED_ON_500MS           0x03
>> +
>> +#define LED_PERIOD_OFF         0x00
>> +#define LED_PERIOD_125MS       0x01
>> +#define LED_PERIOD_250MS       0x02
>> +#define LED_PERIOD_500MS       0x03
>> +#define LED_PERIOD_1000MS      0x04
>> +#define LED_PERIOD_2000MS      0x05
>> +#define LED_PERIOD_4000MS      0x06
>> +#define LED_PERIOD_8000MS      0x07
>> +
>> +
>> +static char *palmas_led_names[] = {
>> +       "palmas:led1",
>> +       "palmas:led2",
>> +       "palmas:led3",
>> +       "palmas:led4",
>> +};
>> +
>> +static int palmas_led_read(struct palmas_leds_data *leds, unsigned int reg,
>> +               unsigned int *dest)
>> +{
>> +       return palmas_read(leds->palmas, PALMAS_LED_BASE, reg, dest);
>> +}
>> +
>> +static int palmas_led_write(struct palmas_leds_data *leds, unsigned int reg,
>> +               unsigned int value)
>> +{
>> +       return palmas_write(leds->palmas, PALMAS_LED_BASE, reg, value);
>> +}
>> +
>> +static int palmas_led_update_bits(struct palmas_leds_data *leds,
>> +               unsigned int reg, unsigned int mask, unsigned int value)
>> +{
>> +       return palmas_update_bits(leds->palmas, PALMAS_LED_BASE,
>> +                       reg, mask, value);
>> +}
>> +
>> +static void palmas_leds_work(struct work_struct *work)
>> +{
>> +       struct palmas_led *led = container_of(work, struct palmas_led, work);
>> +       unsigned int period, ctrl;
>> +       unsigned long flags;
>> +
>> +       mutex_lock(&led->mutex);
>> +
>> +       palmas_led_read(led->leds_data, PALMAS_LED_CTRL, &ctrl);
>> +       palmas_led_read(led->leds_data, PALMAS_LED_PERIOD_CTRL, &period);
>> +
>> +       spin_lock_irqsave(&led->value_lock, flags);
>> +
>> +       switch (led->led_no) {
>> +       case 1:
>> +               ctrl &= ~PALMAS_LED_CTRL_LED_1_ON_TIME_MASK;
>> +               period &= ~PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_MASK;
>> +
>> +               if (led->blink) {
>> +                       ctrl |= led->on_time <<
>> +                               PALMAS_LED_CTRL_LED_1_ON_TIME_SHIFT;
>> +                       period |= led->period <<
>> +                               PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_SHIFT;
>> +               } else {
>> +                       /*
>> +                        * for off value is zero which we already set by
>> +                        * masking earlier.
>> +                        */
>> +                       if (led->brightness) {
>> +                               ctrl |= LED_ON_500MS <<
>> +                                       PALMAS_LED_CTRL_LED_1_ON_TIME_SHIFT;
>> +                               period |= LED_PERIOD_500MS <<
>> +                               PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_SHIFT;
>> +                       }
>> +               }
>> +       case 2:
>> +               ctrl &= ~PALMAS_LED_CTRL_LED_2_ON_TIME_MASK;
>> +               period &= ~PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_MASK;
>> +
>> +               if (led->blink) {
>> +                       ctrl |= led->on_time <<
>> +                               PALMAS_LED_CTRL_LED_2_ON_TIME_SHIFT;
>> +                       period |= led->period <<
>> +                               PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_SHIFT;
>> +               } else {
>> +                       /*
>> +                        * for off value is zero which we already set by
>> +                        * masking earlier.
>> +                        */
>> +                       if (led->brightness) {
>> +                               ctrl |= LED_ON_500MS <<
>> +                                       PALMAS_LED_CTRL_LED_2_ON_TIME_SHIFT;
>> +                               period |= LED_PERIOD_500MS <<
>> +                               PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_SHIFT;
>> +                       }
>> +               }
>> +       case 3:
>> +               ctrl &= ~PALMAS_LED_CTRL2_LED_3_ON_TIME_MASK;
>> +               period &= ~PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_MASK;
>> +
>> +               if (led->blink) {
>> +                       ctrl |= led->on_time <<
>> +                               PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT;
>> +                       period |= led->period <<
>> +                               PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT;
>> +               } else {
>> +                       /*
>> +                        * for off value is zero which we already set by
>> +                        * masking earlier.
>> +                        */
>> +                       if (led->brightness) {
>> +                               ctrl |= LED_ON_500MS <<
>> +                                       PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT;
>> +                               period |= LED_PERIOD_500MS <<
>> +                               PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT;
>> +                       }
>> +               }
>> +               break;
>> +       case 4:
>> +               ctrl &= ~PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_MASK;
>> +               period &= ~PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_MASK;
>> +
>> +               if (led->blink) {
>> +                       ctrl |= led->on_time <<
>> +                               PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT;
>> +                       period |= led->period <<
>> +                               PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT;
>> +               } else {
>> +                       /*
>> +                        * for off value is zero which we already set by
>> +                        * masking earlier.
>> +                        */
>> +                       if (led->brightness) {
>> +                               ctrl |= LED_ON_500MS <<
>> +                                       PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT;
>> +                               period |= LED_PERIOD_500MS <<
>> +                               PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT;
>> +                       }
>> +               }
>> +               break;
>> +       }
>> +
>
> This switch-case can definitely be written in a function and you pass
> (led->led_no) to the function and get the right MASK or SHIFT values
> out from a enum struct. Then do the settings. That will be more
> readable and maintainable.
>
>> +       spin_unlock_irqrestore(&led->value_lock, flags);
>> +
>> +       if (led->led_no < 3) {
>> +               palmas_led_write(led->leds_data, PALMAS_LED_CTRL, ctrl);
>> +               palmas_led_write(led->leds_data, PALMAS_LED_PERIOD_CTRL,
>> +                               period);
>> +       } else {
>> +               palmas_led_write(led->leds_data, PALMAS_LED_CTRL2, ctrl);
>> +               palmas_led_write(led->leds_data, PALMAS_LED_PERIOD2_CTRL,
>> +                               period);
>> +       }
>> +
>> +       if (is_palmas_charger(led->leds_data->palmas->product_id)) {
>> +               if (led->brightness || led->blink)
>> +                       palmas_led_update_bits(led->leds_data, PALMAS_LED_EN,
>> +                                       1 << (led->led_no - 1), 0xFF);
>> +               else
>> +                       palmas_led_update_bits(led->leds_data, PALMAS_LED_EN,
>> +                                       1 << (led->led_no - 1), 0x00);
>> +       }
>> +       mutex_unlock(&led->mutex);
>> +}
>> +
>> +static void palmas_leds_set(struct led_classdev *led_cdev,
>> +                          enum led_brightness value)
>> +{
>> +       struct palmas_led *led = to_palmas_led(led_cdev);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&led->value_lock, flags);
>> +       led->brightness = value;
>> +       led->blink = 0;
>> +       schedule_work(&led->work);
>> +       spin_unlock_irqrestore(&led->value_lock, flags);
>> +}
>> +
>> +static int palmas_leds_blink_set(struct led_classdev *led_cdev,
>> +                                  unsigned long *delay_on,
>> +                                  unsigned long *delay_off)
>> +{
>> +       struct palmas_led *led = to_palmas_led(led_cdev);
>> +       unsigned long flags;
>> +       int ret = 0;
>> +       int period;
>> +
>> +       /* Pick some defaults if we've not been given times */
>> +       if (*delay_on == 0 && *delay_off == 0) {
>> +               *delay_on = 250;
>> +               *delay_off = 250;
>> +       }
>> +
>> +       spin_lock_irqsave(&led->value_lock, flags);
>> +
>> +       /*
>> +        * We only have a limited selection of settings, see if we can
>> +        * support the configuration we're being given
>> +        */
>> +       switch (*delay_on) {
>> +       case 500:
>> +               led->on_time = LED_ON_500MS;
>> +               break;
>> +       case 250:
>> +               led->on_time = LED_ON_250MS;
>> +               break;
>> +       case 125:
>> +               led->on_time = LED_ON_125MS;
>> +               break;
>> +       case 62:
>> +       case 63:
>> +               /* Actually 62.5ms */
>> +               led->on_time = LED_ON_62_5MS;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +
>> +       period = *delay_on + *delay_off;
>> +
>> +       if (ret == 0) {
>> +               switch (period) {
>> +               case 124:
>> +               case 125:
>> +               case 126:
>> +                       /* All possible variations of 62.5 + 62.5 */
>> +                       led->period = LED_PERIOD_125MS;
>> +                       break;
>> +               case 250:
>> +                       led->period = LED_PERIOD_250MS;
>> +                       break;
>> +               case 500:
>> +                       led->period = LED_PERIOD_500MS;
>> +                       break;
>> +               case 1000:
>> +                       led->period = LED_PERIOD_1000MS;
>> +                       break;
>> +               case 2000:
>> +                       led->period = LED_PERIOD_2000MS;
>> +                       break;
>> +               case 4000:
>> +                       led->period = LED_PERIOD_4000MS;
>> +                       break;
>> +               case 8000:
>> +                       led->period = LED_PERIOD_8000MS;
>> +                       break;
>> +               default:
>> +                       ret = -EINVAL;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (ret == 0)
>> +               led->blink = 1;
>> +       else
>> +               led->blink = 0;
>> +
>> +       /*
>> +        * Always update; if we fail turn off blinking since we expect
>> +        * a software fallback.
>> +        */
>> +       schedule_work(&led->work);
>> +
>> +       spin_unlock_irqrestore(&led->value_lock, flags);
>> +
>> +       return ret;
>> +}
>> +
>> +static void palmas_init_led(struct palmas_leds_data *leds_data, int offset,
>> +               int led_no)
>> +{
>> +       mutex_init(&leds_data->palmas_led[offset].mutex);
>> +       INIT_WORK(&leds_data->palmas_led[offset].work, palmas_leds_work);
>> +       spin_lock_init(&leds_data->palmas_led[offset].value_lock);
>> +
>> +       leds_data->palmas_led[offset].leds_data = leds_data;
>> +       leds_data->palmas_led[offset].led_no = led_no;
>> +       leds_data->palmas_led[offset].cdev.name = palmas_led_names[led_no - 1];
>> +       leds_data->palmas_led[offset].cdev.default_trigger = NULL;
>> +       leds_data->palmas_led[offset].cdev.brightness_set = palmas_leds_set;
>> +       leds_data->palmas_led[offset].cdev.blink_set = palmas_leds_blink_set;
>> +}
>> +
>> +static int  palmas_dt_to_pdata(struct device *dev,
>> +               struct device_node *node,
>> +               struct palmas_leds_platform_data *pdata)
>> +{
>> +       struct device_node *child_node;
>> +       int ret;
>> +       u32 prop;
>> +
>> +       child_node = of_get_child_by_name(node, "palmas_leds");
>> +       if (!child_node) {
>> +               dev_err(dev, "child node 'palmas_leds' not found\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = of_property_read_u32(child_node, "ti,led1_current", &prop);
>> +       if (!ret)
>> +               pdata->led1_current = prop;
>> +
>> +       ret = of_property_read_u32(child_node, "ti,led2_current", &prop);
>> +       if (!ret)
>> +               pdata->led2_current = prop;
>> +
>> +       ret = of_property_read_u32(child_node, "ti,led3_current", &prop);
>> +       if (!ret)
>> +               pdata->led3_current = prop;
>> +
>> +       ret = of_property_read_u32(child_node, "ti,led4_current", &prop);
>> +       if (!ret)
>> +               pdata->led4_current = prop;
>> +
>> +       ret = of_property_read_u32(child_node, "ti,chrg_led_mode", &prop);
>> +       if (!ret)
>> +               pdata->chrg_led_mode = prop;
>> +
>> +       ret = of_property_read_u32(child_node, "ti,chrg_led_vbat_low", &prop);
>> +       if (!ret)
>> +               pdata->chrg_led_vbat_low = prop;
>> +
>> +       return 0;
>> +}
>> +
>> +static int palmas_leds_probe(struct platform_device *pdev)
>> +{
>> +       struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
>> +       struct palmas_leds_platform_data *pdata = pdev->dev.platform_data;
>> +       struct palmas_leds_data *leds_data;
>> +       struct device_node *node = pdev->dev.of_node;
>> +       int ret, i;
>> +       int offset = 0;
>> +
>> +       if (!palmas->led_muxed && !is_palmas_charger(palmas->product_id)) {
>> +               dev_err(&pdev->dev, "there are no LEDs muxed\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Palmas charger requires platform data */
>> +       if (is_palmas_charger(palmas->product_id) && node && !pdata) {
>> +
>> +               if (!pdata)
>> +                       return -ENOMEM;
>> +
>> +               ret = palmas_dt_to_pdata(&pdev->dev, node, pdata);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       if (is_palmas_charger(palmas->product_id) && !pdata)
>> +               return -EINVAL;
>> +
>> +       leds_data = devm_kzalloc(&pdev->dev, sizeof(*leds_data), GFP_KERNEL);
>> +       if (!leds_data)
>> +               return -ENOMEM;
>> +       platform_set_drvdata(pdev, leds_data);
>> +
>> +       leds_data->palmas = palmas;
>> +
>> +       switch (palmas->led_muxed) {
>> +       case PALMAS_LED1_MUXED | PALMAS_LED2_MUXED:
>> +               leds_data->no_leds = 2;
>> +               break;
>> +       case PALMAS_LED1_MUXED:
>> +       case PALMAS_LED2_MUXED:
>> +               leds_data->no_leds = 1;
>> +               break;
>> +       default:
>> +               leds_data->no_leds = 0;
>> +               break;
>> +       }
>> +
>> +       if (is_palmas_charger(palmas->product_id)) {
>> +               if (pdata->chrg_led_mode)
>> +                       leds_data->no_leds += 2;
>> +               else
>> +                       leds_data->no_leds++;
>> +       }
>> +
>> +       if (leds_data->no_leds == 0)
>> +               leds_data->palmas_led = NULL;
>> +       else
>> +               leds_data = devm_kzalloc(&pdev->dev,
>> +                               leds_data->no_leds * sizeof(*leds_data),
>> +                               GFP_KERNEL);
>> +
>> +       /* Initialise LED1 */
>> +       if (palmas->led_muxed & PALMAS_LED1_MUXED) {
>> +               palmas_init_led(leds_data, offset, 1);
>> +               offset++;
>> +       }
>> +
>> +       /* Initialise LED2 */
>> +       if (palmas->led_muxed & PALMAS_LED2_MUXED) {
>> +               palmas_init_led(leds_data, offset, 2);
>> +               offset++;
>> +       }
>> +
>> +       if (is_palmas_charger(palmas->product_id)) {
>> +               palmas_init_led(leds_data, offset, 3);
>> +               offset++;
>> +
>> +               if (pdata->chrg_led_mode) {
>> +                       palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
>> +                                       PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE,
>> +                                       PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE);
>> +
>> +                       palmas_init_led(leds_data, offset, 4);
>> +               }
>> +       }
>> +
>> +       for (i = 0; i < leds_data->no_leds; i++) {
>> +               ret = led_classdev_register(leds_data->dev,
>> +                               &leds_data->palmas_led[i].cdev);
>> +               if (ret < 0) {
>> +                       dev_err(&pdev->dev,
>> +                               "Failed to register LED no: %d err: %d\n",
>> +                               i, ret);
>> +                       goto err_led;
>> +               }
>> +       }
>> +
>> +       if (!is_palmas_charger(palmas->product_id))
>> +               return 0;
>> +
>> +       /* Set the LED current registers if set in platform data */
>> +       if (pdata->led1_current)
>> +               palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL1,
>> +                               PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_MASK,
>> +                               pdata->led1_current);
>> +
>> +       if (pdata->led2_current)
>> +               palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL1,
>> +                               PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_MASK,
>> +                               pdata->led2_current <<
>> +                               PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_SHIFT);
>> +
>> +       if (pdata->led3_current)
>> +               palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL2,
>> +                               PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK,
>> +                               pdata->led3_current);
>> +
>> +       if (pdata->led3_current)
>> +               palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL2,
>> +                               PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK,
>> +                               pdata->led3_current);
>> +
>> +       if (pdata->led4_current)
>> +               palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
>> +                               PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_MASK,
>> +                               pdata->led4_current <<
>> +                               PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_SHIFT);
>> +
>> +       if (pdata->chrg_led_vbat_low)
>> +               palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
>> +                               PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS,
>> +                               PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS);
>> +
>> +       return 0;
>> +
>> +err_led:
>> +       for (i = 0; i < leds_data->no_leds; i++)
>> +               led_classdev_unregister(&leds_data->palmas_led[i].cdev);
>> +       kfree(leds_data->palmas_led);
>> +       kfree(leds_data);
>> +       return ret;
>> +}
>> +
>> +static int palmas_leds_remove(struct platform_device *pdev)
>> +{
>> +       struct palmas_leds_data *leds_data = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       for (i = 0; i < leds_data->no_leds; i++)
>> +               led_classdev_unregister(&leds_data->palmas_led[i].cdev);
>> +       if (i)
>> +               kfree(leds_data->palmas_led);
>> +       kfree(leds_data);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct of_device_id of_palmas_match_tbl[] = {
>> +       { .compatible = "ti,palmas-leds", },
>> +       { /* end */ }
>> +};
>> +
>> +static struct platform_driver palmas_leds_driver = {
>> +       .driver = {
>> +               .name = "palmas-leds",
>> +               .of_match_table = of_palmas_match_tbl,
>> +               .owner = THIS_MODULE,
>> +       },
>> +       .probe = palmas_leds_probe,
>> +       .remove = palmas_leds_remove,
>> +};
>> +
>> +module_platform_driver(palmas_leds_driver);
>> +
>> +MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
>> +MODULE_DESCRIPTION("Palmas LED driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:palmas-leds");
>> +MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
>> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
>> index 0b86845..856f54e 100644
>> --- a/include/linux/mfd/palmas.h
>> +++ b/include/linux/mfd/palmas.h
>> @@ -232,6 +232,16 @@ struct palmas_clk_platform_data {
>>          int clk32kgaudio_mode_sleep;
>>   };
>>
>> +struct palmas_leds_platform_data {
>> +       int led1_current;
>> +       int led2_current;
>> +       int led3_current;
>> +       int led4_current;
>> +
>> +       int chrg_led_mode;
>> +       int chrg_led_vbat_low;
>> +};
>> +
>>   struct palmas_platform_data {
>>          int gpio_base;
>>
>> @@ -1855,6 +1865,12 @@ enum usb_irq_events {
>>   #define PALMAS_LED_CTRL                                                0x1
>>   #define PALMAS_PWM_CTRL1                                       0x2
>>   #define PALMAS_PWM_CTRL2                                       0x3
>> +#define PALMAS_LED_PERIOD2_CTRL                                        0x4
>> +#define PALMAS_LED_CTRL2                                       0x5
>> +#define PALMAS_LED_CURRENT_CTRL1                               0x6
>> +#define PALMAS_LED_CURRENT_CTRL2                               0x7
>> +#define PALMAS_CHRG_LED_CTRL                                   0x8
>> +#define PALMAS_LED_EN                                          0x9
>>
>>   /* Bit definitions for LED_PERIOD_CTRL */
>>   #define PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_MASK               0x38
>> @@ -1882,6 +1898,50 @@ enum usb_irq_events {
>>   #define PALMAS_PWM_CTRL2_PWM_DUTY_SEL_MASK                     0xff
>>   #define PALMAS_PWM_CTRL2_PWM_DUTY_SEL_SHIFT                    0
>>
>> +/* Bit definitions for LED_PERIOD2_CTRL */
>> +#define PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_MASK           0x38
>> +#define PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT          3
>> +#define PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_MASK              0x07
>> +#define PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT             0
>> +
>> +/* Bit definitions for LED_CTRL2 */
>> +#define PALMAS_LED_CTRL2_CHRG_LED_SEQ                          0x20
>> +#define PALMAS_LED_CTRL2_CHRG_LED_SEQ_SHIFT                    5
>> +#define PALMAS_LED_CTRL2_LED_3_SEQ                             0x10
>> +#define PALMAS_LED_CTRL2_LED_3_SEQ_SHIFT                       4
>> +#define PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_MASK                 0x0c
>> +#define PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT                        2
>> +#define PALMAS_LED_CTRL2_LED_3_ON_TIME_MASK                    0x03
>> +#define PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT                   0
>> +
>> +/* Bit definitions for LED_CURRENT_CTRL1 */
>> +#define PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_MASK            0x38
>> +#define PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_SHIFT           3
>> +#define PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_MASK            0x07
>> +#define PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_SHIFT           0
>> +
>> +/* Bit definitions for LED_CURRENT_CTRL2 */
>> +#define PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK            0x07
>> +#define PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_SHIFT           0
>> +
>> +/* Bit definitions for CHRG_LED_CTRL */
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_MASK             0x38
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_SHIFT            3
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS               0x02
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS_SHIFT         1
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE                     0x01
>> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE_SHIFT               0
>> +
>> +/* Bit definitions for LED_EN */
>> +#define PALMAS_LED_EN_CHRG_LED_EN                              0x08
>> +#define PALMAS_LED_EN_CHRG_LED_EN_SHIFT                                3
>> +#define PALMAS_LED_EN_LED_3_EN                                 0x04
>> +#define PALMAS_LED_EN_LED_3_EN_SHIFT                           2
>> +#define PALMAS_LED_EN_LED_2_EN                                 0x02
>> +#define PALMAS_LED_EN_LED_2_EN_SHIFT                           1
>> +#define PALMAS_LED_EN_LED_1_EN                                 0x01
>> +#define PALMAS_LED_EN_LED_1_EN_SHIFT                           0
>> +
>>   /* Registers for function INTERRUPT */
>>   #define PALMAS_INT1_STATUS                                     0x0
>>   #define PALMAS_INT1_MASK                                       0x1
>> --
>> 1.7.0.4
>>
>
> I prefer you fold the PATCH 2/2 into this one, if there any conflict I
> can solve that. Drivers source code coming with Kconfig/Makefile
> change is easier to maintain.
>
> Thanks,
> -Bryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

