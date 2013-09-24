Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab3IXI0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:26:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54834 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXI0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <5240A0C2.4010502@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<52279524.8090006@wwwdotorg.org>
	<20130909161924.GT29403@sirena.org.uk>
	<2052193.CMUEUJFRgS@lem-wkst-02>
	<522F78CB.2020507@wwwdotorg.org>
	<20130910213718.GH29403@sirena.org.uk>
	<522F9E6C.2010905@wwwdotorg.org>
	<522FBED9.9000305@collabora.co.uk>
	<5230C7F6.3080803@wwwdotorg.org>
	<CACRpkdacx-e01i_h4cj1qMX2zNOiiDshbTV__wi_LfQrLkrL6g@mail.gmail.com>
	<5240A0C2.4010502@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:26:10 +0200
Message-ID: <CACRpkdZKqW9veHzc1Rgj4oKsjGRATk+Sz8vJaP3EfT4de+bjQA@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
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
        joelf@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:12 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/23/2013 01:53 PM, Linus Walleij wrote:

>> I think the kernel should prevent such things.
>
> It might be nice if it could do that.
>
> However, that is 100% unrelated to the problem at hand.

I don't think it is unrelated when the old OMAP boardfile-based
code definately prevents such uses by its strict usage
of gpio_request() for all IRQ-bound GPIOs.

I think not preventing it for the DT boot path is setting lower
standards for DT code than for boardfile code which is not
what we should be doing.

> A driver which only cares about an IRQ should be able to call just IRQ
> APIs and have the HW work. Since not all IRQs are GPIOs, the thing that
> causes the HW to work should not involve the GPIO subsystem in any way
> at all.

Yes I have bought into that concept now.

> Having the kernel detect when two different drivers both request the
> same resource is entirely another thing. The solution to the first issue
> must not rely on any solution to this second issue.

I understand this stance from a DT point of view - which is about
resource passing and its syntax and semantics.

>From a GPIO subsystem point of view, in keeping resources under
kernel control, I naturally do not agree.

> I'm also not convinced it's possible to solve this second issue given
> the current kernel APIs, since there's not enough semantic information;
> requests of GPIOs and IRQs aren't actually tied to a particular driver
> at present (there's no "struct device *dev" parameter to request_irq or
> gpio_request) and so the subsystems can't actually tell who is
> requesting the GPIO/IRQ, and hence can't detect when the same driver, or
> a different driver, is requesting the same core resource for different
> purposes.

Solving the issue that e.g. two different drivers competing about the
same resource (as in one driver requesting an IRQ and another one
requesting a GPIO) is not what I'm after here.

I'm more after the GPIO subsystem having knowledge of a certain
GPIO line being requested for IRQ, and denying that line to be set
as input.

Maybe this can actually be achieved quite easily with
an additional API? Like gpio_lock_as_irq(gpio) which flags this
in .flags of struct gpio_desc and prevent such things?

Alexandre what do you think about this idea?

> Equally, I am actually not 100% sure we want the core to prevent this.
> Why shouldn't two different drivers request the same IRQ? Why shouldn't
> at least one driver, perhaps more, request the pin as a GPIO (assuming
> it will only read the GPIO value, not flip the pin to output).

But I have already stated that this is OK?

Are we talking past each other now?

> This
> exact situation might happen on some Tegra boards where there's a GPIO
> for VBUS_EN that affects 2 USB ports. It's supposed to be driven
> open-collector. If an external entity forces it low, it means
> over-current.

You are describing a very good reason for the core to be
doing exactly what I described I think?

Yours,
Linus Walleij
