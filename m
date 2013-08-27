Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3H0UFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:05:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H0UFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:05:34 -0400
Message-ID: <521D0689.5020008@wwwdotorg.org>
Date: Tue, 27 Aug 2013 14:05:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com> <5217BD74.5030801@wwwdotorg.org> <201308261245.19513.poeschel@lemonage.de>
In-Reply-To: <201308261245.19513.poeschel@lemonage.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 04:45 AM, Lars Poeschel wrote:
> On Friday 23 August 2013 at 21:52:20, Stephen Warren wrote:
>> On 08/23/2013 12:45 PM, Linus Walleij wrote:
>>> On Thu, Aug 22, 2013 at 11:10 PM, Stephen Warren 
> <swarren@wwwdotorg.org> wrote:
>>>> On 08/21/2013 05:36 PM, Linus Walleij wrote:
>>>>> On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren
>>>>> <swarren@wwwdotorg.org> wrote: [Me]
>>>>>
>>>>>>>> check if these in turn reference the interrupt-controller, and
>>>>>>>> if they do, loop over the interrupts used by that child and
>>>>>>>> perform gpio_request() and gpio_direction_input() on these,
>>>>>>>> making them unreachable from the GPIO side.
>>>>>>
>>>>>> What about bindings that require a GPIO to be specified, yet don't
>>>>>> allow an IRQ to be specified, and the driver internally does
>>>>>> perform gpio_to_irq() on it? I don't think one can detect that
>>>>>> case.
>>>>>
>>>>> This is still allowed. Consumers that prefer to have a GPIO
>>>>> passed and convert it to IRQ by that call can still do so,
>>>>> they will know what they're doing and will not cause the
>>>>> double-command situation that we're trying to solve.
>>>>
>>>> Why not? There are certainly drivers in the kernel which request a
>>>> GPIO as both a GPIO and as an (dual-edge) interrupt, so that they
>>>> can read the GPIO input whenever the IRQ goes off, in order to
>>>> determine the pin state. This is safer against high-latency or lost
>>>> interrupts.
>>>
>>> Yes? Are we talking past each other here?
>>>
>>> This is a perfectly OK thing to do as long as it is done like
>>> this:
>>>
>>> request_gpio(gpio);
>>> gpio_direction_input(gpio);
>>> request_irq(gpio_to_irq(gpio));
>>
>> But I'm not aware that there's a rule saying it's illegal to:
>>
>> request_irq(gpio_to_irq(gpio));
>> request_gpio(gpio);
>> gpio_direction_input(gpio);
> 
> But I'd consider this as a bug. What if the scheduler interrupts you right 
> after you requested (and got assigned) the interrupt and another entity 
> requests your gpio? Then you'd have a resource conflict, because you are 
> not the owner of the gpio you requested an interrupt for.

How is that any different from two drivers both attempting to claim a
GPIO, and there being a race to get their first?

Presumably, all this happens in the device's/driver's probe(), and hence
if the gpio_request() fails, then probe() fails, and undoes all allocations.

Your argument can equally be applied to the first case where the GPIO is
requested first, then the IRQ later. What if driver A requests the GPIO
and then attempts to request the IRQ, yet the scheduler causes driver B
to *just* request the (same) IRQ (because it only cares about using it
as an IRQ and doesn't even know it's a GPIO). Then, you have the exact
same problem in reverse.

The only possible way to solve this is for either request_irq() or
request_gpio() to take complete ownership of the GPIO that backs the IRQ
if there is one, yet allow request_gpio by the same driver on that same
GPIO to still succeed, so that the order doesn't matter; whatever the
driver first always claims the GPIO and disallows any other driver from
claiming "part of the GPIO".

Yet, in your other reply you explicitly said there isn't a check for
this (the same driver claiming both the IRQ and GPIO).

Perhaps it would help to lay out exactly the problem this is trying to
solve and why it solves it again.
