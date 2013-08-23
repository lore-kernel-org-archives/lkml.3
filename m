Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3HWOJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:09:19 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41123 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3HWOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <op.w1w4bifku7prd4@fabians-laptop.fritz.box>
References: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box>
	<CACRpkdbLSDiSAGiZ_PpJganrSoar+2fFPaEjbu_L1Ezx5V8DMg@mail.gmail.com>
	<op.w1w4bifku7prd4@fabians-laptop.fritz.box>
Date: Fri, 23 Aug 2013 16:09:16 +0200
Message-ID: <CACRpkdbUoOP9DH59=MQ71tKGJ+OLFd0E7-iz7ZSM4owsTxcWWw@mail.gmail.com>
Subject: Re: [PATCH] gpio: New driver for LSI ZEVIO SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabian Vogt <fabian@ritter-vogt.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 6:34 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:
> On Fri, Aug 16, 2013 at 4:46 PM, Linus Walleij <linus.walleij@linaro.org>
> wrote:

>> I want an ACK from one of the DT bindings maintainers for this
>> portion of the driver ideally. (It looks all right to me.)
>
> Any ideas which mail addresses I should add to CC:?

No. devicetree@vger.kernel.org is the place.

But if nothing happens you might want to ask Stephen Warren.

>>> +config GPIO_ZEVIO
>>> +       bool "LSI ZEVIO SoC memory mapped GPIOs"
>>> +       depends on ARCH_NSPIRE
>>
>>
>> Can't this appear in some other SoC?
>
> The problem is, no documents about this SoC are available at all.
> Everything we know about this chip has been found out by disassembling the
> nspire software (nucleus PLUS), so I have no idea, but probably not.
> Also, it can't be tested during bootup, as the only platform we can test it
> on
> boots from an internal read-only flash, which loads boot2,
> which itself is exploitable to start linux.
> The entire hardware has already been initialized before booting linux.

The thing is that if we don't put in the dependency, we can get
some nice compile coverage on a few different compilers and
platforms.

>>> + * 0x00-0x3F: Section 0
>>> + *     +0x00: Masked interrupt status (read-only)
>>> + *     +0x04: R: Interrupt status W: Reset interrupt status
>>> + *     +0x08: R: Interrupt mask W: Mask interrupt
>>> + *     +0x0C: W: Unmask interrupt (write-only)
>>> + *     +0x10: Direction: I/O=1/0
>>> + *     +0x14: Output
>>> + *     +0x18: Input (read-only)
>>> + *     +0x20: R: Sticky interrupts W: Set sticky interrupt
>>
>>
>> What is a sticky interrupt? Do you mean it is a level IRQ?
>> Then it's edge triggered if zero and level triggered if "sticky"
>> is set to 1, right?
>
> It's how the GPIO controller signals the VIC.
> On sticky it keeps the IRQ high until it has been handled (W to 0x4),

This is what is called a level interrupt.

So please update the terminology to match the common
one.

> if not sticky, it sets the IRQ line at the same state as the GPIO pin is.
> If GPIO high => IRQ high, if GPIO gets low again => IRQ low, which is not
> VERY useful..

Hm doesn't seem like an interrupt at all, rather some
test operation to test the IRQ line. Well whatever...

>> Use just u16 please. uint16_t is some portable C type.
>>
>> Please replace uint16_t with u16 everywhere.
>
> It's used VERY often and I couldn't find any coding style document which
> prefers u16..

There is no consensus around this.
It is up to the subsystem maintainer to decide this I think.


>>> +static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
>>> +{
>>> +       /* Not implemented due to weird lockups */
>>> +       return -ENXIO;
>>
>>
>> Hm. I guess this should be marked TODO: or something.
>>
>> So when you figure this out you also add an irqchip.
>>
>> The way this looks I was thinking it could use the
>> drivers/gpio/gpio-generic.c driver, but maybe not?
>
> Would be great, but it doesn't support multiple registers (4*8 GPIOs),
> so I would have to register 4 of them. Then, they had to share one
> interrupt,
> which would have to be implemented seperately (or not at all) and then it
> has
> to be working with device tree without any extra (struct platform_)data.
> I prefer two bitops (pin&7 and pin>>3), which are present anyways (for IRQs)
> over an array of four gpio_chips.

OK I buy this, but you know you can reuse only part of the
generic MMIO driver, and do not have to use all of it?

> I'll resubmit the improved version as V4 after you told me which devicetree
> mail addresses I should add.

OK thanks.

Yours,
Linus Walleij
