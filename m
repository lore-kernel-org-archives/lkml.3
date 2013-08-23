Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3HWUzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:55:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44964 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3HWUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:55:50 -0400
Message-ID: <5217CC4D.2080905@wwwdotorg.org>
Date: Fri, 23 Aug 2013 14:55:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
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
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com> <5217BD74.5030801@wwwdotorg.org> <1551491.9oAMd0jnLN@flatron>
In-Reply-To: <1551491.9oAMd0jnLN@flatron>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 01:55 PM, Tomasz Figa wrote:
> On Friday 23 of August 2013 13:52:20 Stephen Warren wrote:
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
>>>> GPIO
>>>> as both a GPIO and as an (dual-edge) interrupt, so that they can read
>>>> the GPIO input whenever the IRQ goes off, in order to determine the
>>>> pin
>>>> state. This is safer against high-latency or lost interrupts.
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
> Well, at least on Samsung platforms it is illegal to do so, because 
> gpio_direction_input() would override the interrupt+input function set by 
> setup done in request_irq() with normal input function, thus breaking the 
> interrupt.

Assuming that Linux has no general rule that requires a specific order,
isn't that simply a bug in the Samsung platforms? After all, a
completely generic cross-platform driver, which could touch both GPIO
and IRQ, would be written to any Linux-imposed rules, not any
Samsung-platform-imposed rules.

> We are still to implement some sanity check to disallow (or ignore) this 
> if the pin is already configured as an interrupt.

OK good, so it sounds like this is a temporary issue.
