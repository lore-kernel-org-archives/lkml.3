Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbbAPKPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:15:01 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34862 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbAPKO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <54B55068.8050500@broadcom.com>
References: <rjui@broadcom.com>
	<1418696307-19392-1-git-send-email-rjui@broadcom.com>
	<1418696307-19392-3-git-send-email-rjui@broadcom.com>
	<CACRpkdYGksEseGaO49=1rUi5WBdOxwAd-F1gpgZn+BFatRCdDg@mail.gmail.com>
	<54B55068.8050500@broadcom.com>
Date: Fri, 16 Jan 2015 11:14:56 +0100
Message-ID: <CACRpkdZef8S-EAbShjJ1eg+-3wQKn+yx4u1k_Mf8F7uFkJYdFw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] gpio: Cygnus: add GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 6:05 PM, Ray Jui <rjui@broadcom.com> wrote:
> On 1/13/2015 12:53 AM, Linus Walleij wrote:
>> On Tue, Dec 16, 2014 at 3:18 AM, Ray Jui <rjui@broadcom.com> wrote:
>>
>>> +/* drive strength control for ASIU GPIO */
>>> +#define CYGNUS_GPIO_ASIU_DRV0_CTRL_OFFSET 0x58
>>> +
>>> +/* drive strength control for CCM GPIO */
>>> +#define CYGNUS_GPIO_CCM_DRV0_CTRL_OFFSET  0x00
>>
>> This stuff (drive strength) is pin control, pin config.
>> It does not belong in a pure GPIO driver. If you're
>> making a combined pin control + GPIO driver, it
>> shall be put in drivers/pinctrl/*
>>
> Okay, I have some questions here. Are you suggesting me to register this
> driver to both the pinctrl subsystem and gpiolib and move it to under
> drivers/pinctrl/*?

Either you can have a combined driver in drivers/pinctrl/*
which has one probe() function calling pinctrl_register(),
gpiochip_add(), gpiochip_add_pin_range(), having the gpio
parts call into the pin control backend with
pinctrl_request_gpio(), pinctrl_free_gpio(),
pinctrl_gpio_direction_input(), pinctrl_gpio_direction_output().

Or you can split it in one driver in drivers/pinctrl/*
dealing with just the pin control stuff, and another driver
in drivers/gpio/* dealing with the GPIO stuff, each with one
probe() function.

If they are using the same register range, the first approach
is probably most intuitive. If the pin control and GPIO parts
are separated in different register ranges, probably the
second approach is the best.

> Or Are you suggesting me to combine this driver with the other Cygnus
> pinctrl driver (which only supports pinmux)?

Depends on which hardware block the pin control-like
registers belongs in. See per above.

> Note in Cygnus, all pinmux logic is done in the pinmux block. And there
> are 3 GPIO controllers, that handle GPIO, drive strength of the GPIO
> pins, internal pull up/down of the GPIO pins, which are handled in this
> driver. So this driver is generic to all 3 GPIO controllers, as you can
> see from the device tree bindings, there are 3 nodes.
>
> Therefore, I think it makes sense to have one pinmux driver that handles
> the pinmux block, and one generic pinctrl + gpio driver that handles
> functions supported by all 3 GPIO controllers. Does this make sense to you?

Yep.

Some hardware designs put the software-controlled biasing
resistors in the GPIO block electronically connected to the actual
pins, so that e.g. the biasing will be available if some MMC or
whatever is using the same pins in another muxing. In such
situations it's quite evident that they need to be a combined
GPIO and pin controller.

I have some regrets that bolting a second pin controller to the
GPIO chip make things a bit complex but it's a price we have
to pay for getting some kind of generic interface.

Yours,
Linus Walleij
