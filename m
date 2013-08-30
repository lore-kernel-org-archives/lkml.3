Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3H3AYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:24:40 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54047 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3H3AYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:24:38 -0400
Message-ID: <521FE637.3010805@collabora.co.uk>
Date: Fri, 30 Aug 2013 02:24:23 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
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
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <521D0964.2080209@wwwdotorg.org> <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com>
In-Reply-To: <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 09:26 PM, Linus Walleij wrote:
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

The mentioned patch also broke some ancient platforms that have not been (and
probably never will) migrated to DT like OMAP1.

So, after trying to add this logic by using a custom irq domain .map function
handler for the OMAP GPIO driver I agree with Linus that is better to provide a
solution at the Device Tree level to not affect platforms that are still using
legacy boot.

Legacy boot don't need a fix since it does not have this issue. Platform code
just request the GPIO and do the setup (gpio_direction_input) before the drivers
call to request_irq().

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
> 
> (Also, it force us to implement the same code in each
> and every driver, but that is a lesser problem.)
> 
> I don't quite understand what is so hard around this.
> We cannot get away from restricting the semantics in
> some way, if gpio-controllers shall also be interrupt-controllers,
> the current patch is the least intrusive I've seen so far.
> 

We have been trying to solve this issue for a few months by now and Linus'
approach seems to be the most sensible solution to me.

Drivers that request an IRQ and assume that platform code will request and setup
the GPIO have been broken since the boards using these drivers were migrated to
DT (e.g: smsc911x on OMAP2+ boards). I know is really hard to agree on the
better approach to solve this but it would be great if we can find a solution
and fix these broken platforms.

> And I don't even think this is a Linux problem, handing
> out the same resource with two hands is ambigous and is
> going to cause problems with any operating system.
> It is better to restrict this and say in the binding doc that
> the gpio line cannot be <&gpio n> assigned when there
> is an interrupt on the same line.
>

Indeed, if a driver wants to manually request a GPIO to be used as an IRQ, then
the DT binding for that driver should not use a gpio as "interrupt-parent" and
should leave the driver to handle this manually.

On the other hand, if a driver just calls request_irq() and it does not know if
the IRQ is a real interrupt line from an interrupt controller or a GPIO line
acting as an IRQ, then the DT binding should just have a required
"interrupt-parent" property to define the phandle for the interrupt controller
used which could or could not be a GPIO controller.

> We can start out by printing warnings when we fail to
> request the corresponding GPIO for an interrupt line
> though, it will be annoying enough and a kind of
> compromise.
>

If the GPIO pin is first requested because it is described to be an IRQ in a DT
and then a driver tries to request the same GPIO pin, then there is a bug in
either the DT or the driver IMHO. The same assumption is made with platform code
right now when using legacy boot, I don't understand why is different for the DT
case.

> Or it has to be the GPIO input hogs.
> 
> Yours,
> Linus Walleij
> 

Thanks a lot and best regards,
Javier
