Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3ECL7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:59:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49428 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3ECL7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB5141922EEF@NB-EX-MBX02.diasemi.com>
References: <201304191709.r3JH9w0R017814@latitude>
	<CACRpkdaSLGmmvWYG6ez1h90e=OZXq4yqtUFXKnTpUWG916LmjA@mail.gmail.com>
	<24DF37198A1E704D9811D8F72B87EB5141922EEF@NB-EX-MBX02.diasemi.com>
Date: Fri, 3 May 2013 13:59:16 +0200
Message-ID: <CACRpkdaOnOKDXrf1J9NV8AWHAob0a1ARhS_aY--wZpafnuWZgw@mail.gmail.com>
Subject: Re: [NEW DRIVER V6 5/7] drivers/gpio: DA9058 GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 6:17 PM, Opensource [Anthony Olech]
<anthony.olech.opensource@diasemi.com> wrote:
> [Me]

>> > +struct da9058_gpio {
>> > +       struct da9058 *da9058;
>> > +       struct platform_device *pdev;
>> > +       struct gpio_chip gp;
>> > +       struct mutex lock;
>> > +       int irq_0;
>> > +       int irq_1;
>>
>> Why are you keeping thes two numbers here? Use the irqdomain to contain irq
>> mappings,
>
> this module does not use the irqdomain directly

This does not compute.

> so it gets the numbers from
> the platform data, which I thought did not persist past the probe() function.
> Is the platform data permanently available? - if that is the case, I can of course
> re-get the values on demand from the platform data - please confirm or suggest
> an alternative method of extracting the irq number.

It is indeed usual practice to cache such things from the platform
data in the local state container, do not worry about that.

I am more after where the IRQs are tracked, in an irqdomain or
as some variables somewhere.

I'm OK with this now, I think...

>> > +       if (offset > 1) {
>> > +               dev_err(da9058->dev,
>> > +                       "Failed to set GPIO%d output=%d because illegal GPIO\n",
>> > +                       offset, value);
>> > +               return;
>> > +       }
>>
>> Here you have an error print, pls insert that on the get function too then.
>
> the error print was used here because there is no other way to report an error.
> On the get function a negative number can be returned, so therefore there is
> no need to report it via the error log. I can put more diagnostics back in, but
> is it really necessary to duplicate the error indication in some cases?

No not necessary, OK I get it...

>> Maybe it's more logical to have if (!offset) and handle pin
>> 0 first, then pin 1 in the else clause?
>
> why is it logical for one state to be preferred over the other?

Because 0 comes before 1 in the system of numbers?

>> Please use #define to define these magic bits.
>> Something like this:
>>
>> #include <linux/bitops.h>
>>
>> #define DA9058_GPIO0_VAL  BIT(3)
>> #define DA9058_GPIO0_INOUT  BIT(1)
>> #define DA9058_GPIO1_VAL  BIT(7)
>> #define DA9058_GPIO1_INOUT  BIT(5)
>>
>> (etc, so we see what all bits are for)
>>
>> then use these defines in the code...
>
> the meaning of the bits other than the INP/OUT bits are not independent,
> but depend on the direction. Thus each nibble contains 3 dependent bits.

(...)
>> > +       if (offset) {
>> > +               u8 debounce_bits = debounce ? 0x80 : 0x00;
>>
>> Is this really correct??
>>
>> In earlier code you use bit 7 to set the value!
>
> You are confusing input and output operations, the meanings
> of each nibble's other 3 bits is depends on the direction. That
> is why the INP and OUT configuration needs to be saved in a
> control structure.
>
>> This is partly why I ask you to use #defines for the bits:
>> less risk to do things wrong by e.g. copy/paste bugs.
>
> The hardware definition is in terms of bit patterns in each nibble,
> so introducing a dual name for 3 of the 4 bits means double the
> number of points an error can be made.

(...)
>> > +       gpio->inp_config = 0x99;
>> > +       gpio->out_config = 0x77;
>>
>> Again here you should #define the bits and | or them together instead of using
>> comments to clarify it.
>
> I think that in this particular case it will be more confusing trying to name the bits
> due to the fact that 3 out of 4 bit in each nibble depend on the 4th bit.

(...)
> I failed previously to imagine any naming scheme that would make the meaning
> of the magic bits in each nibble clearer. The best I could come up with was the
> comment you referred to.

So add #defines for all combinations, IN and OUT directions.

Also write a comment explaining that the meaning of some
bits change depending on how other bits are set.

#include <linux/bitops.h>


/* This bit in each nybble detemines if the pin is input or output */
#define DA9058_GPIO0_IN  0
#define DA9058_GPIO1_IN  0
#define DA9058_GPIO0_OUT  BIT(1)
#define DA9058_GPIO1_OUT  BIT(5)
/* This is the meaning of bits 0, 2, 3 in the input mode */
#define DA9058_GPIO0_IN_PU  BIT(0)
#define DA9058_GPIO0_IN_PU  BIT(4)
#define DA9058_GPIO0_IN_DEB  BIT(3)
#define DA9058_GPIO1_IN_DEB  BIT(7)
(what is bit 2 in input mode?)
(...)
/* This is the meaning of bits 0, 2, 3 in the output mode */
#define DA9058_GPIO0_OUT_VAL  BIT(3)
#define DA9058_GPIO0_OUT_PP_EXT  BIT(2) | BIT(0)
#define DA9058_GPIO0_OUT_PP_INT  BIT(0)
#define DA9058_GPIO0_OUT_OD  0
#define DA9058_GPIO1_OUT_VAL  BIT(7)
#define DA9058_GPIO1_OUT_PP_EXT  BIT(6) | BIT(4)
#define DA9058_GPIO1_OUT_PP_INT  BIT(4)
#define DA9058_GPIO1_OUT_OD  0
(...)

Then the init in probe() becomes readable:

gpio->inp_config = DA9058_GPIO0_IN |
     DA9058_GPIO0_IN_PU |
     DA9058_GPIO0_IN_DEB |
     DA9058_GPIO1_IN |
     DA9058_GPIO0_IN_PU |
     DA9058_GPIO0_IN_DEB;
gpio->out_config = DA9058_GPIO0_OUT |
     DA9058_GPIO0_OUT_PP_EXT |
     DA9058_GPIO1_OUT |
     DA9058_GPIO1_OUT_PP_EXT;

This is way more readable than:

gpio->inp_config = 0x99;
gpio->out_config = 0x77;

After this though, I start to wonder if it's not smarter to just
have:

struct da9058_gpio {
    (...)
    u8 gpio0_in_config:4;
    u8 gpio0_out_config:4;
    u8 gpio1_in_config:4;
    u8 gpio1_out_config:4;
};

Then only define one set of bits for a single nybble and
use some <<4 to | together the apropriate config at
runtime.

Yours,
Linus Walleij
