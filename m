Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3H2T0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:26:37 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62188 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3H2T0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <521D0964.2080209@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<521D0964.2080209@wwwdotorg.org>
Date: Thu, 29 Aug 2013 21:26:34 +0200
Message-ID: <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 10:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/26/2013 08:07 AM, Lars Poeschel wrote:
>>
>> Currently the kernel is ambigously treating GPIOs and interrupts
>> from a GPIO controller: GPIOs and interrupts are treated as
>> orthogonal. This unfortunately makes it unclear how to actually
>> retrieve and request a GPIO line or interrupt from a GPIO
>> controller in the device tree probe path.
>
> I still think that this patch is the wrong approach. Instead, the logic
> should be hooked into gpio_request() and request_irq(). This patch only
> addresses DT, and ignores anything else, hence doesn't seem like the
> right level of abstraction to plug in, since the issue is not related to DT.

We tried to do it that way, and it exploded. See commit
b4419e1a15905191661ffe75ba2f9e649f5d565e
"gpio/omap: auto request GPIO as input if used as IRQ via DT"

Here request_irq() augmented through its irqdomain to
issue gpio_request_one().

Why was this patch reverted? It seems this is what has not
managed to reach the audience here.

It turns out some drivers were already doing this:

request_gpio(gpio);
gpio_direction_input(gpio);
request_irq(gpio_to_irq(gpio));

Looks perfectly valid right?

Not so: after the above change, we tried to request the
GPIO a *second time* in the GPIO driver's irq map function,
and of course it failed, as it was already taken.

So saying that it should be done in the request_irq()
function is imposing this other semantic on the kernel
instead: you must *NOT* request the GPIO with
request_gpio() if you're going to use it as an IRQ.

(Also, it force us to implement the same code in each
and every driver, but that is a lesser problem.)

I don't quite understand what is so hard around this.
We cannot get away from restricting the semantics in
some way, if gpio-controllers shall also be interrupt-controllers,
the current patch is the least intrusive I've seen so far.

And I don't even think this is a Linux problem, handing
out the same resource with two hands is ambigous and is
going to cause problems with any operating system.
It is better to restrict this and say in the binding doc that
the gpio line cannot be <&gpio n> assigned when there
is an interrupt on the same line.

We can start out by printing warnings when we fail to
request the corresponding GPIO for an interrupt line
though, it will be annoying enough and a kind of
compromise.

Or it has to be the GPIO input hogs.

Yours,
Linus Walleij
