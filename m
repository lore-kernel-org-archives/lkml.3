Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3BPOq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 09:46:56 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58213 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3BPOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 09:46:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130216090637.GB19639@arwen.pp.htv.fi>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
	<1360988172-15380-4-git-send-email-sjg@chromium.org>
	<20130216090637.GB19639@arwen.pp.htv.fi>
Date: Sat, 16 Feb 2013 06:46:53 -0800
X-Google-Sender-Auth: rZWAfoL274Jr9WxBDvpvTVvv8kY
Message-ID: <CAPnjgZ201Pcq3EshTkEU8YgLNVby=d6xjjss_Rh5Kfrwnc0Mrg@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: Add ChromeOS EC I2C driver
From: Simon Glass <sjg@chromium.org>
To: balbi@ti.com
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 16, 2013 at 1:06 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Feb 15, 2013 at 08:16:09PM -0800, Simon Glass wrote:
>> This uses an I2C bus to talk to the ChromeOS EC. The protocol
>> is defined by the EC and is fairly simple, with a length byte,
>> checksum, command byte and version byte (to permit easy creation
>> of new commands).
>>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
>
> the driver you're adding here is no where near being an MFD device. MFD
> children shouldn't be under drivers/mfd/. Please find a proper location
> for this driver.

I think you might be misunderstanding the intent here. This driver is
actually not an MFD child, but a real MFD device. The children are
things like the cros_ec_keyb which use this device to access to the EC
and provide a function to the kernel (such as keyboard, EC flash
access and so on). They are indeed somewhere else in the tree.

This driver sits in MFD for that reason, and provides a way to talk to
the EC over I2C. Rather than duplicate the code in each bus driver
(I2C, SPI, LPC) we have chosen to put that core code in a common file,
cros_ec, So one way to think of it is that we have several transports
which each provides an abstracted interface to an EC.

There are several examples in drivers/mfd where this is done. For example:

da9052_i2c.c and da9052_spi.c each provide an MFD driver, which calls
da9052_device_init() in da50542-core.c.

and there are many others in MFD which use this approach, for example:

drivers/mfd/wm831x-core.c
drivers/mfd/wm831x-i2c.c
drivers/mfd/wm831x-spi.c

and

drivers/mfd/tps65912-core.c
drivers/mfd/tps65912-i2c.c
drivers/mfd/tps65912-spi.c

The intent is to keep the communications separate from the function
provided by the device.

>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 837a16b..e1cd15e 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -29,6 +29,16 @@ config MFD_CROS_EC
>>         You also ned to enable the driver for the bus you are using. The
>>         protocol for talking to the EC is defined by the bus driver.
>>
>> +config MFD_CROS_EC_I2C
>> +     tristate "ChromeOS Embedded Controller (I2C)"
>> +     depends on MFD_CROS_EC && I2C
>> +
>> +     help
>> +       If you say here, you get support for talking to the ChromeOS EC
>
> if you say what here ?

Will fix.

>
>> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
>> new file mode 100644
>> index 0000000..fe3f2bf
>> --- /dev/null
>> +++ b/drivers/mfd/cros_ec_i2c.c
>> @@ -0,0 +1,262 @@
>> +/*
>> + * ChromeOS EC multi-function device (I2C)
>> + *
>> + * Copyright (C) 2012 Google, Inc
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/mfd/cros_ec.h>
>> +#include <linux/mfd/cros_ec_commands.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +
>> +
>
> one blank line only.
>
>> +/* Since I2C can be unreliable, we retry commands */
>> +#define COMMAND_MAX_TRIES 3
>
> unreliable in what way ? Are you sure you haven't found a bug on your
> embedded controller or your i2c controller driver ?

Well those bugs were fixed. I think this is here for safety just in
case is this bad?

>
>> +static const char *cros_ec_get_name(struct cros_ec_device *ec_dev)
>> +{
>> +     struct i2c_client *client = ec_dev->priv;
>> +
>> +     return client->name;
>> +}
>
> why ? What do you need get_name() for ? Why don't you just pass a
> pointer to client->name directly ?

This is used by MFD children to report the bus they are connected on -
the keyboard driver passes this information to the input layer so that
it conforms with what other input drivers do. I'm not sure how the
information is used internally by the input layer other than just for
logging/errors/debugging. I think I can just put the name in the
structure.

>
>> +static const char *cros_ec_get_phys_name(struct cros_ec_device *ec_dev)
>> +{
>> +     struct i2c_client *client = ec_dev->priv;
>> +
>> +     return client->adapter->name;
>> +}
>> +
>> +static struct device *cros_ec_get_parent(struct cros_ec_device *ec_dev)
>> +{
>> +     struct i2c_client *client = ec_dev->priv;
>> +
>> +     return &client->dev;
>> +}
>
> not sure you should allow other layers to fiddle with these. Specially
> the parent device ointer.

This is the parent device for any children. Some MFD children will
want to know their parent. I can just add it to the structure I think.

>
>> +static int cros_ec_probe_i2c(struct i2c_client *client,
>> +                          const struct i2c_device_id *dev_id)
>> +{
>> +     struct device *dev = &client->dev;
>> +     struct cros_ec_device *ec_dev = NULL;
>> +     int err;
>> +
>> +     if (dev->of_node && !of_device_is_available(dev->of_node)) {
>> +             dev_warn(dev, "Device disabled by device tree\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     ec_dev = cros_ec_alloc("I2C");
>
> please don't use any indirection to allocators

OK will change this.

>
>> +     if (!ec_dev) {
>> +             err = -ENOMEM;
>> +             dev_err(dev, "cannot create cros_ec\n");
>
> OOM messages are printed for you, no need to add another one here.

OK thanks.

>
>> +     i2c_set_clientdata(client, ec_dev);
>> +     ec_dev->dev = dev;
>> +     ec_dev->priv = client;
>> +     ec_dev->irq = client->irq;
>> +     ec_dev->command_xfer = cros_ec_command_xfer;
>> +     ec_dev->get_name = cros_ec_get_name;
>> +     ec_dev->get_phys_name = cros_ec_get_phys_name;
>> +     ec_dev->get_parent = cros_ec_get_parent;
>> +
>> +     err = cros_ec_register(ec_dev);
>> +     if (err) {
>> +             dev_err(dev, "cannot register EC\n");
>> +             goto fail_register;
>> +     }
>
> What is this doing ?

This is registering a new cros_ec - that is what is used by children
of this MFD to access the EC. When these children call
cros_ec->command_xfer(), the request comes back into this driver for
processing. The common code of the three bus options is in there,
whereas this driver contains only the I2C transport.

If you look at something like tps65912_spi_probe() and
tps65912_i2c_probe() you will see something very similar. They set up
some methods for their particular comms interface and then call
tps65912_device_init().

Regards,
Simon

>
> --
> balbi
