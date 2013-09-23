Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3IWUBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:01:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39447 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3IWUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <52373B34.4060709@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<522FBED9.9000305@collabora.co.uk>
	<5230C7F6.3080803@wwwdotorg.org>
	<3653629.tapNZSuWhS@lem-wkst-02>
	<52373B34.4060709@wwwdotorg.org>
Date: Mon, 23 Sep 2013 22:01:24 +0200
Message-ID: <CACRpkdY=cgtf6_eypfAAv-fvmiNgAYyz4StTgDie5THsbrcumg@mail.gmail.com>
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

On Mon, Sep 16, 2013 at 7:09 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Put another way, I don't believe
> there's any rule when writing DT bindings that states that bindings must
> not describe the same pin as both a GPIO and an IRQ, although admittedly
> that may be unusual.

Actually I think you've won me over here.

But I do not think that this shall be done at the expense of letting
DT-based drivers do nasty things like setting up the same GPIO
line as an IRQ (hammering the hardware to do that) and then
request the same line to be an output line and drive it, for
example.

So the state of the GPIO line has to be tracked: if it is set as
input and tied to an IRQ it should *not* be possible for the
other code path to request it and set it as output. But it should
be possible to set it as input again and read the value.

Laurent deascribed exactly the latter usecase, which is OK.

>> I agree with you that it would be the best if the only call would be
>> request_irq and the chip driver programs the HW appropriately. It would be a
>> dream, but unfortunately this is not possible at the moment. This is something
>> that Linus pointed out very very early in this whole discussion. The gpio and
>> irq frameworks don't share any information. The irq framework has no chance to
>> program the HW, because it will never find the related gpio.
>> For this to work the frameworks have to change (and possibly all drivers/board
>> files/whatever using request_irq() and/or request_gpio()) have to change.
>> That is something that I do not dare to do alone.
>
> This is a controller-specific issue, and has nothing to do with the GPIO
> or IRQ frameworks. The driver for the combined irq/gpio_chip simply
> needs to program the HW when the IRQ is requested or set up. The Tegra
> driver already works this way, so there's actual proof that it is
> possible to do this in practice.

And how to you block the same line from being gpio_request()ed
and set as output?

Yours,
Linus Walleij
