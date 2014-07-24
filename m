Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbaGXPXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:23:11 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35200 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076AbaGXPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <53D11667.8050807@ti.com>
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
	<CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
	<53CFD404.7070704@ti.com>
	<CACRpkdYdUKmR+bZo374AqepDXfsZqBwJ88e4is90-UoUBWdJrA@mail.gmail.com>
	<53D11667.8050807@ti.com>
Date: Thu, 24 Jul 2014 17:23:07 +0200
Message-ID: <CACRpkdbBeySnCBD4H2bBmievHYyPabL8sKXKiBp-D6PtNTV9YQ@mail.gmail.com>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, Suman Anna <s-anna@ti.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        ivan.khoronzhuk@ti.com, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 4:21 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Thursday 24 July 2014 10:12 AM, Linus Walleij wrote:
>> On Wed, Jul 23, 2014 at 5:25 PM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>
>>> I will try to answer this. This IP is indeed a GPIO block
>>> but the IO's are used just OUTPUT lines from Linux
>>> HOST perspective. These IOs are connected to the DSPs
>>> as input/IRQ lines.
>>
>> So the DSP is another discrete IC, and could be something
>> different, so this is board-level information?
>>
>> I'm really worrying whether this is general purpose or not :-/
>>
> Am not sure I follow you. This IP is completely controlled
> by Linux OS to generate output signals. How does it matter
> whether its connected to a peripheral or a discrete IC.

What matters to me is whether it is general purpose or
not, and what the use case is.

The Kconfig symbol is called GPIO_KEYSTONE_DSP
not GPIO_KEYSTONE. That does not sound very general
purpose at all. Why is "DSP" at the end of that config
option if it is general purpose?

And we know the Keystone
already has another GPIO block, selected from the
Kconfig symbol GPIO_DAVINCI. Probably that is the
only real GPIO on this system.

And the use case doesn't seem to be exactly for
things like driving leds, reading keys, bit-banging SPI
or MMC card detect or other such common cases.
It seems to be to trigger IRQs on another processor and
nothing else. Not general purpose.

If writing bit such and such in some register has the
effect of pulling a bit high or low in some other IP
is not GPIO. It should be part of the driver for that
other IP block.

Further you wrote:

> The DSP-ARM host IPC mechanism used on
> Keystone is Linux user-space based and it does as
> one of the component.

And given that it's already hinted that this is actually
only there to aid some userspace driver I'm even *less*
interested in having it in the GPIO subsystem.

Shoehorning this into the GPIO subsystem just seems
like some convenient way to keep that DSP driver code
in userspace instead of writing a proper kernel driver
for the DSP.

Like someone wants to avoid things like this:
drivers/staging/tidspbridge
drivers/remoteproc/omap_remoteproc.c
drivers/remoteproc/da8xx_remoteproc.c

As a community maintainer, naturally doing such real
kernel drivers is way better than trying to sneak something
in under the radar, and now I'm worried that this is what
is actually attempted by this driver, so I'm concerned.

> Given that this IP only output functionality is used but
> that shouldn't matter. We have seen SOCs where GPIOs
> are just used as input to form a Matrix Keyboard.

Yes, that is common. And that is for example done with
GPIO_DAVINCI which has lines out to open space
and general purposes.

This is not GPIO, this is DSPIO IMO.

Yours,
Linus Walleij
