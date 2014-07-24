Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbaGXGdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:33:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59010 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbaGXGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:33:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D0A8B7.2010005@roeck-us.net>
Date: Wed, 23 Jul 2014 23:33:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net> <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
In-Reply-To: <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 10:44 PM, Alexandre Courbot wrote:
> On Thu, Jul 24, 2014 at 3:12 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> gpiod_export_name is similar to gpiod_export, but lets the user
>> determine the name used to export a gpio pin.
>>
>> Currently, the pin name is determined by the chip driver with
>> the 'names' array in the gpio_chip data structure, or it is set
>> to gpioX, where X is the pin number, if no name is provided by
>> the chip driver.
>
> Oh, my. I did not even know about this 'names' array. This is pretty
> bad - a GPIO provider should not decide what its GPIOs are used for.
>
> Luckily for you, this creates a precedent that makes this patch more
> acceptable, in that it is not making the situation worse. Even though
> I consider both solutions to be bad, I actually prefer your
> gpiod_export_name() function to that 'names' array in gpio_chip...
>
>>
>> It is, however, desirable to be able to provide the pin name when
>> exporting the pin, for example from platform code. In other words,
>> it would be useful to move the naming decision from the pin provider
>> to the pin consumer. The gpio-pca953x driver provides this capability
>> as part of its platform data. Other drivers could be enhanced in a
>> similar way; however, this is not always possible or easy to accomplish.
>> For example, mfd client drivers such as gpio-ich already use platform
>> data to pass information from the mfd master driver to the client driver.
>> Overloading this platform data to also provide an array of gpio pin names
>> would be a challenge if not impossible.
>>
>> The alternative to use gpiod_export_link is also not always desirable,
>> since it only creates a named link to a different directory, meaning
>> the named gpio pin is not available in /sys/class/gpio but only
>> in some platform specific directory and thus not as generic as possible
>> and/or useful.
>>
>> A specific example for a use case is a gpio pin which reports AC power
>> loss to user space. Depending on the platform and platform variant,
>> the pin can be provided by various gpio chip drivers and pin numbers.
>> It would be very desirable to have a well defined location such as
>> /sys/class/gpio/ac_power_loss for this pin, so user space knows where
>> to find the attribute without knowledge of the underlying platform
>> variant or oher hardware details.
>
> As I explained on the other thread, I still encourage you to have
> these GPIOs under device nodes that give a hint of who is provided the
> GPIO (effectively exporting the (dev, function) tuple to user-space)
> instead of having them popping out under /sys/class/gpio where nobody
> knows where they come from and name collisions are much more likely.
>
> Your message sounds like you have no choice but have the named GPIO
> link under the gpiochip's device node, but this is not the case -
> gpio_export_link() let's you specify the device under which the link
> should appear. Make that device be your "scu" device and you can have
> a consistent sysfs path to access your GPIOs.
>
Yes, I understand, but that is not acceptable for the users - see below.

> Allowing GPIOs to pop up in the same directory with an arbitrary name
> is just a recipe for a mess. But that's a recipe that is already
> allowed thanks to that 'names' array. So I'm really confused about
> what to do with this patch. If you can do with gpio_export_link() (and
> I have not seen evidence of the contrary), please go that way instead.
>

I personally don't think it is that much of a mess. Sure, once has to be
careful when selecting names, but I don't see a problem with that.

I have two users for this. Interestingly the problem is pretty
much the same, though the applications are completely different.

One is the company using the scu.c file. They are currently using the
pca953x driver approach (using the names array), but they also have
a new version of their product which also uses gpio pins from gpio-ich.
For consistency, they want all gpio pins in the same directory, meaning
/sys/class/gpio.

The currently implemented solution is to have a weak pointer to the names
array in gpio-ch.c and override it with a pointer from scu.c.

/* SCU specific gpio pin names. Only works if module is built into kernel. */
static const char * const scu_ichx_gpiolib_names[128] = {
         [0] = "switch_interrupt",       /* GPI0 */
         [3] = "ac_loss_detect",         /* GPI3 */
         [16] = "debug_out",             /* GPO0 */
         [20] = "switch_reset",          /* GPO3 */
};

[ switch_interrupt and switch_reset will ultimately make it into the kernel,
   to be used by a dsa driver, but that is besides the point. ]

const char * const (* const ichx_gpiolib_names)[] = &scu_ichx_gpiolib_names;

and ichx_gpiolib_names is declared as

/* Allow overriding default gpio pin names */
const char * const (* const __weak ichx_gpiolib_names)[];

in gpio-ich.c. Pretty hackish, but at least it works. Slim chance though
to get this accepted upstream. Since the ultimate idea is to submit all
this code upstream, I would prefer to find a solution which is
acceptable for both the user and for upstream integration.

The second user is my employer. Same thing here, though even more complex
as there are several different platforms to support with different platform
drivers. Each platform exports a number of gpio pins to user space, often with
the same functionality across platforms. The request here is to have all
those pins in the same directory, for all platforms, which again suggests
using /sys/class/gpio.

Current approach is to use the "export" file to request pin exports,
which has its own challenges such as having to search for the pin numbers.
Well defined names and pins exported from the kernel would be much cleaner
and be easier to handle.

Of course, I could try to come up with a new class named "gpios" or similar,
put everything there, and start selling that idea. Somehow that doesn't
sound like a good idea to me.

>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> Applies to tip of linux-gpio/for-next.
>>
>>   Documentation/gpio/sysfs.txt  | 12 ++++++++----
>>   drivers/gpio/gpiolib-sysfs.c  | 23 ++++++++++++++++-------
>>   include/linux/gpio/consumer.h |  9 +++++++++
>>   3 files changed, 33 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/gpio/sysfs.txt b/Documentation/gpio/sysfs.txt
>> index c2c3a97..8e301b2 100644
>> --- a/Documentation/gpio/sysfs.txt
>> +++ b/Documentation/gpio/sysfs.txt
>> @@ -125,7 +125,11 @@ requested using gpio_request():
>>          /* export the GPIO to userspace */
>>          int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
>>
>> -       /* reverse gpio_export() */
>> +       /* export named GPIO to userspace */
>> +       int gpiod_export_name(struct gpio_desc *desc, const char *ioname,
>> +                       bool direction_may_change);
>> +
>> +       /* reverse gpio_export() / gpiod_export_name() */
>>          void gpiod_unexport(struct gpio_desc *desc);
>>
>>          /* create a sysfs link to an exported GPIO node */
>> @@ -136,9 +140,9 @@ requested using gpio_request():
>>          int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
>>
>>   After a kernel driver requests a GPIO, it may only be made available in
>> -the sysfs interface by gpiod_export(). The driver can control whether the
>> -signal direction may change. This helps drivers prevent userspace code
>> -from accidentally clobbering important system state.
>> +the sysfs interface by gpiod_export() or gpiod_export_name(). The driver
>> +can control whether the signal direction may change. This helps drivers
>> +prevent userspace code from accidentally clobbering important system state.
>>
>>   This explicit exporting can help with debugging (by making some kinds
>>   of experiments easier), or can provide an always-there interface that's
>> diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
>> index be45a92..7d36230 100644
>> --- a/drivers/gpio/gpiolib-sysfs.c
>> +++ b/drivers/gpio/gpiolib-sysfs.c
>> @@ -523,13 +523,12 @@ static struct class gpio_class = {
>>    *
>>    * Returns zero on success, else an error.
>>    */
>> -int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>> +int gpiod_export_name(struct gpio_desc *desc, const char *ioname,
>> +                     bool direction_may_change)
>>   {
>>          unsigned long           flags;
>>          int                     status;
>> -       const char              *ioname = NULL;
>>          struct device           *dev;
>> -       int                     offset;
>>
>>          /* can't export until sysfs is available ... */
>>          if (!gpio_class.p) {
>> @@ -560,10 +559,6 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>>                  direction_may_change = false;
>>          spin_unlock_irqrestore(&gpio_lock, flags);
>>
>> -       offset = gpio_chip_hwgpio(desc);
>> -       if (desc->chip->names && desc->chip->names[offset])
>> -               ioname = desc->chip->names[offset];
>> -
>>          dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
>>                              desc, ioname ? ioname : "gpio%u",
>>                              desc_to_gpio(desc));
>> @@ -600,6 +595,20 @@ fail_unlock:
>>          gpiod_dbg(desc, "%s: status %d\n", __func__, status);
>>          return status;
>>   }
>> +EXPORT_SYMBOL_GPL(gpiod_export_name);
>> +
>> +int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>> +{
>> +       const char *ioname = NULL;
>> +
>> +       if (desc) {
>> +               int offset = gpio_chip_hwgpio(desc);
>> +
>> +               if (desc->chip->names && desc->chip->names[offset])
>> +                       ioname = desc->chip->names[offset];
>
> I'd add a
>
> else
>      ioname = "gpio%u";
>
> so all the name-chosing code is grouped in the same place. Then you
> can remove that same check from gpiod_export_name().
>
Sure, no problem, though in that case I should probably add a check
to gpiod_export_name to ensure that the passed ioname is not NULL
and return -EINVAL if it is.

Guenter

