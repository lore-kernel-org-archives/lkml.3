Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3FYBxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:53:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50514 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FYBxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:53:30 -0400
Message-ID: <51C8F816.2010502@gmail.com>
Date: Mon, 24 Jun 2013 18:53:26 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO
 pins.
References: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com> <CACRpkdYHzBBbPNujYRGkMFGuQRzeYKs9jgfc3e3HWyxQFahvRQ@mail.gmail.com> <51C34584.8070301@gmail.com> <CACRpkdYmPuyrDYU1n+UpgW-if9-JS-vXJgLVCJ2zrx-4oKBtHw@mail.gmail.com>
In-Reply-To: <CACRpkdYmPuyrDYU1n+UpgW-if9-JS-vXJgLVCJ2zrx-4oKBtHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking at this again.

I will be away from my office until the middle of July, so I will not be 
able to generate and test a revised patch until then.

David Daney



On 06/24/2013 03:06 PM, Linus Walleij wrote:
> On Thu, Jun 20, 2013 at 8:10 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 06/17/2013 01:51 AM, Linus Walleij wrote:
>
>>> +#include <asm/octeon/octeon.h>
>>> +#include <asm/octeon/cvmx-gpio-defs.h>
>>>
>>> I cannot find this in my tree.
>>
>> Weird, I see them here:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/mips/include/asm/octeon/cvmx-gpio-defs.h
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/mips/include/asm/octeon/octeon.h
>>
>> Do you not have these?
>
> Yeah no problem, I must have misgrepped.
> Sorry for the fuzz...
>
>>> depend on OF as well right? Or does the CAVIUM_OCTEON_SOC already
>>> imply that?
>>
>> We already have 'select USE_OF', so I think adding OF here would be
>> redundant.
>
> OK.
>
>>>> +/*
>>>> + * The address offset of the GPIO configuration register for a given
>>>> + * line.
>>>> + */
>>>> +static unsigned int bit_cfg_reg(unsigned int gpio)
>>>
>>> Maybe the passed variable shall be named "offset" here, as it is named
>>> offset on all call sites, and it surely local for this instance?
>>
>> Well it is the gpio line, so perhaps it should universally be change to
>> "line" or "pin"
>
> We use "offset" to signify line enumerators in drivers/gpio/*
> well atleaste if they are local to a piece of hardware.
> (Check the GPIO siblings.)
>
>>>> +{
>>>> +       if (gpio < 16)
>>>> +               return 8 * gpio;
>>>> +       else
>>>> +               return 8 * (gpio - 16) + 0x100;
>>>
>>>
>>> Put this 0x100 in the #defines above with the name something like
>>> STRIDE.
>>
>> But it is not a 'STRIDE', it is a discontinuity compensation and used in
>> exactly one place.
>
> OK what about a comment or something, because it isn't
> exactly intuitive right?
>
>>>> +struct octeon_gpio {
>>>> +       struct gpio_chip chip;
>>>> +       u64 register_base;
>>>> +};
>>>
>>> OMG everything is 64 bit. Well has to come to this I guess.
>>
>> Not everything.  This is custom logic in an SoC with 64-bit wide internal
>> address buses, what would you suggest?
>
> Yep that's what I meant, no big deal. Just first time
> I really see it in driver bases.
>
>>> I'm not a fan of packed bitfields like this, I prefer if you just
>>> OR | and AND & the bits together in the driver.
>
> I see you disregarded this comment, and looking at the header
> files it seems the MIPS arch is a big fan if packed bitfields so
> will live with it for this arch...
>
>>>> +static int octeon_gpio_get(struct gpio_chip *chip, unsigned offset)
>>>> +{
>>>> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio,
>>>> chip);
>>>> +       u64 read_bits = cvmx_read_csr(gpio->register_base + RX_DAT);
>>>> +
>>>> +       return ((1ull << offset) & read_bits) != 0;
>>>
>>> A common idiom we use for this is:
>>>
>>> return !!(read_bits & (1ull << offset));
>>
>> I hate that idiom, but if its use is a condition of accepting the patch, I
>> will change it.
>
> Nah. If a good rational reason like "hate" is given for not using a coding
> idiom I will accept it as it stands ;-)
>
>>>> +       dev_info(&pdev->dev, "OCTEON GPIO\n");
>>>
>>>
>>> This is like shouting "REAL MADRID!" in the bootlog, be a bit more
>>> precise: "octeon GPIO driver probed\n" or something so we know what
>>> is happening.
>>
>> No, more akin to 'Real Madrid', as 'OCTEON' is the correct spelling of its
>> given name.
>>
>> I will happily add "driver probed", and grudgingly switch to lower case if
>> it is a necessary condition of patch acceptance.
>
> I don't know, does this rest of the MIPS drivers emit similar messages
> such that the bootlog will say
>
> OCTEON clocks
> OCTEON irqchip
> OCTEON I2C
> OCTEON GPIO
>
> then I guess it's convention and it can stay like this.
>
> Yours,
> Linus Walleij
>
>

