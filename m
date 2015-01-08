Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbbAHOrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:47:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40181 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbAHOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:47:00 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 09:46:59 EST
MIME-Version: 1.0
In-Reply-To: <54AE43A9.3020309@schinagl.nl>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
 <1420621722-7428-5-git-send-email-oliver+list@schinagl.nl>
 <20150107235522.GA6670@dtor-ws> <54AE43A9.3020309@schinagl.nl>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 8 Jan 2015 08:40:20 -0600
Message-ID: <CAL_JsqJE_PCXrejHO3vfdbbtC4FGyuPhJ8W-A=8nZMcu6aBxCw@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] leds: no longer use unnamed gpios
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 2:45 AM, Olliver Schinagl <oliver@schinagl.nl> wrote:
> Hey Dmitry,
>
>
> On 08-01-15 00:55, Dmitry Torokhov wrote:
>>
>> On Wed, Jan 07, 2015 at 10:08:42AM +0100, Olliver Schinagl wrote:
>>>
>>> From: Olliver Schinagl <oliver@schinagl.nl>
>>>
>>> The gpio document says we should not use unnamed bindings for gpios.
>>> This patch uses the 'led-' prefix to the gpios and updates code and
>>> documents. Because the devm_get_gpiod_from_child() falls back to using
>>> old-style unnamed gpios, we can update the code first, and update
>>> dts files as time allows.

[...]

>>> --- a/drivers/leds/leds-gpio.c
>>> +++ b/drivers/leds/leds-gpio.c
>>> @@ -184,7 +184,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct
>>> platform_device *pdev)
>>>                 struct gpio_led led = {};
>>>                 const char *state = NULL;
>>>   -             led.gpiod = devm_get_gpiod_from_child(dev, NULL, child);
>>> +               led.gpiod = devm_get_gpiod_from_child(dev, "led", child);
>>
>> Would not this break existing boards using old bindings? You need to
>> handle both cases: if you can't located "led-gpios" then you will have to
>> try just "gpios".
>
> Very true. I was rather even hoping we could update all bindings, I don't
> mind going through the available dts files to fix them ... But need to know
> that that's the proper way to go before doing the work ;)

That will not work. You cannot make changes that require a new dtb
with a new kernel. This would also break for the other way around
(i.e. a new dtb and old kernel).

You would have to search for both led-gpios and gpios. I'm not sure if
we can do that generically for all GPIOs. If you had a node with both
"blah-gpios" and "gpios", it would break. I would hope there are no
such cases like that. We also now have to consider how ACPI identifies
GPIOs and whether this makes sense.

Rob
