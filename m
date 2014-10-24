Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaJXHP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:15:58 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:59679 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaJXHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <1581499.2RkCnyfbq6@vostro.rjw.lan>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <13758254.acHP1NJN1b@vostro.rjw.lan> <20141023125655.GJ1484@lahna.fi.intel.com>
 <1581499.2RkCnyfbq6@vostro.rjw.lan>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 24 Oct 2014 16:15:32 +0900
Message-ID: <CAAVeFuKyUok2yNwKmn0UtEufJRXgX7D0Ls5Pg_doVqCSDL1Riw@mail.gmail.com>
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio: Support
 for unified device properties interface)
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 6:51 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, October 23, 2014 03:56:55 PM Mika Westerberg wrote:
>> On Thu, Oct 23, 2014 at 01:21:06AM +0200, Rafael J. Wysocki wrote:
>> > OK, would the below make sense, then (completely untested, on top of the v6
>> > of the device properties patchset)?
>>
>> Yes it does :-)
>>
>> With the the below fix it works nicely with the modified rfkill-gpio.c
>> driver.
>>
>> > +static bool acpi_get_driver_gpio_data(struct acpi_device *adev,
>> > +                                 const char *name,
>> > +                                 struct acpi_reference_args *args)
>> > +{
>> > +   struct acpi_gpio_data *gd;
>> > +
>> > +   mutex_lock(&driver_gpio_data_lock);
>> > +
>> > +   list_for_each_entry(gd, &adev->driver_gpios, item)
>> > +           if (!strcmp(name, gd->name)) {
>> > +                   args->adev = adev;
>> > +                   args->args[0] = gd->entry_index;
>> > +                   args->args[1] = gd->pin_index;
>> > +                   args->args[2] = gd->active_low;
>> > +                   args->nargs = 3;
>>
>>                       mutex_unlock(&driver_gpio_data_lock);
>>
>> > +                   return true;
>> > +           }
>> > +
>> > +   mutex_unlock(&driver_gpio_data_lock);
>> > +
>> > +   return false;
>> > +}
>>
>> Also I think the two functions should be exported to modules as well.
>>
>> Here are the modifications needed for rfkill-gpio.c driver. I think it
>> is not that bad considering that now the driver supports both ACPI _DSD
>> and non-_DSD at the same time.
>
> OK, let's try to take that a bit farther. :-)
>
> With the (untested) patch below applied (which is a replacement for the one
> sent previously), the driver can use static tables like these:
>
> static struct acpi_gpio_params reset_gpios = { 0, 0, false };
> statuc struct acpi_gpio_params shutdown_gpios = { 1, 0, false };
>
> static struct acpi_gpio_mapping my_gpio_mapping[] = {
>         { "reset-gpios", &reset_gpios, 1 },
>         { "shutdown-gpios", &shutdown_gpios, 1 },
>         NULL,
> };
>
> ->
>
>>
>> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
>> index 0f62326c0f5e..f8754e7d81ea 100644
>> --- a/net/rfkill/rfkill-gpio.c
>> +++ b/net/rfkill/rfkill-gpio.c
>> @@ -67,6 +67,8 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
>>                                 struct rfkill_gpio_data *rfkill)
>>  {
>>       const struct acpi_device_id *id;
>> +     struct acpi_device *adev = ACPI_COMPANION(dev);
>> +     int ret;
>>
>>       id = acpi_match_device(dev->driver->acpi_match_table, dev);
>>       if (!id)
>> @@ -75,6 +77,20 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
>>       rfkill->name = dev_name(dev);
>>       rfkill->type = (unsigned)id->driver_data;
>>
>> +     /*
>> +      * Add default mapping for ACPI _DSD properties now just in case
>> +      * there is no _DSD for this device.
>> +      */
>> +     ret = acpi_dev_add_driver_gpio(adev, "reset-gpios", 0, 0, false);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = acpi_dev_add_driver_gpio(adev, "shutdown-gpios", 1, 0, false);
>> +     if (ret) {
>> +             acpi_dev_remove_driver_gpios(adev);
>> +             return ret;
>> +     }
>
> -> and then simply do
>
>         ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), &my_gpio_mapping);
>
> instead of the above.
>
>>       return 0;
>>  }
>>
>> @@ -110,7 +126,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>>               rfkill->reset_gpio = gpio;
>>       }
>>
>> -     gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
>> +     gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 0);
>>       if (!IS_ERR(gpio)) {
>>               ret = gpiod_direction_output(gpio, 0);
>>               if (ret)
>> @@ -150,6 +166,9 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
>>       rfkill_unregister(rfkill->rfkill_dev);
>>       rfkill_destroy(rfkill->rfkill_dev);
>>
>> +     if (ACPI_COMPANION(&pdev->dev))
>> +             acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));
>> +
>
> And here simply
>
>         acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));
>
>>       return 0;
>>  }
>
> and then we can even cover situations in which there is one name for a list of
> GPIOs.

That looks just perfect.
