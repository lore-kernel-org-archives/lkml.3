Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaAIJmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:42:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58131 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaAIJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:41:54 -0500
Date: Thu, 9 Jan 2014 09:41:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
Message-ID: <20140109094147.GA20699@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
 <1387814889-16670-2-git-send-email-lpapp@kde.org>
 <20140108223933.GD18611@lee--X1>
 <CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +config MFD_MAX6651
> >> +     bool "Maxim Semiconductor MAX6651 Support"
> >> +     depends on I2C=y
> >> +     select MFD_CORE
> >> +     select IRQ_DOMAIN
> >
> > Why have you selected IRQ_DOMAIN?
> 
> Initial consistency with other corresponding drivers, but I should
> have dropped it once I dropped the irq handling to be as simple as
> possible initially.

IRQ_DOMAINs are only relevant for IRQ Controllers.

> >> +#include <linux/device.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/input.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/mfd/core.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/module.h>
> >> +#include <linux/i2c.h>
> >
> > Are you sure all these are used? I'm pretty sure some of them are
> > not. Only add headers if you require them. Try not to copy and paste
> > stuff you don't need.
> 
> Yes, this was meant to be the "final clean up step". I aimed
> functionality and design first.

In future please only send your best, most cleaned-up
code. Sub-standard codes desearves nothing but a sub-standard review.

> >> +#include <linux/mfd/max6651-private.h>
> >> +
> >> +static struct mfd_cell max6651_devs[] = {
> >> +    { .name = "max6651-gpio", },
> >> +    { .name = "max6650", },
> >
> > It would be nice to have a comment here to indicate that this is a
> > hwmon driver. If you're planning to add support for the MAX6651 to
> > this existing driver,
> 
> Actually, it is already renamed to max6650-hwmon in the next patch of
> this series.

This won't work, as you haven't changed the name in the
platform_driver struct. And rightly so, as it has nothing to do with
converting the driver over to a platform one. Pull the part that
changes the name into another patch.

> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
> >> +    int ret;
> >
> > Always use 8 char tabs for kernel code.
> 
> As discussed, style stuff is not fixed for a design review. I am still
> intereted in having an automated fix-up like astyle in other projects?
> What is the recommended way? I really would not like to waste too much
> time with style clean up.

If you send any more lazy patches where it's clear that no attempt has
been made to adhere to the documentation I've provided you with, I
won't review. 'Please', no more half-ar$ed patches RFC or otherwise.

There is no automated way to get styling right, but the first step is
to set your editor's config for 8 char tabbing at a bare minimum.

<snip>

> >> +static int max6651_i2c_probe(struct i2c_client *i2c,
> >> +                         const struct i2c_device_id *id)
> >> +{
> >> +     struct max6651_dev *max6651;
> >> +     int ret = 0;
> >
> > Why are you initialising ret?
> 
> Habit for striving for good pratice, I think. It may have also been
> consitency. That being said, I already removed it when I took a look
> at the other driver based on Linus' suggestion. I was trying to be
> consistent with other maxim drivers.
> 
> The linux kernel drivers are inconsistent in general at large,
> unfortunately. It is hard to pick up the "right one" for consistency.
> I will do whatever asked as it really does not make any difference for
> me.

The kernel should be mostly standard with this kind of stuff. If the
variable 'could possibly' be read before it is written to, then
initialise it, failing that, don't worry.

> >> +     ret = mfd_add_devices(max6651->dev, -1, max6651_devs,
> >> +                     ARRAY_SIZE(max6651_devs),
> >> +                     NULL, 0, NULL);
> >> +
> >> +     if (ret < 0) {
> >> +        dev_err(max6651->dev, "cannot add mfd cells\n");
> >
> > Are you trying to add cells or register devices?
> 
> I would not know the difference in this context. Care to elaborate?

Providing a cell structure is just a tool. A means to an end if you
will. The real goal here is to register child devices.

"failed to register child devices\n"

> >> +     kfree(max6651);
> >
> > If you use managed resources you don't need this.
> 
> I am not sure what exactly you mean by managed resource here. I only
> used the malloc above as far as I can tell. Perhaps, the called
> function has some magic behind. I would need to double check...

Yes, devm_* (managed resources) contains magic so you don't have you
free your own memory. You can remove the goto altogether.

> >> +static int max6651_i2c_remove(struct i2c_client *i2c)
> >> +{
> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
> >> +
> >> +    mfd_remove_devices(max6651->dev);
> >
> > In this case you would normally need to kfree() here, but if you use
> > managed resources you won't have to.
> 
> As above...

As above...

> >> +    return 0;
> >> +}
> >> +
> >> +static const struct i2c_device_id max6651_i2c_id[] = {
> >> +    { "max6650", TYPE_MAX6650 },
> >> +    { "max6651", TYPE_MAX6651 },
> >
> > So were're registering the max6650 from here too?
> 
> Absolutely, that is the idea.
> 
> > If so, then you need to change the name of the file.
> >
> >> +    { }
> >
> > {},
> 
> Yep, tiring style stuff...

Styling i.e nice, neat, easily readable/maintainable code should be
your bread and butter. If styling tires you, perhaps a new career
might be in order. ;) 

<snip>

> >> +#include <linux/i2c.h>
> >> +#include <linux/export.h>
> >
> > Why is this in here?
> 
> Because this series was meant for a design review and overall
> direction as opposed to a completely fine tuned patch set. Naturally,
> I agree with the feedback of removing unnecessary header inclusion.

Don't do that.

> >> +struct max6651_dev {
> >> +    struct device *dev;
> >> +    struct mutex iolock;
> >> +
> >> +    struct i2c_client *i2c;
> >
> > Is this used?
> 
> Yes, heavily, for reading and writing the registers in the subdevice drivers.

Can you show me where?

> >> +     int type;
> >
> > Or this?
> 
> Absolutely, this identifies the type, which is necessary for
> initializing some corresponding data.

Can you show me where?

> >> +};
> >> +
> >> +enum max6651_types {
> >> +     TYPE_MAX6650,
> >> +     TYPE_MAX6651,
> >> +};
> >
> > What are you using these for?
> 
> See above.

Can you show me where you are using them?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
