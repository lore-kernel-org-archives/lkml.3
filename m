Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3LQRJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:09:48 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63203 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3LQRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131216164844.GS18769@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
	<20131216082556.GE18769@lee--X1>
	<CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
	<20131216150514.GN18769@lee--X1>
	<CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
	<20131216164844.GS18769@lee--X1>
Date: Tue, 17 Dec 2013 17:09:46 +0000
X-Google-Sender-Auth: FDIaVGIRPKPCtVXB91WPUTWb7vs
Message-ID: <CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
Subject: Re: Simple MFD driver example
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 4:48 PM, Lee Jones <lee.jones@linaro.org> wrote:
> There isn't any documentation that would help you I fear. I'm trying
> to help you, but you haven't answered my previous question.

I did intend to answer your question when I was writing that I would
send some code. See it at the bottom of the email.

> Do you have a datasheet for the device that you're trying to enable?

datasheets.maximintegrated.com/en/ds/MAX6650-MAX6651.pdf

hwmon is already available in the kernel (for which my simple patch
was rejected). I have just sent out a gpio driver for the gpio bits,
and see the mfd driver code below.

/*
 * Device access for MAX6651
 *
 * Copyright(c) 2013 Polatis Ltd.
 *
 * Author: Laszlo Papp <laszlo.papp@polatis.com>
 *
 *  This program is free software; you can redistribute  it and/or modify it
 *  under  the terms of  the GNU General  Public License as published by the
 *  Free Software Foundation;  either version 2 of the  License, or (at your
 *  option) any later version.
 */

#include <linux/device.h>
#include <linux/delay.h>
#include <linux/input.h>
#include <linux/interrupt.h>
#include <linux/mfd/core.h>
#include <linux/slab.h>
#include <linux/module.h>
#include <linux/i2c.h>

#include <linux/mfd/max6651.h>

static struct mfd_cell max6651_devs[] = {
    { .name = "max6651-gpio", },
    { .name = "max6650", },
};

static int max6651_i2c_probe(struct i2c_client *i2c,
                            const struct i2c_device_id *id)
{
        struct max6651_dev *max6651;
        int ret = 0;

        max6651 = kzalloc(sizeof(struct max6651_dev), GFP_KERNEL);
        if (max6651 == NULL)
                return -ENOMEM;

        i2c_set_clientdata(i2c, max6651);
        max6651->dev = &i2c->dev;

        mutex_init(&max6651->iolock);

        ret = mfd_add_devices(max6651->dev, -1, max6651_devs,
                        ARRAY_SIZE(max6651_devs),
                        NULL, 0);

        if (ret < 0) {
        dev_err(max6651->dev, "cannot add mfd cells\n");
                goto err_mfd;
    }

        return ret;

err_mfd:
        mfd_remove_devices(max6651->dev);
err:
        kfree(max6651);
        return ret;
}

static int max6651_i2c_remove(struct i2c_client *i2c)
{
    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);

    mfd_remove_devices(max6651->dev);

    return 0;
}

static const struct i2c_device_id max6651_i2c_id[] = {
    { "max6650", TYPE_MAX6650 },
    { "max6651", TYPE_MAX6651 },
    { }
};
MODULE_DEVICE_TABLE(i2c, max6651_i2c_id);

static struct i2c_driver max6651_i2c_driver = {
    .driver = {
           .name = "max6651",
           .owner = THIS_MODULE,
    },
    .probe = max6651_i2c_probe,
    .remove = max6651_i2c_remove,
    .id_table = max6651_i2c_id,
};

static int __init max6651_i2c_init(void)
{
    return i2c_add_driver(&max6651_i2c_driver);
}
/* init early so consumer devices can complete system boot */
subsys_initcall(max6651_i2c_init);

static void __exit max6651_i2c_exit(void)
{
    i2c_del_driver(&max6651_i2c_driver);
}
module_exit(max6651_i2c_exit);

MODULE_AUTHOR("Laszlo Papp <laszlo.papp@polatis.com>");
MODULE_DESCRIPTION("MAX6651 MFD");
MODULE_LICENSE("GPL");
