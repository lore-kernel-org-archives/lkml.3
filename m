Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3IXQ4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:56:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59245 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3IXQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:56:33 -0400
Message-ID: <5241C43A.2080402@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:56:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
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
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F78CB.2020507@wwwdotorg.org> <20130910213718.GH29403@sirena.org.uk> <522F9E6C.2010905@wwwdotorg.org> <522FBED9.9000305@collabora.co.uk> <5230C7F6.3080803@wwwdotorg.org> <CACRpkdacx-e01i_h4cj1qMX2zNOiiDshbTV__wi_LfQrLkrL6g@mail.gmail.com> <5240A0C2.4010502@wwwdotorg.org> <CACRpkdZKqW9veHzc1Rgj4oKsjGRATk+Sz8vJaP3EfT4de+bjQA@mail.gmail.com>
In-Reply-To: <CACRpkdZKqW9veHzc1Rgj4oKsjGRATk+Sz8vJaP3EfT4de+bjQA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:26 AM, Linus Walleij wrote:
> On Mon, Sep 23, 2013 at 10:12 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 09/23/2013 01:53 PM, Linus Walleij wrote:
> 
>>> I think the kernel should prevent such things.
>>
>> It might be nice if it could do that.
>>
>> However, that is 100% unrelated to the problem at hand.
> 
> I don't think it is unrelated when the old OMAP boardfile-based
> code definately prevents such uses by its strict usage
> of gpio_request() for all IRQ-bound GPIOs.
> 
> I think not preventing it for the DT boot path is setting lower
> standards for DT code than for boardfile code which is not
> what we should be doing.

Semantics matter.

In the old board file code, the gpio_request()s were present to work
around the bug in the OMAP driver where request_irq() wouldn't configure
the IRQ signal correctly. That's the primary reason those calls were there.

Now, this had the side-effect of also preventing anything else from
calling gpio_request() on those GPIOs, but that wasn't the primary
motivation; just a convenient effect.

...
> Solving the issue that e.g. two different drivers competing about the
> same resource (as in one driver requesting an IRQ and another one
> requesting a GPIO) is not what I'm after here.
> 
> I'm more after the GPIO subsystem having knowledge of a certain
> GPIO line being requested for IRQ, and denying that line to be set
> as input.

s/input/output/ I assume.

...
> Maybe this can actually be achieved quite easily with
> an additional API? Like gpio_lock_as_irq(gpio) which flags this
> in .flags of struct gpio_desc and prevent such things?
> 
> Alexandre what do you think about this idea?
> 
>> Equally, I am actually not 100% sure we want the core to prevent this.
>> Why shouldn't two different drivers request the same IRQ? Why shouldn't
>> at least one driver, perhaps more, request the pin as a GPIO (assuming
>> it will only read the GPIO value, not flip the pin to output).
> 
> But I have already stated that this is OK?
> 
> Are we talking past each other now?

If all you want to do is prevent gpio_direction_input() on a GPIO that's
in use as a GPIO, then that's probably OK.

However, the interrupt consistency patch that was posted implemented
that restriction by calling gpio_request(), and the wording of most of
what you've written implies to me that implementing the restriction by
calling gpio_request() is what you're after. That approach imposes far
more restrictions than just preventing gpio_direction_input(). Imposing
those additional restrictions is what I'm objecting to.
