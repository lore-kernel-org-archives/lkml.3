Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668AbaJ3PkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:40:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56735 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaJ3PkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141029085306.GI1304@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<3395005.IveyhHQnye@vostro.rjw.lan>
	<CACRpkdYR70Az1uLyjsaujQN-q-4+qRD=GpqJaOuvnKZhypL=cA@mail.gmail.com>
	<17483842.EFni4iQX1H@vostro.rjw.lan>
	<20141029085306.GI1304@lahna.fi.intel.com>
Date: Thu, 30 Oct 2014 16:40:05 +0100
Message-ID: <CACRpkdaKiz4wODUnH+2+ELY3XGSYYsQ_iFMm+iY=o6rmVcxmSw@mail.gmail.com>
Subject: Re: [PATCH v5 07/12] leds: leds-gpio: Add support for GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 9:53 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Oct 28, 2014 at 10:56:09PM +0100, Rafael J. Wysocki wrote:
>> On Tuesday, October 28, 2014 04:26:25 PM Linus Walleij wrote:
>> > On Fri, Oct 17, 2014 at 2:11 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > >
>> > > GPIO descriptors are the preferred way over legacy GPIO numbers
>> > > nowadays. Convert the driver to use GPIO descriptors internally but
>> > > still allow passing legacy GPIO numbers from platform data to support
>> > > existing platforms.
>> > >
>> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > > Acked-by: Alexandre Courbot <acourbot@nvidia.com>
>> > > Acked-by: Bryan Wu <cooloney@gmail.com>
>> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > (...)
>> >
>> > >         if (led_dat->blinking) {
>> > > -               led_dat->platform_gpio_blink_set(led_dat->gpio,
>> > > -                                                led_dat->new_level,
>> > > -                                                NULL, NULL);
>> > > +               int gpio = desc_to_gpio(led_dat->gpiod);
>> > > +               int level = led_dat->new_level;
>> >
>> > So this desc_to_gpio() is done only to call the legacy callback below?
>> >
>> > > +               if (gpiod_is_active_low(led_dat->gpiod))
>> > > +                       level = !level;
>> >
>> > And that leads to making it necessary to have this helper variable
>> > to invert the level since that callback does not pass a descriptor
>> > (which would inherently know if it's active low)....
>> >
>> > > +
>> > > +               led_dat->platform_gpio_blink_set(gpio, level, NULL, NULL);
>> >
>> > Is it *really* impossible to change all the users of this callback?
>>
>> You said it could be done in a followup patch.  Here:
>> http://marc.info/?l=linux-acpi&m=141154536921643&w=4
>>
>> And Mika said he would add that to his TODO list:
>> http://marc.info/?l=linux-acpi&m=141155173924101&w=4
>>
>> I suppose that is still valid.
>
> Yes, I'll just let dust to settle before sending out a patch that
> converts the existing users of platform_gpio_blink_set() callback to
> gpio descriptors.

Dust settle = 2 weeks, 18 months, 5 years?

Sorry for nagging but I've been *SO* burnt by people in the past
saying they will "fix things later real soon" and then never get around
to it.

But I guess I'm gonna trust you anyway.

>> > > Index: linux-pm/include/linux/leds.h
>> > > ===================================================================
>> > > --- linux-pm.orig/include/linux/leds.h
>> > > +++ linux-pm/include/linux/leds.h
>> > > @@ -251,6 +251,7 @@ struct gpio_led {
>> > >         unsigned        retain_state_suspended : 1;
>> > >         unsigned        default_state : 2;
>> > >         /* default_state should be one of LEDS_GPIO_DEFSTATE_(ON|OFF|KEEP) */
>> > > +       struct gpio_desc *gpiod;
>> >
>> > Put the new struct member right below the current "gpio"
>> > member,
>>
>> It was done like that in previous versions, but turned out to cause problems
>> to happen in testing.  Unfortunately, I don't seem to be able to find a pointer
>> to the original report ATM, but perhaps Mika can.  Mika?
>
> It is burried inside this thread:
>
> http://www.spinics.net/lists/arm-kernel/msg369522.html

OK people not using C99 initalizers, sigh.

I hope Arnd's complimentary patch gets applied too so we
can move the member back where it should be, kernel structs
as ABI isn't really any fun.

Yours,
Linus Walleij
