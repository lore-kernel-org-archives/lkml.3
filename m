Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3DDKB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:01:28 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:59278 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3DDKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130404095716.GJ21804@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
	<CAN+gG=F4LMHMsOqVh+BikSLKBJ8V7ni-p4hKi7yRb4jjD7gv0w@mail.gmail.com>
	<20130404093820.GI21804@intel.com>
	<CAN+gG=F7T6ujLuNu2hfEKfrDwBCG9xM_e3P9Fan0Awj7EYmJyA@mail.gmail.com>
	<20130404095716.GJ21804@intel.com>
Date: Thu, 4 Apr 2013 12:01:23 +0200
Message-ID: <CAN+gG=Edb-iTLeafeDw+E33rJWthSM8Qr37yQJNOG9p45_rrbw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:57 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Apr 04, 2013 at 11:42:11AM +0200, Benjamin Tissoires wrote:
>> On Thu, Apr 4, 2013 at 11:38 AM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > On Thu, Apr 04, 2013 at 11:19:53AM +0200, Benjamin Tissoires wrote:
>> >> Hi Mika,
>> >>
>> >> On Wed, Apr 3, 2013 at 12:56 PM, Mika Westerberg
>> >> <mika.westerberg@linux.intel.com> wrote:
>> >> > Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
>> >> > a helper function analogous to Device Tree version that allows drivers to
>> >> > specify which GPIO resource they are interested (using an index to the GPIO
>> >> > resources). The function then finds out the correct resource, translates
>> >> > the ACPI GPIO number to the corresponding Linux GPIO number and returns
>> >> > that.
>> >> >
>> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >> > ---
>> >> >  Documentation/acpi/enumeration.txt |   32 ++++++++++++++-
>> >> >  drivers/gpio/gpiolib-acpi.c        |   77 ++++++++++++++++++++++++++++++++++++
>> >> >  include/linux/acpi_gpio.h          |   17 ++++++++
>> >> >  3 files changed, 125 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
>> >> > index 94a6561..b0d5410 100644
>> >> > --- a/Documentation/acpi/enumeration.txt
>> >> > +++ b/Documentation/acpi/enumeration.txt
>> >> > @@ -199,6 +199,8 @@ the device to the driver. For example:
>> >> >         {
>> >> >                 Name (SBUF, ResourceTemplate()
>> >> >                 {
>> >> > +                       ...
>> >> > +                       // Used to power on/off the device
>> >> >                         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
>> >> >                                 IoRestrictionOutputOnly, "\\_SB.PCI0.GPI0",
>> >> >                                 0x00, ResourceConsumer,,)
>> >> > @@ -206,10 +208,20 @@ the device to the driver. For example:
>> >> >                                 // Pin List
>> >> >                                 0x0055
>> >> >                         }
>> >> > +
>> >> > +                       // Interrupt for the device
>> >> > +                       GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullNone,
>> >> > +                                0x0000, "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer,,)
>> >>
>> >> Sorry for coming late in the GPIO ACPI discussion, but when I see this
>> >> documentation, I wonder:
>> >> wouldn't it be feasible to find the correct GPIO by its type? Here, we
>> >> have a GpioIo and a GpioInt, and I bet this would be sometime more
>> >> useful to request the first GpioInt without knowing the correct order
>> >> of declarations.
>> >
>> > Why not. But then again you can always check the type returned in the
>> > acpi_gpio_info structure and pick the first GpioInt (if you have multiple
>> > GPIO resources).
>> >
>> >> It may be feasible by walking the tree, but a helper would be of great
>> >> help (thinking at i2c-hid here, which can not rely on indexes in the
>> >> DSDT).
>> >
>> > Well, index is the only thing we can rely on unfortunately. There's nothing
>> > like names or anything like that.
>> >
>> > What I've seen from ACPI enumerated i2c-hid devices there is only one GPIO
>> > resource (GpioInt) declared.
>>
>> Ok, thanks for the answer. I guess the idea would be to pick the index
>> 0, check the type, and try indexes 1 or 2 if it's not GpioInt. I bet
>> there will be devices with more than one Gpio as most of I2C input
>> device have a reset line (except if Microsoft forces them not to have
>> one).
>
> One option is to provide acpi_get_gpio_all() that returns all GPIOs and
> their corresponding types. That should allow clients like i2c-hid to find
> the right GPIO (I'm hoping that there will be only one GpioInt associated
> with these devices).

That could do the trick.
However, I won't be able to test it. I still don't have access to any
ACPI 5 device with i2c-hid devices...

As for the multiple GpioInt: I hope too. But I can not see why would
somebody put several GpioInt to a HID device (GpioIo are more expected
to be present). The spec is not compliant with this idea, but we never
know :)

Cheers,
Benjamin
