Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3FJCNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:13:36 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36228 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3FJCNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYmOHX2bPMKHwY=V2L+4EN-+5KzD-YCJhQtfkFeKV5p8g@mail.gmail.com>
References: <CAAVeFu+hQHScYYkvO1KOrUPLLaC0ju_O4SDZWyJE8KhLn_hibQ@mail.gmail.com>
 <CACRpkdYmOHX2bPMKHwY=V2L+4EN-+5KzD-YCJhQtfkFeKV5p8g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 10 Jun 2013 11:13:14 +0900
Message-ID: <CAAVeFuJctmszhjyL7Z09pzYt9c_NhhYm5xbgm+Ns3gE5Y-xjJQ@mail.gmail.com>
Subject: Re: Active-low behavior in gpiolib
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, linux-gpio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 4:10 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Well it is designed as a sysfs-only thing according to the comment:
> drivers/gpio/gpiolib.c:#define FLAG_ACTIVE_LOW  6       /* sysfs value
> has active low */
>
> So I think your actual question is whether it should also be
> enabled for the kernel-internal interfaces.

Yes, that's my question.

> Currently we have things like this:
>
> /**
>  * struct mmci_platform_data - platform configuration for the MMCI
>  * (also known as PL180) block.
> (...)
>  * @gpio_cd: read this GPIO pin to detect card insertion
>  * @cd_invert: true if the gpio_cd pin value is active low
> (...)
>         int     gpio_cd;
>         bool    cd_invert;
>
> So the knowledge of whether a certain GPIO is active high or low
> is spread out through drivers, and the API only drives the line in a
> very explicit way.
>
> I am uncertain whether it is wise to move this into gpiolib for
> in-kernel consumers, it is mainly a convention of where the
> knowledge should sit. In the mentioned case, the flags will still
> be needed because we need to have the information there to
> set the flag toward the gpiolib API anyway.
>
> So the only thing gained is that gpiolib gets some knowledge
> of how the pin is used. But what is the gain of that?

Well, my problem is clearly highlighted by the example you mention,
which is a very common usage pattern especially for DT-obtained GPIOs
which can have this OF_GPIO_ACTIVE_LOW flag. E.g. we have a lot of
this:

    gpio = of_get_named_gpio_flags(np, "foo-gpios", 0, &flags);
    active_low = flags & OF_GPIO_ACTIVE_LOW ? 1 : 0;
    ...
    state = (gpio_get_value(gpio) ? 1 : 0) ^ active_low;
    ...
    gpio_set_value(gpio, (value ? 1 : 0) ^ active_low;

which could be simplified into this:

    gpio = of_get_named_gpiod_flags(np, "foo-gpios", 0);
    ...
    state = gpiod_get_value(gpio);
    ...
    gpiod_set_value(gpio, value);

Board design makes it possible to turn any GPIO active low for any
(good or bad) reason, thus the drivers, which interact with gpiolib,
are more likely to want to set the GPIO logical value (taking the
active low parameter into account) rather than its raw level.

In the end, drivers that are not using an active_low flag are most
likely doing so just because they never encountered such a situation.
In practice, I suspect nearly all drivers want to be aware of the
active-low property.

Since gpiolib is already half-aware of this property, through the
sysfs active_low node and the OF_GPIO_ACTIVE_LOW DT property, why not
complete the circle and ease the life of driver writers?

As Stephen wrote, an alternative set of functions to get/set the
actual raw value of the line could be provided, but my understanding
is that an overwhelming majority of GPIO users would benefit from
having the active low property being handled transparently.

Alex.
