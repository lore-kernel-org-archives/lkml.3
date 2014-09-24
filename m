Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaIXHzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:55:52 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53783 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaIXHzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <1410868367-11056-10-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410868367-11056-10-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 24 Sep 2014 09:55:48 +0200
Message-ID: <CACRpkdY9enL9v=-e3W8Mqw+RFeTM8pjAPW_sF050sCVCsrJWHQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/16] leds: leds-gpio: Add support for GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> GPIO descriptors are the preferred way over legacy GPIO numbers
> nowadays. Convert the driver to use GPIO descriptors internally but
> still allow passing legacy GPIO numbers from platform data to support
> existing platforms.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Great!

>  #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>

You should not need to include <linux/gpio.h> at all after this change.

> @@ -85,9 +91,10 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
>  {
>         struct gpio_led_data *led_dat =
>                 container_of(led_cdev, struct gpio_led_data, cdev);
> +       int gpio = desc_to_gpio(led_dat->gpiod);
>
>         led_dat->blinking = 1;
> -       return led_dat->platform_gpio_blink_set(led_dat->gpio, GPIO_LED_BLINK,
> +       return led_dat->platform_gpio_blink_set(gpio, GPIO_LED_BLINK,
>                                                 delay_on, delay_off);
>  }

While this is a nice first step, it must be possible to patch all in-kernel
users of this callback to take a gpiod too...

It's actually just:

$ git grep gpio_blink_set
arch/arm/mach-orion5x/dns323-setup.c:   .gpio_blink_set =
orion_gpio_led_blink_set,
arch/arm/mach-orion5x/dns323-setup.c:   .gpio_blink_set =
orion_gpio_led_blink_set,
arch/arm/mach-s3c24xx/mach-h1940.c:     .gpio_blink_set = h1940_led_blink_set,
arch/arm/mach-s3c24xx/mach-rx1950.c:    .gpio_blink_set = rx1950_led_blink_set,

However we can do that as a follow-up patch. (Add to TODO...)

Yours,
Linus Walleij
