Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIEQEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:04:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43942 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaIEQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140905153835.GC13242@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
	<1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
	<20140905153835.GC13242@localhost>
Date: Fri, 5 Sep 2014 19:04:51 +0300
Message-ID: <CAE1zotK4QkA9PWW=uOmM-j=N=MNuBt1v3CgdA+GXctdFUZ3QKA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 6:38 PM, Johan Hovold <johan@kernel.org> wrote:
> On Fri, Sep 05, 2014 at 06:17:59PM +0300, Octavian Purdila wrote:
>
>> +static int dln2_do_remove(struct dln2_gpio *dln2)
>> +{
>> +     /* When removing the DLN2 USB device, gpiochip_remove may fail
>> +      * due to i2c drivers holding a GPIO pin. However, the i2c bus
>> +      * will eventually be removed triggering an i2c driver remove
>> +      * which will release the GPIO pin. So retrying the operation
>> +      * later should succeed. */
>> +     int ret = gpiochip_remove(&dln2->gpio);
>> +     struct device *dev = dln2->gpio.dev;
>> +
>> +     if (ret < 0) {
>> +             if (ret == -EBUSY)
>> +                     schedule_delayed_work(&dln2->remove_work.work, HZ/10);
>> +             else
>> +                     dev_warn(dev, "error removing gpio chip: %d\n", ret);
>> +     } else {
>> +             kfree(dln2);
>> +     }
>> +
>> +     return ret;
>> +}
>
> Apparently, the return value from gpiochip_remove is going away:
>
>         "Start to kill off the return value from gpiochip_remove() by
>         removing the __must_check attribute and removing all checks
>         inside the drivers/gpio directory. The rationale is: well what
>         were we supposed to do if there is an error code? Not much:
>         print an error message. And gpiolib already does that. So make
>         this function return void eventually."
>
>         https://www.mail-archive.com/linux-gpio@vger.kernel.org/msg03468.html
>

Oh, I missed this, thanks for pointing it out.

> Also, have you considered what happens if there are gpios exported
> through sysfs? These may never be released.
>
> In general, how well have these patches been tested with disconnect
> events? At least gpiolib is known to blow up (sooner or later) when a
> gpiochip is removed when having requested gpios.
>

I do disconnect tests regularly. Since switching to the new irq
interface the following patch is needed:

https://lkml.org/lkml/2014/9/5/408

With it and the current patch sets things seems to work well.
