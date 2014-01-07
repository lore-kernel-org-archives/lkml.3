Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaAGTCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:02:17 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45196 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaAGTCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:02:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAGHPBZrPx-ouPkVfvT6mXh1QH5gSPbUwuyAnmSU60AbqKybvsA@mail.gmail.com>
References: <CAGHPBZrPx-ouPkVfvT6mXh1QH5gSPbUwuyAnmSU60AbqKybvsA@mail.gmail.com>
Date: Tue, 7 Jan 2014 20:02:03 +0100
Message-ID: <CACRpkdYK+ceGO2rayHW27h4KAcdk_Je7EimTZ5ZiO6NmPpzaWA@mail.gmail.com>
Subject: Re: Confusion about Pinctrl and GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?B?5pu56I2j6I2j?= <caorr1980@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 5:56 AM, 曹荣荣 <caorr1980@gmail.com> wrote:

> I have read the latest Documentation/pinctrl.txt, and there is two examples
> about muxing logic in "GPIO mode pitfalls" section, let me take example A
> for instance:
>
>                        pin config
>                        logic regs
>                        |               +- SPI
>      Physical pins --- pad --- pinmux -+- I2C
>                                |       +- mmc
>                                |       +- GPIO
>                                pin
>                                multiplex
>                                logic regs
>
> Assuming that the pin has been configured as SPI mode, undoubtedly we can't
> use it as GPIO any longer. However, if we call gpio_request() (gpiolib API)
> to requet this pin for GPIO purpose, gpio_request() still can return
> successfully. I think this is unreasonable, gpio_request() should return an
> "error code" if the pin is in-use by PINMUX.

Yes but there is also example (B) where it is perfectly possible
to use the same pin as GPIO and for a device at the same time.
So that case needs to be supported as well.

> I read the codes of pin_request() in pinmux.c, and guess
> pinmux_ops->gpio_request_enable() may be responsible to handle this use
> case, that is, to return an "error code" if the pin has been owned by
> pinmux.

Yes this is one way to fix this: let the driver impose such
restrictions.

> However, no drivers in drivers/pinctrl/ implements such codes in
> pinmux_ops->gpio_request_enable().

OK so what about you fix it for a driver you have a problem
with? :-)

> Or, pinctrl subsystem is just resposible to set the pin in GPIO mode, and
> gpio subsystem (gpiolib) is responsible for other things like set direction,
> get value if input, or set high/low if output. Is my understanding right?

The pinctrl subsystem is responsible for all muxing, and the GPIO
subsystem drives and reads GPIO lines yes.

> Let me talk about the example described by Stephen. If actually only 4 pins
> of the group which contains 6 pins are needed by HW module, then why does
> the group be defined to contain 6 pins? I think the group should be defined
> only containing 4 pins rather than 6 pins, then the other 2 idle pins can be
> used for any other purpose.

Group definition should be done at the granularity needed to work
with the system mux configuration. Nominally the group definition
should reflect the electrical use case(s) indicated in the documentation
of the pin controller. Some choose to create one group per pin when
all pins can be muxed around individually.

Yours,
Linus Walleij
