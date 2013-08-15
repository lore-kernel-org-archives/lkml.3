Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3HOB14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:27:56 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37873 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HOB1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130814174227.GI4046@lee--X1>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
	<1376468930-9794-4-git-send-email-chao.xie@marvell.com>
	<20130814174227.GI4046@lee--X1>
Date: Thu, 15 Aug 2013 09:27:54 +0800
Message-ID: <CADApbejPaRRX5OM5Ho8-bV2vaKLODOjhOh2Abzb8Auniwdukkw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: 88pm800: add device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chao Xie <chao.xie@marvell.com>, sameo@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +* Marvell 88PM800 Power Management IC
>> +
>> +Required parent device properties:
>> +- compatible : "marvell,88pm800"
>> +- reg : the I2C slave address for the 88pm800 chip
>> +- interrupts : IRQ line for the 88pm800 chip
>> +- interrupt-controller: describes the 88pm800 as an interrupt controller (has its own domain)
>
> You don't need "(has its own domain)", as this is expected.
>
Will remove it.

>> +- #interrupt-cells : should be 1.
>> +             - The cell is the 88pm800 local IRQ number
>
> No need for the last line.
>
will remove it.

>> +Optional parent device properties:
>> +- marvell,88pm800-irq-write-clear: inicates whether interrupt status is cleared by write
>> +- marvell,88pm800-battery-detection: indicats whether need 88pm800 to support battery
>> +                             detection or not.
>
> Not sure what these are. This is why you need to CC the Device Tree
> guys.
>
It is the 88pm805's own configuration.
88pm800-irq-write-clear: when irq happens, the status register is
write clear or read clear.
88pm800-battery-detection: whether the battery is connected to chip.
It means that whether
the chip be aware of battery or not.

>> +88pm800 consists of a large and varied group of sub-devices:
>
> Really? Or just 3?
>
just 3.

>> +Device                        Supply Names    Description
>> +------                        ------------    -----------
>> +88pm80x-onkey                :               : On key
>> +88pm80x-rtc          :               : RTC
>> +88pm80x-regulator    :               : Regulators
>
> If more than 3 please list them.
>
>> +Example:
>> +
>> +     pmic: 88pm800@30 {
>> +             compatible = "marvell,88pm800";
>> +             reg = <0x30>;
>> +             interrupts = <0 4 0x4>;
>
> Use the defines in include/dt-bindings.
>
Will change it

>> +     };
>> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
>> +             !of_property_read_bool(np, "marvell,88pm800-irq-write-clear");
>> +     pdata->batt_det =
>> +             of_property_read_bool(np, "marvell,88pm800-battery-detection");
>> +
>> +     return 0;
>> +}
>> +
>> +
>
> Why two /n's?
>
Will remove addtional one.

>>  static int pm800_probe(struct i2c_client *client,
>>                                const struct i2c_device_id *id)
>>  {
>>       int ret = 0;
>>       struct pm80x_chip *chip;
>>       struct pm80x_platform_data *pdata = client->dev.platform_data;
>> +     struct device_node *node = client->dev.of_node;
>>       struct pm80x_subchip *subchip;
>>
>> +     if (IS_ENABLED(CONFIG_OF)) {
>> +             if (!pdata) {
>> +                     pdata = devm_kzalloc(&client->dev,
>> +                                          sizeof(*pdata), GFP_KERNEL);
>> +                     if (!pdata)
>> +                             return -ENOMEM;
>> +             }
>> +             ret = pm800_dt_init(node, &client->dev, pdata);
>> +             if (ret)
>> +                     return ret;
>> +     } else if (!pdata) {
>> +             return -EINVAL;
>> +     }
>
> Replace with:
>
>         if (!pdata) {
>                 if (node)
>                         /* <blah> populate pdata with DT </blah> */
>                 else
>                         return -EINVAL;
>         }
>
The orignial code will cover the following situation.
1. DT enabled, and user pass pdata
2. DT enabled, but user do not pass pdata
3. DT disabled, user pass pdata
4. DT disabled, user do not pass pdata.

88pm805 has a callback for config the it based on platform requirment.
I do not want to remove this callback now, because it includes so many
configurations.
So i allow user can pass pdata with callback if the platform needs to
configure the chip.

>> +     /*
>> +      * RTC in pmic can run even the core is powered off, and user can set
>> +      * alarm in RTC. When the alarm is time out, the PMIC will power up
>> +      * the core, and the whole system will boot up. When PMIC driver is
>> +      * probed, it will read out some register to find out whether this
>> +      * boot is caused by RTC timeout or not, and it need pass this
>> +      * information to RTC driver.
>> +      * So we need rtc platform data to be existed to pass this information.
>> +      */
>> +     if (!pdata->rtc) {
>> +             pdata->rtc = devm_kzalloc(&client->dev,
>> +                                       sizeof(*(pdata->rtc)), GFP_KERNEL);
>> +             if (!pdata->rtc)
>> +                     return -ENOMEM;
>> +     }
>> +
>>       ret = pm80x_init(client);
>>       if (ret) {
>>               dev_err(&client->dev, "pm800_init fail\n");
>> @@ -612,6 +666,7 @@ static struct i2c_driver pm800_driver = {
>>               .name = "88PM800",
>>               .owner = THIS_MODULE,
>>               .pm = &pm80x_pm_ops,
>> +             .of_match_table = of_match_ptr(pm80x_dt_ids),
>>               },
>>       .probe = pm800_probe,
>>       .remove = pm800_remove,
>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
