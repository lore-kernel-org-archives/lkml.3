Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3HPQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:27:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3HPQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:27:12 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Linus Walleij" <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio: New driver for LSI ZEVIO SoCs
References: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box>
 <CACRpkdbLSDiSAGiZ_PpJganrSoar+2fFPaEjbu_L1Ezx5V8DMg@mail.gmail.com>
Date: Fri, 16 Aug 2013 18:34:20 +0200
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.w1w4bifku7prd4@fabians-laptop.fritz.box>
In-Reply-To: <CACRpkdbLSDiSAGiZ_PpJganrSoar+2fFPaEjbu_L1Ezx5V8DMg@mail.gmail.com>
User-Agent: Opera Mail/12.15 (Linux)
X-Provags-ID: V02:K0:TcQ1w6mYLS+BjixsU7DdvqbeVRtaVxLhA4IRB+wYcPI
 tJW+h9hYJeLDZcFvhYh7YRkJvG/Z9yYTc/eWHQa6BFb7Uh0CkO
 t4P++JiVQTmAKsdp0hNaWwzef+olLCuoVGUAP8CguDepSFgBtu
 dG8ELOfBlE+bjmOVEV22enIfAY3XiA+sfeQNL9y7TFwOdLRSpG
 aaXPIUp3/r6g9Hy3pB5JqP0YdTedM5KdS6/x5iTxDTrecvdvUu
 NhE5fdZZPfyRzkxLkEUhottoCWaMStG0jYVH03tOhHshXHSu5f
 UKgAuQ+FNRTHaacIPBy1VcQTh6rRwLp14wIXX9hNuLGoj67qtJ
 8b+V/NYS1MSoYx5K9hKp4mUDzbuXaDXILADdmYpidpIDnVYHsh
 fwQiouiUtpJpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 4:46 PM, Linus Walleij <linus.walleij@linaro.org>  
wrote:
> On Mon, Aug 5, 2013 at 11:59 PM, Fabian Vogt <fabian@ritter-vogt.de>  
> wrote:
>
>> From: Fabian Vogt <fabian@ritter-vogt.de>
>>
>> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
>> It has been successfully tested on a TI nspire CX calculator.
>>
>> Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
>
> Hi Fabian, sorry for taking so long for getting around to review this.
No problem :)

>> +++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>
> I want an ACK from one of the DT bindings maintainers for this
> portion of the driver ideally. (It looks all right to me.)
Any ideas which mail addresses I should add to CC:?

>> +config GPIO_ZEVIO
>> +       bool "LSI ZEVIO SoC memory mapped GPIOs"
>> +       depends on ARCH_NSPIRE
>
> Can't this appear in some other SoC?
The problem is, no documents about this SoC are available at all.
Everything we know about this chip has been found out by disassembling the
nspire software (nucleus PLUS), so I have no idea, but probably not.
Also, it can't be tested during bootup, as the only platform we can test  
it on
boots from an internal read-only flash, which loads boot2,
which itself is exploitable to start linux.
The entire hardware has already been initialized before booting linux.

> It doesn't seem very arch-dependent in itself.
>
> I would rather have this depend on OF so any device-tree enabled
> SoC may use it, plus we get compile coverage by allmodconfig.
>
>> diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
> (...)
>> +/*
>> + * Memory layout:
>> + * This chip has four gpio sections, each controls 8 GPIOs.
>> + * Bit 0 in section 0 is GPIO 0, bit 2 in section 1 is GPIO 10.
>> + * Disclaimer: Reverse engineered!
>> + * For more information refer to:
>> + *
>> http://hackspire.unsads.com/wiki/index.php/Memory-mapped_I/O_ports#90000000_-_General_Purpose_I.2FO_.28GPIO.29
>
> Very ambitious. Impressive!
Not my work, but indeed, it's very impressive!
(Except for the newer ("complicated") touchpad interface which was indeed  
an I2C controller)

>> + * 0x00-0x3F: Section 0
>> + *     +0x00: Masked interrupt status (read-only)
>> + *     +0x04: R: Interrupt status W: Reset interrupt status
>> + *     +0x08: R: Interrupt mask W: Mask interrupt
>> + *     +0x0C: W: Unmask interrupt (write-only)
>> + *     +0x10: Direction: I/O=1/0
>> + *     +0x14: Output
>> + *     +0x18: Input (read-only)
>> + *     +0x20: R: Sticky interrupts W: Set sticky interrupt
>
> What is a sticky interrupt? Do you mean it is a level IRQ?
> Then it's edge triggered if zero and level triggered if "sticky"
> is set to 1, right?
It's how the GPIO controller signals the VIC.
On sticky it keeps the IRQ high until it has been handled (W to 0x4),
if not sticky, it sets the IRQ line at the same state as the GPIO pin is.
If GPIO high => IRQ high, if GPIO gets low again => IRQ low, which is not  
VERY useful..

>> +/* Functions for struct gpio_chip */
>> +static int zevio_gpio_get(struct gpio_chip *chip, unsigned pin)
>> +{
>> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
>> +
>> +       /* Only reading allowed, so no spinlock needed */
>> +       uint16_t val = readw(ZEVIO_GPIO(controller, pin, INPUT));
>
> Use just u16 please. uint16_t is some portable C type.
>
> Please replace uint16_t with u16 everywhere.
It's used VERY often and I couldn't find any coding style document which  
prefers u16..

>> +
>> +       return (val >> ZEVIO_GPIO_BIT(pin)) & 0x1;
>
> Use this construct:
> return !!(val & ZEVIO_GPIO_BIT(pin));
Ok.

>> +static void zevio_gpio_set(struct gpio_chip *chip, unsigned pin, int  
>> value)
>> +{
>> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
>> +       uint16_t val;
>> +
>> +       spin_lock(&controller->lock);
>> +       val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
>> +       if (value)
>> +               val |= 1<<ZEVIO_GPIO_BIT(pin);
>
> I usually do this:
>
> #include <linux/bitops.h>
>
> val |= BIT(ZEVIO_GPIO_BIT(pin));
Oh, it seems I have overseen that..

>> +       else
>> +               val &= ~(1<<ZEVIO_GPIO_BIT(pin));
>
> Dito, sort of...
>
>> +
>> +       writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
>> +       spin_unlock(&controller->lock);
>> +}
>> +
>> +static int zevio_gpio_direction_input(struct gpio_chip *chip, unsigned  
>> pin)
>> +{
>> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
>> +       uint16_t val;
>> +
>> +       spin_lock(&controller->lock);
>> +
>> +       val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
>> +       val |= 1<<ZEVIO_GPIO_BIT(pin);
>
> Same idea as above.
>
>> +       writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));
>> +
>> +       spin_unlock(&controller->lock);
>> +
>> +       return 0;
>> +}
>> +
>> +static int zevio_gpio_direction_output(struct gpio_chip *chip,
>> +                                      unsigned pin, int value)
>> +{
>> +       struct zevio_gpio *controller = to_zevio_gpio(chip);
>> +       uint16_t val;
>> +
>> +       spin_lock(&controller->lock);
>> +       val = readw(ZEVIO_GPIO(controller, pin, OUTPUT));
>> +       if (value)
>> +               val |= 1<<ZEVIO_GPIO_BIT(pin);
>> +       else
>> +               val &= ~(1<<ZEVIO_GPIO_BIT(pin));
>
> And here too.
>
>> +
>> +       writew(val, ZEVIO_GPIO(controller, pin, OUTPUT));
>> +       val = readw(ZEVIO_GPIO(controller, pin, DIRECTION));
>> +       val &= ~(1<<ZEVIO_GPIO_BIT(pin));
>> +       writew(val, ZEVIO_GPIO(controller, pin, DIRECTION));
>
> And here.
>
>> +
>> +       spin_unlock(&controller->lock);
>> +
>> +       return 0;
>> +}
>> +
>> +static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
>> +{
>> +       /* Not implemented due to weird lockups */
>> +       return -ENXIO;
>
> Hm. I guess this should be marked TODO: or something.
>
> So when you figure this out you also add an irqchip.
>
> The way this looks I was thinking it could use the
> drivers/gpio/gpio-generic.c driver, but maybe not?
Would be great, but it doesn't support multiple registers (4*8 GPIOs),
so I would have to register 4 of them. Then, they had to share one  
interrupt,
which would have to be implemented seperately (or not at all) and then it  
has
to be working with device tree without any extra (struct platform_)data.
I prefer two bitops (pin&7 and pin>>3), which are present anyways (for  
IRQs)
over an array of four gpio_chips.

I'll resubmit the improved version as V4 after you told me which devicetree
mail addresses I should add.

Bye,
Fabian
