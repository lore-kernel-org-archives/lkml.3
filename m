Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKFLMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:12:12 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60982 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKFLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:12:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141106105855.GL1618@lahna.fi.intel.com>
References: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
	<545843B1.3020101@nvidia.com>
	<2455157.3p7mHhT8im@vostro.rjw.lan>
	<CAMuHMdXn9W2S7N+YGfjDxQozMtRZCVdTzzdDps6YfOv2FqVBmw@mail.gmail.com>
	<20141106103033.GK1618@lahna.fi.intel.com>
	<CAMuHMdWtcZcpW=r60s9auENZxChiLwr14R0p_soKr7C3yGYOMQ@mail.gmail.com>
	<20141106105855.GL1618@lahna.fi.intel.com>
Date: Thu, 6 Nov 2014 12:12:04 +0100
X-Google-Sender-Auth: m-TVktPzet2fHM7xLyN16f36OF8
Message-ID: <CAMuHMdUroLo5SdXrTu+etiW+TwHAWV-Qn9UsVnud+BJ7q6nXjw@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Thu, Nov 6, 2014 at 11:58 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Nov 06, 2014 at 11:32:19AM +0100, Geert Uytterhoeven wrote:
>> On Thu, Nov 6, 2014 at 11:30 AM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> >> "leds: leds-gpio: Add support for GPIO descriptors" broke leds-gpio on
>> >> non-DT platforms for me:
>> >>
>> >>     gpiod_direction_output: invalid GPIO
>> >>     leds-gpio: probe of leds-gpio failed with error -22
>> >>
>> >> (desc is NULL in gpiod_direction_output()).
>> >>
>> >> DT shmobile reference/multi-platform are fine.
>> >>
>> >> I noticed the hard way, as I wanted to add some LEDs to a new platform,
>> >> but couldn't get it work. It turned out it also had stopped working on
>> >> r8a7740/armadillo-legacy, so I started bisecting...
>> >
>> > Which board file that is?
>> >
>> > There is a bug that gpio_to_desc() returns NULL instead if ERR_PTR() in
>> > that patch but I wonder why gpio_is_valid() and devm_gpio_request_one()
>> > do not complain about that prior.
>>
>> arch/arm/mach-shmobile/board-armadillo800eva.c
>
> Are you able to put some printks() to the 'if (!template->gpiod)' branch
> so that it prints out gpio number and what does devm_gpio_request_one()
> return?
>
> Something like:
>
>         if (!template->gpiod) {
>                 ...
>                 ret = devm_gpio_request_one(parent, template->gpio, flags,
>                                             template->name);
>                 dev_info(parent, "GPIO %u, ret: %d\n", template->gpio, ret);
>                 if (ret < 0)
>                         ...
>
>                 led_dat->gpiod = gpio_to_desc(template->gpio);
>                 dev_info(parent, "GPIOD: %p\n", led_dat->gpiod);

Sure:

    leds-gpio leds-gpio: GPIO 102, ret: 0
    leds-gpio leds-gpio: GPIOD: c050e970

So led_dat is non-NULL. But it's overwritten by NULL later:

    led_dat->gpiod = template->gpiod;

Whitespace damaged fix below, to fold into the original.
If you prefer a proper separate patch, let me know.

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index ba4698c32bb04bde..b3c5d9d6a42bcd8b 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -92,7 +92,8 @@ static int create_gpio_led(const struct gpio_led *template,
 {
        int ret, state;

-       if (!template->gpiod) {
+       led_dat->gpiod = template->gpiod;
+       if (!led_dat->gpiod) {
                /*
                 * This is the legacy code path for platform code that
                 * still uses GPIO numbers. Ultimately we would like to get
@@ -122,8 +123,7 @@ static int create_gpio_led(const struct gpio_led *template,

        led_dat->cdev.name = template->name;
        led_dat->cdev.default_trigger = template->default_trigger;
-       led_dat->gpiod = template->gpiod;
-       led_dat->can_sleep = gpiod_cansleep(template->gpiod);
+       led_dat->can_sleep = gpiod_cansleep(led_dat->gpiod);
        led_dat->blinking = 0;
        if (blink_set) {
                led_dat->platform_gpio_blink_set = blink_set;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
