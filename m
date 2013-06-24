Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3FXCBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 22:01:43 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56186 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3FXCBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 22:01:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130621152416.GC27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
	<20130621152416.GC27646@sirena.org.uk>
Date: Mon, 24 Jun 2013 10:01:39 +0800
Message-ID: <CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
From: Chao Xie <xiechao.mail@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chao Xie <chao.xie@marvell.com>, lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:24 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 20, 2013 at 03:31:07AM -0400, Chao Xie wrote:
>
> Looks pretty good, main thing here is that some of the functionality
> here appears to be reproducing standard code.
>
>> +static int pm800_set_voltage(struct regulator_dev *rdev,
>> +                          int min_uv, int max_uv, unsigned *selector)
>> +{
>
> Use set_voltage_sel() and map_voltge_ascend()
>
>> +static int pm800_get_voltage(struct regulator_dev *rdev)
>> +{
>> +
>
> Just provide get_voltage_sel(), the core will do the mapping to voltages
> using list_voltage().
>
I am a little confused.
The BUCK voltage is not linear, and it contains a lot of voltages.
If we use map_voltage_ascend, it will looking a a suitable voltage
from begin to end one by one.
It will waist of time.
If we directly make use of set_voltage and get_voltage, we can
directly calculates the voltage which is
suitable, and do not go through all the voltags.
for example, now BUCK voltage table is
range 1 from 600000 to 1587500, each step is 12500
range 2 from 1600000 to 1800000, each step is 50000

When set_voltage(1680000, 1720000)
use map_voltage_ascend, it will go through all voltages range 1, and
then find a suitable voltage in range2
for our code, we direclty find the the voltage is in range2, all need
is (min_uv - range->min_uv)/range->step.
We can get the index, and plus the index with range->index_start, then
we can set the value to register.

>> +     } else if (pdata->num_regulators) {
>> +             /* Check whether num_regulator is valid. */
>> +             unsigned int count = 0;
>> +             for (i = 0; pdata->regulators[i]; i++)
>> +                     count++;
>> +             if (count != pdata->num_regulators)
>> +                     return -EINVAL;
>
> This looks...  odd.
>
It is just make sure that pdata has correct number of regulators.
It you think that it is redundant, i can remove it.

>> +static int __init pm800_regulator_init(void)
>> +{
>> +     return platform_driver_register(&pm800_regulator_driver);
>> +}
>> +subsys_initcall(pm800_regulator_init);
>> +
>> +static void __exit pm800_regulator_exit(void)
>> +{
>> +     platform_driver_unregister(&pm800_regulator_driver);
>> +}
>> +module_exit(pm800_regulator_exit);
>
> With deferred probing you should just be able to use
> module_platform_driver().
>
The regulator controlles some BUCK regulators.
These regulators may be used by application CPU or CP(communication
CPU) for telephony.
The CP may need different voltages if it goes deep initialization. if
we defer the setting later, it is too late for
CP initialization, and will impact the performance.

>> +config REGULATOR_88PM800
>> +     bool "Marvell 88PM800 Power regulators"
>> +     depends on MFD_88PM800=y
>> +     help
>> +       This driver supports Marvell 88PM800 voltage regulator chips.
>> +       It delivers digitally programmable output,
>> +       the voltage is programmed via I2C interface.
>> +       It's suitable to support PXA988 chips to control VCC_MAIN and
>> +       various voltages.
>> +
>
> Keep this file sorted please.
>
I will change it.
>> --- a/drivers/regulator/Makefile
>> +++ b/drivers/regulator/Makefile
>> @@ -70,6 +70,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
>>  obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
>>  obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
>>  obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
>> +obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
>
> Same here.
I will change it.
