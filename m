Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3H3Txw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:53:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3H3Txu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:53:50 -0400
Message-ID: <5220F849.8030909@wwwdotorg.org>
Date: Fri, 30 Aug 2013 13:53:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <521D0964.2080209@wwwdotorg.org> <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com>
In-Reply-To: <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 01:26 PM, Linus Walleij wrote:
> On Tue, Aug 27, 2013 at 10:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/26/2013 08:07 AM, Lars Poeschel wrote:
>>>
>>> Currently the kernel is ambigously treating GPIOs and interrupts
>>> from a GPIO controller: GPIOs and interrupts are treated as
>>> orthogonal. This unfortunately makes it unclear how to actually
>>> retrieve and request a GPIO line or interrupt from a GPIO
>>> controller in the device tree probe path.
>>
>> I still think that this patch is the wrong approach. Instead, the logic
>> should be hooked into gpio_request() and request_irq(). This patch only
>> addresses DT, and ignores anything else, hence doesn't seem like the
>> right level of abstraction to plug in, since the issue is not related to DT.
> 
> We tried to do it that way, and it exploded. See commit
> b4419e1a15905191661ffe75ba2f9e649f5d565e
> "gpio/omap: auto request GPIO as input if used as IRQ via DT"
> 
> Here request_irq() augmented through its irqdomain to
> issue gpio_request_one().
> 
> Why was this patch reverted? It seems this is what has not
> managed to reach the audience here.
> 
> It turns out some drivers were already doing this:
> 
> request_gpio(gpio);
> gpio_direction_input(gpio);
> request_irq(gpio_to_irq(gpio));
> 
> Looks perfectly valid right?
> 
> Not so: after the above change, we tried to request the
> GPIO a *second time* in the GPIO driver's irq map function,
> and of course it failed, as it was already taken.
> 
> So saying that it should be done in the request_irq()
> function is imposing this other semantic on the kernel
> instead: you must *NOT* request the GPIO with
> request_gpio() if you're going to use it as an IRQ.

Surely both request_gpio() and request_irq() must both request the GPIO
(amongst other things), with the caveat that if the same driver does
both, this specific "sharing" is allowed.

If that won't work, then the very core concept behind what this patch is
attempting to do won't work.

> (Also, it force us to implement the same code in each
> and every driver, but that is a lesser problem.)

Drivers don't have to do the request; the IRQ/GPIO core can do this,
with drivers simply providing an irq_to_gpio() (which only returns valid
data iff there's a 1:1 mapping between IRQs and GPIOs in that particular
HW).

> I don't quite understand what is so hard around this.
> We cannot get away from restricting the semantics in
> some way, if gpio-controllers shall also be interrupt-controllers,
> the current patch is the least intrusive I've seen so far.

Yet the current patch only addresses a limited set of cases, since it
doesn't hook the APIs but rather parses the DT. It doesn't cover the
non-DT case. It should if the feature is useful.

> And I don't even think this is a Linux problem, handing
> out the same resource with two hands is ambigous and is
> going to cause problems with any operating system.
> It is better to restrict this and say in the binding doc that
> the gpio line cannot be <&gpio n> assigned when there
> is an interrupt on the same line.

That won't work; there is already HW that allows this and drivers that
assume this.

I still haven't seen an answer to why we really care about this; how
many times has code actually allocated the same GPIO/IRQ when it
shouldn't, in a way that it wasn't detectable by some other mechanism,
i.e. the feature just not working? Why are we even trying to solve this
issue? I'm not totally convinced it even makes sense to try and solve it.
