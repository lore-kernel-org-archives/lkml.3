Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaHSRQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:16:50 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61635 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaHSRQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140819085631.GG1660@lahna.fi.intel.com>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408172039-32513-7-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFu+LRxcJkPRpQMYhyz-TTY1HB7qCEv44a8vTU=g1iKCsfA@mail.gmail.com> <20140819085631.GG1660@lahna.fi.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 19 Aug 2014 10:16:27 -0700
Message-ID: <CAAVeFuLMpq+-5Zt6rmy3QhQg7zSgESKLVj6zFyfpr_FiC5ZFvA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 1:56 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Aug 18, 2014 at 09:24:48AM -0700, Alexandre Courbot wrote:
>> On Fri, Aug 15, 2014 at 11:53 PM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> > index 2ebc9071e354..e6c2413a6fbf 100644
>> > --- a/drivers/gpio/gpiolib.c
>> > +++ b/drivers/gpio/gpiolib.c
>> > @@ -2644,6 +2644,24 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
>> >         return desc;
>> >  }
>> >
>> > +struct gpio_desc *dev_get_gpiod_flags(struct device *dev, unsigned int idx,
>> > +                                     enum gpio_lookup_flags *flags)
>> > +{
>> > +       struct gpio_desc *desc = ERR_PTR(-ENOENT);
>> > +
>> > +       if (!dev || !flags)
>> > +               return ERR_PTR(-EINVAL);
>> > +
>> > +       /* Using device tree? */
>> > +       if (IS_ENABLED(CONFIG_OF) && dev->of_node)
>> > +               desc = of_find_gpio(dev, NULL, idx, flags);
>> > +       else if (IS_ENABLED(CONFIG_ACPI) && ACPI_COMPANION(dev))
>> > +               desc = acpi_get_gpiod_flags(dev, idx, flags);
>> > +
>> > +       return desc;
>> > +}
>> > +EXPORT_SYMBOL(dev_get_gpiod_flags);
>>
>> Putting aside the fact that this function is clearly ACPI-centric (no
>> con_id parameter and no handling of the platform interface), I have
>> two big problems with it and it ending up in the consumer interface:
>>
>> 1) The returned descriptor is not requested by gpiolib, which means no
>> check is made about whether the GPIO has already been requested by
>> someone else, and another driver can very well request the same GPIO
>> later and obtain it. Any descriptor returned by a function in
>> consumer.h *must* be properly requested. Furthermore the 1:1 mapping
>> between GPIO descriptors and GPIO numbers is not something we can take
>> for granted (since it will likely change soon), so this practice is
>> definitely to ban.
>
> My bad, somehow I missed the part that it never requested the GPIO.
> Thanks for pointing it out.
>
>> 2) It exposes the GPIO flags, while they are supposed to be opaque to consumers.
>
> And this, of course we should be using gpiod_is_active_low() and similar
> functions that work with descriptors.

Yes, although if you convert the driver to use descriptors you should
not even have to worry about active_low status.

For drivers that still need to handle GPIO numbers for compatibility
reasons, it might be nice if gpiolib provided a gpio_to_desc() variant
that accepts an ACTIVE_LOW flag, so you don't have to worry about the
active low status once you have converted your GPIO number to a
descriptor. Actually for these cases we may be better with a function
that does what gpio_to_desc() does, but also requests the GPIO and
allows some flags to be specified so the integer-handling part of
drivers can be completely dropped afterwards. That's another problem
though. :)

>
>> These two points would somehow be acceptable if this function was
>> gpiolib-private, but here it is clearly not the case and this allows
>> pretty nasty thing to happen. Basically you are using it to take
>> advantage of the gpiod lookup mechanism and then quickly fall back to
>> the legacy integer interface. That's really not something to encourage
>> - these drivers should be converted to use gpiod internally (while
>> preserving integer-based lookup for compatiblity, if needed).
>>
>> In patch 8 you say:
>>
>> "this can be solved by adding a new field of type
>> struct gpio_desc but then there is another problem: the devm_gpiod_get
>> needs to operate on the button device instead of its parent device that
>> has the driver binded, so when the driver is unloaded, the resources for
>> the gpio will not get freed automatically."
>>
>> I'd very much prefer that you use the non-devm variant of gpiod_get()
>> and free the resources manually when the driver is unloaded than this
>> workaround that introduces an loophole in the gpiod consumer lookup
>> functions.
>
> I agree and we are going to rework this and the consumer patches to do
> exactly what you say.

Great, thanks to you and Aaron for your understanding!

Alex.
