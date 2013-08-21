Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3HUXKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:10:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34015 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3HUXKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:10:33 -0400
Message-ID: <521548E3.6010703@wwwdotorg.org>
Date: Wed, 21 Aug 2013 17:10:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>, poeschel@lemonage.de,
        grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        ian.campbell@citrix.com, galak@codeaurora.org, pawel.moll@arm.com,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <1507189.CRWvzVJqTV@flatron>
In-Reply-To: <1507189.CRWvzVJqTV@flatron>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 03:49 PM, Tomasz Figa wrote:
> Hi Lars, Linus,
> 
> On Wednesday 21 of August 2013 15:38:54 Lars Poeschel wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Currently the kernel is ambigously treating GPIOs and interrupts
>> from a GPIO controller: GPIOs and interrupts are treated as
>> orthogonal. This unfortunately makes it unclear how to actually
>> retrieve and request a GPIO line or interrupt from a GPIO
>> controller in the device tree probe path.
>>
>> In the non-DT probe path it is clear that the GPIO number has to
>> be passed to the consuming device, and if it is to be used as
>> an interrupt, the consumer shall performa a gpio_to_irq() mapping
>> and request the resulting IRQ number.
>>
>> In the DT boot path consumers may have been given one or more
>> interrupts from the interrupt-controller side of the GPIO chip
>> in an abstract way, such that the driver is not aware of the
>> fact that a GPIO chip is backing this interrupt, and the GPIO
>> side of the same line is never requested with gpio_request().
>> A typical case for this is ethernet chips which just take some
>> interrupt line which may be a "hard" interrupt line (such as an
>> external interrupt line from an SoC) or a cascaded interrupt
>> connected to a GPIO line.
>>
>> This has the following undesired effects:
>>
>> - The GPIOlib subsystem is not aware that the line is in use
>>   and willingly lets some other consumer perform gpio_request()
>>   on it, leading to a complex resource conflict if it occurs.
>>
>> - The GPIO debugfs file claims this GPIO line is "free".
>>
>> - The line direction of the interrupt GPIO line is not
>>   explicitly set as input, even though it is obvious that such
>>   a line need to be set up in this way, often making the system
>>   depend on boot-on defaults for this kind of settings.

That last point should simply be taken care of by the IRQ driver in the
relevant callbacks.

>> To solve this dilemma, perform an interrupt consistency check
>> when adding a GPIO chip: if the chip is both gpio-controller and
>> interrupt-controller, walk all children of the device tree,

It seems a little odd to solve this only for DT. What about the non-DT case?

>> check if these in turn reference the interrupt-controller, and
>> if they do, loop over the interrupts used by that child and
>> perform gpio_request() and gpio_direction_input() on these,
>> making them unreachable from the GPIO side.

What about bindings that require a GPIO to be specified, yet don't allow
an IRQ to be specified, and the driver internally does perform
gpio_to_irq() on it? I don't think one can detect that case.

Isn't it better to have the IRQ chip's .request() operation convert the
IRQ to a GPIO if relevant (which it can do since it has specific
knowledge of the HW) and take ownership of the GPIO at that level?

That would cover both the exceptions I pointed out above.

I vaguely recall seeing patches along those lines before, but there must
have been some other problem pointed out...

>> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c

>> +static void of_gpio_scan_irq_lines(const struct device_node *const

>> +		for (i = 0; i < intlen; i += intsize) {
>> +			/*
>> +			 * Find out the local IRQ number. This corresponds to
>> +			 * the GPIO line offset for a GPIO chip.
> 
> I'm still not convinced that this assumption is correct. This code will
> behave erraticaly in cases where it is not true, requesting innocent GPIO
> pins.
> 
>> +			 */
>> +			if (irq_domain && irq_domain->ops->xlate)
>> +				irq_domain->ops->xlate(irq_domain, gcn,
>> +						       intspec + i, intsize,
>> +						       &hwirq, &type);
>> +			else
>> +				hwirq = intspec[0];
> 
> Is it a correct fallback when irq_domain is NULL?

Indeed this fallback is dangerous. The /only/ way to parse an IRQ
specifier is with binding-specific knowledge, which is obtained by
calling irq_domain->ops->xlate(). If the IRQ domain can't be found, this
operation simply has to be deferred; we can't just guess and hope.

> 
>> +
>> +			hwirq = be32_to_cpu(hwirq);
> 
> Is this conversion correct? I don't think hwirq could be big endian here
> (unless running on a big endian CPU).

I think that should be inside the else branch above.
