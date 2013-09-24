Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3IXIbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:31:46 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46883 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3IXIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <5240A2D3.20105@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<522FBED9.9000305@collabora.co.uk>
	<5230C7F6.3080803@wwwdotorg.org>
	<3653629.tapNZSuWhS@lem-wkst-02>
	<52373B34.4060709@wwwdotorg.org>
	<CACRpkdY=cgtf6_eypfAAv-fvmiNgAYyz4StTgDie5THsbrcumg@mail.gmail.com>
	<5240A2D3.20105@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:31:41 +0200
Message-ID: <CACRpkdZ7E7MGppbkTiObvTDHdmphnbysMKVc1OZjsPXKVuKttQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        joelf@ti.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:21 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/23/2013 02:01 PM, Linus Walleij wrote:

>> And how to you block the same line from being gpio_request()ed
>> and set as output?
>
> To be honest, I really don't think this problem is terribly likely to
> occur, so I'm really not convinced that it's worth putting a lot of
> effort into solving it.

I have a different opionion, I think this is important. As GPIO
subsystem maintainer I need to be convinced of the integrity
of the system.

> If the problem does occur, it's trivial to see that this has happened by
> looking at /proc/interrupts and /sys/kernel/debug/gpio,

I basically want /sys/kernel/debug/gpio to say if a certain line
is tied for IRQ.

> That driver needs to maintain some state that indicates which of its
> IRQs have been requested. Any time a GPIO request (I mean e.g.
> set_output() not request_gpio)) comes in, the request needs to be
> validated against that IRQ usage state. If there's a conflict, deny the
> GPIO request.

I think this should be done by gpiolib, and I think it is trivial
given the right APIs. Putting it in the drivers will just create
an array of similar-look Rube Goldberg-machines and code
duplication. There is no point.

> Now, it's quite possible that the code to maintain this state and
> perform the checks will be similar/common across multiple drivers. If
> so, by all means implement the code somewhere common, and have the
> various irq_chip/gpio_chip drivers call into it.

And this is what we should do in gpiolib.

> The main thing is that all of this has to be driven/controlled/enabled
> by the gpio_chip/irq_chip driver itself, not as some global/blanket
> feature of the GPIO or IRQ subsystems.

Sure.

> Perhaps rather than having the gpio_chip/irq_chip drivers physically
> implement a function which calls this common code, they could set some
> flags/data/... in the struct gpio_chip/irq_chip indicating that they
> desire the core code that implements the error-checking to be enabled.

I think it should more be like a function they can call to flag
a GPIO as used for IRQ.

Yours,
Linus Walleij
