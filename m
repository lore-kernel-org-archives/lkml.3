Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaJ2IxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:53:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:45355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaJ2IxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="613296146"
Date: Wed, 29 Oct 2014 10:53:06 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH v5 07/12] leds: leds-gpio: Add support for GPIO
 descriptors
Message-ID: <20141029085306.GI1304@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <3395005.IveyhHQnye@vostro.rjw.lan>
 <CACRpkdYR70Az1uLyjsaujQN-q-4+qRD=GpqJaOuvnKZhypL=cA@mail.gmail.com>
 <17483842.EFni4iQX1H@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17483842.EFni4iQX1H@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:56:09PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, October 28, 2014 04:26:25 PM Linus Walleij wrote:
> > On Fri, Oct 17, 2014 at 2:11 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > 
> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >
> > > GPIO descriptors are the preferred way over legacy GPIO numbers
> > > nowadays. Convert the driver to use GPIO descriptors internally but
> > > still allow passing legacy GPIO numbers from platform data to support
> > > existing platforms.
> > >
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> > > Acked-by: Bryan Wu <cooloney@gmail.com>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > (...)
> > 
> > >         if (led_dat->blinking) {
> > > -               led_dat->platform_gpio_blink_set(led_dat->gpio,
> > > -                                                led_dat->new_level,
> > > -                                                NULL, NULL);
> > > +               int gpio = desc_to_gpio(led_dat->gpiod);
> > > +               int level = led_dat->new_level;
> > 
> > So this desc_to_gpio() is done only to call the legacy callback below?
> > 
> > > +               if (gpiod_is_active_low(led_dat->gpiod))
> > > +                       level = !level;
> > 
> > And that leads to making it necessary to have this helper variable
> > to invert the level since that callback does not pass a descriptor
> > (which would inherently know if it's active low)....
> > 
> > > +
> > > +               led_dat->platform_gpio_blink_set(gpio, level, NULL, NULL);
> > 
> > Is it *really* impossible to change all the users of this callback?
> 
> You said it could be done in a followup patch.  Here:
> http://marc.info/?l=linux-acpi&m=141154536921643&w=4
> 
> And Mika said he would add that to his TODO list:
> http://marc.info/?l=linux-acpi&m=141155173924101&w=4
> 
> I suppose that is still valid.

Yes, I'll just let dust to settle before sending out a patch that
converts the existing users of platform_gpio_blink_set() callback to
gpio descriptors.

> 
> > 
> > >                 led_dat->blinking = 0;
> > >         } else
> > > -               gpio_set_value_cansleep(led_dat->gpio, led_dat->new_level);
> > > +               gpiod_set_value_cansleep(led_dat->gpiod, led_dat->new_level);
> > 
> > (...)
> > >         /* Setting GPIOs with I2C/etc requires a task context, and we don't
> > >          * seem to have a reliable way to know if we're already in one; so
> > >          * let's just assume the worst.
> > > @@ -72,11 +73,16 @@ static void gpio_led_set(struct led_clas
> > >                 schedule_work(&led_dat->work);
> > >         } else {
> > >                 if (led_dat->blinking) {
> > > -                       led_dat->platform_gpio_blink_set(led_dat->gpio, level,
> > > -                                                        NULL, NULL);
> > > +                       int gpio = desc_to_gpio(led_dat->gpiod);
> > > +
> > > +                       if (gpiod_is_active_low(led_dat->gpiod))
> > > +                               level = !level;
> > > +
> > > +                       led_dat->platform_gpio_blink_set(gpio, level, NULL,
> > > +                                                        NULL);
> > 
> > Same comment.
> > 
> > > @@ -85,9 +91,10 @@ static int gpio_blink_set(struct led_cla
> > >  {
> > >         struct gpio_led_data *led_dat =
> > >                 container_of(led_cdev, struct gpio_led_data, cdev);
> > > +       int gpio = desc_to_gpio(led_dat->gpiod);
> > >
> > >         led_dat->blinking = 1;
> > > -       return led_dat->platform_gpio_blink_set(led_dat->gpio, GPIO_LED_BLINK,
> > > +       return led_dat->platform_gpio_blink_set(gpio, GPIO_LED_BLINK,
> > >                                                 delay_on, delay_off);
> > 
> > Same comment.
> > 
> > > @@ -97,24 +104,33 @@ static int create_gpio_led(const struct
> > >  {
> > >         int ret, state;
> > >
> > > -       led_dat->gpio = -1;
> > > +       if (!template->gpiod) {
> > > +               unsigned long flags = 0;
> > >
> > > -       /* skip leds that aren't available */
> > > -       if (!gpio_is_valid(template->gpio)) {
> > > -               dev_info(parent, "Skipping unavailable LED gpio %d (%s)\n",
> > > -                               template->gpio, template->name);
> > > -               return 0;
> > > +               /* skip leds that aren't available */
> > > +               if (!gpio_is_valid(template->gpio)) {
> > > +                       dev_info(parent, "Skipping unavailable LED gpio %d (%s)\n",
> > > +                                       template->gpio, template->name);
> > > +                       return 0;
> > > +               }
> > > +
> > > +               if (template->active_low)
> > > +                       flags |= GPIOF_ACTIVE_LOW;
> > > +
> > > +               ret = devm_gpio_request_one(parent, template->gpio, flags,
> > > +                                           template->name);
> > > +               if (ret < 0)
> > > +                       return ret;
> > > +
> > > +               led_dat->gpiod = gpio_to_desc(template->gpio);
> > > +               if (IS_ERR(led_dat->gpiod))
> > > +                       return PTR_ERR(led_dat->gpiod);
> > >         }
> > 
> > OK so this is the legacy codepath: point it out in a big fat
> > comment that this is the legacy codepath.
> 
> That looks like it could be done in a followup patch too.
> 
> Since the series is in my linux-next branch at this point, I really wouldn't
> like to reshuffle commits in it if that can be avoided.
> 
> > > Index: linux-pm/include/linux/leds.h
> > > ===================================================================
> > > --- linux-pm.orig/include/linux/leds.h
> > > +++ linux-pm/include/linux/leds.h
> > > @@ -251,6 +251,7 @@ struct gpio_led {
> > >         unsigned        retain_state_suspended : 1;
> > >         unsigned        default_state : 2;
> > >         /* default_state should be one of LEDS_GPIO_DEFSTATE_(ON|OFF|KEEP) */
> > > +       struct gpio_desc *gpiod;
> > 
> > Put the new struct member right below the current "gpio"
> > member,
> 
> It was done like that in previous versions, but turned out to cause problems
> to happen in testing.  Unfortunately, I don't seem to be able to find a pointer
> to the original report ATM, but perhaps Mika can.  Mika?

It is burried inside this thread:

http://www.spinics.net/lists/arm-kernel/msg369522.html
