Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaAIKdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:33:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaAIKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140109094147.GA20699@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
	<20140108223933.GD18611@lee--X1>
	<CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
	<20140109094147.GA20699@lee--X1>
Date: Thu, 9 Jan 2014 10:33:00 +0000
X-Google-Sender-Auth: Mf7YB9icPlIGXNNjV1YVx9LIeE4
Message-ID: <CAOMwXhO=0K+SL2rNo_7JvKVET2DYZnTSr_=wzFedz2e2z_3u1w@mail.gmail.com>
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

On Thu, Jan 9, 2014 at 9:41 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> +config MFD_MAX6651
>> >> +     bool "Maxim Semiconductor MAX6651 Support"
>> >> +     depends on I2C=y
>> >> +     select MFD_CORE
>> >> +     select IRQ_DOMAIN
>> >
>> > Why have you selected IRQ_DOMAIN?
>>
>> Initial consistency with other corresponding drivers, but I should
>> have dropped it once I dropped the irq handling to be as simple as
>> possible initially.
>
> IRQ_DOMAINs are only relevant for IRQ Controllers.

Sure.

>> >> +#include <linux/device.h>
>> >> +#include <linux/delay.h>
>> >> +#include <linux/input.h>
>> >> +#include <linux/interrupt.h>
>> >> +#include <linux/mfd/core.h>
>> >> +#include <linux/slab.h>
>> >> +#include <linux/module.h>
>> >> +#include <linux/i2c.h>
>> >
>> > Are you sure all these are used? I'm pretty sure some of them are
>> > not. Only add headers if you require them. Try not to copy and paste
>> > stuff you don't need.
>>
>> Yes, this was meant to be the "final clean up step". I aimed
>> functionality and design first.
>
> In future please only send your best, most cleaned-up
> code. Sub-standard codes desearves nothing but a sub-standard review.

Do not worry, I appreciate your review a lot. :)

>> >> +#include <linux/mfd/max6651-private.h>
>> >> +
>> >> +static struct mfd_cell max6651_devs[] = {
>> >> +    { .name = "max6651-gpio", },
>> >> +    { .name = "max6650", },
>> >
>> > It would be nice to have a comment here to indicate that this is a
>> > hwmon driver. If you're planning to add support for the MAX6651 to
>> > this existing driver,
>>
>> Actually, it is already renamed to max6650-hwmon in the next patch of
>> this series.
>
> This won't work, as you haven't changed the name in the
> platform_driver struct. And rightly so, as it has nothing to do with
> converting the driver over to a platform one. Pull the part that
> changes the name into another patch.

I already changed that locally last week when debugging the
platform_match bug about it... This two lines can be taken into a
fourth patch, surely, but is it worth it when the change is already
long for the conversion and two lines do not make much difference.
Anyway, I will surely do it since you would seem to be happier.

>> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> >> +    int ret;
>> >
>> > Always use 8 char tabs for kernel code.
>>
>> As discussed, style stuff is not fixed for a design review. I am still
>> intereted in having an automated fix-up like astyle in other projects?
>> What is the recommended way? I really would not like to waste too much
>> time with style clean up.
>
> If you send any more lazy patches where it's clear that no attempt has
> been made to adhere to the documentation I've provided you with, I
> won't review. 'Please', no more half-ar$ed patches RFC or otherwise.
>
> There is no automated way to get styling right, but the first step is
> to set your editor's config for 8 char tabbing at a bare minimum.

Yes, I understand. The problem is that the Linux kernel is not the
only project I am contributing to. That is why I was asking what
people do in similar scenarios. Do they have different editor profiles
for each project? How is it gently solved? What is the best practice?
I am using vim for what it is worth. Although, I can probably ask this
on the list in a different thread.... Will do it.

>> >> +static int max6651_i2c_probe(struct i2c_client *i2c,
>> >> +                         const struct i2c_device_id *id)
>> >> +{
>> >> +     struct max6651_dev *max6651;
>> >> +     int ret = 0;
>> >
>> > Why are you initialising ret?
>>
>> Habit for striving for good pratice, I think. It may have also been
>> consitency. That being said, I already removed it when I took a look
>> at the other driver based on Linus' suggestion. I was trying to be
>> consistent with other maxim drivers.
>>
>> The linux kernel drivers are inconsistent in general at large,
>> unfortunately. It is hard to pick up the "right one" for consistency.
>> I will do whatever asked as it really does not make any difference for
>> me.
>
> The kernel should be mostly standard with this kind of stuff. If the
> variable 'could possibly' be read before it is written to, then
> initialise it, failing that, don't worry.

Sure. It might be that my experiment was reading so at some point, and
I did not adhere to the change later. I will remove it as you asked
because I agree.

>> >> +     ret = mfd_add_devices(max6651->dev, -1, max6651_devs,
>> >> +                     ARRAY_SIZE(max6651_devs),
>> >> +                     NULL, 0, NULL);
>> >> +
>> >> +     if (ret < 0) {
>> >> +        dev_err(max6651->dev, "cannot add mfd cells\n");
>> >
>> > Are you trying to add cells or register devices?
>>
>> I would not know the difference in this context. Care to elaborate?
>
> Providing a cell structure is just a tool. A means to an end if you
> will. The real goal here is to register child devices.
>
> "failed to register child devices\n"

Right, but in that case, I will go ahead and fix at the place rfom
where I picked this up.

>> >> +     kfree(max6651);
>> >
>> > If you use managed resources you don't need this.
>>
>> I am not sure what exactly you mean by managed resource here. I only
>> used the malloc above as far as I can tell. Perhaps, the called
>> function has some magic behind. I would need to double check...
>
> Yes, devm_* (managed resources) contains magic so you don't have you
> free your own memory. You can remove the goto altogether.

OK, thankie.

>> >> +static int max6651_i2c_remove(struct i2c_client *i2c)
>> >> +{
>> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> >> +
>> >> +    mfd_remove_devices(max6651->dev);
>> >
>> > In this case you would normally need to kfree() here, but if you use
>> > managed resources you won't have to.
>>
>> As above...
>
> As above...

As above... (thankie). :-)

>> >> +    return 0;
>> >> +}
>> >> +
>> >> +static const struct i2c_device_id max6651_i2c_id[] = {
>> >> +    { "max6650", TYPE_MAX6650 },
>> >> +    { "max6651", TYPE_MAX6651 },
>> >
>> > So were're registering the max6650 from here too?
>>
>> Absolutely, that is the idea.
>>
>> > If so, then you need to change the name of the file.

Yes, we discussed that before and I agree with the "obfuscating" 'x'.

>> >
>> >> +    { }
>> >
>> > {},
>>
>> Yep, tiring style stuff...
>
> Styling i.e nice, neat, easily readable/maintainable code should be
> your bread and butter. If styling tires you, perhaps a new career
> might be in order. ;)

or a new tool to be more professional ...

>> >> +#include <linux/i2c.h>
>> >> +#include <linux/export.h>
>> >
>> > Why is this in here?
>>
>> Because this series was meant for a design review and overall
>> direction as opposed to a completely fine tuned patch set. Naturally,
>> I agree with the feedback of removing unnecessary header inclusion.
>
> Don't do that.

I will guess that you mean "unnecessary header inclusion is OK"...

>> >> +struct max6651_dev {
>> >> +    struct device *dev;
>> >> +    struct mutex iolock;
>> >> +
>> >> +    struct i2c_client *i2c;
>> >
>> > Is this used?
>>
>> Yes, heavily, for reading and writing the registers in the subdevice drivers.
>
> Can you show me where?

Check the gpio driver or even the hwmon in this series. Look at the
places where it is using the read/write_reg functions, or you can just
check their signature in this patch. I am in the process of
refactoring it into regmap as we speak, but it is not painless because
I need to get it working for 3.2, too ...

>> >> +     int type;
>> >
>> > Or this?
>>
>> Absolutely, this identifies the type, which is necessary for
>> initializing some corresponding data.
>
> Can you show me where?

Well, you have different number of GPIO pins for starter ...

>> >> +};
>> >> +
>> >> +enum max6651_types {
>> >> +     TYPE_MAX6650,
>> >> +     TYPE_MAX6651,
>> >> +};
>> >
>> > What are you using these for?
>>
>> See above.
>
> Can you show me where you are using them?

Perhaps, I was not while submitting this change, but the upcoming
changes should.
