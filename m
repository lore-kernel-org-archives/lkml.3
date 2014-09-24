Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaIXJmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:42:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:54538 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXJmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:42:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,588,1406617200"; 
   d="scan'208";a="479664294"
Date: Wed, 24 Sep 2014 12:42:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC PATCH v2 09/16] leds: leds-gpio: Add support for GPIO
 descriptors
Message-ID: <20140924094208.GX1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1410868367-11056-10-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdY9enL9v=-e3W8Mqw+RFeTM8pjAPW_sF050sCVCsrJWHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY9enL9v=-e3W8Mqw+RFeTM8pjAPW_sF050sCVCsrJWHQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:55:48AM +0200, Linus Walleij wrote:
> On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > GPIO descriptors are the preferred way over legacy GPIO numbers
> > nowadays. Convert the driver to use GPIO descriptors internally but
> > still allow passing legacy GPIO numbers from platform data to support
> > existing platforms.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Great!
> 
> >  #include <linux/gpio.h>
> > +#include <linux/gpio/consumer.h>
> 
> You should not need to include <linux/gpio.h> at all after this change.

It is still needed because we call devm_gpio_request_one() if we find
legacy numbers from platform data.

> > @@ -85,9 +91,10 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
> >  {
> >         struct gpio_led_data *led_dat =
> >                 container_of(led_cdev, struct gpio_led_data, cdev);
> > +       int gpio = desc_to_gpio(led_dat->gpiod);
> >
> >         led_dat->blinking = 1;
> > -       return led_dat->platform_gpio_blink_set(led_dat->gpio, GPIO_LED_BLINK,
> > +       return led_dat->platform_gpio_blink_set(gpio, GPIO_LED_BLINK,
> >                                                 delay_on, delay_off);
> >  }
> 
> While this is a nice first step, it must be possible to patch all in-kernel
> users of this callback to take a gpiod too...
> 
> It's actually just:
> 
> $ git grep gpio_blink_set
> arch/arm/mach-orion5x/dns323-setup.c:   .gpio_blink_set =
> orion_gpio_led_blink_set,
> arch/arm/mach-orion5x/dns323-setup.c:   .gpio_blink_set =
> orion_gpio_led_blink_set,
> arch/arm/mach-s3c24xx/mach-h1940.c:     .gpio_blink_set = h1940_led_blink_set,
> arch/arm/mach-s3c24xx/mach-rx1950.c:    .gpio_blink_set = rx1950_led_blink_set,
> 
> However we can do that as a follow-up patch. (Add to TODO...)

OK, I'll add that to my TODO list :)
