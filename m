Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaAICPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:15:36 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39535 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAICPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140108223933.GD18611@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
	<20140108223933.GD18611@lee--X1>
Date: Thu, 9 Jan 2014 02:15:33 +0000
X-Google-Sender-Auth: B-piPt4uSXxuKdEsf0MaeN_g_IY
Message-ID: <CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 10:39 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
>> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>>
>> This patch is an initial release of a MAX6650/6651 MFD driver that
>> supports to enable the chip with its primary I2C bus that will connect
>> the hwmon, and then the gpio devices for now.
>>
>> Signed-off-by: Laszlo Papp <lpapp@kde.org>
>> ---
>>  drivers/mfd/Kconfig                 |  11 +++
>>  drivers/mfd/Makefile                |   1 +
>>  drivers/mfd/max6651.c               | 132 ++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max6651-private.h |  53 +++++++++++++++
>>  4 files changed, 197 insertions(+)
>>  create mode 100644 drivers/mfd/max6651.c
>>  create mode 100644 include/linux/mfd/max6651-private.h
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index dd67158..706c4e5 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -321,6 +321,17 @@ config MFD_88PM860X
>>         select individual components like voltage regulators, RTC and
>>         battery-charger under the corresponding menus.
>>
>> +config MFD_MAX6651
>> +     bool "Maxim Semiconductor MAX6651 Support"
>> +     depends on I2C=y
>> +     select MFD_CORE
>> +     select IRQ_DOMAIN
>
> Why have you selected IRQ_DOMAIN?

Initial consistency with other corresponding drivers, but I should
have dropped it once I dropped the irq handling to be as simple as
possible initially.

>> +#include <linux/device.h>
>> +#include <linux/delay.h>
>> +#include <linux/input.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/i2c.h>
>
> Are you sure all these are used? I'm pretty sure some of them are
> not. Only add headers if you require them. Try not to copy and paste
> stuff you don't need.

Yes, this was meant to be the "final clean up step". I aimed
functionality and design first.

>> +#include <linux/mfd/max6651-private.h>
>> +
>> +static struct mfd_cell max6651_devs[] = {
>> +    { .name = "max6651-gpio", },
>> +    { .name = "max6650", },
>
> It would be nice to have a comment here to indicate that this is a
> hwmon driver. If you're planning to add support for the MAX6651 to
> this existing driver,

Actually, it is already renamed to max6650-hwmon in the next patch of
this series.

> also consider renaming it to "max665x".

Hmm, I will consider.

>> +};
>> +
>> +int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>
> Probably best to use Regmap instead.
>
> regmap_i2c_read()

Yes, do not worry, this was already done after Linus' initial comment.
Note that, it will be a bit hackish to get it working with 3.2 where
the device regmap convenience wrapper was missing, but I guess
backporting is my problem, not yours...

>> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> +    int ret;
>
> Always use 8 char tabs for kernel code.

As discussed, style stuff is not fixed for a design review. I am still
intereted in having an automated fix-up like astyle in other projects?
What is the recommended way? I really would not like to waste too much
time with style clean up.

>> +    mutex_lock(&max6651->iolock);
>> +    ret = i2c_smbus_read_byte_data(i2c, reg);
>> +    mutex_unlock(&max6651->iolock);
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    ret &= 0xff;
>> +    *dest = ret;
>
> *dest = ret & 0xff is clear enough.

I think this function would be removed altogether instead.

>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(max6651_read_reg);
>> +
>> +int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
>> +{
>> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> +    int ret;
>
> Same here.
>
> regmap_i2c_write()

See above.

>> +    mutex_lock(&max6651->iolock);
>> +    ret = i2c_smbus_write_byte_data(i2c, reg, value);
>> +    mutex_unlock(&max6651->iolock);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(max6651_write_reg);
>> +
>> +static int max6651_i2c_probe(struct i2c_client *i2c,
>> +                         const struct i2c_device_id *id)
>> +{
>> +     struct max6651_dev *max6651;
>> +     int ret = 0;
>
> Why are you initialising ret?

Habit for striving for good pratice, I think. It may have also been
consitency. That being said, I already removed it when I took a look
at the other driver based on Linus' suggestion. I was trying to be
consistent with other maxim drivers.

The linux kernel drivers are inconsistent in general at large,
unfortunately. It is hard to pick up the "right one" for consistency.
I will do whatever asked as it really does not make any difference for
me.

>> +     max6651 = kzalloc(sizeof(struct max6651_dev), GFP_KERNEL);
>
> Use managed resources devm_*.

Yes, that was also done after Linus' suggestion.

> s/sizeof(struct max6651_dev)/sizeof(*max6651)/
>
>> +     if (max6651 == NULL)
>
> if (!max6651)

Yes, that was also done after Linus' suggestion, although this is
consistent with the other maxim drivers. I will refactor those
later...

>> +             return -ENOMEM;
>> +
>> +     i2c_set_clientdata(i2c, max6651);
>> +     max6651->dev = &i2c->dev;
>> +
>> +     mutex_init(&max6651->iolock);
>> +
>> +     ret = mfd_add_devices(max6651->dev, -1, max6651_devs,
>> +                     ARRAY_SIZE(max6651_devs),
>> +                     NULL, 0, NULL);
>> +
>> +     if (ret < 0) {
>> +        dev_err(max6651->dev, "cannot add mfd cells\n");
>
> Are you trying to add cells or register devices?

I would not know the difference in this context. Care to elaborate?

>> +             goto err_mfd;
>> +    }
>> +
>> +     return ret;
>> +
>> +err_mfd:
>> +     mfd_remove_devices(max6651->dev);
>
> If mfd_add_devices() failed, you don't need to remove them.

Sure.

>> +     kfree(max6651);
>
> If you use managed resources you don't need this.

I am not sure what exactly you mean by managed resource here. I only
used the malloc above as far as I can tell. Perhaps, the called
function has some magic behind. I would need to double check...

>> +     return ret;
>> +}
>> +
>> +static int max6651_i2c_remove(struct i2c_client *i2c)
>> +{
>> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> +
>> +    mfd_remove_devices(max6651->dev);
>
> In this case you would normally need to kfree() here, but if you use
> managed resources you won't have to.

As above...

>> +    return 0;
>> +}
>> +
>> +static const struct i2c_device_id max6651_i2c_id[] = {
>> +    { "max6650", TYPE_MAX6650 },
>> +    { "max6651", TYPE_MAX6651 },
>
> So were're registering the max6650 from here too?

Absolutely, that is the idea.

> If so, then you need to change the name of the file.
>
>> +    { }
>
> {},

Yep, tiring style stuff...

>> +};
>> +MODULE_DEVICE_TABLE(i2c, max6651_i2c_id);
>> +
>> +static struct i2c_driver max6651_i2c_driver = {
>> +    .driver = {
>> +           .name = "max6651",
>> +           .owner = THIS_MODULE,
>> +    },
>> +    .probe = max6651_i2c_probe,
>> +    .remove = max6651_i2c_remove,
>> +    .id_table = max6651_i2c_id,
>> +};
>
> Remove from here ------
>
>> +static int __init max6651_i2c_init(void)
>> +{
>> +    return i2c_add_driver(&max6651_i2c_driver);
>> +}
>> +/* init early so consumer devices can complete system boot */
>
> I don't think this is required.
>
>> +subsys_initcall(max6651_i2c_init);
>> +
>> +static void __exit max6651_i2c_exit(void)
>> +{
>> +    i2c_del_driver(&max6651_i2c_driver);
>> +}
>> +module_exit(max6651_i2c_exit);
>
> To here -----
>
>  and replace with one line:
>
>   module_i2c_driver()

Yes, this was for consistency again, and modified after Linus' hint.
The other maxim drivers need to be patched later....

>> +#ifndef __LINUX_MFD_MAX6651_PRIVATE_H
>> +#define __LINUX_MFD_MAX6651_PRIVATE_H
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/export.h>
>
> Why is this in here?

Because this series was meant for a design review and overall
direction as opposed to a completely fine tuned patch set. Naturally,
I agree with the feedback of removing unnecessary header inclusion.

>> +#include <linux/irqdomain.h>
>
> And this?

Same stuff as above...

>> +struct max6651_dev {
>> +    struct device *dev;
>> +    struct mutex iolock;
>> +
>> +    struct i2c_client *i2c;
>
> Is this used?

Yes, heavily, for reading and writing the registers in the subdevice drivers.

>> +     int type;
>
> Or this?

Absolutely, this identifies the type, which is necessary for
initializing some corresponding data.

>> +};
>> +
>> +enum max6651_types {
>> +     TYPE_MAX6650,
>> +     TYPE_MAX6651,
>> +};
>
> What are you using these for?

See above.

>> +extern int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
>> +extern int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
>
> regmap_i2c_read()
> regmap_i2c_write()

Sure, that was done after Linus' hint.

Thanks for the review...

Cheers ...
