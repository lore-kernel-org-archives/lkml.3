Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaANJ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:26:18 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35696 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaANJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:26:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAGHPBZpaObWyif7nzitZSQYfvLegFiH0O9S9PCWaWNNQTUqi+Q@mail.gmail.com>
References: <CAGHPBZogJzOUTM=WooJmNd92=QCivWa9W+c9Co1NJd-sgRTB1A@mail.gmail.com>
	<CAGHPBZpaObWyif7nzitZSQYfvLegFiH0O9S9PCWaWNNQTUqi+Q@mail.gmail.com>
Date: Tue, 14 Jan 2014 10:26:13 +0100
Message-ID: <CACRpkdbZcJXGAzbwJrKYYVzo+8nw9145LMsA=jsdbRjkN3f0_w@mail.gmail.com>
Subject: Re: Confusion about Pinctrl and GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Rongrong Cao <caorr1980@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rongrong,

> I noticed that Stephen<swarren@nvidia.com> submitted a patch for pinctrl:
> http://www.gossamer-threads.com/lists/linux/kernel/1500890?do=post_view_threaded
>
> In this patch, Stephen said, "When an SoC muxes pins in a group, it's
> quite possible for the group to contain e.g. 6 pins, but only 4 of
> them actually be needed by the HW module that's mux'd to them. In this
> case, the other 2 pins could be used as GPIOs. However, pinctrl marks
> all the pins within the group as in-use by the selected mux function.
> To allow the expected gpiolib interaction, separate the concepts of
> pin ownership into two parts: One for the mux function and one for
> GPIO usage. Finally, allow those two ownerships to exist in parallel.

Yes that is how it works.

> I agree that gpiolib should be able to use the two idle pins as GPIO,
> but after apply this patch, gpiolib can also request the 4 pins used
> by HW module succesfully, and this will override the settings of the 4
> pins for HW module.

If your hardware cannot use the same pins for function X and
GPIO at the same time, it is the responsibility of the individual
driver to disallow this by returning an error code from e.g.
.gpio_request_enable() and .enable() in struct pinmux_ops.

> Assuming that the pin has been configured as SPI mode, undoubtedly we
> can't use it as GPIO any longer. However, if we call gpio_request()
> (gpiolib API) to requet this pin for GPIO purpose, gpio_request()
> still can return successfully. I think this is unreasonable,

It is only unreasonable that a certain driver allows this when
it should be disallowed. Just like a display driver shall disallow
setting update frequencies that can harm a display.

> However, no drivers in drivers/pinctrl/ implements such
> codes in pinmux_ops->gpio_request_enable().

So, if you know a driver is doing something wrong, why not
send a (tested) patch to fix the issue?

> Or, pinctrl subsystem is just resposible to set the pin in GPIO mode,
> and gpio subsystem (gpiolib) is responsible for other things like set
> direction, get value if input, or set high/low if output.

This is true but unrelated to the issue you're bringing up.

A separate GPIO driver should call pinctrl_request_gpio() etc from
the consumer interface to ensure proper muxing of the
GPIO line from the pinctrl backend.

> Let me talk again about the example described by Stephen. If actually
> only 4 pins of the group which contains 6 pins are needed by HW
> module, then why does the group be defined to contain 6 pins? I think
> the group should be defined only containing 4 pins rather than 6 pins,
> then the other 2 idle pins can be used for any other purpose.

It is possible to define two groups of 4+2 pins and only activate
the group containing the first four pins in a certain state in the
pin table. Then there will be no conflict about the two remaining
pins.

Another option is to implement .gpio_request_enable() as
outlined above and not deny the simultaneous usage of the
last two pins, but deny any attempt to use the first 4 pins
for GPIO.

I think many drivers certainly have logical holes here, but
they survive anyway because people do not subject them to
silly configurations and impossible usecases, but indeed if
you want to hammer down any possible mistake from a user
you can proceed to implement proper checking logic into
the driver(s).

Yours,
Linus Walleij
