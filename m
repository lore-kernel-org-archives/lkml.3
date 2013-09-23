Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3IWUVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:21:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42744 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3IWUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:21:45 -0400
Message-ID: <5240A2D3.20105@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:21:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lars Poeschel <poeschel@lemonage.de>,
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
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <522FBED9.9000305@collabora.co.uk> <5230C7F6.3080803@wwwdotorg.org> <3653629.tapNZSuWhS@lem-wkst-02> <52373B34.4060709@wwwdotorg.org> <CACRpkdY=cgtf6_eypfAAv-fvmiNgAYyz4StTgDie5THsbrcumg@mail.gmail.com>
In-Reply-To: <CACRpkdY=cgtf6_eypfAAv-fvmiNgAYyz4StTgDie5THsbrcumg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:01 PM, Linus Walleij wrote:
> On Mon, Sep 16, 2013 at 7:09 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Put another way, I don't believe
>> there's any rule when writing DT bindings that states that bindings must
>> not describe the same pin as both a GPIO and an IRQ, although admittedly
>> that may be unusual.
> 
> Actually I think you've won me over here.
> 
> But I do not think that this shall be done at the expense of letting
> DT-based drivers do nasty things like setting up the same GPIO
> line as an IRQ (hammering the hardware to do that) and then
> request the same line to be an output line and drive it, for
> example.
> 
> So the state of the GPIO line has to be tracked: if it is set as
> input and tied to an IRQ it should *not* be possible for the
> other code path to request it and set it as output. But it should
> be possible to set it as input again and read the value.
> 
> Laurent deascribed exactly the latter usecase, which is OK.
> 
>>> I agree with you that it would be the best if the only call would be
>>> request_irq and the chip driver programs the HW appropriately. It would be a
>>> dream, but unfortunately this is not possible at the moment. This is something
>>> that Linus pointed out very very early in this whole discussion. The gpio and
>>> irq frameworks don't share any information. The irq framework has no chance to
>>> program the HW, because it will never find the related gpio.
>>> For this to work the frameworks have to change (and possibly all drivers/board
>>> files/whatever using request_irq() and/or request_gpio()) have to change.
>>> That is something that I do not dare to do alone.
>>
>> This is a controller-specific issue, and has nothing to do with the GPIO
>> or IRQ frameworks. The driver for the combined irq/gpio_chip simply
>> needs to program the HW when the IRQ is requested or set up. The Tegra
>> driver already works this way, so there's actual proof that it is
>> possible to do this in practice.
> 
> And how to you block the same line from being gpio_request()ed
> and set as output?

To be honest, I really don't think this problem is terribly likely to
occur, so I'm really not convinced that it's worth putting a lot of
effort into solving it.

If the problem does occur, it's trivial to see that this has happened by
looking at /proc/interrupts and /sys/kernel/debug/gpio, assuming the
system doesn't hang when this happens due to an interrupt storm, and if
it does, it should be pretty easy to track down the problematic register
write.

That said, I'm not outright against the kernel checking for this
situation. I think it'd work as follows:

The only code that knows the correlation between the IRQ and GPIO in
question is the combined gpio_chip/irq_chip driver. Everything /has/ to
be driven through that driver. In some cases, an IRQ may not be related
to any GPIO at all; there are certainly IRQ controllers which take
inputs directly from outside the chip, but have no GPIO functionality at
all on those signals.

That driver needs to maintain some state that indicates which of its
IRQs have been requested. Any time a GPIO request (I mean e.g.
set_output() not request_gpio)) comes in, the request needs to be
validated against that IRQ usage state. If there's a conflict, deny the
GPIO request.

Now, it's quite possible that the code to maintain this state and
perform the checks will be similar/common across multiple drivers. If
so, by all means implement the code somewhere common, and have the
various irq_chip/gpio_chip drivers call into it.

The main thing is that all of this has to be driven/controlled/enabled
by the gpio_chip/irq_chip driver itself, not as some global/blanket
feature of the GPIO or IRQ subsystems.

Perhaps rather than having the gpio_chip/irq_chip drivers physically
implement a function which calls this common code, they could set some
flags/data/... in the struct gpio_chip/irq_chip indicating that they
desire the core code that implements the error-checking to be enabled.
That might save some levels of stack. But the key is still that the
whole scenario is controlled by the end driver, not always assumed to
apply by the core code.
